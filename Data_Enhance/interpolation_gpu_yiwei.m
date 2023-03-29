function varargout = interpolation_gpu_yiwei(varargin)
% INTERPOLATION_GPU_YIWEI MATLAB code for interpolation_gpu_yiwei.fig
%      INTERPOLATION_GPU_YIWEI, by itself, creates a new INTERPOLATION_GPU_YIWEI or raises the existing
%      singleton*.
%
%      H = INTERPOLATION_GPU_YIWEI returns the handle to a new INTERPOLATION_GPU_YIWEI or the handle to
%      the existing singleton*.
%
%      INTERPOLATION_GPU_YIWEI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERPOLATION_GPU_YIWEI.M with the given input arguments.
%
%      INTERPOLATION_GPU_YIWEI('Property','Value',...) creates a new INTERPOLATION_GPU_YIWEI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interpolation_gpu_yiwei_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interpolation_gpu_yiwei_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help
% interpolation_gpu_yiwei

% Last Modified by GUIDE v2.5 09-May-2016 14:49:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interpolation_gpu_yiwei_OpeningFcn, ...
                   'gui_OutputFcn',  @interpolation_gpu_yiwei_OutputFcn, ...
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


% --- Executes just before interpolation_gpu_yiwei is made visible.
function interpolation_gpu_yiwei_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interpolation_gpu_yiwei (see VARARGIN)

% Choose default command line output for interpolation_gpu_yiwei
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
vars=evalin('base','who');
set(handles.listbox,'String',vars);
% UIWAIT makes interpolation_gpu_yiwei wait for user response (see UIRESUME)
% uiwait(handles.interpolation_gpu_yiwei);


% --- Outputs from this function are returned to the command line.
function varargout = interpolation_gpu_yiwei_OutputFcn(hObject, eventdata, handles) 
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
    var_name = list_entries{index_selected(1)};
catch
    var_name=list_entries{end};
    set(handles.listbox,'Value',length(list_entries));
end
    
datav=evalin('base',var_name);

if isfield(datav,'x')
    set(handles.radiobutton_x,'Value',1);
    set(handles.edit_x_1,'String',num2str(datav.x(1)));
    set(handles.edit_x_end,'String',num2str(datav.x(end)));
    set(handles.edit_delta_x,'String',num2str(datav.x(2)-datav.x(1)));
    set(handles.edit_xnum,'String',num2str(length(datav.x)));
else
    set(handles.radiobutton_x,'Value',0);
    set(handles.edit_x_1,'String',[]);
    set(handles.edit_x_end,'String',[]);
    set(handles.edit_delta_x,'String',[]);
    set(handles.edit_xnum,'String',[]);
end
if isfield(datav,'y')
    set(handles.radiobutton_y,'Value',1);
    set(handles.edit_y_1,'String',num2str(datav.y(1)));
    set(handles.edit_y_end,'String',num2str(datav.y(end)));
    set(handles.edit_delta_y,'String',num2str(datav.y(2)-datav.y(1)));
    set(handles.edit_ynum,'String',num2str(length(datav.y)));
else
    set(handles.radiobutton_y,'Value',0);
    set(handles.edit_y_1,'String',[]);
    set(handles.edit_y_end,'String',[]);
    set(handles.edit_delta_y,'String',[]);
    set(handles.edit_ynum,'String',[]);
end
if isfield(datav,'z')
    set(handles.radiobutton_z,'Value',1);
    set(handles.edit_z_1,'String',num2str(datav.z(1)));
    set(handles.edit_z_end,'String',num2str(datav.z(end)));
    set(handles.edit_delta_z,'String',num2str(datav.z(2)-datav.z(1)));
    set(handles.edit_znum,'String',num2str(length(datav.z)));
else
    set(handles.radiobutton_z,'Value',0);
    set(handles.edit_z_1,'String',[]);
    set(handles.edit_z_end,'String',[]);
    set(handles.edit_delta_z,'String',[]);
    set(handles.edit_znum,'String',[]);
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


