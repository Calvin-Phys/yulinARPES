function [x_list,y_list,z_list]=lattice_hex(x0,y0,z0,a,c)
x=[a a/2 -a/2 -a -a/2 a/2 0];
y=[0 -sqrt(3)*a/2 -sqrt(3)*a/2 0 sqrt(3)*a/2 sqrt(3)*a/2 0];
x_list=[x x]+x0;
y_list=[y y]+y0;
z_list=[-c/2 -c/2 -c/2 -c/2 -c/2 -c/2 -c/2 c/2 c/2 c/2 c/2 c/2 c/2 c/2]+z0;
plot3(x_list,y_list,z_list,'.','markersize',30);
end
