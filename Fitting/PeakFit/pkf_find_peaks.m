function [centres, prominence] = pkf_find_peaks(u, I, varargin)
%PKF_FIND_PEAKS  Suggest peak centres in a profile (base MATLAB islocalmax).
%   [centres, prominence] = PKF_FIND_PEAKS(u, I) returns up to 6 local
%   maxima, sorted by position, whose prominence exceeds 10 % of the data
%   range. Name-value options:
%     'Prominence'    minimum prominence as a fraction of max(I)-min(I)
%                     (default 0.1)
%     'MaxPeaks'      keep at most this many, the most prominent (default 6)
%     'Window'        [lo hi] restrict the search to this profile window
%     'Smooth'        moving-average length in samples used only for the
%                     search (default: ~2 % of the points, at least 1)
%     'MinSeparation' minimum distance between suggestions in u units
%                     (default 0)
%   The data are not changed; smoothing is never used for fitting.

p = inputParser;
p.addParameter('Prominence', 0.1, @(v) isnumeric(v) && isscalar(v) && v >= 0 && v <= 1);
p.addParameter('MaxPeaks', 6, @(v) isnumeric(v) && isscalar(v) && v >= 1);
p.addParameter('Window', [], @(v) isempty(v) || (isnumeric(v) && numel(v) == 2));
p.addParameter('Smooth', [], @(v) isempty(v) || (isnumeric(v) && isscalar(v) && v >= 1));
p.addParameter('MinSeparation', 0, @(v) isnumeric(v) && isscalar(v) && v >= 0);
p.parse(varargin{:});
o = p.Results;

u = double(u(:)); I = double(I(:));
ok = isfinite(u) & isfinite(I);
if ~isempty(o.Window), ok = ok & u >= min(o.Window) & u <= max(o.Window); end
u = u(ok); I = I(ok);
[u, order] = unique(u); I = I(order);
centres = zeros(1, 0); prominence = zeros(1, 0);
if numel(u) < 3, return; end
n = o.Smooth;
if isempty(n), n = max(1, round(numel(u) / 50)); end
Is = smoothdata(I, 'movmean', n);
range = max(Is) - min(Is);
if ~(range > 0), return; end
[tf, P] = islocalmax(Is, 'MinProminence', o.Prominence * range, ...
    'MinSeparation', o.MinSeparation, 'SamplePoints', u);
idx = find(tf);
if isempty(idx), return; end
[~, rank] = sort(P(idx), 'descend');
idx = idx(rank(1:min(numel(idx), round(o.MaxPeaks))));
idx = sort(idx);
centres = u(idx).';
prominence = P(idx).';
end
