function [data_nu, data_fft, data_fft_full_inan_remove, debug] = FixGridRemove_v4(data, opts)
%FIXGRIDREMOVE_V4  FFT notch filtering for grid-like background removal.
%
% Peak seeding modes:
%   opts.peakMethod = 'auto'   : automatic peak seeding
%   opts.peakMethod = 'manual' : user clicks two peaks
%   opts.peakMethod = 'direct' : user provides initial peak guesses
%
% For direct mode:
%   opts.peakGuess = [x1 y1; x2 y2]
%   where x is FFT column offset from center, y is FFT row offset from center.
%
% All modes are refined by local optimization around the initial guess.
%
% Outputs:
%   data_nu                  : grid-removed real-space data
%   data_fft                 : log1p magnitude FFT before removal
%   data_fft_full_inan_remove : log1p magnitude FFT after removal
%   debug                    : struct with intermediates

    if nargin < 2 || isempty(opts)
        opts = struct();
    end

    debugMode   = getOpt(opts, 'debug', false);
    figBase     = getOpt(opts, 'figBase', 510);
    peakMethod  = lower(string(getOpt(opts, 'peakMethod', 'manual')));
    peakGuess   = getOpt(opts, 'peakGuess', []);
    maxOrder    = getOpt(opts, 'maxOrder', 4);
    centerFrac  = getOpt(opts, 'centerFrac', 0.03);
    sigmaFactor = getOpt(opts, 'sigmaFactor', 0.08);
    notchDepth  = getOpt(opts, 'notchDepth', 0.98);
    minMask     = getOpt(opts, 'minMask', 0.02);
    useWindow   = getOpt(opts, 'useWindow', true);
    searchRad   = getOpt(opts, 'searchRad', 12);
    fitRad      = getOpt(opts, 'fitRad', 2);

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
        error('FixGridRemove_v4:SizeMismatch', ...
            'data.value must have size [numel(data.x), numel(data.y)] or its transpose.');
    end

    data_nu = data;
    data_fft = data;
    data_fft_full_inan_remove = data;

    debug = struct();
    debug.options = opts;
    debug.inputSize = [nx, ny];
    debug.peakMethod = peakMethod;

    % ------------------------------------------------------------
    % Fill missing values in real space
    % ------------------------------------------------------------
    Vfilled = fillMissing2D(V, x, y);
    debug.Vfilled = Vfilled;

    % ------------------------------------------------------------
    % Detection FFT: windowed only for peak finding
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
    % Seed two first-order peaks, then refine them locally
    % ------------------------------------------------------------
    [initialPeaks, selectedPeaks] = getPeakSeeds(A, peakMethod, peakGuess, figBase, searchRad, fitRad, debugMode);
    debug.initialPeaks = initialPeaks;
    debug.selectedPeaks = selectedPeaks;

    if isempty(selectedPeaks) || size(selectedPeaks, 1) ~= 2 || size(selectedPeaks, 2) ~= 2
        data_nu.value = real(Vfilled);
        data_fft_full_inan_remove.value = log1p(abs(fftshift(fft2(Vfilled))));
        debug.status = 'failed_to_get_two_peaks';
        return;
    end

    % ------------------------------------------------------------
    % Estimate reciprocal lattice basis from the two refined peaks
    % ------------------------------------------------------------
    B = [selectedPeaks(1,:).', selectedPeaks(2,:).'];   % 2 x 2, columns are [x;y]
    B = [B(2,:); B(1,:)]; % convert to [row; col] = [y; x] style for internal use
    debug.B = B;

    if rcond(B) < 1e-10 || abs(det(B)) < 1e-8
        data_nu.value = real(Vfilled);
        data_fft_full_inan_remove.value = log1p(abs(fftshift(fft2(Vfilled))));
        debug.status = 'degenerate_basis';
        return;
    end

    % ------------------------------------------------------------
    % Build smooth notch mask in shifted FFT coordinates
    % ------------------------------------------------------------
    [U, Vc] = ndgrid((1:nx) - (nx + 1) / 2, (1:ny) - (ny + 1) / 2);

    bNorm = max(norm(B(:,1)), norm(B(:,2)));
    sigmaPix = max(1.25, sigmaFactor * bNorm);

    orders = -maxOrder:maxOrder;
    [aa, bb] = ndgrid(orders, orders);
    orderList = [aa(:), bb(:)];
    orderList(all(orderList == 0, 2), :) = [];

    targetPeaks = B * orderList.';  % 2 x N, in [row; col]
    debug.orderList = orderList;
    debug.targetPeaks = targetPeaks;

    atten = zeros(nx, ny);

    for k = 1:size(targetPeaks, 2)
        pk = targetPeaks(:, k);

        % pk = [rowOffset; colOffset]
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

    % Apply mask to original FFT
    F0 = fftshift(fft2(Vfilled));
    Ffilt = F0 .* mask;

    data_fft_full_inan_remove.value = log1p(abs(Ffilt));
    debug.F0 = F0;
    debug.Ffilt = Ffilt;

    % ------------------------------------------------------------
    % Back to real space
    % ------------------------------------------------------------
    Vclean = real(ifft2(ifftshift(Ffilt)));
    data_nu.value = Vclean;
    debug.status = 'ok';

    % ------------------------------------------------------------
    % Debug figures
    % ------------------------------------------------------------
    if debugMode
        showDebugFigures(figBase, Vfilled, A, mask, data_fft_full_inan_remove.value, ...
            initialPeaks, selectedPeaks, targetPeaks, B, x, y, Vclean, peakMethod);
    end