% --- Executes on button press in radiobutton_x.
function radiobutton_x_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_x


% --- Executes on button press in radiobutton_y.
function radiobutton_y_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_y


% --- Executes on button press in radiobutton_z.
function radiobutton_z_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_z



function edit_x_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_x_1 as a double
x_1=eval(get(handles.edit_x_1,'String'));
x_end=eval(get(handles.edit_x_end,'String'));
delta_x=eval(get(handles.edit_delta_x,'String'));
xnum=eval(get(handles.edit_xnum,'String'));
if get(handles.radiobutton_delta_x,'Value')==1
    xnum=round((x_end-x_1)/delta_x);
    delta_x=(x_end-x_1)/xnum;
    set(handles.edit_xnum,'String',num2str(xnum));
    set(handles.edit_delta_x,'String',num2str(delta_x));
    set(handles.edit_x_1,'String',num2str(x_1));
    set(handles.edit_x_end,'String',num2str(x_end));
else
    delta_x=(x_end-x_1)/xnum;
    set(handles.edit_xnum,'String',num2str(xnum));
    set(handles.edit_delta_x,'String',num2str(delta_x));
    set(handles.edit_x_1,'String',num2str(x_1));
    set(handles.edit_x_end,'String',num2str(x_end));
end


% --- Executes during object creation, after setting all properties.
function edit_x_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_x_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x_end as text
%        str2double(get(hObject,'String')) returns contents of edit_x_end as a double
x_1=eval(get(handles.edit_x_1,'String'));
x_end=eval(get(handles.edit_x_end,'String'));
delta_x=eval(get(handles.edit_delta_x,'String'));
xnum=eval(get(handles.edit_xnum,'String'));
if get(handles.radiobutton_delta_x,'Value')==1
    xnum=round((x_end-x_1)/delta_x);
    delta_x=(x_end-x_1)/xnum;
    set(handles.edit_xnum,'String',num2str(xnum));
    set(handles.edit_delta_x,'String',num2str(delta_x));
    set(handles.edit_x_1,'String',num2str(x_1));
    set(handles.edit_x_end,'String',num2str(x_end));
else
    delta_x=(x_end-x_1)/xnum;
    set(handles.edit_xnum,'String',num2str(xnum));
    set(handles.edit_delta_x,'String',num2str(delta_x));
    set(handles.edit_x_1,'String',num2str(x_1));
    set(handles.edit_x_end,'String',num2str(x_end));
end



% --- Executes during object creation, after setting all properties.
function edit_x_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_y_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_y_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_y_1 as a double
y_1=eval(get(handles.edit_y_1,'String'));
y_end=eval(get(handles.edit_y_end,'String'));
delta_y=eval(get(handles.edit_delta_y,'String'));
ynum=eval(get(handles.edit_ynum,'String'));
if get(handles.radiobutton_delta_y,'Value')==1
    ynum=round((y_end-y_1)/delta_y);
    delta_y=(y_end-y_1)/ynum;
    set(handles.edit_ynum,'String',num2str(ynum));
    set(handles.edit_delta_y,'String',num2str(delta_y));
    set(handles.edit_y_1,'String',num2str(y_1));
    set(handles.edit_y_end,'String',num2str(y_end));
else
    delta_y=(y_end-y_1)/ynum;
    set(handles.edit_ynum,'String',num2str(ynum));
    set(handles.edit_delta_y,'String',num2str(delta_y));
    set(handles.edit_y_1,'String',num2str(y_1));
    set(handles.edit_y_end,'String',num2str(y_end));
end


