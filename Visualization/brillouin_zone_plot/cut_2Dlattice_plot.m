function output = cut_2Dlattice_plot( handles )
%Plot real space cut 2D lattice 
%   surface MillerPC
%   output is new handles 
%% calculate normal vector of surface MillerPC 
a=gen_realspace_basevector(handles);
b1=cross(a(2,:),a(3,:));
b2=cross(a(3,:),a(1,:));
b3=cross(a(1,:),a(2,:)); 
MillerPC=str2num(get(handles.edit_MillerPC,'String'));
if isempty(MillerPC)
    msgbox('Miller style [h1,h2,h3] is required!','Error','error','replace');
    return;
elseif MillerPC-floor(MillerPC)~=0
    msgbox('Miller integer [h1,h2,h3] is required!','Error','error','replace');
    return;
end
NormalVector=MillerPC*[b1;b2;b3];
NormalVector=NormalVector/sqrt((NormalVector*NormalVector'));

%% all real space lattice points in bulk NxNyNz
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
for n1=1:Nx
    for n2=1:Ny
        for n3=1:Nz
            N(num,1)=n1;
            N(num,2)=n2;
            N(num,3)=n3;
            num=num+1;
        end
    end
end
Point_all=N*a; %coordinate of all lattice points 

%% find points in surface MillerPC
Point_middle=round([Nx,Ny,Nz]/2)*a;   %surface passes the middle point of bulk
Point_vector=Point_all-repmat(Point_middle,Nx*Ny*Nz,1);
distance=Point_vector*NormalVector';

RoundRes=1e-10;  % computer round resolution
Res=str2double(get(handles.edit_Resolution,'String')); %experiment resolution  
Res=abs(Res);

Point_up=zeros(Nx*Ny*Nz,1);
Point_down=zeros(Nx*Ny*Nz,1); %index 
if get(handles.CheckBox_up,'Value')
    for i=1:Nx*Ny*Nz
        if distance(i)<Res+RoundRes && distance(i)>0.0-RoundRes
            Point_up(i)=0.5;
        end
    end
end
if get(handles.CheckBox_down,'Value')
    for i=1:Nx*Ny*Nz
        if distance(i)<0.0+RoundRes && distance(i)>-RoundRes-Res
            Point_down(i)=0.5;
        end
    end
end
if (~get(handles.CheckBox_up,'Value'))&&(~get(handles.CheckBox_down,'Value'))
    for i=1:Nx*Ny*Nz
        if distance(i)<RoundRes && distance(i)>0.0-RoundRes
            Point_up(i)=0.5;
        end
    end
end
index_surf=round(Point_up+Point_down); %merge and erase repetition
num=length(index_surf(index_surf>0));
Point_surf=zeros(num,3);
num=1;
for i=1:Nx*Ny*Nz
    if index_surf(i)>0
        Point_surf(num,1)=Point_all(i,1);
        Point_surf(num,2)=Point_all(i,2);
        Point_surf(num,3)=Point_all(i,3);
        num=num+1;
    end
end
    
%% plot surface in 3D lattice
cla(handles.axes1,'reset');
scatter3(handles.axes1,Point_all(:,1),Point_all(:,2),Point_all(:,3),400,'.');
hold on;
% Color_cut = repmat([1,0,0],numel(Point_surf)/3,1); %red
scatter3(handles.axes1,Point_surf(:,1),Point_surf(:,2),Point_surf(:,3),...
    1000,'red','.');
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
box on;
hold off;

%% plot surface in 2D
% for points not exactly in surface MillerPC, projection is adopted
surf_vector=Point_surf-repmat(Point_middle,num-1,1);

x=surf_vector(2,:)-surf_vector(1,:);
x=x/sqrt(x*x');
y=cross(NormalVector,x);

X=surf_vector*x';
Y=surf_vector*y';

handles.fig_2D_cut_lattice=figure(10);
set(handles.fig_2D_cut_lattice,'Name','2D cut lattice');
scatter(X,Y,800,'.');
xlabel('x');
ylabel('y');
axis equal;
box on;

%%
handles.X=X;
handles.Y=Y;
output=handles;
end