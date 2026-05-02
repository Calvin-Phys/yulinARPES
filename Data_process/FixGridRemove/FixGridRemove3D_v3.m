function [data_nu, data_fft, data_fft_full_inan_remove, debug] = FixGridRemove3D_v3(data, direction, opts)
% Remove 2D grid-like Fourier artifacts from a 3D dataset slice-by-slice.
%
% Inputs
%   data.x, data.y, data.z, data.value
%   direction : 'x' | 'y' | 'z'
%   opts fields:
%       .debug             logical, default false
%       .figBase           default 700
%       .peakMethod        'auto' | 'manual' | 'direct'   default 'manual'
%       .peakGuess         [x1 y1; x2 y2] for 'direct', centered FFT coords
%       .refMode           'average' | 'slice' | 'matrix' default 'average'
%       .refSliceIndex     for refMode='slice'
%       .refMatrix         for refMode='matrix'
%       .useWindow         default true
%       .searchRad         default 12   % for 1st-order peak refinement
%       .fitRad            default 2
%       .maxOrder          default 3    % harmonic order to consider
%       .harmonicSearchRad default 6    % local search around predicted harmonics
%       .harmonicFitRad    default 2
%       .harmonicThreshSigma default 2.5
%       .centerFrac        default 0.03
%       .sigmaFactor       default 0.10 % used only if notchSigmaPx empty
%       .notchSigmaPx      default []   % direct Gaussian sigma in pixels
%       .notchDepth        default 1.0
%       .minMask           default 0.0
%
% Outputs
%   data_nu.value                     cleaned 3D data
%   data_fft.value                    reference FFT before removal
%   data_fft_full_inan_remove.value   reference FFT after removal
%   debug.reference                   reference diagnostics
%   debug.slicePeaks / sliceBasis     per-slice diagnostics

    if nargin < 2 || isempty(direction)
        error('FixGridRemove3D_v3:MissingDirection', ...
            'direction must be ''x'', ''y'', or ''z''.');
    end
    if nargin < 3 || isempty(opts)
        opts = struct();
    end

    direction = lower(strtrim(char(direction)));

    debugMode           = getOpt(opts, 'debug', false);
    figBase             = getOpt(opts, 'figBase', 700);
    peakMethod          = lower(strtrim(char(getOpt(opts, 'peakMethod', 'manual'))));
    peakGuess           = getOpt(opts, 'peakGuess', []);
    refMode             = lower(strtrim(char(getOpt(opts, 'refMode', 'average'))));
    refSliceIndex       = getOpt(opts, 'refSliceIndex', []);
    refMatrix           = getOpt(opts, 'refMatrix', []);
    useWindow           = getOpt(opts, 'useWindow', true);

    searchRad           = getOpt(opts, 'searchRad', 12);
    fitRad              = getOpt(opts, 'fitRad', 2);

    maxOrder            = getOpt(opts, 'maxOrder', 3);
    harmonicSearchRad   = getOpt(opts, 'harmonicSearchRad', 6);
    harmonicFitRad      = getOpt(opts, 'harmonicFitRad', 2);
    harmonicThreshSigma = getOpt(opts, 'harmonicThreshSigma', 2.5);

    centerFrac          = getOpt(opts, 'centerFrac', 0.03);
    sigmaFactor         = getOpt(opts, 'sigmaFactor', 0.10);
    notchSigmaPx        = getOpt(opts, 'notchSigmaPx', []);
    notchDepth          = getOpt(opts, 'notchDepth', 1.0);
    minMask             = getOpt(opts, 'minMask', 0.0);

    if ~(isfield(data, 'value') && isfield(data, 'x') && isfield(data, 'y') && isfield(data, 'z')) && ...
       ~(isprop(data, 'value')  && isprop(data, 'x')  && isprop(data, 'y')  && isprop(data, 'z'))
        error('FixGridRemove3D_v3:InvalidInput', ...
            'Input must contain x, y, z, and value as fields or properties.');
    end

    x = data.x(:);
    y = data.y(:);
    z = data.z(:);
    V = double(data.value);

    if ndims(V) ~= 3
        error('FixGridRemove3D_v3:InvalidValueSize', 'data.value must be 3D.');
    end

    nx = numel(x);
    ny = numel(y);
    nz = numel(z);

    if ~isequal(size(V), [nx, ny, nz])
        error('FixGridRemove3D_v3:SizeMismatch', ...
            'Expected size(data.value) = [numel(x), numel(y), numel(z)].');
    end

    plane = getPlaneInfo(direction, data);

    data_nu = data;
    data_fft = struct();
    data_fft_full_inan_remove = struct();

    debug = struct();
    debug.direction = direction;
    debug.options = opts;
    debug.reference = struct();
    debug.slicePeaks = cell(plane.nStack, 1);
    debug.sliceBasis = cell(plane.nStack, 1);
    debug.sliceStatus = strings(plane.nStack, 1);

    % ----------------------------
    % Reference plane
    % ----------------------------
    refPlane = buildReferencePlane(V, plane, refMode, refSliceIndex, refMatrix);
    refPlane = fillMissing2D(refPlane, plane.uAxis, plane.vAxis);

    if useWindow
        Wref = cosineWindow(size(refPlane,1)) * cosineWindow(size(refPlane,2)).';
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

    % ----------------------------
    % First-order peaks on reference
    % ----------------------------
    [refInitialPeaks, refRefinedPeaks] = getReferencePeaks( ...
        Aref, peakMethod, peakGuess, figBase, searchRad, fitRad, debugMode);

    debug.reference.initialPeaks = refInitialPeaks;
    debug.reference.refinedPeaks = refRefinedPeaks;

    if isempty(refRefinedPeaks) || size(refRefinedPeaks,1) ~= 2 || size(refRefinedPeaks,2) ~= 2
        warning('FixGridRemove3D_v3:NoReferencePeaks', ...
            'Could not determine reference peaks. Returning input unchanged.');
        data_nu.value = V;
        data_fft_full_inan_remove.x = plane.uAxis;
        data_fft_full_inan_remove.y = plane.vAxis;
        data_fft_full_inan_remove.value = Aref;
        return;
    end

    % B is [row; col] basis
    refB = [refRefinedPeaks(1,2), refRefinedPeaks(2,2); ...
            refRefinedPeaks(1,1), refRefinedPeaks(2,1)];

    if any(~isfinite(refB(:))) || abs(det(refB)) < 1e-8 || rcond(refB) < 1e-10
        warning('FixGridRemove3D_v3:DegenerateReferenceBasis', ...
            'Reference peak pair is degenerate. Returning input unchanged.');
        data_nu.value = V;
        data_fft_full_inan_remove.x = plane.uAxis;
        data_fft_full_inan_remove.y = plane.vAxis;
        data_fft_full_inan_remove.value = Aref;
        return;
    end

    debug.reference.B = refB;

    % ----------------------------
    % Find real harmonic peaks on the reference FFT
    % ----------------------------
    [refCoeffs, refTargetPeaks, refPeakAmp] = findActualHarmonicPeaks( ...
        Aref, refB, maxOrder, harmonicSearchRad, harmonicFitRad, centerFrac, harmonicThreshSigma);

    debug.reference.targetCoeffs = refCoeffs;
    debug.reference.targetPeaks = refTargetPeaks;
    debug.reference.targetPeakAmp = refPeakAmp;

    if isempty(refTargetPeaks)
        warning('FixGridRemove3D_v3:NoHarmonicsAccepted', ...
            'No harmonic peaks were accepted on the reference FFT. Returning input unchanged.');
        data_nu.value = V;
        data_fft_full_inan_remove.x = plane.uAxis;
        data_fft_full_inan_remove.y = plane.vAxis;
        data_fft_full_inan_remove.value = Aref;
        return;
    end

    % ----------------------------
    % Reference mask
    % ----------------------------
    refSigma = chooseNotchSigma(refB, notchSigmaPx, sigmaFactor);
    refMask = buildMaskFromPeaks(size(refPlane,1), size(refPlane,2), refTargetPeaks, refSigma, notchDepth, minMask);
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

    % ----------------------------
    % Process stack
    % ----------------------------
    Vout = V;

    for is = 1:plane.nStack
        sliceRaw = extractSlice(V, is, plane);
        sliceFilled = fillMissing2D(sliceRaw, plane.uAxis, plane.vAxis);

        if useWindow
            W = cosineWindow(size(sliceFilled,1)) * cosineWindow(size(sliceFilled,2)).';
            sliceDet = sliceFilled .* W;
        else
            sliceDet = sliceFilled;
        end

        Aslice = log1p(abs(fftshift(fft2(sliceDet))));

        % refine the two first-order peaks for this slice
        sliceGuess = refRefinedPeaks;
        p1 = refineFFTpeak(Aslice, sliceGuess(1,1), sliceGuess(1,2), searchRad, fitRad);
        p2 = refineFFTpeak(Aslice, sliceGuess(2,1), sliceGuess(2,2), searchRad, fitRad);
        slicePeaks = [p1(:).'; p2(:).'];

        Bslice = [slicePeaks(1,2), slicePeaks(2,2); ...
                  slicePeaks(1,1), slicePeaks(2,1)];

        if any(~isfinite(Bslice(:))) || abs(det(Bslice)) < 1e-8 || rcond(Bslice) < 1e-10
            Bslice = refB;
            slicePeaks = refRefinedPeaks;
            status = "fallback_reference_basis";
        else
            status = "ok";
        end

        % use the accepted reference harmonic coefficient list only
        [sliceTargetPeaks, sliceTargetAmp] = refineHarmonicsFromCoeffs( ...
            Aslice, Bslice, refCoeffs, harmonicSearchRad, harmonicFitRad, centerFrac);

        if isempty(sliceTargetPeaks)
            sliceTargetPeaks = refTargetPeaks;
            status = "fallback_reference_targets";
        end

        sliceSigma = chooseNotchSigma(Bslice, notchSigmaPx, sigmaFactor);
        sliceMask = buildMaskFromPeaks(size(sliceFilled,1), size(sliceFilled,2), ...
            sliceTargetPeaks, sliceSigma, notchDepth, minMask);

        F0 = fftshift(fft2(sliceFilled));
        Ffilt = F0 .* sliceMask;
        sliceClean = real(ifft2(ifftshift(Ffilt)));

        Vout = assignSlice(Vout, sliceClean, is, plane);

        debug.slicePeaks{is} = slicePeaks;
        debug.sliceBasis{is} = Bslice;
        debug.sliceStatus(is) = status;
        debug.sliceTargetAmp{is,1} = sliceTargetAmp; %#ok<AGROW>
    end

    data_nu.value = Vout;

    if debugMode
        showReferenceDebugFigure(figBase, refPlane, Aref, refMask, log1p(abs(refFfilt)), ...
            refClean, refInitialPeaks, refRefinedPeaks, refTargetPeaks, refB, plane, refMode);
    end
