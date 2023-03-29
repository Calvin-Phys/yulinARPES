function varargout = volume_3d_plot_w_notch(varargin)
% VOLUME_3D_PLOT_W_NOTCH M-file for volume_3d_plot_w_notch.fig
%      VOLUME_3D_PLOT_W_NOTCH, by itself, creates a new VOLUME_3D_PLOT_W_NOTCH or raises the existing
%      singleton*.
%
%      H = VOLUME_3D_PLOT_W_NOTCH returns the handle to a new VOLUME_3D_PLOT_W_NOTCH or the handle to
%      the existing singleton*.
%
%      VOLUME_3D_PLOT_W_NOTCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOLUME_3D_PLOT_W_NOTCH.M with the given input arguments.
%
%      VOLUME_3D_PLOT_W_NOTCH('Property','Value',...) creates a new VOLUME_3D_PLOT_W_NOTCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before volume_3d_plot_w_notch_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to volume_3d_plot_w_notch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help volume_3d_plot_w_notch

% Last Modified by GUIDE v2.5 27-Feb-2006 20:16:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @volume_3d_plot_w_notch_OpeningFcn, ...
                   'gui_OutputFcn',  @volume_3d_plot_w_notch_OutputFcn, ...
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


% --- Executes just before volume_3d_plot_w_notch is made visible.
function volume_3d_plot_w_notch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to volume_3d_plot_w_notch (see VARARGIN)

% Choose default command line output for volume_3d_plot_w_notch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes volume_3d_plot_w_notch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = volume_3d_plot_w_notch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in refresh_variables.
function refresh_variables_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------
vars = evalin('base','who');
set(handles.variables,'String',vars);
%---------------------

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
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_edit as text
%        str2double(get(hObject,'String')) returns contents of x_edit as a double


% --- Executes during object creation, after setting all properties.
function x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in x_dec.
function x_dec_Callback(hObject, eventdata, handles)
% hObject    handle to x_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%-------------------
if strcmp(get(handles.x_edit,'String'),'N')
    set(handles.x_edit,'String',num2str(0));
else
    x_valuev=str2num(get(handles.x_edit,'String'));
    step_sizev=str2num(get(handles.step_size_edit,'String'));
    set(handles.x_edit,'String', num2str(x_valuev-step_sizev));
end
%-------------------

% --- Executes on button press in x_inc.
function x_inc_Callback(hObject, eventdata, handles)
% hObject    handle to x_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%-------------------
if strcmp(get(handles.x_edit,'String'),'N')
    set(handles.x_edit,'String',num2str(0));
else
    x_valuev=str2num(get(handles.x_edit,'String'));
    step_sizev=str2num(get(handles.step_size_edit,'String'));
    set(handles.x_edit,'String', num2str(x_valuev+step_sizev));
end
%-------------------


function y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_edit as text
%        str2double(get(hObject,'String')) returns contents of y_edit as a double


% --- Executes during object creation, after setting all properties.
function y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in y_dec.
function y_dec_Callback(hObject, eventdata, handles)
% hObject    handle to y_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%-------------------
if strcmp(get(handles.y_edit,'String'),'N')
    set(handles.y_edit,'String',num2str(0));
else
    y_valuev=str2num(get(handles.y_edit,'String'));
    step_sizev=str2num(get(handles.step_size_edit,'String'));
    set(handles.y_edit,'String', num2str(y_valuev-step_sizev));
end
%-------------------

% --- Executes on button press in y_inc.
function y_inc_Callback(hObject, eventdata, handles)
% hObject    handle to y_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%-------------------
if strcmp(get(handles.y_edit,'String'),'N')
    set(handles.y_edit,'String',num2str(0));
else
    y_valuev=str2num(get(handles.y_edit,'String'));
    step_sizev=str2num(get(handles.step_size_edit,'String'));
    set(handles.y_edit,'String', num2str(y_valuev+step_sizev));
end
%-------------------


