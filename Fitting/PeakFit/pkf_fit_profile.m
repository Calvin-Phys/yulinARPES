function R = pkf_fit_profile(u, I, peaks, varargin)
%PKF_FIT_PROFILE  Bounded multi-peak fit of one MDC or EDC (base MATLAB).
%   R = PKF_FIT_PROFILE(u, I, peaks) fits the sum of pseudo-Voigt peaks
%   (PKF_LINESHAPE) on a linear background c0 + c1*(u - uMid), optionally
%   multiplied by a Fermi-Dirac cutoff (PKF_FERMI). PEAKS is a struct array
%   (one element per peak) with required field centre and optional fields
%     fwhm, height, eta      start values (NaN/missing: PKF_INITIAL_GUESS)
%     fixCentre, fixFWHM     hold the start value exactly (default false)
%     lo, hi                 extra centre bounds (default -Inf / Inf)
%
%   Name-value options:
%     'Shape'          'Lorentzian' (eta = 1, default), 'Gaussian' (eta = 0)
%                      or 'Pseudo-Voigt' (eta free in [0, 1])
%     'FlatBackground' true holds the slope c1 at 0 (default false)
%     'Background'     [c0 c1] start values (default: automatic)
%     'Window'         [lo hi] profile window; points outside are ignored
%                      (default: all finite points). uMid is its centre.
%     'Fermi'          struct('enabled',tf,'EF',eV,'T',K); EF and T are held
%     'Weights'        'none' (default) or 'poisson' (1/sqrt(max(I,1)))
%     'MaxIter'        Levenberg-Marquardt iteration limit (default 200)
%
%   Bounds are enforced at every step: centre within the window and [lo hi];
%   FWHM within [half the median sample step, twice the window span];
%   height >= 0; 0 <= eta <= 1. Held values are used exactly as given.
%
%   R fields: ok, message, converged, iterations, warnings, shape, window,
%   uMid, fermi, peaks (centre, fwhm, height, eta and err_* = 1-sigma),
%   background [c0 c1], err_background, u, I, fit, components, bg_curve,
%   residual (I - fit), rss, dof, chi2_red, r2, nPoints, free.
%   1-sigma errors come from the Jacobian at the solution, scaled by the
%   reduced chi-square (unweighted: residual variance). NaN/Inf points are
%   dropped; when too few finite points remain, R.ok is false, parameters
%   keep their start values, and errors and fit statistics are NaN.

o = parseOptions(varargin{:});
u = double(u(:)); I = double(real(I(:)));
if numel(u) ~= numel(I)
    error('PeakFit:SizeMismatch', 'u and I must have the same number of elements.');
end
peaks = normalisePeaks(peaks);
okPts = isfinite(u) & isfinite(I);
if isempty(o.Window)
    if any(okPts), win = [min(u(okPts)) max(u(okPts))]; else, win = [min(u) max(u)]; end
else
    win = sort(double(o.Window(:))).';
end
okPts = okPts & u >= win(1) & u <= win(2);
uf = u(okPts); If = I(okPts);
[uf, order] = sort(uf); If = If(order);
uMid = mean(win);
opts = struct('uMid', uMid, 'Fermi', o.Fermi);

np = numel(peaks);
switch o.Shape
    case 'Lorentzian', etaFixed = 1;
    case 'Gaussian', etaFixed = 0;
    otherwise, etaFixed = [];
end

% ---- start values ----
needGuess = any(arrayfun(@(p) ~(isfinite(p.fwhm) && isfinite(p.height)), peaks)) || isempty(o.Background);
if needGuess && numel(uf) >= 2
    [g, bgGuess] = pkf_initial_guess(uf, If, [peaks.centre], 'Background', o.Background, 'uMid', uMid);
else
    g = peaks; bgGuess = [0 0];
    if ~isempty(o.Background), bgGuess = o.Background(:).'; end
