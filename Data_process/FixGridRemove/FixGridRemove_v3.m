function [data_nu, data_fft, data_fft_full_inan_remove, debug] = FixGridRemove_v3(data, opts)
%FIXGRIDREMOVE_V3  FFT notch filtering for grid-like background removal.
%
% Usage:
%   [data_nu, data_fft, data_fft_full_inan_remove, debug] = ...
%       FixGridRemove_v3(data, struct('debug', true));
%
% Inputs
%   data.x      : x coordinate vector
%   data.y      : y coordinate vector
%   data.value  : 2D matrix, expected size [numel(data.x), numel(data.y)]
%
% Options (optional struct)
%   opts.debug        : true/false, show diagnostic figures (default false)
%   opts.figBase      : base figure number (default 510)
%   opts.maxOrder     : maximum reciprocal-lattice order to notch (default 4)
%   opts.centerFrac   : center exclusion fraction of min(size) (default 0.03)
%   opts.sigmaFactor  : notch width factor relative to |B| (default 0.08)
%   opts.notchDepth   : peak attenuation depth, 0..1 (default 0.98)
%   opts.minMask      : lower bound for mask transmission (default 0.02)
%   opts.useWindow    : use apodization for peak detection only (default true)
%
% Outputs
%   data_nu                  : grid-removed real-space data
%   data_fft                 : log1p magnitude FFT of windowed detection image
%   data_fft_full_inan_remove : log1p magnitude FFT after removal
%   debug                    : struct with intermediates if requested

    if nargin < 2 || isempty(opts)
        opts = struct();
    end

    debugMode   = getOpt(opts, 'debug', false);
    figBase     = getOpt(opts, 'figBase', 510);
    maxOrder    = getOpt(opts, 'maxOrder', 4);
    centerFrac  = getOpt(opts, 'centerFrac', 0.03);
    sigmaFactor = getOpt(opts, 'sigmaFactor', 0.08);
    notchDepth  = getOpt(opts, 'notchDepth', 0.98);
    minMask     = getOpt(opts, 'minMask', 0.02);
    useWindow   = getOpt(opts, 'useWindow', true);

    if (~isfield(data, 'value') || ~isfield(data, 'x') || ~isfield(data, 'y')) && ...
            (~isprop(data, 'value') || ~isprop(data, 'x') || ~isprop(data, 'y'))
        error('FixGridRemove:InvalidInput', 'Input must contain fields x, y, and value.');
    end

    x = data.x(:);
    y = data.y(:);
    V = double(data.value);

    nx = numel(x);
    ny = numel(y);

    if isequal(size(V), [nx, ny])
        % ok
    elseif isequal(size(V), [ny, nx])
        V = V.';
    else
        error('FixGridRemove_v3:SizeMismatch', ...
            'data.value must have size [numel(data.x), numel(data.y)] or its transpose.');
    end

    data_nu = data;
    data_fft = data;
    data_fft_full_inan_remove = data;

    debug = struct();
    debug.options = opts;
    debug.inputSize = [nx, ny];

    % ------------------------------------------------------------
    % Fill missing values in real space
    % ------------------------------------------------------------
    Vfilled = fillMissing2D(V, x, y);
    debug.Vfilled = Vfilled;

    % ------------------------------------------------------------
    % Detection FFT: use a window only for peak finding
    % ------------------------------------------------------------
    if useWindow
        wx = cosineWindow(nx);
        wy = cosineWindow(ny);
        W = wx * wy.';
        Vdet = Vfilled .* W;
    else
        Vdet = Vfilled;
    end

    Fdet = fftshift(fft2(Vdet));
    A = log1p(abs(Fdet));

    data_fft.value = A;
    debug.Fdet = Fdet;
    debug.A = A;

    % ------------------------------------------------------------
    % Estimate reciprocal lattice basis from the FFT magnitude
    % ------------------------------------------------------------
    model = estimateLatticeModel_clickRefine(A, centerFrac, maxOrder);
    debug.model = model;

    if isempty(model) || ~isfield(model, 'B') || any(~isfinite(model.B(:)))
        % No reliable lattice detected: return input unchanged
        data_nu.value = real(Vfilled);
        data_fft_full_inan_remove.value = log1p(abs(fftshift(fft2(Vfilled))));
        debug.status = 'no_lattice_found';
        return;
    end

    B = model.B; % 2x2, FFT-index basis vectors in [row; col] coordinates
    debug.B = B;

    % ------------------------------------------------------------
    % Build smooth notch mask in shifted FFT coordinates
    % ------------------------------------------------------------
    [U, Vc] = ndgrid((1:nx) - (nx + 1) / 2, (1:ny) - (ny + 1) / 2);

    bNorm = max(norm(B(:,1)), norm(B(:,2)));
    sigmaPix = max(1.25, sigmaFactor * bNorm);

    % Symmetric order list around the origin, excluding (0,0)
    orders = -maxOrder:maxOrder;
    [aa, bb] = ndgrid(orders, orders);
    orderList = [aa(:), bb(:)];
    orderList(all(orderList == 0, 2), :) = [];

    targetPeaks = B * orderList.';   % 2 x N
    debug.targetPeaks = targetPeaks;
    debug.orderList = orderList;

    atten = zeros(nx, ny);
    selectedPeaks = model.peaks;
    debug.selectedPeaks = selectedPeaks;

    for k = 1:size(targetPeaks, 2)
        pk = targetPeaks(:, k);

        if hypot(pk(1), pk(2)) < 0.5
            continue;
        end

        if abs(pk(1)) > nx/2 + 2 || abs(pk(2)) > ny/2 + 2
            continue;
        end

        d2 = (U - pk(1)).^2 + (Vc - pk(2)).^2;
        notch = notchDepth * exp(-d2 / (2 * sigmaPix^2));
        atten = max(atten, notch);
    end

    mask = max(minMask, 1 - atten);
    debug.mask = mask;

    % Apply the same real-valued symmetric mask to the original FFT
    F0 = fftshift(fft2(Vfilled));
    Ffilt = F0 .* mask;

    data_fft_full_inan_remove.value = log1p(abs(Ffilt));

    debug.F0 = F0;
    debug.Ffilt = Ffilt;
    debug.status = 'ok';

    % ------------------------------------------------------------
    % Inverse FFT
    % ------------------------------------------------------------
    Vclean = real(ifft2(ifftshift(Ffilt)));
    data_nu.value = Vclean;

    % ------------------------------------------------------------
    % Debug figures
    % ------------------------------------------------------------
    if debugMode
        showDebugFigures(figBase, Vfilled, A, mask, data_fft_full_inan_remove.value, ...
            selectedPeaks, targetPeaks, B, model, x, y, Vclean);
    end
