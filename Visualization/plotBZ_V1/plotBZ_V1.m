function varargout = plotBZ_V1(varargin)
%PLOTBZ_V1 M-file for plotBZ_V1.fig
%      PLOTBZ_V1, by itself, creates a new PLOTBZ_V1 or raises the existing
%      singleton*.
%
%      H = PLOTBZ_V1 returns the handle to a new PLOTBZ_V1 or the handle to
%      the existing singleton*.
%
%      PLOTBZ_V1('Property','Value',...) creates a new PLOTBZ_V1 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to plotBZ_V1_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      PLOTBZ_V1('CALLBACK') and PLOTBZ_V1('CALLBACK',hObject,...) call the
%      local function named CALLBACK in PLOTBZ_V1.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotBZ_V1

% Last Modified by GUIDE v2.5 15-Jan-2024 15:17:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotBZ_V1_OpeningFcn, ...
                   'gui_OutputFcn',  @plotBZ_V1_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before plotBZ_V1 is made visible.
function plotBZ_V1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for plotBZ_V1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotBZ_V1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotBZ_V1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in LatticeClass.
function LatticeClass_Callback(hObject, eventdata, handles)
% hObject    handle to LatticeClass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LatticeClass contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LatticeClass
LatticeClass_val = get(handles.LatticeClass,'Value');
LatticeClass_str = get(handles.LatticeClass,'String');
LatticeClass = LatticeClass_str{LatticeClass_val};
switch LatticeClass
    case 'Cubic'
        set(handles.radio_primitive,'Value',1,'Enable','on');
        set(handles.radio_bodycentered,'Enable','on');
        set(handles.radio_facecentered,'Enable','on');
        set(handles.radio_basecentered,'Enable','off');
        set(handles.a,'Enable','on');
        set(handles.b,'String',get(handles.a,'String'),'Enable','off');
        set(handles.c,'String',get(handles.a,'String'),'Enable','off');
        set(handles.alpha,'String','90','Enable','off');
        set(handles.beta,'String','90','Enable','off');
        set(handles.gamma,'String','90','Enable','off');
    case 'Tetragonal'
        set(handles.radio_primitive,'Value',1,'Enable','on');
        set(handles.radio_bodycentered,'Enable','on');
        set(handles.radio_facecentered,'Enable','off');
        set(handles.radio_basecentered,'Enable','off');
        set(handles.a,'Enable','on');
        set(handles.b,'String',get(handles.a,'String'),'Enable','off');
        set(handles.c,'Enable','on');
        set(handles.alpha,'String','90','Enable','off');
        set(handles.beta,'String','90','Enable','off');
        set(handles.gamma,'String','90','Enable','off');
    case 'Orthorhombic'
        set(handles.radio_primitive,'Value',1,'Enable','on');
        set(handles.radio_bodycentered,'Enable','on');
        set(handles.radio_facecentered,'Enable','on');
        set(handles.radio_basecentered,'Enable','on');
        set(handles.a,'Enable','on');
        set(handles.b,'Enable','on');
        set(handles.c,'Enable','on');
        set(handles.alpha,'String','90','Enable','off');
        set(handles.beta,'String','90','Enable','off');
        set(handles.gamma,'String','90','Enable','off');
    case 'Hexagonal'
        set(handles.radio_primitive,'Value',1,'Enable','on');
        set(handles.radio_bodycentered,'Enable','off');
        set(handles.radio_facecentered,'Enable','off');
        set(handles.radio_basecentered,'Enable','off');
        set(handles.a,'Enable','on');
        set(handles.b,'String',get(handles.a,'String'),'Enable','off');
        set(handles.c,'Enable','on');
        set(handles.alpha,'String','90','Enable','off');
        set(handles.beta,'String','90','Enable','off');
        set(handles.gamma,'String','120','Enable','off');
    case 'Rhombohedral'
        set(handles.radio_primitive,'Value',1,'Enable','on');
        set(handles.radio_bodycentered,'Enable','off');
        set(handles.radio_facecentered,'Enable','off');
        set(handles.radio_basecentered,'Enable','off');
        set(handles.a,'Enable','on');
        set(handles.b,'String',get(handles.a,'String'),'Enable','off');
        set(handles.c,'String',get(handles.a,'String'),'Enable','off');
        set(handles.alpha,'Enable','on');
        set(handles.beta,'String',get(handles.alpha,'String'),'Enable','off');
        set(handles.gamma,'String',get(handles.alpha,'String'),'Enable','off');
    case 'Monoclinic'
        set(handles.radio_primitive,'Value',1,'Enable','on');
        set(handles.radio_bodycentered,'Enable','off');
        set(handles.radio_facecentered,'Enable','off');
        set(handles.radio_basecentered,'Enable','on');
        set(handles.a,'Enable','on');
        set(handles.b,'Enable','on');
        set(handles.c,'Enable','on');
        set(handles.alpha,'String','90','Enable','off');
        set(handles.beta,'Enable','on');
        set(handles.gamma,'String','90','Enable','off');
    case 'Triclinic'
        set(handles.radio_primitive,'Value',1,'Enable','on');
        set(handles.radio_bodycentered,'Enable','off');
        set(handles.radio_facecentered,'Enable','off');
        set(handles.radio_basecentered,'Enable','off');
        set(handles.a,'Enable','on');
        set(handles.b,'Enable','on');
        set(handles.c,'Enable','on');
        set(handles.alpha,'Enable','on');
        set(handles.beta,'Enable','on');
        set(handles.gamma,'Enable','on');
    otherwise
        return;
