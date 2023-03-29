function [x,y,r] = area_secant_ph1( x_grid , y_grid, x0, y0, x1, y1 ) 
%Area_secant_ph returns the coodinates of points of a secant of a
%rectangular area defined by x_grid and y_grid.

%% determine the line
k=(y1-y0)/(x1-x0);
reverse_flag=0;
if k>10e4||isnan(k)   % in case the line is vertical to x-axis
    [x_grid,y_grid]=exchange_p(x_grid,y_grid);
    [x0,y0]=exchange_p(x0,y0);
    [x1,y1]=exchange_p(x1,y1);
    k=(y1-y0)/(x1-x0);
    reverse_flag=1;
end
b=y1-x1*k;

%% determine the range of output x array

x_max=max(x0,x1);
x_min=min(x0,x1);


% determine the number of sampling points
r=sqrt((x0-x1)^2+(y0-y1)^2);
n=floor(abs(r/(min(x_grid(1)-x_grid(2),y_grid(1)-y_grid(2)))))+1;

%% determine the output array x and array y
x=linspace(x_min,x_max,n);
y=k*x+b;
r=sqrt((x-x0).^2+(y-y0).^2);
if r(1)>r(2)
    x=fliplr(x);
    y=fliplr(y);
    r=fliplr(r);
end
if reverse_flag==1
    [x,y]=exchange_p(x,y);
end

end

function [a,b] = exchange_p(c,d)  % just exchange
    tmp1=d;
    a=tmp1;
    tmp2=c;
    b=tmp2;
end