% --- Executes during object creation, after setting all properties.
function edit_y_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_y_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_y_end as text
%        str2double(get(hObject,'String')) returns contents of edit_y_end as a double
y_1=eval(get(handles.edit_y_1,'String'));
y_end=eval(get(handles.edit_y_end,'String'));
delta_y=eval(get(handles.edit_delta_y,'String'));
ynum=eval(get(handles.edit_ynum,'String'));
if get(handles.radiobutton_delta_y,'Value')==1
    ynum=round((y_end-y_1)/delta_y);
    delta_y=(y_end-y_1)/ynum;
    set(handles.edit_ynum,'String',num2str(ynum));
    set(handles.edit_delta_y,'String',num2str(delta_y));
    set(handles.edit_y_1,'String',num2str(y_1));
    set(handles.edit_y_end,'String',num2str(y_end));
else
    delta_y=(y_end-y_1)/ynum;
    set(handles.edit_ynum,'String',num2str(ynum));
    set(handles.edit_delta_y,'String',num2str(delta_y));
    set(handles.edit_y_1,'String',num2str(y_1));
    set(handles.edit_y_end,'String',num2str(y_end));
end


% --- Executes during object creation, after setting all properties.
function edit_y_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_z_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_z_1 as a double
z_1=eval(get(handles.edit_z_1,'String'));
z_end=eval(get(handles.edit_z_end,'String'));
delta_z=eval(get(handles.edit_delta_z,'String'));
znum=eval(get(handles.edit_znum,'String'));
if get(handles.radiobutton_delta_z,'Value')==1
    znum=round((z_end-z_1)/delta_z);
    delta_z=(z_end-z_1)/znum;
    set(handles.edit_znum,'String',num2str(znum));
    set(handles.edit_delta_z,'String',num2str(delta_z));
    set(handles.edit_z_1,'String',num2str(z_1));
    set(handles.edit_z_end,'String',num2str(z_end));
else
    delta_z=(z_end-z_1)/znum;
    set(handles.edit_znum,'String',num2str(znum));
    set(handles.edit_delta_z,'String',num2str(delta_z));
    set(handles.edit_z_1,'String',num2str(z_1));
    set(handles.edit_z_end,'String',num2str(z_end));
end


% --- Executes during object creation, after setting all properties.
function edit_z_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_z_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z_end as text
%        str2double(get(hObject,'String')) returns contents of edit_z_end as a double
z_1=eval(get(handles.edit_z_1,'String'));
z_end=eval(get(handles.edit_z_end,'String'));
delta_z=eval(get(handles.edit_delta_z,'String'));
znum=eval(get(handles.edit_znum,'String'));
if get(handles.radiobutton_delta_z,'Value')==1
    znum=((z_end-z_1)/delta_z);
    delta_z=(z_end-z_1)/znum;
    set(handles.edit_znum,'String',num2str(znum));
    set(handles.edit_delta_z,'String',num2str(delta_z));
    set(handles.edit_z_1,'String',num2str(z_1));
    set(handles.edit_z_end,'String',num2str(z_end));
else
    delta_z=(z_end-z_1)/znum;
    set(handles.edit_znum,'String',num2str(znum));
    set(handles.edit_delta_z,'String',num2str(delta_z));
    set(handles.edit_z_1,'String',num2str(z_1));
    set(handles.edit_z_end,'String',num2str(z_end));
end


% --- Executes during object creation, after setting all properties.
function edit_z_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_delta_x_Callback(hObject, eventdata, handles)
% hObject    handles to edit_delta_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delta_x as text
%        str2double(get(hObject,'String')) returns contents of edit_delta_x as a double
x_1=eval(get(handles.edit_x_1,'String'));
x_end=eval(get(handles.edit_x_end,'String'));
delta_x=eval(get(handles.edit_delta_x,'String'));
xnum=eval(get(handles.edit_delta_x,'String'));
if get(handles.radiobutton_delta_x,'Value')==1
    xnum=round((x_end-x_1)/delta_x);
    delta_x=(x_end-x_1)/xnum;
    set(handles.edit_xnum,'String',num2str(xnum));
    set(handles.edit_delta_x,'String',num2str(delta_x));
    set(handles.edit_x_1,'String',num2str(x_1));
    set(handles.edit_x_end,'String',num2str(x_end));
