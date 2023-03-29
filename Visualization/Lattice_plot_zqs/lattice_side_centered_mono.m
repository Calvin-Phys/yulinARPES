function [x_list,y_list,z_list]=lattice_side_centered_mono(x0,y0,z0,a,b,c,beta,nx,ny,nz)
[x1,y1,z1]=lattice_mon(x0,y0,z0,a,b,c,beta,nx+1,ny+1,nz+1);
[x2,y2,z2]=lattice_mono_fc(x0,y0,z0,0,b/2,c/2,a,b,c,beta,nx,ny,nz);
x_list=[x1,x2];
y_list=[y1,y2];
z_list=[z1,z2];
axis equal;
hold on;
plot3(x_list,y_list,z_list,'.','markersize',30);
end

function [x_list,y_list,z_list]=lattice_mon(x0,y0,z0,a,b,c,beta,nx,ny,nz)
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
end

function [x_list,y_list,z_list]=lattice_mono_fc(x0,y0,z0,x,y,z,a,b,c,beta,nx,ny,nz)
ax=a*sind(beta);
ay=a*cosd(beta);
m=0;
for i=1:nx
    for j=1:ny
        for k=1:nz
            m=m+1;
            x_list(m)=x0+x+ax*(i-1);
            y_list(m)=y0+y+b*(j-1)+ay*(i-1);
            z_list(m)=z0+z+c*(k-1);
%             if z==0 && k==n
%                 m=m+1;
%                 x_list(m)=x0+x+a*(i-1);
%                 y_list(m)=y0+y+b*(j-1);
%                 z_list(m)=z0+z+c*k;
%             end
%             if y==0 && j==n
%                 m=m+1;
%                 x_list(m)=x0+x+a*(i-1);
%                 y_list(m)=y0+y+b*j;
%                 z_list(m)=z0+z+c*(k-1);
%             end
            if x==0 && i==nx
                m=m+1;
                x_list(m)=x0+x+ax*i;
                y_list(m)=y0+y+b*(j-1)+ay*i;
                z_list(m)=z0+z+c*(k-1);
            end
        end      
    end   
end
end