function z_edit_Callback(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_edit as text
%        str2double(get(hObject,'String')) returns contents of z_edit as a double


% --- Executes during object creation, after setting all properties.
function z_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in z_dec.
function z_dec_Callback(hObject, eventdata, handles)
% hObject    handle to z_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%-------------------
if strcmp(get(handles.z_edit,'String'),'N')
    set(handles.z_edit,'String',num2str(0));
else
    z_valuev=str2num(get(handles.z_edit,'String'));
    step_sizev=str2num(get(handles.step_size_edit,'String'));
    set(handles.z_edit,'String', num2str(z_valuev-step_sizev));
end
%-------------------

% --- Executes on button press in z_inc.
function z_inc_Callback(hObject, eventdata, handles)
% hObject    handle to z_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%-------------------
if strcmp(get(handles.z_edit,'String'),'N')
    set(handles.z_edit,'String',num2str(0));
else
    z_valuev=str2num(get(handles.z_edit,'String'));
    step_sizev=str2num(get(handles.step_size_edit,'String'));
    set(handles.z_edit,'String', num2str(z_valuev+step_sizev));
end
%-------------------


function step_size_edit_Callback(hObject, eventdata, handles)
% hObject    handle to step_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_size_edit as text
%        str2double(get(hObject,'String')) returns contents of step_size_edit as a double


% --- Executes during object creation, after setting all properties.
function step_size_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in notch_facing_pop.
function notch_facing_pop_Callback(hObject, eventdata, handles)
% hObject    handle to notch_facing_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns notch_facing_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from notch_facing_pop


% --- Executes during object creation, after setting all properties.
function notch_facing_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notch_facing_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%========================begin=============================================

%------------------------------get info------------------------------------
list_entries = get(handles.variables,'String');
index_selected = get(handles.variables,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
data=evalin('base',var_name);
%-------------make data with necessary field "x","y","z", and "value");
%Important note: in our convension, m*n*l matrix, 1st dimension is x
%                                                 2nd dimension is y
%                                                 3rd dimension is z
% *************BUT Matlab treat*********          1st dimension is y
%                                                 2nd dimension is x
%                                                 3rd dimension is z
%so then x-axis in matlab is 1:n, and y is 1:m, and z is 1:l

% if ~isfield(datav,'value') %to be able to use data.value later, so do this...
%     data.value=datav;
%     %data.x=[1:size(datav,1)];
%     %data.y=[1:size(datav,2)];
% else data=datav;
% end
% if ~isfield(datav,'x') %to be able to use data.value later, so do this...
%     data.x=[1:size(datav,1)];
% end
% if ~isfield(datav,'y') %to be able to use data.value later, so do this...
%     data.y=[1:size(datav,2)];
% end
% 
% if ~isfield(datav,'y') %to be able to use data.value later, so do this...
%     data.z=[1:size(datav,3)];
% end
% clear datav;
%---convert our converntion to Matlab convention...
for i=1:size(data.value,3)
    tmp=transpose(reshape(data.value(:,:,i),size(data.value,1),size(data.value,2)));
    datav(:,:,i)=tmp;
end
data.value=datav;
clear datav;
%---end of conversion

%------------end of making data--------
xi=str2num(get(handles.x_edit,'String'));
yi=str2num(get(handles.y_edit,'String'));
zi=str2num(get(handles.z_edit,'String'));
index_v=get(handles.index,'Value');
if index_v==1  %if x,y& z are index, convert index to real scale
    x_v=data.x(xi);
    y_v=data.y(yi);
    z_v=data.z(zi);
else
    x_v=xi;
    y_v=yi;
    z_v=zi;
end
notch_facingv=get(handles.notch_facing_pop,'Value'); % 1 means a, 2 means b, etc.
figure_no=str2num(get(handles.figure_edit,'String'));
%-----------------------------end of getting info--------------------------

%-----------------------------Plot-----------------------------------------
if strcmp(get(handles.x_max,'String'),'Max')
    xmax=max(data.x);
else
    xmax=str2num(get(handles.x_max,'String'));
end
if strcmp(get(handles.x_min,'String'),'Min')
    xmin=min(data.x);
else
    xmin=str2num(get(handles.x_min,'String'));
end
if strcmp(get(handles.x_no1,'String'),'Auto')
    xstep=data.x(2)-data.x(1);
else
    xstep=(xmax-xmin)/str2num(get(handles.x_no1,'String'));
end

%------above make x max & min & x_step-------
if strcmp(get(handles.y_max,'String'),'Max')
    ymax=max(data.y);
else
    ymax=str2num(get(handles.y_max,'String'));
end
if strcmp(get(handles.y_min,'String'),'Min')
    ymin=min(data.y);
else
    ymin=str2num(get(handles.y_min,'String'));
end
if strcmp(get(handles.y_no1,'String'),'Auto')
    ystep=data.y(2)-data.y(1);
else
    ystep=(ymax-ymin)/str2num(get(handles.y_no1,'String'));
end
%------above make y max & min & y_step-------
if strcmp(get(handles.z_max,'String'),'Max')
    zmax=max(data.z);
else
    zmax=str2num(get(handles.z_max,'String'));
end
if strcmp(get(handles.z_min,'String'),'Min')
    zmin=min(data.z);
else
    zmin=str2num(get(handles.z_min,'String'));
end
if strcmp(get(handles.z_no1,'String'),'Auto')
    zstep=data.z(2)-data.z(1);
else
    zstep=(zmax-zmin)/str2num(get(handles.z_no1,'String'));
end
%------above make z max & min & z_step-------

figure(figure_no);

switch notch_facingv
    case 1 %means facing "a"
        xb=xmin; xe=x_v; yb=ymin; ye=y_v; zbe=z_v; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep); %xb=xbegin, xe=xend, etc.
        [xd1,yd1]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd1=xd1'; yd1=yd1';
        zd1=zbe*ones(x_no,y_no);
        
        xb=x_v; xe=xmax; yb=ymin; ye=y_v; zbe=zmin; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd11,yd11]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd11=xd11'; yd11=yd11';
        zd11=zbe*ones(x_no,y_no);
        
        xb=xmin; xe=xmax; yb=y_v; ye=ymax; zbe=zmin; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd12,yd12]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd12=xd12'; yd12=yd12';
        zd12=zbe*ones(x_no,y_no);
        %-----1st surface above
        
        xb=xmin; xe=x_v; zb=zmin; ze=z_v; ybe=y_v; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd2,zd2]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd2=xd2'; zd2=zd2';
        yd2=ybe*ones(x_no,z_no);
        
        xb=x_v; xe=xmax; zb=zmin; ze=z_v; ybe=ymin; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd21,zd21]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd21=xd21'; zd21=zd21';
        yd21=ybe*ones(x_no,z_no);
        
        xb=xmin; xe=xmax; zb=z_v; ze=zmax; ybe=ymin; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd22,zd22]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd22=xd22'; zd22=zd22';
        yd22=ybe*ones(x_no,z_no);
        
        
        %-----2nd surface above
        yb=ymin; ye=y_v; zb=zmin; ze=z_v; xbe=x_v; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd3,zd3]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd3=yd3'; zd3=zd3';
        xd3=xbe*ones(y_no,z_no);

        yb=y_v; ye=ymax; zb=zmin; ze=zmax; xbe=xmin; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd31,zd31]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd31=yd31'; zd31=zd31';
        xd31=xbe*ones(y_no,z_no);
        
        yb=ymin; ye=y_v; zb=z_v; ze=zmax; xbe=xmin; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd32,zd32]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd32=yd32'; zd32=zd32';
        xd32=xbe*ones(y_no,z_no);
        
        %----3 side surface unaffected by notch------------------------
        xd4=xmax*ones(y_no,z_no); [yd4,zd4]=meshgrid(linspace(ymin,ymax,y_no),linspace(zmin,zmax,z_no));yd4=yd4'; zd4=zd4';
        yd5=ymax*ones(x_no,z_no); [xd5,zd5]=meshgrid(linspace(xmin,xmax,x_no),linspace(zmin,zmax,z_no));xd5=xd5'; zd5=zd5';
        zd6=zmax*ones(x_no,y_no); [xd6,yd6]=meshgrid(linspace(xmin,xmax,x_no),linspace(ymin,ymax,y_no));xd6=xd6'; yd6=yd6';
        %slice(data.x,data.y,data.z,data.value,xmax,[],[]);
        %hold on;
        %slice(data.x,data.y,data.z,data.value,[],ymax,[]);
        %slice(data.x,data.y,data.z,data.value,[],[],zmax);
    
    case 2 %means facing "b"
        xb=x_v; xe=xmax; yb=ymin; ye=y_v; zbe=z_v; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep); %xb=xbegin, xe=xend, etc.
        [xd1,yd1]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd1=xd1'; yd1=yd1';
        zd1=zbe*ones(x_no,y_no);
        
        xb=x_v; xe=xmax; yb=y_v; ye=ymax; zbe=zmin; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd11,yd11]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd11=xd11'; yd11=yd11';
        zd11=zbe*ones(x_no,y_no);
        
        xb=xmin; xe=x_v; yb=ymin; ye=ymax; zbe=zmin; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd12,yd12]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd12=xd12'; yd12=yd12';
        zd12=zbe*ones(x_no,y_no);
        %-----1st surface above
        
        xb=x_v; xe=xmax; zb=zmin; ze=z_v; ybe=y_v; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd2,zd2]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd2=xd2'; zd2=zd2';
        yd2=ybe*ones(x_no,z_no);
        
        xb=x_v; xe=xmax; zb=z_v; ze=zmax; ybe=ymin; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd21,zd21]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd21=xd21'; zd21=zd21';
        yd21=ybe*ones(x_no,z_no);
        
        xb=xmin; xe=x_v; zb=zmin; ze=zmax; ybe=ymin; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd22,zd22]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd22=xd22'; zd22=zd22';
        yd22=ybe*ones(x_no,z_no);
        
        
        %-----2nd surface above
        yb=ymin; ye=y_v; zb=zmin; ze=z_v; xbe=x_v; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd3,zd3]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd3=yd3'; zd3=zd3';
        xd3=xbe*ones(y_no,z_no);

        yb=ymin; ye=y_v; zb=z_v; ze=zmax; xbe=xmax; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd31,zd31]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd31=yd31'; zd31=zd31';
        xd31=xbe*ones(y_no,z_no);
        
        yb=y_v; ye=ymax; zb=zmin; ze=zmax; xbe=xmax; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd32,zd32]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd32=yd32'; zd32=zd32';
        xd32=xbe*ones(y_no,z_no);
        
        %----3 side surface unaffected by notch------------------------
        %slice(data.x,data.y,data.z,data.value,xmin,[],[]);
        %hold on;
        %slice(data.x,data.y,data.z,data.value,[],ymax,[]);
        %slice(data.x,data.y,data.z,data.value,[],[],zmax);
        xd4=xmin*ones(y_no,z_no); [yd4,zd4]=meshgrid(linspace(ymin,ymax,y_no),linspace(zmin,zmax,z_no));yd4=yd4'; zd4=zd4';
        yd5=ymax*ones(x_no,z_no); [xd5,zd5]=meshgrid(linspace(xmin,xmax,x_no),linspace(zmin,zmax,z_no));xd5=xd5'; zd5=zd5';
        zd6=zmax*ones(x_no,y_no); [xd6,yd6]=meshgrid(linspace(xmin,xmax,x_no),linspace(ymin,ymax,y_no));xd6=xd6'; yd6=yd6';
        
    case 3 %means facing "c"
        xb=x_v; xe=xmax; yb=y_v; ye=ymax; zbe=z_v; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep); %xb=xbegin, xe=xend, etc.
        [xd1,yd1]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd1=xd1'; yd1=yd1';
        zd1=zbe*ones(x_no,y_no);
        
        xb=x_v; xe=xmax; yb=ymin; ye=y_v; zbe=zmin; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd11,yd11]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd11=xd11'; yd11=yd11';
        zd11=zbe*ones(x_no,y_no);
        
        xb=xmin; xe=x_v; yb=ymin; ye=ymax; zbe=zmin; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd12,yd12]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd12=xd12'; yd12=yd12';
        zd12=zbe*ones(x_no,y_no);
        %-----1st surface above
        
        xb=x_v; xe=xmax; zb=zmin; ze=z_v; ybe=y_v; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd2,zd2]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd2=xd2'; zd2=zd2';
        yd2=ybe*ones(x_no,z_no);
        
        xb=x_v; xe=xmax; zb=z_v; ze=zmax; ybe=ymax; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd21,zd21]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd21=xd21'; zd21=zd21';
        yd21=ybe*ones(x_no,z_no);
        
        xb=xmin; xe=x_v; zb=zmin; ze=zmax; ybe=ymax; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd22,zd22]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd22=xd22'; zd22=zd22';
        yd22=ybe*ones(x_no,z_no);
        %-----2nd surface above
        
        yb=y_v; ye=ymax; zb=zmin; ze=z_v; xbe=x_v; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd3,zd3]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd3=yd3'; zd3=zd3';
        xd3=xbe*ones(y_no,z_no);

        yb=y_v; ye=ymax; zb=z_v; ze=zmax; xbe=xmax; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd31,zd31]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd31=yd31'; zd31=zd31';
        xd31=xbe*ones(y_no,z_no);
        
        yb=ymin; ye=y_v; zb=zmin; ze=zmax; xbe=xmax; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd32,zd32]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd32=yd32'; zd32=zd32';
        xd32=xbe*ones(y_no,z_no);
        %----3 side surface unaffected by notch------------------------
        %slice(data.x,data.y,data.z,data.value,xmin,[],[]);
        %hold on;
        %slice(data.x,data.y,data.z,data.value,[],ymin,[]);
        %slice(data.x,data.y,data.z,data.value,[],[],zmax);
        xd4=xmin*ones(y_no,z_no); [yd4,zd4]=meshgrid(linspace(ymin,ymax,y_no),linspace(zmin,zmax,z_no));yd4=yd4'; zd4=zd4';
        yd5=ymin*ones(x_no,z_no); [xd5,zd5]=meshgrid(linspace(xmin,xmax,x_no),linspace(zmin,zmax,z_no));xd5=xd5'; zd5=zd5';
        zd6=zmax*ones(x_no,y_no); [xd6,yd6]=meshgrid(linspace(xmin,xmax,x_no),linspace(ymin,ymax,y_no));xd6=xd6'; yd6=yd6';

        
    case 4 %means facing "d"
        xb=xmin; xe=x_v; yb=y_v; ye=ymax; zbe=z_v; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep); %xb=xbegin, xe=xend, etc.
        [xd1,yd1]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd1=xd1'; yd1=yd1';
        zd1=zbe*ones(x_no,y_no);
        
        xb=xmin; xe=x_v; yb=ymin; ye=y_v; zbe=zmin; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd11,yd11]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd11=xd11'; yd11=yd11';
        zd11=zbe*ones(x_no,y_no);
        
        xb=x_v; xe=xmax; yb=ymin; ye=ymax; zbe=zmin; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd12,yd12]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd12=xd12'; yd12=yd12';
        zd12=zbe*ones(x_no,y_no);
        %-----1st surface above
        
        xb=xmin; xe=x_v; zb=zmin; ze=z_v; ybe=y_v; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd2,zd2]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd2=xd2'; zd2=zd2';
        yd2=ybe*ones(x_no,z_no);
        
        xb=xmin; xe=x_v; zb=z_v; ze=zmax; ybe=ymax; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd21,zd21]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd21=xd21'; zd21=zd21';
        yd21=ybe*ones(x_no,z_no);
        
        xb=x_v; xe=xmax; zb=zmin; ze=zmax; ybe=ymax; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd22,zd22]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd22=xd22'; zd22=zd22';
        yd22=ybe*ones(x_no,z_no);
        %-----2nd surface above
        
        yb=y_v; ye=ymax; zb=zmin; ze=z_v; xbe=x_v; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd3,zd3]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd3=yd3'; zd3=zd3';
        xd3=xbe*ones(y_no,z_no);

        yb=y_v; ye=ymax; zb=z_v; ze=zmax; xbe=xmin; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd31,zd31]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd31=yd31'; zd31=zd31';
        xd31=xbe*ones(y_no,z_no);
        
        yb=ymin; ye=y_v; zb=zmin; ze=zmax; xbe=xmin; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd32,zd32]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd32=yd32'; zd32=zd32';
        xd32=xbe*ones(y_no,z_no);
        %----3 side surface unaffected by notch------------------------
        %slice(data.x,data.y,data.z,data.value,xmax,[],[]);
        %hold on;
        %slice(data.x,data.y,data.z,data.value,[],ymin,[]);
        %slice(data.x,data.y,data.z,data.value,[],[],zmax);
        xd4=xmax*ones(y_no,z_no); [yd4,zd4]=meshgrid(linspace(ymin,ymax,y_no),linspace(zmin,zmax,z_no));yd4=yd4'; zd4=zd4';
        yd5=ymin*ones(x_no,z_no); [xd5,zd5]=meshgrid(linspace(xmin,xmax,x_no),linspace(zmin,zmax,z_no));xd5=xd5'; zd5=zd5';
        zd6=zmax*ones(x_no,y_no); [xd6,yd6]=meshgrid(linspace(xmin,xmax,x_no),linspace(ymin,ymax,y_no));xd6=xd6'; yd6=yd6';

        
        
    case 5 %means facing "e"
        xb=xmin; xe=x_v; yb=ymin; ye=y_v; zbe=z_v; %xb=xbegin, xe=xend, etc.
        x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd1,yd1]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd1=xd1'; yd1=yd1';
        zd1=zbe*ones(x_no,y_no);
        
        xb=x_v; xe=xmax; yb=ymin; ye=y_v; zbe=zmax; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd11,yd11]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd11=xd11'; yd11=yd11';
        zd11=zbe*ones(x_no,y_no);
        
        xb=xmin; xe=xmax; yb=y_v; ye=ymax; zbe=zmax; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd12,yd12]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd12=xd12'; yd12=yd12';
        zd12=zbe*ones(x_no,y_no);
        %-----1st surface above
        
        xb=xmin; xe=x_v; zb=z_v; ze=zmax; ybe=y_v; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd2,zd2]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd2=xd2'; zd2=zd2';
        yd2=ybe*ones(x_no,z_no);
        
        xb=x_v; xe=xmax; zb=z_v; ze=zmax; ybe=ymin; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd21,zd21]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd21=xd21'; zd21=zd21';
        yd21=ybe*ones(x_no,z_no);
        
        xb=xmin; xe=xmax; zb=zmin; ze=z_v; ybe=ymin; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd22,zd22]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd22=xd22'; zd22=zd22';
        yd22=ybe*ones(x_no,z_no);
        
        
        %-----2nd surface above
        yb=ymin; ye=y_v; zb=z_v; ze=zmax; xbe=x_v; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd3,zd3]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd3=yd3'; zd3=zd3';
        xd3=xbe*ones(y_no,z_no);

        yb=y_v; ye=ymax; zb=z_v; ze=zmax; xbe=xmin; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd31,zd31]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd31=yd31'; zd31=zd31';
        xd31=xbe*ones(y_no,z_no);
        
        yb=ymin; ye=ymax; zb=zmin; ze=z_v; xbe=xmin; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd32,zd32]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd32=yd32'; zd32=zd32';
        xd32=xbe*ones(y_no,z_no);
        
        %----3 side surface unaffected by notch------------------------
        %slice(data.x,data.y,data.z,data.value,xmax,[],[]);
        %hold on;
        %slice(data.x,data.y,data.z,data.value,[],ymax,[]);
        %slice(data.x,data.y,data.z,data.value,[],[],zmin);
        xd4=xmax*ones(y_no,z_no); [yd4,zd4]=meshgrid(linspace(ymin,ymax,y_no),linspace(zmin,zmax,z_no));yd4=yd4'; zd4=zd4';
        yd5=ymax*ones(x_no,z_no); [xd5,zd5]=meshgrid(linspace(xmin,xmax,x_no),linspace(zmin,zmax,z_no));xd5=xd5'; zd5=zd5';
        zd6=zmin*ones(x_no,y_no); [xd6,yd6]=meshgrid(linspace(xmin,xmax,x_no),linspace(ymin,ymax,y_no));xd6=xd6'; yd6=yd6';
        
        
    case 6 %means facing "f"
        xb=x_v; xe=xmax; yb=ymin; ye=y_v; zbe=z_v; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep); %xb=xbegin, xe=xend, etc.
        [xd1,yd1]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd1=xd1'; yd1=yd1';
        zd1=zbe*ones(x_no,y_no);
        
        xb=x_v; xe=xmax; yb=y_v; ye=ymax; zbe=zmax; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd11,yd11]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd11=xd11'; yd11=yd11';
        zd11=zbe*ones(x_no,y_no);
        
        xb=xmin; xe=x_v; yb=ymin; ye=ymax; zbe=zmax; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd12,yd12]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd12=xd12'; yd12=yd12';
        zd12=zbe*ones(x_no,y_no);
        %-----1st surface above
        
        xb=x_v; xe=xmax; zb=z_v; ze=zmax; ybe=y_v; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd2,zd2]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd2=xd2'; zd2=zd2';
        yd2=ybe*ones(x_no,z_no);
        
        xb=x_v; xe=xmax; zb=zmin; ze=z_v; ybe=ymin; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd21,zd21]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd21=xd21'; zd21=zd21';
        yd21=ybe*ones(x_no,z_no);
        
        xb=xmin; xe=x_v; zb=zmin; ze=zmax; ybe=ymin; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd22,zd22]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd22=xd22'; zd22=zd22';
        yd22=ybe*ones(x_no,z_no);
        
        
        %-----2nd surface above
        yb=ymin; ye=y_v; zb=z_v; ze=zmax; xbe=x_v; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd3,zd3]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd3=yd3'; zd3=zd3';
        xd3=xbe*ones(y_no,z_no);

        yb=ymin; ye=y_v; zb=zmin; ze=z_v; xbe=xmax; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd31,zd31]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd31=yd31'; zd31=zd31';
        xd31=xbe*ones(y_no,z_no);
        
        yb=y_v; ye=ymax; zb=zmin; ze=zmax; xbe=xmax; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd32,zd32]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd32=yd32'; zd32=zd32';
        xd32=xbe*ones(y_no,z_no);
        
        %----3 side surface unaffected by notch------------------------
        %slice(data.x,data.y,data.z,data.value,xmin,[],[]);
        %hold on;
        %slice(data.x,data.y,data.z,data.value,[],ymax,[]);
        %slice(data.x,data.y,data.z,data.value,[],[],zmin);
        xd4=xmin*ones(y_no,z_no); [yd4,zd4]=meshgrid(linspace(ymin,ymax,y_no),linspace(zmin,zmax,z_no));yd4=yd4'; zd4=zd4';
        yd5=ymax*ones(x_no,z_no); [xd5,zd5]=meshgrid(linspace(xmin,xmax,x_no),linspace(zmin,zmax,z_no));xd5=xd5'; zd5=zd5';
        zd6=zmin*ones(x_no,y_no); [xd6,yd6]=meshgrid(linspace(xmin,xmax,x_no),linspace(ymin,ymax,y_no));xd6=xd6'; yd6=yd6';
        
    case 7 %means facing "g"
        xb=x_v; xe=xmax; yb=y_v; ye=ymax; zbe=z_v; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep); %xb=xbegin, xe=xend, etc.
        [xd1,yd1]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd1=xd1'; yd1=yd1';
        zd1=zbe*ones(x_no,y_no);
        
        xb=x_v; xe=xmax; yb=ymin; ye=y_v; zbe=zmax; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd11,yd11]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd11=xd11'; yd11=yd11';
        zd11=zbe*ones(x_no,y_no);
        
        xb=xmin; xe=x_v; yb=ymin; ye=ymax; zbe=zmax; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd12,yd12]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd12=xd12'; yd12=yd12';
        zd12=zbe*ones(x_no,y_no);
        %-----1st surface above
        
        xb=x_v; xe=xmax; zb=z_v; ze=zmax; ybe=y_v; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd2,zd2]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd2=xd2'; zd2=zd2';
        yd2=ybe*ones(x_no,z_no);
        
        xb=x_v; xe=xmax; zb=zmin; ze=z_v; ybe=ymax; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd21,zd21]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd21=xd21'; zd21=zd21';
        yd21=ybe*ones(x_no,z_no);
        
        xb=xmin; xe=x_v; zb=zmin; ze=zmax; ybe=ymax; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd22,zd22]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd22=xd22'; zd22=zd22';
        yd22=ybe*ones(x_no,z_no);       
        %-----2nd surface above
        
        yb=y_v; ye=ymax; zb=z_v; ze=zmax; xbe=x_v; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd3,zd3]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd3=yd3'; zd3=zd3';
        xd3=xbe*ones(y_no,z_no);

        yb=y_v; ye=ymax; zb=zmin; ze=z_v; xbe=xmax; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd31,zd31]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd31=yd31'; zd31=zd31';
        xd31=xbe*ones(y_no,z_no);
        
        yb=ymin; ye=y_v; zb=zmin; ze=zmax; xbe=xmax; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd32,zd32]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd32=yd32'; zd32=zd32';
        xd32=xbe*ones(y_no,z_no);
        
        %----3 side surface unaffected by notch------------------------
        %slice(data.x,data.y,data.z,data.value,xmin,[],[]);
        %hold on;
        %slice(data.x,data.y,data.z,data.value,[],ymin,[]);
        %slice(data.x,data.y,data.z,data.value,[],[],zmin);
        xd4=xmin*ones(y_no,z_no); [yd4,zd4]=meshgrid(linspace(ymin,ymax,y_no),linspace(zmin,zmax,z_no));yd4=yd4'; zd4=zd4';
        yd5=ymin*ones(x_no,z_no); [xd5,zd5]=meshgrid(linspace(xmin,xmax,x_no),linspace(zmin,zmax,z_no));xd5=xd5'; zd5=zd5';
        zd6=zmin*ones(x_no,y_no); [xd6,yd6]=meshgrid(linspace(xmin,xmax,x_no),linspace(ymin,ymax,y_no));xd6=xd6'; yd6=yd6';
        
        
    case 8 %means facing "h"
        xb=xmin; xe=x_v; yb=y_v; ye=ymax; zbe=z_v; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep); %xb=xbegin, xe=xend, etc.
        [xd1,yd1]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd1=xd1'; yd1=yd1';
        zd1=zbe*ones(x_no,y_no);
        
        xb=xmin; xe=x_v; yb=ymin; ye=y_v; zbe=zmax; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd11,yd11]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd11=xd11'; yd11=yd11';
        zd11=zbe*ones(x_no,y_no);
        
        xb=x_v; xe=xmax; yb=ymin; ye=ymax; zbe=zmax; x_no=round((xe-xb)/xstep); y_no=round((ye-yb)/ystep);
        [xd12,yd12]=meshgrid(linspace(xb,xe,x_no),linspace(yb,ye,y_no));
        xd12=xd12'; yd12=yd12';
        zd12=zbe*ones(x_no,y_no);
        %-----1st surface above
        
        xb=xmin; xe=x_v; zb=z_v; ze=zmax; ybe=y_v; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd2,zd2]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd2=xd2'; zd2=zd2';
        yd2=ybe*ones(x_no,z_no);
        
        xb=xmin; xe=x_v; zb=zmin; ze=z_v; ybe=ymax; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd21,zd21]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd21=xd21'; zd21=zd21';
        yd21=ybe*ones(x_no,z_no);
        
        xb=x_v; xe=xmax; zb=zmin; ze=zmax; ybe=ymax; x_no=round((xe-xb)/xstep); z_no=round((ze-zb)/zstep);
        [xd22,zd22]=meshgrid(linspace(xb,xe,x_no),linspace(zb,ze,z_no));
        xd22=xd22'; zd22=zd22';
        yd22=ybe*ones(x_no,z_no);       
        %-----2nd surface above
        
        yb=y_v; ye=ymax; zb=z_v; ze=zmax; xbe=x_v; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd3,zd3]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd3=yd3'; zd3=zd3';
        xd3=xbe*ones(y_no,z_no);

        yb=y_v; ye=ymax; zb=zmin; ze=z_v; xbe=xmin; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd31,zd31]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd31=yd31'; zd31=zd31';
        xd31=xbe*ones(y_no,z_no);
        
        yb=ymin; ye=y_v; zb=zmin; ze=zmax; xbe=xmin; y_no=round((ye-yb)/ystep); z_no=round((ze-zb)/zstep);
        [yd32,zd32]=meshgrid(linspace(yb,ye,y_no),linspace(zb,ze,z_no));
        yd32=yd32'; zd32=zd32';
        xd32=xbe*ones(y_no,z_no);
        
        %----3 side surface unaffected by notch------------------------
        %slice(data.x,data.y,data.z,data.value,xmax,[],[]);
        %hold on;
        %slice(data.x,data.y,data.z,data.value,[],ymin,[]);
        %slice(data.x,data.y,data.z,data.value,[],[],zmin);
        xd4=xmax*ones(y_no,z_no); [yd4,zd4]=meshgrid(linspace(ymin,ymax,y_no),linspace(zmin,zmax,z_no));yd4=yd4'; zd4=zd4';
        yd5=ymin*ones(x_no,z_no); [xd5,zd5]=meshgrid(linspace(xmin,xmax,x_no),linspace(zmin,zmax,z_no));xd5=xd5'; zd5=zd5';
        zd6=zmin*ones(x_no,y_no); [xd6,yd6]=meshgrid(linspace(xmin,xmax,x_no),linspace(ymin,ymax,y_no));xd6=xd6'; yd6=yd6';
        