end

% ======================================================================
% Peak seeding and refinement
% ======================================================================

function [initialPeaks, refinedPeaks] = getPeakSeeds(A, peakMethod, peakGuess, figBase, searchRad, fitRad, debugMode)
% Returns peaks in display coordinates:
%   [x, y] = [FFT column offset, FFT row offset]
%
% refinedPeaks is 2 x 2:
%   [x1 y1;
%    x2 y2]

    [nx, ny] = size(A);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

    switch peakMethod
        case "auto"
            guess = autoPeakGuess(A);

        case "manual"
            guess = manualPeakGuess(A, figBase);

        case "direct"
            if isempty(peakGuess) || ~isnumeric(peakGuess) || size(peakGuess,1) < 2 || size(peakGuess,2) < 2
                error('FixGridRemove_v4:BadPeakGuess', ...
                    'For peakMethod="direct", provide opts.peakGuess = [x1 y1; x2 y2].');
            end
            guess = double(peakGuess(1:2,1:2));

        otherwise
            error('FixGridRemove_v4:BadPeakMethod', ...
                'opts.peakMethod must be "auto", "manual", or "direct".');
    end

    initialPeaks = guess;

    p1 = refineFFTpeak(A, guess(1,1), guess(1,2), cx, cy, searchRad, fitRad);
    p2 = refineFFTpeak(A, guess(2,1), guess(2,2), cx, cy, searchRad, fitRad);

    refinedPeaks = [p1(:).'; p2(:).'];

    if debugMode
        figure(figBase); hold on;
        plot(guess(:,1), guess(:,2), 'wo', 'MarkerSize', 8, 'LineWidth', 1.5);
        plot(refinedPeaks(:,1), refinedPeaks(:,2), 'r+', 'MarkerSize', 12, 'LineWidth', 1.5);
        quiver(0, 0, refinedPeaks(1,1), refinedPeaks(1,2), 0, 'r', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
        quiver(0, 0, refinedPeaks(2,1), refinedPeaks(2,2), 0, 'g', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
        drawnow;
    end
end

function guess = autoPeakGuess(A)
% Automatic guess of two strong, non-collinear first-order peaks.

    [nx, ny] = size(A);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

    [U, Vc] = ndgrid((1:nx) - cx, (1:ny) - cy);

    rCenter = max(4, round(0.03 * min(nx, ny)));
    centerMask = hypot(U, Vc) <= rCenter;

    peakMask = localMax2D(A);
    peakMask(centerMask) = false;

    candIdx = find(peakMask);
    if isempty(candIdx)
        error('FixGridRemove_v4:AutoPeakFail', 'Automatic peak detection found no candidates.');
    end

    candVals = A(candIdx);
    [candVals, ord] = sort(candVals, 'descend');
    candIdx = candIdx(ord);

    maxCand = min(100, numel(candIdx));
    candIdx = candIdx(1:maxCand);
    candVals = candVals(1:maxCand);

    flatA = A(isfinite(A));
    medA = median(flatA);
    madA = median(abs(flatA - medA));
    if madA <= 0 || ~isfinite(madA)
        madA = std(flatA);
    end
    if ~isfinite(madA) || madA <= 0
        madA = 1;
    end

    thr = medA + 4 * madA;
    keep = candVals >= thr;
    if nnz(keep) >= 2
        candIdx = candIdx(keep);
        candVals = candVals(keep);
    end

    if numel(candIdx) < 2
        error('FixGridRemove_v4:AutoPeakFail', 'Not enough strong peaks for automatic seeding.');
    end

    [ri, ci] = ind2sub(size(A), candIdx);
    pos = [ci(:).' - cy; ri(:).' - cx];  % [x; y], display coordinates
    r = hypot(pos(1,:), pos(2,:));
    keep = r >= rCenter;
    pos = pos(:, keep);
    candVals = candVals(keep);

    if size(pos, 2) < 2
        error('FixGridRemove_v4:AutoPeakFail', 'Automatic seeding collapsed after center suppression.');
    end

    % Pick a strong, non-collinear pair
    K = min(30, size(pos, 2));
    minSinAngle = sind(15);
    bestScore = -inf;
    iBest = NaN;
    jBest = NaN;

    for i = 1:K-1
        p1 = pos(:, i);
        n1 = norm(p1);
        if n1 < rCenter
            continue;
        end
        for j = i+1:K
            p2 = pos(:, j);
            n2 = norm(p2);
            if n2 < rCenter
                continue;
            end

            sinAng = abs(det([p1, p2])) / (n1 * n2 + eps);
            if sinAng < minSinAngle
                continue;
            end

            score = sqrt(candVals(i) * candVals(j)) * sinAng / (1 + 0.15 * (n1 + n2));
            if score > bestScore
                bestScore = score;
                iBest = i;
                jBest = j;
            end
        end
    end

    if isnan(iBest) || isnan(jBest)
        error('FixGridRemove_v4:AutoPeakFail', 'Could not find a reliable non-collinear peak pair.');
    end

    guess = [pos(1, iBest), pos(2, iBest); pos(1, jBest), pos(2, jBest)];
end

function guess = manualPeakGuess(A, figBase)
% User clicks two peaks in centered FFT coordinates.

    [nx, ny] = size(A);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

    figure(figBase); clf;
    imagesc((1:ny) - cy, (1:nx) - cx, A);
    axis image;
    set(gca, 'YDir', 'normal');
    xlabel('FFT col offset');
    ylabel('FFT row offset');
    title('Click the 2 first-order peaks');
    colorbar;
    drawnow;

    [xClick, yClick] = getpts;
    if numel(xClick) < 2
        error('FixGridRemove_v4:ManualPeakFail', 'Need two clicks for manual seeding.');
    end

    guess = [xClick(1), yClick(1); xClick(2), yClick(2)];
end

function p = refineFFTpeak(A, xClick, yClick, cx, cy, searchRad, fitRad)
% Localize one peak by:
%   1) searching for the strongest local max near the initial guess
%   2) quadratic subpixel refinement around that local max

    [nx, ny] = size(A);

    % Convert centered display coords -> matrix indices
    r0 = yClick + cx;
    c0 = xClick + cy;

    r1 = max(1, round(r0 - searchRad));
    r2 = min(nx, round(r0 + searchRad));
    c1 = max(1, round(c0 - searchRad));
    c2 = min(ny, round(c0 + searchRad));

    patch = A(r1:r2, c1:c2);

    [~, imax] = max(patch(:));
    [rp, cp] = ind2sub(size(patch), imax);
    rMax = r1 + rp - 1;
    cMax = c1 + cp - 1;

    % Quadratic refinement on a small window around the discrete maximum
    rr1 = max(1, rMax - fitRad);
    rr2 = min(nx, rMax + fitRad);
    cc1 = max(1, cMax - fitRad);
    cc2 = min(ny, cMax + fitRad);

    local = A(rr1:rr2, cc1:cc2);

    [R, C] = ndgrid(rr1:rr2, cc1:cc2);
    x = C(:) - cMax;
    y = R(:) - rMax;
    z = local(:);

    % Fit z = ax^2 + by^2 + cxy + dx + ey + f
    G = [x.^2, y.^2, x.*y, x, y, ones(size(x))];
    coef = G \ z;

    a = coef(1);
    b = coef(2);
    c = coef(3);
    d = coef(4);
    e = coef(5);

    H = [2*a, c; c, 2*b];
    g = [d; e];

    useQuad = all(isfinite(coef)) && rcond(H) > 1e-10;

    if useQuad
        xStar = -H \ g;
        if all(isfinite(xStar)) && abs(xStar(1)) <= 1.5 && abs(xStar(2)) <= 1.5
            cRef = cMax + xStar(1);
            rRef = rMax + xStar(2);
            p = [cRef - cy; rRef - cx];
            return;
        end
    end

    % Fallback: weighted centroid
    patch = local - median(local(:));
    patch(patch < 0) = 0;

    if nnz(patch) == 0
        p = [cMax - cy; rMax - cx];
        return;
    end

    w = patch.^2;
    rRef = sum(R(:) .* w(:)) / sum(w(:));
    cRef = sum(C(:) .* w(:)) / sum(w(:));

    p = [cRef - cy; rRef - cx];