end

% =========================
% Core harmonic logic
% =========================

function [coeffsKept, peaksKept, ampsKept] = findActualHarmonicPeaks(A, B, maxOrder, searchRad, fitRad, centerFrac, threshSigma)
    [nr, nc] = size(A);
    cx = (nr + 1) / 2;
    cy = (nc + 1) / 2;

    coeffs = harmonicCoeffList(maxOrder);
    nC = size(coeffs,1);

    flat = A(isfinite(A));
    medA = median(flat);
    madA = median(abs(flat - medA));
    if ~isfinite(madA) || madA <= 0
        madA = std(flat);
    end
    if ~isfinite(madA) || madA <= 0
        madA = 1;
    end
    thr = medA + threshSigma * madA;
    centerR = max(2, centerFrac * min(nr, nc));

    coeffsKept = zeros(0,2);
    peaksKept = zeros(0,2); % [x y]
    ampsKept = zeros(0,1);

    for i = 1:nC
        ab = coeffs(i,:).';
        prc = B * ab; % [row; col]
        x0 = prc(2);
        y0 = prc(1);

        if hypot(x0, y0) < centerR
            continue;
        end
        if abs(y0) > nr/2 - 2 || abs(x0) > nc/2 - 2
            continue;
        end

        p = refineFFTpeak(A, x0, y0, searchRad, fitRad);
        amp = sampleCenteredFFT(A, p(1), p(2));

        if isfinite(amp) && amp >= thr
            coeffsKept(end+1,:) = ab.'; %#ok<AGROW>
            peaksKept(end+1,:) = p; %#ok<AGROW>
            ampsKept(end+1,1) = amp; %#ok<AGROW>
        end
    end
