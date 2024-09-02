function varargout = Curvature(varargin)
% CURVATURE MATLAB code for Curvature.fig
%      CURVATURE, by itself, creates a new CURVATURE or raises the existing
%      singleton*.
%
%      H = CURVATURE returns the handle to a new CURVATURE or the handle to
%      the existing singleton*.
%
%      CURVATURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CURVATURE.M with the given input arguments.
%
%      CURVATURE('Property','Value',...) creates a new CURVATURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Curvature_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Curvature_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Curvature

% Last Modified by GUIDE v2.5 27-May-2016 16:03:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Curvature_OpeningFcn, ...
                   'gui_OutputFcn',  @Curvature_OutputFcn, ...
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


% --- Executes just before Curvature is made visible.
function Curvature_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Curvature (see VARARGIN)

% Choose default command line output for Curvature
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Curvature wait for user response (see UIRESUME)
% uiwait(handles.Curvature);
set(handles.radiobutton_Energy_Contour,'Value',1);
set(handles.radiobutton_Dispersion,'Value',0);
set(handles.uipanel_EC,'Visible','On');
set(handles.uipanel_D,'Visible','Off');

vars=evalin('base','who');
set(handles.listbox_EC,'String',vars);
set(handles.listbox_D,'String',vars);


% --- Outputs from this function are returned to the command line.
function varargout = Curvature_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton_Energy_Contour.
function radiobutton_Energy_Contour_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Energy_Contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Energy_Contour
value=get(hObject,'Value');
set(handles.radiobutton_Dispersion,'Value',1-value);
if value
    set(handles.uipanel_D,'Visible','Off');
    set(handles.uipanel_EC,'Visible','On');
else
    set(handles.uipanel_D,'Visible','On');
    set(handles.uipanel_EC,'Visible','Off');
end

% --- Executes on button press in radiobutton_Dispersion.
function radiobutton_Dispersion_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Dispersion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Dispersion
value=get(hObject,'Value');
set(handles.radiobutton_Energy_Contour,'Value',1-value);
if value
    set(handles.uipanel_D,'Visible','On');
    set(handles.uipanel_EC,'Visible','Off');
else
    set(handles.uipanel_D,'Visible','Off');
    set(handles.uipanel_EC,'Visible','On');
end


% --- Executes on selection change in listbox_EC.
function listbox_EC_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_EC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_EC
vars=evalin('base','who');
set(handles.listbox_EC,'String',vars);
list_entries = get(handles.listbox_EC,'String');
index_selected = get(handles.listbox_EC,'Value');
try
    list_entries{index_selected(1)};
catch
    set(handles.listbox_Mirror,'Value',length(list_entries));
end


% --- Executes during object creation, after setting all properties.
function listbox_EC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox_EC controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_Smoothing_Parameter_EC_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Smoothing_Parameter_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=get(hObject,'Value');
str=num2str(value);
set(handles.edit_Smoothing_Parameter_EC,'String',str);

