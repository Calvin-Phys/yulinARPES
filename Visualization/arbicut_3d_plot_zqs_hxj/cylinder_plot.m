function cylinder_plot(data,x0,y0,r0)
figure(100);
z_max=0;
z_min=min(data.z);
[x,y,z]=cylinder(r0,1000);
x=x+x0;    
y=y+y0;
z(1,:)=z_max;
z(2,:)=z_min;
slice(data.x,data.y,data.z,data.value,x,y,z);
hold on;
r=linspace(0,r0,100);
t=0:0.01*pi:2*pi;
[r,t]=meshgrid(r,t);
x=r.*cos(t)+x0;
y=r.*sin(t)+y0;
z=ones(size(x))*z_max;
slice(data.x,data.y,data.z,data.value,x,y,z);
z=ones(size(x))*z_min;
slice(data.x,data.y,data.z,data.value,x,y,z);
shading interp;
end
