function varargout = CombineDataForKZ(varargin)
% COMBINEDATAFORKZ MATLAB code for CombineDataForKZ.fig
%      COMBINEDATAFORKZ, by itself, creates a new COMBINEDATAFORKZ or raises the existing
%      singleton*.
%
%      H = COMBINEDATAFORKZ returns the handle to a new COMBINEDATAFORKZ or the handle to
%      the existing singleton*.
%
%      COMBINEDATAFORKZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMBINEDATAFORKZ.M with the given input arguments.
%
%      COMBINEDATAFORKZ('Property','Value',...) creates a new COMBINEDATAFORKZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CombineDataForKZ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CombineDataForKZ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CombineDataForKZ

% Last Modified by GUIDE v2.5 30-Mar-2023 00:12:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CombineDataForKZ_OpeningFcn, ...
                   'gui_OutputFcn',  @CombineDataForKZ_OutputFcn, ...
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


% --- Executes just before CombineDataForKZ is made visible.
function CombineDataForKZ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CombineDataForKZ (see VARARGIN)

% Choose default command line output for CombineDataForKZ
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CombineDataForKZ wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CombineDataForKZ_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in refreshvar.
function refreshvar_Callback(hObject, eventdata, handles)
% hObject    handle to refreshvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars = evalin('base','who');
set(handles.listbox1,'String',vars)


% --- Executes on button press in combinedata.
function combinedata_Callback(hObject, eventdata, handles)
% hObject    handle to combinedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
new_map_name = get(handles.edit14,'String');
% check if the variable name exists
ise = evalin( 'base', append("exist('",new_map_name, "','var') == 1") );
if ise
    answer = questdlg('The variable name already exists. Would you like to continue?', ...
	'Variable name','Yes','Cancel','Cancel');
    if strcmp(answer,'Cancel')
        return
    end
end

if size(index_selected,2)==1
    errordlg('more variables, please!');
    return;
end

datafin = evalin('base',list_entries{index_selected(1)});

% looping for each data
for i = 2:size(index_selected,2)
    % get variable
    datain2 = evalin('base',list_entries{index_selected(i)});
    % error control
%     if ~isstruct(datain1)
%         errordlg(['data',num2str(i),'is not struct'])
%         return;
%     elseif (~(isfield(datain1,'x') && isfield(datain1,'y') && isfield(datain1,'z') && isfield(datain1,'ztot') && isfield(datain1,'value')))
%         errordlg(['data',num2str(i),'is wrong. Data needs at least x,y,z,ztot, and value field']);
%         return;
%     end
    if ndims(datain2.value) ~= 3
        errordlg(['Data ',list_entries{index_selected(i)},' is not a 3D kz map. Please check the data type.']);
        return;
    end
    % combining
    if size(datafin.x,1) == 1
        datafin.x = cat(2,datafin.x,datain2.x);
    else
        datafin.x = cat(1,datafin.x,datain2.x);
    end
    
    datafin.value = cat(1,datafin.value,datain2.value);
end

[~,I]=sort(datafin.x);
datafin.x = datafin.x(I);
datafin.value = datafin.value(I,:,:);
% datafin.ztot = datafin.ztot(:,I);

assignin('base',get(handles.edit14,'String'),datafin);


% --- Executes on button press in resampledata.
function resampledata_Callback(hObject, eventdata, handles)
% hObject    handle to resampledata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display('Start resampling, please wait!')
tic
% get data
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if size(index_selected,2)>1
    errordlg('Resample the data one by one!');
    return;
end
%get var_name
var_name1 = list_entries{index_selected(1)};

datain1=evalin('base',var_name1);
if ~isstruct(datain1)
    errordlg('Your data is not struct')
    return;
elseif (~(isfield(datain1,'x') && isfield(datain1,'y') && isfield(datain1,'z') && isfield(datain1,'ztot') && isfield(datain1,'value')))
    errordlg('Data needs at least x,y,z,ztot,value field');
    return;
end

% checking the criteria
if handles.xcheck.Value
    xarray = str2num(handles.xarray.String);
    errordlg('This program is not YET modified for modifying xstep. Ask Sandy!')
    return;
else
    % to be modified later for xarray
    %xarray = datain1.x(2) - datain1.x(1);
end
if handles.ycheck.Value
    yarray = str2num(handles.yarray.String);
    %ystep = yarray(2) - yarray(1);
else
    yarray = datain1.y;
end
if handles.zcheck.Value
    zarray = str2num(handles.zarray.String);
else
    zarray = datain1.z;
end

kasus = handles.ycheck.Value+handles.zcheck.Value;

