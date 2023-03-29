function varargout = brillouin_zone_plot(varargin)
% BRILLOUIN_ZONE_PLOT MATLAB code for brillouin_zone_plot.fig
%      This GUI can generate and cut both real space lattice and corresponding
%      Brillouin zone of 14 basic Bravais lattices
%
%      Contributors:
%      Yuan Cao, caoyuan@mit.edu, 01/Oct./2013,  about first BZ gen and cut  
%      Shuzhan Sun, sunshu@mail.ustc.edu.cn, 25/Aug./2015, modification

% Last Modified by GUIDE v2.5 27-Aug-2015 09:16:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @brillouin_zone_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @brillouin_zone_plot_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before brillouin_zone_plot is made visible.
function brillouin_zone_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to brillouin_zone_plot (see VARARGIN)

% Choose default command line output for brillouin_zone_plot
handles.output = hObject;
% set(handles.ButtonGroup_UnitCell,'SelectionChangeFcn',...
%     @UnitCell_SelectionChangeFcn);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes brillouin_zone_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = brillouin_zone_plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function a_length_Callback(hObject, eventdata, handles)
% hObject    handle to a_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_length as text
%        str2double(get(hObject,'String')) returns contents of a_length as a double


% --- Executes during object creation, after setting all properties.
function a_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b_length_Callback(hObject, eventdata, handles)
% hObject    handle to b_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b_length as text
%        str2double(get(hObject,'String')) returns contents of b_length as a double


% --- Executes during object creation, after setting all properties.
function b_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c_length_Callback(hObject, eventdata, handles)
% hObject    handle to c_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c_length as text
%        str2double(get(hObject,'String')) returns contents of c_length as a double


