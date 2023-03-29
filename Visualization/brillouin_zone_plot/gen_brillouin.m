function brillouin=gen_brillouin(a,handles)
    eps=1e-10;
    function poly=genPolyFromPoints(points)
        if(isempty(points))
            poly=[];
            return;
        end
        poly.points=[points;points(1,:)];
        poly.np=length(points);
    end

    function [face,intersect]=intersectPolyPlane(poly,plane)
        sabc2=sqrt(sum(plane.^2));
        norm=plane/sabc2;
        d=-sum(plane.^2)/2/sabc2;
        isintersect=false;
        intersect=[];
        startend=[];
        for i1=1:(poly.np)
            p1in=(dot(norm,poly.points(i1,:))+d<-eps);
            p2in=(dot(norm,poly.points(i1+1,:))+d<-eps);
            if xor(p1in,p2in)
                D=dot(norm,poly.points(i1+1,:)-poly.points(i1,:));
                if abs(D)>=eps
                    t=-(dot(norm,poly.points(i1,:))+d)/D;
                    isintersect=true;
                    pint=poly.points(i1,:)+t*(poly.points(i1+1,:)-poly.points(i1,:));
                    intersect=[intersect;pint];
                    startend=[startend i1];
                end
            end
        end
        if ~isintersect || length(startend)~=2 || startend(1)==startend(2)
            if p1in
                face=poly;
            else
                face=[];
            end
            intersect=[];
            return;
        end
        [startend,index]=sort(startend);
        intersect=intersect(index,:);
        centi=floor((startend(1)+startend(2)+1)/2);
        if dot(norm,poly.points(centi,:))+d>-eps   %if out 
            face=genPolyFromPoints([poly.points(1:startend(1),:);intersect(:,:);poly.points((startend(2)+1):poly.np,:)]);
        else % if in
            face=genPolyFromPoints([intersect(1,:);poly.points((startend(1)+1):startend(2),:);intersect(2,:)]);
        end
        if face.np == 0
            face=[];
        end
    end
    
    function poly=findpoly(plist)
        points=[];
        current=1;
        visited=repmat(false,1,length(plist)/2);
        for i1=1:length(plist)/2
            visited(current)=true;
            points=[points;plist(current*2-1,:)];
            if i1*2==length(plist)
                break;
            end
            for j1=1:length(plist)
                if ~visited(idivide(j1+1,int32(2),'floor')) && ...
                        sqrt(sum((plist(j1,:)-plist(current*2,:)).^2)) < eps
                    if mod(j1,2)==0
                        t=plist(j1,:);
                        plist(j1,:)=plist(j1-1,:);
                        plist(j1-1,:)=t;
                    end
                    current=idivide(j1+1,int32(2),'floor');
                    break;
                end
            end
        end
        poly=genPolyFromPoints(points);
    end
%     polygon=genPolyFromPoints([-1,0,0;0,0,0;1,0.5,0;0,2,0;-1,2,0]);
%     [f,p]=intersectPolyPlane(polygon,[0,2,0])
%     brillouin=[];
%     return;
    V = dot(cross(a(1,:),a(2,:)),a(3,:));
    b(1,:)=2*pi/V*cross(a(2,:),a(3,:));
    b(2,:)=2*pi/V*cross(a(3,:),a(1,:));
    b(3,:)=2*pi/V*cross(a(1,:),a(2,:));
    
    maxb=1;

    p((0:3)+1,:)=repmat(-b(1,:)*maxb,4,1);
    p((4:7)+1,:)=repmat(b(1,:)*maxb,4,1);
    p([0 1 4 5]+1,:)=p([0 1 4 5]+1,:)-repmat(b(2,:)*maxb,4,1);
    p([2 3 6 7]+1,:)=p([2 3 6 7]+1,:)+repmat(b(2,:)*maxb,4,1);
    p((0:2:6)+1,:)=p((0:2:6)+1,:)-repmat(b(3,:)*maxb,4,1);
    p((1:2:7)+1,:)=p((1:2:7)+1,:)+repmat(b(3,:)*maxb,4,1);
    

    f1=genPolyFromPoints(p([0 4 5 1]+1,:));
    f2=genPolyFromPoints(p([0 4 6 2]+1,:));
    f3=genPolyFromPoints(p([7 6 2 3]+1,:));
    f4=genPolyFromPoints(p([1 5 7 3]+1,:));
    f5=genPolyFromPoints(p([0 1 3 2]+1,:));
    f6=genPolyFromPoints(p([5 4 6 7]+1,:));
    

    brillouin=[f1;f2;f3;f4;f5;f6];
    
    for i=-maxb:maxb
        for j=-maxb:maxb
            for k=-maxb:maxb
                if i==0 && j==0 && k==0
                    continue;
                end
                K=[i j k]*b;
                newb=[];
                iplist=[];
                for face=brillouin'
                    [newface,ipoints]=intersectPolyPlane(face,K);
                    newb=[newb; newface];
                    iplist=[iplist;ipoints];
                end
                newface=findpoly(iplist);
                brillouin=[newb; newface];
                cla;
                plot_brillouin(brillouin);
                view(3);
                xlabel('k_x');
                ylabel('k_y');
                zlabel('k_z');
                drawnow;
            end
        end
    end
    i=1;
    while i<=length(brillouin)
        area=0;
        for j=2:brillouin(i).np-1
            s=cross(brillouin(i).points(j,:)-brillouin(i).points(1,:),brillouin(i).points(j+1,:)-brillouin(i).points(1,:));
            area=area+s;
        end
        if(sqrt(sum(area.^2))<eps)
            brillouin(i)=[];
        else
            i=i+1;
        end
    end
    
    %% draw 3D BZ in new figure
    %%
    % change current axes
    axes(handles.axes_3D_BZ);  
    cla(handles.axes_3D_BZ,'reset');
    %%
    % coordinate of all reciprocal lattice points
    N=str2num(get(handles.edit_NxNyNz,'String'));
    if isempty(N)
        msgbox('style [Nx,Ny,Nz] is required!','Error','error','replace');
        return;
    elseif N-floor(N)~=0
        msgbox('integer [Nx,Ny,Nz] is required!','Error','error','replace');
        return;
    end
    Nx=N(1);
    Ny=N(2);
    Nz=N(3);

    num=1;
    N=zeros(Nx*Ny*Nz,3);
    for n1=floor(-Nx/2)+1:floor(Nx/2)
        for n2=floor(-Ny/2)+1:floor(Ny/2)
            for n3=floor(-Nz/2)+1:floor(Nz/2)
                N(num,1)=n1;
                N(num,2)=n2;
                N(num,3)=n3;
                num=num+1;
            end
        end
    end
    Point=N*b; %coordinate of all reciprocal lattice points 
    %%
    % draw 3D BZ one by one
    for ii=1:Nx*Ny*Nz
        bz=brillouin; % first BZ at zero point
        for jj=1:length(bz)
            bz(jj,1).points=bz(jj,1).points+repmat(Point(ii,:),bz(jj,1).np+1,1);
        end  % new BZ at Point(ii)
        plot_brillouin(bz);
    end
    view(3);
    axis tight;
    xlabel('k_x');
    ylabel('k_y');
    zlabel('k_z');
    %% end of draw 3D BZ in new figure    
    
end