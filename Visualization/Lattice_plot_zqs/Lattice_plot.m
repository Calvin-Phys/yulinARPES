function varargout = Lattice_plot(varargin)

% author: Qunsong Zeng
% e-mail: zqs1111@mail.ustc.edu.cn


% LATTICE_PLOT MATLAB code for Lattice_plot.fig
%      LATTICE_PLOT, by itself, creates a new LATTICE_PLOT or raises the existing
%      singleton*.
%
%      H = LATTICE_PLOT returns the handle to a new LATTICE_PLOT or the handle to
%      the existing singleton*.
%
%      LATTICE_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LATTICE_PLOT.M with the given input arguments.
%
%      LATTICE_PLOT('Property','Value',...) creates a new LATTICE_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Lattice_plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Lattice_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Lattice_plot

% Last Modified by GUIDE v2.5 06-Sep-2016 00:56:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Lattice_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @Lattice_plot_OutputFcn, ...
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


% --- Executes just before Lattice_plot is made visible.
function Lattice_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Lattice_plot (see VARARGIN)

% Choose default command line output for Lattice_plot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Lattice_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Lattice_plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in unit_cell_plot.
function unit_cell_plot_Callback(hObject, eventdata, handles)
% hObject    handle to unit_cell_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=str2double(get(handles.edit_a,'String'));
b=str2double(get(handles.edit_b,'String'));
c=str2double(get(handles.edit_c,'String'));
alpha=str2double(get(handles.edit_alpha,'String'));
beta=str2double(get(handles.edit_beta,'String'));
gamma=str2double(get(handles.edit_gamma,'String'));

figure(100);
if (a==b)&&(a==c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        cell_so_plot(a,b,c);
    elseif get(handles.body_centered,'value')
        cell_bc_plot(a,b,c);
    elseif get(handles.face_centered,'value')
        cell_fc_plot(a,b,c);
    elseif get(handles.side_centered,'value')
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        cell_so_plot(a,b,c);
    elseif get(handles.body_centered,'value')
        cell_bc_plot(a,b,c);
    else
        error_plot;
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        cell_so_plot(a,b,c);
    elseif get(handles.body_centered,'value')
        cell_bc_plot(a,b,c);
    elseif get(handles.face_centered,'value')
        cell_fc_plot(a,b,c);
    elseif get(handles.side_centered,'value')
        cell_sc_plot(a,b,c);
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(gamma==90)&&(beta~=90)
    if get(handles.primitive,'value')
        cell_mono_plot(a,b,c,beta);
    elseif get(handles.side_centered,'value')
        cell_mono_side_center_plot(a,b,c,beta);
    else
        error_plot;
    end
elseif (a==b)&&(b==c)&&(alpha==beta)&&(alpha==gamma)
    if get(handles.primitive,'value')
        cell_trigonal_plot(a,alpha);
    else
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==120)
    if get(handles.primitive,'value')
        cell_hex_plot(a,c);
    else
        error_plot;
    end
else
    sorry_plot;
end


% --- Executes on button press in lattice_plot.
function lattice_plot_Callback(hObject, eventdata, handles)
% hObject    handle to lattice_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nx=str2num(get(handles.edit_Nx,'String'));
ny=str2num(get(handles.edit_Ny,'String'));
nz=str2num(get(handles.edit_Nz,'String'));
a=str2double(get(handles.edit_a,'String'));
b=str2double(get(handles.edit_b,'String'));
c=str2double(get(handles.edit_c,'String'));
alpha=str2double(get(handles.edit_alpha,'String'));
beta=str2double(get(handles.edit_beta,'String'));
gamma=str2double(get(handles.edit_gamma,'String'));

