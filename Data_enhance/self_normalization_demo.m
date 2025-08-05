function varargout = self_normalization_demo(varargin)
% SELF_NORMALIZATION_DEMO M-file for self_normalization_demo.fig
%      SELF_NORMALIZATION_DEMO, by itself, creates a new SELF_NORMALIZATION_DEMO or raises the existing
%      singleton*.
%
%      H = SELF_NORMALIZATION_DEMO returns the handle to a new SELF_NORMALIZATION_DEMO or the handle to
%      the existing singleton*.
%
%      SELF_NORMALIZATION_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELF_NORMALIZATION_DEMO.M with the given input arguments.
%
%      SELF_NORMALIZATION_DEMO('Property','Value',...) creates a new SELF_NORMALIZATION_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before self_normalization_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to self_normalization_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help self_normalization_demo

% Last Modified by GUIDE v2.5 15-Jul-2019 15:16:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @self_normalization_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @self_normalization_demo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before self_normalization_demo is made visible.
function self_normalization_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to self_normalization_demo (see VARARGIN)

% Choose default command line output for self_normalization_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.VerInfo,'String','Last Modified at 20150422');
% UIWAIT makes self_normalization_demo wait for user response (see UIRESUME)
% uiwait(handles.self_normalization_demo);


% --- Outputs from this function are returned to the command line.
function varargout = self_normalization_demo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes on button press in refresh_variables.
function refresh_variables_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--------------------
vars = evalin('base','who');
set(handles.listbox2,'String',vars);
%---------------------


