function varargout = symmetrization_gpu_yiwei(varargin)
% SYMMETRIZATION_GPU_YIWEI MATLAB code for symmetrization_gpu_yiwei.fig
%      SYMMETRIZATION_GPU_YIWEI, by itself, creates a new SYMMETRIZATION_GPU_YIWEI or raises the existing
%      singleton*.
%
%      H = SYMMETRIZATION_GPU_YIWEI returns the handle to a new SYMMETRIZATION_GPU_YIWEI or the handle to
%      the existing singleton*.
%
%      SYMMETRIZATION_GPU_YIWEI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYMMETRIZATION_GPU_YIWEI.M with the given input arguments.
%
%      SYMMETRIZATION_GPU_YIWEI('Property','Value',...) creates a new SYMMETRIZATION_GPU_YIWEI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before symmetrization_gpu_yiwei_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to symmetrization_gpu_yiwei_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help symmetrization_gpu_yiwei

% Last Modified by GUIDE v2.5 12-May-2016 19:46:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @symmetrization_gpu_yiwei_OpeningFcn, ...
                   'gui_OutputFcn',  @symmetrization_gpu_yiwei_OutputFcn, ...
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


% --- Executes just before symmetrization_gpu_yiwei is made visible.
function symmetrization_gpu_yiwei_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to symmetrization_gpu_yiwei (see VARARGIN)

% Choose default command line output for symmetrization_gpu_yiwei
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes symmetrization_gpu_yiwei wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.radiobutton_Rotation,'Value',1);
set(handles.radiobutton_Mirror,'Value',0);
set(handles.radiobutton_Translation,'Value',0);
set(handles.uipanel_Rotational_Symmetrization,'Visible','On');
set(handles.uipanel_Translation_Symmetrization,'Visible','Off');
set(handles.uipanel_Mirror_Symmetrization,'Visible','Off');
set(handles.edit_Translation_x,'String','0');
set(handles.edit_Translation_y,'String','0');
set(handles.radiobutton_Rotation_GPU,'Value',1);
set(handles.edit_Mirror_x,'String','0');
set(handles.edit_Mirror_y,'String','0');
set(handles.radiobutton_Mirror_x,'Value',1);
set(handles.radiobutton_Mirror_y,'Value',1);
set(handles.radiobutton_Mirror_mask_x,'Value',1);
set(handles.radiobutton_Mirror_mask_y,'Value',1);
set(handles.popupmenu_Rotation_Symmetry_Fold,'Value',4);

vars=evalin('base','who');
set(handles.listbox_Mirror,'String',vars);
set(handles.listbox_Translation,'String',vars);
set(handles.Rotation_listbox,'String',vars);

% --- Outputs from this function are returned to the command line.
function varargout = symmetrization_gpu_yiwei_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton_Rotation.
function radiobutton_Rotation_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Rotation

if get(hObject,'Value')
    set(handles.radiobutton_Mirror,'Value',0);
    set(handles.radiobutton_Translation,'Value',0);
    set(handles.uipanel_Rotational_Symmetrization,'Visible','On');
    set(handles.uipanel_Translation_Symmetrization,'Visible','Off');
    set(handles.uipanel_Mirror_Symmetrization,'Visible','Off');
end


% --- Executes on button press in radiobutton_Mirror.
function radiobutton_Mirror_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Mirror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Mirror
if get(hObject,'Value')
    set(handles.radiobutton_Rotation,'Value',0);
    set(handles.radiobutton_Translation,'Value',0);
    set(handles.uipanel_Rotational_Symmetrization,'Visible','Off');
    set(handles.uipanel_Translation_Symmetrization,'Visible','Off');
    set(handles.uipanel_Mirror_Symmetrization,'Visible','On');
end


% --- Executes on button press in radiobutton_Translation.
function radiobutton_Translation_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Translation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Translation
if get(hObject,'Value')
    set(handles.radiobutton_Rotation,'Value',0);
    set(handles.radiobutton_Mirror,'Value',0);
    set(handles.uipanel_Rotational_Symmetrization,'Visible','Off');
    set(handles.uipanel_Translation_Symmetrization,'Visible','On');
    set(handles.uipanel_Mirror_Symmetrization,'Visible','Off');
end


% --- Executes on selection change in Rotation_listbox.
function Rotation_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to Rotation_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Rotation_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Rotation_listbox
vars=evalin('base','who');
set(handles.Rotation_listbox,'String',vars);
list_entries = get(handles.Rotation_listbox,'String');
index_selected = get(handles.Rotation_listbox,'Value');
try
    var_name = list_entries{index_selected(1)};
