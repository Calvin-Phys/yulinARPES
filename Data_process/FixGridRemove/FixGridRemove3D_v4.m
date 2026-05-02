function [data_nu, data_fft, data_fft_full_inan_remove, debug] = FixGridRemove3D_v4(data, opts)
%FIXGRIDREMOVE3D_V1  3D grid removal using a reference average cut.
%
% Keeps the same output structure as FixGridRemove_v4:
%   data_nu
%   data_fft
%   data_fft_full_inan_remove
%   debug
%
% New input control:
%   opts.direction = 'x' | 'y' | 'z'
%
% Workflow:
%   1) average all slices along the chosen stack direction
%   2) manually/auto/direct select 2 first-order peaks on the average FFT
%   3) refine those peaks independently for each slice
%   4) remove the grid slice-by-slice
%
% Debug:
%   one reference debug panel only

    if nargin < 2 || isempty(opts)
        opts = struct();
    end

    direction  = lower(strtrim(char(getOpt(opts, 'direction', 'z'))));
    debugMode   = getOpt(opts, 'debug', false);
    figBase     = getOpt(opts, 'figBase', 510);

    peakMethod  = lower(string(getOpt(opts, 'peakMethod', 'manual')));
    peakGuess   = getOpt(opts, 'peakGuess', []);

    maxOrder    = getOpt(opts, 'maxOrder', 6);
    centerFrac  = getOpt(opts, 'centerFrac', 0.03);
    sigmaFactor = getOpt(opts, 'sigmaFactor', 0.1);
    notchDepth  = getOpt(opts, 'notchDepth', 0.98);
    minMask     = getOpt(opts, 'minMask', 0.02);
    useWindow   = getOpt(opts, 'useWindow', true);
    searchRad   = getOpt(opts, 'searchRad', 12);
    fitRad      = getOpt(opts, 'fitRad', 2);

    if ~(isfield(data, 'value') || isprop(data, 'value')) || ...
       ~(isfield(data, 'x')     || isprop(data, 'x'))     || ...
       ~(isfield(data, 'y')     || isprop(data, 'y'))     || ...
       ~(isfield(data, 'z')     || isprop(data, 'z'))
        error('FixGridRemove3D_v1:InvalidInput', ...
            'Input must contain x, y, z, and value as fields or properties.');
    end

    x = data.x(:);
    y = data.y(:);
    z = data.z(:);
    V = double(data.value);

    if ndims(V) ~= 3
        error('FixGridRemove3D_v1:InvalidValueSize', 'data.value must be a 3D array.');
    end

    nx = numel(x);
    ny = numel(y);
    nz = numel(z);

    if ~isequal(size(V), [nx, ny, nz])
        error('FixGridRemove3D_v1:SizeMismatch', ...
            'Expected data.value size [numel(x), numel(y), numel(z)].');
    end

    plane = getPlaneInfo(direction, data);

    data_nu = data;
    data_fft = struct();
    data_fft_full_inan_remove = struct();

    debug = struct();
    debug.options = opts;
    debug.direction = direction;
    debug.plane = plane;
    debug.reference = struct();
    debug.slicePeaks = cell(plane.nStack, 1);
    debug.sliceBasis = cell(plane.nStack, 1);
    debug.sliceStatus = strings(plane.nStack, 1);

    % ------------------------------------------------------------
    % Reference cut = average of all slices
    % ------------------------------------------------------------
    refPlane = squeeze(meanIgnoreNaN(V, plane.stackDim));
    refPlane = fillMissing2D(refPlane, plane.uAxis, plane.vAxis);

    if useWindow
        Wref = cosineWindow(size(refPlane, 1)) * cosineWindow(size(refPlane, 2)).';
        refDet = refPlane .* Wref;
    else
        refDet = refPlane;
    end

    FrefDet = fftshift(fft2(refDet));
    Aref = log1p(abs(FrefDet));

    data_fft.x = plane.uAxis;
    data_fft.y = plane.vAxis;
    data_fft.value = Aref;

    debug.reference.refPlane = refPlane;
    debug.reference.Aref = Aref;
    debug.reference.Fdet = FrefDet;

    % ------------------------------------------------------------
    % Select and refine 1st-order peaks on the reference cut
    % ------------------------------------------------------------
    [refInitialPeaks, refSelectedPeaks] = getPeakSeeds( ...
        Aref, peakMethod, peakGuess, figBase, searchRad, fitRad, debugMode);

    debug.reference.initialPeaks = refInitialPeaks;
    debug.reference.selectedPeaks = refSelectedPeaks;

    if isempty(refSelectedPeaks) || size(refSelectedPeaks, 1) ~= 2 || size(refSelectedPeaks, 2) ~= 2
        warning('FixGridRemove3D_v1:NoReferencePeaks', ...
            'Could not determine two reference peaks. Returning input unchanged.');
        data_nu.value = V;
        data_fft_full_inan_remove.x = plane.uAxis;
        data_fft_full_inan_remove.y = plane.vAxis;
        data_fft_full_inan_remove.value = Aref;
        return;
    end

    % internal basis is [row; col] = [y; x]
    refB = [refSelectedPeaks(1,2), refSelectedPeaks(2,2); ...
            refSelectedPeaks(1,1), refSelectedPeaks(2,1)];

    debug.reference.B = refB;

    if any(~isfinite(refB(:))) || abs(det(refB)) < 1e-8 || rcond(refB) < 1e-10
        warning('FixGridRemove3D_v1:DegenerateReferenceBasis', ...
            'Reference peak pair is degenerate. Returning input unchanged.');
        data_nu.value = V;
        data_fft_full_inan_remove.x = plane.uAxis;
        data_fft_full_inan_remove.y = plane.vAxis;
        data_fft_full_inan_remove.value = Aref;
        return;
    end

    orders = -maxOrder:maxOrder;
    [aa, bb] = ndgrid(orders, orders);
    orderList = [aa(:), bb(:)];
    orderList(all(orderList == 0, 2), :) = [];
    targetPeaks = refB * orderList.';  % [row; col]

    debug.reference.orderList = orderList;
    debug.reference.targetPeaks = targetPeaks;

    refSigma = max(1.25, sigmaFactor * max(norm(refB(:,1)), norm(refB(:,2))));
    refMask = buildMaskFromPeaks(size(refPlane,1), size(refPlane,2), targetPeaks, refSigma, notchDepth, minMask);

    refF0 = fftshift(fft2(refPlane));
    refFfilt = refF0 .* refMask;
    refClean = real(ifft2(ifftshift(refFfilt)));

    data_fft_full_inan_remove.x = plane.uAxis;
    data_fft_full_inan_remove.y = plane.vAxis;
    data_fft_full_inan_remove.value = log1p(abs(refFfilt));

    debug.reference.mask = refMask;
    debug.reference.F0 = refF0;
    debug.reference.Ffilt = refFfilt;
    debug.reference.cleanedPlane = refClean;
    debug.reference.notchSigma = refSigma;
    debug.reference.status = 'ok';

    % ------------------------------------------------------------
    % Slice-by-slice removal
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

        Aslice = log1p(abs(fftshift(fft2(sliceDet))));

        % refine from the reference peaks for each cut
        p1 = refineFFTpeak(Aslice, refSelectedPeaks(1,1), refSelectedPeaks(1,2), searchRad, fitRad);
        p2 = refineFFTpeak(Aslice, refSelectedPeaks(2,1), refSelectedPeaks(2,2), searchRad, fitRad);
        slicePeaks = [p1(:).'; p2(:).'];

        Bslice = [slicePeaks(1,2), slicePeaks(2,2); ...
                  slicePeaks(1,1), slicePeaks(2,1)];

        if any(~isfinite(Bslice(:))) || abs(det(Bslice)) < 1e-8 || rcond(Bslice) < 1e-10
            Bslice = refB;
            slicePeaks = refSelectedPeaks;
            status = "fallback_reference_basis";
        else
            status = "ok";
        end

        sliceSigma = max(1.25, sigmaFactor * max(norm(Bslice(:,1)), norm(Bslice(:,2))));
        sliceTargetPeaks = Bslice * orderList.';

        sliceMask = buildMaskFromPeaks(size(sliceFilled,1), size(sliceFilled,2), ...
            sliceTargetPeaks, sliceSigma, notchDepth, minMask);

        F0 = fftshift(fft2(sliceFilled));
        Ffilt = F0 .* sliceMask;
        sliceClean = real(ifft2(ifftshift(Ffilt)));

        Vout = assignSlice(Vout, sliceClean, is, plane);

        debug.slicePeaks{is} = slicePeaks;
        debug.sliceBasis{is} = Bslice;
        debug.sliceStatus(is) = status;
    end

    data_nu.value = Vout;

    if debugMode
        showReferenceDebugFigure(figBase, refPlane, Aref, refMask, log1p(abs(refFfilt)), ...
            refClean, refInitialPeaks, refSelectedPeaks, targetPeaks, refB, plane, direction);
    end
