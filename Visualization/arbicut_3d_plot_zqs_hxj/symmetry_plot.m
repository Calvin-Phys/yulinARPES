function varargout = symmetry_plot(varargin)
% SYMMETRY_PLOT MATLAB code for symmetry_plot.fig
%      SYMMETRY_PLOT, by itself, creates a new SYMMETRY_PLOT or raises the existing
%      singleton*.
%
%      H = SYMMETRY_PLOT returns the handle to a new SYMMETRY_PLOT or the handle to
%      the existing singleton*.
%
%      SYMMETRY_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYMMETRY_PLOT.M with the given input arguments.
%
%      SYMMETRY_PLOT('Property','Value',...) creates a new SYMMETRY_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before symmetry_plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to symmetry_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help symmetry_plot

% Last Modified by GUIDE v2.5 29-Jul-2016 10:36:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @symmetry_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @symmetry_plot_OutputFcn, ...
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


% --- Executes just before symmetry_plot is made visible.
function symmetry_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to symmetry_plot (see VARARGIN)

% Choose default command line output for symmetry_plot
handles.output = hObject;
handles.data=varargin{1};
handles.n=varargin{2};

% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);



% UIWAIT makes symmetry_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = symmetry_plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = str2double(get(handles.centerx,'String'));
varargout{2} = str2double(get(handles.centery,'String'));
varargout{3} = str2double(get(handles.radius,'String'));
varargout{4} = str2double(get(handles.rotate,'String'));
delete(handles.figure1);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%refresh(handles.axes2);
cla;
data=handles.data;
zm=fix(size(data.z,2)/2);
value(:,:)=data.value(:,:,zm);
hold on
pcolor(data.x,data.y,value);
load('Colormap.mat');
colormap(flipud(cm_blue));
shading interp;
a=get(hObject,'Value');
set(handles.centerx,'String',a);
x0=str2double(get(handles.centerx,'String'));
y0=str2double(get(handles.centery,'String'));
r=str2double(get(handles.radius,'String'));
theta=str2double(get(handles.rotate,'String'));
[x_list,y_list]=ajust_points(handles.n,x0,y0,r,theta);
plot(x_list,y_list);
hold off
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%refresh(handles.axes2);
cla;
data=handles.data;
zm=fix(size(data.z,2)/2);
value(:,:)=data.value(:,:,zm);
hold on
pcolor(data.x,data.y,value);
load('Colormap.mat');
colormap(flipud(cm_blue));
shading interp;
a=get(hObject,'Value');
set(handles.rotate,'String',a);
x0=str2double(get(handles.centerx,'String'));
y0=str2double(get(handles.centery,'String'));
r=str2double(get(handles.radius,'String'));
theta=str2double(get(handles.rotate,'String'));
[x_list,y_list]=ajust_points(handles.n,x0,y0,r,theta);
plot(x_list,y_list);
hold off
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%refresh(handles.axes2);
cla;
data=handles.data;
zm=fix(size(data.z,2)/2);
value(:,:)=data.value(:,:,zm);
hold on
pcolor(data.x,data.y,value);
load('Colormap.mat');
colormap(flipud(cm_blue));
shading interp;
a=get(hObject,'Value');
set(handles.centery,'String',a);
x0=str2double(get(handles.centerx,'String'));
y0=str2double(get(handles.centery,'String'));
r=str2double(get(handles.radius,'String'));
theta=str2double(get(handles.rotate,'String'));
[x_list,y_list]=ajust_points(handles.n,x0,y0,r,theta);
plot(x_list,y_list);
hold off
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%refresh(handles.axes2);
cla;
data=handles.data;
zm=fix(size(data.z,2)/2);
value(:,:)=data.value(:,:,zm);
hold on
pcolor(data.x,data.y,value);
load('Colormap.mat');
colormap(flipud(cm_blue));
shading interp;
a=get(hObject,'Value');
set(handles.radius,'String',a);
x0=str2double(get(handles.centerx,'String'));
y0=str2double(get(handles.centery,'String'));
r=str2double(get(handles.radius,'String'));
theta=str2double(get(handles.rotate,'String'));
[x_list,y_list]=ajust_points(handles.n,x0,y0,r,theta);
plot(x_list,y_list);
hold off
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function centerx_Callback(hObject, eventdata, handles)
% hObject    handle to centerx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of centerx as text
%        str2double(get(hObject,'String')) returns contents of centerx as a double


% --- Executes during object creation, after setting all properties.
function centerx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to centerx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function centery_Callback(hObject, eventdata, handles)
% hObject    handle to centery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of centery as text
%        str2double(get(hObject,'String')) returns contents of centery as a double


% --- Executes during object creation, after setting all properties.
function centery_CreateFcn(hObject, eventdata, handles)
% hObject    handle to centery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotate_Callback(hObject, eventdata, handles)
% hObject    handle to rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotate as text
%        str2double(get(hObject,'String')) returns contents of rotate as a double


% --- Executes during object creation, after setting all properties.
function rotate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in complete.
function complete_Callback(hObject, eventdata, handles)
% hObject    handle to complete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.x0=str2double(get(handles.centerx,'String'));
%handles.y0=str2double(get(handles.centery,'String'));
%handles.r=str2double(get(handles.radius,'String'));
%handles.theta=str2double(get(handles.rotate,'String'));
uiresume(handles.figure1);


