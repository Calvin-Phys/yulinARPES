function [angle,xaxis,yaxis] = sort_list(a,x,y)
N = length(x);
for i = 1:N-1
    for j = i+1:N
        if a(i) > a(j)
            tmp=a(i); a(i)=a(j); a(j)=tmp;
            tmp=x(i); x(i)=x(j); x(j)=tmp;
            tmp=y(i); y(i)=y(j); y(j)=tmp;
        end
    end
end
angle=a;
xaxis=x;
yaxis=y;
end