catch
    var_name=list_entries{end};
    set(handles.Rotation_listbox,'Value',length(list_entries));
end

datav=evalin('base',var_name);

if ~isfield(datav,'x')||~isfield(datav,'value')
    errordlg('Data must contain fields "x" and "value"','Data Format Error');
    return
end

%---initialzie main panel----%
set(handles.radiobutton_Rotation,'Value',1);
set(handles.radiobutton_Mirror,'Value',0);
set(handles.radiobutton_Translation,'Value',0);

%---initialize Mask Panel----%
set(handles.radiobutton_Rotation_rect_mask,'Value',1);
set(handles.edit_Rotation_x_from,'String',num2str(datav.x(1)));
set(handles.edit_Rotation_y_from,'String',num2str(datav.y(1)));
set(handles.edit_Rotation_x_to,'String',num2str(datav.x(end)));
set(handles.edit_Rotation_y_to,'String',num2str(datav.y(end)));
set(handles.radiobutton_Rotation_sector_mask,'Value',0);
set(handles.edit_Rotation_phi_from,'String','0');
set(handles.edit_Rotation_phi_to,'String','360');

%---initialize Symmetry Fold---%
set(handles.popupmenu_Rotation_Symmetry_Fold,'Value',4);

%---initialize Origin----%
set(handles.edit_Rotation_x,'String','0');
set(handles.edit_Rotation_y,'String','0');

%---initialize GPU----%
set(handles.radiobutton_Rotation_GPU,'Value',1);



% --- Executes during object creation, after setting all properties.
function Rotation_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rotation_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: Rotation_listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Rotation_Symmetry_Fold.
function popupmenu_Rotation_Symmetry_Fold_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Rotation_Symmetry_Fold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Rotation_Symmetry_Fold contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Rotation_Symmetry_Fold


% --- Executes during object creation, after setting all properties.
function popupmenu_Rotation_Symmetry_Fold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Rotation_Symmetry_Fold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Rotation_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Rotation_x as text
%        str2double(get(hObject,'String')) returns contents of edit_Rotation_x as a double


% --- Executes during object creation, after setting all properties.
function edit_Rotation_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Rotation_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Rotation_y as text
%        str2double(get(hObject,'String')) returns contents of edit_Rotation_y as a double


% --- Executes during object creation, after setting all properties.
function edit_Rotation_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Rotation_Symmetrize.
function pushbutton_Rotation_Symmetrize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Rotation_Symmetrize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----information collection----%

GPU_flag=get(handles.radiobutton_Rotation_GPU,'Value');
rect_mask_flag=get(handles.radiobutton_Rotation_rect_mask,'Value');
sector_mask_flag=get(handles.radiobutton_Rotation_sector_mask,'Value');
Symmetry_Fold_index=get(handles.popupmenu_Rotation_Symmetry_Fold,'Value');
Symmetry_Fold_string=get(handles.popupmenu_Rotation_Symmetry_Fold,'String');
Symmetry_Fold=str2double(Symmetry_Fold_string{Symmetry_Fold_index});
x0=eval(get(handles.edit_Rotation_x,'String'));
y0=eval(get(handles.edit_Rotation_y,'String'));
x_from=eval(get(handles.edit_Rotation_x_from,'String'));
x_to=eval(get(handles.edit_Rotation_x_to,'String'));
y_from=eval(get(handles.edit_Rotation_y_from,'String'));
y_to=eval(get(handles.edit_Rotation_y_to,'String'));
phi_from=eval(get(handles.edit_Rotation_phi_from,'String'));
phi_to=eval(get(handles.edit_Rotation_phi_to,'String'));

%--------------------------------------------------------------%

%----interp data into new grid to make the origin at the centre---%
%---make x,y resolution the same----%

%---extract the first chosen variable---%
var_list=get(handles.Rotation_listbox,'String');
var_index=get(handles.Rotation_listbox,'Value');
var1_name=var_list{var_index(1)};
datav1=evalin('base',var1_name);
three_dimension_flag=isfield(datav1,'z');

%----new grid----%
x_half=max(x0-x_from,x_to-x0);
y_half=max(y0-y_from,y_to-y0);
delta_x=datav1.x(2)-datav1.x(1);
delta_y=datav1.y(2)-datav1.y(1);
delta=min(delta_x,delta_y);
Nx=round(x_half/delta);
Ny=round(y_half/delta);
x_grid=linspace(x0-x_half,x0+x_half,2*Nx+1);
y_grid=linspace(y0-y_half,y0+y_half,2*Ny+1);