else
    delta_x=(x_end-x_1)/xnum;
    set(handles.edit_xnum,'String',num2str(xnum));
    set(handles.edit_delta_x,'String',num2str(delta_x));
    set(handles.edit_x_1,'String',num2str(x_1));
    set(handles.edit_x_end,'String',num2str(x_end));
end


% --- Executes during object creation, after setting all properties.
function edit_delta_x_CreateFcn(hObject, eventdata, handles)
% hObject    handles to edit_delta_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_delta_y_Callback(hObject, eventdata, handles)
% hObject    handles to edit_delta_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delta_y as text
%        str2double(get(hObject,'String')) returns contents of edit_delta_y as a double
y_1=eval(get(handles.edit_y_1,'String'));
y_end=eval(get(handles.edit_y_end,'String'));
delta_y=eval(get(handles.edit_delta_y,'String'));
ynum=eval(get(handles.edit_ynum,'String'));
if get(handles.radiobutton_delta_y,'Value')==1
    ynum=round((y_end-y_1)/delta_y);
    delta_y=(y_end-y_1)/ynum;
    set(handles.edit_ynum,'String',num2str(ynum));
    set(handles.edit_delta_y,'String',num2str(delta_y));
    set(handles.edit_y_1,'String',num2str(y_1));
    set(handles.edit_y_end,'String',num2str(y_end));
else
    delta_y=(y_end-y_1)/ynum;
    set(handles.edit_ynum,'String',num2str(ynum));
    set(handles.edit_delta_y,'String',num2str(delta_y));
    set(handles.edit_y_1,'String',num2str(y_1));
    set(handles.edit_y_end,'String',num2str(y_end));
end


% --- Executes during object creation, after setting all properties.
function edit_delta_y_CreateFcn(hObject, eventdata, handles)
% hObject    handles to edit_delta_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_delta_z_Callback(hObject, eventdata, handles)
% hObject    handles to edit_delta_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delta_z as text
%        str2double(get(hObject,'String')) returns contents of edit_delta_z as a double
z_1=eval(get(handles.edit_z_1,'String'));
z_end=eval(get(handles.edit_z_end,'String'));
delta_z=eval(get(handles.edit_delta_z,'String'));
znum=eval(get(handles.edit_znum,'String'));
if get(handles.radiobutton_delta_z,'Value')==1
    znum=round((z_end-z_1)/delta_z);
    delta_z=(z_end-z_1)/znum;
    set(handles.edit_znum,'String',num2str(znum));
    set(handles.edit_delta_z,'String',num2str(delta_z));
    set(handles.edit_z_1,'String',num2str(z_1));
    set(handles.edit_z_end,'String',num2str(z_end));
else
    delta_z=(z_end-z_1)/znum;
    set(handles.edit_znum,'String',num2str(znum));
    set(handles.edit_delta_z,'String',num2str(delta_z));
    set(handles.edit_z_1,'String',num2str(z_1));
    set(handles.edit_z_end,'String',num2str(z_end));
end


% --- Executes during object creation, after setting all properties.
function edit_delta_z_CreateFcn(hObject, eventdata, handles)
% hObject    handles to edit_delta_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_xnum_Callback(hObject, eventdata, handles)
% hObject    handles to edit_xnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xnum as text
%        str2double(get(hObject,'String')) returns contents of edit_xnum as a double
x_1=eval(get(handles.edit_x_1,'String'));
x_end=eval(get(handles.edit_x_end,'String'));
delta_x=eval(get(handles.edit_delta_x,'String'));
xnum=round(eval(get(handles.edit_xnum,'String')));
if get(handles.radiobutton_delta_x,'Value')==1
    xnum=round((x_end-x_1)/delta_x);
    delta_x=(x_end-x_1)/xnum;
    set(handles.edit_xnum,'String',num2str(xnum));
    set(handles.edit_delta_x,'String',num2str(delta_x));
    set(handles.edit_x_1,'String',num2str(x_1));
    set(handles.edit_x_end,'String',num2str(x_end));
