function planar_poly = cut_brillouin( brillouin, normal, displace, center )
%cut_brillouin
%   input: generated Brillouin Zone represented by a set of 3D planar
%   polygons which forms a polyhedral. normal and displace specifies the
%   cut-plane to cut the BZ.
%   center: center point of cut surface
    eps=1e-10;
    function poly=genPolyFromPoints(points)
        if(isempty(points))
            poly=[];
            return;
        end
        poly.points=[points;points(1,:)];
        poly.np=length(points);
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
                        temp=plist(j1,:);
                        plist(j1,:)=plist(j1-1,:);
                        plist(j1-1,:)=temp;
                    end
                    current=idivide(j1+1,int32(2),'floor');
                    break;
                end
            end
        end
        poly=genPolyFromPoints(points);
    end
% cent=normal*displace;
cent=center;
d=-dot(normal,cent);
pts=[];
for poly=brillouin'
    intersect=[];
    startend=[];
    isintersect=false;
    for i=1:(poly.np)
        p1in=(dot(normal,poly.points(i,:))+d<-eps);
        p2in=(dot(normal,poly.points(i+1,:))+d<-eps);
        if xor(p1in,p2in)
            D=dot(normal,poly.points(i+1,:)-poly.points(i,:));
            if abs(D)>=eps
                t=-(dot(normal,poly.points(i,:))+d)/D;
                isintersect=true;
                pint=poly.points(i,:)+t*(poly.points(i+1,:)-poly.points(i,:));
                intersect=[intersect;pint];
                startend=[startend i];
            end
        end
    end
    if ~isintersect || length(startend)~=2 || startend(1)==startend(2)
        continue;
    end
    pts=[pts;intersect];
end

if isempty(pts)
    return;
end

%% find base vectors in cut surface
if(isequal(normal,[0,0,1]))
    du=[1,0,0];
    dv=[0,1,0];
else
    du=cross([0,0,1],normal);
    du=du/norm(du);
    dv=cross(normal,du);
    dv=dv/norm(dv);
end

%% project points pts to the surface
if(abs(du(2)*dv(3)-du(3)*dv(2)) > eps)
    delta=du(2)*dv(3)-du(3)*dv(2);
    u=((pts(:,2)-cent(2))*dv(3)-(pts(:,3)-cent(3))*dv(2))/delta;
    v=(du(2)*(pts(:,3)-cent(3))-du(3)*(pts(:,2)-cent(2)))/delta;
elseif(abs(du(1)*dv(2)-du(2)*dv(1)) > eps)
    delta=du(1)*dv(2)-du(2)*dv(1);
    u=((pts(:,1)-cent(1))*dv(2)-(pts(:,2)-cent(2))*dv(1))/delta;
    v=(du(1)*(pts(:,2)-cent(2))-du(2)*(pts(:,1)-cent(1)))/delta;
else
    delta=du(1)*dv(3)-du(3)*dv(1);
    u=((pts(:,1)-cent(1))*dv(3)-(pts(:,3)-cent(3))*dv(1))/delta;
    v=(du(1)*(pts(:,3)-cent(3))-du(3)*(pts(:,1)-cent(1)))/delta;
end
% pts=pts-repmat(center,length(pts),1);
% u=pts*du';
% v=pts*dv';
pts=[u,v,zeros(size(u))];

planar_poly=findpoly(pts);
plot_brillouin(planar_poly);
end