end

function [peaksKept, ampsKept] = refineHarmonicsFromCoeffs(A, B, coeffs, searchRad, fitRad, centerFrac)
    [nr, nc] = size(A);
    centerR = max(2, centerFrac * min(nr, nc));

    peaksKept = zeros(0,2); % [x y]
    ampsKept = zeros(0,1);

    for i = 1:size(coeffs,1)
        ab = coeffs(i,:).';
        prc = B * ab; % [row; col]
        x0 = prc(2);
        y0 = prc(1);

        if hypot(x0, y0) < centerR
            continue;
        end
        if abs(y0) > nr/2 - 2 || abs(x0) > nc/2 - 2
            continue;
        end

        p = refineFFTpeak(A, x0, y0, searchRad, fitRad);
        amp = sampleCenteredFFT(A, p(1), p(2));

        if isfinite(amp)
            peaksKept(end+1,:) = p; %#ok<AGROW>
            ampsKept(end+1,1) = amp; %#ok<AGROW>
        end
    end
end

function coeffs = harmonicCoeffList(maxOrder)
    [aa, bb] = ndgrid(-maxOrder:maxOrder, -maxOrder:maxOrder);
    coeffs = [aa(:), bb(:)];
    coeffs(all(coeffs == 0, 2), :) = [];
    ord = abs(coeffs(:,1)) + abs(coeffs(:,2));
    coeffs = coeffs(ord >= 1 & ord <= maxOrder, :);
