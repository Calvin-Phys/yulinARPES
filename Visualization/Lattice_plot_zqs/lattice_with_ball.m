function lattice_with_ball(x_list,y_list,z_list,radius,red,green,blue)
pts=[x_list;y_list;z_list];
color=[red green blue];
scatter3_ball(pts,radius,color);
end