end

% ======================================================================
% Peak seeding and refinement
% ======================================================================

function [initialPeaks, refinedPeaks] = getPeakSeeds(A, peakMethod, peakGuess, figBase, searchRad, fitRad, debugMode)
% Returns peaks in centered FFT coordinates:
%   [x, y] = [FFT col offset, FFT row offset]

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
                error('FixGridRemove3D_v1:BadPeakGuess', ...
                    'For peakMethod="direct", provide opts.peakGuess = [x1 y1; x2 y2].');
            end
            guess = double(peakGuess(1:2,1:2));
        otherwise
            error('FixGridRemove3D_v1:BadPeakMethod', ...
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
        error('FixGridRemove3D_v1:AutoPeakFail', 'Automatic peak detection found no candidates.');
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
        error('FixGridRemove3D_v1:AutoPeakFail', 'Not enough strong peaks for automatic seeding.');
    end

    [ri, ci] = ind2sub(size(A), candIdx);
    pos = [ci(:).' - cy; ri(:).' - cx];  % [x; y]

    r = hypot(pos(1,:), pos(2,:));
    keep = r >= rCenter;
    pos = pos(:, keep);
    candVals = candVals(keep);

    if size(pos, 2) < 2
        error('FixGridRemove3D_v1:AutoPeakFail', 'Automatic seeding collapsed after center suppression.');
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
        error('FixGridRemove3D_v1:AutoPeakFail', 'Could not find a reliable non-collinear peak pair.');
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
    title('Click the 2 first-order peaks on the reference average');
    colorbar;
    drawnow;

    [xClick, yClick] = getpts;
    if numel(xClick) < 2
        error('FixGridRemove3D_v1:ManualPeakFail', 'Need two clicks for manual seeding.');
    end

    guess = [xClick(1), yClick(1); xClick(2), yClick(2)];
end

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
    x = C(:) - cMax;
    y = R(:) - rMax;
    z = local(:);

    G = [x.^2, y.^2, x.*y, x, y, ones(size(x))];
    coef = G \ z;

    a = coef(1);
    b = coef(2);
    c = coef(3);
    d = coef(4);
    e = coef(5);

    H = [2*a, c; c, 2*b];
    g = [d; e];

    if all(isfinite(coef)) && rcond(H) > 1e-10
        xStar = -H \ g;
        if all(isfinite(xStar)) && abs(xStar(1)) <= 1.5 && abs(xStar(2)) <= 1.5
            cRef = cMax + xStar(1);
            rRef = rMax + xStar(2);
            p = [cRef - cy, rRef - cx];
            return;
        end
    end

    local = local - median(local(:));
    local(local < 0) = 0;

    if nnz(local) == 0
        p = [cMax - cy, rMax - cx];
        return;
    end

    w = local.^2;
    rRef = sum(R(:) .* w(:)) / sum(w(:));
    cRef = sum(C(:) .* w(:)) / sum(w(:));

    p = [cRef - cy, rRef - cx];
end

% ======================================================================
% Mask / FFT helpers
% ======================================================================

function mask = buildMaskFromPeaks(nr, nc, peaksXY, sigma, notchDepth, minMask)
    [U, V] = ndgrid((1:nr) - (nr + 1)/2, (1:nc) - (nc + 1)/2);
    atten = zeros(nr, nc);

    for i = 1:size(peaksXY,2)
        x0 = peaksXY(2,i);
        y0 = peaksXY(1,i);
        d2 = (U - y0).^2 + (V - x0).^2;
        notch = notchDepth * exp(-d2 / (2 * sigma^2));
        atten = max(atten, notch);
    end

    mask = max(minMask, 1 - atten);
end

% ======================================================================
% Plane / stack helpers
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
            error('FixGridRemove3D_v1:BadDirection', 'direction must be ''x'', ''y'', or ''z''.');
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
            error('FixGridRemove3D_v1:BadStackDim', 'Invalid stack dimension.');
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
            error('FixGridRemove3D_v1:BadStackDim', 'Invalid stack dimension.');
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

function showReferenceDebugFigure(figBase, refPlane, Aref, mask, Afinal, refClean, initialPeaks, refinedPeaks, targetPeaks, B, plane, direction)
    [nr, nc] = size(refPlane);
    cx = (nr + 1) / 2;
    cy = (nc + 1) / 2;

    figure(figBase); clf;
    tiledlayout(2,3, 'Padding', 'compact', 'TileSpacing', 'compact');

    nexttile;
    imagesc(plane.vAxis, plane.uAxis, refPlane);
    axis image;
    set(gca, 'YDir', 'normal');
    title(['Reference average cut (', direction, ')']);
    xlabel(plane.vLabel); ylabel(plane.uLabel);
    colorbar;

    nexttile;
    imagesc((1:nc)-cy, (1:nr)-cx, Aref);
    axis image;
    set(gca, 'YDir', 'normal');
    title('FFT before removal');
    xlabel('FFT col offset'); ylabel('FFT row offset');
    colorbar;
    hold on;
    plot(initialPeaks(:,1), initialPeaks(:,2), 'wo', 'MarkerSize', 8, 'LineWidth', 1.2);
    plot(refinedPeaks(:,1), refinedPeaks(:,2), 'r+', 'MarkerSize', 12, 'LineWidth', 1.5);
    if ~isempty(targetPeaks)
        plot(targetPeaks(2,:), targetPeaks(1,:), 'c.', 'MarkerSize', 8);
    end
    quiver(0, 0, B(2,1), B(1,1), 0, 'r', 'LineWidth', 1.2, 'MaxHeadSize', 0.5);
    quiver(0, 0, B(2,2), B(1,2), 0, 'g', 'LineWidth', 1.2, 'MaxHeadSize', 0.5);

    nexttile;
    imagesc((1:nc)-cy, (1:nr)-cx, mask);
    axis image;
    set(gca, 'YDir', 'normal');
    title('Fourier mask');
    xlabel('FFT col offset'); ylabel('FFT row offset');
    colorbar;

    nexttile;
    imagesc((1:nc)-cy, (1:nr)-cx, Afinal);
    axis image;
    set(gca, 'YDir', 'normal');
    title('FFT after removal');
    xlabel('FFT col offset'); ylabel('FFT row offset');
    colorbar;
    hold on;
    if ~isempty(targetPeaks)
        plot(targetPeaks(2,:), targetPeaks(1,:), 'c.', 'MarkerSize', 8);
    end

    nexttile;
    imagesc(plane.vAxis, plane.uAxis, refClean);
    axis image;
    set(gca, 'YDir', 'normal');
    title('Reference cut after removal');
    xlabel(plane.vLabel); ylabel(plane.uLabel);
    colorbar;

    nexttile;
    imagesc(plane.vAxis, plane.uAxis, refPlane - refClean);
    axis image;
    set(gca, 'YDir', 'normal');
    title('Removed component');
    xlabel(plane.vLabel); ylabel(plane.uLabel);
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