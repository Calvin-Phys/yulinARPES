function varargout = EDC_MDC_plot(varargin)
% EDC_MDC_PLOT MATLAB code for EDC_MDC_plot.fig
%      EDC_MDC_PLOT, by itself, creates a new EDC_MDC_PLOT or raises the existing
%      singleton*.
%
%      H = EDC_MDC_PLOT returns the handle to a new EDC_MDC_PLOT or the handle to
%      the existing singleton*.
%
%      EDC_MDC_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDC_MDC_PLOT.M with the given input arguments.
%
%      EDC_MDC_PLOT('Property','Value',...) creates a new EDC_MDC_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EDC_MDC_plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EDC_MDC_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EDC_MDC_plot

% Last Modified by GUIDE v2.5 17-Aug-2012 12:38:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EDC_MDC_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @EDC_MDC_plot_OutputFcn, ...
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


% --- Executes just before EDC_MDC_plot is made visible.
function EDC_MDC_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EDC_MDC_plot (see VARARGIN)

% Choose default command line output for EDC_MDC_plot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EDC_MDC_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EDC_MDC_plot_OutputFcn(hObject, eventdata, handles) 
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
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);
if ~isfield(datav,'value')
    data.value=datav;
else data=datav;
end
clear datav;

set(handles.file_name,'String',[var_name,'_fit']);

di=ndims(data.value);

% initialize info
        set(handles.no_z,'String','');
        set(handles.z_start,'String','');
        set(handles.z_end,'String','');
        set(handles.z_step,'String','');
        
if isfield(data,'x')
    size_x=max(size(data.x));
    set(handles.no_x,'String',num2str(size_x));
    set(handles.x_start,'String',num2str(data.x(1)));
    set(handles.x_end,'String',num2str(data.x(size_x)));
    set(handles.x_step,'String',num2str((data.x(size_x)-data.x(1))/(size_x-1)));
else
    size_x=size(data.value,1);
    set(handles.no_x,'String',num2str(size_x));
    set(handles.x_start,'String','index');
    set(handles.x_end,'String','index');
    set(handles.x_step,'String','index');
end

if isfield(data,'y')
    size_y=max(size(data.y));
    set(handles.no_y,'String',num2str(size_y));
    set(handles.y_start,'String',num2str(data.y(1)));
    set(handles.y_end,'String',num2str(data.y(size_y)));
    set(handles.y_step,'String',num2str((data.y(size_y)-data.y(1))/(size_y-1)));
else
    size_y=size(data.value,2);
    set(handles.no_y,'String',num2str(size_y));
    set(handles.y_start,'String','index');
    set(handles.y_end,'String','index');
    set(handles.y_step,'String','index');
end

if di==3
    if isfield(data,'z')
        size_z=max(size(data.z));
        set(handles.no_z,'String',num2str(size_z));
        set(handles.z_start,'String',num2str(data.z(1)));
        set(handles.z_end,'String',num2str(data.z(size_z)));
        set(handles.z_step,'String',num2str((data.z(size_z)-data.z(1))/(size_z-1)));
    else
        size_z=size(data.value,3);
        set(handles.no_z,'String',num2str(size_z));
        set(handles.z_start,'String','index');
        set(handles.z_end,'String','index');
        set(handles.z_step,'String','index');
    end
end

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




% --- Executes on button press in update_listbox.
function update_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to update_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updatelistbox(handles);



function fig_no_Callback(hObject, eventdata, handles)
% hObject    handle to fig_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fig_no as text
%        str2double(get(hObject,'String')) returns contents of fig_no as a double


% --- Executes during object creation, after setting all properties.
function fig_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fig_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in fig_no_decrease.
function fig_no_decrease_Callback(hObject, eventdata, handles)
% hObject    handle to fig_no_decrease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure_num=str2num(get(handles.fig_no,'String'));
figure_num=figure_num-1;
set(handles.fig_no,'String',num2str(figure_num));

% --- Executes on button press in fig_no_crease.
function fig_no_crease_Callback(hObject, eventdata, handles)
% hObject    handle to fig_no_crease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure_num=str2num(get(handles.fig_no,'String'));
figure_num=figure_num+1;
set(handles.fig_no,'String',num2str(figure_num));


function updatelistbox(handles)
vars = evalin('base','who');
set(handles.listbox1,'String',vars)



function stack_offset_Callback(hObject, eventdata, handles)
% hObject    handle to stack_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stack_offset as text
%        str2double(get(hObject,'String')) returns contents of stack_offset as a double


