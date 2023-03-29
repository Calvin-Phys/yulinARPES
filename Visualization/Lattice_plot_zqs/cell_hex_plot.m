function cell_hex_plot(a,c)
lattice_hex(0,0,0,a,c);
hold on;
x=[a a/2 -a/2 -a -a/2 a/2 a];
y=[0 -sqrt(3)*a/2 -sqrt(3)*a/2 0 sqrt(3)*a/2 sqrt(3)*a/2 0];
z1=[1 1 1 1 1 1 1];
z=-c*z1/2;
plot3(x,y,z,'color','b','linewidth',1.5);
z=c*z1/2;
plot3(x,y,z,'color','b','linewidth',1.5);
p1=[a,0,-c/2]; p2=[a/2,-sqrt(3)*a/2,-c/2]; p3=[-a/2,-sqrt(3)*a/2,-c/2]; p4=[-a,0,-c/2]; p5=[-a/2,sqrt(3)*a/2,-c/2]; p6=[a/2,sqrt(3)*a/2,-c/2];
p7=[a,0,c/2]; p8=[a/2,-sqrt(3)*a/2,c/2]; p9=[-a/2,-sqrt(3)*a/2,c/2]; p10=[-a,0,c/2]; p11=[-a/2,sqrt(3)*a/2,c/2]; p12=[a/2,sqrt(3)*a/2,c/2];
point_to_line(p1,p7);
point_to_line(p2,p8);
point_to_line(p3,p9);
point_to_line(p4,p10);
point_to_line(p5,p11);
point_to_line(p6,p12);
point_to_line(p1,p4);
point_to_line(p2,p5);
point_to_line(p3,p6);
point_to_line(p7,p10);
point_to_line(p8,p11);
point_to_line(p9,p12);
point_to_line([0 0 -c/2],[0 0 c/2]);
end