figure(200);
if (a==b)&&(a==c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        lattice_sc(0,0,0,a,nx+1,ny+1,nz+1);
    elseif get(handles.body_centered,'value')
        lattice_bcc(0,0,0,a,nx,ny,nz);
    elseif get(handles.face_centered,'value')
        lattice_fcc(0,0,0,a,nx,ny,nz);
    elseif get(handles.side_centered,'value')
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        lattice_so(0,0,0,a,b,c,nx+1,ny+1,nz+1);
    elseif get(handles.body_centered,'value')
        lattice_body_centred(0,0,0,a,b,c,nx,ny,nz);
    else
        error_plot;
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        lattice_so(0,0,0,a,b,c,nx+1,ny+1,nz+1);
    elseif get(handles.body_centered,'value')
        lattice_body_centred(0,0,0,a,b,c,nx,ny,nz);
    elseif get(handles.face_centered,'value')
        lattice_face_centred(0,0,0,a,b,c,nx,ny,nz);
    elseif get(handles.side_centered,'value')
        lattice_side_centred(0,0,0,a,b,c,nx,ny,nz);
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(gamma==90)&&(beta~=90)
    if get(handles.primitive,'value')
        lattice_mono(0,0,0,a,b,c,beta,nx,ny,nz);
    elseif get(handles.side_centered,'value')
        lattice_side_centered_mono(0,0,0,a,b,c,beta,nx,ny,nz);
    else
        error_plot;
    end
elseif (a==b)&&(b==c)&&(alpha==beta)&&(alpha==gamma)
    if get(handles.primitive,'value')
        lattice_trigonal(0,0,0,a,alpha,nx,ny,nz);
    else
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==120)
    if get(handles.primitive,'value')
        lattice_prim(0,0,0,a,b,c,beta,gamma,nx,ny,nz);
    else
        error_plot;
    end
else
    sorry_plot;
end



% --- Executes on button press in show_planes.
function show_planes_Callback(hObject, eventdata, handles)
% hObject    handle to show_planes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nx=str2num(get(handles.edit_Nx,'String'));
ny=str2num(get(handles.edit_Ny,'String'));
nz=str2num(get(handles.edit_Nz,'String'));
a=str2double(get(handles.edit_a,'String'));
b=str2double(get(handles.edit_b,'String'));
c=str2double(get(handles.edit_c,'String'));
alpha=str2double(get(handles.edit_alpha,'String'));
beta=str2double(get(handles.edit_beta,'String'));
gamma=str2double(get(handles.edit_gamma,'String'));

miller_indices=str2num(get(handles.miller,'String'));
k=miller_indices(1);
l=miller_indices(2);
m=miller_indices(3);

figure(200);
if (a==b)&&(a==c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        [xlist,ylist,zlist]=lattice_sc(0,0,0,a,nx+1,ny+1,nz+1);
    elseif get(handles.body_centered,'value')
        [xlist,ylist,zlist]=lattice_bcc(0,0,0,a,nx,ny,nz);
    elseif get(handles.face_centered,'value')
        [xlist,ylist,zlist]=lattice_fcc(0,0,0,a,nx,ny,nz);
    elseif get(handles.side_centered,'value')
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        [xlist,ylist,zlist]=lattice_so(0,0,0,a,b,c,nx+1,ny+1,nz+1);
    elseif get(handles.body_centered,'value')
        [xlist,ylist,zlist]=lattice_body_centred(0,0,0,a,b,c,nx,ny,nz);
    else
        error_plot;
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        [xlist,ylist,zlist]=lattice_so(0,0,0,a,b,c,nx+1,ny+1,nz+1);
    elseif get(handles.body_centered,'value')
        [xlist,ylist,zlist]=lattice_body_centred(0,0,0,a,b,c,nx,ny,nz);
    elseif get(handles.face_centered,'value')
        [xlist,ylist,zlist]=lattice_face_centred(0,0,0,a,b,c,nx,ny,nz);
    elseif get(handles.side_centered,'value')
        [xlist,ylist,zlist]=lattice_side_centred(0,0,0,a,b,c,nx,ny,nz);
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(gamma==90)&&(beta~=90)
    if get(handles.primitive,'value')
        [xlist,ylist,zlist]=lattice_mono(0,0,0,a,b,c,beta,nx,ny,nz);
    elseif get(handles.side_centered,'value')
        [xlist,ylist,zlist]=lattice_side_centered_mono(0,0,0,a,b,c,beta,nx,ny,nz);
    else
        error_plot;
    end
elseif (a==b)&&(b==c)&&(alpha==beta)&&(alpha==gamma)
    if get(handles.primitive,'value')
        [xlist,ylist,zlist]=lattice_trigonal(0,0,0,a,alpha,nx,ny,nz);
    else
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==120)
    if get(handles.primitive,'value')
        [xlist,ylist,zlist]=lattice_prim(a,b,c,beta,gamma,nx,ny,nz);
    else
        error_plot;
    end
else
    sorry_plot;
end
millersurface(a,b,c,beta,gamma,k,l,m,xlist,ylist,zlist);

% --- Executes on button press in lattice_with_unit.
function lattice_with_unit_Callback(hObject, eventdata, handles)
% hObject    handle to lattice_with_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=str2double(get(handles.uitable,'Data'));
xlist=data(:,1);
ylist=data(:,2);
zlist=data(:,3);

