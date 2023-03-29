function plot_brillouin(brillouin)
    j=0;
    for poly=brillouin'
        j=j+1;
        for i=1:(poly.np)
            p1=poly.points(i,:);
            p2=poly.points(i+1,:);
            line([p1(1),p2(1)],[p1(2),p2(2)],[p1(3),p2(3)]);
        end
    end
    axis equal;
end