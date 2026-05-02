function [data_nu, data_fft, data_fft_full_inan_remove, debug] = FixGridRemove3D_v2(data, direction, opts)
%FIXGRIDREMOVE3D_V2 Remove 2D grid-like background from a 3D stack slice-by-slice.
%
% Usage:
%   [data_nu, data_fft, data_fft_full_inan_remove, debug] = ...
%       FixGridRemove3D_v2(data, 'z', opts);
%
% Inputs
%   data.x, data.y, data.z : coordinate vectors
%   data.value             : 3D array
%   direction              : 'x', 'y', or 'z'
%                             - 'z': each slice is x-y, stack along z
%                             - 'x': each slice is y-z, stack along x
%                             - 'y': each slice is x-z, stack along y
%
% opts fields (all optional)
%   opts.debug          : true/false, default false
%   opts.peakMethod     : 'auto' | 'manual' | 'direct' (default 'manual')
%   opts.peakGuess      : [x1 y1; x2 y2] for direct mode, in centered FFT coords
%   opts.refMode        : 'average' | 'slice' | 'matrix' (default 'average')
%   opts.refSliceIndex  : index for refMode='slice'
%   opts.refMatrix      : 2D matrix for refMode='matrix'
%   opts.searchRad      : local search radius for peak refinement (default 12)
%   opts.fitRad         : subpixel refinement window radius (default 2)
%   opts.maxOrder       : max lattice order for notches (default 4)
%   opts.centerFrac     : center exclusion fraction (default 0.03)
%   opts.sigmaFactor    : notch width factor (default 0.08)
%   opts.notchDepth     : notch depth in [0,1] (default 0.98)
%   opts.minMask        : minimum transmission (default 0.02)
%   opts.useWindow      : apply apodization for FFT peak finding (default true)
%
% Outputs
%   data_nu                  : cleaned 3D data, same size as input
%   data_fft                 : reference-plane FFT before removal (2D)
%   data_fft_full_inan_remove: reference-plane FFT after removal (2D)
%   debug                    : diagnostics

    if nargin < 2 || isempty(direction)
        error('FixGridRemove3D_v2:MissingDirection', 'You must provide direction = ''x'', ''y'', or ''z''.');
    end
    if nargin < 3 || isempty(opts)
        opts = struct();
    end

    direction = lower(strtrim(char(direction)));
    peakMethod = lower(strtrim(char(getOpt(opts, 'peakMethod', 'manual'))));
    refMode    = lower(strtrim(char(getOpt(opts, 'refMode', 'average'))));

    debugMode   = getOpt(opts, 'debug', false);
    figBase     = getOpt(opts, 'figBase', 610);
    peakGuess   = getOpt(opts, 'peakGuess', []);
    refSliceIdx = getOpt(opts, 'refSliceIndex', []);
    refMatrix   = getOpt(opts, 'refMatrix', []);
    searchRad   = getOpt(opts, 'searchRad', 12);
    fitRad      = getOpt(opts, 'fitRad', 2);
    maxOrder    = getOpt(opts, 'maxOrder', 4);
    centerFrac  = getOpt(opts, 'centerFrac', 0.03);
    sigmaFactor = getOpt(opts, 'sigmaFactor', 0.08);
    notchDepth  = getOpt(opts, 'notchDepth', 0.98);
    minMask     = getOpt(opts, 'minMask', 0.02);
    useWindow   = getOpt(opts, 'useWindow', true);

    if ~(isfield(data, 'value') && isfield(data, 'x') && isfield(data, 'y') && isfield(data, 'z')) && ...
       ~(isprop(data, 'value')  && isprop(data, 'x')  && isprop(data, 'y')  && isprop(data, 'z'))
        error('FixGridRemove3D_v2:InvalidInput', 'Input must contain x, y, z, and value as fields or properties.');
    end

    x = data.x(:);
    y = data.y(:);
    z = data.z(:);

    V = double(data.value);
    sz = size(V);

    if numel(sz) ~= 3
        error('FixGridRemove3D_v2:InvalidValueSize', 'data.value must be a 3D array.');
    end

    nx = numel(x);
    ny = numel(y);
    nz = numel(z);

    if ~isequal(sz, [nx, ny, nz])
        error('FixGridRemove3D_v2:SizeMismatch', ...
            'Expected data.value size [numel(x), numel(y), numel(z)].');
    end

    plane = getPlaneInfo(direction, data);

    data_nu = data;
    data_fft = struct();
    data_fft_full_inan_remove = struct();

    debug = struct();
    debug.direction = direction;
    debug.options = opts;
    debug.peakMethod = peakMethod;
    debug.refMode = refMode;
    debug.plane = plane;
    debug.slicePeaks = cell(plane.nStack, 1);
    debug.sliceBasis = cell(plane.nStack, 1);
    debug.sliceStatus = strings(plane.nStack, 1);
    debug.reference = struct();

    % ------------------------------------------------------------
    % Build reference plane
    % ------------------------------------------------------------
    refPlane = buildReferencePlane(V, plane, refMode, refSliceIdx, refMatrix);
    refPlaneFilled = fillMissing2D(refPlane, plane.uAxis, plane.vAxis);

    debug.reference.refPlane = refPlane;
    debug.reference.refPlaneFilled = refPlaneFilled;

    % ------------------------------------------------------------
    % FFT of reference plane for peak seeding
    % ------------------------------------------------------------
    if useWindow
        Wref = cosineWindow(size(refPlaneFilled, 1)) * cosineWindow(size(refPlaneFilled, 2)).';
        refDet = refPlaneFilled .* Wref;
    else
        refDet = refPlaneFilled;
    end

    FrefDet = fftshift(fft2(refDet));
    Aref = log1p(abs(FrefDet));

    data_fft.x = plane.uAxis;
    data_fft.y = plane.vAxis;
    data_fft.value = Aref;

    debug.reference.Fdet = FrefDet;
    debug.reference.Aref = Aref;

    % ------------------------------------------------------------
    % Seed and refine the 1st-order peaks on the reference plane
    % ------------------------------------------------------------
    [refInitialPeaks, refRefinedPeaks] = getReferencePeaks( ...
        Aref, peakMethod, peakGuess, figBase, searchRad, fitRad, debugMode);

    debug.reference.initialPeaks = refInitialPeaks;
    debug.reference.refinedPeaks = refRefinedPeaks;

    if isempty(refRefinedPeaks) || size(refRefinedPeaks,1) ~= 2 || size(refRefinedPeaks,2) ~= 2
        warning('FixGridRemove3D_v2:NoReferencePeaks', 'Could not determine two reference peaks. Returning input unchanged.');
        data_nu.value = V;
        data_fft_full_inan_remove.x = plane.uAxis;
        data_fft_full_inan_remove.y = plane.vAxis;
        data_fft_full_inan_remove.value = Aref;
        return;
    end

    % Convert reference peak coordinates [x,y] to internal basis [row; col] = [y; x]
    refB = [refRefinedPeaks(1,2), refRefinedPeaks(2,2); ...
            refRefinedPeaks(1,1), refRefinedPeaks(2,1)];

    debug.reference.B = refB;

    if rcond(refB) < 1e-10 || abs(det(refB)) < 1e-8
        warning('FixGridRemove3D_v2:DegenerateReferenceBasis', 'Reference peak pair is degenerate. Returning input unchanged.');
        data_nu.value = V;
        data_fft_full_inan_remove.x = plane.uAxis;
        data_fft_full_inan_remove.y = plane.vAxis;
        data_fft_full_inan_remove.value = Aref;
        return;
    end

    % ------------------------------------------------------------
    % Reference notch mask for debugging only
    % ------------------------------------------------------------
    [refMask, refF0, refFfilt, refTargetPeaks] = buildNotchFilteredFFT( ...
    refPlaneFilled, refB, maxOrder, centerFrac, sigmaFactor, notchDepth, minMask);

    refClean = real(ifft2(ifftshift(refFfilt)));
    
    debug.reference.mask = refMask;
    debug.reference.F0 = refF0;
    debug.reference.Ffilt = refFfilt;
    debug.reference.targetPeaks = refTargetPeaks;
    debug.reference.cleanedPlane = refClean;
    debug.reference.status = 'ok';

    % ------------------------------------------------------------
    % Process each slice using the reference peaks as initial guess
    % ------------------------------------------------------------
    Vout = V;

    for is = 1:plane.nStack
        sliceRaw = extractSlice(V, is, plane);
        sliceFilled = fillMissing2D(sliceRaw, plane.uAxis, plane.vAxis);

        if useWindow
            W = cosineWindow(size(sliceFilled, 1)) * cosineWindow(size(sliceFilled, 2)).';
            sliceDet = sliceFilled .* W;
        else
            sliceDet = sliceFilled;
        end

        Fdet = fftshift(fft2(sliceDet));
        A = log1p(abs(Fdet));

        % Refine the two peaks independently for this slice
        sliceGuess = refRefinedPeaks;
        p1 = refineFFTpeak(A, sliceGuess(1,1), sliceGuess(1,2), searchRad, fitRad);
        p2 = refineFFTpeak(A, sliceGuess(2,1), sliceGuess(2,2), searchRad, fitRad);

        refinedPeaks = [p1(:).'; p2(:).'];

        % Basis in internal [row; col] form
        B = [refinedPeaks(1,2), refinedPeaks(2,2); ...
             refinedPeaks(1,1), refinedPeaks(2,1)];

        if any(~isfinite(B(:))) || rcond(B) < 1e-10 || abs(det(B)) < 1e-8
            B = refB;
            refinedPeaks = refRefinedPeaks;
            status = "fallback_reference_basis";
        else
            status = "ok";
        end

        [~, ~, Ffilt] = buildNotchFilteredFFT( ...
            sliceFilled, B, maxOrder, centerFrac, sigmaFactor, notchDepth, minMask);

        sliceClean = real(ifft2(ifftshift(Ffilt)));
        Vout = assignSlice(Vout, sliceClean, is, plane);

        debug.slicePeaks{is} = refinedPeaks;
        debug.sliceBasis{is} = B;
        debug.sliceStatus(is) = status;
    end

    data_nu.value = Vout;

    data_fft_full_inan_remove.x = plane.uAxis;
    data_fft_full_inan_remove.y = plane.vAxis;
    data_fft_full_inan_remove.value = log1p(abs(refFfilt));

    if debugMode
        showReferenceDebugFigure(figBase, refPlaneFilled, Aref, refMask, log1p(abs(refFfilt)), ...
            refClean, refInitialPeaks, refRefinedPeaks, refTargetPeaks, refB, plane, refMode);
    end