end

slice(data.x,data.y,data.z,data.value,xd4,yd4,zd4);
hold on;
slice(data.x,data.y,data.z,data.value,xd5,yd5,zd5);
slice(data.x,data.y,data.z,data.value,xd6,yd6,zd6);

slice(data.x,data.y,data.z,data.value,xd1,yd1,zd1);
slice(data.x,data.y,data.z,data.value,xd11,yd11,zd11);
slice(data.x,data.y,data.z,data.value,xd12,yd12,zd12);

slice(data.x,data.y,data.z,data.value,xd2,yd2,zd2);
slice(data.x,data.y,data.z,data.value,xd21,yd21,zd21);
slice(data.x,data.y,data.z,data.value,xd22,yd22,zd22);

slice(data.x,data.y,data.z,data.value,xd3,yd3,zd3);
slice(data.x,data.y,data.z,data.value,xd31,yd31,zd31);
slice(data.x,data.y,data.z,data.value,xd32,yd32,zd32);

hold off;
shading flat
colormap(flipud(gray));
%-----------------------------end of plot----------------------------------
%-----Make Plot options-------------------------------
if get(handles.shade_interp,'Value')==1
    shading interp
end

if get(handles.axis_equal,'Value')==1
    axis equal;
end
%==========================================================================


%========================end===============================================


