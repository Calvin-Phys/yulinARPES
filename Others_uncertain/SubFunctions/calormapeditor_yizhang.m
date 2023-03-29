%calormapeditor_yizhang(hfig, position) 
%hfig, handle of the figure for edit
%position, position of this ui
function varargout = calormapeditor_yizhang(varargin)
%calormapeditor_yizhang(hfig, position)
%hfig, handle of the figure for edit
%position, position of this ui
%CALORMAPEDITOR_YIZHANG MATLAB code for calormapeditor_yizhang.fig
%      CALORMAPEDITOR_YIZHANG, by itself, creates a new CALORMAPEDITOR_YIZHANG or raises the existing
%      singleton*.
%
%      H = CALORMAPEDITOR_YIZHANG returns the handle to a new CALORMAPEDITOR_YIZHANG or the handle to
%      the existing singleton*.
%
%      CALORMAPEDITOR_YIZHANG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALORMAPEDITOR_YIZHANG.M with the given input arguments.
%
%      CALORMAPEDITOR_YIZHANG('Property','Value',...) creates a new CALORMAPEDITOR_YIZHANG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calormapeditor_yizhang_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calormapeditor_yizhang_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calormapeditor_yizhang

% Last Modified by GUIDE v2.5 14-Nov-2013 12:03:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calormapeditor_yizhang_OpeningFcn, ...
                   'gui_OutputFcn',  @calormapeditor_yizhang_OutputFcn, ...
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


% --- Executes just before calormapeditor_yizhang is made visible.
function calormapeditor_yizhang_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calormapeditor_yizhang (see VARARGIN)

% Choose default command line output for calormapeditor_yizhang
handles.output = hObject;
global hfig ha cl_map clim clim0
hfig=figure(varargin{1});
ha=gca;
figure(hfig);
cl_map=colormap;

% Update handles structure
guidata(hObject, handles);

%plot color map
h=figure(get(handles.color_map,'Parent'));
rgbplot(get(hfig,'ColorMap'));
set(gca,'XTickLabel',[],'YTickLabel',[]);

set(h,'Unit','pixels','Resize','on');
position=get(h,'Position');
windows_position=varargin{2};
if  isvector(windows_position)
    position(1)=windows_position(1);
    position(2)=windows_position(2)-position(4)-35;
    set(h,'Position',position);
end
figure(hfig);
%read color limit
clim=caxis;
set(handles.cmin,'String',num2str(clim(1)));
set(handles.cmax,'String',num2str(clim(2)));
set(handles.clim_max,'Value',1);
set(handles.clim_min,'Value',0);
clim0=clim;



% UIWAIT makes calormapeditor_yizhang wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = calormapeditor_yizhang_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig ha cl_map

figure(hfig);

colormap(ha,cl_map);

cl=get(hfig,'Color');
beta=get(handles.gamma,'Value');
brighten(hfig,beta);
set(handles.gamma_txt,'String',num2str(beta));
set(hfig,'Color',cl);

update_colormap(handles);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function gamma_txt_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma_txt as text
%        str2double(get(hObject,'String')) returns contents of gamma_txt as a double
global hfig ha cl_map
load('Colormap.mat');
colormap(ha,cl_map);
cl=get(hfig,'Color');

v=str2num(get(handles.gamma_txt,'String'));
beta=max(-1,min(1,v));
brighten(hfig,beta);
set(handles.gamma,'Value',beta);
set(hfig,'Color',cl);

update_colormap(handles);


% --- Executes during object creation, after setting all properties.
function gamma_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over gamma.
function gamma_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function clim_max_Callback(hObject, eventdata, handles)
% hObject    handle to clim_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global hfig clim
figure(hfig);
nclim(1)=get(handles.clim_min,'Value')*(clim(2)-clim(1))+clim(1);
nclim(2)=get(handles.clim_max,'Value')*(clim(2)-clim(1))+clim(1);
if nclim(1)>nclim(2)
    nclim(2)=nclim(1)+0.001*(clim(2)-clim(1));
    set(handles.clim_max,'Value',(nclim(2)-clim(1))/(clim(2)-clim(1)));
