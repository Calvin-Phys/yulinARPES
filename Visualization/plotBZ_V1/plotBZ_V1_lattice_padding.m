function padding = plotBZ_V1_lattice_padding(basis)
%PLOTBZ_V1_LATTICE_PADDING Bound lattice neighbors needed for Voronoi cells.
%   BASIS stores basis vectors by row (two or three dimensions). Any point
%   in a Voronoi cell is at most half the sum of basis-vector lengths from
%   its lattice site: round its coordinates in the basis to nearby integers.
%   A site farther than twice that bound cannot define a cell facet.

if size(basis, 1) ~= size(basis, 2) || ...
        ~all(isfinite(basis), 'all') || rcond(basis) <= 1e-12
    error('plotBZ_V1:InvalidBasis', 'Reciprocal basis is singular or ill conditioned.');
end

neighborRadius = sum(vecnorm(basis, 2, 2));
dualBasis = inv(basis);
padding = ceil(neighborRadius*vecnorm(dualBasis, 2, 1));
end
