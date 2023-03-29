function varargout = ridge_detection_3(varargin)
% RIDGE_DETECTION_3 MATLAB code for ridge_detection_3.fig
%      RIDGE_DETECTION_3, by itself, creates a new RIDGE_DETECTION_3 or raises the existing
%      singleton*.
%
%      H = RIDGE_DETECTION_3 returns the handle to a new RIDGE_DETECTION_3 or the handle to
%      the existing singleton*.
%
%      RIDGE_DETECTION_3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RIDGE_DETECTION_3.M with the given input arguments.
%
%      RIDGE_DETECTION_3('Property','Value',...) creates a new RIDGE_DETECTION_3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ridge_detection_3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ridge_detection_3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ridge_detection_3

% Last Modified by GUIDE v2.5 24-Aug-2016 15:53:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ridge_detection_3_OpeningFcn, ...
                   'gui_OutputFcn',  @ridge_detection_3_OutputFcn, ...
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


% --- Executes just before ridge_detection_3 is made visible.
function ridge_detection_3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ridge_detection_3 (see VARARGIN)

% Choose default command line output for ridge_detection_3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ridge_detection_3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = ridge_detection_3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
names = getDataNames;
data = evalin('base',names{1});
setappdata(handles.figure1, 'input_data', data);
set(handles.data_name,'String',names{1});
set(handles.process, 'String', 'Ready')

% --- Executes on button press in detect.
function detect_Callback(hObject, eventdata, handles)
% hObject    handle to detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get params from the panel
radius = str2double(handles.radius.String);
tol = str2double(handles.tol.String);
thres = str2double(handles.thres.String);
gamma = str2double(handles.gamma.String);
use_cuda = str2double(handles.use_cuda.Value);
% get source data to process
data = getappdata(handles.figure1,'input_data');
data_name = get(handles.data_name,'String');
% detecting ridge
set(handles.process, 'String', 'Detecting');
data_ans = ridge_detection_3_standalone(data, radius, tol, thres, gamma, use_cuda);
set(handles.process, 'String', 'Saving');
% dialog for saving
save_name = inputdlg({'Data Name'},...
    'Ridge Detection Data Saving',...
    1,...
    {[data_name,'_rd']});
if isempty(save_name)
    return;
end
assignin('base', save_name{1}, data_ans);
set(handles.process, 'String', 'Done')



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma as text
%        str2double(get(hObject,'String')) returns contents of gamma as a double


% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tol_Callback(hObject, eventdata, handles)
% hObject    handle to tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol as text
%        str2double(get(hObject,'String')) returns contents of tol as a double


% --- Executes during object creation, after setting all properties.
function tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres_Callback(hObject, eventdata, handles)
% hObject    handle to thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres as text
%        str2double(get(hObject,'String')) returns contents of thres as a double


% --- Executes during object creation, after setting all properties.
function thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function data_ans = ridge_detection_3_standalone(data,...
    radius, tol, thres, gamma, use_cuda)
% Arguments:
% data: struct, the std data structure of chen group;
% radius: int, radius of gaussian blur, number in k space;
% tol: double, tolerence for ridge detection equality check;
% thres: double, threshold for rejecting blunt ridges;
% gamma: double, gamma value to modulate the representation of the sharpness of ridge;

% Returns:
% data_ans: struct, the std data structure of chen group;

% gaussian convolution to smooth the image
mat_source = data.value;
delta_x = abs(data.x(2) - data.x(1));
delta_y = abs(data.y(2) - data.y(1));
delta_z = abs(data.z(2) - data.z(1));
if use_cuda == true
    mat_source = gpuArray(double(mat_source));
else
    mat_source = double(mat_source);
