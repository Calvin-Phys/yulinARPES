function draw_circle(r)
ang=-pi/6:0.01:2*pi;
x=r*cos(ang);
y=r*sin(ang);
hold on;
plot(x,y);
hold off;
axis tight;
