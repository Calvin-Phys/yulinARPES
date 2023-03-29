function [x_list,y_list]=new_list(rmin,xlist,ylist,theta,x1,y1,theta1,x2,y2,theta2,x0,y0)
%if theta1<0
%    theta1=theta1+360;
%end
%if theta2<0
%    theta2=theta2+360;
%end
[theta,xlist,ylist]=sort_list(theta,xlist,ylist);
n=length(xlist);
if abs(theta2-theta1)>180
    %if theta1<theta2
        theta_list(1)=theta1; x_list(1)=x1; y_list(1)=y1;
        j=2;
        for i=1:n
            if theta(i)>theta1 && theta(i)<theta2 && distancebe(xlist(i),ylist(i),x1,y1)>rmin && distancebe(xlist(i),ylist(i),x2,y2)>rmin
                theta_list(j)=theta(i); x_list(j)=xlist(i); y_list(j)=ylist(i);
                j=j+1;
            end
        end
        theta_list(j)=theta2; x_list(j)=x2; y_list(j)=y2;
        x_list(j+1)=x0; y_list(j+1)=y0;
    %else
    %    theta_list(1)=theta2; x_list(1)=x2; y_list(1)=y2;
    %    j=2;
    %    for i=1:n
    %        if theta(i)>theta2 && theta(i)<theta1
    %            theta_list(j)=theta(i);
    %            x_list(j)=xlist(i);
    %            y_list(j)=ylist(i);
    %            j=j+1;
    %        end
    %    end
    %   theta_list(j)=theta1; x_list(j)=x1; y_list(j)=y1;
    %    x_list(j+1)=x0; y_list(j+1)=y0;
    %end
else
    %if theta1<theta2
        theta_list(1)=theta2; x_list(1)=x2; y_list(1)=y2;
        j=2;
        for i=1:n
            if theta(i)>theta2 && distancebe(xlist(i),ylist(i),x1,y1)>rmin && distancebe(xlist(i),ylist(i),x2,y2)>rmin
                theta_list(j)=theta(i); x_list(j)=xlist(i); y_list(j)=ylist(i);
                j=j+1;
            end
        end
        for i=1:n
            if theta(i)<theta1 && distancebe(xlist(i),ylist(i),x1,y1)>rmin && distancebe(xlist(i),ylist(i),x2,y2)>rmin
                theta_list(j)=theta(i); x_list(j)=xlist(i); y_list(j)=ylist(i);
                j=j+1;
            end
        end
        theta_list(j)=theta1; x_list(j)=x1; y_list(j)=y1;
        x_list(j+1)=x0; y_list(j+1)=y0;
    %else
    %    theta_list(1)=theta1; x_list(1)=x1; y_list(1)=y1;
    %    j=2;
    %    for i=1:n
    %        if theta(i)>theta1
    %            theta_list(j)=theta(i); x_list(j)=xlist(i); y_list(j)=ylist(i);
    %            j=j+1;
    %        end
    %    end
    %    for i=1:n
    %        if theta(i)<theta2
    %            theta_list(j)=theta(i); x_list(j)=xlist(i); y_list(j)=ylist(i);
    %            j=j+1;
    %        end
    %    end
    %    theta_list(j)=theta2; x_list(j)=x2; y_list(j)=y2;
    %    x_list(j+1)=x0; y_list(j+1)=y0;
    %end
end
end
        
function r=distancebe(x1,y1,x2,y2)
r=sqrt((x1-x2)^2+(y1-y2)^2);
end
        
        