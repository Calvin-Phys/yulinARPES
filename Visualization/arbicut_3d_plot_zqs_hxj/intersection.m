function [node_x1,node_y1,node_x2,node_y2] = intersection(x,y,theta,theta1,theta2,x0,y0)
[theta,x,y]=sort_list(theta,x,y);
n=length(x);
flag=1;
for i=1:n-1
    if theta1>theta(i) && theta1<=theta(i+1)
        x1=x(i); y1=y(i);
        x2=x(i+1); y2=y(i+1);
        flag=0;
    end
end
if flag==1
    x1=x(1); y1=y(1);
    x2=x(n); y2=y(n);
end
if abs(theta1-90)<10^-9 || abs(theta1-270)<10^-9
    node_x1=x0;
    node_y1=((x0-x2)*y1-(x0-x1)*y2)/(x1-x2);
else
    k=tand(theta1);
    node_x1=(k*x0*(x1-x2)+x2*(y0-y1)+x1*(-y0+y2))/(k*(x1-x2)-y1+y2);
    node_y1=y0+k*(node_x1-x0);
end

flag=1;
for i=1:n-1
    if theta2>theta(i) && theta2<=theta(i+1)
        x1=x(i); y1=y(i);
        x2=x(i+1); y2=y(i+1);
        flag=0;
    end
end
if flag==1
    x1=x(1); y1=y(1);
    x2=x(n); y2=y(n);
end
if abs(theta2-90)<10^-9 || abs(theta2-270)<10^-9
    node_x2=x0;
    node_y2=((x0-x2)*y1-(x0-x1)*y2)/(x1-x2);
else
    k=tand(theta2);
    node_x2=(k*x0*(x1-x2)+x2*(y0-y1)+x1*(-y0+y2))/(k*(x1-x2)-y1+y2);
    node_y2=y0+k*(node_x2-x0);
end
end       
