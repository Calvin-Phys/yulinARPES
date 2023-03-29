function varargout = plotBZ_demo(varargin)
% plotBZ_demo MATLAB code for plotBZ_demo.fig
%      plotBZ_demo, by itself, creates a new plotBZ_demo or raises the existing
%      singleton*.
%
%      H = plotBZ_demo returns the handle to a new plotBZ_demo or the handle to
%      the existing singleton*.
%
%      plotBZ_demo('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in plotBZ_demo.M with the given input arguments.
%
%      plotBZ_demo('Property','Value',...) creates a new plotBZ_demo or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotBZ_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotBZ_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotBZ_demo

% Last Modified by GUIDE v2.5 13-Mar-2015 03:30:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotBZ_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @plotBZ_demo_OutputFcn, ...
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


% --- Executes just before plotBZ_demo is made visible.
function plotBZ_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotBZ_demo (see VARARGIN)

% Choose default command line output for plotBZ_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotBZ_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotBZ_demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function a_Callback(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a as text
%        str2double(get(hObject,'String')) returns contents of a as a double


% --- Executes during object creation, after setting all properties.
function a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b_Callback(hObject, eventdata, handles)
% hObject    handle to b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b as text
%        str2double(get(hObject,'String')) returns contents of b as a double


% --- Executes during object creation, after setting all properties.
function b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c_Callback(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c as text
%        str2double(get(hObject,'String')) returns contents of c as a double


% --- Executes during object creation, after setting all properties.
function c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beta_Callback(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beta as text
%        str2double(get(hObject,'String')) returns contents of beta as a double


% --- Executes during object creation, after setting all properties.
function beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
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



function kxstart_Callback(hObject, eventdata, handles)
% hObject    handle to kxstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kxstart as text
%        str2double(get(hObject,'String')) returns contents of kxstart as a double


% --- Executes during object creation, after setting all properties.
function kxstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kxstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in kxstartminus.
function kxstartminus_Callback(hObject, eventdata, handles)
% hObject    handle to kxstartminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kxstart,'String'));
temp=temp-1;
set(handles.kxstart,'String',num2str(temp));


% --- Executes on button press in kxstartplus.
function kxstartplus_Callback(hObject, eventdata, handles)
% hObject    handle to kxstartplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kxstart,'String'));
temp=temp+1;
set(handles.kxstart,'String',num2str(temp));


function kxend_Callback(hObject, eventdata, handles)
% hObject    handle to kxend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kxend as text
%        str2double(get(hObject,'String')) returns contents of kxend as a double


% --- Executes during object creation, after setting all properties.
function kxend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kxend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in kxendminus.
function kxendminus_Callback(hObject, eventdata, handles)
% hObject    handle to kxendminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kxend,'String'));
temp=temp-1;
set(handles.kxend,'String',num2str(temp));

% --- Executes on button press in kxendplus.
function kxendplus_Callback(hObject, eventdata, handles)
% hObject    handle to kxendplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kxend,'String'));
temp=temp+1;
set(handles.kxend,'String',num2str(temp));


function kystart_Callback(hObject, eventdata, handles)
% hObject    handle to kystart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kystart as text
%        str2double(get(hObject,'String')) returns contents of kystart as a double


% --- Executes during object creation, after setting all properties.
function kystart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kystart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in kystartminus.
function kystartminus_Callback(hObject, eventdata, handles)
% hObject    handle to kystartminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kystart,'String'));
temp=temp-1;
set(handles.kystart,'String',num2str(temp));

% --- Executes on button press in kystartplus.
function kystartplus_Callback(hObject, eventdata, handles)
% hObject    handle to kystartplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kystart,'String'));
temp=temp+1;
set(handles.kystart,'String',num2str(temp));


function kyend_Callback(hObject, eventdata, handles)
% hObject    handle to kyend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kyend as text
%        str2double(get(hObject,'String')) returns contents of kyend as a double


% --- Executes during object creation, after setting all properties.
function kyend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kyend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in kyendminus.
function kyendminus_Callback(hObject, eventdata, handles)
% hObject    handle to kyendminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kyend,'String'));
temp=temp-1;
set(handles.kyend,'String',num2str(temp));

% --- Executes on button press in kyendplus.
function kyendplus_Callback(hObject, eventdata, handles)
% hObject    handle to kyendplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kyend,'String'));
temp=temp+1;
set(handles.kyend,'String',num2str(temp));


function kzstart_Callback(hObject, eventdata, handles)
% hObject    handle to kzstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kzstart as text
%        str2double(get(hObject,'String')) returns contents of kzstart as a double


% --- Executes during object creation, after setting all properties.
function kzstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kzstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in kzstartminus.
function kzstartminus_Callback(hObject, eventdata, handles)
% hObject    handle to kzstartminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kzstart,'String'));
temp=temp-1;
set(handles.kzstart,'String',num2str(temp));