end
for k = 1:np
    if ~isfinite(peaks(k).fwhm), peaks(k).fwhm = g(k).fwhm; end
    if ~isfinite(peaks(k).height), peaks(k).height = g(k).height; end
    if ~isempty(etaFixed)
        peaks(k).eta = etaFixed;
    elseif ~isfinite(peaks(k).eta)
        peaks(k).eta = 0.5;
    end
end
bg0 = bgGuess;
if o.FlatBackground, bg0(2) = 0; end

% ---- parameter vector, bounds, free mask ----
nPar = 4 * np + 2;
x0 = zeros(1, nPar); lb = -inf(1, nPar); ub = inf(1, nPar); free = true(1, nPar);
step = 0;
if numel(uf) >= 2, step = median(abs(diff(uf))); end
span = max(win(2) - win(1), eps);
wMin = max(step / 2, span * 1e-6); wMax = 2 * span;
rangeI = 1;
if ~isempty(If), rangeI = max(max(If) - min(If), eps); end
typical = ones(1, nPar);
for k = 1:np
    j = 4 * (k - 1);
    pk = peaks(k);
    if pk.fixFWHM && ~(pk.fwhm > 0)
        error('PeakFit:InvalidParameter', 'Peak %d: a held FWHM must be > 0.', k);
    end
    x0(j + (1:4)) = [pk.centre pk.fwhm pk.height pk.eta];
    lb(j + 1) = max(win(1), pk.lo); ub(j + 1) = min(win(2), pk.hi);
    if lb(j + 1) > ub(j + 1)
        error('PeakFit:InvalidBounds', 'Peak %d: the centre bounds do not overlap the fit window.', k);
    end
    lb(j + 2) = wMin; ub(j + 2) = wMax;
    lb(j + 3) = 0;
    lb(j + 4) = 0; ub(j + 4) = 1;
    free(j + 1) = ~pk.fixCentre;
    free(j + 2) = ~pk.fixFWHM;
    free(j + 4) = isempty(etaFixed);
    for q = find(free(j + (1:4)))
        x0(j + q) = min(max(x0(j + q), lb(j + q)), ub(j + q));
    end
    typical(j + (1:4)) = [max(pk.fwhm, step + eps), max(pk.fwhm, step + eps), max(abs(pk.height), rangeI), 1];
end
x0(end - 1:end) = bg0;
free(end) = ~o.FlatBackground;
typical(end - 1:end) = [max(rangeI, abs(bg0(1))), max(rangeI / span, eps)];
typical(~isfinite(typical) | typical <= 0) = 1;

R = emptyResult(o, win, uMid, uf, If, free);
nFree = nnz(free);
if numel(uf) < nFree + 1
    R.message = sprintf('Only %d finite point(s) in the window for %d free parameter(s); slice not fitted.', ...
        numel(uf), nFree);
    R.peaks = unpackPeaks(x0, nan(1, nPar), np);
    R.background = x0(end - 1:end);
    return
end
if strcmp(o.Weights, 'poisson')
    wts = 1 ./ sqrt(max(If, 1));
else
    wts = ones(size(If));
end
resfun = @(x) (modelVec(x, uf, np, opts) - If) .* wts;

