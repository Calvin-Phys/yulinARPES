function varargout = k_space_conversion_Soleil(varargin)
% K_SPACE_CONVERSION_SOLEIL MATLAB code for k_space_conversion_Soleil.fig
%      K_SPACE_CONVERSION_SOLEIL, by itself, creates a new K_SPACE_CONVERSION_SOLEIL or raises the existing
%      singleton*.
%
%      H = K_SPACE_CONVERSION_SOLEIL returns the handle to a new K_SPACE_CONVERSION_SOLEIL or the handle to
%      the existing singleton*.
%
%      K_SPACE_CONVERSION_SOLEIL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in K_SPACE_CONVERSION_SOLEIL.M with the given input arguments.
%
%      K_SPACE_CONVERSION_SOLEIL('Property','Value',...) creates a new K_SPACE_CONVERSION_SOLEIL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before k_space_conversion_Soleil_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to k_space_conversion_Soleil_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help k_space_conversion_Soleil

% Last Modified by GUIDE v2.5 13-Jun-2015 17:22:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @k_space_conversion_Soleil_OpeningFcn, ...
                   'gui_OutputFcn',  @k_space_conversion_Soleil_OutputFcn, ...
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


% --- Executes just before k_space_conversion_Soleil is made visible.
function k_space_conversion_Soleil_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to k_space_conversion_Soleil (see VARARGIN)

% Choose default command line output for k_space_conversion_Soleil
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes k_space_conversion_Soleil wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = k_space_conversion_Soleil_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_name = list_entries{index_selected(1)};  %get var_name
datain =evalin('base',var_name);

try
    set(handles.tilt_angle,'String',num2str(datain.info.theta(1)))
catch
    set(handles.tilt_angle,'String','no info')
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cone_angle_Callback(hObject, eventdata, handles)
% hObject    handle to cone_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cone_angle as text
%        str2double(get(hObject,'String')) returns contents of cone_angle as a double


% --- Executes during object creation, after setting all properties.
function cone_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cone_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cone_angle_azimuthpos_Callback(hObject, eventdata, handles)
% hObject    handle to cone_angle_azimuthpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cone_angle_azimuthpos as text
%        str2double(get(hObject,'String')) returns contents of cone_angle_azimuthpos as a double


% --- Executes during object creation, after setting all properties.
function cone_angle_azimuthpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cone_angle_azimuthpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function latt_constv_Callback(hObject, eventdata, handles)
% hObject    handle to latt_constv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of latt_constv as text
%        str2double(get(hObject,'String')) returns contents of latt_constv as a double


% --- Executes during object creation, after setting all properties.
function latt_constv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to latt_constv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numkx_Callback(hObject, eventdata, handles)
% hObject    handle to numkx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numkx as text
%        str2double(get(hObject,'String')) returns contents of numkx as a double


% --- Executes during object creation, after setting all properties.
function numkx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numkx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numky_Callback(hObject, eventdata, handles)
% hObject    handle to numky (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numky as text
%        str2double(get(hObject,'String')) returns contents of numky as a double


% --- Executes during object creation, after setting all properties.
function numky_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numky (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refresh_var.
function refresh_var_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars = evalin('base','who');
set(handles.listbox1,'String',vars)

% --- Executes on button press in conv_k_space.
function conv_k_space_Callback(hObject, eventdata, handles)
% hObject    handle to conv_k_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_name = list_entries{index_selected(1)};  %get var_name
datain =evalin('base',var_name); 

%% retrieving the constant
% on the GUI is called sigma slit angle, in here it is called cone_angle
% which is defined as in my presentation
cone_angle=str2double(get(handles.cone_angle,'String'));
cone_angle_azimuthpos=str2double(get(handles.cone_angle_azimuthpos,'String'));
latt_constv=str2num(get(handles.latt_constv,'String'));
numkx=str2double(get(handles.numkx,'String'));
numky=str2double(get(handles.numky,'String'));

%% start converting
disp('start converting')
callingfunction = tic;
dataout = kSpaceConversionFromPolar_v2(datain,cone_angle,cone_angle_azimuthpos,latt_constv,numkx,numky);
toc(callingfunction)
disp('done converting')
%% collecting the constant
dataout.para.cone_angle = cone_angle;
dataout.para.cone_angle_azimuthpos = cone_angle_azimuthpos;
dataout.para.latt_constant = latt_constv;
dataout.para.tilt = datain.info.theta;
%% put data back
var_namei=cat(2,var_name,'_k_sp');
assignin('base',var_namei,dataout);

load chirp;
   sound(y, Fs);


% --- Executes during object creation, after setting all properties.
function tilt_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tilt_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox1.
function listbox1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function fermi_energy_Callback(hObject, eventdata, handles)
% hObject    handle to fermi_energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fermi_energy as text
%        str2double(get(hObject,'String')) returns contents of fermi_energy as a double


% --- Executes during object creation, after setting all properties.
function fermi_energy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fermi_energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fermisurface.
function fermisurface_Callback(hObject, eventdata, handles)
% hObject    handle to fermisurface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_name = list_entries{index_selected(1)};  %get var_name
datain =evalin('base',var_name); 

%% retrieving the constant
% on the GUI is called sigma slit angle, in here it is called cone_angle
% which is defined as in my presentation
cone_angle=str2double(get(handles.cone_angle,'String'));
cone_angle_azimuthpos=str2double(get(handles.cone_angle_azimuthpos,'String'));
latt_constv=str2num(get(handles.latt_constv,'String'));
numkx=str2double(get(handles.numkx,'String'));
numky=str2double(get(handles.numky,'String'));
fermi_energy=str2double(get(handles.fermi_energy,'String'));

%% start converting
disp('start converting')
callingfunction = tic;

[~,index_fermi] = min(abs(datain.z - fermi_energy));
fermi_energy = datain.z(index_fermi);

datain.z = fermi_energy;
datain.value = datain.value(:,:,index_fermi);

dataout = kSpaceConversionFromPolar_v2(datain,cone_angle,cone_angle_azimuthpos,latt_constv,numkx,numky);
toc(callingfunction)
disp('done converting')
%% collecting the constant
dataout.para.cone_angle = cone_angle;
dataout.para.cone_angle_azimuthpos = cone_angle_azimuthpos;
dataout.para.latt_constant = latt_constv;
dataout.para.tilt = datain.info.theta;
%% put data back
var_namei=cat(2,var_name,'_k_sp_fermi');
assignin('base',var_namei,dataout);

load chirp;
   sound(y, Fs);