end

% --- Executes during object creation, after setting all properties.
function LatticeClass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LatticeClass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double
LatticeClass_val = get(handles.LatticeClass,'Value');
LatticeClass_str = get(handles.LatticeClass,'String');
LatticeClass = LatticeClass_str{LatticeClass_val};
if strcmp(LatticeClass,'Rhombohedral')
        set(findobj(handles.uipanel_cellangle,'Enable','off'),'String',get(hObject,'String'));
else
    return;
end


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



function a_Callback(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a as text
%        str2double(get(hObject,'String')) returns contents of a as a double
set(findobj(handles.uipanel_Celllength,'Enable','off'),'String',get(hObject,'String'));

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



function rot2DpBZ_Callback(hObject, eventdata, handles)
% hObject    handle to rot2DpBZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot2DpBZ as text
%        str2double(get(hObject,'String')) returns contents of rot2DpBZ as a double


% --- Executes during object creation, after setting all properties.
function rot2DpBZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot2DpBZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function shi2DhBZ_Callback(hObject, eventdata, handles)
% hObject    handle to shi2DhBZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shi2DhBZ as text
%        str2double(get(hObject,'String')) returns contents of shi2DhBZ as a double


% --- Executes during object creation, after setting all properties.
function shi2DhBZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shi2DhBZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rot3DBZ_Callback(hObject, eventdata, handles)
% hObject    handle to rot3DBZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot3DBZ as text
%        str2double(get(hObject,'String')) returns contents of rot3DBZ as a double


% --- Executes during object creation, after setting all properties.
function rot3DBZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot3DBZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in KxStartdown.
function KxStartdown_Callback(hObject, eventdata, handles)
% hObject    handle to KxStartdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2double(get(handles.KxStart,'String'));
temp=temp-1;
set(handles.KxStart,'String',num2str(temp));

% --- Executes on button press in KxStartup.
function KxStartup_Callback(hObject, eventdata, handles)
% hObject    handle to KxStartup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KxStart,'String'));
temp=temp+1;
set(handles.KxStart,'String',num2str(temp));


function KxStart_Callback(hObject, eventdata, handles)
% hObject    handle to KxStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KxStart as text
%        str2double(get(hObject,'String')) returns contents of KxStart as a double


% --- Executes during object creation, after setting all properties.
function KxStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KxStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in KxEnddown.
function KxEnddown_Callback(hObject, eventdata, handles)
% hObject    handle to KxEnddown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KxEnd,'String'));
temp=temp-1;
set(handles.KxEnd,'String',num2str(temp));

% --- Executes on button press in KxEndup.
function KxEndup_Callback(hObject, eventdata, handles)
% hObject    handle to KxEndup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KxEnd,'String'));
temp=temp+1;
set(handles.KxEnd,'String',num2str(temp));


function KxEnd_Callback(hObject, eventdata, handles)
% hObject    handle to KxEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KxEnd as text
%        str2double(get(hObject,'String')) returns contents of KxEnd as a double