[x, iter, converged] = levenberg_marquardt(resfun, x0, free, lb, ub, typical, o.MaxIter);
r = resfun(x);
J = jacobian(resfun, x, r, lb, ub, typical, free);
rss = sum(r.^2);
dof = numel(uf) - nFree;
err = nan(1, nPar);
if dof > 0
    s2 = rss / dof;
    Jf = J(:, free);
    C = pinv(Jf' * Jf) * s2;
    err(free) = sqrt(max(diag(C), 0)).';
end
err(~free) = 0;

[fitv, comps, bgc] = pkf_model(uf, unpackPeaks(x, err, np), x(end - 1:end), opts);
R.peaks = unpackPeaks(x, err, np);
R.background = x(end - 1:end);
R.err_background = err(end - 1:end);
R.fit = fitv; R.components = comps; R.bg_curve = bgc;
R.residual = If - fitv;
R.rss = rss; R.dof = dof;
R.chi2_red = rss / max(dof, 1);
R.r2 = 1 - sum((If - fitv).^2) / max(sum((If - mean(If)).^2), realmin);
R.iterations = iter; R.converged = converged;
R.ok = all(isfinite(x)) && isfinite(rss);
if R.ok, R.message = 'Fitted.'; else, R.message = 'Fit produced non-finite values.'; end
names = {'centre', 'FWHM', 'height', 'eta'};
for q = find(free(1:4 * np) & (x(1:4 * np) <= lb(1:4 * np) | x(1:4 * np) >= ub(1:4 * np)))
    k = ceil(q / 4);
    R.warnings{end + 1} = sprintf('Peak %d %s reached its bound (%g).', k, names{q - 4 * (k - 1)}, x(q));
end
if ~converged
    R.warnings{end + 1} = 'The optimiser stopped at the iteration limit before converging.';
end
end

% -------------------------------------------------------------------------
function y = modelVec(x, u, np, opts)
y = pkf_model(u, unpackPeaks(x, [], np), x(end - 1:end), opts);
end

function P = unpackPeaks(x, err, np)
P = struct('centre', cell(1, np), 'fwhm', [], 'height', [], 'eta', [], ...
    'err_centre', NaN, 'err_fwhm', NaN, 'err_height', NaN, 'err_eta', NaN);
for k = 1:np
    j = 4 * (k - 1);
    P(k).centre = x(j + 1); P(k).fwhm = x(j + 2); P(k).height = x(j + 3); P(k).eta = x(j + 4);
    if ~isempty(err)
        P(k).err_centre = err(j + 1); P(k).err_fwhm = err(j + 2);
        P(k).err_height = err(j + 3); P(k).err_eta = err(j + 4);
    end
end
end

function R = emptyResult(o, win, uMid, uf, If, free)
R = struct('ok', false, 'message', '', 'converged', false, 'iterations', 0, ...
    'warnings', {{}}, 'shape', o.Shape, 'window', win, 'uMid', uMid, 'fermi', o.Fermi, ...
    'peaks', [], 'background', [NaN NaN], 'err_background', [NaN NaN], ...
    'u', uf, 'I', If, 'fit', nan(size(uf)), 'components', [], 'bg_curve', nan(size(uf)), ...
    'residual', nan(size(uf)), 'rss', NaN, 'dof', NaN, 'chi2_red', NaN, 'r2', NaN, ...
    'nPoints', numel(uf), 'free', free);
end

function peaks = normalisePeaks(peaks)
if isempty(peaks) || ~isstruct(peaks) || ~isfield(peaks, 'centre')
    error('PeakFit:NoPeaks', 'Give at least one peak (struct array with field centre).');
end
template = struct('centre', NaN, 'fwhm', NaN, 'height', NaN, 'eta', NaN, ...
    'fixCentre', false, 'fixFWHM', false, 'lo', -Inf, 'hi', Inf);
f = setdiff(fieldnames(template), {'centre'}, 'stable');
out = repmat(template, 1, numel(peaks));
for k = 1:numel(peaks)
    c = peaks(k).centre;
    if ~(isnumeric(c) && isscalar(c) && isfinite(c))
        error('PeakFit:InvalidParameter', 'Peak %d: centre must be a finite scalar.', k);
    end
    out(k).centre = double(c);
    for q = 1:numel(f)
        if isfield(peaks, f{q}) && ~isempty(peaks(k).(f{q}))
            out(k).(f{q}) = peaks(k).(f{q});
        end
    end
    out(k).fixCentre = logical(out(k).fixCentre);
    out(k).fixFWHM = logical(out(k).fixFWHM);
    if isnan(out(k).lo), out(k).lo = -Inf; end
    if isnan(out(k).hi), out(k).hi = Inf; end
end
peaks = out;
end

function o = parseOptions(varargin)
p = inputParser;
p.FunctionName = 'pkf_fit_profile';
p.addParameter('Shape', 'Lorentzian');
p.addParameter('FlatBackground', false, @(v) islogical(v) || isnumeric(v));
p.addParameter('Background', [], @(v) isempty(v) || (isnumeric(v) && numel(v) == 2 && all(isfinite(v))));
p.addParameter('Window', [], @(v) isempty(v) || (isnumeric(v) && numel(v) == 2 && all(isfinite(v)) && v(1) ~= v(2)));
p.addParameter('Fermi', struct('enabled', false, 'EF', 0, 'T', 0), @isstruct);
p.addParameter('Weights', 'none', @(v) any(strcmpi(v, {'none', 'poisson'})));
p.addParameter('MaxIter', 200, @(v) isnumeric(v) && isscalar(v) && v >= 1);
p.parse(varargin{:});
o = p.Results;
o.Shape = pkf_shape(o.Shape);
o.FlatBackground = logical(o.FlatBackground);
o.Weights = lower(o.Weights);
F = struct('enabled', false, 'EF', 0, 'T', 0);
for f = fieldnames(o.Fermi).'
    if ~isfield(F, f{1})
        error('PeakFit:UnknownOption', 'Unknown Fermi field "%s" (use enabled, EF, T).', f{1});
    end
    F.(f{1}) = o.Fermi.(f{1});
end
F.enabled = logical(F.enabled);
if F.enabled && ~(isnumeric(F.EF) && isscalar(F.EF) && isfinite(F.EF) && isnumeric(F.T) && isscalar(F.T) && F.T > 0 && isfinite(F.T))
    error('PeakFit:InvalidFermi', 'The Fermi cutoff needs a finite EF (eV) and a temperature T > 0 K.');
end
o.Fermi = F;
end

function [x, iter, converged] = levenberg_marquardt(resfun, x, free, lb, ub, typical, maxIter)
% Damped Gauss-Newton on the scaled free parameters with box clamping.
lambda = 1e-3;
ws = warning('off', 'MATLAB:nearlySingularMatrix');
ws(2) = warning('off', 'MATLAB:singularMatrix');
restore = onCleanup(@() warning(ws));
r = resfun(x);
rss = sum(r.^2);
converged = false;
iter = 0;
if ~any(free), converged = true; return; end
J = jacobian(resfun, x, r, lb, ub, typical, free);
for iter = 1:maxIter
    Jf = J(:, free) .* typical(free);
    A = Jf' * Jf;
    gvec = Jf' * r;
    improved = false;
    while lambda < 1e12
        M = A + lambda * diag(max(diag(A), 1e-12 * max(diag(A)) + realmin));
        stepv = -(M \ gvec)';
        xt = x;
        xt(free) = min(max(x(free) + stepv .* typical(free), lb(free)), ub(free));
        rt = resfun(xt);
        rsst = sum(rt.^2);
        if isfinite(rsst) && rsst < rss
            improved = true;
            break
        end
        lambda = lambda * 10;
    end
    if ~improved
        converged = true;
        break
    end
    relDrop = (rss - rsst) / max(rss, realmin);
    dx = abs(xt - x) ./ typical;
    x = xt; r = rt; rss = rsst;
    lambda = max(lambda / 10, 1e-12);
    J = jacobian(resfun, x, r, lb, ub, typical, free);
    if relDrop < 1e-12 || max(dx(free)) < 1e-10
        converged = true;
        break
    end
end
end

function J = jacobian(resfun, x, r0, lb, ub, typical, free)
J = zeros(numel(r0), numel(x));
for k = find(free)
    h = 1e-6 * max(abs(x(k)), typical(k));
    xp = x; xm = x;
    xp(k) = min(x(k) + h, ub(k));
    xm(k) = max(x(k) - h, lb(k));
    if xp(k) == xm(k), continue; end
    J(:, k) = (resfun(xp) - resfun(xm)) / (xp(k) - xm(k));
end
end
