function [u, I, info] = pkf_extract_profile(D, direction, sliceValue, halfWidth)
%PKF_EXTRACT_PROFILE  MDC or EDC from a normalised 2-D cut (see PKF_INPUT).
%   [u, I, info] = PKF_EXTRACT_PROFILE(D, direction, sliceValue, halfWidth)
%     direction  'MDC' (horizontal): profile along x at fixed y (energy);
%                'EDC' (vertical):   profile along y at fixed x.
%     sliceValue position on the slice axis (y for MDC, x for EDC), in axis
%                units; the nearest sample is used as the centre.
%     halfWidth  integration half-width in slice-axis units (default 0):
%                all samples with |s - s0| <= halfWidth are averaged with
%                'omitnan'; at least the nearest sample is always used.
%   u is returned ascending (column) with I reordered to match; NaN values
%   are kept so callers can see missing data. info has fields index (centre
%   sample), indices (averaged samples), sliceValue (actual centre value),
%   direction, profileAxis ('x'|'y') and sliceAxis ('y'|'x').

if nargin < 4 || isempty(halfWidth), halfWidth = 0; end
direction = pkf_direction(direction);
if ~(isnumeric(halfWidth) && isscalar(halfWidth) && isfinite(halfWidth) && halfWidth >= 0)
    error('PeakFit:InvalidWidth', 'The integration half-width must be a finite value >= 0.');
end
if strcmp(direction, 'MDC')
    s = D.y; u = D.x(:);
else
    s = D.x; u = D.y(:);
end
if ~(isnumeric(sliceValue) && isscalar(sliceValue) && isfinite(sliceValue))
    error('PeakFit:InvalidSlice', 'The slice position must be a finite scalar.');
end
[~, index] = min(abs(s - sliceValue));
indices = find(abs(s - s(index)) <= halfWidth + 1e-12 * max(abs(s)));
if isempty(indices), indices = index; end
if strcmp(direction, 'MDC')
    I = mean(D.value(:, indices), 2, 'omitnan');
    info.profileAxis = 'x'; info.sliceAxis = 'y';
else
    I = mean(D.value(indices, :), 1, 'omitnan').';
    info.profileAxis = 'y'; info.sliceAxis = 'x';
end
[u, order] = sort(u);
I = I(order);
info.index = index;
info.indices = indices(:).';
info.sliceValue = s(index);
info.direction = direction;
end
