function varargout = data_comb_resamp_demo(varargin)
% DATA_COMB_RESAMP_DEMO M-file for data_comb_resamp_demo.fig
%      DATA_COMB_RESAMP_DEMO, by itself, creates a new DATA_COMB_RESAMP_DEMO or raises the existing
%      singleton*.
%
%      H = DATA_COMB_RESAMP_DEMO returns the handle to a new DATA_COMB_RESAMP_DEMO or the handle to
%      the existing singleton*.
%
%      DATA_COMB_RESAMP_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_COMB_RESAMP_DEMO.M with the given input arguments.
%
%      DATA_COMB_RESAMP_DEMO('Property','Value',...) creates a new DATA_COMB_RESAMP_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data_comb_resamp_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data_comb_resamp_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data_comb_resamp_demo

% Last Modified by GUIDE v2.5 18-Jun-2015 23:04:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data_comb_resamp_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @data_comb_resamp_demo_OutputFcn, ...
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


% --- Executes just before data_comb_resamp_demo is made visible.
function data_comb_resamp_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_comb_resamp_demo (see VARARGIN)

% Choose default command line output for data_comb_resamp_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data_comb_resamp_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = data_comb_resamp_demo_OutputFcn(hObject, eventdata, handles) 
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


function x_pix_Callback(hObject, eventdata, handles)
% hObject    handle to x_pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_pix as text
%        str2double(get(hObject,'String')) returns contents of x_pix as a double


% --- Executes during object creation, after setting all properties.
function x_pix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_pix_Callback(hObject, eventdata, handles)
% hObject    handle to y_pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_pix as text
%        str2double(get(hObject,'String')) returns contents of y_pix as a double


% --- Executes during object creation, after setting all properties.
function y_pix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_pix_Callback(hObject, eventdata, handles)
% hObject    handle to z_pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_pix as text
%        str2double(get(hObject,'String')) returns contents of z_pix as a double


% --- Executes during object creation, after setting all properties.
function z_pix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in combine_resample.
function combine_resample_Callback(hObject, eventdata, handles)
% hObject    handle to combine_resample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
flag_resa=get(handles.resample,'Value');

xpix=str2double(get(handles.x_pix,'String'));
ypix=str2double(get(handles.y_pix,'String'));
zpix=str2double(get(handles.z_pix,'String'));
kpix=str2double(get(handles.k_pix,'String'));

%====================== check data format =====================
if ~ ((isfield(datav,'value') && isfield(datav,'x')) || (isprop(datav,'value') && isprop(datav,'x')) )
    errordlg('Data must contains "datav.value" and at least "data.x" (for 1d)','error input');
    return;
end
datav_new=datav;
datav_new.x = [];
try
    datav_new.y = [];
    datav_new.z = [];
catch
end
datav_new.value = [];

%% ====================== 1d case ================================
if ndims(datav.value)==1
    data_size=max(size(datav.value));    
    
    if flag_resa==1                %------ if resample data----
        datav_new.value=datav.value(1:xpix:data_size);
        if isfield(datav, 'x')
            datav_new.x=datav.x(1:xpix:data_size);
        end
        assignin('base',cat(2,var_name,'_resam'),datav_new);
        
    else                            %----- if combine data-----
        max_index=floor(data_size/xpix);
        for i=1:max_index
            datav_new.value(i)=sum(datav.value((i-1)*xpix+1:i*xpix));
            if isfield(datav, 'x')
                datav_new.x(i)=mean(datav.x((i-1)*xpix+1:i*xpix));
            end
        end
        assignin('base',cat(2,var_name,'_comb'),datav_new);
    end
end

%% ====================== 2d case ================================
if ndims(datav.value)==2
    if ~isfield(datav,'y') && ~isprop(datav,'y')
        errordlg('2D Data must also contains "data.y" field','error input');   
        return;
    end
    
    data_size=size(datav.value);
    
    if flag_resa==1                %------ if resample data----
        datav_new.value=datav.value(1:xpix:data_size(1),1:ypix:data_size(2));
        if isfield(datav, 'x') || isprop(datav, 'x')
            datav_new.x=datav.x(1:xpix:data_size(1));
        end
        if isfield(datav, 'y')  || isprop(datav, 'y')
            datav_new.y=datav.y(1:ypix:data_size(2));
        end
        assignin('base',cat(2,var_name,'_resam'),datav_new);
        
    else                            %----- if combine data-----
        max_index(1)=floor(data_size(1)/xpix);
        max_index(2)=floor(data_size(2)/ypix);
        clear vlaue1;
        for i=1:max_index(1)
            value1(i,:)=sum(datav.value((i-1)*xpix+1:i*xpix,:),1);
            if isfield(datav,'x') || isprop(datav, 'x')
                datav_new.x(i)=mean(datav.x((i-1)*xpix+1:i*xpix));
            end
        end
        
        for i=1:max_index(2)
            datav_new.value(:,i)=sum(value1(:,(i-1)*ypix+1:i*ypix),2);
            if isfield(datav, 'y') || isprop(datav, 'y')
                datav_new.y(i)=mean(datav.y((i-1)*ypix+1:i*ypix));
            end
        end
        
        assignin('base',cat(2,var_name,'_comb'),datav_new);
    end

end

