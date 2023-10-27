function varargout = ridge_detection(varargin)
% RIDGE_DETECTION MATLAB code for ridge_detection.fig
%      RIDGE_DETECTION, by itself, creates a new RIDGE_DETECTION or raises the existing
%      singleton*.
%
%      H = RIDGE_DETECTION returns the handle to a new RIDGE_DETECTION or the handle to
%      the existing singleton*.
%
%      RIDGE_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RIDGE_DETECTION.M with the given input arguments.
%
%      RIDGE_DETECTION('Property','Value',...) creates a new RIDGE_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ridge_detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ridge_detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ridge_detection

% Last Modified by GUIDE v2.5 28-Jul-2016 15:52:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ridge_detection_OpeningFcn, ...
                   'gui_OutputFcn',  @ridge_detection_OutputFcn, ...
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


% --- Executes just before ridge_detection is made visible.
function ridge_detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ridge_detection (see VARARGIN)

% Choose default command line output for ridge_detection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ridge_detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ridge_detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
calculate_from_handles(handles)


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function tol_Callback(hObject, eventdata, handles)
% hObject    handle to tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
calculate_from_handles(handles)


% --- Executes during object creation, after setting all properties.
function tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function thres_Callback(hObject, eventdata, handles)
% hObject    handle to thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
calculate_from_handles(handles)


% --- Executes during object creation, after setting all properties.
function thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
calculate_from_handles(handles)

% --- Executes on button press in cuda_use.
function cuda_use_Callback(hObject, eventdata, handles)
% hObject    handle to cuda_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cuda_use
calculate_from_handles(handles)

function calculate_from_handles(handles)
radius = handles.radius.Value;
tol = handles.tol.Value;
thres = handles.thres.Value;
gamma = handles.gamma.Value;
use_cuda = handles.cuda_use.Value;
set(handles.radius_value,'string',num2str(radius));
set(handles.tol_value,'string',num2str(tol));
set(handles.thres_value,'string',num2str(thres));
set(handles.gamma_value,'string',num2str(gamma));
data = getappdata(handles.figure1,'input_data');
delta_x = data.x(2) - data.x(1);
delta_y = data.y(2) - data.y(1);
value_new = detection(data.value, delta_x, delta_y, radius, tol, thres, gamma, use_cuda);
x_new=data.x(2:end-1);
y_new=data.y(2:end-1);
pcolor(handles.plot,x_new,y_new,value_new');
load('Colormap.mat');
colormap(gray);
if handles.equal_axis.Value == true
    axis equal;
end
axis tight;
shading interp;
data_new=data;
data_new.x=x_new;
data_new.y=y_new;
data_new.value=value_new;
setappdata(handles.figure1,'output_data',data_new);

function mat_ans = detection(mat_source, delta_x, delta_y, radius, tol, thres, gamma, use_cuda)
% Arguments:
% img_source: 2-dim mat, the source matrix data from ARPES slice;
% redius: int, radius of gaussian blur;
% tol: double, tolerence for ridge detection lpp equality check;
% thres: double, threshold for rejecting blunt ridges;
% gamma: double, gamma value to modulate the representation of the sharpness of ridge;
% cuda_use: bool, GPU array system enabled when true.

% Returns:
% mat_ans: 2-dim mat, the image of ridge.

% gaussian convolution to smooth the image
sigma = [radius / delta_x, radius / delta_y];
mat_smooth = imgaussfilt(mat2gray(mat_source), sigma);
% check cuda usage
if use_cuda == true
    mat_smooth = gpuArray(mat_smooth);
end
% generate the 3*3 moved matrix
[height, width] = size(mat_smooth);
map11 = mat_smooth(1:(end-2), 1:(end-2));
map12 = mat_smooth(1:(end-2), 2:(end-1));
map13 = mat_smooth(1:(end-2), 3:end    );
map21 = mat_smooth(2:(end-1), 1:(end-2));
map22 = mat_smooth(2:(end-1), 2:(end-1));
map23 = mat_smooth(2:(end-1), 3:end    );
map31 = mat_smooth(3:end    , 1:(end-2));
map32 = mat_smooth(3:end    , 2:(end-1));
map33 = mat_smooth(3:end    , 3:end    );
% calculate the numerical gradient
gradient_x = (map23 - map21) / (2.0 * delta_x);
gradient_y = (map12 - map32) / (2.0 * delta_y);
% calculate the numerical hessian
hessian_xx = (map23 + map21 - 2.0 * map22) / (delta_x ^ 2);
hessian_xy = (map13 + map31 - map33 - map11) / (4 * delta_x * delta_y);
hessian_yy = (map12 + map32 - 2.0 * map22) / (delta_y ^ 2);
% calculate the eigen direction of hessian matrix
cosine = (0.5 * (1.0 + (hessian_xx - hessian_yy) ./ (((hessian_xx - hessian_yy).^2 + 4.0 * hessian_xy .^ 2).^0.5))).^0.5;
sine = sign(hessian_xy) .* (1.0 - cosine .^2) .^0.5;
% diagonalization of hessian matrix
hessian_qq = cosine .* (hessian_xx .* cosine + hessian_xy .* sine) + sine .* (hessian_xy .* cosine + hessian_yy .* sine);
hessian_pp = sine .* (hessian_xx .* sine - hessian_xy .* cosine) - cosine .* (hessian_xy .* sine - hessian_yy .* cosine);
gradient_p = sine .* gradient_x - cosine .* gradient_y;
% compute the mat_ans
mat_relative = arrayfun(@ridge, gradient_p, hessian_pp, hessian_qq, ones(height - 2, width - 2) * tol, ones(height - 2,width - 2) * thres);
mat_ans = mat2gray(mat_relative).^gamma;

function pixel_relative_value = ridge(lp,lpp,lqq,tol,thres)
if abs(lp)<=tol && lpp<0 && abs(lpp)>=thres && abs(lpp)>abs(lqq)
    % the sharpness of the ridge is represented by |lpp|
    pixel_relative_value = abs(lpp);
else
    % none ridge region is set to black
    pixel_relative_value = 0;
end


% --- Executes on button press in equal_axis.
function equal_axis_Callback(hObject, eventdata, handles)
% hObject    handle to equal_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of equal_axis
calculate_from_handles(handles)


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get the operating data for 
names = getDataNames;
data = evalin('base',names{1});
setappdata(handles.figure1, 'input_data', data);
calculate_from_handles(handles)
set(handles.DataName,'String',names{1});

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=getappdata(handles.figure1,'output_data');
DataName=get(handles.DataName,'String');
SaveName=inputdlg({'Data Name'},...
    'ridge_detection',...
    1,...
    {[DataName,'_rd']});
if isempty(SaveName)
    return;
end
assignin('base',SaveName{1},data);


% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.figure1,'output_data');
[x_index, y_index] = find(data.value > 0);
ridge_points = struct('x', data.x(x_index),'y', data.y(y_index));
DataName=get(handles.DataName,'String');
SaveName=inputdlg({'Data Name'},...
    'ridge_detection',...
    1,...
    {[DataName,'_rp']});
if isempty(SaveName)
    return;
end
assignin('base',SaveName{1},ridge_points);


