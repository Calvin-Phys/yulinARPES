function [x_list,y_list,z_list]=lattice_fcc(x0,y0,z0,a,nx,ny,nz)
[x1,y1,z1]=lattice_cub(x0,y0,z0,a,nx+1,ny+1,nz+1);
[x2,y2,z2]=lattice_fcc_fc(x0,y0,z0,a/2,a/2,0,a,nx,ny,nz);
[x3,y3,z3]=lattice_fcc_fc(x0,y0,z0,0,a/2,a/2,a,nx,ny,nz);
[x4,y4,z4]=lattice_fcc_fc(x0,y0,z0,a/2,0,a/2,a,nx,ny,nz);
x_list=[x1,x2,x3,x4];
y_list=[y1,y2,y3,y4];
z_list=[z1,z2,z3,z4];
plot3(x_list,y_list,z_list,'.','markersize',30);
axis tight;
axis equal;
end

function [x_list,y_list,z_list]=lattice_fcc_fc(x0,y0,z0,x,y,z,a,nx,ny,nz)
m=0;
for i=1:nx
    for j=1:ny
        for k=1:nz
            m=m+1;
            x_list(m)=x0+x+a*(i-1);
            y_list(m)=y0+y+a*(j-1);
            z_list(m)=z0+z+a*(k-1);
            if z==0 && k==nz
                m=m+1;
                x_list(m)=x0+x+a*(i-1);
                y_list(m)=y0+y+a*(j-1);
                z_list(m)=z0+z+a*k;
            end
            if y==0 && j==ny
                m=m+1;
                x_list(m)=x0+x+a*(i-1);
                y_list(m)=y0+y+a*j;
                z_list(m)=z0+z+a*(k-1);
            end
            if x==0 && i==nx
                m=m+1;
                x_list(m)=x0+x+a*i;
                y_list(m)=y0+y+a*(j-1);
                z_list(m)=z0+z+a*(k-1);
            end
        end      
    end   
end
end