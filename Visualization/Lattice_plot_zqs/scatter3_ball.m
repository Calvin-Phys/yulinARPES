function scatter3_ball(pts,r,c)
% pts is a matrix specify the location of each points.
% size(pts) == 3 by N, N is the length of point list.
% c specifies color, using any permitted color specification, such as 'r'.
% or [0.2 0.3 0.8]
npts = 1000;
for i = 1:size(pts,2)
    lon = 2*pi*rand(1,npts) - pi;
    lat = acos(2*rand(1,npts) - 1);
    x = r*cos(lon).*cos(lat);
    y = r*cos(lon).*sin(lat);
    z = r*sin(lon);
    tris = convhull(x,y,z);
    g(i) = hgtransform;
    set(g(i),'Matrix',makehgtform('translate',pts(:,i)));
    p = patch('FACES',tris,'Vertices',[x',y',z'],'Parent',g(i));
    set(p,'FaceColor',c);
    set(p,'EdgeColor','none');
end
axis tight;
axis equal;
axis vis3d;
light;
end