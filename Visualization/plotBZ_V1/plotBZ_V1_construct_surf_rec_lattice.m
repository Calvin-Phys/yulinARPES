function [sites, targetRows] = plotBZ_V1_construct_surf_rec_lattice(s1, s2, handles)
%PLOTBZ_V1_CONSTRUCT_SURF_REC_LATTICE Enclose requested surface BZ cells.

starts = [plotBZ_V1_parse_scalar(handles, 's1start', 'integer'), ...
    plotBZ_V1_parse_scalar(handles, 's2start', 'integer')];
ends = [plotBZ_V1_parse_scalar(handles, 's1end', 'integer'), ...
    plotBZ_V1_parse_scalar(handles, 's2end', 'integer')];
if any(starts > ends)
    error('plotBZ_V1:InvalidInput', ...
        'Each surface lattice start index must not exceed its end index.');
end

basis = [s1; s2];
padding = plotBZ_V1_lattice_padding(basis);
pointCount = prod(ends - starts + 1 + 2*padding);
if pointCount > 50000
    error('plotBZ_V1:TooManySites', ...
        'Surface Voronoi construction needs %g sites; reduce the range.', pointCount);
end

indexRanges = arrayfun(@(axisIndex) ...
    (starts(axisIndex)-padding(axisIndex)):(ends(axisIndex)+padding(axisIndex)), ...
    1:2, 'UniformOutput', false);
[i, j] = ndgrid(indexRanges{:});
integerSites = [i(:), j(:)];
sites = integerSites*basis;
targetRows = find(all(integerSites >= starts & integerSites <= ends, 2))';
end