end

% ======================================================================
% Reference selection
% ======================================================================

function refPlane = buildReferencePlane(V, plane, refMode, refSliceIdx, refMatrix)
    switch refMode
        case 'average'
            refPlane = meanIgnoreNaN(V, plane.stackDim);
            refPlane = squeeze(refPlane);

        case 'slice'
            if isempty(refSliceIdx) || ~isscalar(refSliceIdx) || ~isfinite(refSliceIdx)
                error('FixGridRemove3D_v2:MissingRefSliceIndex', ...
                    'For refMode="slice", provide opts.refSliceIndex.');
            end
            refPlane = extractSlice(V, round(refSliceIdx), plane);

        case 'matrix'
            if isempty(refMatrix) || ~isnumeric(refMatrix) || ndims(refMatrix) ~= 2
                error('FixGridRemove3D_v2:MissingRefMatrix', ...
                    'For refMode="matrix", provide opts.refMatrix as a 2D matrix.');
            end
            refPlane = double(refMatrix);

            if ~isequal(size(refPlane), [numel(plane.uAxis), numel(plane.vAxis)])
                if isequal(size(refPlane), [numel(plane.vAxis), numel(plane.uAxis)])
                    refPlane = refPlane.';
                else
                    error('FixGridRemove3D_v2:RefMatrixSizeMismatch', ...
                        'refMatrix size must match the selected plane size, or its transpose.');
                end
            end

        otherwise
            error('FixGridRemove3D_v2:BadRefMode', 'opts.refMode must be "average", "slice", or "matrix".');
    end