% --- Executes on button press in geometry_example.
function geometry_example_Callback(hObject, eventdata, handles)
% hObject    handle to geometry_example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure;

plot3([0,1],[0,0],[0,0]);
hold on;
plot3([0,1],[1,1],[0,0],'-.');
plot3([0,1],[0,0],[1,1]);
plot3([0,1],[1,1],[1,1]);

plot3([0,0],[0,1],[0,0]);
plot3([1,1],[0,1],[0,0],'-.');
plot3([0,0],[0,1],[1,1]);
plot3([1,1],[0,1],[1,1]);

plot3([0,0],[0,0],[0,1]);
plot3([1,1],[0,0],[0,1]);
plot3([0,0],[1,1],[0,1]);
plot3([1,1],[1,1],[0,1],'-.');

xlabel('x');
ylabel('y');
zlabel('z');

text(0.1,0.1,0,'a');
text(0.9,0.1,0,'b');
text(0.9,0.9,0,'c');
text(0.1,0.9,0,'d');
text(0.1,0.1,1,'e');
text(0.9,0.1,1,'f');
text(0.9,0.9,1,'g');
text(0.1,0.9,1,'h');

daspect([1,1,1]);

%------------------
plot3([0,0.3],[0,0],[0,0]);
plot3([0,0.3],[0.3,0.3],[0,0],'-.');
plot3([0,0.3],[0,0],[0.3,0.3]);
plot3([0,0.3],[0.3,0.3],[0.3,0.3],'-.');

