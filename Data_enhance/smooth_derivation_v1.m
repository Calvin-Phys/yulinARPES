function varargout = smooth_derivation_v1(varargin)
% SMOOTH_DERIVATION_V1 MATLAB code for smooth_derivation_v1.fig
%      SMOOTH_DERIVATION_V1, by itself, creates a new SMOOTH_DERIVATION_V1 or raises the existing
%      singleton*.
%
%      H = SMOOTH_DERIVATION_V1 returns the handle to a new SMOOTH_DERIVATION_V1 or the handle to
%      the existing singleton*.
%
%      SMOOTH_DERIVATION_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMOOTH_DERIVATION_V1.M with the given input arguments.
%
%      SMOOTH_DERIVATION_V1('Property','Value',...) creates a new SMOOTH_DERIVATION_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before smooth_derivation_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to smooth_derivation_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help smooth_derivation_v1

% Last Modified by GUIDE v2.5 20-Jun-2012 11:28:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smooth_derivation_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @smooth_derivation_v1_OutputFcn, ...
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


% --- Executes just before smooth_derivation_v1 is made visible.
function smooth_derivation_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to smooth_derivation_v1 (see VARARGIN)

% Choose default command line output for smooth_derivation_v1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
update_listbox(handles);

% UIWAIT makes smooth_derivation_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = smooth_derivation_v1_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_listbox(handles);

function update_listbox(handles)
vars = evalin('base','who');
set(handles.listbox1,'String',vars)


% --- Executes on button press in dxx.
function dxx_Callback(hObject, eventdata, handles)
% hObject    handle to dxx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list=get(handles.listbox1,'String');
index=get(handles.listbox1,'Value');
data1=struct(evalin('base',list{index}));
x=data1.x;
y=data1.y;
f0=data1.value;
fxx=f0;
fyy=f0;
m=size(x,2);
n=size(y,2);
[xx,yy]=ndgrid(x,y);

fx=diff(f0,1,1)./diff(xx,1,1);
fy=diff(f0,1,2)./diff(yy,1,2);
xxx=xx(2:m,:);
yyy=yy(:,2:n);
fxx(2:m-1,:)=-diff(fx,1,1)./diff(xxx,1);
fyy(:,2:n-1)=-diff(fy,1,2)./diff(yyy,1,2);

fxx(1,:)=0;
fxx(m,:)=0;
fyy(:,1)=0;
fyy(:,n)=0;

assignin('base',[list{index},'_d2x'],struct('x',x,'y',y,'value',fxx));

update_listbox(handles);

% --- Executes on button press in dyy.
function dyy_Callback(hObject, eventdata, handles)
% hObject    handle to dyy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list=get(handles.listbox1,'String');
index=get(handles.listbox1,'Value');
data1=struct(evalin('base',list{index}));
x=data1.x;
y=data1.y;
f0=data1.value;
fxx=f0;
fyy=f0;
m=size(x,2);
n=size(y,2);
[xx,yy]=ndgrid(x,y);

fx=diff(f0,1,1)./diff(xx,1,1);
fy=diff(f0,1,2)./diff(yy,1,2);
xxx=xx(2:m,:);
yyy=yy(:,2:n);
fxx(2:m-1,:)=-diff(fx,1,1)./diff(xxx,1);
fyy(:,2:n-1)=-diff(fy,1,2)./diff(yyy,1,2);

fxx(1,:)=0;
fxx(m,:)=0;
fyy(:,1)=0;
fyy(:,n)=0;

assignin('base',[list{index},'_d2y'],struct('x',x,'y',y,'value',fyy));

update_listbox(handles);

% --- Executes on button press in dxx_dyy.
function dxx_dyy_Callback(hObject, eventdata, handles)
% hObject    handle to dxx_dyy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list=get(handles.listbox1,'String');
index=get(handles.listbox1,'Value');
data1=struct(evalin('base',list{index}));
x=data1.x;
y=data1.y;
f0=data1.value;
dff=-del2(f0,y,x);

assignin('base',[list{index},'_dxy'],struct('x',x,'y',y,'value',dff));

update_listbox(handles);

% --- Executes on button press in smooth.
function smooth_Callback(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list=get(handles.listbox1,'String');
index=get(handles.listbox1,'Value');
data1=struct(evalin('base',list{index}));
xy={data1.x,data1.y};
smooth=csaps(xy,data1.value,0.9997,xy);
assignin('base',[list{index},'_sm1'],struct('x',data1.x,'y',data1.y,'value',smooth));
update_listbox(handles);

% --- Executes on button press in smoother.
function smoother_Callback(hObject, eventdata, handles)
% hObject    handle to smoother (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list=get(handles.listbox1,'String');
index=get(handles.listbox1,'Value');
data1=struct(evalin('base',list{index}));
xy={data1.x,data1.y};
smooth=csaps(xy,data1.value,0.999,xy);
assignin('base',[list{index},'_sm2'],struct('x',data1.x,'y',data1.y,'value',smooth));
update_listbox(handles);

% --- Executes on button press in smoothest.
function smoothest_Callback(hObject, eventdata, handles)
% hObject    handle to smoothest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list=get(handles.listbox1,'String');
index=get(handles.listbox1,'Value');
data1=struct(evalin('base',list{index}));
xy={data1.x,data1.y};
smooth=csaps(xy,data1.value,0.99,xy);
assignin('base',[list{index},'_sm3'],struct('x',data1.x,'y',data1.y,'value',smooth));
update_listbox(handles);