% --- Executes during object creation, after setting all properties.
function stack_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stack_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function combine_num_Callback(hObject, eventdata, handles)
% hObject    handle to combine_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of combine_num as text
%        str2double(get(hObject,'String')) returns contents of combine_num as a double


% --- Executes during object creation, after setting all properties.
function combine_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to combine_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in ling_group_less.
function ling_group_less_Callback(hObject, eventdata, handles)
% hObject    handle to ling_group_less (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
line_group_v=str2num(get(handles.combine_num,'String'));
line_group_v=line_group_v-1;
set(handles.combine_num,'String',num2str(line_group_v));


% --- Executes on button press in line_group_more.
function line_group_more_Callback(hObject, eventdata, handles)
% hObject    handle to line_group_more (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
line_group_v=str2num(get(handles.combine_num,'String'));
line_group_v=line_group_v+1;
set(handles.combine_num,'String',num2str(line_group_v));



function x_start_Callback(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_start as text
%        str2double(get(hObject,'String')) returns contents of x_start as a double


% --- Executes during object creation, after setting all properties.
function x_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function y_start_Callback(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_start as text
%        str2double(get(hObject,'String')) returns contents of y_start as a double


% --- Executes during object creation, after setting all properties.
function y_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function z_start_Callback(hObject, eventdata, handles)
% hObject    handle to z_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_start as text
%        str2double(get(hObject,'String')) returns contents of z_start as a double


% --- Executes during object creation, after setting all properties.
function z_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_end_Callback(hObject, eventdata, handles)
% hObject    handle to z_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_end as text
%        str2double(get(hObject,'String')) returns contents of z_end as a double


% --- Executes during object creation, after setting all properties.
function z_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function no_x_Callback(hObject, eventdata, handles)
% hObject    handle to no_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_x as text
%        str2double(get(hObject,'String')) returns contents of no_x as a double


% --- Executes during object creation, after setting all properties.
function no_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function no_y_Callback(hObject, eventdata, handles)
% hObject    handle to no_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_y as text
%        str2double(get(hObject,'String')) returns contents of no_y as a double


% --- Executes during object creation, after setting all properties.
function no_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function no_z_Callback(hObject, eventdata, handles)
% hObject    handle to no_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_z as text
%        str2double(get(hObject,'String')) returns contents of no_z as a double


% --- Executes during object creation, after setting all properties.
function no_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in line_color.
function line_color_Callback(hObject, eventdata, handles)
% hObject    handle to line_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns line_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from line_color


% --- Executes during object creation, after setting all properties.
function line_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to line_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in line_style.
function line_style_Callback(hObject, eventdata, handles)
% hObject    handle to line_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns line_style contents as cell array
%        contents{get(hObject,'Value')} returns selected item from line_style


% --- Executes during object creation, after setting all properties.
function line_style_CreateFcn(hObject, eventdata, handles)
% hObject    handle to line_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in line_width_less.
function line_width_less_Callback(hObject, eventdata, handles)
% hObject    handle to line_width_less (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
width=str2num(get(handles.line_width,'String'));
width=width-0.5;
set(handles.line_width,'String',num2str(width));



% --- Executes on button press in line_width_more.
function line_width_more_Callback(hObject, eventdata, handles)
% hObject    handle to line_width_more (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
width=str2num(get(handles.line_width,'String'));
width=width+0.5;
set(handles.line_width,'String',num2str(width));


% --- Executes during object creation, after setting all properties.
function line_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to line_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function line_width_Callback(hObject, eventdata, handles)
% hObject    handle to line_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of line_width as text
%        str2double(get(hObject,'String')) returns contents of line_width as a double


% --- Executes on button press in fit_check.
function fit_check_Callback(hObject, eventdata, handles)
% hObject    handle to fit_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fit_check


% --- Executes on selection change in fit_type.
function fit_type_Callback(hObject, eventdata, handles)
% hObject    handle to fit_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fit_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fit_type


% --- Executes during object creation, after setting all properties.
function fit_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fit_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check3d.
function check3d_Callback(hObject, eventdata, handles)
% hObject    handle to check3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check3d


% --- Executes on button press in EDC_plot.
function [lines] = EDC_plot_Callback(hObject, eventdata, handles)
% hObject    handle to EDC_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load data
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_name = list_entries{index_selected(1)}; 
data=evalin('base',var_name);
% if ~isfield(datav,'value')
%     data.value=datav;
% else data=datav;
% end
% clear datav;
%load data

%--------------------------------------
%load seting
dimension=ndims(data.value);

if dimension~=2
    errordlg('data must be 2D');
    return;
end

check_3d=get(handles.check3d,'Value');
check_fit=get(handles.fit_check,'Value');
check_noteoff=get(handles.note_off,'Value');
check_EDC=get(handles.EDC,'Value');

offset=str2double(get(handles.stack_offset,'String'));
combine=str2num(get(handles.combine_num,'String'));
combine=round(combine);
if combine<=0
    combine=1;
end
stepsize=str2double(get(handles.step_size,'String'));

color_contents = cellstr(get(handles.line_color,'String'));
linecolor = color_contents{get(handles.line_color,'Value')};
style_list={'-';'--';':';'-.'};
linestyle=style_list{get(handles.line_style,'Value')};
linewidth=str2num(get(handles.line_width,'String'));
fittype_list={'smoothingspline';'cubicinterp';'poly2';'poly1';'linearinterp'};
fittype=fittype_list{get(handles.fit_type,'Value')};

color_contents = cellstr(get(handles.note_color,'String'));
notecolor = color_contents{get(handles.note_color,'Value')};
size_contents = cellstr(get(handles.note_size,'String'));
notesize = str2num(size_contents{get(handles.note_size,'Value')});
weight_contents = cellstr(get(handles.note_weight,'String'));
noteweight = weight_contents{get(handles.note_weight,'Value')};
%finish load setting


size_x=max(size(data.x));
size_y=max(size(data.y));
scale_x=data.x(size_x)-data.x(1);
scale_y=data.y(size_y)-data.y(1);

%caculate how many lines
if check_EDC
    if stepsize>0
        lines_num=ceil(scale_x/stepsize);
    else
        lines_num=size_x;
    end
else
    if stepsize>0
        lines_num=ceil(scale_y/stepsize);
    else
        lines_num=size_y;
    end
end

lines_h=[];
lines_note=cell(lines_num,1);

str=[];
str=get(handles.step_size,'String');
precision=0;
for i=1:max(size(str))
    if str(i)=='.'
       precision=max(size(str))-i;
    end
end
format=['%-10.',num2str(precision),'f'];
            
%plot data
figure_num=str2num(get(handles.fig_no,'String'));
hfig=figure(figure_num);
set(gca,'NextPlot','replace');


if check_EDC  %plot EDC
    for lines_index=1:lines_num
        x_index_mid=0;
        x_index=[];
        
        if stepsize<=0
            x_index_mid=lines_index;
        else
            x_index_mid = 1+round((lines_index-1)*(stepsize/(scale_x/(size_x-1))));
        end
        
        x_index=[(x_index_mid+ceil(-combine/2)):(x_index_mid+ceil(combine/2)-1)];
        for i=1:max(size(x_index))
            if x_index(i)<1
                x_index(i)=1;
            else if x_index(i)>size_x
                    x_index(i)=size_x;
                end
            end
        end
                    
        plot_x=data.y;
        plot_y=zeros(1,size_y);
        for i=1:max(size(x_index))
            plot_y=plot_y+data.value(x_index(i),:);
        end
        if check_fit
            result=fit(plot_x',plot_y',fittype);
            plot_y=result(plot_x')';
        end
        
        if ~check_3d
        plot_y=plot_y+(lines_index-1)*offset;
        
        
            lines_h(lines_index)=plot(plot_x,plot_y,'Color',linecolor,'LineStyle',linestyle,'LineWidth',linewidth);
        else
            plot_3=zeros(1,size_y);
            plot_3(:)=data.x(x_index_mid);
            lines_h(lines_index)=plot3(plot_3,plot_x,plot_y,'Color',linecolor,'LineStyle',linestyle,'LineWidth',linewidth);
        end
                        
        hold on
             
        if stepsize<=0
            lines_note{lines_index}=num2str(data.x(x_index_mid));
            lines_v(lines_index)=data.x(x_index_mid);
        else
            lines_note{lines_index}=num2str((data.x(1)+(lines_index-1)*stepsize),format);
            lines_v(lines_index)=(data.x(1)+(lines_index-1)*stepsize);
        end
        
        if ~check_noteoff
            if~check_3d
                text(plot_x(max(size(plot_x))),plot_y(max(size(plot_y))),['\leftarrow  ',lines_note{lines_index}],'Color',notecolor,'FontSize',notesize,'FontWeight',noteweight);
            else
                text(data.x(x_index_mid),plot_x(max(size(plot_x))),plot_y(max(size(plot_y))),['\leftarrow  ',lines_note{lines_index}],'Color',notecolor,'FontSize',notesize,'FontWeight',noteweight);
            end
        end
        
        set(lines_h(lines_index),'Tag',lines_note{lines_index});
        
        hold on
    end
    
else   %plot MDC
    
     for lines_index=1:lines_num
        y_index_mid=0;
        y_index=[];
        
        if stepsize<=0
            y_index_mid=lines_index;
        else
            y_index_mid = 1+round((lines_index-1)*(stepsize/(scale_y/(size_y-1))));
        end
        
        y_index=[(y_index_mid+ceil(-combine/2)):(y_index_mid+ceil(combine/2)-1)];
        i=1;
        for i=1:max(size(y_index))
            if y_index(i)<1
                y_index(i)=1;
            else if y_index(i)>size_y
                    y_index(i)=size_y;
                end
            end
        end
                            
        plot_x=data.x;
        plot_y=zeros(1,size_x);
        i=1;
        for i=1:max(size(y_index))
            plot_y=plot_y+(data.value(:,y_index(i)))';
        end
        if check_fit
            result=fit(plot_x',plot_y',fittype);
            plot_y=result(plot_x')';
        end
        
        if ~check_3d
        plot_y=plot_y+(lines_index-1)*offset;
        lines_h(lines_index)=plot(plot_x,plot_y,'Color',linecolor,'LineStyle',linestyle,'LineWidth',linewidth);
        else
            plot_3=zeros(1,size_x);
            plot_3(:)=data.y(y_index_mid);
            lines_h(lines_index)=plot3(plot_x,plot_3,plot_y,'Color',linecolor,'LineStyle',linestyle,'LineWidth',linewidth);
        end
        
        hold on
        
        if stepsize<=0
            lines_note{lines_index}=num2str(data.y(y_index_mid));
            lines_v(lines_index)=data.y(y_index_mid);
        else
            lines_note{lines_index}=num2str((data.y(1)+(lines_index-1)*stepsize),format);  
            lines_v(lines_index)=(data.y(1)+(lines_index-1)*stepsize);
        end
        
        if ~check_noteoff
            if~check_3d
                text(plot_x(max(size(plot_x))),plot_y(max(size(plot_y))),['\leftarrow  ',lines_note{lines_index}],'Color',notecolor,'FontSize',notesize,'FontWeight',noteweight);
            else
                text(plot_x(max(size(plot_x))),data.y(y_index_mid),plot_y(max(size(plot_y))),['\leftarrow  ',lines_note{lines_index}],'Color',notecolor,'FontSize',notesize,'FontWeight',noteweight);
            end
        end
        
        set(lines_h(lines_index),'Tag',lines_note{lines_index});
        hold on
     end
end


if ~check_3d
set(gca,'YTickLabel',{});
view(2);
else
    view(3);
    clear plot_3;
end
clear plot_x;
clear plot_y;
clear result;
hold off
set(gca,'NextPlot','replace');
lines=struct('h',lines_h,'v',lines_v,'n',lines_num,'EDC',get(handles.EDC,'Value'));
        
            
            
% --- Executes during object creation, after setting all properties.
function line_group_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to line_group_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function line_group_panel_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to line_group_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function step_size_Callback(hObject, eventdata, handles)
% hObject    handle to step_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_size as text
%        str2double(get(hObject,'String')) returns contents of step_size as a double


% --- Executes during object creation, after setting all properties.
function step_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_step_Callback(hObject, eventdata, handles)
% hObject    handle to x_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_step as text
%        str2double(get(hObject,'String')) returns contents of x_step as a double


% --- Executes during object creation, after setting all properties.
function x_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_step_Callback(hObject, eventdata, handles)
% hObject    handle to y_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_step as text
%        str2double(get(hObject,'String')) returns contents of y_step as a double


% --- Executes during object creation, after setting all properties.
function y_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_step_Callback(hObject, eventdata, handles)
% hObject    handle to z_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_step as text
%        str2double(get(hObject,'String')) returns contents of z_step as a double


% --- Executes during object creation, after setting all properties.
function z_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in note_color.
function note_color_Callback(hObject, eventdata, handles)
% hObject    handle to note_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns note_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from note_color


% --- Executes during object creation, after setting all properties.
function note_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to note_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in note_off.
function note_off_Callback(hObject, eventdata, handles)
% hObject    handle to note_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of note_off


% --- Executes on selection change in note_size.
function note_size_Callback(hObject, eventdata, handles)
% hObject    handle to note_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns note_size contents as cell array
%        contents{get(hObject,'Value')} returns selected item from note_size


% --- Executes during object creation, after setting all properties.
function note_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to note_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in note_weight.
function note_weight_Callback(hObject, eventdata, handles)
% hObject    handle to note_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns note_weight contents as cell array
%        contents{get(hObject,'Value')} returns selected item from note_weight


% --- Executes during object creation, after setting all properties.
function note_weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to note_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_begin_Callback(hObject, eventdata, handles)
% hObject    handle to x_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_begin as text
%        str2double(get(hObject,'String')) returns contents of x_begin as a double


% --- Executes during object creation, after setting all properties.
function x_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to x_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_over as text
%        str2double(get(hObject,'String')) returns contents of x_over as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_begin_Callback(hObject, eventdata, handles)
% hObject    handle to y_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_begin as text
%        str2double(get(hObject,'String')) returns contents of y_begin as a double


% --- Executes during object creation, after setting all properties.
function y_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to y_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_over as text
%        str2double(get(hObject,'String')) returns contents of y_over as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file_name_Callback(hObject, eventdata, handles)
% hObject    handle to file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_name as text
%        str2double(get(hObject,'String')) returns contents of file_name as a double


% --- Executes during object creation, after setting all properties.
function file_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fit_function.
function fit_function_Callback(hObject, eventdata, handles)
% hObject    handle to fit_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fit_function contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fit_function


% --- Executes during object creation, after setting all properties.
function fit_function_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fit_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_peaks.
function plot_peaks_Callback(hObject, eventdata, handles)
% hObject    handle to plot_peaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_peaks


% --- Executes on button press in plot_line.
function plot_line_Callback(hObject, eventdata, handles)
% hObject    handle to plot_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_line


% --- Executes on button press in fit_band.
function fit_band_Callback(hObject, eventdata, handles)
% hObject    handle to fit_band (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fit_band


% --- Executes on button press in fit_line.
function fit_line_Callback(hObject, eventdata, handles)
% hObject    handle to fit_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%---------------load MDC/EDC/ lines information---------------

lines=EDC_plot_Callback(hObject, eventdata, handles);

%---------------load setting-----------

if strncmp('Min',get(handles.x_begin,'String'),2) || strncmp('min',get(handles.x_begin,'String'),2)
    xdata=get(lines.h(1),'XData');
    xbegin=xdata(1);
else
    xbegin=str2double(get(handles.x_begin,'String'));
end

if strncmp('Max',get(handles.x_over,'String'),2) || strncmp('max',get(handles.x_over,'String'),2)
    xdata=get(lines.h(1),'XData');
    xend=xdata(max(size(xdata)));
else
    xend=str2double(get(handles.x_over,'String'));
end

if strncmp('Min',get(handles.y_begin,'String'),2) || strncmp('min',get(handles.y_begin,'String'),2)
    ybegin=lines.v(1);
else
    ybegin=str2double(get(handles.y_begin,'String'));
end

if strncmp('Max',get(handles.y_over,'String'),2) || strncmp('max',get(handles.y_over,'String'),2)
    yend=lines.v(lines.n);
else
    yend=str2double(get(handles.y_over,'String'));
end

peaknum=get(handles.peak_num,'Value');

var_name=get(handles.file_name,'String');

fignum=str2num(get(handles.fig_no,'String'));

offset=str2num(get(handles.stack_offset,'String'));

%-------------calculate y scale-------------
    if ybegin<=lines.v(1)
        ybegin_index=1;
    else if ybegin>=lines.v(lines.n)
            ybegin_index=lines.n;
        else
            ybegin_index=find(round((ybegin-lines.v)/(lines.v(2)-lines.v(1)))==0);
        end
    end
    
    if yend <= ybegin
        yend_index = ybegin_index;
    else if yend > lines.v(lines.n)
            yend_index = lines.n;
        else
            yend_index = find(round((yend-lines.v)/(lines.v(2)-lines.v(1)))==0);
        end
    end
    
%-------------fit function-----------------------
func_string='A1+A2*x';
coff={'A1','A2'};
    for i=1:peaknum
        istr=num2str(i); 
        Pa=['P',istr,'a'];
        Px=['P',istr,'x'];
        Pw=['P',istr,'w'];
        
        if get(handles.fit_function,'Value') == 1   %-----Lorenzian fit
           fpeak=[Pa,'/(1+((x-',Px,')/',Pw,')^2)'];
        end
        
        if get(handles.fit_function,'Value') == 2  %-----Guassian fit
           fpeak=[Pa,'*exp(-(x-',Px,')^2/(2*',Pw,'^2))'];
        end
        
        func_string=[func_string,'+',fpeak];
        coff=[coff,Pa,Px,Pw];
    end
    ffun=fittype(func_string,'coefficients',coff)

%---creat result cell---

curve=cell(1,yend_index-ybegin_index+1);

    
%----fit line one by one-----------
for i=ybegin_index:yend_index
    
    %------------------load x, y------------
    xdata=[];
    ydata=[];    
        
    tempx=get(lines.h(i),'XData');
    tempy=get(lines.h(i),'Ydata');
    
    if xbegin<=tempx(1)
        xbegin_index=1;
    else if xbegin>=tempx(max(size(tempx)))
            xbegin_index=max(size(tempx));
        else
            xbegin_index=find(round((xbegin-tempx)/(tempx(2)-tempx(1)))==0);
        end
    end
       
    if xend<=xbegin
        xend_index=xbegin_index;
    else if xend > tempx(max(size(tempx)))
            xend_index=max(size(tempx));
        else
            xend_index=find(round((xend-tempx)/(tempx(2)-tempx(1)))==0);
        end
    end
    
    xdata=tempx(xbegin_index:xend_index);
    ydata=tempy(xbegin_index:xend_index);
    data_n=max(size(xdata));
    
    clear tempx tempy;
    
    %-----------------initial background----
    
    if lines.EDC || ~lines.EDC
        A2=(ydata(data_n)-ydata(1))/(xdata(data_n)-xdata(1));
    else
        A2=0;
    end
        
    [ymin,min_index]=min(ydata);   
    A1=ymin-A2*xdata(min_index);
    
    
    
    %-----------------initial peaks position, width and amp----------
    space=1;
    while space<=data_n
    pks=[];
    locs=[];
    pks_n=0;    
    for j=1:data_n     %find peak
        region=[max(1,j-space):min(data_n,j+space)];
        if (ydata(j)-A1-A2*xdata(j))>=max(ydata(region)-A1-A2*xdata(region));
            pks_n=pks_n+1;
            locs(pks_n)=j;
            pks(pks_n)=ydata(j);
                       
        end
    end
    if pks_n>peaknum    %check whether peak num is correct
        space=space+1;   %if peak num not correct, change space parameter and redo 
    else                
        space=data_n+1;  %if peak num is correct, change space to end loop
    end
    end
    while pks_n<peaknum  % if peak num is not enough, add to request
        if locs(1)==1 || locs(1)==data_n
            locs(1)=round(data_n/2);
        end
        
        pks_n=pks_n+1;
        locs(pks_n)=locs(1);
        pks(pks_n)=ydata(locs(1));
    end
    [pks,ni]=sort(pks,'descend');   % sort pks array descend
    locs_i=(locs(ni));
    locs=xdata(locs_i);
      
    st_pt=[A1,A2];
    lower=[(i-1)*offset,-Inf];
    upper=[Inf,Inf];
    width=zeros(1,pks_n); 
    for j=1:pks_n
        left=find(ydata(1:locs_i(j))<((pks(j)+A1+A2*locs(j))/2),1,'last');
        if isempty(left)
            left=1;
        end
        
        right=find(ydata(locs_i(j):data_n)<((pks(j)+A1+A2*locs(j))/2),1,'first')+locs_i(j)-1;
        if isempty(right)
            right=data_n;
        end
        
        width(j)=2*(min(locs_i(j)-left,right-locs_i(j)))*(xdata(2)-xdata(1));
        width(j)=min(width(j),(xdata(data_n)-xdata(1)));
        
        st_pt=[st_pt,pks(j)-A1-A2*locs(j),locs(j),width(j)];
        lower=[lower,0,xdata(1),(xdata(2)-xdata(1))];
        upper=[upper,max(ydata)-(i-1)*offset,xdata(data_n),5*(xdata(data_n)-xdata(1))];
    end
                               
      %begin fiting        
    opt=fitoptions('Method','NonlinearLeastSquares','StartPoint',st_pt,'Lower',lower,'Upper',upper,'Display','final','MaxIter',800);
    result=fit(xdata',ydata',ffun,opt);
        
    coeff=coeffvalues(result);
    

    
    %sort peaks
    coeff_x=coeff(4:3:size(coeff,2));
    coeff_a=coeff(3:3:size(coeff,2));
    coeff_w=coeff(5:3:size(coeff,2));
    
    [coeff_x,sort_i]=sort(coeff_x);
    coeff_a=coeff_a(sort_i);
    coeff_w=coeff_w(sort_i);
    
    a1(i-ybegin_index+1)=coeff(1);
    a2(i-ybegin_index+1)=coeff(2);
    curve{i-ybegin_index+1}=result;
    
    for j=1:peaknum
        x{j}(i-ybegin_index+1)=coeff_x(j);
        a{j}(i-ybegin_index+1)=coeff_a(j);
        w{j}(i-ybegin_index+1)=coeff_w(j);
        y{j}(i-ybegin_index+1)=lines.v(i);
    end


    %plot result    
    contents=get(handles.line_color,'String');
    color_i=get(handles.line_color,'Value');           
    style_list={'-';'--';':';'-.'};
    linestyle=style_list{get(handles.line_style,'Value')};
    
    figure(fignum);
    hold on
       
           
    if get(handles.plot_line,'Value')
        color_i=rem(color_i,8)+1;
        linecolor=contents{color_i};
        xlim=get(gca,'XLim');
        set(gca,'XLim',[xdata(1),xdata(data_n)]);
        h=plot(result); 
        set(h,'Color',linecolor,'LineStyle',linestyle);
        set(gca,'XLim',xlim);       
    end
    
    
        for j=1:peaknum
            color_i=rem(color_i,8)+1;
            linecolor=contents{color_i};
            xlim=get(gca,'XLim');
            
            plot(coeff_x(j),result(coeff_x(j)),'LineStyle','none','Marker','v','MarkerEdgeColor',linecolor);
            
            if get(handles.plot_peaks,'Value')
            coeff_str='coeff(1),coeff(2)';
            for m=1:peaknum
                coeff_str=[coeff_str,',',num2str(coeff_a(m)*(m==j)),',',num2str(coeff_x(m)),',',num2str(coeff_w(m))];
            end
            peak_curve=eval(['cfit(ffun,',coeff_str,')']);
            
            set(gca,'XLim',[coeff_x(j)-2*coeff_w(j),coeff_x(j)+1.5*coeff_w(j)]);
            h=plot(peak_curve);
            set(h,'Color',linecolor,'LineStyle',linestyle);
            set(gca,'XLim',xlim);
           
            end
        end        
        legend('off');

end

if lines.EDC  %change x, y
    t=x;
    x=y;
    y=t;
end





output=struct('a1',a1,'a2',a2,'a',a,'x',x,'y',y,'w',w,'band',cell(1,peaknum),'curve',struct('c',curve),'EDC',lines.EDC,'peaknum',peaknum,'curvenum',yend_index-ybegin_index+1);

%output.band is the fitline of the peak. It is empty now. The fit operate
%is  at plot_peak_band function. So you can modify the peak data manually
%after check peak data at MDC fig or finish plot_peak_cut

assignin('base',var_name,output);
hold off;

 
        



% --- Executes on button press in plot_peak_cut.
function plot_peak_cut_Callback(hObject, eventdata, handles)
% hObject    handle to plot_peak_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents=get(handles.listbox1,'String');
var_name=contents{get(handles.listbox1,'Value')};
band=evalin('base',var_name);

fignum=str2num(get(handles.cut_fig_no,'String'));
hfig=figure(fignum);
hold on

peaknum=band(1).peaknum;
marker_contents=get(handles.marker,'String');
color_contents=get(handles.marker_color,'String');
for i=1:peaknum
    marker=marker_contents{rem(get(handles.marker,'Value')-2+i,8)+1};
    color=color_contents{rem(get(handles.marker_color,'Value')-2+i,8)+1};
    plot(band(i).x,band(i).y,'LineStyle','none','Marker',marker,'MarkerEdgeColor',color);
end


% --- Executes on button press in plot_band_cut.
function plot_band_cut_Callback(hObject, eventdata, handles)
% hObject    handle to plot_band_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents=get(handles.listbox1,'String');
var_name=contents{get(handles.listbox1,'Value')};
band=evalin('base',var_name);

peaknum=band(1).peaknum;

color_contents = cellstr(get(handles.line_color,'String'));
linecolor = color_contents{get(handles.line_color,'Value')};
style_list={'-';'--';':';'-.'};
linestyle=style_list{get(handles.line_style,'Value')};
linewidth=str2num(get(handles.line_width,'String'));


fignum=str2num(get(handles.cut_fig_no,'String'));
hfig=figure(fignum);
hold on

xlabel_h=get(gca,'XLabel');
ylabel_h=get(gca,'YLabel');
x_seting=get(xlabel_h,'String');
y_seting=get(ylabel_h,'String');

for i=1:peaknum
    % fit band first
    xdata=band(i).x;
    ydata=band(i).y;
    if get(handles.poly2,'Value')
        band(i).band=fit(xdata',ydata','poly2');
        ceff=coeffvalues(band(i).band);
        coin=confint(band(i).band,0.95);
        m=sprintf('y = %s\ncoefficients (with %s confidence bounds)\np1 = \t%g\t  (  \t%g\t , \t%g\t  )\np2 = \t%g\t  (  \t%g\t , \t%g\t  )\np3 = \t%g\t  (  \t%g\t , \t%g\t  )\n',...
        formula(band(i).band),'95%',ceff(1),coin(1,1),coin(2,1),ceff(2),coin(1,2),coin(2,2),ceff(3),coin(1,3),coin(2,3));
    else if get(handles.poly1,'Value')
            band(i).band=fit(xdata',ydata','poly1');
            ceff=coeffvalues(band(i).band);
            coin=confint(band(i).band,0.95);
            m=sprintf('y = %s\ncoefficients (with %s confidence bounds)\np1 = \t%g\t  (  \t%g\t , \t%g\t  )\np2 = \t%g\t  (  \t%g\t , \t%g\t  )\n',...
            formula(band(i).band),'95%',ceff(1),coin(1,1),coin(2,1),ceff(2),coin(1,2),coin(2,2));
        end
    end
   
    %plot fit result
    
    if strncmp('auto',get(handles.xlim_begin,'String'),1) || strncmp('auto',get(handles.xlim_end,'String'),1)
        xlim=[min(band(i).x),max(band(i).x)];
    else
        xlim=[str2num(get(handles.xlim_begin,'String')),str2num(get(handles.xlim_end,'String'))];
    end
    xlim_o=get(gca,'XLim');
    set(gca,'XLim',xlim);
    h(i)=plot(band(i).band);  %this function will change fig setting
    set(h(i),'Color',linecolor,'LineStyle',linestyle,'LineWidth',linewidth); %change fig setting as before plot
    set(gca,'Xlim',xlim_o);
    
    set(h(i),'DisplayName',m);
end

legend();


set(xlabel_h,'String',x_seting);
set(ylabel_h,'String',y_seting);
hold off

assignin('base',var_name,band);



function x_over_Callback(hObject, eventdata, handles)
% hObject    handle to x_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_over as text
%        str2double(get(hObject,'String')) returns contents of x_over as a double


% --- Executes during object creation, after setting all properties.
function x_over_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_over_Callback(hObject, eventdata, handles)
% hObject    handle to y_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_over as text
%        str2double(get(hObject,'String')) returns contents of y_over as a double


% --- Executes during object creation, after setting all properties.
function y_over_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_end_Callback(hObject, eventdata, handles)
% hObject    handle to x_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_end as text
%        str2double(get(hObject,'String')) returns contents of x_end as a double


% --- Executes during object creation, after setting all properties.
function x_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_end_Callback(hObject, eventdata, handles)
% hObject    handle to y_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_end as text
%        str2double(get(hObject,'String')) returns contents of y_end as a double


% --- Executes during object creation, after setting all properties.
function y_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in peak_num.
function peak_num_Callback(hObject, eventdata, handles)
% hObject    handle to peak_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns peak_num contents as cell array
%        contents{get(hObject,'Value')} returns selected item from peak_num


% --- Executes during object creation, after setting all properties.
function peak_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peak_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in p_c_f.
function p_c_f_Callback(hObject, eventdata, handles)
% hObject    handle to p_c_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p_c_f



function cut_fig_no_Callback(hObject, eventdata, handles)
% hObject    handle to cut_fig_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cut_fig_no as text
%        str2double(get(hObject,'String')) returns contents of cut_fig_no as a double


% --- Executes during object creation, after setting all properties.
function cut_fig_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cut_fig_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cut_fig_no_less.
function cut_fig_no_less_Callback(hObject, eventdata, handles)
% hObject    handle to cut_fig_no_less (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=str2num(get(handles.cut_fig_no,'String'))-1;
set(handles.cut_fig_no,'String',num2str(n));



% --- Executes on button press in cut_fig_no_more.
function cut_fig_no_more_Callback(hObject, eventdata, handles)
% hObject    handle to cut_fig_no_more (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=str2num(get(handles.cut_fig_no,'String'))+1;
set(handles.cut_fig_no,'String',num2str(n));

% --- Executes on selection change in marker.
function marker_Callback(hObject, eventdata, handles)
% hObject    handle to marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns marker contents as cell array
%        contents{get(hObject,'Value')} returns selected item from marker


% --- Executes during object creation, after setting all properties.
function marker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in marker_color.
function marker_color_Callback(hObject, eventdata, handles)
% hObject    handle to marker_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns marker_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from marker_color


% --- Executes during object creation, after setting all properties.
function marker_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to marker_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xlim_begin_Callback(hObject, eventdata, handles)
% hObject    handle to xlim_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlim_begin as text
%        str2double(get(hObject,'String')) returns contents of xlim_begin as a double


% --- Executes during object creation, after setting all properties.
function xlim_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xlim_end_Callback(hObject, eventdata, handles)
% hObject    handle to xlim_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlim_end as text
%        str2double(get(hObject,'String')) returns contents of xlim_end as a double


% --- Executes during object creation, after setting all properties.
function xlim_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