plot3([0,0],[0,0.3],[0,0]);
plot3([0.3,0.3],[0,0.3],[0,0],'-.');
plot3([0,0],[0,0.3],[0.3,0.3]);
plot3([0.3,0.3],[0,0.3],[0.3,0.3],'-.');

plot3([0,0],[0,0],[0,0.3]);
plot3([0.3,0.3],[0,0],[0,0.3]);
plot3([0,0],[0.3,0.3],[0,0.3]);
plot3([0.3,0.3],[0.3,0.3],[0,0.3],'-.');

text(0.32,0.32,0.32,'i');
title('Example: Notch origin is at point "i", facing "a"');
%------------------

hold off;



function figure_edit_Callback(hObject, eventdata, handles)
% hObject    handle to figure_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figure_edit as text
%        str2double(get(hObject,'String')) returns contents of figure_edit as a double


% --- Executes during object creation, after setting all properties.
function figure_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in figure_dec.
function figure_dec_Callback(hObject, eventdata, handles)
% hObject    handle to figure_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure_valuev=str2num(get(handles.figure_edit,'String'));
set(handles.figure_edit,'String', num2str(figure_valuev-1));

% --- Executes on button press in figure_inc.
function figure_inc_Callback(hObject, eventdata, handles)
% hObject    handle to figure_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure_valuev=str2num(get(handles.figure_edit,'String'));
set(handles.figure_edit,'String', num2str(figure_valuev+1));