if GPU_flag
    reset(gpuDevice(1));
    x_grid=gpuArray(single(x_grid));
    y_grid=gpuArray(single(y_grid));
    if three_dimension_flag
        z_grid=gpuArray(single(datav1.z));
        [X_grid,Y_grid,Z_grid]=ndgrid(x_grid,y_grid,z_grid);
    else
        [X_grid,Y_grid]=ndgrid(x_grid,y_grid);
    end
else
    if three_dimension_flag
        z_grid=datav1.z;
        [X_grid,Y_grid,Z_grid]=ndgrid(x_grid,y_grid,z_grid);
    else
        [X_grid,Y_grid]=ndgrid(x_grid,y_grid);
    end
end

%----mask matrix----%
if rect_mask_flag
    rect_mask=(X_grid>=x_from).*(X_grid<=x_to).*(Y_grid>=y_from).*(Y_grid<=y_to);
end

if sector_mask_flag
    [Theta,~,~]=cart2pol(X_grid,Y_grid,Z_grid);
    Theta=Theta+pi;
    sector_mask=(Theta>=(phi_from/180*pi)).*(Theta<=(phi_to/180*pi));
end

if GPU_flag
    if rect_mask_flag
        rect_mask=gpuArray(single(rect_mask));
        switch Symmetry_Fold
            case 2
                mask=rect_mask+imrotate(rect_mask,180,'bilinear','crop');
            case 3
                mask=rect_mask+imrotate(rect_mask,120,'bilinear','crop')...
                    +imrotate(rect_mask,240,'bilinear','crop');
            case 4
                mask=rect_mask+imrotate(rect_mask,90,'bilinear','crop')...
                    +imrotate(rect_mask,180,'bilinear','crop')...
                    +imrotate(rect_mask,270,'bilinear','crop');
            case 6
                mask=rect_mask+imrotate(rect_mask,60,'bilinear','crop')...
                    +imrotate(rect_mask,120,'bilinear','crop')...
                    +imrotate(rect_mask,180,'bilinear','crop')...
                    +imrotate(rect_mask,240,'bilinear','crop')...
                    +imrotate(rect_mask,300,'bilinear','crop');
        end
    end
    
    if sector_mask_flag
        sector_mask=gpuArray(single(single(sector_mask)));
        switch Symmetry_Fold
            case 2
                mask=sector_mask+imrotate(sector_mask,180,'bilinear','crop');
            case 3
                mask=sector_mask+imrotate(sector_mask,120,'bilinear','crop')...
                    +imrotate(sector_mask,240,'bilinear','crop');
            case 4
                mask=sector_mask+imrotate(sector_mask,90,'bilinear','crop')...
                    +imrotate(sector_mask,180,'bilinear','crop')...
                    +imrotate(sector_mask,270,'bilinear','crop');
            case 6
                mask=sector_mask+imrotate(sector_mask,60,'bilinear','crop')...
                    +imrotate(sector_mask,120,'bilinear','crop')...
                    +imrotate(sector_mask,180,'bilinear','crop')...
                    +imrotate(sector_mask,240,'bilinear','crop')...
                    +imrotate(sector_mask,300,'bilinear','crop');
        end
    end
    mask=double(gather(mask));
    
else
    if rect_mask_flag
        switch Symmetry_Fold
            case 2
                mask=rect_mask+imrotate(rect_mask,180,'bilinear','crop');
            case 3
                mask=rect_mask+imrotate(rect_mask,120,'bilinear','crop')...
                    +imrotate(rect_mask,240,'bilinear','crop');
            case 4
                mask=rect_mask+imrotate(rect_mask,90,'bilinear','crop')...
                    +imrotate(rect_mask,180,'bilinear','crop')...
                    +imrotate(rect_mask,270,'bilinear','crop');
            case 6
                mask=rect_mask+imrotate(rect_mask,60,'bilinear','crop')...
                    +imrotate(rect_mask,120,'bilinear','crop')...
                    +imrotate(rect_mask,180,'bilinear','crop')...
                    +imrotate(rect_mask,240,'bilinear','crop')...
                    +imrotate(rect_mask,300,'bilinear','crop');
        end
    end
       
     if sector_mask_flag
        switch Symmetry_Fold
            case 2
                mask=sector_mask+imrotate(sector_mask,180,'bilinear','crop');
            case 3
                mask=sector_mask+imrotate(sector_mask,120,'bilinear','crop')...
                    +imrotate(sector_mask,240,'bilinear','crop');
            case 4
                mask=sector_mask+imrotate(sector_mask,90,'bilinear','crop')...
                    +imrotate(sector_mask,180,'bilinear','crop')...
                    +imrotate(sector_mask,270,'bilinear','crop');
            case 6
                mask=sector_mask+imrotate(sector_mask,60,'bilinear','crop')...
                    +imrotate(sector_mask,120,'bilinear','crop')...
                    +imrotate(sector_mask,180,'bilinear','crop')...
                    +imrotate(sector_mask,240,'bilinear','crop')...
                    +imrotate(sector_mask,300,'bilinear','crop');
        end
     end
