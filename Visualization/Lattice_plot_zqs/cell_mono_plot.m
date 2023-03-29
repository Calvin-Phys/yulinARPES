function cell_mono_plot(a,b,c,beta)
lattice_mono(0,0,0,a,b,c,beta,2,2,2);
hold on;
p1=[0,0,0]; p2=[a*sind(beta),a*cosd(beta),0]; p3=[a*sind(beta),a*cosd(beta)+b,0]; p4=[0,b,0];
p5=[0,0,c]; p6=[a*sind(beta),a*cosd(beta),c]; p7=[a*sind(beta),a*cosd(beta)+b,c]; p8=[0,b,c];
point_to_line(p1,p2); 
point_to_line(p2,p3); 
point_to_line(p3,p4); 
point_to_line(p4,p1); 
point_to_line(p5,p6); 
point_to_line(p6,p7); 
point_to_line(p7,p8); 
point_to_line(p8,p5); 
point_to_line(p1,p5); 
point_to_line(p2,p6); 
point_to_line(p3,p7); 
point_to_line(p4,p8); 
end