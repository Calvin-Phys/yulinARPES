function spherecut(data,x0,y0,z0,r,theta1,theta2,energy)

deltaz=abs(data.z(2)-data.z(1));

%%determine the boundary of phi
if energy>z0
    phicut1=acos((energy+deltaz-z0)/r);      %phicut1 is the boundary of phi decided by energy
else
    if energy<z0
        phicut1=pi-acos((z0-energy-2*deltaz)/r);
    else
        phicut1=pi/2;
    end
end


%%plot the part of sphere surface
figure;
hold on

%the surface under energy
theta=0:0.01*pi:2*pi;
phi=phicut1:0.01*pi:pi;
[theta,phi]=meshgrid(theta,phi);
x=r*sin(phi).*cos(theta)+x0;
y=r*sin(phi).*sin(theta)+y0;
z=r*cos(phi)+z0;
slice(data.x,data.y,data.z,data.value,x,y,z);

%plot the part below the energy
if abs(theta1-theta2)<pi
    theta=theta2:0.0005*pi:(2*pi+theta1);
else
    theta=theta1:0.0005*pi:theta2;
end
phi=0:0.01*pi:pi;
[theta,phi]=meshgrid(theta,phi);
x=r*sin(phi).*cos(theta)+x0;
y=r*sin(phi).*sin(theta)+y0;
z=r*cos(phi)+z0;
slice(data.x,data.y,data.z,data.value,x,y,z);

%plot the energy plane
r_energy=sqrt(r^2-(energy-z0)^2);
r0=linspace(0,r_energy,100);
theta=0:0.01*pi:2*pi;
[r0,theta]=meshgrid(r0,theta);
x=r0.*cos(theta)+x0;
y=r0.*sin(theta)+y0;
z=ones(size(x))*energy;
slice(data.x,data.y,data.z,data.value,x,y,z);

%plot the other two tangent plane
r0=linspace(0,r,100);
theta=0:0.01*pi:2*pi;
[r0,theta]=meshgrid(r0,theta);
x=r0.*sin(theta)*cos(theta1)+x0;
y=r0.*sin(theta)*sin(theta1)+y0;
z=r0.*cos(theta)+z0;
slice(data.x,data.y,data.z,data.value,x,y,z);

x=r0.*sin(theta)*cos(theta2)+x0;
y=r0.*sin(theta)*sin(theta2)+y0;
z=r0.*cos(theta)+z0;
slice(data.x,data.y,data.z,data.value,x,y,z);

shading interp

end