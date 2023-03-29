function varargout = data_interpolation_demo(varargin)
% DATA_INTERPOLATION_DEMO M-file for data_interpolation_demo.fig
%      DATA_INTERPOLATION_DEMO, by itself, creates a new DATA_INTERPOLATION_DEMO or raises the existing
%      singleton*.
%
%      H = DATA_INTERPOLATION_DEMO returns the handle to a new DATA_INTERPOLATION_DEMO or the handle to
%      the existing singleton*.
%
%      DATA_INTERPOLATION_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_INTERPOLATION_DEMO.M with the given input arguments.
%
%      DATA_INTERPOLATION_DEMO('Property','Value',...) creates a new DATA_INTERPOLATION_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data_interpolation_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data_interpolation_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data_interpolation_demo

% Last Modified by GUIDE v2.5 12-Apr-2015 22:45:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data_interpolation_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @data_interpolation_demo_OutputFcn, ...
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


% --- Executes just before data_interpolation_demo is made visible.
function data_interpolation_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_interpolation_demo (see VARARGIN)

% Choose default command line output for data_interpolation_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data_interpolation_demo wait for user response (see UIRESUME)
% uiwait(handles.data_interpolation_demo);


% --- Outputs from this function are returned to the command line.
function varargout = data_interpolation_demo_OutputFcn(hObject, eventdata, handles) 
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

% Hints: contents = cellstr(get(hObject,'String')) returns variables contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables


% --- Executes during object creation, after setting all properties.
function variables_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: variables controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refresh_variables.
function refresh_variables_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars=evalin('base','who');
set(handles.variables,'String',vars);


function x_from_Callback(hObject, eventdata, handles)
% hObject    handle to x_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_from as text
%        str2double(get(hObject,'String')) returns contents of x_from as a double


% --- Executes during object creation, after setting all properties.
function x_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function y_from_Callback(hObject, eventdata, handles)
% hObject    handle to y_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_from as text
%        str2double(get(hObject,'String')) returns contents of y_from as a double


% --- Executes during object creation, after setting all properties.
function y_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_from_Callback(hObject, eventdata, handles)
% hObject    handle to z_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_from as text
%        str2double(get(hObject,'String')) returns contents of z_from as a double


% --- Executes during object creation, after setting all properties.
function z_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_to_Callback(hObject, eventdata, handles)
% hObject    handle to x_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_to as text
%        str2double(get(hObject,'String')) returns contents of x_to as a double


% --- Executes during object creation, after setting all properties.
function x_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_to_Callback(hObject, eventdata, handles)
% hObject    handle to y_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_to as text
%        str2double(get(hObject,'String')) returns contents of y_to as a double


% --- Executes during object creation, after setting all properties.
function y_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_to_Callback(hObject, eventdata, handles)
% hObject    handle to z_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_to as text
%        str2double(get(hObject,'String')) returns contents of z_to as a double


% --- Executes during object creation, after setting all properties.
function z_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_no_Callback(hObject, eventdata, handles)
% hObject    handle to x_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_no as text
%        str2double(get(hObject,'String')) returns contents of x_no as a double


% --- Executes during object creation, after setting all properties.
function x_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_no_Callback(hObject, eventdata, handles)
% hObject    handle to y_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_no as text
%        str2double(get(hObject,'String')) returns contents of y_no as a double


% --- Executes during object creation, after setting all properties.
function y_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_no_Callback(hObject, eventdata, handles)
% hObject    handle to z_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_no as text
%        str2double(get(hObject,'String')) returns contents of z_no as a double


% --- Executes during object creation, after setting all properties.
function z_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in generate_new_data_set.
function generate_new_data_set_Callback(hObject, eventdata, handles)
% hObject    handle to generate_new_data_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%===================== Get information ==========================
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
VarNames = handles_h.VarNames;
index_length=length(VarNames);
if index_length<1
    return;
end
for index_num=1:index_length
var_name = VarNames{index_num};  %determine the var in base
datav=evalin('base',var_name);
datav_nu=datav;

xmin=get(handles.x_from,'String');
xmax=get(handles.x_to,'String');
xno=str2num(get(handles.x_no,'String'));

ymin=get(handles.y_from,'String');
ymax=get(handles.y_to,'String');
yno=str2num(get(handles.y_no,'String'));

zmin=get(handles.z_from,'String');
zmax=get(handles.z_to,'String');
zno=str2num(get(handles.z_no,'String'));
%====================== check data format =====================
if ~isfield(datav,'value') || ~isfield(datav,'x')
    errordlg('Data must contains "data.value" and at least "data.x" (for 1d)','error input');
    return;
end
%====================== 1d case ================================