end

function sigma = chooseNotchSigma(B, notchSigmaPx, sigmaFactor)
    if ~isempty(notchSigmaPx) && isfinite(notchSigmaPx) && notchSigmaPx > 0
        sigma = notchSigmaPx;
    else
        bNorm = max(norm(B(:,1)), norm(B(:,2)));
        sigma = max(1.25, sigmaFactor * bNorm);
    end
end

function mask = buildMaskFromPeaks(nr, nc, peaksXY, sigma, notchDepth, minMask)
    [U, V] = ndgrid((1:nr) - (nr + 1)/2, (1:nc) - (nc + 1)/2);
    atten = zeros(nr, nc);

    for i = 1:size(peaksXY,1)
        x0 = peaksXY(i,1);
        y0 = peaksXY(i,2);
        d2 = (U - y0).^2 + (V - x0).^2;
        notch = notchDepth * exp(-d2 / (2 * sigma^2));
        atten = max(atten, notch);
    end

    mask = max(minMask, 1 - atten);
end

% =========================
% Peak selection / refinement
% =========================

function [initialPeaks, refinedPeaks] = getReferencePeaks(A, peakMethod, peakGuess, figBase, searchRad, fitRad, debugMode)
    switch peakMethod
        case 'auto'
            guess = autoPeakGuess(A);
        case 'manual'
            guess = manualPeakGuess(A, figBase);
        case 'direct'
            if isempty(peakGuess) || size(peakGuess,1) < 2 || size(peakGuess,2) < 2
                error('FixGridRemove3D_v3:BadPeakGuess', ...
                    'For peakMethod=''direct'', use opts.peakGuess = [x1 y1; x2 y2].');
            end
            guess = double(peakGuess(1:2,1:2));
        otherwise
            error('FixGridRemove3D_v3:BadPeakMethod', ...
                'peakMethod must be auto/manual/direct.');
    end

    initialPeaks = guess;
    p1 = refineFFTpeak(A, guess(1,1), guess(1,2), searchRad, fitRad);
    p2 = refineFFTpeak(A, guess(2,1), guess(2,2), searchRad, fitRad);
    refinedPeaks = [p1(:).'; p2(:).'];

    if debugMode
        figure(figBase); clf;
        [nr, nc] = size(A);
        cx = (nr + 1) / 2;
        cy = (nc + 1) / 2;
        imagesc((1:nc)-cy, (1:nr)-cx, A);
        axis image;
        set(gca, 'YDir', 'normal');
        colorbar;
        hold on;
        plot(initialPeaks(:,1), initialPeaks(:,2), 'wo', 'MarkerSize', 8, 'LineWidth', 1.2);
        plot(refinedPeaks(:,1), refinedPeaks(:,2), 'r+', 'MarkerSize', 12, 'LineWidth', 1.5);
        title('Reference FFT: selected 1st-order peaks');
        xlabel('FFT col offset');
        ylabel('FFT row offset');
        drawnow;
    end
end

