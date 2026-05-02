function [data_nu, data_fft, data_fft_full_inan_remove] = FixGridRemove_v2(data)
%FIXGRIDREMOVE Automatically remove grid-like background using FFT notch filtering.
%
% Same input/output interface as the legacy version, but:
%   - no manual clicking / no getpts
%   - no hard FFT bin deletion
%   - uses automatic peak detection
%   - uses smooth Gaussian notch masks
%   - inverse transform is done correctly with ifftshift
%
% Inputs
%   data.x      : x coordinate vector
%   data.y      : y coordinate vector
%   data.value  : 2D matrix, expected size [numel(data.x), numel(data.y)]
%
% Outputs
%   data_nu                     : grid-removed real-space data
%   data_fft                    : log-magnitude FFT of the original data
%   data_fft_full_inan_remove    : log-magnitude FFT after grid removal

    % ----------------------------
    % Basic validation / shaping
    % ----------------------------
    if (~isfield(data, 'value') || ~isfield(data, 'x') || ~isfield(data, 'y')) && ...
            (~isprop(data, 'value') || ~isprop(data, 'x') || ~isprop(data, 'y'))
        error('FixGridRemove:InvalidInput', 'Input must contain fields x, y, and value.');
    end

    x = data.x(:);
    y = data.y(:);
    V = double(data.value);

    nx = numel(x);
    ny = numel(y);

    % Accept either [nx, ny] or transposed [ny, nx]
    if isequal(size(V), [nx, ny])
        % ok
    elseif isequal(size(V), [ny, nx])
        V = V.';
    else
        error('FixGridRemove:SizeMismatch', ...
            'data.value must have size [numel(data.x), numel(data.y)] or its transpose.');
    end

    data_nu = data;
    data_fft = data;
    data_fft_full_inan_remove = data;

    % ----------------------------
    % Fill missing values robustly
    % ----------------------------
    V = fillMissing2D(V, x, y);

    % ----------------------------
    % Build a gentle apodization window for peak detection only
    % ----------------------------
    wx = cosineWindow(nx);
    wy = cosineWindow(ny);
    W = wx * wy.';  % [nx, ny]
    Vdet = V .* W;

    % ----------------------------
    % FFT for detection and for output
    % ----------------------------
    Fdet = fftshift(fft2(Vdet));
    F0   = fftshift(fft2(V));

    A = log1p(abs(Fdet));
    data_fft.value = A;

    % ----------------------------
    % Detect grid basis automatically
    % ----------------------------
    model = estimateLatticeModel(A);

    % If no reliable lattice found, return original data and FFTs
    if isempty(model) || ~isfield(model, 'B') || any(~isfinite(model.B(:)))
        data_nu.value = real(V);
        data_fft_full_inan_remove.value = log1p(abs(F0));
        return;
    end

    B = model.B;  % 2x2 reciprocal-lattice basis in FFT index coordinates

    % ----------------------------
    % Build smooth notch mask
    % ----------------------------
    [U, Vc] = ndgrid((1:nx) - (nx + 1) / 2, (1:ny) - (ny + 1) / 2);

    % Parameters that control suppression strength
    sigmaPix = max(1.25, 0.08 * min(norm(B(:,1)), norm(B(:,2))));
    notchDepth = 0.98;
    minMask = 0.02;

    maxOrder = 4;
    if isfield(model, 'maxOrder') && isfinite(model.maxOrder)
        maxOrder = max(3, min(8, round(model.maxOrder)));
    end

    orders = -maxOrder:maxOrder;
    [aa, bb] = ndgrid(orders, orders);
    orderList = [aa(:), bb(:)];
    orderList(all(orderList == 0, 2), :) = [];

    targetPeaks = B * orderList.';  % 2 x Ntargets

    atten = zeros(nx, ny);

    for k = 1:size(targetPeaks, 2)
        pk = targetPeaks(:, k);

        % Skip the DC neighborhood
        if hypot(pk(1), pk(2)) < 0.5
            continue;
        end

        % Skip targets outside the useful FFT area
        if abs(pk(1)) > nx/2 + 2 || abs(pk(2)) > ny/2 + 2
            continue;
        end

        d2 = (U - pk(1)).^2 + (Vc - pk(2)).^2;
        notch = notchDepth * exp(-d2 / (2 * sigmaPix^2));
        atten = max(atten, notch);
    end

    mask = max(minMask, 1 - atten);

    % Apply mask in Fourier space
    Ffilt = F0 .* mask;

    % Enforce Hermitian symmetry to keep the inverse transform real-valued
    Ffilt = 0.5 * (Ffilt + conj(flipud(fliplr(Ffilt))));

    % ----------------------------
    % Back to real space
    % ----------------------------
    Vclean = real(ifft2(ifftshift(Ffilt)));

    data_nu.value = Vclean;

    % For display / inspection
    data_fft_full_inan_remove.value = log1p(abs(Ffilt));