function x_min_Callback(hObject, eventdata, handles)
% hObject    handle to x_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_min as text
%        str2double(get(hObject,'String')) returns contents of x_min as a double


% --- Executes during object creation, after setting all properties.
function x_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_max_Callback(hObject, eventdata, handles)
% hObject    handle to x_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_max as text
%        str2double(get(hObject,'String')) returns contents of x_max as a double


% --- Executes during object creation, after setting all properties.
function x_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_min_Callback(hObject, eventdata, handles)
% hObject    handle to y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_min as text
%        str2double(get(hObject,'String')) returns contents of y_min as a double


% --- Executes during object creation, after setting all properties.
function y_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_max_Callback(hObject, eventdata, handles)
% hObject    handle to y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_max as text
%        str2double(get(hObject,'String')) returns contents of y_max as a double


% --- Executes during object creation, after setting all properties.
function y_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function z_min_Callback(hObject, eventdata, handles)
% hObject    handle to z_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_min as text
%        str2double(get(hObject,'String')) returns contents of z_min as a double


% --- Executes during object creation, after setting all properties.
function z_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function z_max_Callback(hObject, eventdata, handles)
% hObject    handle to z_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_max as text
%        str2double(get(hObject,'String')) returns contents of z_max as a double


% --- Executes during object creation, after setting all properties.
function z_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_no1_Callback(hObject, eventdata, handles)
% hObject    handle to x_no1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_no1 as text
%        str2double(get(hObject,'String')) returns contents of x_no1 as a double