switch kasus
    case 0
        errordlg('no resampling?')
    case {1,2,3}
        % redefining the output x y z
        dataout = datain1;
        %dataout.x = [min(datain1.x):xarray:max(datain1.x)];
        dataout.y = yarray;
        dataout.z = zarray;
        deltaztot = datain1.z(1) - datain1.ztot(1,:); %check deltaztot for each photon energy slice
        deltaztot = repmat(deltaztot,size(dataout.z,2),1); %replicate the differences
        dataout.value = [];
        dataout.ztot = [];
        dataout.ztot = repmat(dataout.z',1,size(dataout.x,2)) - deltaztot;
        
        % start interpolating
        eee = permute(datain1.value,[2 3 1]);
        eee = reshape(eee, [numel(datain1.y)*numel(datain1.z), numel(datain1.x)]);
        [yq,zq] = ndgrid(dataout.y,dataout.z);
        [y,z] = ndgrid(datain1.y,datain1.z);
        tri = delaunayTriangulation(y(:),z(:));
        t_element = tri(:,:);
        [ti, bc] = pointLocation(tri, [yq(:), zq(:)]);
        ti(isnan(ti)) = numel(datain1.y)*numel(datain1.z)+1;
        pt = t_element(ti,:);
        triVals3D_1 = eee(pt(:,1),:);
        triVals3D_2 = eee(pt(:,2),:);
        triVals3D_3 = eee(pt(:,3),:);
        bc_1 = repmat(bc(:,1),[1,numel(datain1.x)]);
        bc_2 = repmat(bc(:,2),[1,numel(datain1.x)]);
        bc_3 = repmat(bc(:,3),[1,numel(datain1.x)]);
        DummyValue = bc_1.*triVals3D_1 ...
            +bc_2.*triVals3D_2 ...
            + bc_3.*triVals3D_3;
        dataout.value = reshape(DummyValue,[numel(dataout.y),numel(dataout.z),numel(datain1.x)]); %always remember to swap the dimension here ... dont know why
        dataout.value = permute(dataout.value,[3 1 2]);
%         y = reshape(y,1,numel(datain1.y)*numel(datain1.z));
%         z = reshape(z,1,numel(datain1.y)*numel(datain1.z));
%              %dummy variables for parfor
%              datain1value = datain1.value;
%              datain1y = datain1.y;
%              datain1z = datain1.z;
%         
%         parfor i = 1:numel(dataout.x)         
%             v = reshape(squeeze(datain1value(i,:,:)),1,numel(datain1y)*numel(datain1z));
%             vq{i} = griddata(y,z,v,yq,zq);
%         end
%         
%         for i = 1:numel(dataout.x)
%             dataout.value(i,:,:) = vq{i};
%         end
        var_namei1=cat(2,var_name1,'_resamp');
        assignin('base',var_namei1,dataout);
end
toc
display('resampling done')
load chirp;
sound(y, Fs);

% --- Executes on button press in xcheck.
function xcheck_Callback(hObject, eventdata, handles)
% hObject    handle to xcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xcheck


% --- Executes on button press in ycheck.
function ycheck_Callback(hObject, eventdata, handles)
% hObject    handle to ycheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ycheck


% --- Executes on button press in zcheck.
function zcheck_Callback(hObject, eventdata, handles)
% hObject    handle to zcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zcheck



function xarray_Callback(hObject, eventdata, handles)
% hObject    handle to xarray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xarray as text
%        str2double(get(hObject,'String')) returns contents of xarray as a double


% --- Executes during object creation, after setting all properties.
function xarray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xarray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yarray_Callback(hObject, eventdata, handles)
% hObject    handle to yarray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yarray as text
%        str2double(get(hObject,'String')) returns contents of yarray as a double


% --- Executes during object creation, after setting all properties.
function yarray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yarray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zarray_Callback(hObject, eventdata, handles)
% hObject    handle to zarray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zarray as text
%        str2double(get(hObject,'String')) returns contents of zarray as a double


% --- Executes during object creation, after setting all properties.
function zarray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zarray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CombineSliceData.
function CombineSliceData_Callback(hObject, eventdata, handles)
% hObject    handle to CombineSliceData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the variable list
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');

num_cuts = size(index_selected,2);
hv_array = eval(get(handles.edit12,'String'));
workfunction = str2num(get(handles.edit13,'String'));
new_map_name = get(handles.edit14,'String');
% check if the variable name exists
ise = evalin( 'base', append("exist('",new_map_name, "','var') == 1") );
if ise
    answer = questdlg('The variable name already exists. Would you like to continue?', ...
	'Variable name','Yes','Cancel','Cancel');
    if strcmp(answer,'Cancel')
        return
    end
end

e_min = zeros(1,num_cuts);
e_max = zeros(1,num_cuts);

datain1 = evalin('base',list_entries{index_selected(1)});

% declare final variable name
datafin.x = hv_array;
datafin.y = datain1.x;
datafin.z = datain1.y - hv_array(1) + workfunction;
datafin.value = [];

% looping for each data
for i = 1:num_cuts
    % get var name
    var_name1 = list_entries{index_selected(i)};
    % call the data
    datain1=evalin('base',var_name1);
    % error control
    if ndims(datain1.value) ~= 2
        errordlg(['Data ',var_name1,' is not a 2D cut. Please check the data.']);
        return;
    end
    
    datafin.value(i,:,:) = datain1.value;
end

[~,I] = sort(datafin.x);
datafin.x = datafin.x(I);
datafin.value = datafin.value(I,:,:);
% datafin.ztot = datafin.ztot(:,I);

if isa(datain1,'OxA_CUT')
    datafin = OxA_KZ(datafin);
    datafin.info.workfunction = workfunction;
end

assignin('base',new_map_name,datafin);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
z_range=evalin('base',[var_name{1} '.z']);
set(handles.zarray,'String',['linspace(' num2str(min(z_range)) ',' num2str(max(z_range)) ',' num2str(length(z_range)) ')']);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
y_range=evalin('base',[var_name{1} '.y']);
set(handles.yarray,'String',['linspace(' num2str(min(y_range)) ',' num2str(max(y_range)) ',' num2str(length(y_range)) ')']);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
x_range=evalin('base',[var_name{1} '.x']);
set(handles.xarray,'String',['linspace(' num2str(min(x_range)) ',' num2str(max(x_range)) ',' num2str(length(x_range)) ')']);



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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