end
set(handles.cmax,'String',num2str(nclim(2)));
caxis(nclim);

update_colormap(handles);



% --- Executes during object creation, after setting all properties.
function clim_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clim_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function clim_min_Callback(hObject, eventdata, handles)
% hObject    handle to clim_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global hfig clim
figure(hfig);
nclim(1)=get(handles.clim_min,'Value')*(clim(2)-clim(1))+clim(1);
nclim(2)=get(handles.clim_max,'Value')*(clim(2)-clim(1))+clim(1);
if nclim(1)>nclim(2)
    nclim(1)=nclim(2)-0.001*(clim(2)-clim(1));
    set(handles.clim_min,'Value',(nclim(1)-clim(1))/(clim(2)-clim(1)));
end
set(handles.cmin,'String',num2str(nclim(1)));
caxis(nclim);

update_colormap(handles);


% --- Executes during object creation, after setting all properties.
function clim_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clim_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function cmax_Callback(hObject, eventdata, handles)
% hObject    handle to cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmax as text
%        str2double(get(hObject,'String')) returns contents of cmax as a double
global hfig clim
figure(hfig);
nclim(1)=get(handles.clim_min,'Value')*(clim(2)-clim(1))+clim(1);
nclim(2)=str2double(get(handles.cmax,'String'));
if nclim(1)>nclim(2)
    nclim(2)=nclim(1)+0.001*(clim(2)-clim(1));
    set(handles.cmax,'String',num2str(nclim(2)));
end
ratio=(nclim(2)-clim(1))/(clim(2)-clim(1));

if ratio>1
    clim(2)=nclim(2);
    ratio=1;
end

set(handles.clim_max,'Value',ratio);
caxis(nclim);

update_colormap(handles);


% --- Executes during object creation, after setting all properties.
function cmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cmin_Callback(hObject, eventdata, handles)
% hObject    handle to cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmin as text
%        str2double(get(hObject,'String')) returns contents of cmin as a double
global hfig clim
figure(hfig);
nclim(1)=str2double(get(handles.cmin,'String'));
nclim(2)=get(handles.clim_max,'Value')*(clim(2)-clim(1))+clim(1);
if nclim(1)>nclim(2)
    nclim(1)=nclim(2)-0.001*(clim(2)-clim(1));
    set(handles.cmin,'String',num2str(nclim(1)));
end

ratio=(nclim(1)-clim(1))/(clim(2)-clim(1));
if ratio<0
    clim(1)=nclim(1);
    ratio=0;
end
set(handles.clim_min,'Value',ratio);
caxis(nclim);
update_colormap(handles);

% --- Executes during object creation, after setting all properties.
function cmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cmax_set.
function cmax_set_Callback(hObject, eventdata, handles)
% hObject    handle to cmax_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cmin_set.
function cmin_set_Callback(hObject, eventdata, handles)
% hObject    handle to cmin_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function update_colormap(handles)
global hfig

figure(get(handles.color_map,'Parent'));

rgbplot(get(hfig,'ColorMap'));

set(gca,'XTickLabel',[],'YTickLabel',[]);
figure(hfig);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

global hfig ha cl_map clim clim0
clear hfig ha cl_map clim clim0
delete(hObject);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global clim0 cl_map clim hfig ha 

figure(hfig);
caxis(clim0);
colormap(ha,cl_map);
set(handles.cmin,'String',num2str(clim0(1)));
set(handles.cmax,'String',num2str(clim0(2)));
set(handles.clim_max,'Value',1);
set(handles.clim_min,'Value',0);
set(handles.gamma,'Value',0);
set(handles.gamma_txt,'String',0);
clim=clim0;
update_colormap(handles);