k=get(handles.slider_Smoothing_Parameter_EC,'Value');
k=1-10^(-k);
a=get(handles.slider_a_EC,'Value');
a=10^(a);
var_list=get(handles.listbox_EC,'String');
var_index=get(handles.listbox_EC,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_EC,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_xy(Data_smooth,a);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;


% --- Executes during object creation, after setting all properties.
function slider_Smoothing_Parameter_EC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Smoothing_Parameter_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_a_EC_Callback(hObject, eventdata, handles)
% hObject    handle to slider_a_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=get(hObject,'Value');
str=num2str(value);
set(handles.edit_a_EC,'String',str);

k=get(handles.slider_Smoothing_Parameter_EC,'Value');
k=1-10^(-k);
a=get(handles.slider_a_EC,'Value');
a=10^(a);
var_list=get(handles.listbox_EC,'String');
var_index=get(handles.listbox_EC,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_EC,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_xy(Data_smooth,a);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;


% --- Executes during object creation, after setting all properties.
function slider_a_EC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_a_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_Smoothing_Parameter_EC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Smoothing_Parameter_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Smoothing_Parameter_EC as text
%        str2double(get(hObject,'String')) returns contents of edit_Smoothing_Parameter_EC as a double
str=get(hObject,'String');
value=eval(str);
if value<=1
    set(handles.slider_Smoothing_Parameter_EC,'Value',1);
    set(handles.edit_Smoothing_Parameter_EC,'String','1');
end

if value>=9
    set(handles.slider_Smoothing_Parameter_EC,'Value',9);
    set(handles.edit_Smoothing_Parameter_EC,'String','9');
end

if value<9&&value>1
    set(handles.slider_Smoothing_Parameter_EC,'Value',value);
end

k=get(handles.slider_Smoothing_Parameter_EC,'Value');
k=1-10^(-k);
a=get(handles.slider_a_EC,'Value');
a=10^(a);
var_list=get(handles.listbox_EC,'String');
var_index=get(handles.listbox_EC,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_EC,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_xy(Data_smooth,a);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;

% --- Executes during object creation, after setting all properties.
function edit_Smoothing_Parameter_EC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Smoothing_Parameter_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_a_EC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_a_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_a_EC as text
%        str2double(get(hObject,'String')) returns contents of edit_a_EC as a double
str=get(hObject,'String');
value=eval(str);
if value<=-4
    set(handles.slider_a_EC,'Value',-4);
    set(handles.edit_a_EC,'String','-4');
end

if value>=4
    set(handles.slider_a_EC,'Value',4)
    set(handles.edit_a_EC,'String','4');
end

if value<4&&value>-4
    set(handles.slider_a_EC,'Value',value);
end

k=get(handles.slider_Smoothing_Parameter_EC,'Value');
k=1-10^(-k);
a=get(handles.slider_a_EC,'Value');
a=10^(a);
var_list=get(handles.listbox_EC,'String');
var_index=get(handles.listbox_EC,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_EC,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_xy(Data_smooth,a);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;


% --- Executes during object creation, after setting all properties.
function edit_a_EC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_a_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton_PlotSlices_EC.
function pushbutton_PlotSlices_EC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PlotSlices_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%-----collect information-----%
k=get(handles.slider_Smoothing_Parameter_EC,'Value');
k=1-10^(-k);
a=get(handles.slider_a_EC,'Value');
a=10^(a);
var_list=get(handles.listbox_EC,'String');
var_index=get(handles.listbox_EC,'Value');
var_name=var_list{var_index};
obj=PlotSlices(var_name,'z');
set(handles.uipanel_EC,'UserData',obj);

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_xy(Data_smooth,a);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;

function Data_new=curvature_2d_xy(Data,a0)

Data_new.x=Data.x(2:end-1);
Data_new.y=Data.y(2:end-1);
Nx=length(Data_new.x);
Ny=length(Data_new.y);

hx=Data_new.x(2)-Data_new.x(1);
hy=Data_new.y(2)-Data_new.y(1);

Ix=diff(Data.value,1,1)/hx;
Iy=diff(Data.value,1,2)/hy;
Ixx=diff(Data.value,2,1)/hx/hx;
Iyy=diff(Data.value,2,2)/hy/hy;
Ixy=diff(diff(Data.value,1,1),1,2)/hx/hy;
Iyx=diff(diff(Data.value,1,2),1,1)/hy/hx;
Ix=Ix(1:Nx,1:Ny);
Iy=Iy(1:Nx,1:Ny);
Ixx=Ixx(1:Nx,2:Ny+1);
Iyy=Iyy(2:Nx+1,1:Ny);
Ixy=Ixy(1:Nx,1:Ny);
Iyx=Iyx(1:Nx,1:Ny);
 
Data_new.value=-((a0+Ix.^2).*Iyy-Ix.*Iy.*Ixy-Iy.*Ix.*Iyx+(a0+Iy.^2).*Ixx)./(2*(a0+Ix.^2+Iy.^2).^1.5);

[count,centre]=hist(Data_new.value(:),100);
M=max(count(:));
flag=count>(M/10000);
ind=find(flag);
upper_ind=max(ind(:));
upper=centre(upper_ind);
low=upper/10000;
filter=and((Data_new.value>low),(Data_new.value<upper));
Data_new.value=Data_new.value.*filter;

function Data_new=curvature_2d_yz(Data,a0,Res)

Data_new.x=Data.x(2:end-1);
Data_new.y=Data.y(2:end-1);
Nx=length(Data_new.x);
Ny=length(Data_new.y);
c1=a0;
c2=a0*Res^2;

hx=Data_new.x(2)-Data_new.x(1);
hy=Data_new.y(2)-Data_new.y(1);

Ix=diff(Data.value,1,1)/hx;
Iy=diff(Data.value,1,2)/hy;
Ixx=diff(Data.value,2,1)/hx/hx;
Iyy=diff(Data.value,2,2)/hy/hy;
Ixy=diff(diff(Data.value,1,1),1,2)/hx/hy;
Iyx=diff(diff(Data.value,1,2),1,1)/hy/hx;
Ix=Ix(1:Nx,1:Ny);
Iy=Iy(1:Nx,1:Ny);
Ixx=Ixx(1:Nx,2:Ny+1);
Iyy=Iyy(2:Nx+1,1:Ny);
Ixy=Ixy(1:Nx,1:Ny);
Iyx=Iyx(1:Nx,1:Ny);
 
Data_new.value=-((1+c1*Ix.^2).*Iyy*c2-Ix.*Iy.*Ixy*c1*c2-Iy.*Ix.*Iyx*c1*c2+(1+c2*Iy.^2).*Ixx*c1)./(2*(1+c1*Ix.^2+c2*Iy.^2).^1.5);

[count,centre]=hist(Data_new.value(:),100);
M=max(count(:));
flag=count>(M/10000);
ind=find(flag);
upper_ind=max(ind(:));
upper=centre(upper_ind);
low=upper/10000;
filter=and((Data_new.value>low),(Data_new.value<upper));
Data_new.value=Data_new.value.*filter;

function data_new=smooth_2d_xy(data,k)

data_new.x=data.x;
data_new.y=data.y;
xy={data.x,data.y};
data_new.value=zeros(length(data.x),length(data.y));

data_new.value=csaps(xy,data.value,k,xy);


% --- Executes on selection change in listbox_D.
function listbox_D_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_D contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_D
vars=evalin('base','who');
set(handles.listbox_EC,'String',vars);
list_entries = get(handles.listbox_D,'String');
index_selected = get(handles.listbox_D,'Value');
try
    list_entries{index_selected(1)};
catch
    set(handles.listbox_Mirror,'Value',length(list_entries));
end


% --- Executes during object creation, after setting all properties.
function listbox_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_Smoothing_Parameter_D_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Smoothing_Parameter_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=get(hObject,'Value');
str=num2str(value);
set(handles.edit_Smoothing_Parameter_D,'String',str);

k=get(handles.slider_Smoothing_Parameter_D,'Value');
k=1-10^(-k);
a=get(handles.slider_a_D,'Value');
a=10^(a);
Res=get(handles.slider_Res,'Value');
var_list=get(handles.listbox_D,'String');
var_index=get(handles.listbox_D,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_D,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_yz(Data_smooth,a,Res);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;


% --- Executes during object creation, after setting all properties.
function slider_Smoothing_Parameter_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Smoothing_Parameter_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_a_D_Callback(hObject, eventdata, handles)
% hObject    handle to slider_a_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=get(hObject,'Value');
str=num2str(value);
set(handles.edit_a_D,'String',str);

k=get(handles.slider_Smoothing_Parameter_D,'Value');
k=1-10^(-k);
a=get(handles.slider_a_D,'Value');
a=10^(a);
Res=get(handles.slider_Res,'Value');
var_list=get(handles.listbox_D,'String');
var_index=get(handles.listbox_D,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_D,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_yz(Data_smooth,a,Res);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;

% --- Executes during object creation, after setting all properties.
function slider_a_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_a_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_Smoothing_Parameter_D_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Smoothing_Parameter_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Smoothing_Parameter_D as text
%        str2double(get(hObject,'String')) returns contents of edit_Smoothing_Parameter_D as a double
str=get(hObject,'String');
value=eval(str);
if value<=1
    set(handles.slider_Smoothing_Parameter_D,'Value',1);
    set(handles.edit_Smoothing_Parameter_D,'String','1');
end

if value>=9
    set(handles.slider_Smoothing_Parameter_D,'Value',9);
    set(handles.edit_Smoothing_Parameter_D,'String','9');
end

if value<9&&value>1
    set(handles.slider_Smoothing_Parameter_D,'Value',value);
end

k=get(handles.slider_Smoothing_Parameter_D,'Value');
k=1-10^(-k);
a=get(handles.slider_a_D,'Value');
a=10^(a);
Res=get(handles.slider_Res,'Value');
var_list=get(handles.listbox_D,'String');
var_index=get(handles.listbox_D,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_D,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_yz(Data_smooth,a,Res);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;


% --- Executes during object creation, after setting all properties.
function edit_Smoothing_Parameter_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Smoothing_Parameter_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_a_D_Callback(hObject, eventdata, handles)
% hObject    handle to edit_a_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_a_D as text
%        str2double(get(hObject,'String')) returns contents of edit_a_D as a double
str=get(hObject,'String');
value=eval(str);
if value<=-4
    set(handles.slider_a_D,'Value',-4);
    set(handles.edit_a_D,'String','-4');
end

if value>=4
    set(handles.slider_a_D,'Value',4)
    set(handles.edit_a_D,'String','4');
end

if value<4&&value>-4
    set(handles.slider_a_D,'Value',value);
end

k=get(handles.slider_Smoothing_Parameter_D,'Value');
k=1-10^(-k);
a=get(handles.slider_a_D,'Value');
a=10^(a);
Res=get(handles.slider_Res,'Value');
var_list=get(handles.listbox_D,'String');
var_index=get(handles.listbox_D,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_D,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_yz(Data_smooth,a,Res);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;


% --- Executes during object creation, after setting all properties.
function edit_a_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_a_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_PlotSlices_D.
function pushbutton_PlotSlices_D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PlotSlices_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%-----collect information-----%
k=get(handles.slider_Smoothing_Parameter_D,'Value');
k=1-10^(-k);
a=get(handles.slider_a_D,'Value');
a=10^(a);
Res=get(handles.slider_Res,'Value');
var_list=get(handles.listbox_D,'String');
var_index=get(handles.listbox_D,'Value');
var_name=var_list{var_index};
obj=PlotSlices(var_name,'z');
set(handles.uipanel_D,'UserData',obj);

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_yz(Data_smooth,a,Res);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;


% --- Executes on slider movement.
function slider_Res_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=get(hObject,'Value');
str=num2str(value);
set(handles.edit_Res,'String',str);

k=get(handles.slider_Smoothing_Parameter_D,'Value');
k=1-10^(-k);
a=get(handles.slider_a_D,'Value');
a=10^(a);
Res=get(handles.slider_Res,'Value');
var_list=get(handles.listbox_D,'String');
var_index=get(handles.listbox_D,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_D,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_yz(Data_smooth,a,Res);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;


% --- Executes during object creation, after setting all properties.
function slider_Res_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_Res_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Res as text
%        str2double(get(hObject,'String')) returns contents of edit_Res as a double
str=get(hObject,'String');
value=eval(str);
if value<=0
    set(handles.slider_Res,'Value',0);
    set(handles.edit_Res,'String','0');
end

if value>=100
    set(handles.slider_Res,'Value',100);
    set(handles.edit_Res,'String','100');
end

if value<100&&value>0
    set(handles.slider_Res,'Value',value);
end

k=get(handles.slider_Smoothing_Parameter_D,'Value');
k=1-10^(-k);
a=get(handles.slider_a_D,'Value');
a=10^(a);
Res=get(handles.slider_Res,'Value');
var_list=get(handles.listbox_D,'String');
var_index=get(handles.listbox_D,'Value');
var_name=var_list{var_index};

obj=get(handles.uipanel_D,'UserData');

Data=evalin('base',var_name);
Data_smooth=smooth_2d_xy(Data,k);
Data_smooth_curvature=curvature_2d_yz(Data_smooth,a,Res);
obj.Data=Data_smooth_curvature;
obj.data2Dto3D;
obj.initial_plot;

% --- Executes during object creation, after setting all properties.
function edit_Res_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Save_Variable_D.
function pushbutton_Save_Variable_D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Save_Variable_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
var_list=get(handles.listbox_D,'String');
var_index=get(handles.listbox_D,'Value');
var_name=var_list{var_index};
obj=get(handles.uipanel_D,'UserData');
data=obj.Data;
datav.x=data.y;
datav.y=data.z;
datav.value=squeeze(data.value);
assignin('base',cat(2,var_name,'_cur'),datav);



% --- Executes on button press in pushbutton_Save_Variable_EC.
function pushbutton_Save_Variable_EC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Save_Variable_EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
var_list=get(handles.listbox_EC,'String');
var_index=get(handles.listbox_EC,'Value');
var_name=var_list{var_index};
obj=get(handles.uipanel_EC,'UserData');
data=obj.Data;
datav.x=data.y;
datav.y=data.z;
datav.value=squeeze(data.value);
assignin('base',cat(2,var_name,'_cur'),datav);