else
    delta_x=(x_end-x_1)/xnum;
    set(handles.edit_xnum,'String',num2str(xnum));
    set(handles.edit_delta_x,'String',num2str(delta_x));
    set(handles.edit_x_1,'String',num2str(x_1));
    set(handles.edit_x_end,'String',num2str(x_end));
end


% --- Executes during object creation, after setting all properties.
function edit_xnum_CreateFcn(hObject, eventdata, handles)
% hObject    handles to edit_xnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ynum_Callback(hObject, eventdata, handles)
% hObject    handles to edit_ynum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ynum as text
%        str2double(get(hObject,'String')) returns contents of edit_ynum as a double
y_1=eval(get(handles.edit_y_1,'String'));
y_end=eval(get(handles.edit_y_end,'String'));
delta_y=eval(get(handles.edit_delta_y,'String'));
ynum=round(eval(get(handles.edit_ynum,'String')));
if get(handles.radiobutton_delta_y,'Value')==1
    ynum=round((y_end-y_1)/delta_y);
    delta_y=(y_end-y_1)/ynum;
    set(handles.edit_ynum,'String',num2str(ynum));
    set(handles.edit_delta_y,'String',num2str(delta_y));
    set(handles.edit_y_1,'String',num2str(y_1));
    set(handles.edit_y_end,'String',num2str(y_end));
else
    delta_y=(y_end-y_1)/ynum;
    set(handles.edit_ynum,'String',num2str(ynum));
    set(handles.edit_delta_y,'String',num2str(delta_y));
    set(handles.edit_y_1,'String',num2str(y_1));
    set(handles.edit_y_end,'String',num2str(y_end));
end


% --- Executes during object creation, after setting all properties.
function edit_ynum_CreateFcn(hObject, eventdata, handles)
% hObject    handles to edit_ynum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_znum_Callback(hObject, eventdata, handles)
% hObject    handles to edit_znum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_znum as text
%        str2double(get(handles.edit_delta_z,'String')) returns contents of edit_znum as a double
z_1=eval(get(handles.edit_z_1,'String'));
z_end=eval(get(handles.edit_z_end,'String'));
delta_z=eval(get(handles.edit_delta_z,'String'));
znum=round(eval(get(handles.edit_znum,'String')));
if get(handles.radiobutton_delta_z,'Value')==1
    znum=round((z_end-z_1)/delta_z);
    delta_z=(z_end-z_1)/znum;
    set(handles.edit_znum,'String',num2str(znum));
    set(handles.edit_delta_z,'String',num2str(delta_z));
    set(handles.edit_z_1,'String',num2str(z_1));
    set(handles.edit_z_end,'String',num2str(z_end));
else
    delta_z=(z_end-z_1)/znum;
    set(handles.edit_znum,'String',num2str(znum));
    set(handles.edit_delta_z,'String',num2str(delta_z));
    set(handles.edit_z_1,'String',num2str(z_1));
    set(handles.edit_z_end,'String',num2str(z_end));
end


% --- Executes during object creation, after setting all properties.
function edit_znum_CreateFcn(hObject, eventdata, handles)
% hObject    handles to edit_znum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_GPU.
function radiobutton_GPU_Callback(hObject, eventdata, handles)
% hObject    handles to radiobutton_GPU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_GPU
if get(hObject,'Value')
    set(handles.popupmenu_interp_method,'Value',2);
end


% --- Executes on button press in radiobutton_Reset.
function radiobutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handles to radiobutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Reset


% --- Executes on button press in pushbutton_Interpolate.
function pushbutton_Interpolate_Callback(hObject, eventdata, handles)
% hObject    handles to pushbutton_Interpolate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%---check data format----%
list_entries = get(handles.listbox,'String');
index_selected = get(handles.listbox,'Value');
index_length=length(index_selected);
if index_length<1
    return;
