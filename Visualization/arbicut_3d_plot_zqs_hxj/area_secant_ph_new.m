function [x,y,r]=area_secant_ph_new(x_list,y_list,x1,y1,x2,y2)
x_max=max(x1,x2);
x_min=min(x1,x2);
r=sqrt((x1-x2)^2+(y1-y2)^2);
n=floor(abs(r/(min(x_list(1)-x_list(2),y_list(1)-y_list(2)))))+1;
if abs(x1-x2)<10^(-4)
    y=linspace(y1,y2,n);
    x=x1*(y./y);
else
    x=linspace(x_min,x_max,n);
    k=(y2-y1)/(x2-x1);
    b=y1-x1*k;
    y=k*x+b;
end
r=sqrt((x-x1).^2+(y-y1).^2);
end