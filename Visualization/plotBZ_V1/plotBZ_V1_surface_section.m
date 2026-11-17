function [segments, coplanar] = plotBZ_V1_surface_section(scan, normal, offset)
%PLOTBZ_V1_SURFACE_SECTION Intersect a sampled scan with n*k = offset.
%   SEGMENTS is N-by-6 Cartesian endpoint pairs. A crossing of a point or
%   curve can be a zero-length segment. COPLANAR identifies a full surface
%   lying in the plane, which callers should render as an area.

arguments
    scan (1,1) struct
    normal (1,3) double {mustBeFinite, mustBeReal}
    offset (1,1) double {mustBeFinite, mustBeReal}
end
if norm(normal) == 0
    error('plotBZ_V1:InvalidSimulation', 'Section normal must be nonzero.');
end
offset = offset/norm(normal);
normal = normal/norm(normal);
points = [scan.kx(:), scan.ky(:), scan.kz(:)];
distance = points*normal' - offset;
tolerance = 1e-10*max([1;vecnorm(points,2,2)]);
coplanar = scan.dimension == 2 && all(abs(distance) <= tolerance);
segments = zeros(0,6);
if coplanar
    return;
end
if scan.dimension < 2
    if scan.dimension == 0
        curve = points(1,:);
    elseif scan.firstDimensionVaries
        curve = [scan.kx(:,1),scan.ky(:,1),scan.kz(:,1)];
    else
        curve = [scan.kx(1,:)',scan.ky(1,:)',scan.kz(1,:)'];
    end
    if size(curve,1) == 1
        if abs(curve*normal'-offset) <= tolerance
            segments = [curve curve];
        end
        return;
    end
    edges = [(1:size(curve,1)-1)', (2:size(curve,1))'];
    segments = zeros(size(edges,1),6);
    count = 0;
    for index = 1:size(edges,1)
        ends = edgeSection(curve(edges(index,:),:), normal, offset, tolerance);
        if ~isempty(ends)
            count = count + 1;
            segments(count,:) = [ends(1,:) ends(end,:)];
        end
    end
    segments = segments(1:count,:);
    return;
end
indices = reshape(1:numel(scan.kx),size(scan.kx));
a = indices(1:end-1,1:end-1);
b = indices(2:end,1:end-1);
c = indices(1:end-1,2:end);
d = indices(2:end,2:end);
triangles = [a(:),b(:),c(:); d(:),c(:),b(:)];
% Each triangle contributes at most three coplanar edges. This also keeps
% a plane through an entire mesh edge, which crossing-only tests omit.
segments = zeros(3*size(triangles,1),6);
count = 0;
for index = 1:size(triangles,1)
    triangle = points(triangles(index,:),:);
    crossings = zeros(6,3);
    crossingCount = 0;
    for edge = [1 2;2 3;3 1]'
        ends = edgeSection(triangle(edge,:), normal, offset, tolerance);
        countEnds = size(ends,1);
        crossings(crossingCount+(1:countEnds),:) = ends;
        crossingCount = crossingCount + countEnds;
    end
    crossings = crossings(1:crossingCount,:);
    if isempty(crossings)
        continue;
    end
    crossings = uniquetol(crossings,tolerance,'ByRows',true,'DataScale',1);
    if size(crossings,1) < 2
        count = count + 1;
        segments(count,:) = [crossings crossings];
    elseif size(crossings,1) == 2
        count = count + 1;
        segments(count,:) = [crossings(1,:) crossings(2,:)];
    else
        for edge = [1 2;2 3;3 1]'
            count = count + 1;
            segments(count,:) = [crossings(edge(1),:) crossings(edge(2),:)];
        end
    end
end
segments = segments(1:count,:);
end

function points = edgeSection(ends, normal, offset, tolerance)
distance = ends*normal'-offset;
if all(abs(distance) <= tolerance)
    points = ends;
elseif abs(distance(1)) <= tolerance
    points = ends(1,:);
elseif abs(distance(2)) <= tolerance
    points = ends(2,:);
elseif prod(distance) < 0
    fraction = distance(1)/(distance(1)-distance(2));
    points = ends(1,:) + fraction*(ends(2,:)-ends(1,:));
else
    points = zeros(0,3);
end
end