if ndims(datav.value)==1
    if strcmp(xmin,'Min')
        xmin_nu=min(datav.x);
    else
        xmin_nu=str2num(xmin);
    end
    
    if strcmp(xmax,'Max')
        xmax_nu=max(datav.x);
    else
        xmax_nu=str2num(xmax);
    end
    
    if xno==-1
        xno_nu=max(size(datav.x));
    else
        xno_nu=xno;
    end
    
    datav_nu.x=linspace(xmin_nu,xmax_nu,xno_nu);
    datav_nu.value=interp1(datav.x,datav.value,datav_nu.x,'spline');
    assignin('base',cat(2,var_name,'_nu'),datav_nu);
end

%====================== 2d case ================================
if ndims(datav.value)==2
    if ~isfield(datav,'y')
        errordlg('2D Data must also contains "data.y" field','error input');
        return;
    end
    %-------------------------------------------------------------------
    if strcmp(xmin,'Min')
        xmin_nu=min(datav.x);
    else
        xmin_nu=str2num(xmin);
    end
    
    if strcmp(xmax,'Max')
        xmax_nu=max(datav.x);
    else
        xmax_nu=str2num(xmax);
    end
    
    if xno==-1
        xno_nu=max(size(datav.x));
    else
        xno_nu=xno;
    end
    %-------------------------------------------------------------------
    if strcmp(ymin,'Min')
        ymin_nu=min(datav.y);
    else
        ymin_nu=str2num(ymin);
    end
    
    if strcmp(ymax,'Max')
        ymax_nu=max(datav.y);
    else
        ymax_nu=str2num(ymax);
    end
    
    if yno==-1
        yno_nu=max(size(datav.y));
    else
        yno_nu=yno;
    end
    
    %------------------------------------------------------------------
    datav_nu.x=linspace(xmin_nu,xmax_nu,xno_nu);
    datav_nu.y=linspace(ymin_nu,ymax_nu,yno_nu);
    
    %[ygrid,xgrid]=meshgrid(datav.x, datav.y);
    %[ygrid_nu,xgrid_nu]=meshgrid(datav_nu.x, datav_nu.y);
    %datav_nu.value=transpose(interp2(ygrid, xgrid,transpose(datav.value),ygrid_nu,xgrid_nu,'spline'));
    
    [xgrid,ygrid]=meshgrid(datav.y, datav.x);
    [xgrid_nu,ygrid_nu]=meshgrid(datav_nu.y, datav_nu.x);
    datav_nu.value=interp2(xgrid, ygrid,datav.value,xgrid_nu,ygrid_nu,'spline');
    
    %datav_nu.value=transpose(interp2(xgrid, ygrid,transpose(datav.value),xgrid_nu,ygrid_nu,'spline'));
    
    assignin('base',cat(2,var_name,'_nu'),datav_nu);
end

%========================= 3d case ====================================
if ndims(datav.value)==3
    
    %-------------------------------------------------------------------
    if strcmp(xmin,'Min')
        xmin_nu=min(datav.x);
    else
        xmin_nu=str2num(xmin);
    end
    
    if strcmp(xmax,'Max')
        xmax_nu=max(datav.x);
    else
        xmax_nu=str2num(xmax);
    end
    
    if xno==-1
        xno_nu=max(size(datav.x));
    else
        xno_nu=xno;
    end
    %-------------------------------------------------------------------
    if strcmp(ymin,'Min')
        ymin_nu=min(datav.y);
    else
        ymin_nu=str2num(ymin);
    end
    
    if strcmp(ymax,'Max')
        ymax_nu=max(datav.y);
    else
        ymax_nu=str2num(ymax);
    end
    
    if yno==-1
        yno_nu=max(size(datav.y));
    else
        yno_nu=yno;
    end
    
    %-------------------------------------------------------------------
    if strcmp(zmin,'Min')
        zmin_nu=min(datav.z);
    else
        zmin_nu=str2num(zmin);
    end
    
    if strcmp(zmax,'Max')
        zmax_nu=max(datav.z);
    else
        zmax_nu=str2num(zmax);
    end
    
    if zno==-1
        zno_nu=max(size(datav.z));
    else
        zno_nu=zno;
    end
    %------------------------------------------------------------------
    datav_nu.x=linspace(xmin_nu,xmax_nu,xno_nu);
    datav_nu.y=linspace(ymin_nu,ymax_nu,yno_nu);
    datav_nu.z=linspace(zmin_nu,zmax_nu,zno_nu);
    
    [xgrid,ygrid,zgrid]=meshgrid(datav.y, datav.x,datav.z);
    [xgrid_nu,ygrid_nu,zgrid_nu]=meshgrid(datav_nu.y, datav_nu.x,datav_nu.z);
    
    datav_nu.value=interp3(xgrid, ygrid, zgrid,datav.value,xgrid_nu,ygrid_nu,zgrid_nu,'spline');
    assignin('base',cat(2,var_name,'_nu'),datav_nu);end
end



% --- Executes when data_interpolation_demo is resized.
function data_interpolation_demo_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to data_interpolation_demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
