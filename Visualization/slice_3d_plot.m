function varargout = slice_3d_plot(varargin)
% SLICE_3D_PLOT MATLAB code for slice_3d_plot.fig
%      SLICE_3D_PLOT, by itself, creates a new SLICE_3D_PLOT or raises the existing
%      singleton*.
%
%      H = SLICE_3D_PLOT returns the handle to a new SLICE_3D_PLOT or the handle to
%      the existing singleton*.
%
%      SLICE_3D_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLICE_3D_PLOT.M with the given input arguments.
%
%      SLICE_3D_PLOT('Property','Value',...) creates a new SLICE_3D_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before slice_3d_plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to slice_3d_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help slice_3d_plot

% Last Modified by GUIDE v2.5 28-Jul-2012 09:44:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @slice_3d_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @slice_3d_plot_OutputFcn, ...
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


% --- Executes just before slice_3d_plot is made visible.
function slice_3d_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to slice_3d_plot (see VARARGIN)

% Choose default command line output for slice_3d_plot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes slice_3d_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = slice_3d_plot_OutputFcn(hObject, eventdata, handles) 
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



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in update_listbox.
function update_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to update_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updatelistbox(handles);


% --- Executes on button press in check_xslice.
function check_xslice_Callback(hObject, eventdata, handles)
% hObject    handle to check_xslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_xslice



function xbegin_Callback(hObject, eventdata, handles)
% hObject    handle to xbegin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xbegin as text
%        str2double(get(hObject,'String')) returns contents of xbegin as a double


% --- Executes during object creation, after setting all properties.
function xbegin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xbegin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in colorselect.
function colorselect_Callback(hObject, eventdata, handles)
% hObject    handle to colorselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colorselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colorselect


% --- Executes during object creation, after setting all properties.
function colorselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zbegin_Callback(hObject, eventdata, handles)
% hObject    handle to zbegin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zbegin as text
%        str2double(get(hObject,'String')) returns contents of zbegin as a double


% --- Executes during object creation, after setting all properties.
function zbegin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zbegin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_zslice.
function check_zslice_Callback(hObject, eventdata, handles)
% hObject    handle to check_zslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_zslice



function ybegin_Callback(hObject, eventdata, handles)
% hObject    handle to ybegin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ybegin as text
%        str2double(get(hObject,'String')) returns contents of ybegin as a double


% --- Executes during object creation, after setting all properties.
function ybegin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ybegin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_yslice.
function check_yslice_Callback(hObject, eventdata, handles)
% hObject    handle to check_yslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_yslice



% --- Executes on button press in colormap.
function colormap_Callback(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure_num=str2num(get(handles.figure_no,'String'));

list_entries = get(handles.colorselect,'String');
index_selected = get(handles.colorselect,'Value');
colormap_v = list_entries{index_selected(1)}; 

figure(figure_num);
colormap(colormap_v);


function figure_no_Callback(hObject, eventdata, handles)
% hObject    handle to figure_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figure_no as text
%        str2double(get(hObject,'String')) returns contents of figure_no as a double


% --- Executes during object creation, after setting all properties.
function figure_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in figure_less.
function figure_less_Callback(hObject, eventdata, handles)
% hObject    handle to figure_less (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure_num=str2num(get(handles.figure_no,'String'));
figure_num=figure_num-1;
set(handles.figure_no,'String',num2str(figure_num));

% --- Executes on button press in figure_more.
function figure_more_Callback(hObject, eventdata, handles)
% hObject    handle to figure_more (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure_num=str2num(get(handles.figure_no,'String'));
figure_num=figure_num+1;
set(handles.figure_no,'String',num2str(figure_num));

% --- Executes on button press in slice_plot.
function slice_plot_Callback(hObject, eventdata, handles)
% hObject    handle to slice_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
data=evalin('base',var_name);
% if ~isfield(datav,'value')
%     data.value=datav;
% else data=datav;
% end
% clear datav;

figure_num=str2double(get(handles.figure_no,'String'));

if ndims(data.value)~=3
    errordlg('data must be 3D');
    return;
end

checkx=get(handles.check_xslice,'Value');
checky=get(handles.check_yslice,'Value');
checkz=get(handles.check_zslice,'Value');


if checkx==1
    xbegin=get(handles.xbegin,'String');        
    xslice=[];
    eval(['xslice=[',xbegin,']']);
else
    xslice=[];
end

if checky==1
   
    ybegin=get(handles.ybegin,'String');
    yslice=[];
    eval(['yslice=[',ybegin,']']);
else
    yslice=[];
end

if checkz==1
   
    zbegin=get(handles.zbegin,'String');
    zslice=[];
    eval(['zslice=[',zbegin,']']);
    
else
    zslice=[];
end

[x,y,z]=meshgrid(data.y,data.x,data.z);
v=data.value;

figure_num=str2double(get(handles.figure_no,'String'));

h=figure(figure_num);

hh=slice(x,y,z,v,xslice,yslice,zslice);

set(hh,'EdgeColor','flat');

list_entries2 = get(handles.colorselect,'String');
index_selected2 = get(handles.colorselect,'Value');
colormap_v = list_entries2{index_selected2(1)}; 
colormap(colormap_v);




function updatelistbox(handles)
vars = evalin('base','who');
set(handles.listbox1,'String',vars)
