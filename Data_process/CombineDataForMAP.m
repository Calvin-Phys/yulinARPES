function varargout = CombineDataForMAP(varargin)
% COMBINEDATAFORMAP MATLAB code for CombineDataForMAP.fig
%      COMBINEDATAFORMAP, by itself, creates a new COMBINEDATAFORMAP or raises the existing
%      singleton*.
%
%      H = COMBINEDATAFORMAP returns the handle to a new COMBINEDATAFORMAP or the handle to
%      the existing singleton*.
%
%      COMBINEDATAFORMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMBINEDATAFORMAP.M with the given input arguments.
%
%      COMBINEDATAFORMAP('Property','Value',...) creates a new COMBINEDATAFORMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CombineDataForMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CombineDataForMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CombineDataForMAP

% Last Modified by GUIDE v2.5 26-Nov-2019 17:54:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CombineDataForMAP_OpeningFcn, ...
                   'gui_OutputFcn',  @CombineDataForMAP_OutputFcn, ...
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


% --- Executes just before CombineDataForMAP is made visible.
function CombineDataForMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CombineDataForMAP (see VARARGIN)

% Choose default command line output for CombineDataForMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CombineDataForMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CombineDataForMAP_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in combine.
function combine_Callback(hObject, eventdata, handles)
% hObject    handle to combine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');

%get var_name and check
for i = 1:size(index_selected,2)
    var_name{i} = list_entries{index_selected(i)};
    dataincheck = evalin('base',var_name{i});
    if ~isstruct(dataincheck)
        errordlg(['data ',num2str(i), ' is not struct'])
        return;
    elseif (~(isfield(dataincheck,'x') && isfield(dataincheck,'y') && isfield(dataincheck,'z') && isfield(dataincheck,'value')))
        errordlg('data ', num2str(i),' is wrong. Data needs at least x,y,z,value field');
        return;
    end
end

% put the first file
dataout = evalin('base',var_name{1});

for i = 2:size(index_selected,2)
    datain = evalin('base',var_name{i});
    if length(dataout.y) == length(datain.y)
        datain.x=round(datain.x,1); %rounds to 0.1 to avoid rounding error artefacts
        dataout.x=round(dataout.x,1);
        %[~,di,do]=intersect(datain.x,dataout.x); %detects overlapping
        %data.x scales, could be used to merge overlapping pieces in future
        %releases
        dataout.x = cat(2,dataout.x, datain.x);
        dataout.value = cat(1,dataout.value,datain.value);
    else
    if length(dataout.x) == length(datain.x)
        datain.y=round(datain.y,1); %rounds to 0.1 to avoid rounding error artefacts
        dataout.y=round(dataout.y,1);
        %[~,di,do]=intersect(datain.x,dataout.x); %detects overlapping
        %data.x scales, could be used to merge overlapping pieces in future
        %releases
        dataout.y = cat(2,dataout.y, datain.y);
        dataout.value = cat(2,dataout.value,datain.value);
    else
        errordlg(['data ',num2str(i),' has not the same y scale'])
    end
    end
end

[dataout.x,I] = sort(dataout.x);
dataout.value = dataout.value(I,:,:);

var_name_out='combinedMAP';
assignin('base',var_name_out,dataout);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox1.
function listbox1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
