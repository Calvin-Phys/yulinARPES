function [x_list,y_list]=cylinder_new_list(xlist,ylist,xc,yc,r,x0,y0,theta1,theta2)

theta=angle_list(xlist,ylist,xc,yc);
if theta1<0
   theta1=theta1+360;
end
if theta2<0
   theta2=theta2+360;
end
if theta1>theta2
    tmp=theta1; theta1=theta2; theta2=tmp;
end
x1=r*cosd(theta1)+xc;
y1=r*sind(theta1)+yc;
x2=r*cosd(theta2)+xc;
y2=r*sind(theta2)+yc;

n=length(xlist);
if abs(theta2-theta1)>180
        theta_list(1)=theta1; x_list(1)=x1; y_list(1)=y1;
        j=2;
        for i=1:n
            if theta(i)>theta1 && theta(i)<theta2
                theta_list(j)=theta(i); x_list(j)=xlist(i); y_list(j)=ylist(i);
                j=j+1;
            end
        end
        theta_list(j)=theta2; x_list(j)=x2; y_list(j)=y2;
%         x_list(j+1)=x0; y_list(j+1)=y0;
%         x_list(j+2)=x1; y_list(j+2)=y1;
else
        theta_list(1)=theta2; x_list(1)=x2; y_list(1)=y2;
        j=2;
        for i=1:n
            if theta(i)>theta2 
                theta_list(j)=theta(i); x_list(j)=xlist(i); y_list(j)=ylist(i);
                j=j+1;
            end
        end
        for i=1:n
            if theta(i)<theta1 
                theta_list(j)=theta(i); x_list(j)=xlist(i); y_list(j)=ylist(i);
                j=j+1;
            end
        end
        theta_list(j)=theta1; x_list(j)=x1; y_list(j)=y1;
%         x_list(j+1)=x0; y_list(j+1)=y0;
%         x_list(j+2)=x2; y_list(j+2)=y2;
end

end