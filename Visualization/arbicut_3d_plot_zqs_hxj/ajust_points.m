function [x_list,y_list,theta_list]=ajust_points(n,x0,y0,r,theta)
angle_unit=360/n;
for i=1:n+1
    theta_list(i)=theta+angle_unit*(i-1);
    x_list(i)=x0+r*cosd(theta_list(i));
    y_list(i)=y0+r*sind(theta_list(i));
end
end