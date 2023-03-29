function h=cylinder_plot_cut(data,xc,yc,r0,x0,y0,theta1,theta2,z0)
if theta1<0;
    theta1=theta1+360;
end
if theta2<0
    theta2=theta2+360;
end
if theta1>theta2
    tmp=theta1; theta1=theta2; theta2=tmp;
end

h=figure(100);
z_max=0;
z_min=min(data.z);
[x,y,~]=cylinder(r0,1000);
x=x+xc;    
y=y+yc;
x(2,:)=[];    
y(2,:)=[];
[x_list,y_list]=cylinder_new_list(x,y,xc,yc,r0,x0,y0,theta1,theta2);
z=ones(size(x_list));
z(1,:)=z_max;
z(2,:)=z0;
x=repmat(x_list,2,1);
y=repmat(y_list,2,1);
slice(data.x,data.y,data.z,data.value,x,y,z);
shading interp;
hold on;

x1=r0*cosd(theta1)+x0;
y1=r0*sind(theta1)+y0;
x2=r0*cosd(theta2)+x0;
y2=r0*sind(theta2)+y0;

[xp,yp,~]=area_secant_ph_new(data.x,data.y,x0,y0,x1,y1);
zp=data.z(data.z<=z_max);
zp=zp(zp>=z_min);
xx=repmat(xp,max(size(zp)),1);
yy=repmat(yp,max(size(zp)),1);
zz=repmat(zp',1,max(size(xp)));
slice(data.x,data.y,data.z,data.value,xx,yy,zz);
shading interp;
hold on;

[xp,yp,~]=area_secant_ph_new(data.x,data.y,x0,y0,x2,y2);
zp=data.z(data.z<=z_max);
zp=zp(zp>=z_min);
xx=repmat(xp,max(size(zp)),1);
yy=repmat(yp,max(size(zp)),1);
zz=repmat(zp',1,max(size(xp)));
slice(data.x,data.y,data.z,data.value,xx,yy,zz);
shading interp;
hold on;

r=linspace(0,r0,100);
if abs(theta1-theta2)>180
    t=theta1:0.01:theta2;
else
    t=theta2:0.01:(theta1+360);
end
[r,t]=meshgrid(r,t);
x=r.*cosd(t)+x0;
y=r.*sind(t)+y0;
z=ones(size(x))*z_max;
slice(data.x,data.y,data.z,data.value,x,y,z);
shading interp;
hold on;

[xx,yy,zz]=cylinder(r0,100);
x=xx+x0;
y=yy+y0;
z=(z0-z_min)*zz+z_min;
slice(data.x,data.y,data.z,data.value,x,y,z);
shading interp;
hold on;
r=linspace(0,r0,100);
t=0:0.01*pi:2*pi;
[r,t]=meshgrid(r,t);
x=r.*cos(t)+x0;
y=r.*sin(t)+y0;
z=ones(size(x))*z0;
slice(data.x,data.y,data.z,data.value,x,y,z);
shading interp;
hold on;
z=ones(size(x))*z_min;
slice(data.x,data.y,data.z,data.value,x,y,z);
shading interp;

end