%% ====================== 3d case ================================
if ndims(datav.value)==3

    if ~isfield(datav,'z')  && ~isprop(datav, 'x')
        errordlg('3D Data must also contains "data.z" field','error input');
        return;
    end
    
    data_size=size(datav.value);
    if flag_resa==1                %------ if resample data----
        datav_new=datav;
        datav_new.value=datav.value(1:xpix:data_size(1),1:ypix:data_size(2),1:zpix:data_size(3));
        if isfield(datav, 'x') || isprop(datav, 'x')
            datav_new.x=datav.x(1:xpix:data_size(1));
        end
        if isfield(datav, 'y') || isprop(datav, 'y')
            datav_new.y=datav.y(1:ypix:data_size(2));
        end
        if isfield(datav, 'z') || isprop(datav, 'z')
            datav_new.z=datav.z(1:zpix:data_size(3));
        end

        assignin('base',cat(2,var_name,'_resam'),datav_new);
        
    else                            %----- if combine data-----
        clear value;
        clear value1;
        clear value2;
        max_index(1)=floor(data_size(1)/xpix);
        max_index(2)=floor(data_size(2)/ypix);
        max_index(3)=floor(data_size(3)/zpix);
%         datav_new=datav;
        for i=1:max_index(1)
            value1(i,:,:)=sum(datav.value((i-1)*xpix+1:i*xpix,:,:),1);
            if isfield(datav, 'x')  || isprop(datav, 'x')
                datav_new.x(i)=mean(datav.x((i-1)*xpix+1:i*xpix));
            end
        end
        
        for i=1:max_index(2)
            value2(:,i,:)=sum(value1(:,(i-1)*ypix+1:i*ypix,:),2);
            if isfield(datav, 'y')  || isprop(datav, 'y')
                datav_new.y(i)=mean(datav.y((i-1)*ypix+1:i*ypix));
            end
        end
        
        for i=1:max_index(3)
            value(:,:,i)=sum(value2(:,:,(i-1)*zpix+1:i*zpix),3);
            if isfield(datav, 'z')  || isprop(datav, 'z')
                datav_new.z(i)=mean(datav.z((i-1)*zpix+1:i*zpix));
            end
        end
        datav_new.value=value;
        assignin('base',cat(2,var_name,'_comb'),datav_new);
    end
end
%% ========================= 4d case ====================================
if ndims(datav.value)==4

    if ~isfield(datav,'z')  && ~isprop(datav, 'z')
        errordlg('4D Data must also contains "data.z" field','error input');
        return;
    end
    if ~isfield(datav,'k')  && ~isprop(datav, 'k')
        errordlg('4D Data must also contains "data.k" field','error input');
        return;
    end
    
    data_size=size(datav.value);
    if flag_resa==1                %------ if resample data----
        datav_new=datav;
        datav_new.value=datav.value(1:xpix:data_size(1),1:ypix:data_size(2),1:kpix:data_size(3),1:zpix:data_size(4));
        if isfield(datav, 'x') || isprop(datav, 'x')
            datav_new.x=datav.x(1:xpix:data_size(1));
        end
        if isfield(datav, 'y') || isprop(datav, 'y')
            datav_new.y=datav.y(1:ypix:data_size(2));
        end
        if isfield(datav, 'k') || isprop(datav, 'k')
            datav_new.k=datav.k(1:kpix:data_size(3));
        end
        if isfield(datav, 'z') || isprop(datav, 'z')
            datav_new.z=datav.z(1:zpix:data_size(4));
        end

        assignin('base',cat(2,var_name,'_resam'),datav_new);
        
    else                            %----- if combine data-----
        max_index(1)=floor(data_size(1)/xpix);
        max_index(2)=floor(data_size(2)/ypix);
        max_index(3)=floor(data_size(3)/kpix);
        max_index(4)=floor(data_size(4)/zpix);
%         datav_new=datav;
        clear value;
        clear value1;
        clear value2;
        clear value3;
        for i=1:max_index(1)
            value1(i,:,:,:)=sum(datav.value((i-1)*xpix+1:i*xpix,:,:,:),1);
            if isfield(datav, 'x')  || isprop(datav, 'x')
                datav_new.x(i)=mean(datav.x((i-1)*xpix+1:i*xpix));
            end
        end
        
        for i=1:max_index(2)
            value2(:,i,:,:)=sum(value1(:,(i-1)*ypix+1:i*ypix,:,:),2);
            if isfield(datav, 'y')  || isprop(datav, 'y')
                datav_new.y(i)=mean(datav.y((i-1)*ypix+1:i*ypix));
            end
        end
        
        for i=1:max_index(3)
            value3(:,:,i,:)=sum(value2(:,:,(i-1)*kpix+1:i*kpix,:),3);
            if isfield(datav, 'k') || isprop(datav, 'k')
                datav_new.k(i)=mean(datav.k((i-1)*kpix+1:i*kpix));
            end
        end
        for i=1:max_index(4)
            value(:,:,:,i)=sum(value3(:,:,:,(i-1)*zpix+1:i*zpix),4);
            if isfield(datav, 'z') || isprop(datav, 'z')
                datav_new.z(i)=mean(datav.z((i-1)*zpix+1:i*zpix));
            end
        end
        datav_new.value=value;
        assignin('base',cat(2,var_name,'_comb'),datav_new);
    end
end
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function k_pix_Callback(hObject, eventdata, handles)
% hObject    handle to k_pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k_pix as text
%        str2double(get(hObject,'String')) returns contents of k_pix as a double


% --- Executes during object creation, after setting all properties.
function k_pix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k_pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