end



            
%----------------------------------%

%-----symmetrize-----%
if GPU_flag
    for ii=1:length(var_index)
        var_name=var_list{var_index(ii)};
        datav=evalin('base',var_name);
        x_old=gpuArray(single(datav.x));
        y_old=gpuArray(single(datav.y));
        value=gpuArray(single(datav.value));
        
        if three_dimension_flag
            z_old=gpuArray(single(datav.z));
            [X_old,Y_old,Z_old]=ndgrid(x_old,y_old,z_old);
            value=interp3(Y_old,X_old,Z_old,value,Y_grid,X_grid,Z_grid,'linear');
        else
            [X_old,Y_old]=ndgrid(x_old,y_old);
            value=interp2(Y_old,X_old,value,Y_grid,X_grid,'linear');
        end
        value0=double(gather(value));
        
        if rect_mask_flag
            value=value.*rect_mask;
        end
        if sector_mask_flag
            value=value.*sector_mask;
        end
        
        clearvars x_old y_old z_old X_old Y_old Z_old
        
        switch Symmetry_Fold
            case 2
                value=value+imrotate(value,180,'bilinear','crop');
            case 3
                value=value+imrotate(value,120,'bilinear','crop')...
                    +imrotate(value,240,'bilinear','crop');
            case 4
                value=value+imrotate(value,90,'bilinear','crop')...
                    +imrotate(value,180,'bilinear','crop')...
                    +imrotate(value,270,'bilinear','crop');
            case 6
                value=value+imrotate(value,60,'bilinear','crop')...
                    +imrotate(value,120,'bilinear','crop')...
                    +imrotate(value,180,'bilinear','crop')...
                    +imrotate(value,240,'bilinear','crop')...
                    +imrotate(value,300,'bilinear','crop');
        end
        datav.x=double(gather(x_grid));
        datav.y=double(gather(y_grid));
        if three_dimension_flag
            datav.z=double(gather(z_grid));
        end
        datav.value=double(gather(value));
        clearvars value;
        datav.value=datav.value./mask;
        datav.value(isnan(datav.value))=value0(isnan(datav.value));
        
        clearvars value0;
        
        assignin('base',cat(2,var_name,'_rs'),datav);
    end
else
     for ii=1:length(var_index)
        var_name=var_list{var_index(ii)};
        datav=evalin('base',var_name);
        value=datav.value;
        
        if three_dimension_flag
            [X_old,Y_old,Z_old]=ndgrid(datav.x,datav.y,datav.z);
            value=interp3(Y_old,X_old,Z_old,value,Y_grid,X_grid,Z_grid,'spline');
        else
            [X_old,Y_old]=ndgrid(datav.x,datav.y);
            value=interp2(Y_old,X_old,value,Y_grid,X_grid,'spline');
        end
        value0=value;
        
        if rect_mask_flag
            value=value.*rect_mask;
        end
        if sector_mask_flag
            value=value.*sector_mask;
        end
        
        clearvars x_old y_old z_old X_old Y_old Z_old
        
        switch Symmetry_Fold
            case 2
                value=value+imrotate(value,180,'bilinear','crop');
            case 3
                value=value+imrotate(value,120,'bilinear','crop')...
                    +imrotate(value,240,'bilinear','crop');
            case 4
                value=value+imrotate(value,90,'bilinear','crop')...
                    +imrotate(value,180,'bilinear','crop')...
                    +imrotate(value,270,'bilinear','crop');
            case 6
                value=value+imrotate(value,60,'bilinear','crop')...
                    +imrotate(value,120,'bilinear','crop')...
                    +imrotate(value,180,'bilinear','crop')...
                    +imrotate(value,240,'bilinear','crop')...
                    +imrotate(value,300,'bilinear','crop');
        end
        datav.x=x_grid;
        datav.y=y_grid;
        if three_dimension_flag
            datav.z=z_grid;
        end
        datav.value=value;
        datav.value=datav.value./mask;
        datav.value(isnan(datav.value))=value0(isnan(datav.value));
        
        clearvars value0;
        
        assignin('base',cat(2,var_name,'_rs'),datav);
    end
end

