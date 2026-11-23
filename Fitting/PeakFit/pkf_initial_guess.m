function [peaks, bg] = pkf_initial_guess(u, I, centres, varargin)
%PKF_INITIAL_GUESS  Data-driven start values for peaks at given centres.
%   [peaks, bg] = PKF_INITIAL_GUESS(u, I, centres) estimates a linear
%   background and, for each centre, the height above it and the FWHM from
%   the half-maximum crossings either side of the centre. Name-value options:
%     'Window'      [lo hi] profile window (default: all finite points)
%     'Background'  [c0 c1] to use instead of the automatic estimate
%     'uMid'        reference point of the background slope (default:
%                   middle of the window)
%     'Eta'         mixing value for the returned peaks (default 1)
%   The background estimate is the 10th percentile of the finite data (no
%   slope). FWHM values are limited to [half a sample step, window span]
%   and to the spacing of neighbouring centres, so close peaks do not start
%   wider than their separation.

p = inputParser;
p.addParameter('Window', [], @(v) isempty(v) || (isnumeric(v) && numel(v) == 2));
p.addParameter('Background', [], @(v) isempty(v) || (isnumeric(v) && numel(v) == 2));
p.addParameter('uMid', [], @(v) isempty(v) || isscalar(v));
p.addParameter('Eta', 1, @(v) isnumeric(v) && isscalar(v) && v >= 0 && v <= 1);
p.parse(varargin{:});
o = p.Results;

u = double(u(:)); I = double(I(:));
ok = isfinite(u) & isfinite(I);
if ~isempty(o.Window)
    ok = ok & u >= min(o.Window) & u <= max(o.Window);
end
u = u(ok); I = I(ok);
[u, order] = sort(u); I = I(order);
centres = double(centres(:)).';
peaks = struct('centre', num2cell(centres), 'fwhm', NaN, 'height', NaN, 'eta', o.Eta);
if isempty(o.Window), win = [min(u) max(u)]; else, win = sort(o.Window(:)).'; end
if isempty(o.uMid), uMid = mean(win); else, uMid = o.uMid; end
if numel(u) < 2
    bg = [0 0];
    if ~isempty(o.Background), bg = o.Background(:).'; end
    for k = 1:numel(peaks), peaks(k).fwhm = max(diff(win), eps) / 10; peaks(k).height = 1; end
    return
end
span = max(u) - min(u);
step = median(abs(diff(u)));
range = max(max(I) - min(I), eps);
if isempty(o.Background)
    s = sort(I);
    bg = [s(max(1, round(0.1 * numel(s)))) 0];
else
    bg = o.Background(:).';
end
sortedC = sort(centres);
for k = 1:numel(peaks)
    c = peaks(k).centre;
    base = bg(1) + bg(2) * (c - uMid);
    [~, idx] = min(abs(u - c));
    h = I(idx) - base;
    if ~(h > 0), h = 0.05 * range; end
    level = base + h / 2;
    left = NaN; right = NaN;
    for j = idx:-1:2
        if I(j - 1) < level
            left = interp1(I([j - 1 j]), u([j - 1 j]), level);
            break
        end
    end
    for j = idx:numel(u) - 1
        if I(j + 1) < level
            right = interp1(I([j j + 1]), u([j j + 1]), level);
            break
        end
    end
    if isfinite(left) && isfinite(right)
        w = right - left;
    elseif isfinite(left)
        w = 2 * (c - left);
    elseif isfinite(right)
        w = 2 * (right - c);
    else
        w = span / 10;
    end
    others = sortedC(sortedC ~= c);
    if ~isempty(others)
        w = min(w, max(min(abs(others - c)), step));
    end
    peaks(k).fwhm = min(max(w, step), max(span, step));
    peaks(k).height = h;
end
end
