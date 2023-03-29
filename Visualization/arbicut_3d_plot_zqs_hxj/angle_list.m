function angle=angle_list(x,y,x0,y0)
n=length(x);
for i = 1:n
    angle(i)=atand((y(i)-y0)/(x(i)-x0));    
    if x(i)-x0<0
        angle(i)=angle(i)+180;
    end
    if x(i)-x0>0 && y(i)-y0<0
        angle(i)=angle(i)+360;
    end
    if x(i)==x0 && y(i)-y0>0
        angle(i)=90;
    end
    if x(i)==x0 && y(i)-y0<0
        angle(i)=270;
    end
end
end