vars=evalin('base','who');
set(handles.Rotation_listbox,'String',vars);


% --- Executes on button press in radiobutton_Rotation_GPU.
function radiobutton_Rotation_GPU_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Rotation_GPU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Rotation_GPU


% --- Executes on button press in radiobutton_Rotation_rect_mask.
function radiobutton_Rotation_rect_mask_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Rotation_rect_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Rotation_rect_mask
set(handles.radiobutton_Rotation_sector_mask,'Value',1-get(hObject,'Value'));



function edit_Rotation_x_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_x_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Rotation_x_from as text
%        str2double(get(hObject,'String')) returns contents of edit_Rotation_x_from as a double


% --- Executes during object creation, after setting all properties.
function edit_Rotation_x_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_x_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Rotation_x_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_x_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Rotation_x_to as text
%        str2double(get(hObject,'String')) returns contents of edit_Rotation_x_to as a double


% --- Executes during object creation, after setting all properties.
function edit_Rotation_x_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_x_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Rotation_y_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_y_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Rotation_y_from as text
%        str2double(get(hObject,'String')) returns contents of edit_Rotation_y_from as a double


% --- Executes during object creation, after setting all properties.
function edit_Rotation_y_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_y_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Rotation_y_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_y_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Rotation_y_to as text
%        str2double(get(hObject,'String')) returns contents of edit_Rotation_y_to as a double


% --- Executes during object creation, after setting all properties.
function edit_Rotation_y_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_y_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_Rotation_sector_mask.
function radiobutton_Rotation_sector_mask_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Rotation_sector_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Rotation_sector_mask
set(handles.radiobutton_Rotation_rect_mask,'Value',1-get(hObject,'Value'));



function edit_Rotation_phi_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_phi_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Rotation_phi_from as text
%        str2double(get(hObject,'String')) returns contents of edit_Rotation_phi_from as a double


% --- Executes during object creation, after setting all properties.
function edit_Rotation_phi_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_phi_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Rotation_phi_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_phi_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Rotation_phi_to as text
%        str2double(get(hObject,'String')) returns contents of edit_Rotation_phi_to as a double


% --- Executes during object creation, after setting all properties.
function edit_Rotation_phi_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rotation_phi_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_Translation.
function listbox_Translation_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_Translation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_Translation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_Translation
vars=evalin('base','who');
set(handles.listbox_Translation,'String',vars);
list_entries = get(handles.listbox_Translation,'String');
index_selected = get(handles.listbox_Translation,'Value');
try
    var_name = list_entries{index_selected(1)};
catch
    var_name=list_entries{end};
    set(handles.listbox_Translation,'Value',length(list_entries));
end

datav=evalin('base',var_name);

if ~isfield(datav,'x')||~isfield(datav,'value')
    errordlg('Data must contain fields "x" and "value"','Data Format Error');
    return
end



% --- Executes during object creation, after setting all properties.
function listbox_Translation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_Translation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Translation_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Translation_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Translation_x as text
%        str2double(get(hObject,'String')) returns contents of edit_Translation_x as a double


% --- Executes during object creation, after setting all properties.
function edit_Translation_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Translation_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Translation_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Translation_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Translation_y as text
%        str2double(get(hObject,'String')) returns contents of edit_Translation_y as a double


% --- Executes during object creation, after setting all properties.
function edit_Translation_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Translation_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Translation_Ga_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Translation_Ga_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Translation_Ga_x as text
%        str2double(get(hObject,'String')) returns contents of edit_Translation_Ga_x as a double
str=get(hObject,'String');
num=eval(str);
set(hObject,'String',num2str(num));


% --- Executes during object creation, after setting all properties.
function edit_Translation_Ga_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Translation_Ga_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Translation_Gb_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Translation_Gb_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Translation_Gb_x as text
%        str2double(get(hObject,'String')) returns contents of edit_Translation_Gb_x as a double
str=get(hObject,'String');
num=eval(str);
set(hObject,'String',num2str(num));


% --- Executes during object creation, after setting all properties.
function edit_Translation_Gb_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Translation_Gb_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Translation_Ga_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Translation_Ga_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Translation_Ga_y as text
%        str2double(get(hObject,'String')) returns contents of edit_Translation_Ga_y as a double
str=get(hObject,'String');
num=eval(str);
set(hObject,'String',num2str(num));


% --- Executes during object creation, after setting all properties.
function edit_Translation_Ga_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Translation_Ga_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Translation_Gb_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Translation_Gb_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Translation_Gb_y as text
%        str2double(get(hObject,'String')) returns contents of edit_Translation_Gb_y as a double
str=get(hObject,'String');
num=eval(str);
set(hObject,'String',num2str(num));