% --- Executes during object creation, after setting all properties.
function KxEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KxEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in KyStartdown.
function KyStartdown_Callback(hObject, eventdata, handles)
% hObject    handle to KyStartdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KyStart,'String'));
temp=temp-1;
set(handles.KyStart,'String',num2str(temp));

% --- Executes on button press in KyStartup.
function KyStartup_Callback(hObject, eventdata, handles)
% hObject    handle to KyStartup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KyStart,'String'));
temp=temp+1;
set(handles.KyStart,'String',num2str(temp));


function KyStart_Callback(hObject, eventdata, handles)
% hObject    handle to KyStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KyStart as text
%        str2double(get(hObject,'String')) returns contents of KyStart as a double


% --- Executes during object creation, after setting all properties.
function KyStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KyStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in KzStartdown.
function KzStartdown_Callback(hObject, eventdata, handles)
% hObject    handle to KzStartdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KzStart,'String'));
temp=temp-1;
set(handles.KzStart,'String',num2str(temp));

% --- Executes on button press in KzStartup.
function KzStartup_Callback(hObject, eventdata, handles)
% hObject    handle to KzStartup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KzStart,'String'));
temp=temp+1;
set(handles.KzStart,'String',num2str(temp));


function KzStart_Callback(hObject, eventdata, handles)
% hObject    handle to KzStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KzStart as text
%        str2double(get(hObject,'String')) returns contents of KzStart as a double


% --- Executes during object creation, after setting all properties.
function KzStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KzStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in KyEnddown.
function KyEnddown_Callback(hObject, eventdata, handles)
% hObject    handle to KyEnddown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KyEnd,'String'));
temp=temp-1;
set(handles.KyEnd,'String',num2str(temp));

% --- Executes on button press in KyEndup.
function KyEndup_Callback(hObject, eventdata, handles)
% hObject    handle to KyEndup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KyEnd,'String'));
temp=temp+1;
set(handles.KyEnd,'String',num2str(temp));


function KyEnd_Callback(hObject, eventdata, handles)
% hObject    handle to KyEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KyEnd as text
%        str2double(get(hObject,'String')) returns contents of KyEnd as a double


% --- Executes during object creation, after setting all properties.
function KyEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KyEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in KzEnddown.
function KzEnddown_Callback(hObject, eventdata, handles)
% hObject    handle to KzEnddown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KzEnd,'String'));
temp=temp-1;
set(handles.KzEnd,'String',num2str(temp));

% --- Executes on button press in KzEndup.
function KzEndup_Callback(hObject, eventdata, handles)
% hObject    handle to KzEndup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.KzEnd,'String'));
temp=temp+1;
set(handles.KzEnd,'String',num2str(temp));


function KzEnd_Callback(hObject, eventdata, handles)
% hObject    handle to KzEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KzEnd as text
%        str2double(get(hObject,'String')) returns contents of KzEnd as a double


% --- Executes during object creation, after setting all properties.
function KzEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KzEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SurfBZ_clear.
function SurfBZ_clear_Callback(hObject, eventdata, handles)
% hObject    handle to SurfBZ_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SurfBZ_fig=str2double(get(handles.SurfBZ_fig,'String'));
h_axes=figure(SurfBZ_fig);
h1=findobj(h_axes,'Type','Line'); 
delete(h1);


% --- Executes on button press in SurfBZ_plot.
function SurfBZ_plot_Callback(hObject, eventdata, handles)
% hObject    handle to SurfBZ_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SurfBZ_fig = str2double(get(handles.SurfBZ_fig,'String'));
SurfBZ_color_val = get(handles.SurfBZ_color,'Value');
switch SurfBZ_color_val
    case 1
        SurfBZ_color = 'k';
    case 2
        SurfBZ_color = 'b';
    case 3
        SurfBZ_color = 'c';
    case 4
        SurfBZ_color = 'g';
    case 5
        SurfBZ_color = 'm';
    case 6
        SurfBZ_color = 'r';
    case 7
        SurfBZ_color = 'y';
    case 8
        SurfBZ_color = 'w';
