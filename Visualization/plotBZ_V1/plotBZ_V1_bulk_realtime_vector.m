function [b1, b2, b3, rotatedNormal] = plotBZ_V1_bulk_realtime_vector(b1Original, b2Original, b3Original, normal, handles)
%PLOTBZ_V1_BULK_REALTIME_VECTOR Rotate reciprocal vectors to plotting axes.
%   The selected Miller normal becomes positive kz. rot3DBZ then rotates
%   all bulk vectors about kz without changing reciprocal-vector lengths.

if ~isequal(size(normal), [1 3]) || ~all(isfinite(normal)) || norm(normal) == 0
    error('plotBZ_V1:InvalidNormal', 'Selected Miller normal must be finite and nonzero.');
end
[azimuth, elevation] = cart2sph(normal(1), normal(2), normal(3));
alignNormal = plotBZ_V1_rotation('x', 90 - rad2deg(elevation))*plotBZ_V1_rotation('z', 90 - rad2deg(azimuth));
displayRotation = plotBZ_V1_rotation('z', plotBZ_V1_parse_scalar(handles, 'rot3DBZ'));
rotation = displayRotation*alignNormal;

rotatedBasis = [b1Original; b2Original; b3Original]*rotation';
rotatedNormal = normal*rotation';
b1 = rotatedBasis(1, :);
b2 = rotatedBasis(2, :);
b3 = rotatedBasis(3, :);
end
