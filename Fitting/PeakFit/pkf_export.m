function S = pkf_export(T, D, varargin)
%PKF_EXPORT  Package PeakFit results as a workspace-friendly struct.
%   S = PKF_EXPORT(T, D) converts a tracking result T (PKF_TRACK) for the
%   cut D (PKF_INPUT) into a struct. S = PKF_EXPORT(R, D, 'SliceValue', s)
%   accepts a single-slice result R (PKF_FIT_PROFILE) fitted at slice s.
%   Optional 'Direction' (needed for R; T carries its own) and 'HalfWidth'.
%
%   Coordinates: for every peak, x is along the data x axis and y along the
%   data y axis, as for EmassFitting and the legacy fit_MDC_demo export:
%     MDC: x = fitted centre (momentum/angle), y = slice energy
%     EDC: x = slice momentum/angle,          y = fitted centre (energy)
%   Only accepted slices (T.valid) enter x, y and the per-peak vectors.
%
%   S fields: source_name, source_class, direction, model, flat_background,
%   fermi, slice_axis, profile_axis, slice_values, integration_halfwidth,
%   window, background (c0, c1, err_c0, err_c1), chi2_red, r2, ok, peaks
%   (1 x n struct: x, y, slice, centre, fwhm, height, eta, err.centre,
%   err.fwhm, err.height, err.eta, valid), x and y (copies of peak 1 so a
%   one-peak export can be passed to EmassFitting directly), units and
%   created. Widths are FWHM in profile-axis units (fit_MDC_demo stored
%   the half width w = FWHM/2).

p = inputParser;
p.addParameter('SliceValue', [], @(v) isempty(v) || (isnumeric(v) && isscalar(v)));
p.addParameter('Direction', '');
p.addParameter('HalfWidth', 0);
p.parse(varargin{:});
o = p.Results;
if isfield(T, 'rss')          % single-slice result -> one-row track
    if isempty(o.SliceValue) || isempty(o.Direction)
        error('PeakFit:InvalidExport', 'A single-slice result needs ''SliceValue'' and ''Direction''.');
    end
    T = fromSingle(T, pkf_direction(o.Direction), o.SliceValue, o.HalfWidth);
end
np = size(T.centre, 2);
if strcmp(T.direction, 'MDC')
    sliceLabel = D.yLabel; profileLabel = D.xLabel;
else
    sliceLabel = D.xLabel; profileLabel = D.yLabel;
end
S = struct();
S.source_name = D.name;
S.source_class = D.sourceClass;
S.direction = T.direction;
S.model = T.shape;
S.flat_background = T.flat_background;
S.fermi = T.fermi;
S.slice_axis = sliceLabel;
S.profile_axis = profileLabel;
S.slice_values = T.slice_values(:);
S.integration_halfwidth = T.halfWidth;
S.window = T.window;
S.background = struct('c0', T.c0, 'c1', T.c1, 'err_c0', T.err_c0, 'err_c1', T.err_c1);
S.chi2_red = T.chi2_red;
S.r2 = T.r2;
S.ok = T.ok;
peaks = struct('x', cell(1, np), 'y', [], 'slice', [], 'centre', [], 'fwhm', [], ...
    'height', [], 'eta', [], 'err', [], 'valid', []);
for k = 1:np
    v = T.valid(:, k);
    sv = T.slice_values(v); c = T.centre(v, k);
    if strcmp(T.direction, 'MDC'), px = c; py = sv; else, px = sv; py = c; end
    peaks(k).x = px(:); peaks(k).y = py(:); peaks(k).slice = sv(:);
    peaks(k).centre = c(:);
    peaks(k).fwhm = T.fwhm(v, k); peaks(k).height = T.height(v, k); peaks(k).eta = T.eta(v, k);
    peaks(k).err = struct('centre', T.err_centre(v, k), 'fwhm', T.err_fwhm(v, k), ...
        'height', T.err_height(v, k), 'eta', T.err_eta(v, k));
    peaks(k).valid = v;
end
S.peaks = peaks;
if np >= 1
    S.x = peaks(1).x; S.y = peaks(1).y;
else
    S.x = zeros(0, 1); S.y = zeros(0, 1);
end
S.units = sprintf('centre/fwhm in %s; slice in %s; height and background in data units', ...
    profileLabel, sliceLabel);
S.created = char(datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss'));
end

function T = fromSingle(R, direction, sliceValue, halfWidth)
np = numel(R.peaks);
T = struct('direction', direction, 'shape', R.shape, 'flat_background', R.free(end) == 0, ...
    'fermi', R.fermi, 'window', R.window, 'halfWidth', halfWidth, 'slice_values', sliceValue);
f = {'centre', 'fwhm', 'height', 'eta', 'err_centre', 'err_fwhm', 'err_height', 'err_eta'};
for q = 1:numel(f), T.(f{q}) = nan(1, np); end
for k = 1:np
    for q = 1:numel(f), T.(f{q})(k) = R.peaks(k).(f{q}); end
end
T.c0 = R.background(1); T.c1 = R.background(2);
T.err_c0 = R.err_background(1); T.err_c1 = R.err_background(2);
T.chi2_red = R.chi2_red; T.r2 = R.r2; T.ok = R.ok;
T.valid = repmat(R.ok, 1, np);
end