% --- Executes on button press in kzstartplus.
function kzstartplus_Callback(hObject, eventdata, handles)
% hObject    handle to kzstartplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kzstart,'String'));
temp=temp+1;
set(handles.kzstart,'String',num2str(temp));


function kzend_Callback(hObject, eventdata, handles)
% hObject    handle to kzend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kzend as text
%        str2double(get(hObject,'String')) returns contents of kzend as a double


% --- Executes during object creation, after setting all properties.
function kzend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kzend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in kzendminus.
function kzendminus_Callback(hObject, eventdata, handles)
% hObject    handle to kzendminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kzend,'String'));
temp=temp-1;
set(handles.kzend,'String',num2str(temp));

% --- Executes on button press in kzendplus.
function kzendplus_Callback(hObject, eventdata, handles)
% hObject    handle to kzendplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.kzend,'String'));
temp=temp+1;
set(handles.kzend,'String',num2str(temp));

% --- Executes on selection change in plane.
function plane_Callback(hObject, eventdata, handles)
% hObject    handle to plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plane contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plane


% --- Executes during object creation, after setting all properties.
function plane_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kvert_Callback(hObject, eventdata, handles)
% hObject    handle to kvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kvert as text
%        str2double(get(hObject,'String')) returns contents of kvert as a double


% --- Executes during object creation, after setting all properties.
function kvert_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kunit_Callback(hObject, eventdata, handles)
% hObject    handle to kunit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kunit as text
%        str2double(get(hObject,'String')) returns contents of kunit as a double


% --- Executes during object creation, after setting all properties.
function kunit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kunit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function figno_Callback(hObject, eventdata, handles)
% hObject    handle to figno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figno as text
%        str2double(get(hObject,'String')) returns contents of figno as a double


