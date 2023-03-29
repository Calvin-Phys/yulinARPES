function varargout = add_two_value_arrays(varargin)
% ADD_TWO_VALUE_ARRAYS MATLAB code for add_two_value_arrays.fig
%      ADD_TWO_VALUE_ARRAYS, by itself, creates a new ADD_TWO_VALUE_ARRAYS or raises the existing
%      singleton*.
%
%      H = ADD_TWO_VALUE_ARRAYS returns the handle to a new ADD_TWO_VALUE_ARRAYS or the handle to
%      the existing singleton*.
%
%      ADD_TWO_VALUE_ARRAYS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADD_TWO_VALUE_ARRAYS.M with the given input arguments.
%
%      ADD_TWO_VALUE_ARRAYS('Property','Value',...) creates a new ADD_TWO_VALUE_ARRAYS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before add_two_value_arrays_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to add_two_value_arrays_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help add_two_value_arrays

% Last Modified by GUIDE v2.5 12-Mar-2017 19:20:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @add_two_value_arrays_OpeningFcn, ...
                   'gui_OutputFcn',  @add_two_value_arrays_OutputFcn, ...
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


% --- Executes just before add_two_value_arrays is made visible.
function add_two_value_arrays_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to add_two_value_arrays (see VARARGIN)

% Choose default command line output for add_two_value_arrays
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes add_two_value_arrays wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = add_two_value_arrays_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;

data1=evalin('base',var_name{1});
data2=evalin('base',var_name{2});

data1.value=data1.value+data2.value;
% data1.info1=data1.info;
% data1.info2=data2.info;

var_name_out= inputdlg('enter combined file name','file name',1,{[var_name{1} '_add']});
assignin('base',var_name_out{1},data1);    
