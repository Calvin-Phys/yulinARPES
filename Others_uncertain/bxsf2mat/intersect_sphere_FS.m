function varargout = intersect_sphere_FS(varargin)
% INTERSECT_SPHERE_FS MATLAB code for intersect_sphere_FS.fig
%      INTERSECT_SPHERE_FS, by itself, creates a new INTERSECT_SPHERE_FS or raises the existing
%      singleton*.
%
%      H = INTERSECT_SPHERE_FS returns the handle to a new INTERSECT_SPHERE_FS or the handle to
%      the existing singleton*.
%
%      INTERSECT_SPHERE_FS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERSECT_SPHERE_FS.M with the given input arguments.
%
%      INTERSECT_SPHERE_FS('Property','Value',...) creates a new INTERSECT_SPHERE_FS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before intersect_sphere_FS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to intersect_sphere_FS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help intersect_sphere_FS

% Last Modified by GUIDE v2.5 19-Jun-2018 08:58:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @intersect_sphere_FS_OpeningFcn, ...
                   'gui_OutputFcn',  @intersect_sphere_FS_OutputFcn, ...
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


% --- Executes just before intersect_sphere_FS is made visible.
function intersect_sphere_FS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to intersect_sphere_FS (see VARARGIN)

% Choose default command line output for intersect_sphere_FS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes intersect_sphere_FS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = intersect_sphere_FS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_translation_vector_Callback(hObject, eventdata, handles)
% hObject    handle to edit_translation_vector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_translation_vector as text
%        str2double(get(hObject,'String')) returns contents of edit_translation_vector as a double


% --- Executes during object creation, after setting all properties.
function edit_translation_vector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_translation_vector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
raw_data=evalin('base','bxsf_data');
translation_direction=str2num(get(handles.edit_translation_vector, 'String'));
if get(handles.popupmenu_translation_units,'Value')==1
    raw_data.kx=raw_data.kx+translation_direction(1).*norm(raw_data.v1);
    raw_data.ky=raw_data.ky+translation_direction(2).*norm(raw_data.v2);
    raw_data.kz=raw_data.kz+translation_direction(3).*norm(raw_data.v3);
else
    raw_data.kx=raw_data.kx+translation_direction(1);
    raw_data.ky=raw_data.ky+translation_direction(2);
    raw_data.kz=raw_data.kz+translation_direction(3);
end
assignin('base', 'bxsf_data', raw_data);



function edit_Ekin_V0_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ekin_V0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ekin_V0 as text
%        str2double(get(hObject,'String')) returns contents of edit_Ekin_V0 as a double


% --- Executes during object creation, after setting all properties.
function edit_Ekin_V0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ekin_V0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EplusV0=str2num(get(handles.edit_Ekin_V0, 'String'));

raw_data=evalin('base','bxsf_data');
length_kz_cut_plane_side=1;
resolution_cut=200;
kz_direction=[0 0 1];
assignin('base', 'bxsf_kzcut_data', cut_kz_plane_sphere( raw_data,...
    kz_direction, EplusV0,length_kz_cut_plane_side,resolution_cut ));


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EplusV0=str2num(get(handles.edit_Ekin_V0, 'String'));
translation_direction=str2num(get(handles.edit_translation_vector, 'String'));
raw_data=evalin('base','bxsf_data');
if get(handles.popupmenu_translation_units,'Value')==1
    o1=translation_direction(1).*norm(raw_data.v1);
    o2=translation_direction(2).*norm(raw_data.v2);
    o3=translation_direction(3).*norm(raw_data.v3);
else
    o1=translation_direction(1);
    o2=translation_direction(2);
    o3=translation_direction(3);
end

A=2*9.10938291e-31*1.6e-19/1.054571726e-34^2*10^-20;
kz_plane_intercept=sqrt(A*EplusV0);
drawSphere([o1 o2 o3 kz_plane_intercept],'nPhi', 360, 'nTheta', 180,'linestyle', ':', 'facecolor', 'r','FaceAlpha',0.6)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_translation_units.
function popupmenu_translation_units_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_translation_units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_translation_units contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_translation_units


% --- Executes during object creation, after setting all properties.
function popupmenu_translation_units_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_translation_units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