% --- Executes during object creation, after setting all properties.
function edit_Translation_Gb_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Translation_Gb_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Translation_Symmetrize.
function pushbutton_Translation_Symmetrize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Translation_Symmetrize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--- collect information-----%
x0=eval(get(handles.edit_Translation_x,'String'));
y0=eval(get(handles.edit_Translation_y,'String'));
Ga_x=eval(get(handles.edit_Translation_Ga_x,'String'));
Ga_y=eval(get(handles.edit_Translation_Ga_y,'String'));
Gb_x=eval(get(handles.edit_Translation_Gb_x,'String'));
Gb_y=eval(get(handles.edit_Translation_Gb_y,'String'));

%-------------%
var_list=get(handles.listbox_Translation,'String');
var_index=get(handles.listbox_Translation,'Value');

for ii=1:length(var_index)
    var_name=var_list{var_index(ii)};
    datav=evalin('base',var_name);
    value0=datav.value;
    
    mask=Translation_mask(datav,x0,y0,Ga_x,Ga_y,Gb_x,Gb_y);
    datav.value=datav.value.*mask;

    datav=Translation_Symmetrize(datav,Ga_x,Ga_y,Gb_x,Gb_y);
    mask_struct.x=datav.x;
    mask_struct.y=datav.y;
    mask_struct.value=mask;
    clearvars mask
    mask_struct=Translation_Symmetrize(mask_struct,Ga_x,Ga_y,Gb_x,Gb_y);
    datav.value=datav.value./mask_struct.value;
    
    datav.value(datav.value==0)=value0(datav.value==0);
    assignin('base',cat(2,var_name,'_ts'),datav);
    clearvars datav value0
    
end

vars=evalin('base','who');
set(handles.listbox_Translation,'String',vars);

function  mask=Translation_mask(datav,x0,y0,Ga_x,Ga_y,Gb_x,Gb_y)
datav_size=size(datav.value);
mask=ones(datav_size(1),datav_size(2));
[Kx,Ky]=ndgrid(datav.x,datav.y);

if isfield(datav,'z')
    mask=repmat(mask,[1,1,length(datav.z)]);
    Kx=repmat(Kx,[1,1,length(datav.z)]);
    Ky=repmat(Ky,[1,1,length(datav.z)]);
end

Kx=Kx-x0;Ky=Ky-y0;

for ii=-2:2
    for jj=-2:2
        if ~(ii==0&&jj==0)
        G_x=ii*Ga_x+jj*Gb_x;
        G_y=ii*Ga_y+jj*Gb_y;
        mask_temp=((G_x*(Kx+0.5*G_x))+(G_y*(Ky+0.5*G_y)))>0;
        mask=mask.*mask_temp;
        clearvars mask_temp;
        end
    end
end

function datav_new=Translation_Symmetrize(datav,Ga_x,Ga_y,Gb_x,Gb_y)
delta_x=datav.x(2)-datav.x(1);
delta_y=datav.y(2)-datav.y(1);
datav_new.x=datav.x;
datav_new.y=datav.y;
if isfield(datav,'z')
    datav_new.z=datav.z;
end
datav_new.value=datav.value;
datav_new.value(isnan(datav_new.value))=0;
v_o=datav_new.value;
for ii=-2:2
    for jj=-2:2
        if ~(ii==0&&jj==0)
        G_x=ii*Ga_x+jj*Gb_x;
        G_y=ii*Ga_y+jj*Gb_y;
        trans_x=G_x/delta_x;
        trans_y=G_y/delta_y;
        datav_new.value=datav_new.value+imtranslate(v_o,[trans_y,trans_x]);
        end
    end
end
    


% --- Executes on selection change in listbox_Mirror.
function listbox_Mirror_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_Mirror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_Mirror contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_Mirror
vars=evalin('base','who');
set(handles.listbox_Mirror,'String',vars);
list_entries = get(handles.listbox_Mirror,'String');
index_selected = get(handles.listbox_Mirror,'Value');
try
    var_name = list_entries{index_selected(1)};
catch
    var_name=list_entries{end};
    set(handles.listbox_Mirror,'Value',length(list_entries));
end

datav=evalin('base',var_name);

if ~isfield(datav,'x')||~isfield(datav,'value')
    errordlg('Data must contain fields "x" and "value"','Data Format Error');
    return
end


