function error_plot
theta=0:330;
phi=60:180;
beta=0:360;
x0=1; y0=0;
x=x0+cosd(theta); y=y0+sind(theta);
plot(x,y,'color','b','linewidth',5);
hold on;
x=[0 2]; y=[0 0];
plot(x,y,'color','b','linewidth',5);

x=[3 3];
y=[-1 1];
plot(x,y,'color','b','linewidth',5);
x0=4; y0=0;
x=x0+cosd(phi); y=y0+sind(phi);
plot(x,y,'color','b','linewidth',5);

x=[5 5];
y=[-1 1];
plot(x,y,'color','b','linewidth',5);
x0=6; y0=0;
x=x0+cosd(phi); y=y0+sind(phi);
plot(x,y,'color','b','linewidth',5);

x0=8; y0=0;
x=x0+cosd(beta); y=y0+sind(beta);
plot(x,y,'color','b','linewidth',5);

x=[10 10];
y=[-1 1];
plot(x,y,'color','b','linewidth',5);
x0=11; y0=0;
x=x0+cosd(phi); y=y0+sind(phi);
plot(x,y,'color','b','linewidth',5);

axis equal;
end