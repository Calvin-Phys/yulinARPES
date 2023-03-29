function [x_list,y_list,z_list]=lattice_prim(x0,y0,z0,a,b,c,beta,gamma,nx,ny,nz)
ay=a*cosd(beta);
az=a*cosd(gamma);
ax=sqrt(a^2-ay^2-az^2);

i=1;
for m=1:nx
    for n=1:ny
        for l=1:nz
            x_list(i)=x0+m*ax;
            y_list(i)=y0+m*ay+n*b;
            z_list(i)=z0+m*az+l*c;
            i=i+1;
        end
    end
end
axis equal;
hold on;
axis tight;
plot3(x_list,y_list,z_list,'.','markersize',30);
end