% --- Executes during object creation, after setting all properties.
function listbox_Mirror_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_Mirror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Mirror_Symmetrize.
function pushbutton_Mirror_Symmetrize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Mirror_Symmetrize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%-----collect information------%
x_flag=get(handles.radiobutton_Mirror_x,'Value');
y_flag=get(handles.radiobutton_Mirror_y,'Value');
x_axis=eval(get(handles.edit_Mirror_x,'String'));
y_axis=eval(get(handles.edit_Mirror_y,'String'));
x_mask=get(handles.popupmenu_Mirror_x_mask,'Value');
y_mask=get(handles.popupmenu_Mirror_y_mask,'Value');

%--------------%
var_list=get(handles.listbox_Mirror,'String');
var_index=get(handles.listbox_Mirror,'Value');

for ii=1:length(var_index)
    var_name=var_list{var_index(ii)};
    datav=evalin('base',var_name);
    
    if x_flag
        switch x_mask
            case 1
                datav=Mirror_Symmetrize_x_whole(datav,x_axis);
            case 2
                datav=Mirror_Symmetrize_x_left(datav,x_axis);
            case 3
                datav=Mirror_Symmetrize_x_right(datav,x_axis);
        end
    end
    
    if y_flag
        switch y_mask
            case 1
                datav=Mirror_Symmetrize_y_whole(datav,y_axis);
            case 2
                datav=Mirror_Symmetrize_y_top(datav,y_axis);
            case 3
                datav=Mirror_Symmetrize_y_bottom(datav,y_axis);
        end
    end
   
    assignin('base',cat(2,var_name,'_ms'),datav);
    clearvars datav
end

vars=evalin('base','who');
set(handles.listbox_Mirror,'String',vars);

function datav_new=Mirror_Symmetrize_x_whole(datav,x_axis)
value=datav.value;
value(isnan(value))=0;
mask=ones(size(datav.value));
x_centre=0.5*(datav.x(1)+datav.x(end));
trans_x=2*(x_axis-x_centre)/(datav.x(2)-datav.x(1));

value_flip=flipud(value);
value_flip=imtranslate(value_flip,[0,trans_x]);

mask_flip=flipud(mask);
mask_flip=imtranslate(mask_flip,[0,trans_x]);

value=(value+value_flip)./(mask+mask_flip);
value(isnan(value))=0;

datav_new.x=datav.x;
datav_new.y=datav.y;
if isfield(datav,'z')
    datav_new.z=datav.z;
end
datav_new.value=value;

function datav_new=Mirror_Symmetrize_x_left(datav,x_axis)
value=datav.value;
value(isnan(value))=0;
x=datav.x;
y=datav.y;
x_centre=0.5*(datav.x(1)+datav.x(end));
trans_x=2*(x_axis-x_centre)/(datav.x(2)-datav.x(1));

if isfield(datav,'z')
    [X,~,~]=ndgrid(x,y,datav.z);
else
    [X,~]=ndgrid(x,y);
end

mask=X<x_axis;
value=value.*mask;

value_flip=flipud(value);
value_flip=imtranslate(value_flip,[0,trans_x]);

mask_flip=flipud(mask);
mask_flip=mask_flip+0;
mask_flip=imtranslate(mask_flip,[0,trans_x]);

value=(value+value_flip)./(mask+mask_flip);
value(isnan(value))=0;

datav_new.x=datav.x;
datav_new.y=datav.y;
if isfield(datav,'z')
    datav_new.z=datav.z;
end
datav_new.value=value;

function datav_new=Mirror_Symmetrize_x_right(datav,x_axis)
value=datav.value;
value(isnan(value))=0;
x=datav.x;
y=datav.y;
x_centre=0.5*(datav.x(1)+datav.x(end));
trans_x=2*(x_axis-x_centre)/(datav.x(2)-datav.x(1));

if isfield(datav,'z')
    [X,~,~]=ndgrid(x,y,datav.z);
else
    [X,~]=ndgrid(x,y);
end

mask=X>x_axis;
value=value.*mask;

value_flip=flipud(value);
value_flip=imtranslate(value_flip,[0,trans_x]);

mask_flip=flipud(mask);
mask_flip=mask_flip+0;
mask_flip=imtranslate(mask_flip,[0,trans_x]);

value=(value+value_flip)./(mask+mask_flip);
value(isnan(value))=0;

datav_new.x=datav.x;
datav_new.y=datav.y;
if isfield(datav,'z')
    datav_new.z=datav.z;
end
datav_new.value=value;

function datav_new=Mirror_Symmetrize_y_whole(datav,y_axis)
value=datav.value;
value(isnan(value))=0;
mask=ones(size(datav.value));
y_centre=0.5*(datav.y(1)+datav.y(end));
trans_y=2*(y_axis-y_centre)/(datav.y(2)-datav.y(1));