% --- Executes during object creation, after setting all properties.
function x_no1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_no1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_no1_Callback(hObject, eventdata, handles)
% hObject    handle to y_no1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_no1 as text
%        str2double(get(hObject,'String')) returns contents of y_no1 as a double


% --- Executes during object creation, after setting all properties.
function y_no1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_no1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function z_no1_Callback(hObject, eventdata, handles)
% hObject    handle to z_no1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_no1 as text
%        str2double(get(hObject,'String')) returns contents of z_no1 as a double


% --- Executes during object creation, after setting all properties.
function z_no1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_no1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in shade_interp.
function shade_interp_Callback(hObject, eventdata, handles)
% hObject    handle to shade_interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of shade_interp


% --- Executes on button press in axis_equal.
function axis_equal_Callback(hObject, eventdata, handles)
% hObject    handle to axis_equal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of axis_equal


% --- Executes on button press in slice_x_y_z.
function slice_x_y_z_Callback(hObject, eventdata, handles)
% hObject    handle to slice_x_y_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%------------------------------get info------------------------------------
list_entries = get(handles.variables,'String');
index_selected = get(handles.variables,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
%-------------make data with necessary field "x","y","z", and "value");
%Important note: in our convension, m*n*l matrix, 1st dimension is x
%                                                 2nd dimension is y
%                                                 3rd dimension is z
% *************BUT Matlab treat*********          1st dimension is y
%                                                 2nd dimension is x
%                                                 3rd dimension is z
%so then x-axis in matlab is 1:n, and y is 1:m, and z is 1:l

