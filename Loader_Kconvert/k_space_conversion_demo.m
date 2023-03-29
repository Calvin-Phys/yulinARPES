function varargout = k_space_conversion_demo(varargin)
% k_space_conversion_demo M-file for k_space_conversion_demo.fig
%      k_space_conversion_demo, by itself, creates a new k_space_conversion_demo or raises the existing
%      singleton*.
%
%      H = k_space_conversion_demo returns the handle to a new k_space_conversion_demo or the handle to
%      the existing singleton*.
%
%      k_space_conversion_demo('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in k_space_conversion_demo.M with the given input arguments.
%
%      k_space_conversion_demo('Property','Value',...) creates a new k_space_conversion_demo or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before k_space_conversion_demo_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to k_space_conversion_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help k_space_conversion_demo

% Last Modified by GUIDE v2.5 04-Mar-2015 21:31:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @k_space_conversion_demo_OpeningFcn, ...
    'gui_OutputFcn',  @k_space_conversion_demo_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before k_space_conversion_demo is made visible.
function k_space_conversion_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to k_space_conversion_demo (see VARARGIN)

% Choose default command line output for k_space_conversion_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes k_space_conversion_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = k_space_conversion_demo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.



% --- Executes during object creation, after setting all properties.
function ek_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ek (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ek_Callback(hObject, eventdata, handles)
% hObject    handle to ek (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of ek as text
%        str2double(get(hObject,'String')) returns contents of ek as a double


% --- Executes during object creation, after setting all properties.
function latt_const_CreateFcn(hObject, eventdata, handles)
% hObject    handle to latt_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function latt_const_Callback(hObject, eventdata, handles)
% hObject    handle to latt_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of latt_const as text
%        str2double(get(hObject,'String')) returns contents of latt_const as a double


% --- Executes during object creation, after setting all properties.
function kz_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kz_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function kz_offset_Callback(hObject, eventdata, handles)
% hObject    handle to kz_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kz_offset as text
%        str2double(get(hObject,'String')) returns contents of kz_offset as a double


% --- Executes during object creation, after setting all properties.
function energy_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energy_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function energy_offset_Callback(hObject, eventdata, handles)
% hObject    handle to energy_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of energy_offset as text
%        str2double(get(hObject,'String')) returns contents of energy_offset as a double


% --- Executes during object creation, after setting all properties.
function theta_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function theta_offset_Callback(hObject, eventdata, handles)
% hObject    handle to theta_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of theta_offset as text
%        str2double(get(hObject,'String')) returns contents of theta_offset as a double


% --- Executes during object creation, after setting all properties.
function phi_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phi_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function phi_offset_Callback(hObject, eventdata, handles)
% hObject    handle to phi_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phi_offset as text
%        str2double(get(hObject,'String')) returns contents of phi_offset as a double


% --- Executes on button press in convert_to_k.
function convert_to_k_Callback(hObject, eventdata, handles)
% hObject    handle to convert_to_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%=====================start converting=========================
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
VarNames = handles_h.VarNames;
var_name = VarNames{1};  %get var_name
ind=regexp(var_name,'_k_sp');
if ~isempty(ind)
    var_name=var_name(1:ind-1);
end
data=evalin('base',var_name);
data_k=data;
% data_k=rmfield(data_k,'x');
% data_k=rmfield(data_k,'y');
% if isfield(data,'z')
%     data_k=rmfield(data_k,'z');
% end
% data_k=rmfield(data_k,'value');
nx=length(data.x);
ny=length(data.y);
%nz=length(data.z);

ekv=str2num(get(handles.ek,'String'));
latt_constv=1e-10*str2num(get(handles.latt_const,'String'));
kz_offsetv=str2num(get(handles.kz_offset,'String'));
energy_offsetv=str2num(get(handles.energy_offset,'String'));
theta_offsetv=-str2num(get(handles.theta_offset,'String'))*pi/180; % negtive sign is just for user's habit
phi_offsetv=str2num(get(handles.phi_offset,'String'))*pi/180;
sample_rotationv=-str2num(get(handles.sample_rotation,'String'))*pi/180;% negtive sign is just for user's habit
k_space_stepv=str2num(get(handles.k_space_step,'String'));
ky_stepv=str2num(get(handles.ky_step,'String'));


% rotation matrix
rx=[[1,0,0]',[0,cos(phi_offsetv),-sin(phi_offsetv)]',[0,sin(phi_offsetv),cos(phi_offsetv)]'];
ry=[[cos(theta_offsetv),0,sin(theta_offsetv)]',[0,1,0]',[-sin(theta_offsetv),0,cos(theta_offsetv)]'];
rz=[[cos(sample_rotationv),-sin(sample_rotationv),0]',[sin(sample_rotationv),cos(sample_rotationv),0]',[0,0,1]'];
R=rz*rx*ry;


% just data format
% if ~isfield(data,'value') | ~isfield(data,'x') | ~isfield(data,'y')
%     errordlg('Data must contain fields: data.Value, data.x, data.y (for 3-D, also data.z)','Wrong data format');
%     return;
% end

if ~(isfield(data,'value') && isfield(data,'x') && isfield(data,'y')) && ~(isprop(data,'value') && isprop(data,'x') && isprop(data,'y'))
    errordlg('Data must contain fields: data.Value, data.x, data.y (for 3-D, also data.z)','Wrong data format');
    return;
end

ce=1.6021892e-19;
me=9.109534e-31;
h=6.626176e-34;
ekk=ekv*ce;
k_unit=pi/latt_constv;

%---------------if 2-d data--------------
% convention: alpha(data.x) is the analyzer angle
%             phi(data.y) is the angle within a cut
%             theta_offset is offset of the sample normal rotate with beam direction
%             kx is along anlyzer angle direction
%             ky is along angle within a cut
if size(size(data.value),2)==2
    
    data.x=data.x*pi/180; % change unit
    data.y=data.y*pi/180; % change unit
    k0=(sqrt(2*me*ekk)*2*pi/h)/k_unit;
    
    
    % Refer to the codes in for loops below.
    % Basically I need to constrcut matrix for [kx0,ky0,kz0]'
    kx0=sin(data.x)'*cos(data.y);
    ky0=repmat(sin(data.y),[nx 1]);
    kz0=cos(data.x)'*cos(data.y);
    kx=k0*(R(1,1)*kx0+R(1,2)*ky0+R(1,3)*kz0);
    ky=k0*(R(2,1)*kx0+R(2,2)*ky0+R(2,3)*kz0);
    
    
    %--------make new mesh-------------------------
    if k_space_stepv~=-1
        k_stepx=(max(max(kx))-min(min(kx)))/k_space_stepv;
    else
        k_stepx=(max(max(kx))-min(min(kx)))/100;
    end
    
    if ky_stepv~=-1
        k_stepy=(max(max(ky))-min(min(ky)))/ky_stepv;
    else
        k_stepy=(max(max(ky))-min(min(ky)))/100;
    end
    
    kx_grid=[min(min(kx)):k_stepx:max(max(kx))];
    ky_grid=[min(min(ky)):k_stepy:max(max(ky))];
    [XXX,YYY]=ndgrid(kx_grid,ky_grid);
    xxx=reshape(XXX,[length(kx_grid)*length(ky_grid) 1]);
    yyy=reshape(YYY,[length(kx_grid)*length(ky_grid) 1]);
    
    % -------interpolate to 2-D even mesh----------
    xxk=reshape(kx,[nx*ny 1]);
    yyk=reshape(ky,[nx*ny 1]);
    eek=reshape(data.value,[nx*ny 1]);
    F=TriScatteredInterp(xxk,yyk,eek);
    converted=F(xxx,yyy);
    data_k.value=reshape(converted,[length(kx_grid) length(ky_grid)]);
    
    data_k.x=kx_grid;
    data_k.y=ky_grid;
    
end

%----------------------------------------
%---------------if 3-d data--------------
% convention: theta is the analyzer angle
%             phi is the angle within a cut
%             kx is along anlyzer angle direction
%             ky is along angle within a cut
if size(size(data.value),2)==3
    
    nz=length(data.z);
    %Wrong if use: data.x=data.x+theta_offsetv;
    %data.y=data.y+phi_offsetv;
    data.x=data.x*pi/180; % change unit
    data.y=data.y*pi/180; % change unit
    data.z=data.z+energy_offsetv;
    
    %TIMER1
    %disp('step1 begins, matrix method');
    kx0=sin(data.x)'*cos(data.y); % Unit Grid X
    ky0=repmat(sin(data.y),[nx 1]); % Unit Grid Y
    kz0=cos(data.x)'*cos(data.y);
    %spacial factor
    
    kx1 = R(1,1)*kx0+R(1,2)*ky0+R(1,3)*kz0;
    ky1 = R(2,1)*kx0+R(2,2)*ky0+R(2,3)*kz0;
    %rotation
    
    k0_constant = (sqrt(2*me*ce)*2*pi/h) / k_unit;
    k00 = sqrt(data.z) * k0_constant;
    %energy related
    
    kx_min = kx1 * k00(1);
    ky_min = ky1 * k00(1);
    %for searching for the minimum of kx and ky
    
    kx_max = kx1 * k00(length(k00));
    ky_max = ky1 * k00(length(k00));
    %for searching for the maximum of kx and ky
    
    %--------make new mesh-------------------------
    if k_space_stepv~=-1
        k_stepx=(max(max(kx_max))-min(min(kx_min)))/k_space_stepv;
        kx_step = k_space_stepv + 1;
    else
        k_stepx=(max(max(kx_max))-min(min(kx_min)))/100;
        kx_step = 101;
    end
    
    if ky_stepv~=-1
        k_stepy=(max(max(ky_max))-min(min(ky_min)))/ky_stepv;
        ky_step = ky_stepv + 1;
    else
        k_stepy=(max(max(ky_max))-min(min(ky_min)))/100;
        ky_step = 101;
    end
    
    kx_grid = linspace(min(min(kx_min)), max(max(kx_max)), kx_step);
    ky_grid = linspace(min(min(ky_min)), max(max(ky_max)), ky_step);
    [kxx_grid, kyy_grid] = meshgrid(kx_grid, ky_grid);
    % -------interpolate to 2-D even mesh----------
    data_k.x=kx_grid;
    data_k.y=ky_grid;
    data_k.z=data.z;
    
    data_k.value=zeros(size(data_k.x,2),size(data_k.y,2),size(data_k.z,2));
    
    kxList = reshape(kx1, [nx*ny, 1]);
    kyList = reshape(ky1, [nx*ny, 1]);
    eee = reshape(data.value, [nx*ny, nz]);
    tri = delaunayTriangulation(kxList, kyList);
    t_element = [tri(:, :); NaN, NaN, NaN];
    
    % Build Unit Grid
    Nx = ceil(kx_step*1.1);
    Ny = ceil(ky_step*1.1);
    kxGrid=linspace(min(kx1(:)),max(kx1(:)),Nx);
    kyGrid=linspace(min(ky1(:)),max(ky1(:)),Ny);
    
    % Interpolation to non-gridded data
    [kxGrid,kyGrid] = meshgrid(kxGrid,kyGrid);
    [ti, bc] = pointLocation(tri, [kxGrid(:), kyGrid(:)]);
    ti(isnan(ti)) = nx*ny+1;
    ddc = zeros(kx_step, ky_step, nz);
        %    eee(nx * ny + 1,:) = NaN;
    pt = t_element(ti,:);
    triVals3D_1 = eee(pt(:,1),:);
    triVals3D_2 = eee(pt(:,2),:);
    triVals3D_3 = eee(pt(:,3),:);
    bc_1 = repmat(bc(:,1),[1,nz]);
    bc_2 = repmat(bc(:,2),[1,nz]);
    bc_3 = repmat(bc(:,3),[1,nz]);
    ValueNonGrid = bc_1.*triVals3D_1 ...
        +bc_2.*triVals3D_2 ...
        + bc_3.*triVals3D_3;
    tic;
    % Interpolation to gridded data
    ValueNonGrid = reshape(ValueNonGrid,[Ny,Nx,nz]);
    for m = 1:nz
        % Get Gridded data Value2
        kxGrid_m = k00(m)*kxGrid;
        kyGrid_m = k00(m)*kyGrid;
        Value_m = interp2(kxGrid_m,kyGrid_m,ValueNonGrid(:,:,m),...
            kxx_grid,kyy_grid)';
        ddc(:, :, m) = Value_m;
    end
    data_k.value = ddc;
    
    % Finish
    load chirp;
    sound(y, Fs);
    toc;
end

%-------------record the conversion parameter--------------------
data_k.info.kc_para.ek=ekv;
data_k.info.kc_para.latt_const=latt_constv/1e-10;
data_k.info.kc_para.kz_offset=kz_offsetv;
data_k.info.kc_para.energy_offset=energy_offsetv;
data_k.info.kc_para.theta_offset=-theta_offsetv*180/pi;% negtive sign is just for user's habit
data_k.info.kc_para.phi_offset=phi_offsetv*180/pi;
data_k.info.kc_para.sample_rotation=-sample_rotationv*180/pi;% negtive sign is just for user's habit
data_k.info.kc_para.kx_step=k_space_stepv;
data_k.info.kc_para.ky_step=ky_stepv;

%------------------put the converted data back-----------------
var_namei=cat(2,var_name,'_k_sp');
assignin('base',var_namei,data_k);


%======================end of conversion=======================

% --- Executes during object creation, after setting all properties.
function sample_rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample_rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function sample_rotation_Callback(hObject, eventdata, handles)
% hObject    handle to sample_rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sample_rotation as text
%        str2double(get(hObject,'String')) returns contents of sample_rotation as a double


% --- Executes during object creation, after setting all properties.
function k_space_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k_space_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function k_space_step_Callback(hObject, eventdata, handles)
% hObject    handle to k_space_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k_space_step as text
%        str2double(get(hObject,'String')) returns contents of k_space_step as a double


% --- Executes during object creation, after setting all properties.
function ky_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ky_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ky_step_Callback(hObject, eventdata, handles)
% hObject    handle to ky_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ky_step as text
%        str2double(get(hObject,'String')) returns contents of ky_step as a double


% --- Executes on button press in convert_points.
function convert_points_Callback(hObject, eventdata, handles)
% hObject    handle to convert_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%=====================start converting=========================
%get var_name
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
VarNames = handles_h.VarNames;
var_name = VarNames{1};
data=evalin('base',var_name);

ekv=str2num(get(handles.ek,'String'));
latt_constv=1e-10*str2num(get(handles.latt_const,'String'));
kz_offsetv=str2num(get(handles.kz_offset,'String'));
energy_offsetv=str2num(get(handles.energy_offset,'String'));
theta_offsetv=-str2num(get(handles.theta_offset,'String'))*pi/180;% negtive sign is just for user's habit
phi_offsetv=str2num(get(handles.phi_offset,'String'))*pi/180;
sample_rotationv=-str2num(get(handles.sample_rotation,'String'))*pi/180;% negtive sign is just for user's habit

% just data format
if ~isfield(data,'x') | ~isfield(data,'y')
    errordlg('Point data must contain fields: data.x, data.y','Wrong data format');
    return;
end

ce=1.6021892e-19;
me=9.109534e-31;
h=6.626176e-34;
ekk=ekv*ce;
k_unit=pi/latt_constv;

%---------------Start conversion ------------------
data.x=data.x*pi/180; % change unit
data.y=data.y*pi/180; % change unit
k0=(sqrt(2*me*ekk)*2*pi/h)/k_unit;
kx=zeros(1,size*data.x,2);  %alocate array space first
ky=zeros(1,size*data.x,2);  %alocate array space first
k=1;
for i=1:size(data.x,2)
    %-----------get the value first--------
    %kx0(i)=k0*cos(data.y(i)*pi/180)*sin(data.x(i)*pi/180);
    %ky0(i)=k0*sin(data.y(i)*pi/180);
    %ky0(i)=k0*cos(theta_offsetv*pi/180)*cos(data.y(i)*pi/180)*sin(data.x(i)*pi/180)+k0*sin(theta_offsetv*pi/180)*sin(data.y(i)*pi/180);
    %-----------then rotate----------------
    %kx(i)=kx0(i)*cos(sample_rotationv)-ky0(i)*sin(sample_rotationv);
    %ky(i)=kx0(i)*sin(sample_rotationv)+ky0(i)*cos(sample_rotationv);
    
    %-----------get the value in Lab-reference frame first--------
    kx0=k0*cos(data.y(i))*sin(data.x(i));
    ky0=k0*sin(data.y(i));
    kz0=k0*cos(data.y(i))*cos(data.x(i));
    %-----------make rotation matrix used 3 angles provided-------
    rx=[[1,0,0]',[0,cos(phi_offsetv),-sin(phi_offsetv)]',[0,sin(phi_offsetv),cos(phi_offsetv)]'];
    ry=[[cos(theta_offsetv),0,sin(theta_offsetv)]',[0,1,0]',[-sin(theta_offsetv),0,cos(theta_offsetv)]'];
    rz=[[cos(sample_rotationv),-sin(sample_rotationv),0]',[sin(sample_rotationv),cos(sample_rotationv),0]',[0,0,1]',];
    %-----------then rotate in the sequence of 1st: rx, 2nd: ry, 3rd rz----------------
    kxyz=rz*rx*ry*[kx0,ky0,kz0]';
    kx(i)=kxyz(1);
    ky(i)=kxyz(2);
    
end

%---------assign points-----------------------------
data_k.x=kx;
data_k.y=ky;

%-------------record the conversion parameter--------------------
data_k.info.kc_para.ek=ekv;
data_k.info.kc_para.latt_const=latt_constv/1e-10;
data_k.info.kc_para.kz_offset=kz_offsetv;
data_k.info.kc_para.energy_offset=energy_offsetv;
data_k.info.kc_para.theta_offset=-theta_offsetv*180/pi;% negtive sign is just for user's habit
data_k.info.kc_para.phi_offset=phi_offsetv*180/pi;
data_k.info.kc_para.sample_rotation=-sample_rotationv*180/pi;% negtive sign is just for user's habit

%------------------put the converted data back-----------------
var_namei=cat(2,var_name,'_k_sp');
assignin('base',var_namei,data_k);



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when k_space_conversion_demo is resized.
function k_space_conversion_demo_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to k_space_conversion_demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
