function T = pkf_track(D, peaks, varargin)
%PKF_TRACK  Fit peaks slice by slice, walking both ways from a start slice.
%   T = PKF_TRACK(D, peaks, Name, Value, ...) fits the profiles of a cut D
%   (see PKF_INPUT) with PKF_FIT_PROFILE. The start slice uses PEAKS as start
%   values (a single seed per peak is enough). The walk then moves to higher
%   and to lower slice indices; every slice starts from the last accepted
%   fit on that side. Name-value options:
%     'Direction'      'MDC' (default) or 'EDC'
%     'Start'          start slice position, slice-axis units (default: middle)
%     'Range'          [a b] slice-axis range to fit (default: whole axis)
%     'Step'           index stride between fitted slices (default 1)
%     'HalfWidth'      integration half-width, slice-axis units (default 0)
%     'Window'         [lo hi] profile window used for every slice
%     'Shape', 'FlatBackground', 'Fermi', 'Weights', 'Background'
%                      passed to PKF_FIT_PROFILE
%     'MaxJump'        flag a slice when a centre moves more than MaxJump
%                      times its start FWHM (default 1.5; Inf disables)
%     'StopAfter'      stop walking in one direction after this many
%                      consecutive rejected slices (default 5; Inf: never)
%     'Guides'         cell array, one element per peak, of [slice centre]
%                      rows (e.g. clicks on the image). Inside a guide's
%                      slice span the start centre is the pchip
%                      interpolation of its points.
%     'Progress'       @(done, total) called after each slice
%     'StopFcn'        @() returning true to stop early (checked per slice)
%
%   T has one row per slice in the range (ascending index) with fields
%   slice_values, slice_index, centre, fwhm, height, eta, err_centre,
%   err_fwhm, err_height, err_eta (rows x peaks), c0, c1, err_c0, err_c1,
%   chi2_red, r2, ok (fit succeeded), flagged (rows x peaks, centre jump),
%   valid (ok & ~flagged), attempted, message, plus the settings used,
%   start_index, stopped and nValid. Slices that were not fitted keep NaN.
%   A rejected slice (failed or flagged) never becomes the start of the next.

o = parseOptions(varargin{:});
if strcmp(o.Direction, 'MDC'), s = D.y; else, s = D.x; end
s = s(:);
if isempty(peaks) || ~isstruct(peaks) || ~isfield(peaks, 'centre')
    error('PeakFit:NoPeaks', 'Give at least one peak (struct array with field centre).');
end
for f = {'fwhm', 'height', 'eta'}
    if ~isfield(peaks, f{1}), [peaks.(f{1})] = deal(NaN); end
end
np = numel(peaks);
if isempty(o.Range), rng = [min(s) max(s)]; else, rng = sort(o.Range(:)).'; end
inRange = find(s >= rng(1) - 1e-12 * max(abs(s)) & s <= rng(2) + 1e-12 * max(abs(s)));
if isempty(inRange)
    error('PeakFit:EmptyRange', 'No slices lie within the requested range.');
end
if isempty(o.Start), startVal = mean(rng); else, startVal = o.Start; end
[~, k0] = min(abs(s(inRange) - startVal));
startIdx = inRange(k0);
[~, order] = sort(inRange);
inRange = inRange(order);
up = startIdx:o.Step:max(inRange);
down = startIdx - o.Step:-o.Step:min(inRange);
up = up(ismember(up, inRange)); down = down(ismember(down, inRange));
rows = sort(unique([up down]));
n = numel(rows);

T = struct();
T.direction = o.Direction; T.shape = o.Shape; T.flat_background = o.FlatBackground;
T.fermi = o.Fermi; T.window = o.Window; T.halfWidth = o.HalfWidth; T.range = rng;
T.max_jump = o.MaxJump; T.start_index = startIdx;
T.slice_index = rows(:); T.slice_values = s(rows);
z = nan(n, np);
T.centre = z; T.fwhm = z; T.height = z; T.eta = z;
T.err_centre = z; T.err_fwhm = z; T.err_height = z; T.err_eta = z;
T.c0 = nan(n, 1); T.c1 = nan(n, 1); T.err_c0 = nan(n, 1); T.err_c1 = nan(n, 1);
T.chi2_red = nan(n, 1); T.r2 = nan(n, 1);
T.ok = false(n, 1); T.flagged = false(n, np); T.attempted = false(n, 1);
T.message = repmat({''}, n, 1);
T.stopped = false;

fitArgs = {'Shape', o.Shape, 'FlatBackground', o.FlatBackground, 'Fermi', o.Fermi, 'Weights', o.Weights};
if ~isempty(o.Window), fitArgs = [fitArgs {'Window', o.Window}]; end
done = 0;
% Fit the start slice once, then walk up and down from its result.
[startPeaks, startBg, ok] = fitOne(startIdx, peaks, o.Background, true);
walks = {up(2:end), down};
for w = 1:2
    prevPeaks = startPeaks; prevBg = startBg;
    if ~ok, prevPeaks = peaks; prevBg = o.Background; end
    bad = 0;
    for idx = walks{w}
        if T.stopped, break; end
        [fp, fb, good] = fitOne(idx, prevPeaks, prevBg, false);
        if good
            prevPeaks = fp; prevBg = fb; bad = 0;
        else
            bad = bad + 1;
            if bad >= o.StopAfter, break; end
        end
    end
