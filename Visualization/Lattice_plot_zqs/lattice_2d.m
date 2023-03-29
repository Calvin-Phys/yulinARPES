function [x_list,y_list]=lattice_2d(x0,y0,a,b,alpha,m,n)
k=1;
a1=[a,0];
a2=[b*cosd(alpha),b*sind(alpha)];
for i=1:m
    for j=1:n
        x_list(k)=i*a1(1)+j*a2(1)+x0;
        y_list(k)=i*a1(2)+j*a2(2)+y0;
        k=k+1;
    end
end
axis equal;
hold on;
plot(x_list,y_list,'.','markersize',30);
end