end

function [initialPeaks, refinedPeaks] = getReferencePeaks(A, peakMethod, peakGuess, figBase, searchRad, fitRad, debugMode)
    [nx, ny] = size(A);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

    switch peakMethod
        case 'auto'
            guess = autoPeakGuess(A);

        case 'manual'
            guess = manualPeakGuess(A, figBase);

        case 'direct'
            if isempty(peakGuess) || ~isnumeric(peakGuess) || size(peakGuess,1) < 2 || size(peakGuess,2) < 2
                error('FixGridRemove3D_v2:BadPeakGuess', ...
                    'For peakMethod="direct", provide opts.peakGuess = [x1 y1; x2 y2].');
            end
            guess = double(peakGuess(1:2,1:2));

        otherwise
            error('FixGridRemove3D_v2:BadPeakMethod', ...
                'opts.peakMethod must be "auto", "manual", or "direct".');
    end

    initialPeaks = guess;

    p1 = refineFFTpeak(A, guess(1,1), guess(1,2), searchRad, fitRad);
    p2 = refineFFTpeak(A, guess(2,1), guess(2,2), searchRad, fitRad);

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

% ======================================================================
% Peak seeding methods
% ======================================================================

function guess = autoPeakGuess(A)
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
        error('FixGridRemove3D_v2:AutoPeakFail', 'Automatic peak detection found no candidates.');
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
        error('FixGridRemove3D_v2:AutoPeakFail', 'Not enough strong peaks for automatic seeding.');
    end

    [ri, ci] = ind2sub(size(A), candIdx);
    pos = [ci(:).' - cy; ri(:).' - cx];  % [x; y] in centered FFT coordinates
    r = hypot(pos(1,:), pos(2,:));
    keep = r >= rCenter;
    pos = pos(:, keep);
    candVals = candVals(keep);

    if size(pos, 2) < 2
        error('FixGridRemove3D_v2:AutoPeakFail', 'Automatic seeding collapsed after center suppression.');
    end

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
        error('FixGridRemove3D_v2:AutoPeakFail', 'Could not find a reliable non-collinear peak pair.');
    end

    guess = [pos(1, iBest), pos(2, iBest); ...
             pos(1, jBest), pos(2, jBest)];
