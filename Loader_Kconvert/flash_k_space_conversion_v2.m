function varargout = flash_k_space_conversion_v2(varargin)
% FLASH_K_SPACE_CONVERSION_V2 MATLAB code for flash_k_space_conversion_v2.fig
%      FLASH_K_SPACE_CONVERSION_V2, by itself, creates a new FLASH_K_SPACE_CONVERSION_V2 or raises the existing
%      singleton*.
%
%      H = FLASH_K_SPACE_CONVERSION_V2 returns the handle to a new FLASH_K_SPACE_CONVERSION_V2 or the handle to
%      the existing singleton*.
%
%      FLASH_K_SPACE_CONVERSION_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLASH_K_SPACE_CONVERSION_V2.M with the given input arguments.
%
%      FLASH_K_SPACE_CONVERSION_V2('Property','Value',...) creates a new FLASH_K_SPACE_CONVERSION_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before flash_k_space_conversion_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to flash_k_space_conversion_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help flash_k_space_conversion_v2

% Last Modified by GUIDE v2.5 06-Oct-2016 08:28:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @flash_k_space_conversion_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @flash_k_space_conversion_v2_OutputFcn, ...
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

% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
fign=handles.axes1;
h1=findall(0,'Tag','DataBrowser');
if isempty(h1)
    errordlg('Please open data_browser_demo');
    return;
end
h2=findall(0,'Tag','general_plot_demo');
h3=findall(0,'Tag','k_space_conversion_demo');
if isempty(h3)
    errordlg('Tag','Please open k_space_conversion_demo');
    return;
end
handles1=guidata(h1);
DataName=handles1.VarNames{1};
ind=regexp(DataName,'_k_sp');
if ~isempty(ind)
    DataName=DataName(1:ind-1);
end
data=evalin('base',DataName);
%%%%%
% earlier version did access general plot to extract the slice
%%%%%
% if ~isempty(h2)
% handles2=guidata(h2);
% z=get(handles2.x_from,'String');
% z=str2num(z);

