function varargout = massplott_2(varargin)
% MASSPLOTT_2 MATLAB code for massplott_2.fig
%      MASSPLOTT_2, by itself, creates a new MASSPLOTT_2 or raises the existing
%      singleton*.
%
%      H = MASSPLOTT_2 returns the handle to a new MASSPLOTT_2 or the handle to
%      the existing singleton*.
%
%      MASSPLOTT_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASSPLOTT_2.M with the given input arguments.
%
%      MASSPLOTT_2('Property','Value',...) creates a new MASSPLOTT_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before massplott_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to massplott_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help massplott_2

% Last Modified by GUIDE v2.5 15-Dec-2016 21:38:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @massplott_2_OpeningFcn, ...
                   'gui_OutputFcn',  @massplott_2_OutputFcn, ...
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


% --- Executes just before massplott_2 is made visible.
function massplott_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to massplott_2 (see VARARGIN)

% Choose default command line output for massplott_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes massplott_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = massplott_2_OutputFcn(hObject, eventdata, handles) 
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
cols=str2num(get(handles.col,'String'));
rows=str2num(get(handles.rows,'String'));


for ii=1:length(var_name)
if mod(ii,cols*rows)==1 %starts new figure if index exceeds subplot number
    figure
    set(gcf,'Color','white');
    subplot_index=1;
