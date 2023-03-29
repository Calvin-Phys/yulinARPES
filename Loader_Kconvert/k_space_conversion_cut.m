function varargout = k_space_conversion_cut(varargin)
% K_SPACE_CONVERSION_CUT M-file for k_space_conversion_cut.fig
%      K_SPACE_CONVERSION_CUT, by itself, creates a new K_SPACE_CONVERSION_CUT or raises the existing
%      singleton*.
%
%      H = K_SPACE_CONVERSION_CUT returns the handle to a new K_SPACE_CONVERSION_CUT or the handle to
%      the existing singleton*.
%
%      K_SPACE_CONVERSION_CUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in K_SPACE_CONVERSION_CUT.M with the given input arguments.
%
%      K_SPACE_CONVERSION_CUT('Property','Value',...) creates a new K_SPACE_CONVERSION_CUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before k_space_conversion_cut_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to k_space_conversion_cut_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help k_space_conversion_cut

% Last Modified by GUIDE v2.5 09-Jul-2008 12:17:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @k_space_conversion_cut_OpeningFcn, ...
                   'gui_OutputFcn',  @k_space_conversion_cut_OutputFcn, ...
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


% --- Executes just before k_space_conversion_cut is made visible.
function k_space_conversion_cut_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to k_space_conversion_cut (see VARARGIN)

% Choose default command line output for k_space_conversion_cut
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes k_space_conversion_cut wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = k_space_conversion_cut_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in variables.
function variables_Callback(hObject, eventdata, handles)
% hObject    handle to variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables


% --- Executes during object creation, after setting all properties.
function variables_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refresh_variables.
function refresh_variables_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars = evalin('base','who');
set(handles.variables,'String',vars)


function ek_Callback(hObject, eventdata, handles)
% hObject    handle to ek (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ek as text
%        str2double(get(hObject,'String')) returns contents of ek as a double


% --- Executes during object creation, after setting all properties.
function ek_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ek (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function latt_const_Callback(hObject, eventdata, handles)
% hObject    handle to latt_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of latt_const as text
%        str2double(get(hObject,'String')) returns contents of latt_const as a double


% --- Executes during object creation, after setting all properties.
function latt_const_CreateFcn(hObject, eventdata, handles)
% hObject    handle to latt_const (see GCBO)
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



function k_space_step_Callback(hObject, eventdata, handles)
% hObject    handle to k_space_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k_space_step as text
%        str2double(get(hObject,'String')) returns contents of k_space_step as a double


% --- Executes during object creation, after setting all properties.
function k_space_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k_space_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in convert_cut.
function convert_cut_Callback(hObject, eventdata, handles)
% hObject    handle to convert_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%===================== Get infomation =========================
list_entries = get(handles.variables,'String');
index_selected = get(handles.variables,'Value');
var_name = list_entries{index_selected(1)};  %get var_name
data=evalin('base',var_name); 

ek_offsetv=str2num(get(handles.ek,'String'));
latt_constv=1e-10*str2num(get(handles.latt_const,'String'));
theta_offsetv=str2num(get(handles.theta_offset,'String'));
k_space_stepv=str2num(get(handles.k_space_step,'String'));

% just data format
if ~isfield(data,'value') | ~isfield(data,'x') | ~isfield(data,'y')
    errordlg('Data must contain fields: data.Value, data.x, data.y (for 3-D, also data.z)','Wrong data format');
    return;
end

if size(size(data.value),2)~=2
    errordlg('Data cut must be two dimensional','Wrong data format');
    return;
end

ce=1.6021892e-19;
me=9.109534e-31;
h=6.626176e-34;
k_unit=pi/latt_constv;

%===================== Start Conversion ==========================
%---------------if 2-d data--------------
% convention: alpha(data.x) is the analyzer angle
%             theta_offset is offset of the angle
    data.x=(data.x+theta_offsetv).*pi/180;      % change unit
    data.y=data.y+ek_offsetv;      % correct energy scale
    
%    [mesh_energy,mesh_angle]=meshgrid(data.y,data.x);
%    kkk=(sqrt(2*me*mesh_energy*ce)*2*pi/h)/k_unit.*sin(mesh_angle+theta_offsetv);

    %-----------make 1-D (kx,ky,E) serial for later interpolation--
    ii=size(data.x,2);
    jj=size(data.y,2);
    
    kxx=zeros(1,ii*jj);
    kyy=zeros(1,ii*jj);
    eee=zeros(1,ii*jj);
    
    k=1;
    for i=1:ii
        for j=1:jj
            kxx(k)=(sqrt(2*me*data.y(j)*ce)*2*pi/h)/k_unit.*sin(data.x(i));
            kyy(k)=data.y(j);
            eee(k)=data.value(i,j);
            k=k+1;
        end
    end
    
    %--------make new mesh-------------------------
    if k_space_stepv~=-1
        k_stepx=(max(kxx)-min(kxx))/k_space_stepv;
    else
        k_stepx=(max(kxx)-min(kxx))/ii;
    end
    
           
    kx_grid=[min(kxx):k_stepx:max(kxx)];
    ky_grid=data.y;
    
    % -------interpolate to 2-D even mesh----------
    data_k.x=kx_grid;
    data_k.y=ky_grid;
    data_k.value=griddata(kxx,kyy,eee,data_k.x',data_k.y);
    data_k.value=data_k.value';
    

%-------------record the conversion parameter--------------------
data_k.para.ek_offset=ek_offsetv;
data_k.para.latt_const=latt_constv/1e-10;
data_k.para.angle_offset=theta_offsetv*180/pi;
data_k.para.k_step=k_space_stepv;

%------------------put the converted data back-----------------
var_namei=cat(2,var_name,'_k_sp_cut');
assignin('base',var_namei,data_k);


%======================end of conversion=======================