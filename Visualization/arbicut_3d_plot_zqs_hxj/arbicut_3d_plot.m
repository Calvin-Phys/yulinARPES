function varargout = arbicut_3d_plot(varargin)

% author: Qungsong Zeng & Xinjing Huang
% E-mail: zqs1111@mail.ustc.edu.cn & aliciah@mail.ustc.edu.cn


% ARBICUT_3D_PLOT MATLAB code for arbicut_3d_plot.fig
%      ARBICUT_3D_PLOT, by itself, creates a new ARBICUT_3D_PLOT or raises the existing
%      singleton*.
%
%      H = ARBICUT_3D_PLOT returns the handle to a new ARBICUT_3D_PLOT or the handle to
%      the existing singleton*.
%
%      ARBICUT_3D_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARBICUT_3D_PLOT.M with the given input arguments.
%
%      ARBICUT_3D_PLOT('Property','Value',...) creates a new ARBICUT_3D_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before arbicut_3d_plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to arbicut_3d_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help arbicut_3d_plot

% Last Modified by GUIDE v2.5 28-Aug-2016 23:14:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @arbicut_3d_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @arbicut_3d_plot_OutputFcn, ...
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


% --- Executes just before arbicut_3d_plot is made visible.
function arbicut_3d_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to arbicut_3d_plot (see VARARGIN)

% Choose default command line output for arbicut_3d_plot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes arbicut_3d_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = arbicut_3d_plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in GetFromFigue.
function getfromfigure_Callback(hObject, eventdata, handles)
% hObject    handle to GetFromFigue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function number_Callback(hObject, eventdata, handles)
% hObject    handle to figureno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figureno as text
%        str2double(get(hObject,'String')) returns contents of figureno as a double


% --- Executes during object creation, after setting all properties.
function number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figureno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars = evalin('base','who');
set(handles.datalist,'String',vars);
if isempty(vars)
    set(handles.datalist,'Value',0);
else
    index=get(handles.datalist,'Value');
    if index>length(vars)
        set(handles.datalist,'Value',length(vars));
    elseif index==0
        set(handles.datalist,'Value',1);
    end
end



function datalist_Callback(hObject, eventdata, handles)
% hObject    handle to datalist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datalist as text
%        str2double(get(hObject,'String')) returns contents of datalist as a double
%list_entries = get(handles.datalist,'String');
%set(handles.save_as,'String',[var_name,'_cut']);
%var_name = list_entries{index_selected(1)};  %determine the var in base



% --- Executes during object creation, after setting all properties.
function datalist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datalist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double


% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y2_Callback(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y2 as text
%        str2double(get(hObject,'String')) returns contents of y2 as a double


% --- Executes during object creation, after setting all properties.
function y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x3_Callback(hObject, eventdata, handles)
% hObject    handle to x3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x3 as text
%        str2double(get(hObject,'String')) returns contents of x3 as a double


% --- Executes during object creation, after setting all properties.
function x3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y3_Callback(hObject, eventdata, handles)
% hObject    handle to y3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y3 as text
%        str2double(get(hObject,'String')) returns contents of y3 as a double


% --- Executes during object creation, after setting all properties.
function y3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x4_Callback(hObject, eventdata, handles)
% hObject    handle to x4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x4 as text
%        str2double(get(hObject,'String')) returns contents of x4 as a double


% --- Executes during object creation, after setting all properties.
function x4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y4_Callback(hObject, eventdata, handles)
% hObject    handle to y4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y4 as text
%        str2double(get(hObject,'String')) returns contents of y4 as a double


% --- Executes during object creation, after setting all properties.
function y4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x5_Callback(hObject, eventdata, handles)
% hObject    handle to x5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x5 as text
%        str2double(get(hObject,'String')) returns contents of x5 as a double


% --- Executes during object creation, after setting all properties.
function x5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x6_Callback(hObject, eventdata, handles)
% hObject    handle to x6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x6 as text
%        str2double(get(hObject,'String')) returns contents of x6 as a double


% --- Executes during object creation, after setting all properties.
function x6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y5_Callback(hObject, eventdata, handles)
% hObject    handle to y5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y5 as text
%        str2double(get(hObject,'String')) returns contents of y5 as a double


% --- Executes during object creation, after setting all properties.
function y5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_Callback(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2 as text
%        str2double(get(hObject,'String')) returns contents of x2 as a double


% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y1_Callback(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y1 as text
%        str2double(get(hObject,'String')) returns contents of y1 as a double


% --- Executes during object creation, after setting all properties.
function y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y6_Callback(hObject, eventdata, handles)
% hObject    handle to y6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y6 as text
%        str2double(get(hObject,'String')) returns contents of y6 as a double


% --- Executes during object creation, after setting all properties.
function y6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x7_Callback(hObject, eventdata, handles)
% hObject    handle to x7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x7 as text
%        str2double(get(hObject,'String')) returns contents of x7 as a double


% --- Executes during object creation, after setting all properties.
function x7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y7_Callback(hObject, eventdata, handles)
% hObject    handle to y7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y7 as text
%        str2double(get(hObject,'String')) returns contents of y7 as a double


% --- Executes during object creation, after setting all properties.
function y7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x8_Callback(hObject, eventdata, handles)
% hObject    handle to x8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x8 as text
%        str2double(get(hObject,'String')) returns contents of x8 as a double


% --- Executes during object creation, after setting all properties.
function x8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y8_Callback(hObject, eventdata, handles)
% hObject    handle to y8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y8 as text
%        str2double(get(hObject,'String')) returns contents of y8 as a double


% --- Executes during object creation, after setting all properties.
function y8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x9_Callback(hObject, eventdata, handles)
% hObject    handle to x9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x9 as text
%        str2double(get(hObject,'String')) returns contents of x9 as a double


% --- Executes during object creation, after setting all properties.
function x9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y9_Callback(hObject, eventdata, handles)
% hObject    handle to y9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y9 as text
%        str2double(get(hObject,'String')) returns contents of y9 as a double


% --- Executes during object creation, after setting all properties.
function y9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y10_Callback(hObject, eventdata, handles)
% hObject    handle to y10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y10 as text
%        str2double(get(hObject,'String')) returns contents of y10 as a double


% --- Executes during object creation, after setting all properties.
function y10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x10_Callback(hObject, eventdata, handles)
% hObject    handle to x10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x10 as text
%        str2double(get(hObject,'String')) returns contents of x10 as a double


% --- Executes during object creation, after setting all properties.
function x10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotbutton.
function plotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% read data
list_entries = get(handles.datalist,'String');
index_selected = get(handles.datalist,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
data=datav;
clear datav;

%% get points
global xlist;
global ylist;
global point_num;
xlist=[];
ylist=[];
point_num=0;
if get(handles.x1,'String')
    xlist(1)=str2double(get(handles.x1,'String'));
    ylist(1)=str2double(get(handles.y1,'String'));
    point_num=point_num+1;
end
if get(handles.x2,'String')
    xlist(2)=str2double(get(handles.x2,'String'));
    ylist(2)=str2double(get(handles.y2,'String'));
    point_num=point_num+1;
end
if get(handles.x3,'String')
    xlist(3)=str2double(get(handles.x3,'String'));
    ylist(3)=str2double(get(handles.y3,'String'));
    point_num=point_num+1;
end
if get(handles.x4,'String')
    xlist(4)=str2double(get(handles.x4,'String'));
    ylist(4)=str2double(get(handles.y4,'String'));
    point_num=point_num+1;
end
if get(handles.x5,'String')
    xlist(5)=str2double(get(handles.x5,'String'));
    ylist(5)=str2double(get(handles.y5,'String'));
    point_num=point_num+1;
end
if get(handles.x6,'String')
    xlist(6)=str2double(get(handles.x6,'String'));
    ylist(6)=str2double(get(handles.y6,'String'));
    point_num=point_num+1;
end
if get(handles.x7,'String')
    xlist(7)=str2double(get(handles.x7,'String'));
    ylist(7)=str2double(get(handles.y7,'String'));
    point_num=point_num+1;
end
if get(handles.x8,'String')
    xlist(8)=str2double(get(handles.x8,'String'));
    ylist(8)=str2double(get(handles.y8,'String'));
    point_num=point_num+1;
end
%if get(handles.x9,'String')
%    xlist(9)=str2double(get(handles.x9,'String'));
%    ylist(9)=str2double(get(handles.y9,'String'));
%    point_num=point_num+1;
%end
%if get(handles.x10,'String')
%    xlist(10)=str2double(get(handles.x10,'String'));
%    ylist(10)=str2double(get(handles.y10,'String'));
%    point_num=point_num+1;
%end

%arbi cut slice plot
            h=figure(100);
            deltaz=data.z(2)-data.z(1);
            hold on
            for i=1:point_num            
                if i~=point_num
                    x0=xlist(i);
                    y0=ylist(i);
                    x1=xlist(i+1);
                    y1=ylist(i+1);
                else 
                    x0=xlist(i);
                    y0=ylist(i);
                    x1=xlist(1);
                    y1=ylist(1);
                end
                [x,y,~]=area_secant_ph_new(data.x,data.y,x0,y0,x1,y1);
                z=data.z(data.z<=deltaz);
                xx=repmat(x,max(size(z)),1);
                yy=repmat(y,max(size(z)),1);
                zz=repmat(z',1,max(size(x)));
                slice(data.y,data.x,data.z,data.value,yy,xx,zz);
            end
           [Xsl,Ysl]=ndgrid(data.x,data.y);
            Zs1=ones(size(Xsl))*deltaz;
            Zs2=ones(size(Xsl))*min(data.z);
            h0=slice(data.y,data.x,data.z,data.value,Ysl,Xsl,Zs1);
            h1=slice(data.y,data.x,data.z,data.value,Ysl,Xsl,Zs2);

            x_ind=round((xlist-data.x(1))/(data.x(2)-data.x(1)))+1;
            y_ind=round((ylist-data.y(1))/(data.y(2)-data.y(1)))+1;
            mask=poly2mask(y_ind,x_ind,length(data.y),length(data.x))+0;
            mask(mask==0)=NaN;
            h0.CData=h0.CData.*mask;
            h1.CData=h1.CData.*mask;

            load('Colormap.mat');
            colormap(flipud(cm_blue));
            shading interp;
            

            
% --- Executes on button press in GetFromFigue.
function GetFromFigue_Callback(hObject, eventdata, handles)
% hObject    handle to GetFromFigue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% read data
list_entries = get(handles.datalist,'String');
index_selected = get(handles.datalist,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
data=datav;
clear datav;
%clear all the point coordinates
            set(handles.x1,'string','');
            set(handles.y1,'string','');
            set(handles.x2,'string','');
            set(handles.y2,'string','');
            set(handles.x3,'string','');
            set(handles.y3,'string','');
            set(handles.x4,'string','');
            set(handles.y4,'string','');
            set(handles.x5,'string','');
            set(handles.y5,'string','');
            set(handles.x6,'string','');
            set(handles.y6,'string','');
            set(handles.x7,'string','');
            set(handles.y7,'string','');
            set(handles.x8,'string','');
            set(handles.y8,'string','');
%            set(handles.x9,'string','');
%            set(handles.y9,'string','');
%            set(handles.x10,'string','');
%            set(handles.y10,'string','');
% draw a 2D picture to get point
zm=fix(size(data.z,2)/2);
obj=figure(200);
value(:,:)=data.value(:,:,zm);
pcolor(data.x,data.y,value);
load('Colormap.mat');
colormap(flipud(cm_blue));
shading interp;
%read points and enter the coordinates
x_list=[];
y_list=[];
[x_list,y_list]=getpts;
point_number=size(x_list,1);
if point_number>=1
    set(handles.x1,'string',num2str(x_list(1)));
    set(handles.y1,'string',num2str(y_list(1)));
end
if point_number>=2
    set(handles.x2,'string',num2str(x_list(2)));
    set(handles.y2,'string',num2str(y_list(2)));
end
if point_number>=3
    set(handles.x3,'string',num2str(x_list(3)));
    set(handles.y3,'string',num2str(y_list(3)));
end
if point_number>=4
    set(handles.x4,'string',num2str(x_list(4)));
    set(handles.y4,'string',num2str(y_list(4)));
end
if point_number>=5
    set(handles.x5,'string',num2str(x_list(5)));
    set(handles.y5,'string',num2str(y_list(5)));
end
if point_number>=6
    set(handles.x6,'string',num2str(x_list(6)));
    set(handles.y6,'string',num2str(y_list(6)));
end
if point_number>=7
    set(handles.x7,'string',num2str(x_list(7)));
    set(handles.y7,'string',num2str(y_list(7)));
end
if point_number>=8
    set(handles.x8,'string',num2str(x_list(8)));
    set(handles.y8,'string',num2str(y_list(8)));
end
% if point_number>=9
%     set(handles.x9,'string',num2str(x_list(9)));
%     set(handles.y9,'string',num2str(y_list(9)));
% end
% if point_number>=10
%     set(handles.x10,'string',num2str(x_list(10)));
%     set(handles.y10,'string',num2str(y_list(10)));
% end



%function figureno_Callback(hObject, eventdata, handles)
% hObject    handle to figureno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figureno as text
%        str2double(get(hObject,'String')) returns contents of figureno as a double


% --- Executes during object creation, after setting all properties.
%function figureno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figureno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%    set(hObject,'BackgroundColor','white');
%end


% --- Executes on button press in cutplot.
function cutplot_Callback(hObject, eventdata, handles)
% hObject    handle to cutplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xlist;
global ylist;
global point_num;
% global theta;
% read data
list_entries = get(handles.datalist,'String');
index_selected = get(handles.datalist,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
data=datav;
clear datav;

x0=str2double(get(handles.x0,'string'));
y0=str2double(get(handles.y0,'string'));
theta1=str2double(get(handles.theta1,'string'));
if theta1<0
    theta1=theta1+360;
end
theta2=str2double(get(handles.theta2,'string'));
if theta2<0
    theta2=theta2+360;
end
if theta1>theta2
    a=theta1;
    theta1=theta2;
    theta2=a;
end

theta=angle_list(xlist,ylist,x0,y0);

[node_x1,node_y1,node_x2,node_y2] = intersection(xlist,ylist,theta,theta1,theta2,x0,y0);

%determine the points data on the top surface
rmin=abs(min(data.x(1)-data.x(2),data.y(1)-data.y(2)));
[x_list,y_list]=new_list(rmin,xlist,ylist,theta,node_x1,node_y1,theta1,node_x2,node_y2,theta2,x0,y0);

h=figure(300);
hold on
deltaz=data.z(2)-data.z(1);
energy=str2double(get(handles.energy,'string'));

%slice the part above the energy plane
point_number=size(x_list,2);
for i=1:point_number
    if i~=point_number
        x0=x_list(i);
        y0=y_list(i);
        x1=x_list(i+1);
        y1=y_list(i+1);
    else 
        x0=x_list(i);
        y0=y_list(i);
        x1=x_list(1);
        y1=y_list(1);
    end
    [x,y,~]=area_secant_ph_new(data.x,data.y,x0,y0,x1,y1);
    z=data.z(data.z<=deltaz);
    %z=z(z>=min(data.z));
    xx=repmat(x,max(size(z)),1);
    yy=repmat(y,max(size(z)),1);
    zz=repmat(z',1,max(size(x)));
    slice(data.y,data.x,data.z,data.value,yy,xx,zz);
end
[Xsl,Ysl]=ndgrid(data.x,data.y);
Zsl=ones(size(Xsl))*deltaz;
h0=slice(data.y,data.x,data.z,data.value,Ysl,Xsl,Zsl);

x_ind=round((x_list-data.x(1))/(data.x(2)-data.x(1)))+1;
y_ind=round((y_list-data.y(1))/(data.y(2)-data.y(1)))+1;
mask=poly2mask(y_ind,x_ind,length(data.y),length(data.x))+0;
mask(mask==0)=NaN;
h0.CData=h0.CData.*mask;

%slice the part below the energy plane
for i=1:point_num            
    if i~=point_num
        x0=xlist(i);
        y0=ylist(i);
        x1=xlist(i+1);
        y1=ylist(i+1);
    else 
        x0=xlist(i);
        y0=ylist(i);
        x1=xlist(1);
        y1=ylist(1);
    end
    [x,y,~]=area_secant_ph_new(data.x,data.y,x0,y0,x1,y1);
    z=data.z(data.z<=energy+deltaz);
    %z=z(z>=min(data.z));
    xx=repmat(x,max(size(z)),1);
    yy=repmat(y,max(size(z)),1);
    zz=repmat(z',1,max(size(x)));
    slice(data.y,data.x,data.z,data.value,yy,xx,zz);
end
[Xsl,Ysl]=ndgrid(data.x,data.y);
Zs1=ones(size(Xsl))*(energy);
Zs2=ones(size(Xsl))*(-0.5-deltaz);
h1=slice(data.y,data.x,data.z,data.value,Ysl,Xsl,Zs1);
h2=slice(data.y,data.x,data.z,data.value,Ysl,Xsl,Zs2);

x_ind=round((xlist-data.x(1))/(data.x(2)-data.x(1)))+1;
y_ind=round((ylist-data.y(1))/(data.y(2)-data.y(1)))+1;
mask=poly2mask(y_ind,x_ind,length(data.y),length(data.x))+0;
mask(mask==0)=NaN;
h1.CData=h1.CData.*mask;
h2.CData=h2.CData.*mask;

load('Colormap.mat');
colormap(flipud(cm_blue));
shading interp;


function x0_Callback(hObject, eventdata, handles)
% hObject    handle to x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x0 as text
%        str2double(get(hObject,'String')) returns contents of x0 as a double


% --- Executes during object creation, after setting all properties.
function x0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y0_Callback(hObject, eventdata, handles)
% hObject    handle to y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y0 as text
%        str2double(get(hObject,'String')) returns contents of y0 as a double


% --- Executes during object creation, after setting all properties.
function y0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function theta1_Callback(hObject, eventdata, handles)
% hObject    handle to theta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta1 as text
%        str2double(get(hObject,'String')) returns contents of theta1 as a double


% --- Executes during object creation, after setting all properties.
function theta1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta2_Callback(hObject, eventdata, handles)
% hObject    handle to theta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta2 as text
%        str2double(get(hObject,'String')) returns contents of theta2 as a double


% --- Executes during object creation, after setting all properties.
function theta2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function energy_Callback(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of energy as text
%        str2double(get(hObject,'String')) returns contents of energy as a double


% --- Executes during object creation, after setting all properties.
function energy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in xminus1.
function xminus1_Callback(hObject, eventdata, handles)
% hObject    handle to xminus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2double(get(handles.x1,'String'));
set(handles.x1,'String', num2str(x1-0.001));


% --- Executes on button press in xplus1.
function xplus1_Callback(hObject, eventdata, handles)
% hObject    handle to xplus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2double(get(handles.x1,'String'));
set(handles.x1,'String', num2str(x1+0.001));


% --- Executes on button press in xminus2.
function xminus2_Callback(hObject, eventdata, handles)
% hObject    handle to xminus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x2=str2double(get(handles.x2,'String'));
set(handles.x2,'String', num2str(x2-0.001));


% --- Executes on button press in xplus2.
function xplus2_Callback(hObject, eventdata, handles)
% hObject    handle to xplus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x2=str2double(get(handles.x2,'String'));
set(handles.x2,'String', num2str(x2+0.001));

% --- Executes on button press in xminus3.
function xminus3_Callback(hObject, eventdata, handles)
% hObject    handle to xminus3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x3=str2double(get(handles.x3,'String'));
set(handles.x3,'String', num2str(x3-0.001));


% --- Executes on button press in xplus3.
function xplus3_Callback(hObject, eventdata, handles)
% hObject    handle to xplus3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x3=str2double(get(handles.x3,'String'));
set(handles.x3,'String', num2str(x3+0.001));


% --- Executes on button press in xminus4.
function xminus4_Callback(hObject, eventdata, handles)
% hObject    handle to xminus4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x4=str2double(get(handles.x4,'String'));
set(handles.x4,'String', num2str(x4-0.001));


% --- Executes on button press in xplus4.
function xplus4_Callback(hObject, eventdata, handles)
% hObject    handle to xplus4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x4=str2double(get(handles.x4,'String'));
set(handles.x4,'String', num2str(x4+0.001));


% --- Executes on button press in xminus5.
function xminus5_Callback(hObject, eventdata, handles)
% hObject    handle to xminus5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x5=str2double(get(handles.x5,'String'));
set(handles.x5,'String', num2str(x5-0.001));


% --- Executes on button press in xplus5.
function xplus5_Callback(hObject, eventdata, handles)
% hObject    handle to xplus5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x5=str2double(get(handles.x5,'String'));
set(handles.x5,'String', num2str(x5+0.001));


% --- Executes on button press in xminus7.
function xminus7_Callback(hObject, eventdata, handles)
% hObject    handle to xminus7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x7=str2double(get(handles.x7,'String'));
set(handles.x7,'String', num2str(x7-0.001));


% --- Executes on button press in xplus7.
function xplus7_Callback(hObject, eventdata, handles)
% hObject    handle to xplus7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x7=str2double(get(handles.x7,'String'));
set(handles.x7,'String', num2str(x7+0.001));


% --- Executes on button press in xminus8.
function xminus8_Callback(hObject, eventdata, handles)
% hObject    handle to xminus8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x8=str2double(get(handles.x8,'String'));
set(handles.x8,'String', num2str(x8-0.001));


% --- Executes on button press in xplus8.
function xplus8_Callback(hObject, eventdata, handles)
% hObject    handle to xplus8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x8=str2double(get(handles.x8,'String'));
set(handles.x8,'String', num2str(x8+0.001));


% --- Executes on button press in xminus6.
function xminus6_Callback(hObject, eventdata, handles)
% hObject    handle to xminus6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x6=str2double(get(handles.x6,'String'));
set(handles.x6,'String', num2str(x6-0.001));

% --- Executes on button press in xplus6.
function xplus6_Callback(hObject, eventdata, handles)
% hObject    handle to xplus6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x6=str2double(get(handles.x6,'String'));
set(handles.x6,'String', num2str(x6+0.001));


% --- Executes on button press in yminus1.
function yminus1_Callback(hObject, eventdata, handles)
% hObject    handle to yminus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y1=str2double(get(handles.y1,'String'));
set(handles.y1,'String', num2str(y1-0.001));

% --- Executes on button press in yplus1.
function yplus1_Callback(hObject, eventdata, handles)
% hObject    handle to yplus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y1=str2double(get(handles.y1,'String'));
set(handles.y1,'String', num2str(y1+0.001));

% --- Executes on button press in yminus2.
function yminus2_Callback(hObject, eventdata, handles)
% hObject    handle to yminus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y2=str2double(get(handles.y2,'String'));
set(handles.y2,'String', num2str(y2-0.001));

% --- Executes on button press in yplus2.
function yplus2_Callback(hObject, eventdata, handles)
% hObject    handle to yplus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y2=str2double(get(handles.y2,'String'));
set(handles.y2,'String', num2str(y2+0.001));

% --- Executes on button press in yminus3.
function yminus3_Callback(hObject, eventdata, handles)
% hObject    handle to yminus3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y3=str2double(get(handles.y3,'String'));
set(handles.y3,'String', num2str(y3-0.001));

% --- Executes on button press in yplus3.
function yplus3_Callback(hObject, eventdata, handles)
% hObject    handle to yplus3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y3=str2double(get(handles.y3,'String'));
set(handles.y3,'String', num2str(y3+0.001));

% --- Executes on button press in yminus4.
function yminus4_Callback(hObject, eventdata, handles)
% hObject    handle to yminus4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y4=str2double(get(handles.y4,'String'));
set(handles.y4,'String', num2str(y4-0.001));

% --- Executes on button press in yplus4.
function yplus4_Callback(hObject, eventdata, handles)
% hObject    handle to yplus4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y4=str2double(get(handles.y4,'String'));
set(handles.y4,'String', num2str(y4+0.001));

% --- Executes on button press in yminus5.
function yminus5_Callback(hObject, eventdata, handles)
% hObject    handle to yminus5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y5=str2double(get(handles.y5,'String'));
set(handles.y5,'String', num2str(y5-0.001));

% --- Executes on button press in yplus5.
function yplus5_Callback(hObject, eventdata, handles)
% hObject    handle to yplus5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y5=str2double(get(handles.y5,'String'));
set(handles.y5,'String', num2str(y5+0.001));

% --- Executes on button press in yminus7.
function yminus7_Callback(hObject, eventdata, handles)
% hObject    handle to yminus7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y7=str2double(get(handles.y7,'String'));
set(handles.y7,'String', num2str(y7-0.001));

% --- Executes on button press in yplus7.
function yplus7_Callback(hObject, eventdata, handles)
% hObject    handle to yplus7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y7=str2double(get(handles.y7,'String'));
set(handles.y7,'String', num2str(y7+0.001));

% --- Executes on button press in yminus8.
function yminus8_Callback(hObject, eventdata, handles)
% hObject    handle to yminus8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y8=str2double(get(handles.y8,'String'));
set(handles.y8,'String', num2str(y8-0.001));


% --- Executes on button press in yplus8.
function yplus8_Callback(hObject, eventdata, handles)
% hObject    handle to yplus8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y8=str2double(get(handles.y8,'String'));
set(handles.y8,'String', num2str(y8+0.001));


% --- Executes on button press in yminus6.
function yminus6_Callback(hObject, eventdata, handles)
% hObject    handle to yminus6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y6=str2double(get(handles.y6,'String'));
set(handles.y6,'String', num2str(y6-0.001));


% --- Executes on button press in yplus6.
function yplus6_Callback(hObject, eventdata, handles)
% hObject    handle to yplus6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y6=str2double(get(handles.y6,'String'));
set(handles.y6,'String', num2str(y6+0.001));


% --- Executes on button press in symmetryco.
function symmetryco_Callback(hObject, eventdata, handles)
% hObject    handle to symmetryco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=str2double(get(handles.symmetry,'String'));
list_entries = get(handles.datalist,'String');
index_selected = get(handles.datalist,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
data=datav;
clear datav;
%zm=fix(size(data.z,2)/2);
%value(:,:)=data.value(:,:,zm);
%datax=data.x;
%datay=data.y;
[centerx,centery,r,theta]=symmetry_plot(data,n);
[x_list,y_list]=ajust_points(n,centerx,centery,r,theta);
point_number=n;
if point_number>=1
    set(handles.x1,'string',num2str(x_list(1)));
    set(handles.y1,'string',num2str(y_list(1)));
end
if point_number>=2
    set(handles.x2,'string',num2str(x_list(2)));
    set(handles.y2,'string',num2str(y_list(2)));
end
if point_number>=3
    set(handles.x3,'string',num2str(x_list(3)));
    set(handles.y3,'string',num2str(y_list(3)));
end
if point_number>=4
    set(handles.x4,'string',num2str(x_list(4)));
    set(handles.y4,'string',num2str(y_list(4)));
end
if point_number>=5
    set(handles.x5,'string',num2str(x_list(5)));
    set(handles.y5,'string',num2str(y_list(5)));
end
if point_number>=6
    set(handles.x6,'string',num2str(x_list(6)));
    set(handles.y6,'string',num2str(y_list(6)));
end
if point_number>=7
    set(handles.x7,'string',num2str(x_list(7)));
    set(handles.y7,'string',num2str(y_list(7)));
end
if point_number>=8
    set(handles.x8,'string',num2str(x_list(8)));
    set(handles.y8,'string',num2str(y_list(8)));
end
% if point_number>=9
%     set(handles.x9,'string',num2str(x_list(9)));
%     set(handles.y9,'string',num2str(y_list(9)));
% end
% if point_number>=10
%     set(handles.x10,'string',num2str(x_list(10)));
%     set(handles.y10,'string',num2str(y_list(10)));
% end

    



function symmetry_Callback(hObject, eventdata, handles)
% hObject    handle to symmetry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symmetry as text
%        str2double(get(hObject,'String')) returns contents of symmetry as a double


% --- Executes during object creation, after setting all properties.
function symmetry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symmetry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sphere_x0_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sphere_x0 as text
%        str2double(get(hObject,'String')) returns contents of sphere_x0 as a double


% --- Executes during object creation, after setting all properties.
function sphere_x0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sphere_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sphere_y0_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sphere_y0 as text
%        str2double(get(hObject,'String')) returns contents of sphere_y0 as a double


% --- Executes during object creation, after setting all properties.
function sphere_y0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sphere_y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton70.
function pushbutton70_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton71.
function pushbutton71_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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



function sphere_z0_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sphere_z0 as text
%        str2double(get(hObject,'String')) returns contents of sphere_z0 as a double


% --- Executes during object creation, after setting all properties.
function sphere_z0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sphere_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sphere_x0_minus.
function sphere_x0_minus_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_x0_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2double(get(handles.sphere_x0,'String'));
set(handles.sphere_x0,'String', num2str(x1-0.001));

% --- Executes on button press in sphere_x0_plus.
function sphere_x0_plus_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_x0_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2double(get(handles.sphere_x0,'String'));
set(handles.sphere_x0,'String', num2str(x1+0.001));

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





% --- Executes during object creation, after setting all properties.
function cylinder_x0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cylinder_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in cylinder_x0_plus.
function cylinder_x0_plus_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_x0_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2double(get(handles.cylinder_x0,'String'));
set(handles.cylinder_x0,'String', num2str(x1+0.001));



function cylinder_y0_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cylinder_y0 as text
%        str2double(get(hObject,'String')) returns contents of cylinder_y0 as a double


% --- Executes during object creation, after setting all properties.
function cylinder_y0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cylinder_y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cylinder_y0_minus.
function cylinder_y0_minus_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_y0_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y1=str2double(get(handles.cylinder_y0,'String'));
set(handles.cylinder_y0,'String', num2str(y1-0.001));

% --- Executes on button press in cylinder_y0_plus.
function cylinder_y0_plus_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_y0_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y1=str2double(get(handles.cylinder_y0,'String'));
set(handles.cylinder_y0,'String', num2str(y1+0.001));


function cylinder_radius_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cylinder_radius as text
%        str2double(get(hObject,'String')) returns contents of cylinder_radius as a double


% --- Executes during object creation, after setting all properties.
function cylinder_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cylinder_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cylinder_radius_minus.
function cylinder_radius_minus_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_radius_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r1=str2double(get(handles.cylinder_radius,'String'));
set(handles.cylinder_radius,'String', num2str(r1-0.001));

% --- Executes on button press in cylinder_radius_plus.
function cylinder_radius_plus_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_radius_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r1=str2double(get(handles.cylinder_radius,'String'));
set(handles.cylinder_radius,'String', num2str(r1+0.001));

% --- Executes on button press in cylinder_plot.
function cylinder_plot_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.datalist,'String');
index_selected = get(handles.datalist,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
data=datav;
clear datav;
%%get point
%figure(100);
xc=str2double(get(handles.cylinder_x0,'String'));
yc=str2double(get(handles.cylinder_y0,'String'));
r0=str2double(get(handles.cylinder_radius,'String'));
%%plotbutton cylinder
cylinder_plot(data,xc,yc,r0);
load('Colormap.mat');
colormap(flipud(cm_blue));

% --- Executes on button press in sphere_y0_minus.
function sphere_y0_minus_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_y0_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y1=str2double(get(handles.sphere_y0,'String'));
set(handles.sphere_y0,'String', num2str(y1-0.001));

% --- Executes on button press in sphere_y0_plus.
function sphere_y0_plus_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_y0_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y1=str2double(get(handles.sphere_y0,'String'));
set(handles.sphere_y0,'String', num2str(y1+0.001));

% --- Executes on button press in sphere_z0_minus.
function sphere_z0_minus_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_z0_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z1=str2double(get(handles.sphere_z0,'String'));
set(handles.sphere_z0,'String', num2str(z1-0.001));

% --- Executes on button press in sphere_z0_plus.
function sphere_z0_plus_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_z0_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z1=str2double(get(handles.sphere_z0,'String'));
set(handles.sphere_z0,'String', num2str(z1+0.001));


function sphere_radius_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sphere_radius as text
%        str2double(get(hObject,'String')) returns contents of sphere_radius as a double


% --- Executes during object creation, after setting all properties.
function sphere_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sphere_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sphere_radius_minus.
function sphere_radius_minus_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_radius_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r1=str2double(get(handles.sphere_radius,'String'));
set(handles.sphere_radius,'String', num2str(r1-0.001));

% --- Executes on button press in sphere_radius_plus.
function sphere_radius_plus_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_radius_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r1=str2double(get(handles.sphere_radius,'String'));
set(handles.sphere_radius,'String', num2str(r1+0.001));

% --- Executes on button press in sphere_plot.
function sphere_plot_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.datalist,'String');
index_selected = get(handles.datalist,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
data=datav;
clear datav;
r=str2double(get(handles.sphere_radius,'String'));
x0=str2double(get(handles.sphere_x0,'String'));
y0=str2double(get(handles.sphere_y0,'String'));
z0=str2double(get(handles.sphere_z0,'String'));
[x,y,z]=sphere(100);
x=x*r+x0;
y=y*r+y0;
z=z*r+z0;
h=figure;
slice(data.x,data.y,data.z,data.value,x,y,z);
load('Colormap.mat');
colormap(flipud(cm_blue));
shading interp;

% --- Executes on button press in cylinder_cut_plot.
function cylinder_cut_plot_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_cut_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.datalist,'String');
index_selected = get(handles.datalist,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
data=datav;
clear datav;

xc=str2double(get(handles.cylinder_x0,'string'));
yc=str2double(get(handles.cylinder_y0,'string'));
x0=str2double(get(handles.x0,'string'));
y0=str2double(get(handles.y0,'string'));
r0=str2double(get(handles.cylinder_radius,'string'));
theta1=str2double(get(handles.theta1,'string'));
theta2=str2double(get(handles.theta2,'string'));
z0=str2double(get(handles.energy,'string'));
h=cylinder_plot_cut(data,xc,yc,r0,x0,y0,theta1,theta2,z0);
load('Colormap.mat');
colormap(flipud(cm_blue));

% --- Executes on button press in sphere_cut_plot.
function sphere_cut_plot_Callback(hObject, eventdata, handles)
% hObject    handle to sphere_cut_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.datalist,'String');
index_selected = get(handles.datalist,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
data=datav;
clear datav;

x0=str2double(get(handles.sphere_x0,'String'));
y0=str2double(get(handles.sphere_y0,'String'));
z0=str2double(get(handles.sphere_z0,'String'));
r=str2double(get(handles.sphere_radius,'String'));
theta1=str2double(get(handles.theta1,'String'))*pi/180;
theta2=str2double(get(handles.theta2,'String'))*pi/180;
energy=str2double(get(handles.energy,'String'));
if theta1>theta2
    temp=theta1;
    theta1=theta2;
    theta2=temp;
end
spherecut(data,x0,y0,z0,r,theta1,theta2,energy);
load('Colormap.mat');
colormap(flipud(cm_blue));



function cylinder_x0_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cylinder_x0 as text
%        str2double(get(hObject,'String')) returns contents of cylinder_x0 as a double


% --- Executes on button press in cylinder_x0_minus.
function cylinder_x0_minus_Callback(hObject, eventdata, handles)
% hObject    handle to cylinder_x0_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2double(get(handles.cylinder_x0,'String'));
set(handles.cylinder_x0,'String', num2str(x1-0.001));
