function cell_bc_plot(a,b,c)
lattice_body_centred(0,0,0,a,b,c,1,1,1);
hold on;
x=[0 a a 0 0 0 a a 0 0];
y=[0 0 b b 0 0 0 b b 0];
z=[0 0 0 0 0 c c c c c];
plot3(x,y,z,'color','b','linewidth',1.5);
x=[a a]; y=[0 0]; z=[0 c];
plot3(x,y,z,'color','b','linewidth',1.5);
x=[a a]; y=[b b]; z=[0 c];
plot3(x,y,z,'color','b','linewidth',1.5);
x=[0 0]; y=[b b]; z=[0 c];
plot3(x,y,z,'color','b','linewidth',1.5);
x=[0 a]; y=[0 b]; z=[0 c];
plot3(x,y,z,'color','b','linewidth',1.5);
x=[0 a]; y=[0 b]; z=[c 0];
plot3(x,y,z,'color','b','linewidth',1.5);
x=[a 0]; y=[0 b]; z=[0 c];
plot3(x,y,z,'color','b','linewidth',1.5);
x=[a 0]; y=[0 b]; z=[c 0];
plot3(x,y,z,'color','b','linewidth',1.5);
end