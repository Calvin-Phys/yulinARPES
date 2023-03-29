function [x_list,y_list,z_list]=lattice_bcc(x0,y0,z0,a,nx,ny,nz)
[x1,y1,z1]=lattice_cub(x0,y0,z0,a,nx+1,ny+1,nz+1);
hold on;
[x2,y2,z2]=lattice_cub(x0+a/2,y0+a/2,z0+a/2,a,nx,ny,nz);
x_list=[x1,x2];
y_list=[y1,y2];
z_list=[z1,z2];
plot3(x_list,y_list,z_list,'.','markersize',30);
axis tight;
axis equal;
light;
end