end
[b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl] = plotBZ_V1_construct_rec_lattice_vectors(handles);
[s1,s2] = plotBZ_V1_surface_realtime_vector(b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl,handles);
[surf_rec_lattice_coordinates,surf_rec_lattice_rows] = plotBZ_V1_construct_surf_rec_lattice(s1,s2,handles);
[v,c]=voronoin(surf_rec_lattice_coordinates);

ln = str2num(get(handles.edit93,'String'));

ff = figure(SurfBZ_fig);
ax = gca;
xl = xlim;
yl = ylim;

for ii=surf_rec_lattice_rows
        figure(SurfBZ_fig);
        vertices = v(c{ii},:);
        K=convhull(vertices);
        drawPolygon(vertices(K,:),'Linewidth',ln,'Color',SurfBZ_color);
end

if ~(isequal(xl,[0 1]) && isequal(yl,[0 1]))
    ff = figure(SurfBZ_fig);
    ax = gca;
    xlim(ax,xl);
    ylim(ax,yl);
else
    axis equal;
end

%  xlabel('Kx');ylabel('Ky');
%  axis equal;
 







function SurfBZ_fig_Callback(hObject, eventdata, handles)
% hObject    handle to SurfBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SurfBZ_fig as text
%        str2double(get(hObject,'String')) returns contents of SurfBZ_fig as a double


% --- Executes during object creation, after setting all properties.
function SurfBZ_fig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SurfBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SurfBZ_color.
function SurfBZ_color_Callback(hObject, eventdata, handles)
% hObject    handle to SurfBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SurfBZ_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SurfBZ_color


% --- Executes during object creation, after setting all properties.
function SurfBZ_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SurfBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TwoDpBZ_plot.
function TwoDpBZ_plot_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDpBZ_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TwoDpBZ_fig = str2double(get(handles.TwoDpBZ_fig,'String'));
TwoDpBZ_color_val = get(handles.TwoDpBZ_color,'Value');
switch TwoDpBZ_color_val
    case 1
        TwoDpBZ_color = 'k';
    case 2
        TwoDpBZ_color = 'b';
    case 3
        TwoDpBZ_color = 'c';
    case 4
        TwoDpBZ_color = 'g';
    case 5
        TwoDpBZ_color = 'm';
    case 6
        TwoDpBZ_color = 'r';
    case 7
        TwoDpBZ_color = 'y';
    case 8
        TwoDpBZ_color = 'w';
end

ln = str2num(get(handles.edit91,'String'));

