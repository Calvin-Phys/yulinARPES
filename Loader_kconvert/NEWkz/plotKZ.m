function varargout = plotKZ(varargin)
%this plot convert 3D data x.photonEnergy y.slitAngle z.Ek value to be
%kpar kz Ek
% PLOTKZ MATLAB code for plotKZ.fig
%      PLOTKZ, by itself, creates a new PLOTKZ or raises the existing
%      singleton*.
%
%      H = PLOTKZ returns the handle to a new PLOTKZ or the handle to
%      the existing singleton*.
%
%      PLOTKZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTKZ.M with the given input arguments.
%
%      PLOTKZ('Property','Value',...) creates a new PLOTKZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotKZ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotKZ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotKZ

% Last Modified by GUIDE v2.5 03-Oct-2015 07:31:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotKZ_OpeningFcn, ...
                   'gui_OutputFcn',  @plotKZ_OutputFcn, ...
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


% --- Executes just before plotKZ is made visible.
function plotKZ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotKZ (see VARARGIN)

% Choose default command line output for plotKZ
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotKZ wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotKZ_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars = evalin('base','who');
set(handles.listbox1,'String',vars)
%1;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


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



function value_a_Callback(hObject, eventdata, handles)
% hObject    handle to value_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_a as text
%        str2double(get(hObject,'String')) returns contents of value_a as a double


% --- Executes during object creation, after setting all properties.
function value_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value_c_Callback(hObject, eventdata, handles)
% hObject    handle to value_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_c as text
%        str2double(get(hObject,'String')) returns contents of value_c as a double


% --- Executes during object creation, after setting all properties.
function value_c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m_eff_Callback(hObject, eventdata, handles)
% hObject    handle to m_eff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m_eff as text
%        str2double(get(hObject,'String')) returns contents of m_eff as a double


% --- Executes during object creation, after setting all properties.
function m_eff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m_eff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Elevel_Callback(hObject, eventdata, handles)
% hObject    handle to Elevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Elevel as text
%        str2double(get(hObject,'String')) returns contents of Elevel as a double


% --- Executes during object creation, after setting all properties.
function Elevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Elevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phi_offset_Callback(hObject, eventdata, handles)
% hObject    handle to phi_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phi_offset as text
%        str2double(get(hObject,'String')) returns contents of phi_offset as a double


% --- Executes during object creation, after setting all properties.
function phi_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phi_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numofkpar_Callback(hObject, eventdata, handles)
% hObject    handle to numofkpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numofkpar as text
%        str2double(get(hObject,'String')) returns contents of numofkpar as a double


% --- Executes during object creation, after setting all properties.
function numofkpar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numofkpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta_offset_Callback(hObject, eventdata, handles)
% hObject    handle to theta_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta_offset as text
%        str2double(get(hObject,'String')) returns contents of theta_offset as a double


% --- Executes during object creation, after setting all properties.
function theta_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numofkz_Callback(hObject, eventdata, handles)
% hObject    handle to numofkz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numofkz as text
%        str2double(get(hObject,'String')) returns contents of numofkz as a double


% --- Executes during object creation, after setting all properties.
function numofkz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numofkz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in convert_kz_level.
function convert_kz_level_Callback(hObject, eventdata, handles)
% hObject    handle to convert_kz_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display('processing, please wait until next message')
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_name = list_entries{index_selected(1)};  %get var_name
datain=evalin('base',var_name); 

% parameters given
latt_constva=str2num(get(handles.value_a,'String'))*1e-10; %%converted now
latt_constvc=str2num(get(handles.value_c,'String'))*1e-10; %%converted now
offset=str2num(get(handles.phi_offset,'String')); %phi_offset
theta_offsetv=str2num(get(handles.theta_offset,'String'));
theta_positionv = str2num(get(handles.theta_position,'String'));
meffective=str2num(get(handles.m_eff,'String'));
v0=str2num(get(handles.Vo,'string'));
numofkpar=str2num(get(handles.numofkpar,'String'));
numofkz=str2num(get(handles.numofkz,'string'));
Elevel = str2num(get(handles.Elevel,'string'));

% just data format
if ~isfield(datain,'value') || ~isfield(datain,'x') || ~isfield(datain,'y') ||~isfield(datain,'z')
    errordlg('Data must contain fields: data.Value, data.x, data.y, data.z','Wrong data format');
    return;
end

if size(size(datain.value),2)~=3
    errordlg('Data should be three dimensional','Wrong data format');
    return;
end

%----- slicing the original data according to the Elevel -------

dumdumslice = datain;
dumdumslice.x = datain.ztot(Elevel,:);
dumdumslice.y = datain.y*pi/180;
dumdumslice.value = datain.value(:,:,Elevel);
dumdumslice.z = [];

%matlabpool('open',4);
dumdumslice2 = KzConv.Eslice_conversion(dumdumslice, latt_constva,latt_constvc,meffective,v0,offset,theta_offsetv,theta_positionv);

kx1 = dumdumslice2.kx1;
kpar_min = dumdumslice2.kpar_min;
kpar_max = dumdumslice2.kpar_max;
kzz_min = dumdumslice2.kzz_min;
kzz_max = dumdumslice2.kzz_max;

data_k.x = linspace(kzz_min,kzz_max,numofkz);
data_k.y = linspace(kpar_min,kpar_max,numofkpar);
data_k.info = datain.info;
[xgrid,ygrid] = ndgrid(data_k.x,data_k.y);

