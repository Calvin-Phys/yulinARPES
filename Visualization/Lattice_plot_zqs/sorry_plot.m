function sorry_plot
theta=0:270;
phi=60:180;
x0=1; y0=2;
x=x0+cosd(theta); y=y0+sind(theta);
plot(x,y,'color','b','linewidth',5);
hold on;
theta=-180:90;
x0=1; y0=0;
x=x0+cosd(theta); y=y0+sind(theta);
plot(x,y,'color','b','linewidth',5);

theta=0:360;
x0=3.5; y0=0;
x=x0+cosd(theta); y=y0+sind(theta);
plot(x,y,'color','b','linewidth',5);

x=[5 5];
y=[-1 1];
plot(x,y,'color','b','linewidth',5);
x0=6; y0=0;
x=x0+cosd(phi); y=y0+sind(phi);
plot(x,y,'color','b','linewidth',5);

x=[7 7];
y=[-1 1];
plot(x,y,'color','b','linewidth',5);
x0=8; y0=0;
x=x0+cosd(phi); y=y0+sind(phi);
plot(x,y,'color','b','linewidth',5);

x=[9 10];
y=[1 -1];
plot(x,y,'color','b','linewidth',5);
x=[11 9];
y=[1 -3.5];
plot(x,y,'color','b','linewidth',5);

axis equal;
end