value_flip=fliplr(value);
value_flip=imtranslate(value_flip,[trans_y,0]);

mask_flip=fliplr(mask);
mask_flip=imtranslate(mask_flip,[trans_y,0]);

value=(value+value_flip)./(mask+mask_flip);
value(isnan(value))=0;

datav_new.x=datav.x;
datav_new.y=datav.y;
if isfield(datav,'z')
    datav_new.z=datav.z;
end
datav_new.value=value;

function datav_new=Mirror_Symmetrize_y_bottom(datav,y_axis)
value=datav.value;
value(isnan(value))=0;
x=datav.x;
y=datav.y;
y_centre=0.5*(datav.y(1)+datav.y(end));
trans_y=2*(y_axis-y_centre)/(datav.y(2)-datav.y(1));

if isfield(datav,'z')
    [~,Y,~]=ndgrid(x,y,datav.z);
else
    [~,Y]=ndgrid(x,y);
end

mask=Y<y_axis;
value=value.*mask;

value_flip=fliplr(value);
value_flip=imtranslate(value_flip,[trans_y,0]);

mask_flip=fliplr(mask);
mask_flip=mask_flip+0;
mask_flip=imtranslate(mask_flip,[trans_y,0]);

value=(value+value_flip)./(mask+mask_flip);
value(isnan(value))=0;

datav_new.x=datav.x;
datav_new.y=datav.y;
if isfield(datav,'z')
    datav_new.z=datav.z;
end
datav_new.value=value;

function datav_new=Mirror_Symmetrize_y_top(datav,y_axis)
value=datav.value;
value(isnan(value))=0;
x=datav.x;
y=datav.y;
y_centre=0.5*(datav.y(1)+datav.y(end));
trans_y=2*(y_axis-y_centre)/(datav.y(2)-datav.y(1));

if isfield(datav,'z')
    [~,Y,~]=ndgrid(x,y,datav.z);
else
    [~,Y]=ndgrid(x,y);
end

mask=Y>y_axis;
value=value.*mask;

value_flip=fliplr(value);
value_flip=imtranslate(value_flip,[trans_y,0]);

mask_flip=fliplr(mask);
mask_flip=mask_flip+0;
mask_flip=imtranslate(mask_flip,[trans_y,0]);

value=(value+value_flip)./(mask+mask_flip);
value(isnan(value))=0;

datav_new.x=datav.x;
datav_new.y=datav.y;
if isfield(datav,'z')
    datav_new.z=datav.z;
end
datav_new.value=value;




% --- Executes on button press in radiobutton_Mirror_mask_x.
function radiobutton_Mirror_mask_x_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Mirror_mask_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Mirror_mask_x
set(handles.radiobutton_Mirror_x,'Value',get(hObject,'Value'));


% --- Executes on button press in radiobutton_Mirror_mask_y.
function radiobutton_Mirror_mask_y_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Mirror_mask_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Mirror_mask_y
set(handles.radiobutton_Mirror_y,'Value',get(hObject,'Value'));


% --- Executes on selection change in popupmenu_Mirror_x_mask.
function popupmenu_Mirror_x_mask_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Mirror_x_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Mirror_x_mask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Mirror_x_mask

% --- Executes during object creation, after setting all properties.
function popupmenu_Mirror_x_mask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Mirror_x_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Mirror_y_mask.
function popupmenu_Mirror_y_mask_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Mirror_y_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Mirror_y_mask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Mirror_y_mask


% --- Executes during object creation, after setting all properties.
function popupmenu_Mirror_y_mask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Mirror_y_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_Mirror_x.
function radiobutton_Mirror_x_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Mirror_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Mirror_x
set(handles.radiobutton_Mirror_mask_x,'Value',get(hObject,'Value'));


% --- Executes on button press in radiobutton_Mirror_y.
function radiobutton_Mirror_y_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Mirror_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Mirror_y
set(handles.radiobutton_Mirror_mask_y,'Value',get(hObject,'Value'));



function edit_Mirror_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Mirror_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Mirror_x as text
%        str2double(get(hObject,'String')) returns contents of edit_Mirror_x as a double
str=get(hObject,'String');
set(hObject,'String',num2str(eval(str)));


% --- Executes during object creation, after setting all properties.
function edit_Mirror_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Mirror_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Mirror_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Mirror_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Mirror_y as text
%        str2double(get(hObject,'String')) returns contents of edit_Mirror_y as a double
str=get(hObject,'String');
set(hObject,'String',num2str(eval(str)));


% --- Executes during object creation, after setting all properties.
function edit_Mirror_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Mirror_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