function guess = autoPeakGuess(A)
    [nr, nc] = size(A);
    cx = (nr + 1) / 2;
    cy = (nc + 1) / 2;

    [U, V] = ndgrid((1:nr)-cx, (1:nc)-cy);
    centerMask = hypot(U, V) <= max(4, round(0.03 * min(nr, nc)));

    peakMask = localMax2D(A);
    peakMask(centerMask) = false;

    idx = find(peakMask);
    if isempty(idx)
        error('FixGridRemove3D_v3:AutoPeakFail', 'No FFT peaks found.');
    end

    vals = A(idx);
    [vals, ord] = sort(vals, 'descend');
    idx = idx(ord);
    idx = idx(1:min(80, numel(idx)));
    vals = vals(1:min(80, numel(vals)));

    [r, c] = ind2sub(size(A), idx);
    pos = [c - cy, r - cx]; % [x y]

    bestScore = -inf;
    bestPair = [];

    K = size(pos,1);
    for i = 1:min(K,25)-1
        p1 = pos(i,:).';
        for j = i+1:min(K,25)
            p2 = pos(j,:).';
            n1 = norm(p1);
            n2 = norm(p2);
            if n1 < 3 || n2 < 3
                continue;
            end
            s = abs(det([p1 p2])) / max(n1*n2, eps);
            if s < sind(15)
                continue;
            end
            score = sqrt(vals(i)*vals(j)) * s / (1 + 0.1*(n1+n2));
            if score > bestScore
                bestScore = score;
                bestPair = [p1.'; p2.'];
            end
        end
    end

    if isempty(bestPair)
        error('FixGridRemove3D_v3:AutoPeakFail', ...
            'Could not find a reliable non-collinear first-order pair.');
    end

    guess = bestPair;
end

function guess = manualPeakGuess(A, figBase)
    [nr, nc] = size(A);
    cx = (nr + 1) / 2;
    cy = (nc + 1) / 2;

    figure(figBase); clf;
    imagesc((1:nc)-cy, (1:nr)-cx, A);
    axis image;
    set(gca, 'YDir', 'normal');
    colorbar;
    title('Click the 2 first-order peaks');
    xlabel('FFT col offset');
    ylabel('FFT row offset');
    drawnow;

    [xClick, yClick] = getpts;
    if numel(xClick) < 2
        error('FixGridRemove3D_v3:ManualPeakFail', 'Need two clicks.');
    end
    guess = [xClick(1), yClick(1); xClick(2), yClick(2)];
end

function p = refineFFTpeak(A, xClick, yClick, searchRad, fitRad)
    [nr, nc] = size(A);
    cx = (nr + 1) / 2;
    cy = (nc + 1) / 2;

    r0 = yClick + cx;
    c0 = xClick + cy;

    r1 = max(1, round(r0 - searchRad));
    r2 = min(nr, round(r0 + searchRad));
    c1 = max(1, round(c0 - searchRad));
    c2 = min(nc, round(c0 + searchRad));

    patch = A(r1:r2, c1:c2);
    [~, imax] = max(patch(:));
    [rp, cp] = ind2sub(size(patch), imax);
    rMax = r1 + rp - 1;
    cMax = c1 + cp - 1;

    rr1 = max(1, rMax - fitRad);
    rr2 = min(nr, rMax + fitRad);
    cc1 = max(1, cMax - fitRad);
    cc2 = min(nc, cMax + fitRad);

    local = A(rr1:rr2, cc1:cc2);
    [R, C] = ndgrid(rr1:rr2, cc1:cc2);

    dx = C(:) - cMax;
    dy = R(:) - rMax;
    z = local(:);

    G = [dx.^2, dy.^2, dx.*dy, dx, dy, ones(size(dx))];
    coef = G \ z;

    H = [2*coef(1), coef(3); coef(3), 2*coef(2)];
    g = [coef(4); coef(5)];

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
    rRef = sum(R(:).*w(:)) / sum(w(:));
    cRef = sum(C(:).*w(:)) / sum(w(:));
    p = [cRef - cy, rRef - cx];
end

function val = sampleCenteredFFT(A, x, y)
    [nr, nc] = size(A);
    cx = (nr + 1) / 2;
    cy = (nc + 1) / 2;

    rq = y + cx;
    cq = x + cy;

    if rq < 1 || rq > nr || cq < 1 || cq > nc
        val = nan;
        return;
    end

    [C, R] = meshgrid(1:nc, 1:nr);
    val = interp2(C, R, A, cq, rq, 'linear', nan);