end

% ========================================================================
% Helper functions
% ========================================================================

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

function model = estimateLatticeModel(A)
    % Estimate a 2D reciprocal lattice basis from FFT magnitude peaks.
    % Returns empty if no reliable basis is found.

    model = [];

    [nx, ny] = size(A);
    cx = (nx + 1) / 2;
    cy = (ny + 1) / 2;

    [U, Vc] = ndgrid((1:nx) - cx, (1:ny) - cy);

    % Suppress the DC neighborhood
    rCenter = max(4, round(0.04 * min(nx, ny)));
    centerMask = hypot(U, Vc) <= rCenter;

    % Local maxima detection without toolbox dependencies
    peakMask = localMax2D(A);
    peakMask(centerMask) = false;

    candIdx = find(peakMask);
    if isempty(candIdx)
        return;
    end

    candVals = A(candIdx);
    [candVals, ord] = sort(candVals, 'descend');
    candIdx = candIdx(ord);

    % Keep only a limited number of the strongest candidates
    maxCand = min(80, numel(candIdx));
    candIdx = candIdx(1:maxCand);
    candVals = candVals(1:maxCand);

    % Mild amplitude threshold based on robust spread
    flatA = A(isfinite(A));
    medA = median(flatA);
    madA = median(abs(flatA - medA));
    if madA <= 0
        madA = std(flatA);
    end
    thr = medA + 4 * madA;

    strong = candVals >= thr;
    if nnz(strong) >= 4
        candIdx = candIdx(strong);
        candVals = candVals(strong);
    end

    if numel(candIdx) < 2
        return;
    end

    [ri, ci] = ind2sub(size(A), candIdx);
    pos = [ri(:).' - cx; ci(:).' - cy];  % 2 x Ncand

    % Remove tiny-radius candidates
    r = hypot(pos(1,:), pos(2,:));
    keep = r >= rCenter;
    pos = pos(:, keep);
    candVals = candVals(keep);

    if size(pos, 2) < 2
        return;
    end

    % Choose a non-collinear pair among the strongest candidates
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

            % Prefer strong, low-order peaks with good angular separation
            score = sqrt(candVals(i) * candVals(j)) * sinAng / (1 + 0.15 * (n1 + n2));
            if score > bestScore
                bestScore = score;
                iBest = i;
                jBest = j;
            end
        end
    end

    if isnan(iBest) || isnan(jBest)
        return;
    end

    B = [pos(:, iBest), pos(:, jBest)];

    % Refine using all candidate peaks that fit integer combinations well
    orderLimit = 8;
    tolPix = 1.5;

    for iter = 1:2
        if rcond(B) < 1e-8
            return;
        end

        coeff = round(B \ pos);              % 2 x Ncand
        resid = vecnorm(pos - B * coeff, 2, 1);

        inlier = resid <= tolPix & max(abs(coeff), [], 1) <= orderLimit;

        if nnz(inlier) < 2
            break;
        end

        P = pos(:, inlier);
        N = coeff(:, inlier);

        w = candVals(inlier);
        w = w / max(w);
        sw = sqrt(w);

        % Weighted least squares: B * N ~= P
        P = pos(:, inlier);
        N = coeff(:, inlier);

        w = candVals(inlier);
        w = w / max(w);
        sw = sqrt(w(:)).';   % 1 x M

        % Weighted least squares:
        % minimize || (P - B*N) .* sqrt(w) ||_F
        Pw = P .* sw;        % 2 x M
        Nw = N .* sw;        % 2 x M

        den = Nw * Nw.';     % 2 x 2
        if rcond(den) < 1e-12
            break;
        end

        Bnew = (Pw * Nw.') / den;   % 2 x 2

        if rcond(Bnew) < 1e-8 || any(~isfinite(Bnew(:)))
            break;
        end

        B = Bnew;
    end

    if any(~isfinite(B(:))) || abs(det(B)) < 1e-6
        return;
    end

    model.B = B;
    model.maxOrder = orderLimit;
end

function m = localMax2D(A)
    % True local maxima in 8-neighborhood, with padding to avoid wrap-around.
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