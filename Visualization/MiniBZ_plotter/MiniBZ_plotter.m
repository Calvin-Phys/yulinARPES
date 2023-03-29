function varargout = MiniBZ_plotter(varargin)
% MINIBZ_PLOTTER MATLAB code for MiniBZ_plotter.fig
%      MINIBZ_PLOTTER, by itself, creates a new MINIBZ_PLOTTER or raises the existing
%      singleton*.
%
%      H = MINIBZ_PLOTTER returns the handle to a new MINIBZ_PLOTTER or the handle to
%      the existing singleton*.
%
%      MINIBZ_PLOTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MINIBZ_PLOTTER.M with the given input arguments.
%
%      MINIBZ_PLOTTER('Property','Value',...) creates a new MINIBZ_PLOTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MiniBZ_plotter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MiniBZ_plotter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MiniBZ_plotter

% Last Modified by GUIDE v2.5 08-Sep-2020 17:38:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MiniBZ_plotter_OpeningFcn, ...
                   'gui_OutputFcn',  @MiniBZ_plotter_OutputFcn, ...
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


% --- Executes just before MiniBZ_plotter is made visible.
function MiniBZ_plotter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MiniBZ_plotter (see VARARGIN)

% Choose default command line output for MiniBZ_plotter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MiniBZ_plotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MiniBZ_plotter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Top_Lattice_Callback(hObject, eventdata, handles)
% hObject    handle to Top_Lattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Top_Lattice as text
%        str2double(get(hObject,'String')) returns contents of Top_Lattice as a double


% --- Executes during object creation, after setting all properties.
function Top_Lattice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Top_Lattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Top_Rotation_Callback(hObject, eventdata, handles)
% hObject    handle to Top_Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Top_Rotation as text
%        str2double(get(hObject,'String')) returns contents of Top_Rotation as a double


% --- Executes during object creation, after setting all properties.
function Top_Rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Top_Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bottom_Lattice_Callback(hObject, eventdata, handles)
% hObject    handle to Bottom_Lattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bottom_Lattice as text
%        str2double(get(hObject,'String')) returns contents of Bottom_Lattice as a double


% --- Executes during object creation, after setting all properties.
function Bottom_Lattice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bottom_Lattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bottom_Rotation_Callback(hObject, eventdata, handles)
% hObject    handle to Bottom_Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bottom_Rotation as text
%        str2double(get(hObject,'String')) returns contents of Bottom_Rotation as a double


% --- Executes during object creation, after setting all properties.
function Bottom_Rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bottom_Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Plot_BZ.
function Plot_BZ_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_BZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Top_Lattice=str2double(get(handles.Top_Lattice,'String'));
Bottom_Lattice=str2double(get(handles.Bottom_Lattice,'String'));
Top_Rotation=str2double(get(handles.Top_Rotation,'String'));
Bottom_Rotation=str2double(get(handles.Bottom_Rotation,'String'));
Fig_No=str2num(get(handles.Figure_Num,'String'));
kxstart=str2num(get(handles.kx_min,'String'));
kystart=str2num(get(handles.ky_min,'String'));
kxend=str2num(get(handles.kx_max,'String'));
kyend=str2num(get(handles.ky_max,'String'));
figure(Fig_No);
hold on;
color_top='red';
color_bot='black';
plotBZ_demo_old(Top_Lattice,Top_Rotation,kxstart,kxend,kystart,kyend,color_top);
plotBZ_demo_old(Bottom_Lattice,Bottom_Rotation,kxstart,kxend,kystart,kyend,color_bot);
axis equal;
hold off



% --- Executes on button press in Plot_MiniBZ.
function Plot_MiniBZ_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_MiniBZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Top_Lattice=str2double(get(handles.Top_Lattice,'String'));
Bottom_Lattice=str2double(get(handles.Bottom_Lattice,'String'));
Top_Rotation=str2double(get(handles.Top_Rotation,'String'));
Bottom_Rotation=str2double(get(handles.Bottom_Rotation,'String'));

theta=abs(Top_Rotation-Bottom_Rotation)/180*pi;
Lattice=Top_Lattice/(2*sin(theta/2));

%ratio=floor(Lattice/Top_Lattice)+1;
Rotation=MiniBZ_Rotation(Top_Rotation,Bottom_Rotation,Top_Lattice)+60;

Fig_No=str2num(get(handles.Figure_Num,'String'));
kxstart=str2num(get(handles.Mini_kx_min,'String'));
kystart=str2num(get(handles.Mini_ky_min,'String'));
kxend=str2num(get(handles.Mini_kx_max,'String'));
kyend=str2num(get(handles.Mini_ky_max,'String'));
color='blue';
figure(Fig_No);
hold on;
plotBZ_demo_old(Lattice,Rotation,kxstart,kxend,kystart,kyend,color);

axis equal;
hold off


function Figure_Num_Callback(hObject, eventdata, handles)
% hObject    handle to Figure_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Figure_Num as text
%        str2double(get(hObject,'String')) returns contents of Figure_Num as a double


% --- Executes during object creation, after setting all properties.
function Figure_Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Figure_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kx_min_Callback(hObject, eventdata, handles)
% hObject    handle to kx_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kx_min as text
%        str2double(get(hObject,'String')) returns contents of kx_min as a double


% --- Executes during object creation, after setting all properties.
function kx_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kx_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kx_max_Callback(hObject, eventdata, handles)
% hObject    handle to kx_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kx_max as text
%        str2double(get(hObject,'String')) returns contents of kx_max as a double


% --- Executes during object creation, after setting all properties.
function kx_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kx_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ky_min_Callback(hObject, eventdata, handles)
% hObject    handle to ky_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ky_min as text
%        str2double(get(hObject,'String')) returns contents of ky_min as a double


