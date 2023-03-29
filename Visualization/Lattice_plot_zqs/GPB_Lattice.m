function GPB_Lattice
%% Define Lattice
a = 6.68;
b = 6.68;
c = 6.68;
v1 = [a 0 0]';
v2 = [0 b 0]';
v3 = [0 0 c]';
lat = [[0 0 0]',[0 0 1]',[0 1 0]',[0 1 1]',...
    [1 0 0]',[1 0 1]',[1 1 0]',[1 1 1]'];


%% Define sublattice
pts_G= a*[[0 0 0]',[0 1/2 1/2]',...
    [1/2 0 1/2]',[1/2 1/2 0]'];
v_B = a*[1/2,0,0]';
v_P = a*[1/4,1/4,1/4]';
pts_B = pts_G+repmat(v_B,[1,size(pts_G,2)]);
pts_P = pts_G+repmat(v_P,[1,size(pts_G,2)]);
pts_B(pts_B>=a) = pts_B(pts_B>=a) - a;
pts_P(pts_P>=a) = pts_P(pts_P>=a) - a;
r_G = 0.1 * a;
r_B = 0.1 * a;
r_P = 0.07 * a;

%% Draw Cleavage Plane
pt_plane1 = a*[[0,2,2]',[0 0 0]',[2,0,2]'];
pt_plane2 = a*[[0,0,2]',[2 2 2]',[0,2,0]'];
hold on;
h1=fill3(pt_plane1(1,:),pt_plane1(2,:),pt_plane1(3,:),'r');
alpha(h1,0.5);
h2=fill3(pt_plane2(1,:),pt_plane2(2,:),pt_plane2(3,:),'g');
alpha(h2,0.5);
hold off;

%% Draw Lattice
for i = 1:size(lat,2)
    hold on;
    v = v1 * lat(1,i) + v2 * lat(2,i) + v3 * lat(3,i);
    v_mat = repmat(v,[1,size(pts_G,2)]);
    scatter3_ball(pts_G+v_mat,r_G,'r');
    scatter3_ball(pts_B+v_mat,r_B,[0.2 0.3 0.8]);
    scatter3_ball(pts_P+v_mat,r_P,'g');
    hold off;
end
axis tight;
axis equal;
axis vis3d;
light;
end
function scatter3_ball(pts,r,c)
% pts is a matrix specify the location of each points.
% size(pts) == 3 by N, N is the length of point list.
% c specifies color, using any permitted color specification, such as 'r'.
% or [0.2 0.3 0.8]
npts = 500;
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
end