F1 = zeros(numofkz,numofkpar);
F1 = griddata(dumdumslice2.kzz, dumdumslice2.kpar, dumdumslice2.value, xgrid, ygrid);

data_k.value = F1; 

%matlabpool('close');


%-------------record the conversion parameter--------------------
data_k.para.latt_constva=latt_constva;
data_k.para.latt_constvc=latt_constvc;
data_k.para.theta_offset=theta_offsetv;
data_k.para.theta_position = theta_positionv;
data_k.para.phi_offset=offset;
data_k.para.meffective = meffective;
data_k.para.potential_barrier = v0;
data_k.para.numoff_kparkz = [numofkpar numofkz];
%data_k.para.EphotonInitial = initial_photon;

%------------------put the converted data back-----------------
var_namei=cat(2,var_name,'_kz_SLICEconv');
assignin('base',var_namei,data_k);

load chirp;
sound(y, Fs);
% --- Executes on button press in combine_z_cut.
function combine_z_cut_Callback(hObject, eventdata, handles)
% hObject    handle to combine_z_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Vo_Callback(hObject, eventdata, handles)
% hObject    handle to Vo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Vo as text
%        str2double(get(hObject,'String')) returns contents of Vo as a double


% --- Executes during object creation, after setting all properties.
function Vo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Eph_init_Callback(hObject, eventdata, handles)
% hObject    handle to Eph_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Eph_init as text
%        str2double(get(hObject,'String')) returns contents of Eph_init as a double


% --- Executes during object creation, after setting all properties.
function Eph_init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Eph_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Eph_max_Callback(hObject, eventdata, handles)
% hObject    handle to Eph_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Eph_max as text
%        str2double(get(hObject,'String')) returns contents of Eph_max as a double


% --- Executes during object creation, after setting all properties.
function Eph_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Eph_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Eph_Callback(hObject, eventdata, handles)
% hObject    handle to Eph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Eph as text
%        str2double(get(hObject,'String')) returns contents of Eph as a double


% --- Executes during object creation, after setting all properties.
function Eph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Eph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function photon_step_Callback(hObject, eventdata, handles)
% hObject    handle to photon_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of photon_step as text
%        str2double(get(hObject,'String')) returns contents of photon_step as a double


% --- Executes during object creation, after setting all properties.
function photon_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to photon_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in convert_kz.
function convert_kz_Callback(hObject, eventdata, handles)
% hObject    handle to convert_kz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display('processing, please wait until next message')
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_name = list_entries{index_selected(1)};  %get var_name
datain=evalin('base',var_name); 

% parameters given
latt_constva=str2num(get(handles.value_a,'String')); %%converted later
latt_constvc=str2num(get(handles.value_c,'String')); %%converted later
offset=str2num(get(handles.phi_offset,'String')); %phi_offset
theta_offsetv=str2num(get(handles.theta_offset,'String'));
theta_positionv = str2num(get(handles.theta_position,'String'));
meffective=str2num(get(handles.m_eff,'String'));
v0=str2num(get(handles.Vo,'string'));
numofkpar=str2num(get(handles.numofkpar,'String'));
numofkz=str2num(get(handles.numofkz,'string'));

%initial_photon = str2num(get(handles.Eph_init,'string'));

% % just data format
% if ~isfield(datain,'value') || ~isfield(datain,'x') || ~isfield(datain,'y') ||~isfield(datain,'z')
%     errordlg('Data must contain fields: data.Value, data.x, data.y, data.z','Wrong data format');
%     return;
% end
% 
% if size(size(datain.value),2)~=3
%     errordlg('Data should be three dimensional','Wrong data format');
%     return;
% end

%matlabpool('open',4);
data_k = KzConv.kzconversionV4(datain, latt_constva,latt_constvc,meffective,v0,numofkpar,numofkz,offset,theta_offsetv,theta_positionv);
%matlabpool('close');


%-------------record the conversion parameter--------------------
data_k.para.latt_constva=latt_constva;
data_k.para.latt_constvc=latt_constvc;
data_k.para.theta_offset=theta_offsetv;
data_k.para.theta_position = theta_positionv;
data_k.para.phi_offset=offset;
data_k.para.meffective = meffective;
data_k.para.potential_barrier = v0;
data_k.para.numoff_kparkz = [numofkpar numofkz];
%data_k.para.EphotonInitial = initial_photon;

%------------------put the converted data back-----------------
var_namei=cat(2,var_name,'_kz_conv');
assignin('base',var_namei,data_k);

load chirp;
sound(y, Fs);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function output_name_Callback(hObject, eventdata, handles)
% hObject    handle to output_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_name as text
%        str2double(get(hObject,'String')) returns contents of output_name as a double


% --- Executes during object creation, after setting all properties.
function output_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to output_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_name as text
%        str2double(get(hObject,'String')) returns contents of output_name as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in plot_on.
function plot_on_Callback(hObject, eventdata, handles)
% hObject    handle to plot_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_on


% --- Executes when selected object is changed in datasource.
function datasource_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in datasource 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if hObject == handles.DLS
    DLS =1 ;
elseif hObject == handles.ALS
    ALS =1;
end



function theta_position_Callback(hObject, eventdata, handles)
% hObject    handle to theta_position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta_position as text
%        str2double(get(hObject,'String')) returns contents of theta_position as a double


% --- Executes during object creation, after setting all properties.
function theta_position_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
