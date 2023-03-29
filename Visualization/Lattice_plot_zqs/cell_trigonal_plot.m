function cell_trigonal_plot(a,alpha)
[x,y,z]=lattice_trigonal(0,0,0,a,alpha,2,2,2);
hold on;
p=[x;y;z];
point_to_line(p(:,1),p(:,2));
point_to_line(p(:,2),p(:,4));
point_to_line(p(:,4),p(:,3));
point_to_line(p(:,3),p(:,1));
point_to_line(p(:,5),p(:,6));
point_to_line(p(:,6),p(:,8));
point_to_line(p(:,8),p(:,7));
point_to_line(p(:,7),p(:,5));
point_to_line(p(:,1),p(:,5));
point_to_line(p(:,2),p(:,6));
point_to_line(p(:,3),p(:,7));
point_to_line(p(:,4),p(:,8));
end