% --- Executes during object creation, after setting all properties.
function figno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_append.
function button_append_Callback(hObject, eventdata, handles)
% hObject    handle to button_append (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=str2double(get(handles.a,'String'));
b=str2double(get(handles.b,'String'));
c=str2double(get(handles.c,'String'));
lattice_type= get(handles.lattice_type,'Value');
alpha=str2num(get(handles.alpha,'String'));
beta=str2num(get(handles.beta,'String'));
gamma=str2num(get(handles.gamma,'String'));
omega=str2num(get(handles.omega,'String'));
unit=str2double(get(handles.kunit,'String'));
kxstart=str2num(get(handles.kxstart,'String'));
kxend=str2num(get(handles.kxend,'String'));
kystart=str2num(get(handles.kystart,'String'));
kyend=str2num(get(handles.kyend,'String'));
kzstart=str2num(get(handles.kzstart,'String'));
kzend=str2num(get(handles.kzend,'String'));
plane=get(handles.plane,'Value');
kcut_value=str2double(get(handles.kvert,'String'));
fig_no=str2num(get(handles.figno,'String'));
h=findobj('Tag','flash_k_space_conversion');
if get(handles.flashflag,'Value')&&~isempty(h)
    handles1=guidata(h);
    set(0,'CurrentFigure',h);
    set(h,'CurrentAxes',handles1.axes2);
    plotBZ_demo_old(a,b,c,lattice_type,alpha,beta,gamma,omega,unit,kxstart,kxend,kystart,kyend,kzstart,kzend,plane,kcut_value);
else
figure(fig_no);
hold on;
plotBZ_demo_old(a,b,c,lattice_type,alpha,beta,gamma,omega,unit,kxstart,kxend,kystart,kyend,kzstart,kzend,plane,kcut_value);
hold off;
end


% --- Executes on button press in button_plot.
function button_plot_Callback(hObject, eventdata, handles)
% hObject    handle to button_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=str2double(get(handles.a,'String'));
b=str2double(get(handles.b,'String'));
c=str2double(get(handles.c,'String'));
lattice_type= get(handles.lattice_type,'Value');
alpha=str2num(get(handles.alpha,'String'));
beta=str2num(get(handles.beta,'String'));
gamma=str2num(get(handles.gamma,'String'));
omega=str2num(get(handles.omega,'String'));
unit=str2double(get(handles.kunit,'String'));
kxstart=str2num(get(handles.kxstart,'String'));
kxend=str2num(get(handles.kxend,'String'));
kystart=str2num(get(handles.kystart,'String'));
kyend=str2num(get(handles.kyend,'String'));
kzstart=str2num(get(handles.kzstart,'String'));
kzend=str2num(get(handles.kzend,'String'));
plane=int8(get(handles.plane,'Value'));
kcut_value=str2double(get(handles.kvert,'String'));
fig_no=str2num(get(handles.figno,'String'));
figure(fig_no);
clf;
plotBZ_demo_old(a,b,c,lattice_type,alpha,beta,gamma,omega,unit,kxstart,kxend,kystart,kyend,kzstart,kzend,plane,kcut_value);



% --- Executes on key press with focus on kxstartplus and none of its controls.
function kxstartplus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kxstartplus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on kxstartminus and none of its controls.
function kxstartminus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kxstartminus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on key press with focus on kxendplus and none of its controls.
function kxendplus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kxendplus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on key press with focus on kxendminus and none of its controls.
function kxendminus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kxendminus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on kystartminus and none of its controls.
function kystartminus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kystartminus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on kystartplus and none of its controls.
function kystartplus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kystartplus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on kyendminus and none of its controls.
function kyendminus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kyendminus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on kyendplus and none of its controls.
function kyendplus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kyendplus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on kzstartminus and none of its controls.
function kzstartminus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kzstartminus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on key press with focus on kzstartplus and none of its controls.
function kzstartplus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kzstartplus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on kzendminus and none of its controls.
function kzendminus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kzendminus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on kzendplus and none of its controls.
function kzendplus_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kzendplus (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function y=plotBZ_demo_old(a,b,c,lattice_type,alpha,beta,gamma,omega,unit,kxstart,kxend,kystart,kyend,kzstart,kzend,plane,k_cutvalue)
%a,b,c is the lattice constant (in A), alpha, beta, gamma is the
%<ac,<bc,<ab, plot scale would be (pi/unit), so if unit=pi, plot unit would
%be 1/A. plane=1,2,3 plots (kyz,kxz,kxy) respectively. the plot starts with
%kxstart to kxend (kxend>kxstart),k_cutvalue is the k value perpendicular
%to the cutplane

alpha=alpha*pi/180;
beta=beta*pi/180;
gamma=gamma*pi/180;
omega=omega*pi/180;

w1 = cos(alpha) - cos(beta) * cos(gamma)/(sin(beta) * sin(gamma));
w2 = sin(gamma)^2 - cos(beta)^2 - cos(alpha)^2 ...
    + 2*cos(alpha) *cos(beta) * cos(gamma);
w2 = sqrt(w2) / (sin(beta) * sin(gamma));

switch lattice_type
    case 1 %Simple
T1_ori = [a, 0, 0];
T2_ori = [b * cos(gamma), b	* sin(gamma), 0];
T3_ori = [c * cos(beta), c * w1*sin(beta), c*w2*sin(beta)];
    case 2 %FCC cubic
T1_ori = [a/2,0,a/2];
T2_ori = [a/2,a/2,0];
T3_ori = [0,a/2,a/2];
    case 3 %BCC cubic
T1_ori = [a/2,a/2,-a/2];
T2_ori = [-a/2,a/2,a/2];
T3_ori = [a/2,-a/2,a/2];
    case 4 %Zinc Blende
T3_ori = [0,a/2,a/2];
T2_ori = [a/2,0,a/2];
T1_ori = [a/2,a/2,0];        
end

%rotate by omega degrees
T1(1)=T1_ori(1)*cos(omega)-T1_ori(2)*sin(omega);
T1(2)=T1_ori(1)*sin(omega)+T1_ori(2)*cos(omega);
T1(3)=T1_ori(3);

T2(1)=T2_ori(1)*cos(omega)-T2_ori(2)*sin(omega);
T2(2)=T2_ori(1)*sin(omega)+T2_ori(2)*cos(omega);
T2(3)=T2_ori(3);

T3(1)=T3_ori(1)*cos(omega)-T3_ori(2)*sin(omega);
T3(2)=T3_ori(1)*sin(omega)+T3_ori(2)*cos(omega);
T3(3)=T3_ori(3);

spat=cross(T1,T2)*T3';

G1=2*pi*cross(T2,T3)/spat;
G2=2*pi*cross(T3,T1)/spat;
G3=2*pi*cross(T1,T2)/spat;

unit_inv=pi/unit;
G1_plot=G1/unit_inv;
G2_plot=G2/unit_inv;
G3_plot=G3/unit_inv;

testpt1_all=0;
testpt2_all=0;
testpt3_all=0;

[testpt1_all,testpt2_all,testpt3_all]=generate_bz(G1_plot,G2_plot,G3_plot,kxstart,kxend,kystart,kyend,kzstart,kzend);

%bz_cut(testpt1_all,testpt2_all,testpt3_all,k_cutvalue,plane);

bz_cut_2d(testpt1_all,testpt2_all,testpt3_all,k_cutvalue,plane);



function y=bz_cut_2d(testpt1,testpt2,testpt3,z,choice);
%choice 1,kykz,2,kxkz,3,kxky
hold on;

switch choice;
    case 1
        choice_x=2;
        choice_y=3;
    case 2
        choice_x=1;
        choice_y=3;
    case 3
        choice_x=1;
        choice_y=2;
end

for i=1:size(testpt1,1)
pt(1,:)=testpt1(i,:);
pt(2,:)=testpt2(i,:);
pt(3,:)=testpt3(i,:);
%patch(pt(1,:),pt(2,:),pt(3,:),i,'FaceAlpha',.85);
pt=pt';

cross(1)=compare2num(z,pt(1,choice),1e-3)*compare2num(z,pt(2,choice),1e-3);
cross(2)=compare2num(z,pt(2,choice),1e-3)*compare2num(z,pt(3,choice),1e-3);
cross(3)=compare2num(z,pt(3,choice),1e-3)*compare2num(z,pt(1,choice),1e-3);

p1ind=[1;2;3];
p2ind=[2;3;1];

if sum(cross)<2.5
    
    jj=1;
    for j=1:3
        if cross(j)<1 
            if compare2num(pt(p1ind(j),choice),pt(p2ind(j),choice),1e-3)
           
            bzpt(jj,1)=interp1([pt(p1ind(j),choice),pt(p2ind(j),choice)],[pt(p1ind(j),choice_x),pt(p2ind(j),choice_x)],z);
            bzpt(jj,2)=interp1([pt(p1ind(j),choice),pt(p2ind(j),choice)],[pt(p1ind(j),choice_y),pt(p2ind(j),choice_y)],z);
            else
                 bzpt(jj,1)=pt(p1ind(j),choice_x);
                 bzpt(jj,2)=pt(p1ind(j),choice_y);
                line([pt(p1ind(j),choice_x),pt(p2ind(j),choice_x)],[pt(p1ind(j),choice_y),pt(p2ind(j),choice_y)]);
                   
                
            end
            jj=jj+1;
                      
        end
    end
  
    if size(bzpt,1)==1
    line([bzpt(1,1),bzpt(1,1)],[bzpt(1,2),bzpt(1,2)]);
    end
    if size(bzpt,1)==2
    line([bzpt(1,1),bzpt(2,1)],[bzpt(1,2),bzpt(2,2)]);
    end
    if size(bzpt,1)==3
    line([bzpt(1,1),bzpt(2,1)],[bzpt(1,2),bzpt(2,2)]);
    line([bzpt(2,1),bzpt(3,1)],[bzpt(2,2),bzpt(3,2)]);
    line([bzpt(3,1),bzpt(1,1)],[bzpt(3,2),bzpt(1,2)]);
    end
    
    
    end
clear bzpt;    
end
hold off;
    
function [testpt1_all,testpt2_all,testpt3_all]=generate_bz(G1,G2,G3,kx_start,kx_end,ky_start,ky_end,kz_start,kz_end)
loop=1;
for i1=kx_start:kx_end
    for i2=ky_start:ky_end
        for i3=kz_start:kz_end
            
X = zeros(125,3);
l=1;

hold on;
for i=-2+i1:2+i1;
    for j=-2+i2:2+i2;
        for k=-2+i3:2+i3;
            X(l,:)=i*G1+j*G2+k*G3;
            l=l+1;
            
            
        end
    end
end
[c,v] = voronoin(X);

            nx = c(v{63},:);
        tri = convhulln(nx);
        clear testpt1 testpt2 testpt3;
        for ii=1:size(tri,1)
            testpt1(ii,:)=nx(tri(ii,:),1);
            testpt2(ii,:)=nx(tri(ii,:),2);
            testpt3(ii,:)=nx(tri(ii,:),3);
        end
        
        if loop==1
            testpt1_all=testpt1;
            testpt2_all=testpt2;
            testpt3_all=testpt3;
        else
            testpt1_all=[testpt1_all;testpt1];
            testpt2_all=[testpt2_all;testpt2];
            testpt3_all=[testpt3_all;testpt3];
        end
  
     loop=loop+1;

        end
    end
end
hold off;

function y=compare2num(a,b,thres)
if abs(a-b)<thres
    y=0;
else if (a-b)<0
        y=-1;
    else
        y=1;
    end
end



function omega_Callback(hObject, eventdata, handles)
% hObject    handle to omega (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of omega as text
%        str2double(get(hObject,'String')) returns contents of omega as a double


% --- Executes during object creation, after setting all properties.
function omega_CreateFcn(hObject, eventdata, handles)
% hObject    handle to omega (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lattice_type.
function lattice_type_Callback(hObject, eventdata, handles)
% hObject    handle to lattice_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lattice_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lattice_type


% --- Executes during object creation, after setting all properties.
function lattice_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lattice_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flashflag.
function flashflag_Callback(hObject, eventdata, handles)
% hObject    handle to flashflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flashflag