end
    
var1_name=list_entries{index_selected(1)};
datav1=evalin('base',var1_name);

if ~isfield(datav1,'value')
    errordlg('Field value not found!','Data Format Error');
else
    datav1_size=size(datav1.value);
    datav1_dim=length(datav1_size);
end

if length(datav1.x)~=datav1_size(1)
    errordlg('data.value is inconsistent to data.x','Data Format Error');
end
if datav1_dim>1
    if length(datav1.y)~=datav1_size(2)
        errordlg('data.value is inconsistent to data.y','Data Format Error');
    end
end
if datav1_dim>2
    if length(datav1.z)~=datav1_size(3)
       errordlg('data.value is inconsistent to data.z','Data Format Error');
    end
end
    
for index_num=2:index_length
    var_name = list_entries{index_selected(index_num)};  %determine the var in base
    datav=evalin('base',var_name);
    if ~isequal(ndims(datav.value),datav1_dim)
        errordlg('data dimensions are different','Data Format Error');
    end
    datav_size=size(datav.value);
    datav_dim=ndims(datav.value);
    if length(datav.x)~=datav_size(1)
    errordlg('data.value is inconsistent to data.x','Data Format Error');
    end
    if datav_dim>1
        if length(datav.y)~=datav_size(2)
            errordlg('data.value is inconsistent to data.y','Data Format Error');
        end
    end
    if datav_dim>2
        if length(datav.z)~=datav_size(3)
           errordlg('data.value is inconsistent to data.z','Data Format Error');
        end
    end
end

%----grid data preparation---%
if get(handles.radiobutton_x,'Value')
    xgrid_nu=linspace(str2double(get(handles.edit_x_1,'String')),str2double(get(handles.edit_x_end,'String')),str2double(get(handles.edit_xnum,'String')));
end
if get(handles.radiobutton_y,'Value')
    ygrid_nu=linspace(str2double(get(handles.edit_y_1,'String')),str2double(get(handles.edit_y_end,'String')),str2double(get(handles.edit_ynum,'String')));
end
if get(handles.radiobutton_z,'Value')
    zgrid_nu=linspace(str2double(get(handles.edit_z_1,'String')),str2double(get(handles.edit_z_end,'String')),str2double(get(handles.edit_znum,'String')));
end

if get(handles.radiobutton_GPU,'Value')
    reset(gpuDevice(1));
    try xgrid_nu=gpuArray(single(xgrid_nu)); end
    try ygrid_nu=gpuArray(single(ygrid_nu)); end
    try zgrid_nu=gpuArray(single(zgrid_nu)); end
end

switch datav1_dim
    case 2
        [Xgrid_nu,Ygrid_nu]=ndgrid(xgrid_nu,ygrid_nu);
    case 3
        [Xgrid_nu,Ygrid_nu,Zgrid_nu]=ndgrid(xgrid_nu,ygrid_nu,zgrid_nu);
end
    
contents = cellstr(get(handles.popupmenu_interp_method,'String')) ;
interp_method=contents{get(handles.popupmenu_interp_method,'Value')};