end;
    data=evalin('base',var_name{ii});
    subplot(rows,cols,subplot_index)
    subplot_index=subplot_index+1;
    pcolor(data.x,data.y,data.value');
    colormap(flipud(gray));
    shading interp;
%    title(['T=' sprintf('%.2f',data.info.Temperature) 'K    ' var_name{ii}],'Interpreter', 'none');
    axis equal;
end;    
    



function col_Callback(hObject, eventdata, handles)
% hObject    handle to col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of col as text
%        str2double(get(hObject,'String')) returns contents of col as a double


% --- Executes during object creation, after setting all properties.
function col_CreateFcn(hObject, eventdata, handles)
% hObject    handle to col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rows_Callback(hObject, eventdata, handles)
% hObject    handle to rows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rows as text
%        str2double(get(hObject,'String')) returns contents of rows as a double


% --- Executes during object creation, after setting all properties.
function rows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rows (see GCBO)
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
h=gca;
CLIM_sample=h.CLim;
figHandles = get(gcf,'children');
for ii=1:length(figHandles)
figHandles(ii).CLim=CLIM_sample;

end;



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
line('XData', [-1 1], 'YData', [1 -1], 'LineStyle', '-', ...
'LineWidth', 0.5, 'Color','m')
line('XData', [-1 1], 'YData', [-1 1], 'LineStyle', '-', ...
'LineWidth', 0.5, 'Color','m')
line('XData', [-cosd(30) cosd(30)], 'YData', [-sind(30) sind(30)], 'LineStyle', '-', ...
'LineWidth', 0.5, 'Color','m')
line('XData', [-cosd(30) cosd(30)], 'YData', [sind(30) -sind(30)], 'LineStyle', '-', ...
'LineWidth', 0.5, 'Color','m')



function figNum_Callback(hObject, eventdata, handles)
% hObject    handle to figNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figNum as text
%        str2double(get(hObject,'String')) returns contents of figNum as a double


% --- Executes during object creation, after setting all properties.
function figNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figNum (see GCBO)
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
figure(gcf)
eval(['export_fig ' (get(handles.savepath,'String'))])
%saveas(gcf,get(handles.savepath,'String'),handles.extension_type.String{handles.extension_type.Value})
% if handles.extension_type.String
%     savefig(get(handles.savepath,'String'))
% else
%     saveas(a, 'path\to\file\abc1.png','png');
% end;

function savepath_Callback(hObject, eventdata, handles)
% hObject    handle to savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savepath as text
%        str2double(get(hObject,'String')) returns contents of savepath as a double


% --- Executes during object creation, after setting all properties.
function savepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over savepath.
function savepath_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h1=gca;
h1=h1.Title.String;
h1=strrep(h1,'\','');
set(handles.savepath,'String',h1)


% --- Executes on selection change in extension_type.
function extension_type_Callback(hObject, eventdata, handles)
% hObject    handle to extension_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns extension_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from extension_type


% --- Executes during object creation, after setting all properties.
function extension_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to extension_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Del_lines.
function Del_lines_Callback(hObject, eventdata, handles)
% hObject    handle to Del_lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj(gca,'Type','line');
delete(h(:));


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
for ii=1:length(var_name)
    evalin('base',[var_name{ii} '_log' '=' var_name{ii} ';'])
    evalin('base',[var_name{ii} '_log.value' '=log(' var_name{ii} '_log.value);' ])
end;


% --- Executes on button press in EDC_button.
function EDC_button_Callback(hObject, eventdata, handles)
% hObject    handle to EDC_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig_no=str2num(handles.Fig_no.String);
real_space_cut_value=str2double(handles.momentum.String);
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end

handles_h = guidata(h);
var_name = handles_h.VarNames;
figure(fig_no);
set(gcf,'color','w');
sum_index_range=str2num(get(handles.index_range_averaging,'String'));
file_ext=get(handles.file_ext_edit,'String');

stacking_offset=str2num(get(handles.edit_stacking_offset,'String'));

hold on

listbox2_entries=get(handles.listbox2,'String');
title_info_index=get(handles.listbox2,'Value');
title_info=listbox2_entries{title_info_index};

%sort according to remperature
if get(handles.radiobutton_sort_massplott,'Value')
    title_list=[];
    for ii=1:length(var_name)
        data=evalin('base',var_name{ii});
        title_list_item=evalin('base',[var_name{ii},'.info.',title_info]);
        title_list=[title_list title_list_item];
    end
    [~,sort_index]=sort(title_list);
else
    sort_index=1:length(var_name);
end;

kk=1;
for ii=sort_index
    data=evalin('base',var_name{ii});
    [~,index_cut_no]=min(abs(data.x-real_space_cut_value));
    x=data.y;
    
    if sum_index_range>0
        ranger=index_cut_no-sum_index_range:index_cut_no+sum_index_range;
        y=mean(data.value(ranger,:),1);
    else
        y=data.value(index_cut_no,:);
    end;
    %x=smooth(x,3);
    %y=smooth(y,3);
    plot_handles{1,kk}=plot(x, y+(kk-1)*stacking_offset);
    EDC_data=zeros(2,length(x));
    EDC_data(1,:)=x;
    EDC_data(2,:)=y;
    assignin('base',[var_name{1} '_EDC_' file_ext],EDC_data);
    plot_handles{2,kk}=num2str(evalin('base',[var_name{ii},'.info.',title_info]));
    kk=kk+1;
    %evalin('base',['plot(' var_name{ii} '.y,' var_name{ii} '.value(' num2str(index_cut_no) ',:));'])

end;
tmp=allchild(gca);
legend(tmp,flip(plot_handles(2,:)));
hold off



function Fig_no_Callback(hObject, eventdata, handles)
% hObject    handle to Fig_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fig_no as text
%        str2double(get(hObject,'String')) returns contents of Fig_no as a double


% --- Executes during object creation, after setting all properties.
function Fig_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fig_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function momentum_Callback(hObject, eventdata, handles)
% hObject    handle to momentum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of momentum as text
%        str2double(get(hObject,'String')) returns contents of momentum as a double


% --- Executes during object creation, after setting all properties.
function momentum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to momentum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function index_range_averaging_Callback(hObject, eventdata, handles)
% hObject    handle to index_range_averaging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of index_range_averaging as text
%        str2double(get(hObject,'String')) returns contents of index_range_averaging as a double



% --- Executes during object creation, after setting all properties.
function index_range_averaging_CreateFcn(hObject, eventdata, handles)
% hObject    handle to index_range_averaging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hkl_Callback(hObject, eventdata, handles)
% hObject    handle to hkl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hkl as text
%        str2double(get(hObject,'String')) returns contents of hkl as a double


% --- Executes during object creation, after setting all properties.
function hkl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hkl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k_z_perc_Callback(hObject, eventdata, handles)
% hObject    handle to k_z_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k_z_perc as text
%        str2double(get(hObject,'String')) returns contents of k_z_perc as a double


% --- Executes during object creation, after setting all properties.
function k_z_perc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k_z_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lattice_const_Callback(hObject, eventdata, handles)
% hObject    handle to lattice_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lattice_const as text
%        str2double(get(hObject,'String')) returns contents of lattice_const as a double


% --- Executes during object creation, after setting all properties.
function lattice_const_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lattice_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_BZ_cut.
function plot_BZ_cut_Callback(hObject, eventdata, handles)
% hObject    handle to plot_BZ_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load variables from field handles
no_boxes=str2num(get(handles.no_BZs,'String'));
hkl=str2num(get(handles.hkl,'String'));
kz_fraction=str2num(get(handles.k_z_perc,'String'))/100;
lattice_constant=str2num(get(handles.lattice_const,'String'));
rot=str2num(get(handles.rot,'String'));
fig_display=str2num(get(handles.fig_BZ_cut,'String'));
color_BZ_cut=get(handles.color_BZ_cut,'String');

% prepare axis and figure to plot
current_axes=gca;
fig_1=figure(fig_display); clf; hold on;
set(gcf,'color','w');
    if get(handles.radiobutton_axis_equal,'Value')
        axis equal;
    end
ax_lim=(2*pi/lattice_constant)*no_boxes;
axis([-ax_lim ax_lim -ax_lim ax_lim -ax_lim ax_lim]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [400 -200 800]);

% prepare the normal vector to the cutting plane
hkl=(2*pi/lattice_constant)*hkl;
cut_point=kz_fraction*hkl;
cut_normal=hkl;

% prepare the cubic lattice vectors (in reciprocal space)
x_unit=(2*pi/lattice_constant)*[1 0 0];
y_unit=(2*pi/lattice_constant)*[0 1 0];
z_unit=(2*pi/lattice_constant)*[0 0 1];

% create and plot the cut plane
cut_plane=createPlane(cut_point,cut_normal);
figure(fig_1)
set(gcf,'color','w');
drawPlane3d(cut_plane, 'b')
alpha(0.5)

% calculate and plot the brilloiun zones in reciprocal space, as well as
% intersections with cut plane
for ii=-no_boxes:no_boxes
figure(fig_1)
set(gcf,'color','w');
hold on
%generate points on the cubic planes
   p_x=(2*pi/lattice_constant)*[ii 0 0];
   p_y=(2*pi/lattice_constant)*[0 ii 0];
   p_z=(2*pi/lattice_constant)*[0 0 ii];
   
%create cubic planes
   plane_x=createPlane(p_x,x_unit);
   plane_y=createPlane(p_y,y_unit);
   plane_z=createPlane(p_z,z_unit);
%plot cubic planes    
   sketch_plane_x=drawPlane3d(plane_x, 'y');
   alpha(0.2)
   sketch_plane_y=drawPlane3d(plane_y, 'y');
   alpha(0.2)
   sketch_plane_z=drawPlane3d(plane_z, 'y');
   alpha(0.2)
   
%create and plot intersections between cut plane and cubic planes
   line{1} = intersectPlanes(plane_x, cut_plane);
   line{2} = intersectPlanes(plane_y, cut_plane);
   line{3} = intersectPlanes(plane_z, cut_plane);
drawLine3d(line{1}, 'lineWidth', 2 ,'Color',color_BZ_cut);
drawLine3d(line{2}, 'lineWidth', 2,'Color',color_BZ_cut);
drawLine3d(line{3}, 'lineWidth', 2,'Color',color_BZ_cut);

% draw flat plane in current axis
axes(current_axes);
set(gcf,'color','w');
hold on
[delta_a,delta_e,r]=cart2sph(cut_normal(1),cut_normal(2),cut_normal(3));
for kk=1:3
    line_temp=line{kk};
    line_point=line_temp(1:3);
    %the lines have to be rotated such that they are parallel to the x-y
    %plane, see geom3d documentation on how to define lines
    line_point=(rotz(rot)*rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*line_point')';
    line_point(3)=0;
    line_direction=line_temp(4:6);
    line_direction=(rotz(rot)*rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*line_direction')';
    line_flat=cat(2,line_point,line_direction);
    drawLine3d(line_flat, 'lineWidth', 2, 'Color',color_BZ_cut);
end
end

function fig_BZ_cut_Callback(hObject, eventdata, handles)
% hObject    handle to fig_BZ_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fig_BZ_cut as text
%        str2double(get(hObject,'String')) returns contents of fig_BZ_cut as a double


% --- Executes during object creation, after setting all properties.
function fig_BZ_cut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fig_BZ_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function no_BZs_Callback(hObject, eventdata, handles)
% hObject    handle to no_BZs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_BZs as text
%        str2double(get(hObject,'String')) returns contents of no_BZs as a double


% --- Executes during object creation, after setting all properties.
function no_BZs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_BZs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rot_Callback(hObject, eventdata, handles)
% hObject    handle to rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot as text
%        str2double(get(hObject,'String')) returns contents of rot as a double


% --- Executes during object creation, after setting all properties.
function rot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in color_BZ_cut.
function color_BZ_cut_Callback(hObject, eventdata, handles)
% hObject    handle to color_BZ_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns color_BZ_cut contents as cell array
%        contents{get(hObject,'Value')} returns selected item from color_BZ_cut


% --- Executes during object creation, after setting all properties.
function color_BZ_cut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to color_BZ_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hkl_additional_cut_Callback(hObject, eventdata, handles)
% hObject    handle to hkl_additional_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hkl_additional_cut as text
%        str2double(get(hObject,'String')) returns contents of hkl_additional_cut as a double


% --- Executes during object creation, after setting all properties.
function hkl_additional_cut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hkl_additional_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function color_additional_plane_Callback(hObject, eventdata, handles)
% hObject    handle to color_additional_plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of color_additional_plane as text
%        str2double(get(hObject,'String')) returns contents of color_additional_plane as a double


% --- Executes during object creation, after setting all properties.
function color_additional_plane_CreateFcn(hObject, eventdata, handles)
% hObject    handle to color_additional_plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k_norm_perc_Callback(hObject, eventdata, handles)
% hObject    handle to k_norm_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k_norm_perc as text
%        str2double(get(hObject,'String')) returns contents of k_norm_perc as a double


% --- Executes during object creation, after setting all properties.
function k_norm_perc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k_norm_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add_cut.
function add_cut_Callback(hObject, eventdata, handles)
% hObject    handle to add_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load variables from field handles
no_boxes=str2num(get(handles.no_BZs,'String'));
% hkl=str2num(get(handles.hkl_additional_cut,'String'));
kz_fraction=str2num(get(handles.k_norm_perc,'String'))/100;
lattice_constant=str2num(get(handles.lattice_const,'String'));
rot=str2num(get(handles.rot,'String'));
fig_display=str2num(get(handles.fig_BZ_cut,'String'));
color_BZ_cut=get(handles.color_additional_plane,'String');
original_hkl=str2num(get(handles.hkl,'String'));    
rot_perp_BZ=str2num(get(handles.rot_perp_BZ,'String'));
xoff=str2num(get(handles.xoff,'String'));
yoff=str2num(get(handles.yoff,'String'));
% calculate planes and intersections and plot

current_axes=gca;
fig_1=figure(fig_display); hold on;
set(gcf,'color','w');

% hkl=(2*pi/lattice_constant)*hkl;
% cut_point=kz_fraction*hkl;
% cut_normal=hkl;

x_unit=(2*pi/lattice_constant)*[1 0 0];
y_unit=(2*pi/lattice_constant)*[0 1 0];
z_unit=(2*pi/lattice_constant)*[0 0 1];

[delta_a,delta_e,r]=cart2sph(original_hkl(1),original_hkl(2),original_hkl(3));
hkl=(rotz(rad2deg(delta_a))*roty((90-rad2deg(delta_e)))*rotz(-rot)*y_unit')';
cut_normal=(1/hkl(1))*hkl;
cut_point=kz_fraction*cut_normal;

cut_plane=createPlane(cut_point,cut_normal);
figure(fig_1)
drawPlane3d(cut_plane, color_BZ_cut)
alpha(0.5)
for ii=-no_boxes:no_boxes
figure(fig_1)
hold on
   p_x=(2*pi/lattice_constant)*[ii 0 0];
   p_y=(2*pi/lattice_constant)*[0 ii 0];
   p_z=(2*pi/lattice_constant)*[0 0 ii];
   

   plane_x=createPlane(p_x,x_unit);
   plane_y=createPlane(p_y,y_unit);
   plane_z=createPlane(p_z,z_unit);
    
%    sketch_plane_x=drawPlane3d(plane_x, 'y');
%    alpha(0.2)
%    sketch_plane_y=drawPlane3d(plane_y, 'y');
%    alpha(0.2)
%    sketch_plane_z=drawPlane3d(plane_z, 'y');
%    alpha(0.2)
   
   
   line{1} = intersectPlanes(plane_x, cut_plane);
   line{2} = intersectPlanes(plane_y, cut_plane);
   line{3} = intersectPlanes(plane_z, cut_plane);
drawLine3d(line{1}, 'lineWidth', 2 ,'Color',color_BZ_cut);
drawLine3d(line{2}, 'lineWidth', 2,'Color',color_BZ_cut);
drawLine3d(line{3}, 'lineWidth', 2,'Color',color_BZ_cut);

%   %% draw flat plane
 axes(current_axes);
 hold on
 [delta_a,delta_e,r]=cart2sph(cut_normal(1),cut_normal(2),cut_normal(3));
 for kk=1:3
    line_temp=line{kk};
    line_point=line_temp(1:3);
    line_point=(rotz(rot_perp_BZ)*rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*line_point')';
    line_point(3)=0;
    line_point=line_point+xoff*[1 0 0]+yoff*[0 1 0];
    line_direction=line_temp(4:6);
    line_direction=(rotz(rot_perp_BZ)*rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*line_direction')';
    line_flat=cat(2,line_point,line_direction);
    drawLine3d(line_flat, 'lineWidth', 2, 'Color',color_BZ_cut);
 end;
end



function rot_perp_BZ_Callback(hObject, eventdata, handles)
% hObject    handle to rot_perp_BZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot_perp_BZ as text
%        str2double(get(hObject,'String')) returns contents of rot_perp_BZ as a double


% --- Executes during object creation, after setting all properties.
function rot_perp_BZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot_perp_BZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xoff_Callback(hObject, eventdata, handles)
% hObject    handle to xoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xoff as text
%        str2double(get(hObject,'String')) returns contents of xoff as a double


% --- Executes during object creation, after setting all properties.
function xoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yoff_Callback(hObject, eventdata, handles)
% hObject    handle to yoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yoff as text
%        str2double(get(hObject,'String')) returns contents of yoff as a double


% --- Executes during object creation, after setting all properties.
function yoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
cols=str2num(get(handles.col,'String'));
rows=str2num(get(handles.rows,'String'));
listbox2_entries=get(handles.listbox2,'String');
title_info_index=get(handles.listbox2,'Value');
title_info=listbox2_entries{title_info_index};

if get(handles.radiobutton_sort_massplott,'Value')
    title_list=[];
    for ii=1:length(var_name)
        data=evalin('base',var_name{ii});
        title_list_item=evalin('base',[var_name{ii},'.info.',title_info]);
        title_list=[title_list title_list_item];
    end
    [~,sort_index]=sort(title_list);
else
    sort_index=1:length(var_name);
end;

kk=1;
for ii=sort_index
if mod(kk,cols*rows)==1 %starts new figure if index exceeds subplot number
    figure
    set(gcf,'Color','white');
    subplot_index=1;
end;
    data=evalin('base',var_name{ii});
    data.value=squeeze(data.value(:,:,1));
    subplot(rows,cols,subplot_index)
    subplot_index=subplot_index+1;
    pcolor(data.x,data.y,data.value');
    if get(handles.radiobutton_axis_equal,'Value')
        axis equal
    end
%    axis tight;
    colormap(flipud(gray));
    shading interp;
    %title(['V_0=' sprintf('%.1f',data.para.potential_barrier) 'eV m=' sprintf('%.1f',data.para.meffective) 'm_e'])
    %title(['Azi=' sprintf('%.1f',data.para.cone_angle_azimuthpos)])
    %title(sprintf('%.2f',data.z));
    title_list_item=evalin('base',[var_name{ii},'.info.',title_info]);
    title(title_list_item);
kk=kk+1;
end;    


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load variables from field handles
no_boxes=str2num(get(handles.no_BZs,'String'));
% hkl=str2num(get(handles.hkl_additional_cut,'String'));
kz_fraction=str2num(get(handles.k_norm_perc,'String'))/100;
lattice_constant=str2num(get(handles.lattice_const,'String'));
rot=str2num(get(handles.rot,'String'));
fig_display=str2num(get(handles.fig_BZ_cut,'String'));
color_BZ_cut=get(handles.color_additional_plane,'String');
original_hkl=str2num(get(handles.hkl,'String'));
rot_perp_BZ=str2num(get(handles.rot_perp_BZ,'String'));
xoff=str2num(get(handles.xoff,'String'));
yoff=str2num(get(handles.yoff,'String'));
% calculate planes and intersections and plot

current_axes=gca;
fig_1=figure(fig_display); hold on;
set(gcf,'color','w');

% hkl=(2*pi/lattice_constant)*hkl;
% cut_point=kz_fraction*hkl;
% cut_normal=hkl;

x_unit=(2*pi/lattice_constant)*[1 0 0];
y_unit=(2*pi/lattice_constant)*[0 1 0];
z_unit=(2*pi/lattice_constant)*[0 0 1];

[delta_a,delta_e,r]=cart2sph(original_hkl(1),original_hkl(2),original_hkl(3));
hkl=(rotz(rad2deg(delta_a))*roty((90-rad2deg(delta_e)))*rotz(-rot)*y_unit')';
cut_normal=(1/hkl(1))*hkl;
cut_point=kz_fraction*cut_normal;

cut_plane=createPlane(cut_point,cut_normal);
figure(fig_1)
drawPlane3d(cut_plane, color_BZ_cut)
alpha(0.5)
for ii=-no_boxes:no_boxes
figure(fig_1)
hold on
   p_x=(2*pi/lattice_constant)*[ii 0 0];
   p_y=(2*pi/lattice_constant)*[0 ii 0];
   p_z=(2*pi/lattice_constant)*[0 0 ii];
   

   plane_x=createPlane(p_x,x_unit);
   plane_y=createPlane(p_y,y_unit);
   plane_z=createPlane(p_z,z_unit);
    
%    sketch_plane_x=drawPlane3d(plane_x, 'y');
%    alpha(0.2)
%    sketch_plane_y=drawPlane3d(plane_y, 'y');
%    alpha(0.2)
%    sketch_plane_z=drawPlane3d(plane_z, 'y');
%    alpha(0.2)
   
   
   line{1} = intersectPlanes(plane_x, cut_plane);
   line{2} = intersectPlanes(plane_y, cut_plane);
   line{3} = intersectPlanes(plane_z, cut_plane);
drawLine3d(line{1}, 'lineWidth', 2 ,'Color',color_BZ_cut);
drawLine3d(line{2}, 'lineWidth', 2,'Color',color_BZ_cut);
drawLine3d(line{3}, 'lineWidth', 2,'Color',color_BZ_cut);

%   %% draw flat plane
 axes(current_axes);
 hold on
 [delta_a,delta_e,r]=cart2sph(cut_normal(1),cut_normal(2),cut_normal(3));
 figHandles = get(gcf,'children');

 for kk=1:3
    line_temp=line{kk};
    line_point=line_temp(1:3);
    line_point=(rotz(rot_perp_BZ)*rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*line_point')';
    line_point(3)=0;
    line_point=line_point+xoff*[1 0 0]+yoff*[0 1 0];
    line_direction=line_temp(4:6);
    line_direction=(rotz(rot_perp_BZ)*rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*line_direction')';
    line_flat=cat(2,line_point,line_direction);
        for ii=1:length(figHandles)
        axes(figHandles(ii));
        drawLine3d(line_flat, 'lineWidth', 2, 'Color',color_BZ_cut);    
        end;
 end;
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=figure(gcf);
position=get(h,'Position');
windows_position=[position(1),position(2)];
calormapeditor_yizhang(h,windows_position);


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clim=str2num(get(handles.Clim,'String'));

figHandles = get(gcf,'children');
for ii=1:length(figHandles)
figHandles(ii).CLim=[0 clim];

end;


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lines = findall(gca,'Type','line');
figHandles = get(gcf,'children');
for ii=1:length(figHandles)
copyobj(lines,figHandles(ii));
end;


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;

data=evalin('base',var_name{1});
direction=get(handles.direction,'String');
direction_value=get(handles.direction,'Value');
direction=direction(direction_value);
cols=str2num(get(handles.col,'String'));
rows=str2num(get(handles.rows,'String'));
slices=get(handles.slices_field,'String');
if strcmp(slices,'all')==1
    if direction=='z'
        slices=data.z;
    elseif direction=='x'
        slices=data.x;
    elseif direction=='y'
        slices=data.y;
    end;
else
    slices=str2num(get(handles.slices_field,'String'));
end;
integration_interval=str2num(get(handles.step_integration,'String'));        

subplot_index=str2num(get(handles.subplot_start_index,'String'));

% if subplot_index~=1
%     figure
%     set(gcf,'Color','white');
% end

if direction=='z'
    for ii=1:length(slices)
    if mod(subplot_index,cols*rows)==1 %starts new figure if index exceeds subplot number
        figure
        set(gcf,'Color','white');
        subplot_index=1;
    end;
        [~,z_pos]=min(abs(data.z-slices(ii)));
        [~,z_pos_integration]=min(abs(data.z-slices(ii)-integration_interval)); %calculates index of lower integration bound
        data_value_cut=squeeze(sum(data.value(:,:,z_pos:z_pos_integration),3)); %sums over integration range
        subplot(rows,cols,subplot_index)
        subplot_index=subplot_index+1;
        pcolor(data.x,data.y,data_value_cut');
        if get(handles.radiobutton_axis_equal,'Value')
            axis equal
        end
        axis tight;
        colormap(flipud(gray));
        shading interp;
        if slices(ii)==0
            title(['E=E_f'])
        else
            title(['E=E_f' sprintf('%.2f',slices(ii)) 'eV'])
        end;
    end;
elseif direction=='x'
    for ii=1:length(slices)
    if mod(subplot_index,cols*rows)==1 %starts new figure if index exceeds subplot number
        figure
        set(gcf,'Color','white');
        subplot_index=1;
    end;
        [~,x_pos]=min(abs(data.x-slices(ii)));
        data_value_cut=squeeze(data.value(x_pos,:,:));
        subplot(rows,cols,subplot_index)
        subplot_index=subplot_index+1;
        pcolor(data.y,data.z,data_value_cut');
    if get(handles.radiobutton_axis_equal,'Value')
        axis equal
    end
        axis tight;
        colormap(flipud(gray));
        shading interp;
%         if slices(ii)==0
%             title(['k_x=0 A^{-1}'])
%         else
%             title(['k_x=' sprintf('%.1f',slices(ii)) 'A^{-1}'])
%         end;
        title([sprintf('%.2f',slices(ii))])
    end;
elseif direction=='y'
    for ii=1:length(slices)
    if mod(subplot_index,cols*rows)==1 %starts new figure if index exceeds subplot number
        figure
        set(gcf,'Color','white');
        subplot_index=1;
    end;
        [~,y_pos]=min(abs(data.y-slices(ii)));
        data_value_cut=squeeze(data.value(:,y_pos,:));
        subplot(rows,cols,subplot_index)
        subplot_index=subplot_index+1;
        pcolor(data.x,data.z,data_value_cut');
    if get(handles.radiobutton_axis_equal,'Value')
        axis equal
    end
        axis tight;
        colormap(flipud(gray));
        shading interp;
        if slices(ii)==0
            title(['k_y=0 A^{-1}'])
        else
            title(['k_y=' sprintf('%.2f',slices(ii)) 'A^{-1}'])
        end;
    end;    
end;



function slices_field_Callback(hObject, eventdata, handles)
% hObject    handle to slices_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slices_field as text
%        str2double(get(hObject,'String')) returns contents of slices_field as a double


% --- Executes during object creation, after setting all properties.
function slices_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slices_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MDC_button.
function MDC_button_Callback(hObject, eventdata, handles)
% hObject    handle to MDC_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig_no=str2num(handles.Fig_no.String);
real_space_cut_no=str2double(handles.momentum.String);
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
smooth_on=get(handles.radio_smooth,'Value');
handles_h = guidata(h);
var_name = handles_h.VarNames;
figure(fig_no);
set(gcf,'color','w');
sum_index_range=str2num(handles.index_range_averaging.String);
hold on
for ii=1:length(var_name)
    data=evalin('base',var_name{ii});
    [~,index_cut_no]=min(abs(data.y-real_space_cut_no));
    x=data.x;
    if sum_index_range>0
        ranger=index_cut_no-sum_index_range:index_cut_no+sum_index_range;
        if smooth_on==1
            y=smooth(mean(data.value(:,ranger),2),20);
            x=smooth(data.x,20);
        else
            y=mean(data.value(:,ranger),2);
        end;
    else
        if smooth_on==1
            y=smooth(data.value(:,index_cut_no),20);
            x=smooth(data.x,20);
        else
            y=data.value(:,index_cut_no);
        end;
        
    end;
    %x=smooth(x,3);
    %y=smooth(y,3);
    file_ext=get(handles.file_ext_edit,'String');
    MDC_data=zeros(2,length(x));
    MDC_data(1,:)=x;
    MDC_data(2,:)=y;
    assignin('base',[var_name{1} '_MDC_' file_ext],MDC_data);
    
    
    plot_handles{1,ii}=plot(x, y+ii*0);
 %   plot_handles{2,ii}=num2str(data.info.Temperature);
    %evalin('base',['plot(' var_name{ii} '.y,' var_name{ii} '.value(' num2str(index_cut_no) ',:));'])
end;
%legend(plot_handles(2,:));
hold off


% --- Executes on button press in radio_smooth.
function radio_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to radio_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_smooth


% --- Executes on selection change in direction.
function direction_Callback(hObject, eventdata, handles)
% hObject    handle to direction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns direction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from direction


% --- Executes during object creation, after setting all properties.
function direction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to direction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resolution_Callback(hObject, eventdata, handles)
% hObject    handle to resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resolution as text
%        str2double(get(hObject,'String')) returns contents of resolution as a double


% --- Executes during object creation, after setting all properties.
function resolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resolution=str2num(get(handles.resolution,'String'));
hfig=gcf;

%% find all the axes in the figure
hax = findall(hfig, 'type', 'axes');

%% compute the tighest box that includes all axes
tighest_box = [Inf Inf -Inf -Inf]; % left bottom right top
for i=1:length(hax)
    set(hax(i), 'units', 'centimeters');
    
    p = get(hax(i), 'position');
    ti = get(hax(i), 'tightinset');
    
    % get position as left, bottom, right, top
    p = [p(1) p(2) p(1)+p(3) p(2)+p(4)] + ti.*[-1 -1 1 1];
    
    tighest_box(1) = min(tighest_box(1), p(1));
    tighest_box(2) = min(tighest_box(2), p(2));
    tighest_box(3) = max(tighest_box(3), p(3));
    tighest_box(4) = max(tighest_box(4), p(4));
end

%% move all axes to left-bottom
for i=1:length(hax)
    if strcmp(get(hax(i),'tag'),'legend')
        continue
    end
    p = get(hax(i), 'position');
    set(hax(i), 'position', [p(1)-tighest_box(1) p(2)-tighest_box(2) p(3) p(4)]);
end

%% resize figure to fit tightly
set(hfig, 'units', 'centimeters');
p = get(hfig, 'position');

width = tighest_box(3)-tighest_box(1);
height =  tighest_box(4)-tighest_box(2); 
set(hfig, 'position', [p(1) p(2) width height]);

%% set papersize
set(hfig,'PaperUnits','centimeters');
set(hfig,'PaperSize', [width height]);
set(hfig,'PaperPositionMode', 'manual');
set(hfig,'PaperPosition',[0 0 width height]);


%% save
print(hfig,'-dbitmap',strcat('-r',num2str(resolution)));



function Clim_Callback(hObject, eventdata, handles)
% hObject    handle to Clim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Clim as text
%        str2double(get(hObject,'String')) returns contents of Clim as a double


% --- Executes during object creation, after setting all properties.
function Clim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Clim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=gca;
x_lim=get(h,'XLim');
y_lim=get(h,'YLim');
figHandles = get(gcf,'children');
for ii=1:length(figHandles)
set(figHandles(ii),'XLim',x_lim);
set(figHandles(ii),'YLim',y_lim);
end;


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x0=str2num(get(handles.ef_x,'String'));
%figure_num=str2num(get(handles.figure_no,'String'));
%figure(figure_num);
axis_value=axis;

% lc means Line color
lc= get(handles.ef_line_color,'Value');

switch lc
    case 1
        lcc='k';
    case 2
        lcc='b';
    case 3
        lcc='c';
    case 4
        lcc='g';
    case 5
        lcc='m';
    case 6
        lcc='r';
    case 7
        lcc='y';
    case 8
        lcc='w';
end

hold on;
for ii=1:length(x0)
    plot([x0(ii),x0(ii)],axis_value(3:4),lcc);
end;
hold off;


function ef_x_Callback(hObject, eventdata, handles)
% hObject    handle to ef_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ef_x as text
%        str2double(get(hObject,'String')) returns contents of ef_x as a double


% --- Executes during object creation, after setting all properties.
function ef_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ef_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y0=str2num(get(handles.ef_y,'String'));
%figure_num=str2num(get(handles.figure_no,'String'));
%figure(figure_num);
axis_value=axis;

% lc means Line color
lc= get(handles.ef_line_color,'Value');

switch lc
    case 1
        lcc='k';
    case 2
        lcc='b';
    case 3
        lcc='c';
    case 4
        lcc='g';
    case 5
        lcc='m';
    case 6
        lcc='r';
    case 7
        lcc='y';
    case 8
        lcc='w';
end

hold on;
for ii=1:length(y0)
    plot(axis_value(1:2),[y0(ii),y0(ii)],lcc);
end;

hold off;

% --- Executes on selection change in ef_line_color.
function ef_line_color_Callback(hObject, eventdata, handles)
% hObject    handle to ef_line_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ef_line_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ef_line_color


% --- Executes during object creation, after setting all properties.
function ef_line_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ef_line_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ef_y_Callback(hObject, eventdata, handles)
% hObject    handle to ef_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ef_y as text
%        str2double(get(hObject,'String')) returns contents of ef_y as a double


% --- Executes during object creation, after setting all properties.
function ef_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ef_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('Colormap.mat');
cl_str=get(handles.colormap_pop,'String');
cl_inx=get(handles.colormap_pop,'Value');
cl_map=cl_str{cl_inx};
flip_flag=get(handles.inverse_colormap,'Value');
switch cl_map
    case 'jet'
        if flip_flag==1
            colormap(flipud(jet));
        else
            colormap(jet);
        end
    case 'hsv'
        if flip_flag==1
            colormap(flipud(hsv));
        else
            colormap(hsv);
        end       
    case 'hot'
        if flip_flag==1
            colormap(flipud(hot));
        else
            colormap(hot);
        end
    case 'gray'
        if flip_flag==1
            colormap(flipud(gray));
        else
            colormap(gray);
        end
    case 'copper'
        if flip_flag==1
            colormap(flipud(copper));
        else
            colormap(copper);
        end
    case 'cool'
        if flip_flag==1
            colormap(flipud(cool));
        else
            colormap(cool);
        end
    case 'spring'
        if flip_flag==1
            colormap(flipud(spring));
        else
            colormap(spring);
        end
    case 'summer'
        if flip_flag==1
            colormap(flipud(summer));
        else
            colormap(summer);
        end
    case 'autumn'
        if flip_flag==1
            colormap(flipud(autumn));
        else
            colormap(autumn);
        end
    case 'winter'
        if flip_flag==1
            colormap(flipud(winter));
        else
            colormap(winter);
        end
    case 'blackbody'
        if flip_flag==1
            colormap(flipud(blackbody));
        else
            colormap(blackbody);
        end
    case 'blue'
        if flip_flag==1
            colormap(flipud(cm_blue));
        else
            colormap(cm_blue);
        end
    case 'blue-hot'
        if flip_flag==1
            colormap(flipud(cm_bluehot));
        else
            colormap(cm_bluehot);
        end
    case 'blue-red-green'
        if flip_flag==1
            colormap(flipud(cm_blueredgreen));
        else
            colormap(cm_blueredgreen);
        end
    case 'copper2'
        if flip_flag==1
            colormap(flipud(cm_copper));
        else
            colormap(cm_copper);
        end
    case 'cyan'
        if flip_flag==1
            colormap(flipud(cyan));
        else
            colormap(cyan);
        end
    case 'cyan-magenta'
        if flip_flag==1
            colormap(flipud(hsv));
        else
            colormap(hsv);
        end
        colormap(cm_cyanmagenta)
    case 'geo'
        if flip_flag==1
            colormap(flipud(cm_geo));
        else
            colormap(cm_geo);
        end
    case 'gold'
        if flip_flag==1
            colormap(flipud(cm_gold));
        else
            colormap(cm_gold);
        end
    case 'green'
        if flip_flag==1
            colormap(flipud(cm_green));
        else
            colormap(cm_green);
        end
    case 'land and sea'
        if flip_flag==1
            colormap(flipud(cm_landandsea));
        else
            colormap(cm_landandsea);
        end
    case 'magenta'
        if flip_flag==1
            colormap(flipud(cm_magenta));
        else
            colormap(cm_magenta);
        end
    case 'pastels'
        if flip_flag==1
            colormap(flipud(cm_pastels));
        else
            colormap(cm_pastels);
        end
    case 'pastels map'
        if flip_flag==1
            colormap(flipud(cm_pastelsmap));
        else
            colormap(cm_pastelsmap);
        end
    case 'planet earth'
        if flip_flag==1
            colormap(flipud(cm_planetearth));
        else
            colormap(cm_planetearth);
        end
    case 'rainbow'
        if flip_flag==1
            colormap(flipud(cm_rainbow));
        else
            colormap(cm_rainbow);
        end
    case 'red'
        if flip_flag==1
            colormap(flipud(red));
        else
            colormap(red);
        end
    case 'red-white-blue'
        if flip_flag==1
            colormap(flipud(cm_redwhiteblue));
        else
            colormap(cm_redwhiteblue);
        end
    case 'red-white-green'
        if flip_flag==1
            colormap(flipud(cm_redwhhitegreen));
        else
            colormap(cm_redwhitegreen);
        end
    case 'relief'
        if flip_flag==1
            colormap(flipud(cm_relief));
        else
            colormap(cm_relief);
        end
    case 'spectrum'
        if flip_flag==1
            colormap(flipud(cm_spectrum));
        else
            colormap(cm_spectrum);
        end
    case 'terrain'
        if flip_flag==1
            colormap(flipud(cm_terrain));
        else
            colormap(cm_terrain);
        end
    case 'yellow'
        if flip_flag==1
            colormap(flipud(cm_yellow));
        else
            colormap(cm_yellow);
        end
    case 'yellow hot'
        if flip_flag==1
            colormap(flipud(cm_yellowhot));
        else
            colormap(cm_yellowhot);
        end
    otherwise 
        warning('Choose colormap')
end

% --- Executes on selection change in colormap_pop.
function colormap_pop_Callback(hObject, eventdata, handles)
% hObject    handle to colormap_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colormap_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colormap_pop


% --- Executes during object creation, after setting all properties.
function colormap_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormap_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inverse_colormap.
function inverse_colormap_Callback(hObject, eventdata, handles)
% hObject    handle to inverse_colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inverse_colormap


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
str1=['fieldnames(',var_name{1},'.info',')'];
vars = evalin('base',str1);
str2='tt';
set(handles.listbox2,'String',vars)


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
% this function generates multiple MDCs from every slice in a 3D file
%%%
cols=str2num(get(handles.col,'String'));
rows=str2num(get(handles.rows,'String'));  
% fig_no=str2num(handles.Fig_no.String);
real_space_cut_no=str2double(handles.momentum.String);
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
smooth_on=get(handles.radio_smooth,'Value');
handles_h = guidata(h);
var_name = handles_h.VarNames;
% figure(fig_no);
% set(gcf,'color','w');
sum_index_range=str2num(handles.index_range_averaging.String);

data=evalin('base',var_name{1});
slices=data.x;
for ii=1:length(data.x)
        if mod(ii,cols*rows)==1 %starts new figure if index exceeds subplot number
        figure
        set(gcf,'Color','white');
        subplot_index=1;
        end;
        subplot(rows,cols,subplot_index)
        subplot_index=subplot_index+1;    
        [~,x_pos]=min(abs(data.x-slices(ii)));
        [~,index_cut_no]=min(abs(data.z-real_space_cut_no));
        x=data.y;
        ranger=index_cut_no-sum_index_range:index_cut_no+sum_index_range;
        if smooth_on==1
            y=smooth(mean(data.value(x_pos,:,ranger),3),20);
            x=smooth(data.x,20);
        else
            y=mean(data.value(x_pos,:,ranger),3);
        end;
    
        plot(x, y);
        axis tight;
        title([sprintf('%.1f',slices(ii))]);
end;
       


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
angle=str2num(get(handles.rot_line_angle,'String'));
h = findobj(gca,'Type','line');
for ii=1:length(h)
    line_tmp=h(ii);
    P1=[line_tmp.XData(1),line_tmp.YData(1),0];
    P2=[line_tmp.XData(2),line_tmp.YData(2),0];
    P1=rotz(angle)*P1';
    P2=rotz(angle)*P2';
    line_tmp.XData(1)=P1(1);
    line_tmp.XData(2)=P2(1);
    line_tmp.YData(1)=P1(2);
    line_tmp.YData(2)=P2(2);
    h(ii)=line_tmp;
end;



function rot_line_angle_Callback(hObject, eventdata, handles)
% hObject    handle to rot_line_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot_line_angle as text
%        str2double(get(hObject,'String')) returns contents of rot_line_angle as a double


% --- Executes during object creation, after setting all properties.
function rot_line_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot_line_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
data=evalin('base',var_name{1});

% %% subtract background
for ii=1:length(data.y)
    data.value(:,ii)=data.value(:,ii)-min(data.value(:,ii));
end
assignin('base',[var_name{1} '_bgr'],data);


% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
window_title=get(gcf,'name');
title(window_title,'Interpreter', 'none');



function offset_value_Callback(hObject, eventdata, handles)
% hObject    handle to offset_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offset_value as text
%        str2double(get(hObject,'String')) returns contents of offset_value as a double


% --- Executes during object creation, after setting all properties.
function offset_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in offset_z.
function offset_z_Callback(hObject, eventdata, handles)
% hObject    handle to offset_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
data=evalin('base',var_name{1});

% %% subtract background
offset_value=str2num(get(handles.offset_value,'String'));
data.z=data.z+offset_value;
assignin('base',[var_name{1} '_offset'],data);

% --- Executes on button press in offset_y.
function offset_y_Callback(hObject, eventdata, handles)
% hObject    handle to offset_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
data=evalin('base',var_name{1});

% %% subtract background
offset_value=str2num(get(handles.offset_value,'String'));
data.y=data.y+offset_value;
assignin('base',[var_name{1} '_offset'],data);

% --- Executes on button press in offset_x.
function offset_x_Callback(hObject, eventdata, handles)
% hObject    handle to offset_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
data=evalin('base',var_name{1});

% %% subtract background
offset_value=str2num(get(handles.offset_value,'String'));
data.x=data.x+offset_value;
assignin('base',[var_name{1} '_offset'],data);


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
data=evalin('base',var_name{1});
data.value=nthroot(data.value,5);
assignin('base',[var_name{1} '_sqrt'],data);



function file_ext_edit_Callback(hObject, eventdata, handles)
% hObject    handle to file_ext_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_ext_edit as text
%        str2double(get(hObject,'String')) returns contents of file_ext_edit as a double


% --- Executes during object creation, after setting all properties.
function file_ext_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_ext_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function step_integration_Callback(hObject, eventdata, handles)
% hObject    handle to step_integration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_integration as text
%        str2double(get(hObject,'String')) returns contents of step_integration as a double


% --- Executes during object creation, after setting all properties.
function step_integration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_integration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
data=evalin('base',var_name{1});

lap = [-1 -1 -1; -1 8 -1; -1 -1 -1]; %// Change - Centre is now positive
resp = imfilter(data.value, lap, 'conv'); %// Change

%// Change - Normalize the response image
minR = min(resp(:));
maxR = max(resp(:));
resp = (resp - minR) / (maxR - minR);

%// Change - Adding to original image now
sharpened = data.value + resp;

%// Change - Normalize the sharpened result
minA = min(sharpened(:));
maxA = max(sharpened(:));
data.value = (sharpened - minA) / (maxA - minA);

assignin('base',[var_name{1} '_shrp'],data);

%// Change - Perform linear contrast enhancement
% sharpened = imadjust(sharpened, [60/255 200/255], [0 1]);
% figure
% subplot(1,3,1);pcolor(data.x,data.y,data.value'); title('Original image');
% figure
% subplot(1,3,2);pcolor(data.x,data.y,resp'); title('Laplacian filtered image');
% % subplot(1,3,3);pcolor(data.x,data.y,sharpened'); title('Sharpened image');
% colormap(flipud(gray));
% shading interp;


% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'UserData',findall(gca,'Type','line'));

% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
copyobj( get(handles.pushbutton42,'UserData'), gca )



function subplot_start_index_Callback(hObject, eventdata, handles)
% hObject    handle to subplot_start_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subplot_start_index as text
%        str2double(get(hObject,'String')) returns contents of subplot_start_index as a double


% --- Executes during object creation, after setting all properties.
function subplot_start_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subplot_start_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_axis_equal.
function radiobutton_axis_equal_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_axis_equal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_axis_equal


% --- Executes on button press in pushbutton_Clim_90.
function pushbutton_Clim_90_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Clim_90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figHandles = get(gcf,'children');
for ii=1:length(figHandles)
CLim_sample=figHandles(ii).CLim;
CLim_sample(2)=CLim_sample(2)*0.5;
figHandles(ii).CLim=CLim_sample;
end;



% --- Executes on button press in radiobutton_sort_massplott.
function radiobutton_sort_massplott_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_sort_massplott (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_sort_massplott



function edit_stacking_offset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stacking_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stacking_offset as text
%        str2double(get(hObject,'String')) returns contents of edit_stacking_offset as a double


% --- Executes during object creation, after setting all properties.
function edit_stacking_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stacking_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