nx=str2num(get(handles.edit_Nx,'String'));
ny=str2num(get(handles.edit_Ny,'String'));
nz=str2num(get(handles.edit_Nz,'String'));
a=str2double(get(handles.edit_a,'String'));
b=str2double(get(handles.edit_b,'String'));
c=str2double(get(handles.edit_c,'String'));
alpha=str2double(get(handles.edit_alpha,'String'));
beta=str2double(get(handles.edit_beta,'String'));
gamma=str2double(get(handles.edit_gamma,'String'));

k=0;
for i=1:15
    if ~isnan(xlist(i))
        k=k+1;
    end
end
figure(300);
hold on;
for i=1:k
if (a==b)&&(a==c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        lattice_sc(xlist(i),ylist(i),zlist(i),a,nx+1,ny+1,nz+1);
    elseif get(handles.body_centered,'value')
        lattice_bcc(xlist(i),ylist(i),zlist(i),a,nx,ny,nz);
    elseif get(handles.face_centered,'value')
        lattice_fcc(xlist(i),ylist(i),zlist(i),a,nx,ny,nz);
    elseif get(handles.side_centered,'value')
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        lattice_so(xlist(i),ylist(i),zlist(i),a,b,c,nx+1,ny+1,nz+1);
    elseif get(handles.body_centered,'value')
        lattice_body_centred(xlist(i),ylist(i),zlist(i),a,b,c,nx,ny,nz);
    else
        error_plot;
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        lattice_so(xlist(i),ylist(i),zlist(i),a,b,c,nx+1,ny+1,nz+1);
    elseif get(handles.body_centered,'value')
        lattice_body_centred(xlist(i),ylist(i),zlist(i),a,b,c,nx,ny,nz);
    elseif get(handles.face_centered,'value')
        lattice_face_centred(xlist(i),ylist(i),zlist(i),a,b,c,nx,ny,nz);
    elseif get(handles.side_centered,'value')
        lattice_side_centred(xlist(i),ylist(i),zlist(i),a,b,c,nx,ny,nz);
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(gamma==90)&&(beta~=90)
    if get(handles.primitive,'value')
        lattice_mono(xlist(i),ylist(i),zlist(i),a,b,c,beta,nx,ny,nz);
    elseif get(handles.side_centered,'value')
        lattice_side_centered_mono(xlist(i),ylist(i),zlist(i),a,b,c,beta,nx,ny,nz);
    else
        error_plot;
    end
elseif (a==b)&&(b==c)&&(alpha==beta)&&(alpha==gamma)
    if get(handles.primitive,'value')
        lattice_trigonal(xlist(i),ylist(i),zlist(i),a,alpha,nx,ny,nz);
    else
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==120)
    if get(handles.primitive,'value')
        lattice_prim(xlist(i),ylist(i),zlist(i),a,b,c,beta,gamma,nx,ny,nz);
    else
        error_plot;
    end
else
    sorry_plot;
end
end



function miller_Callback(hObject, eventdata, handles)
% hObject    handle to miller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of miller as text
%        str2double(get(hObject,'String')) returns contents of miller as a double


% --- Executes during object creation, after setting all properties.
function miller_CreateFcn(hObject, eventdata, handles)
% hObject    handle to miller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Nx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Nx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Nx as text
%        str2double(get(hObject,'String')) returns contents of edit_Nx as a double


% --- Executes during object creation, after setting all properties.
function edit_Nx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Nx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Ny_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ny as text
%        str2double(get(hObject,'String')) returns contents of edit_Ny as a double


% --- Executes during object creation, after setting all properties.
function edit_Ny_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Nz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Nz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Nz as text
%        str2double(get(hObject,'String')) returns contents of edit_Nz as a double


% --- Executes during object creation, after setting all properties.
function edit_Nz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Nz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Nx_minus.
function Nx_minus_Callback(hObject, eventdata, handles)
% hObject    handle to Nx_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Nx=str2double(get(handles.edit_Nx,'String'));
set(handles.edit_Nx,'String', num2str(Nx-1));

% --- Executes on button press in Nx_plus.
function Nx_plus_Callback(hObject, eventdata, handles)
% hObject    handle to Nx_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Nx=str2double(get(handles.edit_Nx,'String'));
set(handles.edit_Nx,'String', num2str(Nx+1));

% --- Executes on button press in Ny_minus.
function Ny_minus_Callback(hObject, eventdata, handles)
% hObject    handle to Ny_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ny=str2double(get(handles.edit_Ny,'String'));
set(handles.edit_Ny,'String', num2str(Ny-1));