%--interpolate---%
switch datav1_dim
    case 1
        for index_num=1:index_length
            var_name = list_entries{index_selected(index_num)};  %determine the var in base
            datav=evalin('base',var_name);
            datav.value(isnan(datav.value))=0;
            xgrid=datav.x;
            if get(handles.radiobutton_GPU,'Value')
                xgrid=gpuArray(single(xgrid));
                datav.value=gpuArray(single(datav.value));
                datav_nu.value=interp1(xgrid,datav.value,xgrid_nu,'linear');
                datav_nu.value=double(gather(datav_nu.value));
                datav.x=double(gather(xgrid_nu));
            else
                datav_nu.value=interp1(xgrid,datav.value,xgrid_nu,interp_method);
                datav_nu.x=xgrid_nu;
            end
            datav_nu.value(isnan(datav_nu.value))=0;
            assignin('base',cat(2,var_name,'_nu'),datav_nu);
            clearvars -except xgrid_nu list_entries index_selected index_num handles
        end
    case 2
         for index_num=1:index_length
            var_name = list_entries{index_selected(index_num)};  %determine the var in base
            datav=evalin('base',var_name);
            datav.value(isnan(datav.value))=0;
            xgrid=datav.x;
            ygrid=datav.y;
            if get(handles.radiobutton_GPU,interp_method)
                xgrid=gpuArray(single(xgrid));
                ygrid=gpuArray(single(ygrid));
                [Xgrid,Ygrid]=ndgrid(xgrid,ygrid);
                datav.value=gpuArray(single(datav.value));
                datav_nu.value=interp2(Ygrid,Xgrid,datav.value,Ygrid_nu,Xgrid_nu,'linear');
                datav_nu.value=double(gather(datav_nu.value));
                datav_nu.x=double(gather(xgrid_nu));
                datav_nu.y=double(gather(ygrid_nu));
            else
                [Xgrid,Ygrid]=ndgrid(xgrid,ygrid);
                datav_nu.value=interp2(Ygrid,Xgrid,datav.value,Ygrid_nu,Xgrid_nu,interp_method);
                datav_nu.x=xgrid_nu;
                datav_nu.y=ygrid_nu;
            end
            datav_nu.value(isnan(datav_nu.value))=0;
            assignin('base',cat(2,var_name,'_nu'),datav_nu);
            clearvars -except xgrid_nu Xgrid_nu ygrid_nu Ygrid_nu list_entries index_selected index_num handles
         end
    case 3
         for index_num=1:index_length
            var_name = list_entries{index_selected(index_num)};  %determine the var in base
            datav=evalin('base',var_name);
            datav.value(isnan(datav.value))=0;
            xgrid=datav.x;
            ygrid=datav.y;
            zgrid=datav.z;
            if get(handles.radiobutton_GPU,'Value')
                xgrid=gpuArray(single(xgrid));
                ygrid=gpuArray(single(ygrid));
                zgrid=gpuArray(single(zgrid));
                [Xgrid,Ygrid,Zgrid]=ndgrid(xgrid,ygrid,zgrid);
                datav.value=gpuArray(single(datav.value));
                datav_nu.value=interp3(Ygrid,Xgrid,Zgrid,datav.value,Ygrid_nu,Xgrid_nu,Zgrid_nu,'linear');
                datav_nu.value=double(gather(datav_nu.value));
                datav_nu.x=double(gather(xgrid_nu));
                datav_nu.y=double(gather(ygrid_nu));
                datav_nu.z=double(gather(zgrid_nu));
            else
                [Xgrid,Ygrid,Zgrid]=ndgrid(xgrid,ygrid,zgrid);
                datav_nu.value=interp3(Ygrid,Xgrid,Zgrid,datav.value,Ygrid_nu,Xgrid_nu,Zgrid_nu,interp_method);
                datav_nu.x=xgrid_nu;
                datav_nu.y=ygrid_nu;
                datav_nu.z=zgrid_nu;
            end
            datav_nu.value(isnan(datav_nu.value))=0;
            assignin('base',cat(2,var_name,'_nu'),datav_nu);
            clearvars -except xgrid_nu Xgrid_nu ygrid_nu Ygrid_nu zgrid_nu Zgrid_nu list_entries index_selected index_num handles
         end
reset(gpuDevice(1));

vars=evalin('base','who');
set(handles.listbox,'String',vars);
end



% --- Executes on button press in radiobutton_delta_x.
function radiobutton_delta_x_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_delta_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_delta_x
set(handles.radiobutton_xnum,'Value',1-get(hObject,'Value'));