end
sigma = [radius / delta_x, radius / delta_y, radius / delta_z];
mat_smooth = imgaussfilt3(mat2gray(mat_source), sigma);
% generate the 3*3*3 moved matrix
% the commented lines are moved matrix not in use
[x_index_max, y_index_max, z_index_max] = size(mat_smooth);
% map111 = mat_smooth( 1:(end-2), 1:(end-2), 1:(end-2) );
map112 = mat_smooth( 1:(end-2), 1:(end-2), 2:(end-1) );
% map113 = mat_smooth( 1:(end-2), 1:(end-2), 3:(end-0) );
map121 = mat_smooth( 1:(end-2), 2:(end-1), 1:(end-2) );
map122 = mat_smooth( 1:(end-2), 2:(end-1), 2:(end-1) );
map123 = mat_smooth( 1:(end-2), 2:(end-1), 3:(end-0) );
% map131 = mat_smooth( 1:(end-2), 3:(end-0), 1:(end-2) );
map132 = mat_smooth( 1:(end-2), 3:(end-0), 2:(end-1) );
% map133 = mat_smooth( 1:(end-2), 3:(end-0), 3:(end-0) );
map211 = mat_smooth( 2:(end-1), 1:(end-2), 1:(end-2) );
map212 = mat_smooth( 2:(end-1), 1:(end-2), 2:(end-1) );
map213 = mat_smooth( 2:(end-1), 1:(end-2), 3:(end-0) );
map221 = mat_smooth( 2:(end-1), 2:(end-1), 1:(end-2) );
map222 = mat_smooth( 2:(end-1), 2:(end-1), 2:(end-1) );
map223 = mat_smooth( 2:(end-1), 2:(end-1), 3:(end-0) );
map231 = mat_smooth( 2:(end-1), 3:(end-0), 1:(end-2) );
map232 = mat_smooth( 2:(end-1), 3:(end-0), 2:(end-1) );
map233 = mat_smooth( 2:(end-1), 3:(end-0), 3:(end-0) );
% map311 = mat_smooth( 3:(end-0), 1:(end-2), 1:(end-2) );
map312 = mat_smooth( 3:(end-0), 1:(end-2), 2:(end-1) );
% map313 = mat_smooth( 3:(end-0), 1:(end-2), 3:(end-0) );
map321 = mat_smooth( 3:(end-0), 2:(end-1), 1:(end-2) );
map322 = mat_smooth( 3:(end-0), 2:(end-1), 2:(end-1) );
map323 = mat_smooth( 3:(end-0), 2:(end-1), 3:(end-0) );
% map331 = mat_smooth( 3:(end-0), 3:(end-0), 1:(end-2) );
map332 = mat_smooth( 3:(end-0), 3:(end-0), 2:(end-1) );
% map333 = mat_smooth( 3:(end-0), 3:(end-0), 3:(end-0) );
% calculate the numerical gradient
gradient_x = (map322 - map122) / (2.0 * delta_x);
gradient_y = (map232 - map212) / (2.0 * delta_y);
gradient_z = (map223 - map221) / (2.0 * delta_z);
% calculate the numerical hessian
hessian_xx = (map322 + map122 - 2.0 * map222) / (delta_x ^ 2);
hessian_yy = (map232 + map212 - 2.0 * map222) / (delta_y ^ 2);
hessian_zz = (map223 + map221 - 2.0 * map222) / (delta_z ^ 2);
hessian_xy = (map332 + map112 - map132 - map312) / (4 * delta_x * delta_y);
hessian_xz = (map323 + map121 - map123 - map321) / (4 * delta_x * delta_z);
hessian_yz = (map233 + map211 - map213 - map231) / (4 * delta_y * delta_z);
% compute the mat_ans in a parallel way
mat_relative = zeros(x_index_max - 2, y_index_max - 2, z_index_max - 2);
tol_mat_slice = ones(x_index_max - 2, y_index_max - 2) * tol;
thres_mat_slice = ones(x_index_max - 2, y_index_max - 2) * thres;
parfor k = 1:(z_index_max - 2)
    mat_relative(:,:,k) = arrayfun(@is_ridge,...
    gradient_x(:,:,k), gradient_y(:,:,k), gradient_z(:,:,k),...
    hessian_xx(:,:,k), hessian_yy(:,:,k), hessian_zz(:,:,k),...
    hessian_xy(:,:,k), hessian_xz(:,:,k), hessian_yz(:,:,k),...
    tol_mat_slice, thres_mat_slice);
end
% gamma modulation
mat_ans = mat2gray(mat_relative).^gamma;
% construct data struct
data_ans.value = mat_ans;
data_ans.x = data.x(2:(end-1));
data_ans.y = data.y(2:(end-1));
data_ans.z = data.z(2:(end-1));

% function to check the ridge condition
function pixel_value = is_ridge(gradient_x, gradient_y, gradient_z,...
    hessian_xx, hessian_yy, hessian_zz,...
    hessian_xy, hessian_xz, hessian_yz,...
    tol, thres)
hessian = [hessian_xx, hessian_xy, hessian_xz;...
           hessian_xy, hessian_yy, hessian_yz;...
           hessian_xz, hessian_yz, hessian_zz];
gradient = [gradient_x, gradient_y, gradient_z];
[eigenvectors, diagonal_mat] = eig(hessian);
eigenvalues = diag(diagonal_mat);
if eigenvalues(1) < 0 && abs(gradient * eigenvectors(:,1))<tol && abs(eigenvalues(1)) > thres
    pixel_value = abs(eigenvalues(1));
else
    pixel_value = 0;
end


% --- Executes on button press in use_cuda.
function use_cuda_Callback(hObject, eventdata, handles)
% hObject    handle to use_cuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_cuda