end

% =========================
% Reference debug figure
% =========================

function showReferenceDebugFigure(figNum, refPlane, Aref, mask, Afinal, refClean, initialPeaks, refinedPeaks, targetPeaks, B, plane, refMode)
    [nr, nc] = size(refPlane);
    cx = (nr + 1) / 2;
    cy = (nc + 1) / 2;

    figure(figNum); clf;
    tiledlayout(2,3, 'Padding', 'compact', 'TileSpacing', 'compact');

    nexttile;
    imagesc(plane.vAxis, plane.uAxis, refPlane);
    axis image;
    set(gca, 'YDir', 'normal');
    title(['Reference plane (', refMode, ')']);
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
        plot(targetPeaks(:,1), targetPeaks(:,2), 'c.', 'MarkerSize', 10);
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
        plot(targetPeaks(:,1), targetPeaks(:,2), 'c.', 'MarkerSize', 10);
    end

    nexttile;
    imagesc(plane.vAxis, plane.uAxis, refClean);
    axis image;
    set(gca, 'YDir', 'normal');
    title('Reference plane after removal');
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

% =========================
% Plane helpers
% =========================

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
            error('FixGridRemove3D_v3:BadDirection', 'direction must be x/y/z.');
    end
end

function refPlane = buildReferencePlane(V, plane, refMode, refSliceIndex, refMatrix)
    switch refMode
        case 'average'
            refPlane = squeeze(meanIgnoreNaN(V, plane.stackDim));
        case 'slice'
            if isempty(refSliceIndex)
                error('FixGridRemove3D_v3:MissingRefSliceIndex', ...
                    'Provide opts.refSliceIndex for refMode=''slice''.');
            end
            refPlane = extractSlice(V, round(refSliceIndex), plane);
        case 'matrix'
            if isempty(refMatrix) || ~isnumeric(refMatrix) || ndims(refMatrix) ~= 2
                error('FixGridRemove3D_v3:BadRefMatrix', ...
                    'Provide opts.refMatrix for refMode=''matrix''.');
            end
            refPlane = double(refMatrix);
            if ~isequal(size(refPlane), [numel(plane.uAxis), numel(plane.vAxis)])
                if isequal(size(refPlane), [numel(plane.vAxis), numel(plane.uAxis)])
                    refPlane = refPlane.';
                else
                    error('FixGridRemove3D_v3:RefMatrixSizeMismatch', ...
                        'refMatrix size does not match plane size.');
                end
            end
        otherwise
            error('FixGridRemove3D_v3:BadRefMode', ...
                'refMode must be average/slice/matrix.');
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
            error('FixGridRemove3D_v3:BadStackDim', 'Invalid stack dimension.');
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
            error('FixGridRemove3D_v3:BadStackDim', 'Invalid stack dimension.');
    end
end

% =========================
% Small helpers
% =========================

function Vout = fillMissing2D(Vin, x, y)
    Vout = Vin;
    m = isfinite(Vin);
    if all(m(:))
        return;
    end
    if nnz(m) < 4
        Vout(~m) = 0;
        return;
    end
    [X, Y] = ndgrid(x, y);
    F = scatteredInterpolant(X(m), Y(m), Vin(m), 'linear', 'nearest');
    Vout = F(X, Y);
    Vout(~isfinite(Vout)) = 0;
end

function M = meanIgnoreNaN(A, dim)
    m = isfinite(A);
    A(~m) = 0;
    n = sum(m, dim);
    M = sum(A, dim) ./ max(n, 1);
    M(n == 0) = 0;
end

function w = cosineWindow(n)
    if n <= 1
        w = ones(n,1);
        return;
    end
    t = (0:n-1).' / (n-1);
    w = 0.5 - 0.5*cos(2*pi*t);
end

function m = localMax2D(A)
    [nr, nc] = size(A);
    P = -inf(nr+2, nc+2);
    P(2:nr+1, 2:nc+1) = A;
    m = true(nr, nc);
    for dx = -1:1
        for dy = -1:1
            if dx == 0 && dy == 0
                continue;
            end
            m = m & (A > P(2+dx:nr+1+dx, 2+dy:nc+1+dy));
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