% --- Executes on button press in Ny_plus.
function Ny_plus_Callback(hObject, eventdata, handles)
% hObject    handle to Ny_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ny=str2double(get(handles.edit_Ny,'String'));
set(handles.edit_Ny,'String', num2str(Ny+1));

% --- Executes on button press in Nz_minus.
function Nz_minus_Callback(hObject, eventdata, handles)
% hObject    handle to Nz_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Nz=str2double(get(handles.edit_Nz,'String'));
set(handles.edit_Nz,'String', num2str(Nz-1));

% --- Executes on button press in Nz_plus.
function Nz_plus_Callback(hObject, eventdata, handles)
% hObject    handle to Nz_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Nz=str2double(get(handles.edit_Nz,'String'));
set(handles.edit_Nz,'String', num2str(Nz+1));


function edit_gamma_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gamma as text
%        str2double(get(hObject,'String')) returns contents of edit_gamma as a double


% --- Executes during object creation, after setting all properties.
function edit_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_beta_Callback(hObject, eventdata, handles)
% hObject    handle to edit_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_beta as text
%        str2double(get(hObject,'String')) returns contents of edit_beta as a double


% --- Executes during object creation, after setting all properties.
function edit_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_alpha as a double


% --- Executes during object creation, after setting all properties.
function edit_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_c_Callback(hObject, eventdata, handles)
% hObject    handle to edit_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_c as text
%        str2double(get(hObject,'String')) returns contents of edit_c as a double


% --- Executes during object creation, after setting all properties.
function edit_c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_b_Callback(hObject, eventdata, handles)
% hObject    handle to edit_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_b as text
%        str2double(get(hObject,'String')) returns contents of edit_b as a double


% --- Executes during object creation, after setting all properties.
function edit_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_a_Callback(hObject, eventdata, handles)
% hObject    handle to edit_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_a as text
%        str2double(get(hObject,'String')) returns contents of edit_a as a double


% --- Executes during object creation, after setting all properties.
function edit_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes when entered data in editable cell(s) in uitable.
function uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
get(handles.uitable,'Data');



% --- Executes on button press in sublattice.
function sublattice_Callback(hObject, eventdata, handles)
% hObject    handle to sublattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(400);
data=str2double(get(handles.uitable,'Data'));
xlist=data(:,1);
ylist=data(:,2);
zlist=data(:,3);
k=0;
for i=1:15
    if ~isnan(xlist(i))
        k=k+1;
    end
end
hold on;
for i=1:k
    plot3(xlist(i),ylist(i),zlist(i),'.','markersize',30);
end


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
get(handles.uitable2,'Data');


% --- Executes on button press in plot_lattice.
function plot_lattice_Callback(hObject, eventdata, handles)
% hObject    handle to plot_lattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(500);
data2=str2double(get(handles.uitable2,'Data'));
red=data2(:,1);
green=data2(:,2);
blue=data2(:,3);
radius=data2(:,4);

data=str2double(get(handles.uitable,'Data'));
xlist=data(:,1);
ylist=data(:,2);
zlist=data(:,3);

nx=str2num(get(handles.edit_Nx,'String'));
ny=str2num(get(handles.edit_Ny,'String'));
nz=str2num(get(handles.edit_Nz,'String'));
a=str2double(get(handles.edit_a,'String'));
b=str2double(get(handles.edit_b,'String'));
c=str2double(get(handles.edit_c,'String'));
alpha=str2double(get(handles.edit_alpha,'String'));
beta=str2double(get(handles.edit_beta,'String'));
gamma=str2double(get(handles.edit_gamma,'String'));

k=0;
for i=1:15
    if ~isnan(xlist(i))
        k=k+1;
    end