[b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl] = plotBZ_V1_construct_rec_lattice_vectors(handles);
[b1_prim,b2_prim,b3_prim,g_hkl] = plotBZ_V1_bulk_realtime_vector(b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl,handles);
[rec_lattice_coordinates,rec_lattice_rows] = plotBZ_V1_construct_bulk_rec_lattice(b1_prim,b2_prim,b3_prim,handles);
rot2DpBZ = str2double(get(handles.rot2DpBZ,'String'));
rot2DpBZ_inplane = str2double(get(handles.rot2DpBZ_inplane,'String'));
perpendicular_plane = createPlane([0 0 0], (rotz(rot2DpBZ)*rotx(90)*g_hkl')');
[v,c]=voronoin(rec_lattice_coordinates);

ff = figure(TwoDpBZ_fig);
ax = gca;
xl = xlim;
yl = ylim;

for ii=rec_lattice_rows
    vertices = v(c{ii},:);
    K = convhull(vertices,'simplify',true); 
    faces = mergeCoplanarFaces(vertices, K);    
    plotBZ_V1_intersectBZ(vertices,faces,perpendicular_plane,rot2DpBZ_inplane,0,TwoDpBZ_fig,'Linewidth',ln,'Color',TwoDpBZ_color);
end

if ~(isequal(xl,[0 1]) && isequal(yl,[0 1]))
    ff = figure(TwoDpBZ_fig);
    ax = gca;
    xlim(ax,xl);
    ylim(ax,yl);
else
    axis equal;
end
%  xlabel('Kz');ylabel('Ky');
%  axis equal;



function TwoDhBZ_fig_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDhBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TwoDhBZ_fig as text
%        str2double(get(hObject,'String')) returns contents of TwoDhBZ_fig as a double


% --- Executes during object creation, after setting all properties.
function TwoDhBZ_fig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TwoDhBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TwoDhBZ_color.
function TwoDhBZ_color_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDhBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TwoDhBZ_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TwoDhBZ_color


% --- Executes during object creation, after setting all properties.
function TwoDhBZ_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TwoDhBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TwoDpBZ_clear.
function TwoDpBZ_clear_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDpBZ_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TwoDpBZ_fig=str2double(get(handles.TwoDpBZ_fig,'String'));
h_axes=figure(TwoDpBZ_fig);
h1=findobj(h_axes,'Type','Line'); 
delete(h1);



function TwoDpBZ_fig_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDpBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TwoDpBZ_fig as text
%        str2double(get(hObject,'String')) returns contents of TwoDpBZ_fig as a double


% --- Executes during object creation, after setting all properties.
function TwoDpBZ_fig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TwoDpBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TwoDpBZ_color.
function TwoDpBZ_color_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDpBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TwoDpBZ_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TwoDpBZ_color


% --- Executes during object creation, after setting all properties.
function TwoDpBZ_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TwoDpBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TwoDhBZ_clear.
function TwoDhBZ_clear_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDhBZ_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TwoDhBZ_fig=str2double(get(handles.TwoDhBZ_fig,'String'));
h_axes=figure(TwoDhBZ_fig);
h1=findobj(h_axes,'Type','Line'); 
delete(h1);


% --- Executes on button press in TwoDhBZ_plot.
function TwoDhBZ_plot_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDhBZ_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TwoDhBZ_fig = str2double(get(handles.TwoDhBZ_fig,'String'));
TwoDhBZ_color_val = get(handles.TwoDhBZ_color,'Value');
switch TwoDhBZ_color_val
     case 1
        TwoDhBZ_color = 'k';
    case 2
        TwoDhBZ_color = 'b';
    case 3
        TwoDhBZ_color = 'c';
    case 4
        TwoDhBZ_color = 'g';
    case 5
        TwoDhBZ_color = 'm';
    case 6
        TwoDhBZ_color = 'r';
    case 7
        TwoDhBZ_color = 'y';
    case 8
        TwoDhBZ_color = 'w';
end

ln = str2num(get(handles.edit92,'String'));

[b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl] = plotBZ_V1_construct_rec_lattice_vectors(handles);
[b1_prim,b2_prim,b3_prim,g_hkl] = plotBZ_V1_bulk_realtime_vector(b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl,handles);
[rec_lattice_coordinates,rec_lattice_rows] = plotBZ_V1_construct_bulk_rec_lattice(b1_prim,b2_prim,b3_prim,handles);
shi2DhBZ = str2double(get(handles.shi2DhBZ,'String'));
horizontal_plane = createPlane((shi2DhBZ/100)*g_hkl,g_hkl);
[v,c]=voronoin(rec_lattice_coordinates);

ff = figure(TwoDhBZ_fig);
ax = gca;
xl = xlim;
yl = ylim;

for ii=rec_lattice_rows
    vertices = v(c{ii},:);
    K = convhull(vertices,'simplify',true); 
    faces = mergeCoplanarFaces(vertices, K);    
    plotBZ_V1_intersectBZ(vertices,faces,horizontal_plane,180,0,TwoDhBZ_fig,'Linewidth',ln,'Color',TwoDhBZ_color);
end

if ~(isequal(xl,[0 1]) && isequal(yl,[0 1]))
    ff = figure(TwoDhBZ_fig);
    ax = gca;
    xlim(ax,xl);
    ylim(ax,yl);
else
    axis equal;
end
%  xlabel('Kx');ylabel('Ky');
%  axis equal;

 
function ThreeDBZ_fig_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThreeDBZ_fig as text
%        str2double(get(hObject,'String')) returns contents of ThreeDBZ_fig as a double


% --- Executes during object creation, after setting all properties.
function ThreeDBZ_fig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ThreeDBZ_plot.
function ThreeDBZ_plot_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ThreeDBZ_fig = str2double(get(handles.ThreeDBZ_fig,'String'));
ThreeDBZ_color_val = get(handles.ThreeDBZ_color,'Value');
TwoDhBZ_color_val = get(handles.TwoDhBZ_color,'Value');
TwoDpBZ_color_val = get(handles.TwoDpBZ_color,'Value');
switch ThreeDBZ_color_val
    case 1
        ThreeDBZ_color = 'k';
    case 2
        ThreeDBZ_color = 'b';
    case 3
        ThreeDBZ_color = 'c';
    case 4
        ThreeDBZ_color = 'g';
    case 5
        ThreeDBZ_color = 'm';
    case 6
        ThreeDBZ_color = 'r';
    case 7
        ThreeDBZ_color = 'y';
    case 8
        ThreeDBZ_color = 'w';
end
switch TwoDhBZ_color_val
     case 1
        TwoDhBZ_color = 'k';
    case 2
        TwoDhBZ_color = 'b';
    case 3
        TwoDhBZ_color = 'c';
    case 4
        TwoDhBZ_color = 'g';
    case 5
        TwoDhBZ_color = 'm';
    case 6
        TwoDhBZ_color = 'r';
    case 7
        TwoDhBZ_color = 'y';
    case 8
        TwoDhBZ_color = 'w';
end
switch TwoDpBZ_color_val
     case 1
        TwoDpBZ_color = 'k';
    case 2
        TwoDpBZ_color = 'b';
    case 3
        TwoDpBZ_color = 'c';
    case 4
        TwoDpBZ_color = 'g';
    case 5
        TwoDpBZ_color = 'm';
    case 6
        TwoDpBZ_color = 'r';
    case 7
        TwoDpBZ_color = 'y';
    case 8
        TwoDpBZ_color = 'w';
end
[b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl] = plotBZ_V1_construct_rec_lattice_vectors(handles);
[b1_prim,b2_prim,b3_prim,g_hkl] = plotBZ_V1_bulk_realtime_vector(b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl,handles);
[rec_lattice_coordinates,rec_lattice_rows] = plotBZ_V1_construct_bulk_rec_lattice(b1_prim,b2_prim,b3_prim,handles);
shi2DhBZ = str2double(get(handles.shi2DhBZ,'String'));
horizontal_plane = createPlane((shi2DhBZ/100)*g_hkl,g_hkl);
rot2DpBZ = str2double(get(handles.rot2DpBZ,'String'));
perpendicular_plane = createPlane([0 0 0], (rotz(rot2DpBZ)*rotx(90)*g_hkl')');
[v,c]=voronoin(rec_lattice_coordinates);
for ii=rec_lattice_rows
    figure(ThreeDBZ_fig);
    drawPoint3d(rec_lattice_coordinates(ii,:));
    vertices = v(c{ii},:);
    K = convhull(vertices,'simplify',true); 
    faces = mergeCoplanarFaces(vertices, K); 
    figure(ThreeDBZ_fig);
    drawMesh(vertices, faces,'FaceColor','none','EdgeColor',ThreeDBZ_color);
    if get(handles.TwoDh_of3D,'Value')
        plotBZ_V1_intersectBZ(vertices,faces,horizontal_plane,180,ThreeDBZ_fig,0,'Linewidth',1,'Color',TwoDhBZ_color);
    end
    if get(handles.TwoDp_of3D,'Value')
        plotBZ_V1_intersectBZ(vertices,faces,perpendicular_plane,-90,ThreeDBZ_fig,0,'Linewidth',1,'Color',TwoDpBZ_color);
    end
    hold on
end;
 xlabel('Kx');ylabel('Ky');zlabel('Kz');
 axis equal;



% --- Executes on button press in ThreeDBZ_clear.
function ThreeDBZ_clear_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ThreeDBZ_fig=str2num(get(handles.ThreeDBZ_fig,'String'));
h_axes=figure(ThreeDBZ_fig);
h1=findobj(h_axes,'Type','Line'); 
delete(h1);
h2=findobj(h_axes,'Type','patch');
delete(h2);


% --- Executes on selection change in ThreeDBZ_color.
function ThreeDBZ_color_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ThreeDBZ_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ThreeDBZ_color


% --- Executes during object creation, after setting all properties.
function ThreeDBZ_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel_LatticeType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_LatticeType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in uipanel_LatticeType.
function uipanel_LatticeType_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_LatticeType 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over radio_facecentered.
function radio_facecentered_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to radio_facecentered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function MillerK_Callback(hObject, eventdata, handles)
% hObject    handle to MillerK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MillerK as text
%        str2double(get(hObject,'String')) returns contents of MillerK as a double


% --- Executes during object creation, after setting all properties.
function MillerK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MillerK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Hdown.
function Hdown_Callback(hObject, eventdata, handles)
% hObject    handle to Hdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.MillerH,'String'));
temp=temp-1;
set(handles.MillerH,'String',num2str(temp));