end

% ======================================================================
% FFT / image helpers
% ======================================================================

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

function showDebugFigures(figBase, Vfilled, A, mask, Afinal, initialPeaks, refinedPeaks, targetPeaks, B, x, y, Vclean, peakMethod)
    nx = size(Vfilled, 1);
    ny = size(Vfilled, 2);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

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
    title(['log1p |FFT| before removal (', char(peakMethod), ')']);
    xlabel('FFT col offset'); ylabel('FFT row offset');
    colorbar;
    hold on;
    if ~isempty(initialPeaks)
        plot(initialPeaks(:,1), initialPeaks(:,2), 'wo', 'MarkerSize', 8, 'LineWidth', 1.5);
    end
    if ~isempty(refinedPeaks)
        plot(refinedPeaks(:,1), refinedPeaks(:,2), 'r+', 'MarkerSize', 12, 'LineWidth', 1.5);
        quiver(0, 0, refinedPeaks(1,1), refinedPeaks(1,2), 0, 'r', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
        quiver(0, 0, refinedPeaks(2,1), refinedPeaks(2,2), 0, 'g', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
    end

    nexttile;
    imagesc((1:ny)-cy, (1:nx)-cx, mask);
    axis image; set(gca, 'YDir', 'normal');
    title('Fourier mask');
    xlabel('FFT col offset'); ylabel('FFT row offset');
    colorbar;

    nexttile;
    imagesc((1:ny)-cy, (1:nx)-cx, Afinal);
    axis image; set(gca, 'YDir', 'normal');
    title('log1p |FFT| after removal');
    xlabel('FFT col offset'); ylabel('FFT row offset');
    colorbar;
    hold on;
    if ~isempty(targetPeaks)
        plot(targetPeaks(2,:), targetPeaks(1,:), 'c.', 'MarkerSize', 6);
    end

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

function val = getOpt(opts, name, defaultVal)
    if isstruct(opts) && isfield(opts, name) && ~isempty(opts.(name))
        val = opts.(name);
    else
        val = defaultVal;
    end
end