% --- Executes on button press in radiobutton_delta_y.
function radiobutton_delta_y_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_delta_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_delta_y
set(handles.radiobutton_ynum,'Value',1-get(hObject,'Value'));


% --- Executes on button press in radiobutton_delta_z.
function radiobutton_delta_z_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_delta_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_delta_z
set(handles.radiobutton_znum,'Value',1-get(hObject,'Value'));


% --- Executes on button press in radiobutton_xnum.
function radiobutton_xnum_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_xnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_xnum
set(handles.radiobutton_delta_x,'Value',1-get(hObject,'Value'));


% --- Executes on button press in radiobutton_ynum.
function radiobutton_ynum_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_ynum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_ynum
set(handles.radiobutton_delta_y,'Value',1-get(hObject,'Value'));


% --- Executes on button press in radiobutton_znum.
function radiobutton_znum_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_znum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_znum
set(handles.radiobutton_delta_z,'Value',1-get(hObject,'Value'));


% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    vars=evalin('base','who');
    set(handles.listbox,'String',vars);
    list_entries = get(handles.listbox,'String');
    index_selected = get(handles.listbox,'Value');
    var_name = list_entries{index_selected(1)};
    datav=evalin('base',var_name);

    if isfield(datav,'x')
        set(handles.radiobutton_x,'Value',1);
        set(handles.edit_x_1,'String',num2str(datav.x(1)));
        set(handles.edit_x_end,'String',num2str(datav.x(end)));
        set(handles.edit_delta_x,'String',num2str(datav.x(2)-datav.x(1)));
        set(handles.edit_xnum,'String',num2str(length(datav.x)));
    else
        set(handles.radiobutton_x,'Value',0);
        set(handles.edit_x_1,'String',[]);
        set(handles.edit_x_end,'String',[]);
        set(handles.edit_delta_x,'String',[]);
        set(handles.edit_xnum,'String',[]);
    end
    if isfield(datav,'y')
        set(handles.radiobutton_y,'Value',1);
        set(handles.edit_y_1,'String',num2str(datav.y(1)));
        set(handles.edit_y_end,'String',num2str(datav.y(end)));
        set(handles.edit_delta_y,'String',num2str(datav.y(2)-datav.y(1)));
        set(handles.edit_ynum,'String',num2str(length(datav.y)));
    else
        set(handles.radiobutton_y,'Value',0);
        set(handles.edit_y_1,'String',[]);
        set(handles.edit_y_end,'String',[]);
        set(handles.edit_delta_y,'String',[]);
        set(handles.edit_ynum,'String',[]);
    end
    if isfield(datav,'z')
        set(handles.radiobutton_z,'Value',1);
        set(handles.edit_z_1,'String',num2str(datav.z(1)));
        set(handles.edit_z_end,'String',num2str(datav.z(end)));
        set(handles.edit_delta_z,'String',num2str(datav.z(2)-datav.z(1)));
        set(handles.edit_znum,'String',num2str(length(datav.z)));
    else
        set(handles.radiobutton_z,'Value',0);
        set(handles.edit_z_1,'String',[]);
        set(handles.edit_z_end,'String',[]);
        set(handles.edit_delta_z,'String',[]);
        set(handles.edit_znum,'String',[]);
    end

    set(handles.radiobutton_xnum,'Value',1);
    set(handles.radiobutton_ynum,'Value',1);
    set(handles.radiobutton_znum,'Value',1);
    set(handles.radiobutton_delta_x,'Value',0);
    set(handles.radiobutton_delta_y,'Value',0);
    set(handles.radiobutton_delta_z,'Value',0);  
    set(handles.radiobutton_GPU,'Value',0);
    set(handles.popupmenu_interp_method,'Value',1);
    
end


% --- Executes on selection change in popupmenu_interp_method.
function popupmenu_interp_method_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_interp_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_interp_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_interp_method


% --- Executes during object creation, after setting all properties.
function popupmenu_interp_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_interp_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