% --- Executes during object creation, after setting all properties.
function c_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beta_Callback(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beta as text
%        str2double(get(hObject,'String')) returns contents of beta as a double


% --- Executes during object creation, after setting all properties.
function beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma as text
%        str2double(get(hObject,'String')) returns contents of gamma as a double


% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_bz_3d.
function plot_bz_3d_Callback(hObject, eventdata, handles)
% hObject    handle to plot_bz_3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

alpha=str2double(get(handles.alpha,'String'))/180*pi;
beta=str2double(get(handles.beta,'String'))/180*pi;
gamma=str2double(get(handles.gamma,'String'))/180*pi;
a=str2double(get(handles.a_length,'String'));
b=str2double(get(handles.b_length,'String'));
c=str2double(get(handles.c_length,'String'));

a1=a*[1,0,0];
a2=b*[cos(gamma),sin(gamma),0];
a31=c*cos(beta);
A=1+(a2(3)/a2(2))^2;
B=-2*a2(3)*(b-a2(1))*c*cos(beta)/a2(2);
C=(b-a2(1))^2*c^2*cos(beta)^2/a2(2)^2-c^2+a31^2;
if B^2-4*A*C<0
    return;
end
a33=(-B+sqrt(B^2-4*A*C))/2/A;
a32=((b-a2(1))*c*cos(beta)-a33*a2(3))/a2(2);
a3=[a31,a32,a33];
a=[a1;a2;a3];

if get(handles.bcc,'Value')
    a=[-0.5,0.5,0.5;0.5,-0.5,0.5;0.5,0.5,-0.5]*a;
elseif get(handles.fcc,'Value')
    a=[0,0.5,0.5;0.5,0,0.5;0.5,0.5,0]*a;
end

% figure;
% axis equal;
% hold on;
% plot3([0,a(1,1)],[0,a(1,2)],[0,a(1,3)]);
% plot3([0,a(2,1)],[0,a(2,2)],[0,a(2,3)]);
% plot3([0,a(3,1)],[0,a(3,2)],[0,a(3,3)]);
% hold off;

%figure(str2double(get(handles.fig_num,'String')));
h=figure(22);
cla(h,'reset');
set(h,'Name','3D Brillouin Zone');
handles.axes_3D_BZ=axes;
cla(handles.axes_3D_BZ,'reset');
axes(handles.axes1);
cla(handles.axes1,'reset');
handles.brillouin=gen_brillouin(a,handles);

guidata(handles.figure1,handles);

function fig_num_Callback(hObject, eventdata, handles)
% hObject    handle to fig_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fig_num as text
%        str2double(get(hObject,'String')) returns contents of fig_num as a double


% --- Executes during object creation, after setting all properties.
function fig_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fig_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fig_num_inc.
function fig_num_inc_Callback(hObject, eventdata, handles)
% hObject    handle to fig_num_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fignum=str2double(get(handles.fig_num,'String'));
set(handles.fig_num,'String',num2str(fignum+1));

% --- Executes on button press in fig_num_dec.
function fig_num_dec_Callback(hObject, eventdata, handles)
% hObject    handle to fig_num_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fignum=str2double(get(handles.fig_num,'String'));
set(handles.fig_num,'String',num2str(max(fignum-1,1)));



function theta_Callback(hObject, eventdata, handles)
% hObject    handle to theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta as text
%        str2double(get(hObject,'String')) returns contents of theta as a double
update_cut(handles);

% --- Executes during object creation, after setting all properties.
function theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in theta_inc.
function theta_inc_Callback(hObject, eventdata, handles)
% hObject    handle to theta_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta=str2double(get(handles.theta,'String'));
set(handles.theta,'String',num2str(min(180,theta+1)));
update_cut(handles);


% --- Executes on button press in theta_dec.
function theta_dec_Callback(hObject, eventdata, handles)
% hObject    handle to theta_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta=str2double(get(handles.theta,'String'));
set(handles.theta,'String',num2str(max(0,theta-1)));
update_cut(handles);


function phi_Callback(hObject, eventdata, handles)
% hObject    handle to phi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phi as text
%        str2double(get(hObject,'String')) returns contents of phi as a double
update_cut(handles);

% --- Executes during object creation, after setting all properties.
function phi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in phi_inc.
function phi_inc_Callback(hObject, eventdata, handles)
% hObject    handle to phi_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

phi=str2double(get(handles.phi,'String'));
set(handles.phi,'String',num2str(min(360,phi+1)));
update_cut(handles);

% --- Executes on button press in phi_dec.
function phi_dec_Callback(hObject, eventdata, handles)
% hObject    handle to phi_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

phi=str2double(get(handles.phi,'String'));
set(handles.phi,'String',num2str(max(0,phi-1)));
update_cut(handles);


function displace_Callback(hObject, eventdata, handles)
% hObject    handle to displace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of displace as text
%        str2double(get(hObject,'String')) returns contents of displace as a double
update_cut(handles);

% --- Executes during object creation, after setting all properties.
function displace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to displace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in disp_inc.
function disp_inc_Callback(hObject, eventdata, handles)
% hObject    handle to disp_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d=str2double(get(handles.displace,'String'));
a=str2double(get(handles.a_length,'String'));
b=str2double(get(handles.b_length,'String'));
c=str2double(get(handles.c_length,'String'));
set(handles.displace,'String',num2str(d+0.1*(a*b*c)^(-1/3)));
update_cut(handles);

% --- Executes on button press in disp_dec.
function disp_dec_Callback(hObject, eventdata, handles)
% hObject    handle to disp_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d=str2double(get(handles.displace,'String'));
a=str2double(get(handles.a_length,'String'));
b=str2double(get(handles.b_length,'String'));
c=str2double(get(handles.c_length,'String'));
set(handles.displace,'String',num2str(d-0.1*(a*b*c)^(-1/3)));
update_cut(handles);

function update_cut(handles)
%% 'updata_cut', cut BZ function
%%
axes(handles.axes1);
if(~isfield(handles,'cut_handle') || ~ishandle(handles.cut_handle))
    handles.cut_handle=surface(rand(10,10),'FaceColor','None');
    guidata(handles.figure1,handles);
end
theta=str2double(get(handles.theta,'String'))/180*pi;
phi=str2double(get(handles.phi,'String'))/180*pi;
a=str2double(get(handles.a_length,'String'));
b=str2double(get(handles.b_length,'String'));
c=str2double(get(handles.c_length,'String'));
displace=str2double(get(handles.displace,'String'));

%% update the preview cut plane in axes1
n=[sin(theta)*cos(phi),sin(theta)*sin(phi),cos(theta)];
if(isequal(n,[0,0,1]))
    du=[1,0,0];
    dv=[0,1,0];
else
    du=cross([0,0,1],n);
    du=du/norm(du);
    dv=cross(n,du);
    dv=dv/norm(dv);
end
% u=linspace(-1,1,20)*(a*b*c)^(-1/3)*4;
% v=linspace(-1,1,20)*(a*b*c)^(-1/3)*4;
% u=linspace(-1,1,2)*(a*b*c)^(-1/3)*4;
% v=linspace(-1,1,2)*(a*b*c)^(-1/3)*4;
u=get(handles.axes1,'XLim');
v=get(handles.axes1,'YLim');
[u,v]=meshgrid(u,v);
center=displace*n;
x=center(1)+du(1)*u+dv(1)*v;
y=center(2)+du(2)*u+dv(2)*v;
z=center(3)+du(3)*u+dv(3)*v;
set(handles.cut_handle,'XData',x);
set(handles.cut_handle,'YData',y);
set(handles.cut_handle,'ZData',z);
set(handles.cut_handle,'EdgeColor','red');
axis(handles.axes1,'equal');
axis(handles.axes1,'tight');

%% update cross-section in the new figure
fignum=str2double(get(handles.fig_num,'String'));
if(isfield(handles,'brillouin') && ishandle(fignum))
    %figure(str2double(get(handles.fig_num,'String')));
    set(0,'CurrentFigure',fignum);
    if(~get(handles.hold,'Value'))
        clf;
    end
    %cut_brillouin(handles.brillouin,n,displace);
    %% new cut with larger scale NxNyNz
    %%
      % base vectors of reciprocal lattice
    a=gen_realspace_basevector(handles);
    V=dot(a(1,:),cross(a(2,:),a(3,:)));
    b1=cross(a(2,:),a(3,:));
    b2=cross(a(3,:),a(1,:));
    b3=cross(a(1,:),a(2,:));
    b=[b1;b2;b3]*2*pi/V; 
    %%
      %coordinate of all reciprocal lattice points
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
      %distance, lattice point 2 cut surface in reciprocal space
%     MiddleBZ=floor([Nx,Ny,Nz]/2)*b;
%     center=center+MiddleBZ; % center of cut surface
%     distance=displace+MiddleBZ*n'-Point*n'; 
    distance=displace-Point*n';
    %%
      %cut BZ one by one
    for i=1:Nx*Ny*Nz
        bz=handles.brillouin; % first BZ at zero point
        for j=1:length(bz)
            bz(j,1).points=bz(j,1).points+repmat(Point(i,:),bz(j,1).np+1,1);
        end  % new BZ at Point(i)     
        cut_brillouin(bz,n,distance(i),center);
    end
    %% end of new cut
    
end

%% update cut plane in axes_3D_BZ in figure 3D Brillouin Zone
axes(handles.axes_3D_BZ); % change current axes
if(~isfield(handles,'cut_handle_new') || ~ishandle(handles.cut_handle_new))
    handles.cut_handle_new=surface(rand(10,10),'FaceColor','None');
    % guidata(handles.figure2,handles);
end
% N=str2num(get(handles.edit_NxNyNz,'String'));
% u=linspace(-1,1,2)*(a*b*c)^(-1/3)*4*(N(1)*N(2)*N(3))^(1/3);
% v=linspace(-1,1,2)*(a*b*c)^(-1/3)*4*(N(1)*N(2)*N(3))^(1/3);
u=get(handles.axes_3D_BZ,'XLim');
v=get(handles.axes_3D_BZ,'YLim');
[u,v]=meshgrid(u,v);
x=center(1)+du(1)*u+dv(1)*v;
y=center(2)+du(2)*u+dv(2)*v;
z=center(3)+du(3)*u+dv(3)*v;
set(handles.cut_handle_new,'XData',x);
set(handles.cut_handle_new,'YData',y);
set(handles.cut_handle_new,'ZData',z);
set(handles.cut_handle_new,'EdgeColor','red');
axis(handles.axes_3D_BZ,'equal');
axis(handles.axes_3D_BZ,'tight');


drawnow;


% --- Executes on button press in plot_bz_cut.
function plot_bz_cut_Callback(hObject, eventdata, handles)
% hObject    handle to plot_bz_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(str2double(get(handles.fig_num,'String')));
update_cut(handles);

% --- Executes on button press in hold.
function hold_Callback(hObject, eventdata, handles)
% hObject    handle to hold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hold


function edit_NxNyNz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NxNyNz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NxNyNz as text
%        str2double(get(hObject,'String')) returns contents of edit_NxNyNz as a double


% --- Executes during object creation, after setting all properties.
function edit_NxNyNz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NxNyNz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_Plot3D_Lattice.
function pb_Plot3D_Lattice_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Plot3D_Lattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=gen_realspace_basevector(handles);

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
Point=N*a; %coordinate of all lattice point 

%axes(handles.axes1);
cla(handles.axes1,'reset');
%scatter3(handles.axes1,Point(:,1),Point(:,2),Point(:,3),1200,'.');
scatter3(handles.axes1,Point(:,1),Point(:,2),Point(:,3),1200,N(:,1),'.');
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
axis tight;
box on;
guidata(hObject,handles);


function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MillerPC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MillerPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MillerPC as text
%        str2double(get(hObject,'String')) returns contents of edit_MillerPC as a double
MillerPC=str2num(get(handles.edit_MillerPC,'String'));
if isempty(MillerPC)
    msgbox('style [h1,h2,h3] is required!','Error','error','replace');
    return;
elseif MillerPC-floor(MillerPC)~=0
    msgbox('integer [h1,h2,h3] is required!','Error','error','replace');
    return;
end
p1=MillerPC(1);
p2=MillerPC(2);
p3=MillerPC(3);
divisor_p=gcd(gcd(p1,p2),p3);
if divisor_p~=1
    MillerPC=MillerPC/divisor_p;
    set(handles.edit_MillerPC,'String',['[',num2str(MillerPC),']']);
end
MillerUC=MillerPC;

if get(handles.bcc,'Value')
    u1=(p2+p3);
    u2=(p1+p3);
    u3=(p1+p2);
    divisor_u=gcd(gcd(u1,u2),u3);
    MillerUC=[u1,u2,u3]/divisor_u;
elseif get(handles.fcc,'Value')
    u1=p3+p2-p1;
    u2=p3-p2+p1;
    u3=-p3+p2+p1;
    divisor_u=gcd(gcd(u1,u2),u3);
    MillerUC=[u1,u2,u3]/divisor_u;
end

set(handles.edit_MillerUC,'String',['[',num2str(MillerUC),']']);

%% calculate theta and phi in 'k-space cut' panel 
%  generally, a series of real space surfaces with Miller(h1,h2,h3), only 
%  correspond to a vector h*b in reciprocal lattice, but for ARPES, we can
%  do such treatment, see guidebook for this GUI by Shuzhan Sun

  %%
    % base vectors of reciprocal lattice
a=gen_realspace_basevector(handles);
V=dot(a(1,:),cross(a(2,:),a(3,:)));
b1=cross(a(2,:),a(3,:));
b2=cross(a(3,:),a(1,:));
b3=cross(a(1,:),a(2,:));
b=[b1;b2;b3]*2*pi/V; 
  %%
    % normal vector n of the surface
n=MillerPC*b; 
n=n/sqrt(n*n');
  %%
theta=acos(n(3));
if sin(theta)<1e-10
    phi=0;
else
    phi=acos(n(1)/sin(theta));
end
set(handles.theta,'String',num2str(theta*180/pi));
set(handles.phi,'String',num2str(phi*180/pi));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_MillerPC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MillerPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MillerUC_Callback(~, ~, handles)
% hObject    handle to edit_MillerUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MillerUC=str2num(get(handles.edit_MillerUC,'String'));
if isempty(MillerUC)
    msgbox('style [h1,h2,h3] is required!','Error','error','replace');
    return;
elseif MillerUC-floor(MillerUC)~=0
    msgbox('integer [h1,h2,h3] is required!','Error','error','replace');
    return;
end
u1=MillerUC(1);
u2=MillerUC(2);
u3=MillerUC(3);
divisor_u=gcd(gcd(u1,u2),u3);
if divisor_u~=1
    MillerUC=MillerUC/divisor_u;
    set(handles.edit_MillerUC,'String',['[',num2str(MillerUC),']']);
end
MillerPC=MillerUC;

if get(handles.bcc,'Value')
    p1=u3+u2-u1;
    p2=u3-u2+u1;
    p3=-u3+u2+u1;
    divisor_p=gcd(gcd(p1,p2),p3);
    MillerPC=[p1,p2,p3]/divisor_p;
elseif get(handles.fcc,'Value')
    p1=u3+u2;
    p2=u3+u1;
    p3=u2+u1;
    divisor_p=gcd(gcd(p1,p2),p3);
    MillerPC=[p1,p2,p3]/divisor_p;
end

set(handles.edit_MillerPC,'String',['[',num2str(MillerPC),']']);

%% calculate theta and phi in 'k-space cut' panel 
%  generally, a series of real space surfaces with Miller(h1,h2,h3), only 
%  correspond to a vector h*b in reciprocal lattice, but for ARPES, we can
%  do such treatment, see guidebook for this GUI by Shuzhan Sun

  %%
    % base vectors of reciprocal lattice
a=gen_realspace_basevector(handles);
V=dot(a(1,:),cross(a(2,:),a(3,:)));
b1=cross(a(2,:),a(3,:));
b2=cross(a(3,:),a(1,:));
b3=cross(a(1,:),a(2,:));
b=[b1;b2;b3]*2*pi/V; 
  %%
    % normal vector n of the surface
n=MillerPC*b; 
n=n/sqrt(n*n');
  %%
theta=acos(n(3));
if sin(theta)<1e-10
    phi=0;
else
    phi=acos(n(1)/sin(theta));
end
set(handles.theta,'String',num2str(theta*180/pi));
set(handles.phi,'String',num2str(phi*180/pi));
%guidata(hObject,handles);



% Hints: get(hObject,'String') returns contents of edit_MillerUC as text
%        str2double(get(hObject,'String')) returns contents of edit_MillerUC as a double


% --- Executes during object creation, after setting all properties.
function edit_MillerUC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MillerUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Resolution_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=cut_2Dlattice_plot(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_Resolution as text
%        str2double(get(hObject,'String')) returns contents of edit_Resolution as a double


% --- Executes during object creation, after setting all properties.
function edit_Resolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_Resolution_Add.
function pb_Resolution_Add_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Resolution_Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Resolution=str2double(get(handles.edit_Resolution,'String'));
set(handles.edit_Resolution,'String',num2str(Resolution+0.1));
handles=cut_2Dlattice_plot(handles);
guidata(hObject,handles);


% --- Executes on button press in pb_Resolution_Subtract.
function pb_Resolution_Subtract_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Resolution_Subtract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Resolution=str2double(get(handles.edit_Resolution,'String'));
set(handles.edit_Resolution,'String',num2str(Resolution-0.1));
handles=cut_2Dlattice_plot(handles);
guidata(hObject,handles);

% --- Executes on button press in CheckBox_up.
function CheckBox_up_Callback(hObject, eventdata, handles)
% hObject    handle to CheckBox_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
handles=cut_2Dlattice_plot(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of CheckBox_up


% --- Executes on button press in CheckBox_down.
function CheckBox_down_Callback(hObject, eventdata, handles)
% hObject    handle to CheckBox_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
handles=cut_2Dlattice_plot(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of CheckBox_down


% --- Executes on button press in pb_Plot2DCut_Lattice.
function pb_Plot2DCut_Lattice_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Plot2DCut_Lattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
handles=cut_2Dlattice_plot(handles);
guidata(hObject,handles);

% --- Executes on button press in CheckBox_newfig.
function CheckBox_newfig_Callback(hObject, eventdata, handles)
% hObject    handle to CheckBox_newfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckBox_newfig


% --- Executes on button press in pb_Plot_Reciprocal_Lattice.
function pb_Plot_Reciprocal_Lattice_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Plot_Reciprocal_Lattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
handles=cut_2Dlattice_plot(handles);
%% find basic real space lattice cell
% a1 a2 are base vectors
X=handles.X;
Y=handles.Y;
Res=1e-10; % computer calculate resolution
x1=X(abs(Y)<Res);
a1=[min(x1(x1>Res)),0];
a2=[0,min(Y(Y>Res))];
x2=X(abs(Y-a2(2))<Res);
a2(1)=min(x2(x2>(0-Res)));
%% reciprocal lattice base vectors
b1=[2*pi/a1(1),0];
b1(2)=-b1(1)*a2(1)/a2(2);
b2=[0,2*pi/a2(2)];

%% plot 
ax=[0,a1(1),a1(1)+a2(1),a2(1),0];
ay=[0,a1(2),a1(2)+a2(2),a2(2),0];
bx=[0,b1(1),b1(1)+b2(1),b2(1),0];
by=[0,b1(2),b1(2)+b2(2),b2(2),0];
if ~get(handles.CheckBox_newfig,'Value')%plot real and reciprocal in one fig
    figure(handles.fig_2D_cut_lattice);
    line(bx,by,'Color','red');
    line(ax,ay,'Color','blue');
else 
    h=figure(11);
    set(h,'Name','Reciprocal lattice cell');
    line(bx,by,'Color','red');
end
guidata(hObject,handles);


% function UnitCell_SelectionChangeFcn(handles, eventdata)
% edit_MillerUC_Callback(1,1 ,handles);


% --- Executes when selected object is changed in ButtonGroup_UnitCell.
function ButtonGroup_UnitCell_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ButtonGroup_UnitCell 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit_MillerUC_Callback(hObject, eventdata, handles);