end

% ======================================================================
% Helper functions
% ======================================================================

function val = getOpt(opts, name, defaultVal)
    if isstruct(opts) && isfield(opts, name) && ~isempty(opts.(name))
        val = opts.(name);
    else
        val = defaultVal;
    end
end

function Vout = fillMissing2D(Vin, x, y)
    Vout = Vin;
    finiteMask = isfinite(Vin);

    if all(finiteMask(:))
        return;
    end

    if nnz(finiteMask) < 4
        Vout(~finiteMask) = 0;
        return;
    end

    [Xg, Yg] = ndgrid(x, y);
    F = scatteredInterpolant(Xg(finiteMask), Yg(finiteMask), Vin(finiteMask), ...
        'linear', 'nearest');

    Vout = F(Xg, Yg);
    Vout(~isfinite(Vout)) = 0;
end

function w = cosineWindow(n)
    if n <= 1
        w = ones(n, 1);
        return;
    end
    t = (0:n-1).' / (n-1);
    w = 0.5 - 0.5 * cos(2*pi*t);
end


function model = estimateLatticeModel_clickRefine(A, opts, figBase)
% Manual initial guess + local refinement for FFT peak selection.
%
% A        : log1p magnitude FFT, centered with fftshift
% opts     : struct with optional fields
%   .debug      (default true)
%   .searchRad  (default 12)   local search radius around click
%   .fitRad     (default 2)    centroid refinement radius around local max
%
% model.B  : 2x2 basis matrix, columns are [row; col] peak offsets

    if nargin < 2 || isempty(opts)
        opts = struct();
    end
    if nargin < 3
        figBase = 510;
    end

    debugMode = getOpt(opts, 'debug', true);
    searchRad = getOpt(opts, 'searchRad', 12);
    fitRad    = getOpt(opts, 'fitRad', 2);

    [nx, ny] = size(A);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

    model = [];

    figure(figBase); clf;
    imagesc((1:ny) - cy, (1:nx) - cx, A);
    axis image;
    set(gca, 'YDir', 'normal');
    xlabel('FFT col offset');
    ylabel('FFT row offset');
    title('Click the 2 first-order peaks');
    colorbar;
    hold on;

    if debugMode
        drawnow;
    end

    [xClick, yClick] = getpts;
    if numel(xClick) < 2
        warning('FixGridRemove:NotEnoughClicks', 'Need two peak clicks.');
        return;
    end

    % Refine both clicks.
    p1 = refineFFTpeak(A, xClick(1), yClick(1), cx, cy, searchRad, fitRad);
    p2 = refineFFTpeak(A, xClick(2), yClick(2), cx, cy, searchRad, fitRad);

    % Store as [row; col] offsets from the FFT center.
    B = [p1(:), p2(:)];

    % Optional: draw clicked and refined positions.
    plot(xClick(1:2), yClick(1:2), 'wo', 'MarkerSize', 8, 'LineWidth', 1.5);
    plot(p1(2), p1(1), 'r+', 'MarkerSize', 12, 'LineWidth', 1.5);
    plot(p2(2), p2(1), 'r+', 'MarkerSize', 12, 'LineWidth', 1.5);
    quiver(0, 0, B(2,1), B(1,1), 0, 'r', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
    quiver(0, 0, B(2,2), B(1,2), 0, 'g', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);

    model.B = B;
    model.peaks = [p1(:), p2(:)];
end

function p = refineFFTpeak(A, xClick, yClick, cx, cy, searchRad, fitRad)
% Refine one clicked FFT peak.
% Input click coordinates are in the plotted centered coordinate system:
%   xClick = horizontal axis = FFT column offset
%   yClick = vertical axis   = FFT row offset

    [nx, ny] = size(A);

    % Convert centered plot coordinates to matrix indices.
    r0 = yClick + cx;
    c0 = xClick + cy;

    % Search window around the click.
    r1 = max(1, round(r0 - searchRad));
    r2 = min(nx, round(r0 + searchRad));
    c1 = max(1, round(c0 - searchRad));
    c2 = min(ny, round(c0 + searchRad));

    patch = A(r1:r2, c1:c2);

    % First snap to the strongest local maximum in the search window.
    [~, imax] = max(patch(:));
    [rp, cp] = ind2sub(size(patch), imax);
    rMax = r1 + rp - 1;
    cMax = c1 + cp - 1;

    % Second refinement: weighted centroid in a tighter window.
    r1 = max(1, rMax - fitRad);
    r2 = min(nx, rMax + fitRad);
    c1 = max(1, cMax - fitRad);
    c2 = min(ny, cMax + fitRad);

    patch = A(r1:r2, c1:c2);

    % Make weights positive and suppress flat background.
    patch = patch - median(patch(:));
    patch(patch < 0) = 0;

    if nnz(patch) == 0
        p = [rMax - cx; cMax - cy];
        return;
    end

    [R, C] = ndgrid(r1:r2, c1:c2);
    w = patch.^2;

    rRef = sum(R(:) .* w(:)) / sum(w(:));
    cRef = sum(C(:) .* w(:)) / sum(w(:));

    p = [rRef - cx; cRef - cy];
end

function m = localMax2D(A)
    [nx, ny] = size(A);
    P = -inf(nx + 2, ny + 2);
    P(2:nx+1, 2:ny+1) = A;

    m = true(nx, ny);
    for dx = -1:1
        for dy = -1:1
            if dx == 0 && dy == 0
                continue;
            end
            m = m & (A > P(2+dx:nx+1+dx, 2+dy:ny+1+dy));
        end
    end
end

function showDebugFigures(figBase, Vfilled, A, mask, Afinal, selectedPeaks, targetPeaks, B, model, x, y, Vclean)
    nx = size(Vfilled, 1);
    ny = size(Vfilled, 2);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

    % Figure 1: input and detected FFT peaks
    figure(figBase); clf;
    tiledlayout(2,2, 'Padding', 'compact', 'TileSpacing', 'compact');

    nexttile;
    imagesc(y, x, Vfilled);
    axis image; set(gca, 'YDir', 'normal');
    title('Filled real-space input');
    xlabel('y'); ylabel('x');
    colorbar;

    nexttile;
    imagesc((1:ny)-cy, (1:nx)-cx, A);
    axis image; set(gca, 'YDir', 'normal');
    title('log1p |FFT| before removal');
    xlabel('FFT col index'); ylabel('FFT row index');
    colorbar;
    hold on;

    if ~isempty(selectedPeaks)
        plot(selectedPeaks(2,:), selectedPeaks(1,:), 'r.', 'MarkerSize', 10);

        % Show the fitted basis vectors
        quiver(0, 0, B(2,1), B(1,1), 0, 'r', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
        quiver(0, 0, B(2,2), B(1,2), 0, 'g', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
    end

    nexttile;
    imagesc((1:ny)-cy, (1:nx)-cx, mask);
    axis image; set(gca, 'YDir', 'normal');
    title('Fourier mask');
    xlabel('FFT col index'); ylabel('FFT row index');
    colorbar;

    nexttile;
    imagesc((1:ny)-cy, (1:nx)-cx, Afinal);
    axis image; set(gca, 'YDir', 'normal');
    title('log1p |FFT| after removal');
    xlabel('FFT col index'); ylabel('FFT row index');
    colorbar;
    hold on;
    if ~isempty(targetPeaks)
        plot(targetPeaks(2,:), targetPeaks(1,:), 'c.', 'MarkerSize', 6);
    end

    % Figure 2: real-space before/after
    figure(figBase + 1); clf;
    tiledlayout(1,3, 'Padding', 'compact', 'TileSpacing', 'compact');

    nexttile;
    imagesc(y, x, Vfilled);
    axis image; set(gca, 'YDir', 'normal');
    title('Input');
    xlabel('y'); ylabel('x');
    colorbar;

    nexttile;
    imagesc(y, x, Vclean);
    axis image; set(gca, 'YDir', 'normal');
    title('Output');
    xlabel('y'); ylabel('x');
    colorbar;

    nexttile;
    imagesc(y, x, Vfilled - Vclean);
    axis image; set(gca, 'YDir', 'normal');
    title('Difference');
    xlabel('y'); ylabel('x');
    colorbar;

    drawnow;
end