end
figure(500);
hold on;
for i=1:k
if (a==b)&&(a==c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        [x_list,y_list,z_list]=lattice_sc(xlist(i),ylist(i),zlist(i),a,nx+1,ny+1,nz+1);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    elseif get(handles.body_centered,'value')
        [x_list,y_list,z_list]=lattice_bcc(xlist(i),ylist(i),zlist(i),a,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    elseif get(handles.face_centered,'value')
        [x_list,y_list,z_list]=lattice_fcc(xlist(i),ylist(i),zlist(i),a,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    elseif get(handles.side_centered,'value')
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        [x_list,y_list,z_list]=lattice_so(xlist(i),ylist(i),zlist(i),a,b,c,nx+1,ny+1,nz+1);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    elseif get(handles.body_centered,'value')
        [x_list,y_list,z_list]=lattice_body_centred(xlist(i),ylist(i),zlist(i),a,b,c,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    else
        error_plot;
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
    if get(handles.primitive,'value')
        [x_list,y_list,z_list]=lattice_so(xlist(i),ylist(i),zlist(i),a,b,c,nx+1,ny+1,nz+1);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    elseif get(handles.body_centered,'value')
        [x_list,y_list,z_list]=lattice_body_centred(xlist(i),ylist(i),zlist(i),a,b,c,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    elseif get(handles.face_centered,'value')
        [x_list,y_list,z_list]=lattice_face_centred(xlist(i),ylist(i),zlist(i),a,b,c,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    elseif get(handles.side_centered,'value')
        [x_list,y_list,z_list]=lattice_side_centred(xlist(i),ylist(i),zlist(i),a,b,c,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    end
elseif (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(gamma==90)&&(beta~=90)
    if get(handles.primitive,'value')
        [x_list,y_list,z_list]=lattice_mono(xlist(i),ylist(i),zlist(i),a,b,c,beta,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    elseif get(handles.side_centered,'value')
        [x_list,y_list,z_list]=lattice_side_centered_mono(xlist(i),ylist(i),zlist(i),a,b,c,beta,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    else
        error_plot;
    end
elseif (a==b)&&(b==c)&&(alpha==beta)&&(alpha==gamma)
    if get(handles.primitive,'value')
        [x_list,y_list,z_list]=lattice_trigonal(xlist(i),ylist(i),zlist(i),a,alpha,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    else
        error_plot;
    end
elseif (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==120)
    if get(handles.primitive,'value')
        [x_list,y_list,z_list]=lattice_prim(xlist(i),ylist(i),zlist(i),a,b,c,beta,gamma,nx,ny,nz);
        lattice_with_ball(x_list,y_list,z_list,radius(i),red(i),green(i),blue(i));
    else
        error_plot;
    end
else
    sorry_plot;
end
end
axis tight;
axis equal;
axis vis3d;
light;



function point11_Callback(hObject, eventdata, handles)
% hObject    handle to point11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of point11 as text
%        str2double(get(hObject,'String')) returns contents of point11 as a double


% --- Executes during object creation, after setting all properties.
function point11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to point11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function point12_Callback(hObject, eventdata, handles)
% hObject    handle to point12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of point12 as text
%        str2double(get(hObject,'String')) returns contents of point12 as a double


% --- Executes during object creation, after setting all properties.
function point12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to point12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function point13_Callback(hObject, eventdata, handles)
% hObject    handle to point13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of point13 as text
%        str2double(get(hObject,'String')) returns contents of point13 as a double


% --- Executes during object creation, after setting all properties.
function point13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to point13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_plane2.
function plot_plane2_Callback(hObject, eventdata, handles)
% hObject    handle to plot_plane2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
point11=str2num(get(handles.point11,'String'));
point12=str2num(get(handles.point12,'String'));
point13=str2num(get(handles.point13,'String'));
pt_plane2 = [point11',point12',point13'];
figure(500);
hold on;
h2=fill3(pt_plane2(1,:),pt_plane2(2,:),pt_plane2(3,:),'b');
alpha(h2,0.5);
hold off;


function point1_Callback(hObject, eventdata, handles)
% hObject    handle to point1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of point1 as text
%        str2double(get(hObject,'String')) returns contents of point1 as a double


% --- Executes during object creation, after setting all properties.
function point1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to point1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function point2_Callback(hObject, eventdata, handles)
% hObject    handle to point2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of point2 as text
%        str2double(get(hObject,'String')) returns contents of point2 as a double


% --- Executes during object creation, after setting all properties.
function point2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to point2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function point3_Callback(hObject, eventdata, handles)
% hObject    handle to point3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of point3 as text
%        str2double(get(hObject,'String')) returns contents of point3 as a double


% --- Executes during object creation, after setting all properties.
function point3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to point3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_plane1.
function plot_plane1_Callback(hObject, eventdata, handles)
% hObject    handle to plot_plane1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
point1=str2num(get(handles.point1,'String'));
point2=str2num(get(handles.point2,'String'));
point3=str2num(get(handles.point3,'String'));
pt_plane1 = [point1',point2',point3'];
figure(500);
hold on;
h1=fill3(pt_plane1(1,:),pt_plane1(2,:),pt_plane1(3,:),'r');
alpha(h1,0.5);
hold off;
