function varargout = Gradient(varargin)
% GRADIENT MATLAB code for Gradient.fig
%      GRADIENT, by itself, creates a new GRADIENT or raises the existing
%      singleton*.
%
%      H = GRADIENT returns the handle to a new GRADIENT or the handle to
%      the existing singleton*.
%
%      GRADIENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRADIENT.M with the given input arguments.
%
%      GRADIENT('Property','Value',...) creates a new GRADIENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gradient_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gradient_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gradient

% Last Modified by GUIDE v2.5 25-Oct-2016 20:32:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gradient_OpeningFcn, ...
                   'gui_OutputFcn',  @Gradient_OutputFcn, ...
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


% --- Executes just before Gradient is made visible.
function Gradient_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gradient (see VARARGIN)

% Choose default command line output for Gradient
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gradient wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gradient_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox
vars=evalin('base','who');
set(handles.listbox,'String',vars);
list_entries = get(handles.listbox,'String');
index_selected = get(handles.listbox,'Value');
try
    list_entries{index_selected(1)};
catch
    set(handles.listbox,'Value',length(list_entries));
end


% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_delta_k_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delta_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delta_k as text
%        str2double(get(hObject,'String')) returns contents of edit_delta_k as a double
str=get(hObject,'String');
value=eval(str);
set(handles.edit_delta_k,'Value',value);

k=get(handles.edit_smooth,'Value');
k=1-10^(-k);
delta_k=get(handles.edit_delta_k,'Value');
delta_E=get(handles.edit_delta_E,'Value');
var_list=get(handles.listbox,'String');
var_index=get(handles.listbox,'Value');
var_name=var_list{var_index};

obj=get(handles.pushbutton_PlotSlice,'UserData');

data=evalin('base',var_name);
data_smooth=smooth_2d_xy(data,k);
data_smooth_grad=grad_2d(data_smooth,delta_k,delta_E);
obj.Data=data_smooth_grad;
obj.data2Dto3D;
obj.plot;



% --- Executes during object creation, after setting all properties.
function edit_delta_k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delta_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_delta_E_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delta_E as text
%        str2double(get(hObject,'String')) returns contents of edit_delta_E as a double
str=get(hObject,'String');
value=eval(str);
set(handles.edit_delta_E,'Value',value);

k=get(handles.edit_smooth,'Value');
k=1-10^(-k);
delta_k=get(handles.edit_delta_k,'Value');
delta_E=get(handles.edit_delta_E,'Value');
var_list=get(handles.listbox,'String');
var_index=get(handles.listbox,'Value');
var_name=var_list{var_index};

obj=get(handles.pushbutton_PlotSlice,'UserData');

data=evalin('base',var_name);
data_smooth=smooth_2d_xy(data,k);
data_smooth_grad=grad_2d(data_smooth,delta_k,delta_E);
obj.Data=data_smooth_grad;
obj.data2Dto3D;
obj.plot;



% --- Executes during object creation, after setting all properties.
function edit_delta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_smooth as text
%        str2double(get(hObject,'String')) returns contents of edit_smooth as a double
str=get(hObject,'String');
value=eval(str);
set(handles.edit_smooth,'Value',value);

k=get(handles.edit_smooth,'Value');
k=1-10^(-k);
delta_k=get(handles.edit_delta_k,'Value');
delta_E=get(handles.edit_delta_E,'Value');
var_list=get(handles.listbox,'String');
var_index=get(handles.listbox,'Value');
var_name=var_list{var_index};

obj=get(handles.pushbutton_PlotSlice,'UserData');

data=evalin('base',var_name);
data_smooth=smooth_2d_xy(data,k);
data_smooth_grad=grad_2d(data_smooth,delta_k,delta_E);
obj.Data=data_smooth_grad;
obj.data2Dto3D;
obj.plot;



% --- Executes during object creation, after setting all properties.
function edit_smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Save.
function pushbutton_Save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
var_list=get(handles.listbox,'String');
var_index=get(handles.listbox,'Value');
var_name=var_list{var_index};
obj=get(handles.pushbutton_PlotSlice,'UserData');
data=obj.Data;
datav.x=data.y;
datav.y=data.z;
datav.value=squeeze(data.value);
assignin('base',cat(2,var_name,'_grad'),datav);


% --- Executes on button press in pushbutton_PlotSlice.
function pushbutton_PlotSlice_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PlotSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
k=get(handles.edit_smooth,'Value');
k=1-10^(-k);
delta_k=get(handles.edit_delta_k,'Value');
delta_E=get(handles.edit_delta_E,'Value');
var_list=get(handles.listbox,'String');
var_index=get(handles.listbox,'Value');
var_name=var_list{var_index};
obj=PlotSlices(var_name,'z');
set(handles.pushbutton_PlotSlice,'UserData',obj);

data=evalin('base',var_name);
data_smooth=smooth_2d_xy(data,k);
data_smooth_grad=grad_2d(data_smooth,delta_k,delta_E);
obj.Data=data_smooth_grad;
obj.data2Dto3D;
obj.plot;

% --- Smooth function
function data_new=smooth_2d_xy(data,k)

data_new.x=data.x;
data_new.y=data.y;
xy={data.x,data.y};
data_new.value=zeros(length(data.x),length(data.y));

data_new.value=csaps(xy,data.value,k,xy);

% --- Gradient function
function data_grad=grad_2d(data,delta_k,delta_E)
[Nx,Ny]=size(data.value);

I0=data.value(1+delta_k:Nx-delta_k,1+delta_E:Ny-delta_E);
In=data.value(1+delta_k:Nx-delta_k,1:Ny-2*delta_E);
Is=data.value(1+delta_k:Nx-delta_k,1+2*delta_E:Ny);
Iw=data.value(1:Nx-2*delta_k,1+delta_E:Ny-delta_E);
Ie=data.value(1+2*delta_k:Nx,1+delta_E:Ny-delta_E);
Inw=data.value(1:Nx-2*delta_k,1:Ny-2*delta_E);
Ine=data.value(1+2*delta_k:Nx,1:Ny-2*delta_E);
Isw=data.value(1:Nx-2*delta_k,1+2*delta_E:Ny);
Ise=data.value(1+2*delta_k:Nx,1+2*delta_E:Ny);

Gn=I0-In;
Gs=I0-Is;
Gw=I0-Iw;
Ge=I0-Ie;
Gnw=I0-Inw;
Gne=I0-Ine;
Gsw=I0-Isw;
Gse=I0-Ise;

G=(Gn.^2+Gs.^2+Gw.^2+Ge.^2+Gnw.^2+Gne.^2+Gsw.^2+Gse.^2).^0.5;
G_ren=I0./G;
data_grad.x=data.x(1+delta_k:Nx-delta_k);
data_grad.y=data.y(1+delta_E:Ny-delta_E);
data_grad.value=G_ren;