% --- Executes on button press in Hup.
function Hup_Callback(hObject, eventdata, handles)
% hObject    handle to Hup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.MillerH,'String'));
temp=temp+1;
set(handles.MillerH,'String',num2str(temp));


function MillerH_Callback(hObject, eventdata, handles)
% hObject    handle to MillerH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MillerH as text
%        str2double(get(hObject,'String')) returns contents of MillerH as a double


% --- Executes during object creation, after setting all properties.
function MillerH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MillerH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Ldown.
function Ldown_Callback(hObject, eventdata, handles)
% hObject    handle to Ldown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.MillerL,'String'));
temp=temp-1;
set(handles.MillerL,'String',num2str(temp));

% --- Executes on button press in Lup.
function Lup_Callback(hObject, eventdata, handles)
% hObject    handle to Lup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.MillerL,'String'));
temp=temp+1;
set(handles.MillerL,'String',num2str(temp));


function MillerL_Callback(hObject, eventdata, handles)
% hObject    handle to MillerL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MillerL as text
%        str2double(get(hObject,'String')) returns contents of MillerL as a double


% --- Executes during object creation, after setting all properties.
function MillerL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MillerL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Kdown.
function Kdown_Callback(hObject, eventdata, handles)
% hObject    handle to Kdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.MillerK,'String'));
temp=temp-1;
set(handles.MillerK,'String',num2str(temp));

