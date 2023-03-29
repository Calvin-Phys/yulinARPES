function cell_fc_plot(a,b,c)
lattice_face_centred(0,0,0,a,b,c,1,1,1);
hold on;
x=[0 a a 0 0 0 a a 0 0];
y=[0 0 b b 0 0 0 b b 0];
z=[0 0 0 0 0 c c c c c];
plot3(x,y,z,'color','b','linewidth',1.5);
p1=[0,0,0]; p2=[a,0,0]; p3=[a,b,0]; p4=[0,b,0];
p5=[0,0,c]; p6=[a,0,c]; p7=[a,b,c]; p8=[0,b,c];
point_to_line(p2,p6);
point_to_line(p3,p7);
point_to_line(p4,p8);
point_to_line(p1,p6);
point_to_line(p1,p8);
point_to_line(p2,p5);
point_to_line(p2,p7);
point_to_line(p3,p6);
point_to_line(p3,p8);
point_to_line(p4,p7);
point_to_line(p4,p5);
point_to_line(p5,p7);
point_to_line(p6,p8);
point_to_line(p1,p3);
point_to_line(p2,p4);

end