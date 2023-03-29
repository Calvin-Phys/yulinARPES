function [x_list,y_list,z_list]=lattice_trigonal(x0,y0,z0,a,alpha,nx,ny,nz)
theta=acosd(cosd(alpha)/cosd(alpha/2));
a1=[a*cosd(alpha/2),a*sind(alpha/2),0];
a2=[a*cosd(alpha/2),-a*sind(alpha/2),0];
a3=[a*cosd(theta),0,a*sind(theta)];
i=1;
for m=1:nx
    for n=1:ny
        for l=1:nz
            x_list(i)=(m-1)*a1(1)+(n-1)*a2(1)+(l-1)*a3(1)+x0;
            y_list(i)=(m-1)*a1(2)+(n-1)*a2(2)+(l-1)*a3(2)+y0;
            z_list(i)=(m-1)*a1(3)+(n-1)*a2(3)+(l-1)*a3(3)+z0;
            i=i+1;
        end
    end
end
axis equal;
hold on;
plot3(x_list,y_list,z_list,'.','markersize',30);
axis tight;
end