% if ~(z<max(data.z)&&z>min(data.z))
%     z=(max(data.z)-min(data.z))*2/3+min(data.z);
% end
% else
%     z=(max(data.z)-min(data.z))*2/3+min(data.z);
% end
%     
% [~,z_ind]=min(abs(data.z-z));
z_ind=str2num(get(handles.energy_slice_index,'String'));
z=data.z(z_ind);
v=data.value(:,:,z_ind);
pcolor(fign,data.x,data.y,v');
% colormap('gray');
[lx,ly]=size(v);
data_new=data;
data_new.value=reshape(v,[lx,ly,1]);
data_new.z=z;
x_ci=floor(length(data.x)/2);
y_ci=floor(length(data.y)/2);
x_c=data.x(x_ci);
y_c=data.y(y_ci);
hold on
line('XData',x_c,'YData',y_c,'Parent',fign,...
    'Color','r',...
    'Marker','+','MarkerSize',5,'LineWidth',1,'Tag','CursorPos',...
    'ButtonDownFcn',@UpdateKSpacePlot);
hold off
shading(fign,'interp');
x_range=max(data.x)-min(data.x);
y_range=max(data.y)-min(data.y);
x_1=min(data.x)-x_range;
x_2=max(data.x)+x_range;
y_1=min(data.y)-y_range;
y_2=max(data.y)+y_range;
xlim(fign,[x_1,x_2]);
ylim(fign,[y_1,y_2]);
% set(handles.x1,'String',num2str(x_1));
% set(handles.x2,'String',num2str(x_2));
% set(handles.y1,'String',num2str(y_1));
% set(handles.y2,'String',num2str(y_2));
% Merged Data, save to axes2
x1=min(data_new.x);
x2=max(data_new.x);
y1=min(data_new.y);
y2=max(data_new.y);
data_merge=data_new;
if lx<60
    lx_n=lx;
else
    lx_n=60;
end
if ly<60
    ly_n=ly;
else
    ly_n=60;
end
data_merge.x=linspace(x1,x2,lx_n);
data_merge.y=linspace(y1,y2,ly_n);
[xx0,yy0]=ndgrid(data_new.x,data_new.y);
[xx1,yy1]=ndgrid(data_merge.x,data_merge.y);
data_merge.value=griddata(xx0,yy0,data_new.value,xx1,yy1);

data_s={};
data_s{1}=data_new;
data_s{2}=data_merge;
set(handles.flash_k_space_conversion,'UserData',data_s);

function UpdateKSpacePlot(hObject,evt)
handles=guidata(hObject);
set(handles.flash_k_space_conversion,'WindowButtonMotionFcn',@flash_k_space_conversion_callback);
set(handles.flash_k_space_conversion,'WindowButtonUpFcn',@flash_k_space_conversion_callback_end);


function flash_k_space_conversion_callback(hObject,evt)
handles=guidata(hObject);
fign=handles.axes1;
Position=get(fign,'CurrentPoint');
h1=findobj(fign,'Tag','CursorPos');
x=Position(1,1);
y=Position(1,2);
set(h1,'XData',x,'YData',y);
flash_k_space_conversion_function(hObject,evt,2,x,y);

% --- Executes on key press with focus on flash_k_space_conversion or any of its controls.
function flash_k_space_conversion_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to flash_k_space_conversion (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress=eventdata.Key;
handles=guidata(hObject);
fign=handles.axes1;
h1=findobj(fign,'Tag','CursorPos');
x=get(h1,'XData');
y=get(h1,'YData');
arrowstep=str2double(get(handles.arrowstep,'String'));
switch keypress
    case 'uparrow'
        y=y+arrowstep;
    case 'downarrow'
        y=y-arrowstep;
    case 'leftarrow'
        x=x-arrowstep;
    case 'rightarrow'
        x=x+arrowstep;
end
flash_k_space_conversion_function(hObject,[],1,x,y);

function flash_k_space_conversion_callback_end(hObject,evt)
handles=guidata(hObject);
set(handles.flash_k_space_conversion,'WindowButtonMotionFcn',[],...
    'WindowButtonUpFcn',[]);
fign=handles.axes1;
Position=get(fign,'CurrentPoint');
x=Position(1,1);
y=Position(1,2);
flash_k_space_conversion_function(hObject,evt,1,x,y);

function flash_k_space_conversion_function(hObject,evt,mode,x,y)
handles=guidata(hObject);
%% Read Data
fign=handles.axes1;
h1=findobj(fign,'Tag','CursorPos');
data_load=get(handles.flash_k_space_conversion,'UserData');
data=data_load{mode};
set(h1,'XData',x,'YData',y);
theta_offsetv=x*pi/180; % negtive sign is just for user's habit
phi_offsetv=-y*pi/180;


h1=findobj('Tag','k_space_conversion_demo');
handles=guidata(h1);
sample_rotationv=-str2num(get(handles.sample_rotation,'String'))*pi/180;
set(handles.theta_offset,'String',num2str(-x));
set(handles.phi_offset,'String',num2str(-y));
clear handles;
clear h1;

%% k_space_conversion
%=====================start converting=========================

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

latt_constv=1e-10*3.14159;
kz_offsetv=0;
energy_offsetv=0;
if mode == 1
    k_space_stepv=150;
    ky_stepv=150;
else
    k_space_stepv=60;
    ky_stepv=60;
end

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

k_unit=pi/latt_constv;

%----------------------------------------
%---------------if 3-d data--------------
% convention: theta is the analyzer angle
%             phi is the angle within a cut
%             kx is along anlyzer angle direction
%             ky is along angle within a cut

    nz=length(data.z);
    %Wrong if use: data.x=data.x+theta_offsetv;
    %data.y=data.y+phi_offsetv;
    data.x=data.x*pi/180; % change unit
    data.y=data.y*pi/180; % change unit
    data.z=data.z+energy_offsetv;

        kx0=sin(data.x)'*cos(data.y);
        ky0=repmat(sin(data.y),[nx 1]);
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
    
    % -------interpolate to 2-D even mesh----------
    data_k.x=kx_grid;
    data_k.y=ky_grid;
    data_k.z=data.z;
   
    data_k.value=zeros(size(data_k.x,2),size(data_k.y,2),size(data_k.z,2));

   kx10 = reshape(kx1, [nx*ny, 1]);
   ky10 = reshape(ky1, [nx*ny, 1]);
   eee = reshape(data.value, [nx*ny, nz]);
   tri = DelaunayTri(kx10, ky10);
   t_element = [tri(:, :); NaN, NaN, NaN];
   
   
   kx10(nx*ny + 1) = NaN;
   ky10(nx*ny + 1) = NaN;
   
   
%-------parrallel computing cooperation structure----------------
%----------------------------------------------------------------
           
   
   %If local matlabpool is open, then codes below can do parellel
   %computing.
   %If local matlabpool is close, then codes below are the same
   %with normal for-loops.
  m = 1;
       kxx_grid = kx_grid / k00( m );
       kyy_grid = ky_grid / k00( m );
       %normalization
       
       [kxx_grid, kyy_grid] = ndgrid(kxx_grid, kyy_grid);
       kxx_grid = reshape(kxx_grid, [kx_step*ky_step, 1]);
       kyy_grid = reshape(kyy_grid, [kx_step*ky_step, 1]);
       ee = eee(:, m);
       ee(nx * ny + 1) = NaN;
      
       [ti, bc] = pointLocation(tri, [kxx_grid, kyy_grid]);
       %search grid for pointlocation and convert into barycentric
       %coordinate associated with each triangle 
       ti(isnan(ti)) = nx*ny+1;
       triVals = ee(t_element(ti, :));
       
       ddc(:, :, m) = reshape(dot(bc', triVals')', [kx_step, ky_step]);
       %linear interpolation

   data_k.value = ddc;

%%
handles=guidata(hObject);

v=data_k.value(:,:,1);
h=findobj(handles.axes2,'Tag','kplot');


if isempty(h)
    h=pcolor(handles.axes2,data_k.x,data_k.y,v');
    set(h,'Tag','kplot');
else
    hold on
    set(h,'XData',data_k.x,'YData',data_k.y,'CData',v',...
        'ZData',zeros(size(v')));
    hold off
end
% colormap('gray');
shading(handles.axes2,'interp');
axis(handles.axes2,'tight');
axis(handles.axes2,'equal');





% --- Executes just before flash_k_space_conversion_v2 is made visible.
function flash_k_space_conversion_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to flash_k_space_conversion_v2 (see VARARGIN)

% Choose default command line output for flash_k_space_conversion_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes flash_k_space_conversion_v2 wait for user response (see UIRESUME)
% uiwait(handles.flash_k_space_conversion);


% --- Outputs from this function are returned to the command line.
function varargout = flash_k_space_conversion_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function flash_k_space_conversion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flash_k_space_conversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function z_Callback(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z as text
%        str2double(get(hObject,'String')) returns contents of z as a double


% --- Executes during object creation, after setting all properties.
function z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double


% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_Callback(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2 as text
%        str2double(get(hObject,'String')) returns contents of x2 as a double


% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y1_Callback(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y1 as text
%        str2double(get(hObject,'String')) returns contents of y1 as a double


% --- Executes during object creation, after setting all properties.
function y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y2_Callback(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y2 as text
%        str2double(get(hObject,'String')) returns contents of y2 as a double


% --- Executes during object creation, after setting all properties.
function y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setaxes.
function setaxes_Callback(hObject, ~, handles)
% hObject    handle to setaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
fign=handles.axes1;

x_1=str2double(get(handles.x1,'String'));
x_2=str2double(get(handles.x2,'String'));
y_1=str2double(get(handles.y1,'String'));
y_2=str2double(get(handles.y2,'String'));

xlim(fign,[x_1,x_2]);
ylim(fign,[y_1,y_2]);



function arrowstep_Callback(hObject, eventdata, handles)
% hObject    handle to arrowstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of arrowstep as text
%        str2double(get(hObject,'String')) returns contents of arrowstep as a double


% --- Executes during object creation, after setting all properties.
function arrowstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arrowstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearAxes.
function ClearAxes_Callback(hObject, eventdata, handles)
% hObject    handle to ClearAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(hObject);
cla(handles.axes2)



function energy_slice_index_Callback(hObject, eventdata, handles)
% hObject    handle to energy_slice_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of energy_slice_index as text
%        str2double(get(hObject,'String')) returns contents of energy_slice_index as a double


% --- Executes during object creation, after setting all properties.
function energy_slice_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energy_slice_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
