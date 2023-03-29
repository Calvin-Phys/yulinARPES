function [x_list,y_list,z_list]=lattice_cuboid(x0,y0,z0,a,b,c,nx,ny,nz)
m=1;
for i=1:nx
    for j=1:ny
        for k=1:nz
            x_list(m)=x0+a*(i-1);
            y_list(m)=y0+b*(j-1);
            z_list(m)=z0+c*(k-1);
            m=m+1;
        end
    end
end
end