% --- Executes during object creation, after setting all properties.
function ky_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ky_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ky_max_Callback(hObject, eventdata, handles)
% hObject    handle to ky_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ky_max as text
%        str2double(get(hObject,'String')) returns contents of ky_max as a double


% --- Executes during object creation, after setting all properties.
function ky_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ky_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Append.
function Append_Callback(hObject, eventdata, handles)
% hObject    handle to Append (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function y=plotBZ_demo_old(a,rotation,kxstart,kxend,kystart,kyend,color)
%a,b,c is the lattice constant (in A), alpha, beta, gamma is the
%<ac,<bc,<ab, plot scale would be (pi/unit), so if unit=pi, plot unit would
%be 1/A. plane=1,2,3 plots (kyz,kxz,kxy) respectively. the plot starts with
%kxstart to kxend (kxend>kxstart),k_cutvalue is the k value perpendicular
%to the cutplane


gamma=120*pi/180;
rotation=rotation*pi/180;

T1_ori = [a, 0, 0];
T2_ori = [a * cos(gamma), a	* sin(gamma), 0];
T3_ori = [0, 0, 1];


%rotate by omega degrees
T1(1)=T1_ori(1)*cos(rotation)-T1_ori(2)*sin(rotation);
T1(2)=T1_ori(1)*sin(rotation)+T1_ori(2)*cos(rotation);
T1(3)=T1_ori(3);

T2(1)=T2_ori(1)*cos(rotation)-T2_ori(2)*sin(rotation);
T2(2)=T2_ori(1)*sin(rotation)+T2_ori(2)*cos(rotation);
T2(3)=T2_ori(3);

T3(1)=T3_ori(1)*cos(rotation)-T3_ori(2)*sin(rotation);
T3(2)=T3_ori(1)*sin(rotation)+T3_ori(2)*cos(rotation);
T3(3)=T3_ori(3);

spat=cross(T1,T2)*T3';

G1=2*pi*cross(T2,T3)/spat;
G2=2*pi*cross(T3,T1)/spat;
G1=G1(1:2);
G2=G2(1:2);
testpt1_all=0;
testpt2_all=0;

[testpt1_all,testpt2_all]=generate_bz(G1,G2,kxstart,kxend,kystart,kyend,color);




function [testpt1_all,testpt2_all]=generate_bz(G1,G2,kx_start,kx_end,ky_start,ky_end,color)
loop=1;
for i1=kx_start:kx_end
    for i2=ky_start:ky_end            
X = zeros(9,2);
l=1;
hold on;
for i=-1+i1:1+i1;
    for j=-1+i2:1+i2;       
            X(l,:)=i*G1+j*G2;
            l=l+1;                
    end
end
[c,v] = voronoin(X);
            nx = c(v{5},:);
        tri = convhulln(nx);
        clear testpt1 testpt2 testpt3;
        for ii=1:size(tri,1)
            testpt1(ii,:)=nx(tri(ii,:),1);
            testpt2(ii,:)=nx(tri(ii,:),2);
            if ii<size(tri,1)
            line([nx(ii,1),nx(ii+1,1)],[nx(ii,2),nx(ii+1,2)],'Color',color);
            %line([nx(ii,1)+0.1246,nx(ii+1,1)+0.1246],[nx(ii,2)+0.466,nx(ii+1,2)+0.466],'Color',color);
            else
              line([nx(size(tri,1),1),nx(1,1)],[nx(size(tri,1),2),nx(1,2)],'Color',color);
              %line([nx(6,1)+0.1246,nx(1,1)+0.1246],[nx(6,2)+0.466,nx(1,2)+0.466],'Color',color);
            end
        end      
        
        if loop==1
            testpt1_all=testpt1;
            testpt2_all=testpt2;          
        else
            testpt1_all=[testpt1_all;testpt1];
            testpt2_all=[testpt2_all;testpt2];       
        end  
     loop=loop+1;        
    end
end
hold off;

function Rotation=MiniBZ_Rotation(Top_Rotation,Bottom_Rotation,Lattice)
top=Top_Rotation*pi/180;
bot=Bottom_Rotation*pi/180;
v_top=[Lattice*cos(top),Lattice*sin(top)];
v_bot=[Lattice*cos(bot),Lattice*sin(bot)];
v=v_bot-v_top;
Rotation=acos(dot(v,[1,0])/norm(v))/pi*180;



function Mini_kx_min_Callback(hObject, eventdata, handles)
% hObject    handle to Mini_kx_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mini_kx_min as text
%        str2double(get(hObject,'String')) returns contents of Mini_kx_min as a double


% --- Executes during object creation, after setting all properties.
function Mini_kx_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mini_kx_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mini_kx_max_Callback(hObject, eventdata, handles)
% hObject    handle to Mini_kx_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mini_kx_max as text
%        str2double(get(hObject,'String')) returns contents of Mini_kx_max as a double


% --- Executes during object creation, after setting all properties.
function Mini_kx_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mini_kx_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mini_ky_min_Callback(hObject, eventdata, handles)
% hObject    handle to Mini_ky_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mini_ky_min as text
%        str2double(get(hObject,'String')) returns contents of Mini_ky_min as a double


% --- Executes during object creation, after setting all properties.
function Mini_ky_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mini_ky_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mini_ky_max_Callback(hObject, eventdata, handles)
% hObject    handle to Mini_ky_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mini_ky_max as text
%        str2double(get(hObject,'String')) returns contents of Mini_ky_max as a double


% --- Executes during object creation, after setting all properties.
function Mini_ky_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mini_ky_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