if ~isfield(datav,'value') %to be able to use data.value later, so do this...
    data.value=datav;
    %data.x=[1:size(datav,1)];
    %data.y=[1:size(datav,2)];
else data=datav;
end

if ~isfield(datav,'x') %to be able to use data.value later, so do this...
    data.x=[1:size(datav,1)];
end
if ~isfield(datav,'y') %to be able to use data.value later, so do this...
    data.y=[1:size(datav,2)];
end

if ~isfield(datav,'y') %to be able to use data.value later, so do this...
    data.z=[1:size(datav,3)];
end
clear datav;
%---convert our converntion to Matlab convention...
for i=1:size(data.value,3);
    tmp=transpose(reshape(data.value(:,:,i),size(data.value,1),size(data.value,2)));
    datav(:,:,i)=tmp;
end
data.value=datav;
clear datav;
%---end of conversion

%------------end of making data--------

if ~strcmp(get(handles.x_edit,'String'),'N')
    xi=str2num(get(handles.x_edit,'String'));
else
    xi=[];
end

if ~strcmp(get(handles.y_edit,'String'),'N')
    yi=str2num(get(handles.y_edit,'String'));
else
    yi=[];
end

if ~strcmp(get(handles.z_edit,'String'),'N')
    zi=str2num(get(handles.z_edit,'String'));
else
    zi=[];
end

index_v=get(handles.index,'Value');
if index_v==1  %if x,y& z are index, convert index to real scale
    if ~strcmp(get(handles.x_edit,'String'),'N')
        x_v=data.x(xi);
    else
        x_v=[];
    end
    if ~strcmp(get(handles.y_edit,'String'),'N')
        y_v=data.y(yi);
    else
        y_v=[];
    end
    if ~strcmp(get(handles.z_edit,'String'),'N')
        z_v=data.z(zi);
    else
        z_v=[];
    end
else
    x_v=xi;
    y_v=yi;
    z_v=zi;
end
figure_no=str2num(get(handles.figure_edit,'String'));
%-----------------------------end of getting info-----
figure(figure_no);
slice(data.x, data.y, data.z,data.value,x_v,y_v,z_v);

%-----Make Plot options-------------------------------
if get(handles.shade_interp,'Value')==1
    shading interp
end

if get(handles.axis_equal,'Value')==1
    axis equal;
end



% --- Executes on button press in x_n.
function x_n_Callback(hObject, eventdata, handles)
% hObject    handle to x_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in y_N.
set(handles.x_edit,'String','N');


% --- Executes on button press in z_n.
function z_n_Callback(hObject, eventdata, handles)
% hObject    handle to z_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.z_edit,'String','N');

% --- Executes on button press in y_n.
function y_n_Callback(hObject, eventdata, handles)
% hObject    handle to y_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.y_edit,'String','N');



% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%----------------------
set(handles.x_min,'String','Min');
set(handles.x_max,'String','Max');
set(handles.x_no1,'String','Auto');
set(handles.y_min,'String','Min');
set(handles.y_max,'String','Max');
set(handles.y_no1,'String','Auto');
set(handles.z_min,'String','Min');
set(handles.z_max,'String','Max');
set(handles.z_no1,'String','Auto');
%----------------------