% --- Executes on button press in x.
function x_Callback(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of x

%----------mutually exclusive----------
set(handles.y,'value',0);
set(handles.z,'value',0);
%--------------------------------------


% --- Executes on button press in y.
function y_Callback(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of y

%----------mutually exclusive----------
set(handles.x,'value',0);
set(handles.z,'value',0);
%--------------------------------------

% --- Executes on button press in z.
function z_Callback(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of z

%----------mutually exclusive----------
set(handles.x,'value',0);
set(handles.y,'value',0);
%--------------------------------------

% --- Executes on button press in normalize.
function normalize_Callback(hObject, eventdata, handles)
% hObject    handle to normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%================get info from the panel==============
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
VarNames = handles_h.VarNames;
index_size=length(VarNames);
if index_size==0
    return;
else
for indx_num=1:index_size
var_name = VarNames{indx_num};  %get var_name
data=evalin('base',var_name);       % get data from base

direx=get(handles.x,'value');
direy=get(handles.y,'value');
direz=get(handles.z,'value');
direyz=get(handles.yz,'value');
direxz=get(handles.xz,'value');
direxy=get(handles.xy,'value');
if direx==0 && direy==0 && direz==0 && direyz==0 && direxz==0 && direxy==0% check if the direction is selected
    errordlg('You must specify normalization direction!','Incorrect input');
    return;
end

nor_from=str2num(get(handles.from,'String'));
nor_to=str2num(get(handles.to,'String'));
scale_index=get(handles.index,'value');
scale_real =get(handles.real_scale,'value');
nor_to_peak=get(handles.normal_to_peak,'value');

% if specify from AND to value, must also specify index or real scale
if ~isempty(nor_from)&& ~isempty(nor_to) && scale_index==0 && scale_real==0
    errordlg('If you specify "From" AND "To" value, you must also specify if they mean index or real scale!','Incorrect input');
    return;
end


% if data doesn't have real scale value info, then specify real_scale is
% wrong-----------------------
if ~(isfield(data,"value") || isprop(data,"value")) && scale_real==1  % if data has no real scale info at all
    errordlg('Data have no real scale info!','Incorrect input');
    return;
end


if direx==1 && isempty(data.x) && scale_real==1 % if data has no real scale info along x
    errordlg('Data have no real scale info along x direction ','Incorrect input');
    return;
end

if direy==1 && isempty(data.y) && scale_real==1
    errordlg('Data have no real scale info along y direction ','Incorrect input');
    return;
end

if (direz==1||direyz==1||direxz==1) && isempty(data.z) && scale_real==1
    errordlg('Data have no real scale info along z direction ','Incorrect input');
    return;
end
%----------------------------

%--------------------start handling data--------------------

%------------in three different direction, decide from & to indivitually
% then apply the normalization---------------
vNaN = isnan(data.value);
data.value(vNaN==1)=0;
data_nor=data;

%----------------------along x--------------------------
if direx==1
    
    if isempty(nor_from) || isempty(nor_to)
        n_start=1; 
        n_end=size(data_nor.value,1);
    else if scale_index==1
            n_start=nor_from;
            n_end=nor_to;
        else
            n_start=round( (nor_from-data_nor.x(1))/(data_nor.x(2)-data_nor.x(1))+1);
            n_end=round( (nor_to-data_nor.x(1))/(data_nor.x(2)-data_nor.x(1))+1);
        end
    end
    
    for i=1:size(data_nor.value,2)
        for j=1:size(data_nor.value,3)
            if nor_to_peak==1
                norm=max(max(max(data.value(:,i,j))));
            else
                norm=sum(data_nor.value(n_start:n_end,i,j),1);
            end
            data_nor.value(:,i,j)=data_nor.value(:,i,j)/norm;
        end
    end
    
end
%----------------------along y--------------------------
if direy==1
    
    if isempty(nor_from) || isempty(nor_to)
        n_start=1; 
        n_end=size(data_nor.value,2); % <---- change
    else if scale_index==1
            n_start=nor_from;
            n_end=nor_to;
        else
            n_start=round( (nor_from-data_nor.y(1))/(data_nor.y(2)-data_nor.y(1))+1);
            n_end=round( (nor_to-data_nor.y(1))/(data_nor.y(2)-data_nor.y(1))+1);
        end
    end
    
    for i=1:size(data_nor.value,1)
        for j=1:size(data_nor.value,3)
            if nor_to_peak==1
                norm=max(max(max(data.value(i,:,j))));
            else
                norm=sum(data_nor.value(i,n_start:n_end,j),2);
            end
            data_nor.value(i,:,j)=data_nor.value(i,:,j)/norm;
        end
    end
    
end
%----------------------along z--------------------------
if direz==1
    
    if isempty(nor_from) || isempty(nor_to)
        n_start=1; 
        n_end=size(data_nor.value,3);
    else if scale_index==1
            n_start=nor_from;
            n_end=nor_to;
        else
            n_start=round( (nor_from-data_nor.z(1))/(data_nor.z(2)-data_nor.z(1))+1);
            n_end=round( (nor_to-data_nor.z(1))/(data_nor.z(2)-data_nor.z(1))+1);
        end
    end
    
    for i=1:size(data_nor.value,1)
        for j=1:size(data_nor.value,2)
            if nor_to_peak==1
                norm=max(max(max(data.value(i,j,:))));
            else
                norm=sum(data_nor.value(i,j,n_start:n_end),3);
            end            
            data_nor.value(i,j,:)=data_nor.value(i,j,:)/norm;
        end
    end
    
end

if direyz==1
    if isempty(nor_from) || isempty(nor_to)
        n_start=1; 
        n_end=size(data_nor.value,3);
    else if scale_index==1
            n_start=nor_from;
            n_end=nor_to;
        else
            n_start=round( (nor_from-data_nor.z(1))/(data_nor.z(2)-data_nor.z(1))+1);
            n_end=round( (nor_to-data_nor.z(1))/(data_nor.z(2)-data_nor.z(1))+1);
        end
    end

    [sizeX,sizeY,sizeZ]=size(data.value);

    norm_curv = sum(data.value(:,:,n_start:n_end),[2 3]);
    norm_curv = norm_curv / mean(norm_curv);


    for i=1:sizeX
        dataCutYZ=data.value(i,:,:);
        
        if nor_to_peak==1
            maxCutYZ=max(max(dataCutYZ));
            data_nor.value(i,:,:)=dataCutYZ/maxCutYZ;
        else
            data_nor.value(i,:,:)=dataCutYZ./norm_curv(i);
        end
    end
end % end of direyz
if direxz==1
    [~,sizeY,~]=size(data.value);
    for i=1:sizeY
        dataCutXZ=data.value(:,i,:);
        
        
        if nor_to_peak==1
            maxCutXZ=max(max(dataCutXZ));
            data_nor.value(:,i,:)=dataCutXZ/maxCutXZ;
        else
            sumCutXZ=sum(sum(dataCutXZ));
            data_nor.value(:,i,:)=dataCutXZ/sumCutXZ;
        end
    end
end % end of direxz

if direxy==1
    [~,~,sizeZ]=size(data.value);
    for i=1:sizeZ
        dataCutXY=data.value(:,:,i);
        
        
        if nor_to_peak==1
            maxCutXY=max(max(dataCutXY));
            data_nor.value(:,:,i)=dataCutXY/maxCutXY;
        else
            sumCutXY=sum(sum(dataCutXY));
            data_nor.value(:,:,i)=dataCutXY/sumCutXY;
        end
    end
end % end of direxy
%------------------------asign the normalized data back---------
data_nor.value(vNaN==1)=NaN;
var_namei=cat(2,var_name,'_s_nor');
assignin('base',var_namei,data_nor);
end
end


%=================end of execution====================



% --- Executes during object creation, after setting all properties.
function from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function from_Callback(hObject, eventdata, handles)
% hObject    handle to from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of from as text
%        str2double(get(hObject,'String')) returns contents of from as a double


% --- Executes during object creation, after setting all properties.
function to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function to_Callback(hObject, eventdata, handles)
% hObject    handle to to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of to as text
%        str2double(get(hObject,'String')) returns contents of to as a double


% --- Executes on button press in index.
function index_Callback(hObject, eventdata, handles)
% hObject    handle to index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of index

%----------mutually exclusive----------
set(handles.real_scale,'value',0);
%--------------------------------------

% --- Executes on button press in real_scale.
function real_scale_Callback(hObject, eventdata, handles)
% hObject    handle to real_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of real_scale

%----------mutually exclusive----------
set(handles.index,'value',0);
%--------------------------------------


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over refresh_variables.
function refresh_variables_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to refresh_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in normal_to_peak.
function normal_to_peak_Callback(hObject, eventdata, handles)
% hObject    handle to normal_to_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normal_to_peak




% --- Executes on button press in Lower_Contrast.
function Lower_Contrast_Callback(hObject, eventdata, handles)
% hObject    handle to Lower_Contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%
% Attention
% Completed for only x_direction
%
%
%
%%
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
VarNames = handles_h.VarNames;
index_size=length(VarNames);
if index_size==0
    return;
else
for indx_num=1:index_size
var_name = VarNames{indx_num};  %get var_name
data=evalin('base',var_name);       % get data from base

direx=get(handles.x,'value');
direy=get(handles.y,'value');
direz=get(handles.z,'value');
if direx==0 && direy==0 && direz==0   % check if the direction is selected
    errordlg('You must specify normalization direction!','Incorrect input');
    return;
end

nor_from=str2num(get(handles.from,'String'));
nor_to=str2num(get(handles.to,'String'));
scale_index=get(handles.index,'value');
scale_real =get(handles.real_scale,'value');
nor_to_peak=get(handles.normal_to_peak,'value');

% if specify from AND to value, must also specify index or real scale
if ~isempty(nor_from)&& ~isempty(nor_to) && scale_index==0 && scale_real==0
    errordlg('If you specify "From" AND "To" value, you must also specify if they mean index or real scale!','Incorrect input');
    return;
end


% if data doesn't have real scale value info, then specify real_scale is
% wrong-----------------------
if ~(isfield(data,"value") || isprop(data,"value")) && scale_real==1  % if data has no real scale info at all
    errordlg('Data have no real scale info!','Incorrect input');
    return;
end


if direx==1 && isempty(data.x) && scale_real==1 % if data has no real scale info along x
    errordlg('Data have no real scale info along x direction ','Incorrect input');
    return;
end

if direy==1 && isempty(data.y) && scale_real==1
    errordlg('Data have no real scale info along y direction ','Incorrect input');
    return;
end

if direz==1 && isempty(data.z) && scale_real==1
    errordlg('Data have no real scale info along z direction ','Incorrect input');
    return;
end

%----------------------------

%--------------------start handling data--------------------

%------------in three different direction, decide from & to indivitually
% then apply the normalization---------------
data_nor=data;

%----------------------along x--------------------------
if direx==1
    
    if isempty(nor_from) || isempty(nor_to)
        n_start=1; 
        n_end=size(data_nor.value,1);
    else if scale_index==1
            n_start=nor_from;
            n_end=nor_to;
        else
            n_start=round( (nor_from-data_nor.x(1))/(data_nor.x(2)-data_nor.x(1))+1);
            n_end=round( (nor_to-data_nor.x(1))/(data_nor.x(2)-data_nor.x(1))+1);
        end
    end
    
    norm_min=abs(Inf);
    for i=1:size(data_nor.value,2)
        for j=1:size(data_nor.value,3)            
            if nor_to_peak==1
                norm=max(max(max(data.value(i,:,j))));
            else
                norm=sum(data_nor.value(n_start:n_end,i,j),1);
            end
            if norm_min>norm
                norm_min=norm;
            end
        end
    end
    for i=1:size(data_nor.value,2)
        for j=1:size(data_nor.value,3)
            if nor_to_peak==1
                norm=max(max(max(data.value(i,:,j))));
            else
                norm=sum(data_nor.value(n_start:n_end,i,j),1);
            end
            times=norm/norm_min;
            times=log(times)/times;
            data_nor.value(:,i,j)=data_nor.value(:,i,j).*times;
        end
    end
    
end
%----------------------along y--------------------------
if direy==1
    
    if isempty(nor_from) || isempty(nor_to)
        n_start=1; 
        n_end=size(data_nor.value,2); % <---- change
    else if scale_index==1
            n_start=nor_from;
            n_end=nor_to;
        else
            n_start=round( (nor_from-data_nor.y(1))/(data_nor.y(2)-data_nor.y(1))+1);
            n_end=round( (nor_to-data_nor.y(1))/(data_nor.y(2)-data_nor.y(1))+1);
        end
    end
    
    for i=1:size(data_nor.value,1)
        for j=1:size(data_nor.value,3)
            if nor_to_peak==1
                norm=max(max(max(data.value(i,:,j))));
            else
                norm=sum(data_nor.value(i,n_start:n_end,j),2);
            end
            data_nor.value(i,:,j)=data_nor.value(i,:,j)/norm;
        end
    end
    
end
%----------------------along z--------------------------
if direz==1
    
    if isempty(nor_from) || isempty(nor_to)
        n_start=1; 
        n_end=size(data_nor.value,3);
    else if scale_index==1
            n_start=nor_from;
            n_end=nor_to;
        else
            n_start=round( (nor_from-data_nor.z(1))/(data_nor.z(2)-data_nor.z(1))+1);
            n_end=round( (nor_to-data_nor.z(1))/(data_nor.z(2)-data_nor.z(1))+1);
        end
    end
    
    for i=1:size(data_nor.value,1)
        for j=1:size(data_nor.value,2)
            if nor_to_peak==1
                norm=max(max(max(data.value(i,j,:))));
            else
                norm=sum(data_nor.value(i,j,n_start:n_end),3);
            end            
            data_nor.value(i,j,:)=data_nor.value(i,j,:)/norm;
        end
    end
    
end

%------------------------asign the normalized data back---------

var_namei=cat(2,var_name,'_s_log');
assignin('base',var_namei,data_nor);
end
end


% --- Executes when self_normalization_demo is resized.
function self_normalization_demo_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to self_normalization_demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in yz.
function yz_Callback(hObject, eventdata, handles)
% hObject    handle to yz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yz


% --- Executes on button press in xy.
function xz_Callback(hObject, eventdata, handles)
% hObject    handle to xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xz


% --- Executes on button press in xy.
function xy_Callback(hObject, eventdata, handles)
% hObject    handle to xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xy
