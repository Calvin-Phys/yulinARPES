function millersurface(a,b,c,beta,gamma,k,l,m,xlist,ylist,zlist)
    [A,B,C]=surfequation(a,b,c,beta,gamma,k,l,m);
    num=size(xlist,2);
    for i=1:num
        distance(i)=abs(A*xlist(i)+B*ylist(i)+C*zlist(i))/sqrt(A^2+B^2+C^2);
    end
    mindis=minimum(distance);
    figure;
    hold on
    for i=1:num
        n=round(distance(i)/mindis);
        if mod(n,7)==0
            plot3(xlist(i),ylist(i),zlist(i),'.','MarkerSize',50,'Color','b');
        end
        if mod(n,7)==1
            plot3(xlist(i),ylist(i),zlist(i),'.','MarkerSize',50,'Color','g');
        end
        if mod(n,7)==2
            plot3(xlist(i),ylist(i),zlist(i),'.','MarkerSize',50,'Color','r');
        end
        if mod(n,7)==3
            plot3(xlist(i),ylist(i),zlist(i),'.','MarkerSize',50,'Color','y');
        end
        if mod(n,7)==4
            plot3(xlist(i),ylist(i),zlist(i),'.','MarkerSize',50,'Color','k');
        end
        if mod(n,7)==5
            plot3(xlist(i),ylist(i),zlist(i),'.','MarkerSize',50,'Color','c');
        end
        if mod(n,7)==6
            plot3(xlist(i),ylist(i),zlist(i),'.','MarkerSize',50,'Color','m');
        end
    end
end