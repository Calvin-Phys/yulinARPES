function PolygonEdges=plotBZ_V1_intersectBZ(v,f,plane,rotz_angle,figure1,figure2,varargin)

% compute the edge list
e = meshEdges(f);
edges = [ v(e(:,1), :) v(e(:,2), :) ];

% identify which edges cross the mesh
inds = isBelowPlane(v, plane);
edgeCrossInds = find(sum(inds(e), 2) == 1);

% compute one intersection point for each edge
intersectionPoints = intersectEdgePlane(edges(edgeCrossInds, :), plane);
intersectionPoints(any(isnan(intersectionPoints), 2), :) = []; %deletes NaN rows in intersection point list
try
if length(intersectionPoints)>3       
    plane_normal=planeNormal(plane);
    [delta_a,delta_e,~] = cart2sph(plane_normal(1),plane_normal(2),plane_normal(3));
    %intersectionPoints_rot=roty(90-rad2deg(el))*(rotz(rad2deg(-az)))*intersectionPoints';
    intersectionPoints_rot=(rotz(rotz_angle)*rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*intersectionPoints')'; %projection on xy plane, and 90 deg counter clockwise rotation
    intersectionPoints_rot_proj=intersectionPoints_rot(:,1:2);
    K = convhull(intersectionPoints_rot_proj);
    
    PolygonPoints=intersectionPoints(K,:);
    PolygonEdges=[PolygonPoints(1:end-1,:) PolygonPoints(2:end,:)];
    if figure1~=0 
        figure(figure1)
        hold on
        drawPolygon3d(intersectionPoints(K,:),varargin{:});
        hold off
    end
    if figure2~=0 
        figure(figure2)
        drawPolygon(intersectionPoints_rot_proj(K,:),varargin{:});
    end
end
end