function varargout = td_demo(varargin)
% TD_DEMO M-file for td_demo.fig
%      TD_DEMO, by itself, creates a new TD_DEMO or raises the existing
%      singleton*.
%
%      H = TD_DEMO returns the handle to a new TD_DEMO or the handle to
%      the existing singleton*.
%
%      TD_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TD_DEMO.M with the given input arguments.
%
%      TD_DEMO('Property','Value',...) creates a new TD_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before td_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to td_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help td_demo

% Last Modified by GUIDE v2.5 26-Nov-2019 19:46:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @td_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @td_demo_OutputFcn, ...
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


% --- Executes just before td_demo is made visible.
function td_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to td_demo (see VARARGIN)

% Choose default command line output for td_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes td_demo wait for user response (see UIRESUME)
% uiwait(handles.td_demo);


% --- Outputs from this function are returned to the command line.
function varargout = td_demo_OutputFcn(hObject, eventdata, handles) 
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

vars=evalin('base','who');
set(handles.variables,'String',vars);


function xmin_Callback(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmin as text
%        str2double(get(hObject,'String')) returns contents of xmin as a double


% --- Executes during object creation, after setting all properties.
function xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmax_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double


% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymin as text
%        str2double(get(hObject,'String')) returns contents of ymin as a double


% --- Executes during object creation, after setting all properties.
function ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymax as text
%        str2double(get(hObject,'String')) returns contents of ymax as a double


% --- Executes during object creation, after setting all properties.
function ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zmin_Callback(hObject, eventdata, handles)
% hObject    handle to zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zmin as text
%        str2double(get(hObject,'String')) returns contents of zmin as a double


% --- Executes during object creation, after setting all properties.
function zmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zmax_Callback(hObject, eventdata, handles)
% hObject    handle to zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zmax as text
%        str2double(get(hObject,'String')) returns contents of zmax as a double


% --- Executes during object creation, after setting all properties.
function zmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in truncate_data.
function truncate_data_Callback(hObject, eventdata, handles)
% hObject    handle to truncate_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%===================== Get information ==========================
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
VarNames = handles_h.VarNames; %get VarNames
index_size=length(VarNames);
if index_size==0
    return;
else
for indx_num=1:index_size
var_name = VarNames{indx_num};  %determine the var in base
datav=evalin('base',var_name);
flag_1d=0;
flag_2d=0;
flag_3d=0;
if ndims(datav.value)==3
flag_3d=1;
end
if ndims(datav.value)==3
flag_3d=1;
end
[n,m]=size(datav.value);
if ismatrix(datav.value)&&n~=1&&m~=1
    flag_2d=1;
else
    flag_1d=1;
end
if ndims(datav.value)==1
    flag_1d=1;
end
flag_index=get(handles.index_scale,'Value');
flag_scale=get(handles.real_scale,'Value');

xmin=get(handles.xmin,'String');
xmax=get(handles.xmax,'String');
ymin=get(handles.ymin,'String');
ymax=get(handles.ymax,'String');
zmin=get(handles.zmin,'String');
zmax=get(handles.zmax,'String');

%====================== check data format =====================
if ~(isfield(datav,'value') || isprop(datav,'value')) || ~(isfield(datav,'x')||isprop(datav,'x'))
    errordlg('Data must contains "data.value" and at least "data.x" (for 1d)','error input');
    return;
end
%====================== 1d case ================================
if flag_1d==1
    if flag_index==1                %------ if truncate by index----
        if strcmp(xmin,'Min')
            xmin_index=1;
        else
            xmin_index=str2num(xmin);
        end

        if strcmp(xmax,'Max')
            %xmax_index=size(datav.x,2);
            xmax_index=max(size(datav.x));
        else
            xmax_index=str2num(xmax);
        end
    else                            %----- if truncate by scale-----
        if strcmp(xmin,'Min')
            xmin_index=1;
        else
            xmin_index=round((str2num(xmin)-datav.x(1))/(datav.x(2)-datav.x(1)))+1;
        end

        if strcmp(xmax,'Max')
            xmax_index=max(size(datav.x));
        else
            xmax_index=round((str2num(xmax)-datav.x(1))/(datav.x(2)-datav.x(1)))+1;
        end
    end
    datav_tk=datav;
    datav_tk.x=datav.x(xmin_index:xmax_index);
    datav_tk.value=datav.value(xmin_index:xmax_index);
    assignin('base',cat(2,var_name,'_tk'),datav_tk);
end

%====================== 2d case ================================
if flag_2d==1
    if ~(isfield(datav,'y')||isprop(datav,'y'))
        errordlg('2D Data must also contains "data.y" field','error input');   
        return;
    end
    
    if flag_index==1                %------ if truncate by index----
        if strcmp(xmin,'Min')
            xmin_index=1;
        else
            xmin_index=str2num(xmin);
        end

        if strcmp(xmax,'Max')
            xmax_index=max(size(datav.x));
        else
            xmax_index=str2num(xmax);
        end
    else                            %----- if truncate by scale-----
        if strcmp(xmin,'Min')
            xmin_index=1;
        else
            xmin_index=round((str2num(xmin)-datav.x(1))/(datav.x(2)-datav.x(1)))+1;
        end

        if strcmp(xmax,'Max')
            xmax_index=max(size(datav.x));
        else
            xmax_index=round((str2num(xmax)-datav.x(1))/(datav.x(2)-datav.x(1)))+1;
        end
    end
%-------------------------------------------------------------------
    if flag_index==1                %------ if truncate by index----
        if strcmp(ymin,'Min')
            ymin_index=1;
        else
            ymin_index=str2num(ymin);
        end

        if strcmp(ymax,'Max')
            ymax_index=max(size(datav.y));
        else
            ymax_index=str2num(ymax);
        end
    else                            %----- if truncate by scale-----
        if strcmp(ymin,'Min')
            ymin_index=1;
        else
            ymin_index=round((str2num(ymin)-datav.y(1))/(datav.y(2)-datav.y(1)))+1;
        end

        if strcmp(ymax,'Max')
            ymax_index=max(size(datav.y));
        else
            ymax_index=round((str2num(ymax)-datav.y(1))/(datav.y(2)-datav.y(1)))+1;
        end
    end
    datav_tk=datav;
    datav_tk.x=datav.x(xmin_index:xmax_index);
    datav_tk.y=datav.y(ymin_index:ymax_index);
    datav_tk.value=datav.value(xmin_index:xmax_index,ymin_index:ymax_index);
    assignin('base',cat(2,var_name,'_tk'),datav_tk);
end

%========================= 3d case ====================================
if flag_3d==1
    
    if ~(isfield(datav,'z')||isprop(datav,'z'))
        errordlg('3D Data must also contains "data.z" field','error input');
        return;
    end
    
    if flag_index==1                %------ if truncate by index----
        if strcmp(xmin,'Min')
            xmin_index=1;
        else
            xmin_index=str2num(xmin);
        end

        if strcmp(xmax,'Max')
            xmax_index=max(size(datav.x));
        else
            xmax_index=str2num(xmax);
        end
    else                            %----- if truncate by scale-----
        if strcmp(xmin,'Min')
            xmin_index=1;
        else
            xmin_index=round((str2num(xmin)-datav.x(1))/(datav.x(2)-datav.x(1)))+1;
        end

        if strcmp(xmax,'Max')
            xmax_index=max(size(datav.x));
        else
            xmax_index=round((str2num(xmax)-datav.x(1))/(datav.x(2)-datav.x(1)))+1;
        end
    end
%-------------------------------------------------------------------
    if flag_index==1                %------ if truncate by index----
        if strcmp(ymin,'Min')
            ymin_index=1;
        else
            ymin_index=str2num(ymin);
        end

        if strcmp(ymax,'Max')
            ymax_index=max(size(datav.y));
        else
            ymax_index=str2num(ymax);
        end
    else                            %----- if truncate by scale-----
        if strcmp(ymin,'Min')
            ymin_index=1;
        else
            ymin_index=round((str2num(ymin)-datav.y(1))/(datav.y(2)-datav.y(1)))+1;
        end

        if strcmp(ymax,'Max')
            ymax_index=max(size(datav.y));
        else
            ymax_index=round((str2num(ymax)-datav.y(1))/(datav.y(2)-datav.y(1)))+1;
        end
    end
%-------------------------------------------------------------------
    if flag_index==1                %------ if truncate by index----
        if strcmp(zmin,'Min')
            zmin_index=1;
        else
            zmin_index=str2num(zmin);
        end

        if strcmp(zmax,'Max')
            zmax_index=max(size(datav.z));
        else
            zmax_index=str2num(zmax);
        end
    else                            %----- if truncate by scale-----
        
        if strcmp(zmin,'Min')
            zmin_index=1;
        else
            zmin_index=round((str2num(zmin)-datav.z(1))/(datav.z(2)-datav.z(1)))+1;
        end

        if strcmp(zmax,'Max')
            zmax_index=max(size(datav.z));
        else
            zmax_index=round((str2num(zmax)-datav.z(1))/(datav.z(2)-datav.z(1)))+1;
        end
    end
    
    %sandy modified for Photon Dep Data
    if isfield(datav,'ztot')
        datav.ztot = datav.ztot(zmin_index:zmax_index,xmin_index:xmax_index);
    end
        
    datav_tk=datav;
    datav_tk.x=datav.x(xmin_index:xmax_index);
    datav_tk.y=datav.y(ymin_index:ymax_index);
    datav_tk.z=datav.z(zmin_index:zmax_index);
    datav_tk.value=datav.value(xmin_index:xmax_index,ymin_index:ymax_index,zmin_index:zmax_index);
    assignin('base',cat(2,var_name,'_tk'),datav_tk);
end
end
end
