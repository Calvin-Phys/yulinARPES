function [sites, targetRows] = plotBZ_V1_construct_bulk_rec_lattice(b1, b2, b3, handles)
%PLOTBZ_V1_CONSTRUCT_BULK_REC_LATTICE Build sites enclosing requested zones.
%   The padding bound includes every possible Voronoi-facet neighbor of a
%   requested site. It adapts to skew reciprocal cells.

starts = [plotBZ_V1_parse_scalar(handles, 'KxStart', 'integer'), ...
    plotBZ_V1_parse_scalar(handles, 'KyStart', 'integer'), ...
    plotBZ_V1_parse_scalar(handles, 'KzStart', 'integer')];
ends = [plotBZ_V1_parse_scalar(handles, 'KxEnd', 'integer'), ...
    plotBZ_V1_parse_scalar(handles, 'KyEnd', 'integer'), ...
    plotBZ_V1_parse_scalar(handles, 'KzEnd', 'integer')];
if any(starts > ends)
    error('plotBZ_V1:InvalidInput', ...
        'Each bulk lattice start index must not exceed its end index.');
end

basis = [b1; b2; b3];
padding = plotBZ_V1_lattice_padding(basis);
pointCount = prod(ends - starts + 1 + 2*padding);
if pointCount > 50000
    error('plotBZ_V1:TooManySites', ...
        'Bulk Voronoi construction needs %g sites; reduce the range or skew.', pointCount);
end

% The target indices refer to rows of the same cloud passed to voronoin.
indexRanges = arrayfun(@(axisIndex) ...
    (starts(axisIndex)-padding(axisIndex)):(ends(axisIndex)+padding(axisIndex)), ...
    1:3, 'UniformOutput', false);
[i, j, k] = ndgrid(indexRanges{:});
integerSites = [i(:), j(:), k(:)];
sites = integerSites*basis;
targetRows = find(all(integerSites >= starts & integerSites <= ends, 2))';
end