% --- Executes on button press in Kup.
function Kup_Callback(hObject, eventdata, handles)
% hObject    handle to Kup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2num(get(handles.MillerK,'String'));
temp=temp+1;
set(handles.MillerK,'String',num2str(temp));


% --- Executes during object creation, after setting all properties.
function uipanel_Celllength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_Celllength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton33.
function radiobutton33_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton33


% --- Executes on button press in radiobutton34.
function radiobutton34_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton34



function edit68_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThreeDBZ_fig as text
%        str2double(get(hObject,'String')) returns contents of ThreeDBZ_fig as a double


% --- Executes during object creation, after setting all properties.
function edit68_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ThreeDBZ_plot.
function pushbutton70_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ThreeDBZ_clear.
function pushbutton71_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in ThreeDBZ_color.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ThreeDBZ_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ThreeDBZ_color


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThreeDBZ_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TwoDh_of3D.
function TwoDh_of3D_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDh_of3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TwoDh_of3D


% --- Executes on button press in TwoDp_of3D.
function TwoDp_of3D_Callback(hObject, eventdata, handles)
% hObject    handle to TwoDp_of3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TwoDp_of3D


% --- Executes on button press in s1startDown.
function s1startDown_Callback(hObject, eventdata, handles)
% hObject    handle to s1startDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.s1start,'String'));
temp = temp-1;
set(handles.s1start,'String',num2str(temp));


% --- Executes on button press in s1startUp.
function s1startUp_Callback(hObject, eventdata, handles)
% hObject    handle to s1startUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.s1start,'String'));
temp = temp+1;
set(handles.s1start,'String',num2str(temp));



function s1start_Callback(hObject, eventdata, handles)
% hObject    handle to s1start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of s1start as text
%        str2double(get(hObject,'String')) returns contents of s1start as a double


% --- Executes during object creation, after setting all properties.
function s1start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s1start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in s1endDown.
function s1endDown_Callback(hObject, eventdata, handles)
% hObject    handle to s1endDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.s1end,'String'));
temp = temp-1;
set(handles.s1end,'String',num2str(temp));


% --- Executes on button press in s1endUp.
function s1endUp_Callback(hObject, eventdata, handles)
% hObject    handle to s1endUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.s1end,'String'));
temp = temp+1;
set(handles.s1end,'String',num2str(temp));



function s1end_Callback(hObject, eventdata, handles)
% hObject    handle to s1end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of s1end as text
%        str2double(get(hObject,'String')) returns contents of s1end as a double


% --- Executes during object creation, after setting all properties.
function s1end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s1end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in s2startDown.
function s2startDown_Callback(hObject, eventdata, handles)
% hObject    handle to s2startDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.s2start,'String'));
temp = temp-1;
set(handles.s2start,'String',num2str(temp));


