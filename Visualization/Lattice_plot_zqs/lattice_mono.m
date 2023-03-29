function [x_list,y_list,z_list]=lattice_mono(x0,y0,z0,a,b,c,beta,nx,ny,nz)
ay=a*cosd(beta);
ax=sqrt(a^2-ay^2);
i=1;
for m=1:nx
    for n=1:ny
        for l=1:nz
            x_list(i)=(m-1)*ax+x0;
            y_list(i)=(m-1)*ay+(n-1)*b+y0;
            z_list(i)=(l-1)*c+z0;
            i=i+1;
        end
    end
end
axis equal;
axis tight;
hold on;
plot3(x_list,y_list,z_list,'.','markersize',30);
end