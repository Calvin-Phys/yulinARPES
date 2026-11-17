function [s1, s2] = plotBZ_V1_surface_realtime_vector(b1, b2, b3, normal, handles)
%PLOTBZ_V1_SURFACE_REALTIME_VECTOR Find a primitive surface reciprocal basis.
%   Project the entire bulk reciprocal lattice onto the cleavage plane,
%   then rotate that plane into the plotting xy frame. The primitive-basis
%   step matters for high-index surfaces such as cubic (234).

bulkBasis = [b1; b2; b3];
surfaceBasis = plotBZ_V1_primitive_surface_basis(bulkBasis, normal);
[azimuth, elevation] = cart2sph(normal(1), normal(2), normal(3));
alignNormal = plotBZ_V1_rotation('x', 90 - rad2deg(elevation))*plotBZ_V1_rotation('z', 90 - rad2deg(azimuth));
displayRotation = plotBZ_V1_rotation('z', plotBZ_V1_parse_scalar(handles, 'rotsurBZ'));
surfaceBasis = surfaceBasis*(displayRotation*alignNormal)';

s1 = surfaceBasis(1, 1:2);
s2 = surfaceBasis(2, 1:2);
if abs(det([s1; s2])) <= 1e-12*norm(s1)*norm(s2)
    error('plotBZ_V1:InvalidBasis', 'Surface reciprocal vectors are collinear.');
end
end
