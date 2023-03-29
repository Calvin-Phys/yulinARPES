function [x_list,y_list,z_list]=lattice_side_centred(x0,y0,z0,a,b,c,nx,ny,nz)
[x1,y1,z1]=lattice_cuboid(x0,y0,z0,a,b,c,nx+1,ny+1,nz+1);
hold on;
[x2,y2,z2]=lattice_fcc_fc(x0,y0,z0,a/2,b/2,0,a,b,c,nx,ny,nz);
x_list=[x1,x2];
y_list=[y1,y2];
z_list=[z1,z2];
axis equal;
axis tight;
plot3(x_list,y_list,z_list,'.','markersize',30);
end

function [x_list,y_list,z_list]=lattice_fcc_fc(x0,y0,z0,x,y,z,a,b,c,nx,ny,nz)
m=0;
for i=1:nx
    for j=1:ny
        for k=1:nz
            m=m+1;
            x_list(m)=x0+x+a*(i-1);
            y_list(m)=y0+y+b*(j-1);
            z_list(m)=z0+z+c*(k-1);
            if z==0 && k==nz
                m=m+1;
                x_list(m)=x0+x+a*(i-1);
                y_list(m)=y0+y+b*(j-1);
                z_list(m)=z0+z+c*k;
            end
            if y==0 && j==ny
                m=m+1;
                x_list(m)=x0+x+a*(i-1);
                y_list(m)=y0+y+b*j;
                z_list(m)=z0+z+c*(k-1);
            end
            if x==0 && i==nx
                m=m+1;
                x_list(m)=x0+x+a*i;
                y_list(m)=y0+y+b*(j-1);
                z_list(m)=z0+z+c*(k-1);
            end
        end      
    end   
end
end