end

function guess = manualPeakGuess(A, figBase)
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
        error('FixGridRemove3D_v2:ManualPeakFail', 'Need two clicks for manual seeding.');
    end

    guess = [xClick(1), yClick(1); xClick(2), yClick(2)];
end

% ======================================================================
% Peak refinement and masking
% ======================================================================

function p = refineFFTpeak(A, xClick, yClick, searchRad, fitRad)
    [nx, ny] = size(A);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

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

    rr1 = max(1, rMax - fitRad);
    rr2 = min(nx, rMax + fitRad);
    cc1 = max(1, cMax - fitRad);
    cc2 = min(ny, cMax + fitRad);

    local = A(rr1:rr2, cc1:cc2);

    [R, C] = ndgrid(rr1:rr2, cc1:cc2);
    dx = C(:) - cMax;
    dy = R(:) - rMax;
    z = local(:);

    G = [dx.^2, dy.^2, dx.*dy, dx, dy, ones(size(dx))];
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

    local = local - median(local(:));
    local(local < 0) = 0;

    if nnz(local) == 0
        p = [cMax - cy; rMax - cx];
        return;
    end

    w = local.^2;
    rRef = sum(R(:) .* w(:)) / sum(w(:));
    cRef = sum(C(:) .* w(:)) / sum(w(:));

    p = [cRef - cy; rRef - cx];
end

function [mask, F0, Ffilt, targetPeaks] = buildNotchFilteredFFT(sliceFilled, B, maxOrder, centerFrac, sigmaFactor, notchDepth, minMask)
    [nx, ny] = size(sliceFilled);

    F0 = fftshift(fft2(sliceFilled));

    [U, Vc] = ndgrid((1:nx) - (nx + 1) / 2, (1:ny) - (ny + 1) / 2);

    bNorm = max(norm(B(:,1)), norm(B(:,2)));
    sigmaPix = max(1.25, sigmaFactor * bNorm);

    orders = -maxOrder:maxOrder;
    [aa, bb] = ndgrid(orders, orders);
    orderList = [aa(:), bb(:)];
    orderList(all(orderList == 0, 2), :) = [];

    targetPeaks = B * orderList.';  % [row; col]

    atten = zeros(nx, ny);

    for k = 1:size(targetPeaks, 2)
        pk = targetPeaks(:, k);

        if hypot(pk(1), pk(2)) < max(0.5, centerFrac * min(nx, ny))
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
    Ffilt = F0 .* mask;
end

% ======================================================================
% Debug figure
% ======================================================================