end
T.valid = T.ok & ~T.flagged;
T.nValid = nnz(all(T.valid, 2));

    function [fp, fb, good] = fitOne(idx, startPeaks, bgStart, isStart)
        fp = startPeaks; fb = bgStart; good = false;
        if ~isempty(o.StopFcn) && o.StopFcn()
            T.stopped = true;
            return
        end
        row = find(rows == idx, 1);
        [u, I] = pkf_extract_profile(D, o.Direction, s(idx), o.HalfWidth);
        seeds = startPeaks;
        for q = 1:np
            g = guideCentre(q, s(idx));
            if ~isempty(g), seeds(q).centre = g; end
        end
        R = pkf_fit_profile(u, I, seeds, fitArgs{:}, 'Background', bgStart);
        T.attempted(row) = true;
        T.message{row} = R.message;
        done = done + 1;
        if ~isempty(o.Progress), o.Progress(done, n); end
        if ~R.ok, return; end
        for q = 1:np
            P = R.peaks(q);
            T.centre(row, q) = P.centre; T.fwhm(row, q) = P.fwhm;
            T.height(row, q) = P.height; T.eta(row, q) = P.eta;
            T.err_centre(row, q) = P.err_centre; T.err_fwhm(row, q) = P.err_fwhm;
            T.err_height(row, q) = P.err_height; T.err_eta(row, q) = P.err_eta;
            w0 = seeds(q).fwhm;
            if ~isfinite(w0), w0 = P.fwhm; end
            T.flagged(row, q) = ~isStart && abs(P.centre - seeds(q).centre) > o.MaxJump * w0;
        end
        T.c0(row) = R.background(1); T.c1(row) = R.background(2);
        T.err_c0(row) = R.err_background(1); T.err_c1(row) = R.err_background(2);
        T.chi2_red(row) = R.chi2_red; T.r2(row) = R.r2;
        T.ok(row) = true;
        if any(T.flagged(row, :))
            T.message{row} = 'Rejected: a centre jumped by more than MaxJump x FWHM.';
            return
        end
        good = true;
        for q = 1:np
            fp(q).centre = R.peaks(q).centre; fp(q).fwhm = R.peaks(q).fwhm;
            fp(q).height = R.peaks(q).height; fp(q).eta = R.peaks(q).eta;
        end
        fb = R.background;
    end

    function c = guideCentre(q, sv)
        c = [];
        if numel(o.Guides) < q || isempty(o.Guides{q}), return; end
        G = sortrows(double(o.Guides{q}), 1);
        if size(G, 1) == 1
            if abs(G(1, 1) - sv) <= max(abs(diff(s))) / 2, c = G(1, 2); end
        elseif sv >= G(1, 1) && sv <= G(end, 1)
            [gs, iu] = unique(G(:, 1));
            if numel(gs) >= 2
                c = interp1(gs, G(iu, 2), sv, 'pchip');
            end
        end
    end
end

function o = parseOptions(varargin)
p = inputParser;
p.FunctionName = 'pkf_track';
p.addParameter('Direction', 'MDC');
p.addParameter('Start', [], @(v) isempty(v) || (isnumeric(v) && isscalar(v) && isfinite(v)));
p.addParameter('Range', [], @(v) isempty(v) || (isnumeric(v) && numel(v) == 2 && all(isfinite(v))));
p.addParameter('Step', 1, @(v) isnumeric(v) && isscalar(v) && v >= 1 && v == round(v));
p.addParameter('HalfWidth', 0, @(v) isnumeric(v) && isscalar(v) && v >= 0);
p.addParameter('Window', [], @(v) isempty(v) || (isnumeric(v) && numel(v) == 2));
p.addParameter('Shape', 'Lorentzian');
p.addParameter('FlatBackground', false);
p.addParameter('Fermi', struct('enabled', false, 'EF', 0, 'T', 0), @isstruct);
p.addParameter('Weights', 'none');
p.addParameter('Background', [], @(v) isempty(v) || (isnumeric(v) && numel(v) == 2));
p.addParameter('MaxJump', 1.5, @(v) isnumeric(v) && isscalar(v) && v > 0);
p.addParameter('StopAfter', 5, @(v) isnumeric(v) && isscalar(v) && v >= 1);
p.addParameter('Guides', {}, @iscell);
p.addParameter('Progress', [], @(v) isempty(v) || isa(v, 'function_handle'));
p.addParameter('StopFcn', [], @(v) isempty(v) || isa(v, 'function_handle'));
p.parse(varargin{:});
o = p.Results;
o.Direction = pkf_direction(o.Direction);
o.Shape = pkf_shape(o.Shape);
o.FlatBackground = logical(o.FlatBackground);
end
