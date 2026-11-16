function polygonEdges = plotBZ_V1_intersectBZ(vertices, faces, plane, inPlaneAngle, figure3d, figure2d, varargin)
%PLOTBZ_V1_INTERSECTBZ Intersect a convex BZ polyhedron with a plane.
%   Return consecutive polygon edges as N-by-6 endpoint rows. A tangent
%   point, tangent edge, or disjoint plane returns an empty 0-by-6 array.
%   Vertices and edges lying on the plane are included in face sections.

polygonEdges = zeros(0, 6);
normal = planeNormal(plane);
normalLength = norm(normal);
if ~isfinite(normalLength) || normalLength == 0
    error('plotBZ_V1:InvalidPlane', 'Cutting plane must have a nonzero normal.');
end
signedDistance = (vertices - plane(1:3))*normal'/normalLength;
scale = max([1; vecnorm(vertices, 2, 2)]);
tolerance = 1e-10*scale;

edges = meshEdges(faces);
points = zeros(2*size(edges, 1), 3);
pointCount = 0;
for edgeIndex = 1:size(edges, 1)
    first = edges(edgeIndex, 1);
    second = edges(edgeIndex, 2);
    firstDistance = signedDistance(first);
    secondDistance = signedDistance(second);

    if abs(firstDistance) <= tolerance
        pointCount = pointCount + 1;
        points(pointCount, :) = vertices(first, :);
    end
    if abs(secondDistance) <= tolerance
        pointCount = pointCount + 1;
        points(pointCount, :) = vertices(second, :);
    end
    if firstDistance*secondDistance < -tolerance^2
        fraction = firstDistance/(firstDistance - secondDistance);
        pointCount = pointCount + 1;
        points(pointCount, :) = vertices(first, :) + ...
            fraction*(vertices(second, :) - vertices(first, :));
    end
end

% Mesh edges share vertices. Remove duplicate intersection points with a
% distance tolerance before computing the convex section boundary.
points = points(1:pointCount, :);
uniquePoints = zeros(size(points));
uniqueCount = 0;
for pointIndex = 1:pointCount
    if uniqueCount == 0 || all(vecnorm(uniquePoints(1:uniqueCount, :) - ...
            points(pointIndex, :), 2, 2) > tolerance)
        uniqueCount = uniqueCount + 1;
        uniquePoints(uniqueCount, :) = points(pointIndex, :);
    end
end
uniquePoints = uniquePoints(1:uniqueCount, :);
if uniqueCount < 3
    return;
end

[azimuth, elevation] = cart2sph(normal(1), normal(2), normal(3));
rotation = rotz(inPlaneAngle)*rotx(90 - rad2deg(elevation))* ...
    rotz(90 - rad2deg(azimuth));
projected = uniquePoints*rotation';
projected = projected(:, 1:2);
if rank(projected - projected(1, :), tolerance) < 2
    return;
end

boundary = convhull(projected);
polygonPoints = uniquePoints(boundary, :);
polygonEdges = [polygonPoints(1:end-1, :), polygonPoints(2:end, :)];
if figure3d ~= 0
    figure(figure3d);
    drawPolygon3d(polygonPoints, varargin{:});
end
if figure2d ~= 0
    figure(figure2d);
    drawPolygon(projected(boundary, :), varargin{:});
end
end