% --- Executes on button press in s2startUp.
function s2startUp_Callback(hObject, eventdata, handles)
% hObject    handle to s2startUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.s2start,'String'));
temp = temp+1;
set(handles.s2start,'String',num2str(temp));



function s2start_Callback(hObject, eventdata, handles)
% hObject    handle to s2start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of s2start as text
%        str2double(get(hObject,'String')) returns contents of s2start as a double


% --- Executes during object creation, after setting all properties.
function s2start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s2start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in s2endDown.
function s2endDown_Callback(hObject, eventdata, handles)
% hObject    handle to s2endDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.s2end,'String'));
temp = temp-1;
set(handles.s2end,'String',num2str(temp));


% --- Executes on button press in s2endUp.
function s2endUp_Callback(hObject, eventdata, handles)
% hObject    handle to s2endUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.s2end,'String'));
temp = temp+1;
set(handles.s2end,'String',num2str(temp));



function s2end_Callback(hObject, eventdata, handles)
% hObject    handle to s2end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of s2end as text
%        str2double(get(hObject,'String')) returns contents of s2end as a double


% --- Executes during object creation, after setting all properties.
function s2end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s2end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton72.
function pushbutton72_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton73.
function pushbutton73_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit69_Callback(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit69 as text
%        str2double(get(hObject,'String')) returns contents of edit69 as a double


% --- Executes during object creation, after setting all properties.
function edit69_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton74.
function pushbutton74_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton75.
function pushbutton75_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit70_Callback(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit70 as text
%        str2double(get(hObject,'String')) returns contents of edit70 as a double


% --- Executes during object creation, after setting all properties.
function edit70_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton76.
function pushbutton76_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton77.
function pushbutton77_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit71_Callback(hObject, eventdata, handles)
% hObject    handle to edit71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit71 as text
%        str2double(get(hObject,'String')) returns contents of edit71 as a double


% --- Executes during object creation, after setting all properties.
function edit71_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton78.
function pushbutton78_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton79.
function pushbutton79_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit72_Callback(hObject, eventdata, handles)
% hObject    handle to edit72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit72 as text
%        str2double(get(hObject,'String')) returns contents of edit72 as a double


% --- Executes during object creation, after setting all properties.
function edit72_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton80.
function pushbutton80_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton81.
function pushbutton81_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton81 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit73_Callback(hObject, eventdata, handles)
% hObject    handle to edit73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit73 as text
%        str2double(get(hObject,'String')) returns contents of edit73 as a double


% --- Executes during object creation, after setting all properties.
function edit73_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton82.
function pushbutton82_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton83.
function pushbutton83_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton83 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit74_Callback(hObject, eventdata, handles)
% hObject    handle to edit74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit74 as text
%        str2double(get(hObject,'String')) returns contents of edit74 as a double


% --- Executes during object creation, after setting all properties.
function edit74_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotsurBZ_Callback(hObject, eventdata, handles)
% hObject    handle to rotsurBZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotsurBZ as text
%        str2double(get(hObject,'String')) returns contents of rotsurBZ as a double


% --- Executes during object creation, after setting all properties.
function rotsurBZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotsurBZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rot2DpBZ_inplane_Callback(hObject, eventdata, handles)
% hObject    handle to rot2DpBZ_inplane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot2DpBZ_inplane as text
%        str2double(get(hObject,'String')) returns contents of rot2DpBZ_inplane as a double


% --- Executes during object creation, after setting all properties.
function rot2DpBZ_inplane_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot2DpBZ_inplane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit91_Callback(hObject, eventdata, handles)
% hObject    handle to edit91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit91 as text
%        str2double(get(hObject,'String')) returns contents of edit91 as a double


% --- Executes during object creation, after setting all properties.
function edit91_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit92_Callback(hObject, eventdata, handles)
% hObject    handle to edit92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit92 as text
%        str2double(get(hObject,'String')) returns contents of edit92 as a double


% --- Executes during object creation, after setting all properties.
function edit92_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit93_Callback(hObject, eventdata, handles)
% hObject    handle to edit93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit93 as text
%        str2double(get(hObject,'String')) returns contents of edit93 as a double


% --- Executes during object creation, after setting all properties.
function edit93_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