function showReferenceDebugFigure(figNum, refPlaneFilled, Aref, mask, Afinal, refClean, initialPeaks, refinedPeaks, refTargetPeaks, B, plane, refMode)
    [nx, ny] = size(refPlaneFilled);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

    figure(figNum); clf;
    tiledlayout(2,3, 'Padding', 'compact', 'TileSpacing', 'compact');

    nexttile;
    imagesc(plane.vAxis, plane.uAxis, refPlaneFilled);
    axis image;
    set(gca, 'YDir', 'normal');
    title(['Reference plane (', refMode, ')']);
    xlabel(plane.vLabel);
    ylabel(plane.uLabel);
    colorbar;

    nexttile;
    imagesc((1:ny)-cy, (1:nx)-cx, Aref);
    axis image;
    set(gca, 'YDir', 'normal');
    title('log1p |FFT| before removal');
    xlabel('FFT col offset');
    ylabel('FFT row offset');
    colorbar;
    hold on;
    if ~isempty(initialPeaks)
        plot(initialPeaks(:,1), initialPeaks(:,2), 'wo', 'MarkerSize', 8, 'LineWidth', 1.5);
    end
    if ~isempty(refinedPeaks)
        plot(refinedPeaks(:,1), refinedPeaks(:,2), 'r+', 'MarkerSize', 12, 'LineWidth', 1.5);
    end
    if ~isempty(refTargetPeaks)
        plot(refTargetPeaks(2,:), refTargetPeaks(1,:), 'c.', 'MarkerSize', 8);
    end
    quiver(0, 0, B(2,1), B(1,1), 0, 'r', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
    quiver(0, 0, B(2,2), B(1,2), 0, 'g', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);

    nexttile;
    imagesc((1:ny)-cy, (1:nx)-cx, mask);
    axis image;
    set(gca, 'YDir', 'normal');
    title('Fourier mask');
    xlabel('FFT col offset');
    ylabel('FFT row offset');
    colorbar;

    nexttile;
    imagesc((1:ny)-cy, (1:nx)-cx, Afinal);
    axis image;
    set(gca, 'YDir', 'normal');
    title('log1p |FFT| after removal');
    xlabel('FFT col offset');
    ylabel('FFT row offset');
    colorbar;
    hold on;
    if ~isempty(refTargetPeaks)
        plot(refTargetPeaks(2,:), refTargetPeaks(1,:), 'c.', 'MarkerSize', 8);
    end

    nexttile;
    imagesc(plane.vAxis, plane.uAxis, refClean);
    axis image;
    set(gca, 'YDir', 'normal');
    title('Reference plane after removal');
    xlabel(plane.vLabel);
    ylabel(plane.uLabel);
    colorbar;

    nexttile;
    axis off;
end

% ======================================================================
% Plane handling
% ======================================================================

function plane = getPlaneInfo(direction, data)
    switch direction
        case 'z'
            plane.stackDim = 3;
            plane.nStack = numel(data.z);
            plane.uAxis = data.x(:);
            plane.vAxis = data.y(:);
            plane.uLabel = 'x';
            plane.vLabel = 'y';

        case 'x'
            plane.stackDim = 1;
            plane.nStack = numel(data.x);
            plane.uAxis = data.y(:);
            plane.vAxis = data.z(:);
            plane.uLabel = 'y';
            plane.vLabel = 'z';

        case 'y'
            plane.stackDim = 2;
            plane.nStack = numel(data.y);
            plane.uAxis = data.x(:);
            plane.vAxis = data.z(:);
            plane.uLabel = 'x';
            plane.vLabel = 'z';

        otherwise
            error('FixGridRemove3D_v2:BadDirection', 'direction must be ''x'', ''y'', or ''z''.');
    end
end

function slice = extractSlice(V, idx, plane)
    switch plane.stackDim
        case 3
            slice = V(:,:,idx);

        case 1
            slice = reshape(V(idx,:,:), [size(V,2), size(V,3)]);

        case 2
            slice = reshape(V(:,idx,:), [size(V,1), size(V,3)]);

        otherwise
            error('FixGridRemove3D_v2:BadStackDim', 'Invalid stack dimension.');
    end
end

function Vout = assignSlice(Vout, slice, idx, plane)
    switch plane.stackDim
        case 3
            Vout(:,:,idx) = slice;

        case 1
            Vout(idx,:,:) = reshape(slice, [1, size(Vout,2), size(Vout,3)]);

        case 2
            Vout(:,idx,:) = reshape(slice, [size(Vout,1), 1, size(Vout,3)]);

        otherwise
            error('FixGridRemove3D_v2:BadStackDim', 'Invalid stack dimension.');
    end
end

% ======================================================================
% General helpers
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

function M = meanIgnoreNaN(A, dim)
    finiteMask = isfinite(A);
    A(~finiteMask) = 0;

    count = sum(finiteMask, dim);
    sumA = sum(A, dim);

    M = sumA ./ max(count, 1);
    M(count == 0) = 0;
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

function val = getOpt(opts, name, defaultVal)
    if isstruct(opts) && isfield(opts, name) && ~isempty(opts.(name))
        val = opts.(name);
    else
        val = defaultVal;
    end
end