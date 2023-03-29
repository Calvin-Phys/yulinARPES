function varargout = plot_tools2_demo(varargin)
% PLOT_TOOLS2_DEMO M-file for plot_tools2_demo.fig
%      PLOT_TOOLS2_DEMO, by itself, creates a new PLOT_TOOLS2_DEMO or raises the existing
%      singleton*.
%
%      H = PLOT_TOOLS2_DEMO returns the handle to a new PLOT_TOOLS2_DEMO or the handle to
%      the existing singleton*.
%
%      PLOT_TOOLS2_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_TOOLS2_DEMO.M with the given input arguments.
%
%      PLOT_TOOLS2_DEMO('Property','Value',...) creates a new PLOT_TOOLS2_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plot_tools_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plot_tools2_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plot_tools2_demo

% Last Modified by GUIDE v2.5 04-Apr-2017 20:13:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plot_tools2_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @plot_tools2_demo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before plot_tools2_demo is made visible.
function plot_tools2_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plot_tools2_demo (see VARARGIN)

% Choose default command line output for plot_tools2_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plot_tools2_demo wait for user response (see UIRESUME)
% uiwait(handles.plot_tools2_demo);


% --- Outputs from this function are returned to the command line.
function varargout = plot_tools2_demo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in grid_on.
function grid_on_Callback(hObject, eventdata, handles)
% hObject    handle to grid_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            grid on;
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    grid on;
    %PROCEEDED

end


% --- Executes on button press in grid_off.
function grid_off_Callback(hObject, eventdata, handles)
% hObject    handle to grid_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

grid off;

% --- Executes on button press in box_on.
function box_on_Callback(hObject, eventdata, handles)
% hObject    handle to box_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            box on;
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    box on;
    %PROCEEDED
end



% --- Executes on button press in box_off.
function box_off_Callback(hObject, eventdata, handles)
% hObject    handle to box_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            box off;
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    box off;
    %PROCEEDED
end



% --- Executes on button press in axis_on.
function axis_on_Callback(hObject, eventdata, handles)
% hObject    handle to axis_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            axis on;
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    axis on;
    %PROCEEDED
end



% --- Executes on button press in axis_off.
function axis_off_Callback(hObject, eventdata, handles)
% hObject    handle to axis_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            axis off;
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    axis off;
    %PROCEEDED

end


% --- Executes on button press in axis_normal.
function axis_normal_Callback(hObject, eventdata, handles)
% hObject    handle to axis_normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            axis normal;
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    axis normal;
    %PROCEEDED
end




% --- Executes on button press in axis_equal.
function axis_equal_Callback(hObject, eventdata, handles)
% hObject    handle to axis_equal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            axis equal;
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    axis equal;
    %PROCEEDED

end



% --- Executes on button press in interp.
function interp_Callback(hObject, eventdata, handles)
% hObject    handle to interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

shading interp;

% --- Executes on button press in faceted.
function faceted_Callback(hObject, eventdata, handles)
% hObject    handle to faceted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

shading faceted;

% --- Executes on button press in title.
function title_Callback(hObject, eventdata, handles)
% hObject    handle to title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list_size=get(handles.text_fontsize,'String');
index_size=get(handles.text_fontsize,'Value');
size=str2num(list_size{index_size});

list_interpreter=get(handles.text_interpreter,'String');
index_interpreter=get(handles.text_interpreter,'Value');
interpreter=list_interpreter{index_interpreter};

list_color=get(handles.text_color,'String');
index_color=get(handles.text_color,'Value');
color=list_color{index_color};

%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            title(get(handles.title_txt,'String'),'FontSize',size,'Interpreter',interpreter,'Color',color);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    title(get(handles.title_txt,'String'),'FontSize',size,'Interpreter',interpreter,'Color',color);
    %PROCEEDED
end
%%
% --- Executes during object creation, after setting all properties.
function title_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to title_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function title_txt_Callback(hObject, eventdata, handles)
% hObject    handle to title_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of title_txt as text
%        str2double(get(hObject,'String')) returns contents of title_txt as a double


% --- Executes on button press in xlabel.
function xlabel_Callback(hObject, eventdata, handles)
% hObject    handle to xlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% list_size=get(handles.text_fontsize,'String');
% index_size=get(handles.text_fontsize,'Value');
% size=str2num(list_size{index_size});

list_interpreter=get(handles.text_interpreter,'String');
index_interpreter=get(handles.text_interpreter,'Value');
interpreter=list_interpreter{index_interpreter};

list_color=get(handles.text_color,'String');
index_color=get(handles.text_color,'Value');
color=list_color{index_color};

%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            xlabel(get(handles.xlabel_txt,'String'),Interpreter',interpreter,'Color',color);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    xlabel(get(handles.xlabel_txt,'String'),'Interpreter',interpreter,'Color',color);
    %PROCEEDED

end



% --- Executes during object creation, after setting all properties.
function xlabel_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlabel_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xlabel_txt_Callback(hObject, eventdata, handles)
% hObject    handle to xlabel_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlabel_txt as text
%        str2double(get(hObject,'String')) returns contents of xlabel_txt as a double


% --- Executes on button press in x_axis.
function x_axis_Callback(hObject, eventdata, handles)
% hObject    handle to x_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

v=axis;
v(1)=str2num(get(handles.x_from,'String'));
v(2)=str2num(get(handles.x_to,'String'));

%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            axis(v);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    axis(v);
    %PROCEEDED

end



% --- Executes during object creation, after setting all properties.
function x_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_from_Callback(hObject, eventdata, handles)
% hObject    handle to x_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_from as text
%        str2double(get(hObject,'String')) returns contents of x_from as a double


% --- Executes during object creation, after setting all properties.
function x_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_to_Callback(hObject, eventdata, handles)
% hObject    handle to x_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_to as text
%        str2double(get(hObject,'String')) returns contents of x_to as a double


% --- Executes on button press in ylabel.
function ylabel_Callback(hObject, eventdata, handles)
% hObject    handle to ylabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% list_size=get(handles.text_fontsize,'String');
% index_size=get(handles.text_fontsize,'Value');
% size=str2num(list_size{index_size});

list_interpreter=get(handles.text_interpreter,'String');
index_interpreter=get(handles.text_interpreter,'Value');
interpreter=list_interpreter{index_interpreter};

list_color=get(handles.text_color,'String');
index_color=get(handles.text_color,'Value');
color=list_color{index_color};

%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            ylabel(get(handles.ylabel_txt,'String'),'Interpreter',interpreter,'Color',color);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    ylabel(get(handles.ylabel_txt,'String'),'Interpreter',interpreter,'Color',color);
    %PROCEEDED
end




% --- Executes during object creation, after setting all properties.
function ylabel_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylabel_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ylabel_txt_Callback(hObject, eventdata, handles)
% hObject    handle to ylabel_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylabel_txt as text
%        str2double(get(hObject,'String')) returns contents of ylabel_txt as a double


% --- Executes on button press in y_axis.
function y_axis_Callback(hObject, eventdata, handles)
% hObject    handle to y_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

v=axis;
v(3)=str2num(get(handles.y_from,'String'));
v(4)=str2num(get(handles.y_to,'String'));


%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            axis(v);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    axis(v);
    %PROCEEDED

end


% --- Executes during object creation, after setting all properties.
function y_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_from_Callback(hObject, eventdata, handles)
% hObject    handle to y_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_from as text
%        str2double(get(hObject,'String')) returns contents of y_from as a double


% --- Executes during object creation, after setting all properties.
function y_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_to_Callback(hObject, eventdata, handles)
% hObject    handle to y_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_to as text
%        str2double(get(hObject,'String')) returns contents of y_to as a double


% --- Executes on button press in zlabel.
function zlabel_Callback(hObject, eventdata, handles)
% hObject    handle to zlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list_size=get(handles.text_fontsize,'String');
index_size=get(handles.text_fontsize,'Value');
size=str2num(list_size{index_size});

list_interpreter=get(handles.text_interpreter,'String');
index_interpreter=get(handles.text_interpreter,'Value');
interpreter=list_interpreter{index_interpreter};

list_color=get(handles.text_color,'String');
index_color=get(handles.text_color,'Value');
color=list_color{index_color};

%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            zlabel(get(handles.zlabel_txt,'String'),'FontSize',size,'Interpreter',interpreter,'Color',color);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    zlabel(get(handles.zlabel_txt,'String'),'FontSize',size,'Interpreter',interpreter,'Color',color);
    %PROCEEDED
end




% --- Executes during object creation, after setting all properties.
function zlabel_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zlabel_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zlabel_txt_Callback(hObject, eventdata, handles)
% hObject    handle to zlabel_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zlabel_txt as text
%        str2double(get(hObject,'String')) returns contents of zlabel_txt as a double


% --- Executes on button press in z_axis.
function z_axis_Callback(hObject, eventdata, handles)
% hObject    handle to z_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

v=axis;
v(5)=str2num(get(handles.z_from,'String'));
v(6)=str2num(get(handles.z_to,'String'));


%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            axis(v);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    axis(v);
    %PROCEEDED
end



% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function z_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function z_to_Callback(hObject, eventdata, handles)
% hObject    handle to z_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_to as text
%        str2double(get(hObject,'String')) returns contents of z_to as a double


% --- Executes on button press in colormap_butt.
function colormap_butt_Callback(hObject, eventdata, handles)
% hObject    handle to colormap_butt (see GCBO)
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



% --- Executes during object creation, after setting all properties.
function colormap_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormap_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%load('C:\Users\Yulin_UG1\Documents\MATLAB\Colormaps\Colormap.mat');



% --- Executes on selection change in colormap_pop.
function colormap_pop_Callback(hObject, eventdata, handles)
% hObject    handle to colormap_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns colormap_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colormap_pop


% --- Executes during object creation, after setting all properties.
function z_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function z_from_Callback(hObject, eventdata, handles)
% hObject    handle to z_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_from as text
%        str2double(get(hObject,'String')) returns contents of z_from as a double


% --- Executes on button press in x_tick.
function x_tick_Callback(hObject, eventdata, handles)
% hObject    handle to x_tick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x_t=str2num(get(handles.x_tickv,'String'));


% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            set(gca,'xtick',x_t);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    set(gca,'xtick',x_t);
    %PROCEEDED
end

% --- Executes during object creation, after setting all properties.
function x_tickv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_tickv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_tickv_Callback(hObject, eventdata, handles)
% hObject    handle to x_tickv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_tickv as text
%        str2double(get(hObject,'String')) returns contents of x_tickv as a double


% --- Executes on button press in y_tick.
function y_tick_Callback(hObject, eventdata, handles)
% hObject    handle to y_tick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y_t=str2num(get(handles.y_tickv,'String'));
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            set(gca,'ytick',y_t);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    set(gca,'ytick',y_t);
    %PROCEEDED
end

% --- Executes during object creation, after setting all properties.
function y_tickv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_tickv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_tickv_Callback(hObject, eventdata, handles)
% hObject    handle to y_tickv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_tickv as text
%        str2double(get(hObject,'String')) returns contents of y_tickv as a double


% --- Executes on button press in z_tick.
function z_tick_Callback(hObject, eventdata, handles)
% hObject    handle to z_tick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

z_t=str2num(get(handles.z_tickv,'String'));
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            set(gca,'ztick',z_t);
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    set(gca,'ztick',z_t);
    %PROCEEDED
end




% --- Executes during object creation, after setting all properties.
function z_tickv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_tickv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function z_tickv_Callback(hObject, eventdata, handles)
% hObject    handle to z_tickv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_tickv as text
%        str2double(get(hObject,'String')) returns contents of z_tickv as a double


% --- Executes on button press in hold_on.
function hold_on_Callback(hObject, eventdata, handles)
% hObject    handle to hold_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hold on;

% --- Executes on button press in hold_off.
function hold_off_Callback(hObject, eventdata, handles)
% hObject    handle to hold_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hold off;


% --- Executes on button press in x_ef.
function x_ef_Callback(hObject, eventdata, handles)
% hObject    handle to x_ef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x0=str2num(get(handles.ef,'String'));
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
plot([x0,x0],axis_value(3:4),lcc);
hold off;


% --- Executes during object creation, after setting all properties.
function ef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ef_Callback(hObject, eventdata, handles)
% hObject    handle to ef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ef as text
%        str2double(get(hObject,'String')) returns contents of ef as a double



% --- Executes on button press in y_ef.
function y_ef_Callback(hObject, eventdata, handles)
% hObject    handle to y_ef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y0=str2num(get(handles.ef,'String'));
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
plot(axis_value(1:2),[y0,y0],lcc);
hold off;

% --- Executes during object creation, after setting all properties.
function ef_line_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ef_line_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ef_line_color.
function ef_line_color_Callback(hObject, eventdata, handles)
% hObject    handle to ef_line_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ef_line_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ef_line_color


% --- Executes on button press in axis_tight.
function axis_tight_Callback(hObject, eventdata, handles)
% hObject    handle to axis_tight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            axis tight;
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    axis tight;
    %PROCEEDED
end






% --- Executes on button press in axis_square.
function axis_square_Callback(hObject, eventdata, handles)
% hObject    handle to axis_square (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%
% Prcoceed Module 20141201
if get(handles.Apply2All,'Value')
    % get the children of subplots from the selected figure
    FigNum=str2num(get(handles.figure_no_edit,'string'));
    h_figure=get(FigNum,'Children');
    len=length(h_figure);
    if ~len
        return
    else
        for i=1:len
            % set the focus to the axes one by one.
            set(gcf,'CurrentAxes',h_figure(i));
            
            %PROCEED_1/2
            axis square;
            %PROCEEDED
        end
    end
else
    %PROCEED_2/2
    axis square;
    %PROCEEDED

end





% --- Executes on button press in rev_x_axis.
function rev_x_axis_Callback(hObject, eventdata, handles)
% hObject    handle to rev_x_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'XDir','reverse')

% --- Executes on button press in rev_z_axis.
function rev_z_axis_Callback(hObject, eventdata, handles)
% hObject    handle to rev_z_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'ZDir','reverse')

% --- Executes on button press in rev_y_axis.
function rev_y_axis_Callback(hObject, eventdata, handles)
% hObject    handle to rev_y_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'YDir','reverse')

% --- Executes on button press in nor_x_axis.
function nor_x_axis_Callback(hObject, eventdata, handles)
% hObject    handle to nor_x_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'XDir','normal')

% --- Executes on button press in nor_z_axis.
function nor_z_axis_Callback(hObject, eventdata, handles)
% hObject    handle to nor_z_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'ZDir','normal')


% --- Executes on button press in nor_y_axis.
function nor_y_axis_Callback(hObject, eventdata, handles)
% hObject    handle to nor_y_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'ZDir','normal')




% --- Executes on button press in sub_plots.
function sub_plots_Callback(hObject, eventdata, handles)
% hObject    handle to sub_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

r_no=str2num(get(handles.rows_no,'String'));
c_no=str2num(get(handles.columns_no,'String'));
t_no=r_no*c_no;
for i=1:t_no
    subplot(r_no,c_no,i)
end

function rows_no_Callback(hObject, eventdata, handles)
% hObject    handle to rows_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rows_no as text
%        str2double(get(hObject,'String')) returns contents of rows_no as a double


% --- Executes during object creation, after setting all properties.
function rows_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rows_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function columns_no_Callback(hObject, eventdata, handles)
% hObject    handle to columns_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of columns_no as text
%        str2double(get(hObject,'String')) returns contents of columns_no as a double


% --- Executes during object creation, after setting all properties.
function columns_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to columns_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in figure_no.
function figure_no_Callback(hObject, eventdata, handles)
% hObject    handle to figure_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(str2num(get(handles.figure_no_edit,'String')));
set(gcf,'color','w');



function figure_no_edit_Callback(hObject, eventdata, handles)
% hObject    handle to figure_no_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figure_no_edit as text
%        str2double(get(hObject,'String')) returns contents of figure_no_edit as a double


% --- Executes during object creation, after setting all properties.
function figure_no_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure_no_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in axis_layer_top.
function axis_layer_top_Callback(hObject, eventdata, handles)
% hObject    handle to axis_layer_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'Layer','top');


% --- Executes on button press in axis_layer_bottom.
function axis_layer_bottom_Callback(hObject, eventdata, handles)
% hObject    handle to axis_layer_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'Layer','bottom');


% --- Executes on button press in tick_dir_in.
function tick_dir_in_Callback(hObject, eventdata, handles)
% hObject    handle to tick_dir_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'TickDir','in');

% --- Executes on button press in Tick_dir_out.
function Tick_dir_out_Callback(hObject, eventdata, handles)
% hObject    handle to Tick_dir_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca,'TickDir','out');


% --- Executes on selection change in axis_color.
function axis_color_Callback(hObject, eventdata, handles)
% hObject    handle to axis_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns axis_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from axis_color


% --- Executes during object creation, after setting all properties.
function axis_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axis_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in axis_color_set.
function axis_color_set_Callback(hObject, eventdata, handles)
% hObject    handle to axis_color_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries=get(handles.axis_color,'String');
list_index=get(handles.axis_color,'Value');
color=list_entries{list_index};
set(gca,'XColor',color);
set(gca,'YColor',color);
set(gca,'ZColor',color);



function out_left_Callback(hObject, eventdata, handles)
% hObject    handle to out_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of out_left as text
%        str2double(get(hObject,'String')) returns contents of out_left as a double


% --- Executes during object creation, after setting all properties.
function out_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to out_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function out_bottom_Callback(hObject, eventdata, handles)
% hObject    handle to out_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of out_bottom as text
%        str2double(get(hObject,'String')) returns contents of out_bottom as a double


% --- Executes during object creation, after setting all properties.
function out_bottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to out_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function out_width_Callback(hObject, eventdata, handles)
% hObject    handle to out_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of out_width as text
%        str2double(get(hObject,'String')) returns contents of out_width as a double


% --- Executes during object creation, after setting all properties.
function out_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to out_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function out_height_Callback(hObject, eventdata, handles)
% hObject    handle to out_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of out_height as text
%        str2double(get(hObject,'String')) returns contents of out_height as a double


% --- Executes during object creation, after setting all properties.
function out_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to out_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resize.
function resize_Callback(hObject, eventdata, handles)
% hObject    handle to resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

window_style=get(gcf,'WindowStyle')
if window_style=='docked'
    set(gcf,'WindowStyle','normal')
else
end

width=str2num(get(handles.width,'String'));
height=str2num(get(handles.height,'String'));
size=get(gcf,'Position');

size(3)=width;
size(4)=height;

set(gcf,'Position',size);



% --- Executes on button press in out_resize.
function out_resize_Callback(hObject, eventdata, handles)
% hObject    handle to out_resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inner_position(1:2)=[str2num(get(handles.out_left,'String')),str2num(get(handles.out_bottom,'String'))]/100;
fig_size=get(gcf,'Position');
inner_position(3)=str2num(get(handles.out_width,'String'))/fig_size(3);
inner_position(4)=str2num(get(handles.out_height,'String'))/fig_size(4);
inner_position(1)=inner_position(1)-0.5*inner_position(3);
inner_position(2)=inner_position(2)-0.5*inner_position(4);
set(gca,'Position',inner_position);


% --- Executes on button press in colormapedit.
function colormapedit_Callback(hObject, eventdata, handles)
% hObject    handle to colormapedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=figure(gcf);
position=get(h,'Position');
windows_position=[position(1),position(2)];
calormapeditor_yizhang(h,windows_position);

% --- Executes on selection change in text_fontsize.
function text_fontsize_Callback(hObject, eventdata, handles)
% hObject    handle to text_fontsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns text_fontsize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from text_fontsize


% --- Executes during object creation, after setting all properties.
function text_fontsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_fontsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in text_interpreter.
function text_interpreter_Callback(hObject, eventdata, handles)
% hObject    handle to text_interpreter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns text_interpreter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from text_interpreter


% --- Executes during object creation, after setting all properties.
function text_interpreter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_interpreter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in text_color.
function text_color_Callback(hObject, eventdata, handles)
% hObject    handle to text_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns text_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from text_color


% --- Executes during object creation, after setting all properties.
function text_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in axis_font.
function axis_font_Callback(hObject, eventdata, handles)
% hObject    handle to axis_font (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns axis_font contents as cell array
%        contents{get(hObject,'Value')} returns selected item from axis_font


% --- Executes during object creation, after setting all properties.
function axis_font_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axis_font (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in axis_font_set.
function axis_font_set_Callback(hObject, eventdata, handles)
% hObject    handle to axis_font_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list=get(handles.axis_font,'String');
value=get(handles.axis_font,'Value');
size=str2num(list{value});
set(gca,'FontSize',size);


% --- Executes on button press in load_seting.
function load_seting_Callback(hObject, eventdata, handles)
% hObject    handle to load_seting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str=get(get(gca,'Title'),'String');
set(handles.title_txt,'String',str);

str=get(get(gca,'XLabel'),'String');
set(handles.xlabel_txt,'String',str);

str=get(get(gca,'YLabel'),'String');
set(handles.ylabel_txt,'String',str);

str=get(get(gca,'ZLabel'),'String');
set(handles.zlabel_txt,'String',str);

va=get(get(gca,'XLabel'),'FontSize');
list=[6:2:20];
val=find(round((list-va)/2)==0);
set(handles.text_fontsize,'Value',val);

if strcmpi(get(get(gca,'XLabel'),'Interpreter'),'tex')
    set(handles.text_interpreter,'Value',1);
else if strcmpi(get(get(gca,'XLabel'),'Interpreter'),'latex')
        set(handles.text_interpreter,'Value',2);
    else if strcmpi(get(get(gca,'XLabel'),'Interpreter'),'none')
            set(handles.text_interpreter,'Value',2);
        end
    end
end

va=get(gca,'FontSize');
list=[6:2:20];
val=find(round((list-va)/2)==0);
set(handles.axis_font,'Value',val);

va=get(gca,'XTick');
set(handles.x_tickv,'String',num2str(va));

va=get(gca,'YTick');
set(handles.y_tickv,'String',num2str(va));

va=get(gca,'ZTick');
set(handles.z_tickv,'String',num2str(va));

va=get(gca,'XLim');
set(handles.x_from,'String',num2str(va(1)));
set(handles.x_to,'String',num2str(va(2)));

va=get(gca,'YLim');
set(handles.y_from,'String',num2str(va(1)));
set(handles.y_to,'String',num2str(va(2)));

va=get(gca,'ZLim');
set(handles.z_from,'String',num2str(va(1)));
set(handles.z_to,'String',num2str(va(2)));

va=get(gcf,'Position');
set(handles.width,'String',num2str(va(3)));
set(handles.height,'String',num2str(va(4)));

inner_size=get(gca,'Position');
inner_size(3)=va(3)*inner_size(3);
inner_size(4)=va(4)*inner_size(4);
inner_size(1)=inner_size(1)+0.5*inner_size(3)/va(3);
inner_size(2)=inner_size(2)+0.5*inner_size(4)/va(4);
set(handles.out_left,'String',num2str(100*inner_size(1)));
set(handles.out_bottom,'String',num2str(100*inner_size(2)));
set(handles.out_width,'String',num2str(round(inner_size(3))));
set(handles.out_height,'String',num2str(round(inner_size(4))));

[va(1),va(2)]=view;
set(handles.azimuth,'String',num2str(-va(1)));
set(handles.elevation,'String',num2str(va(2)));



function azimuth_Callback(hObject, eventdata, handles)
% hObject    handle to azimuth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of azimuth as text
%        str2double(get(hObject,'String')) returns contents of azimuth as a double



% --- Executes during object creation, after setting all properties.
function azimuth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to azimuth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elevation_Callback(hObject, eventdata, handles)
% hObject    handle to elevation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elevation as text
%        str2double(get(hObject,'String')) returns contents of elevation as a double



% --- Executes during object creation, after setting all properties.
function elevation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elevation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in viewpoint.
function viewpoint_Callback(hObject, eventdata, handles)
% hObject    handle to viewpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
az=-str2double(get(handles.azimuth,'String'));
el=str2double(get(handles.elevation,'String'));
view(az,el);


% --- Executes on button press in exclude.
function exclude_Callback(hObject, eventdata, handles)
% hObject    handle to exclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(get(gco,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off');


% --- Executes on button press in include.
function include_Callback(hObject, eventdata, handles)
% hObject    handle to include (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(get(gco,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');


% --- Executes on button press in inverse_colormap.
function inverse_colormap_Callback(hObject, eventdata, handles)
% hObject    handle to inverse_colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inverse_colormap


% --- Executes on button press in Apply2All.
function Apply2All_Callback(hObject, eventdata, handles)
% hObject    handle to Apply2All (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Apply2All


% --- Executes on button press in publish.
function publish_Callback(hObject, eventdata, handles)
% hObject    handle to publish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=gcf;
hAxis=gca;
fileNameCellArray=inputdlg('Enter File Name','Publish Figure',1,{'SavedFigure'});
fileName=fileNameCellArray{1};
fileNameAxis=[fileName,'_ax'];    

%% Save Axis
hFig=figure;
hAxis=copyobj(hAxis,hFig);
xt=get(hAxis,'XTick');
yt=get(hAxis,'YTick');
zt=get(hAxis,'ZTick');
objList=findobj(hAxis);
set(hAxis,'XLimMode','manual','YLimMode','manual','ZLimMode','manual',...
    'XTick',xt,'YTick',yt,'ZTick',zt);
% for i=1:length(objList)    
%     if ~isa(objList(i),'matlab.graphics.axis.Axes')
%         delete(objList(i));
%     end
% end
for i=1:length(objList)
    if isa(objList(i),'matlab.graphics.primitive.Surface')
        delete(objList(i));
    end
end

print(hFig,fileNameAxis,'-deps');
close(hFig);

%% Save Picture
axis off;
figure(h);
print(h,fileName,'-dtiff');
axis on;





% --- Executes on button press in massplot_2D.
function massplot_2D_Callback(hObject, eventdata, handles)
% hObject    handle to massplot_2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
cols=str2num(get(handles.columns_no,'String'));
rows=str2num(get(handles.rows_no,'String'));
listbox2_entries=get(handles.listbox2,'String');
title_info_index=get(handles.listbox2,'Value');
title_info=listbox2_entries{title_info_index};

subplot_index=str2num(get(handles.subplot_start_index,'String'));

for ii=1:length(var_name)
if mod(ii,cols*rows)==1 && get(handles.radiobutton_new_fig,'Value')  %starts new figure if index exceeds subplot number %starts new figure if index exceeds subplot number
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
end;    

% --- Executes on button press in massplott_3D.
function massplott_3D_Callback(hObject, eventdata, handles)
% hObject    handle to massplott_3D (see GCBO)
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
cols=str2num(get(handles.columns_no,'String'));
rows=str2num(get(handles.rows_no,'String'));
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

% generate titles 
        unit_tmp=get(handles.popupmenu_units_massplott,'String');
        unit_tmp2=get(handles.popupmenu_units_massplott,'Value');
        unit=strtrim(unit_tmp(unit_tmp2)); %removes leading or trailing whitespace from unit


if direction=='z'
    for ii=1:length(slices)
    if mod(subplot_index,cols*rows)==1 && get(handles.radiobutton_new_fig,'Value')  %starts new figure if index exceeds subplot number
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

        if strcmp(unit,'eV')
            if slices(ii)==0
                title(['E=E_f'])
            else
                title(['E=E_f' sprintf('%.2f',slices(ii)) 'eV'])
            end;
        elseif strcmp(unit,'A')
            if slices(ii)==0
            title(['k=0 A^{-1}'])
            else
            title(['k=' sprintf('%.2f',slices(ii)) 'A^{-1}'])
            end;
        end;
    end;
elseif direction=='x'
    for ii=1:length(slices)
    if mod(subplot_index,cols*rows)==1 && get(handles.radiobutton_new_fig,'Value') %starts new figure if index exceeds subplot number
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
        if strcmp(unit,'eV')
            title(['hv= ' sprintf('%.2f',slices(ii)) 'eV'])
        elseif strcmp(unit,'A')
            if slices(ii)==0
            title(['k_x=0 A^{-1}'])
            else
            title(['k_x=' sprintf('%.2f',slices(ii)) 'A^{-1}'])
            end;
        end
        %title([sprintf('%.2f',slices(ii))])
    end;
elseif direction=='y'
    for ii=1:length(slices)
    if mod(subplot_index,cols*rows)==1 && get(handles.radiobutton_new_fig,'Value') %starts new figure if index exceeds subplot number
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


% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton56 (see GCBO)
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


% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton57 (see GCBO)
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


% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj(gca,'Type','line');
delete(h(:));

% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lines = findall(gca,'Type','line');
figHandles = get(gcf,'children');
for ii=1:length(figHandles)
copyobj(lines,figHandles(ii));
end;

% --- Executes on button press in pushbutton60.
% plot lines
function pushbutton60_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton60 (see GCBO)
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
end
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


% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton61 (see GCBO)
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
function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to ef_line_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ef_line_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ef_line_color


% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
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


% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
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


% --- Executes on button press in pushbutton_cp_lines.
function pushbutton_cp_lines_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cp_lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'UserData',findall(gca,'Type','line'));

% --- Executes on button press in pushbutton_paste_lines.
function pushbutton_paste_lines_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_paste_lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
copyobj( get(handles.pushbutton_cp_lines,'UserData'), gca )


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


% --- Executes on button press in pushbutton67.
function pushbutton67_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton67 (see GCBO)
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

% --- Executes on button press in pushbutton65.
function pushbutton65_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=gca;
CLIM_sample=h.CLim;
figHandles = get(gcf,'children');
for ii=1:length(figHandles)
figHandles(ii).CLim=CLIM_sample;

end;


% --- Executes on button press in pushbutton66.
function pushbutton66_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton66 (see GCBO)
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


% --- Executes on button press in radiobutton_new_fig.
function radiobutton_new_fig_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_new_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_new_fig


% --- Executes on selection change in massplott_suffix.
function massplott_suffix_Callback(hObject, eventdata, handles)
% hObject    handle to massplott_suffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns massplott_suffix contents as cell array
%        contents{get(hObject,'Value')} returns selected item from massplott_suffix


% --- Executes during object creation, after setting all properties.
function massplott_suffix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to massplott_suffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton68.
function pushbutton68_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figHandles = get(gcf,'children');
for ii=1:length(figHandles)
CLim_gca=figHandles(ii).CLim;
CLim_gca(2)=CLim_gca(2)*0.5;
figHandles(ii).CLim=CLim_gca;
end;


% --- Executes on selection change in popupmenu_units_massplott.
function popupmenu_units_massplott_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_units_massplott (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_units_massplott contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_units_massplott


% --- Executes during object creation, after setting all properties.
function popupmenu_units_massplott_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_units_massplott (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton69.
function pushbutton69_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HistHan([],[],[])
figure(findall(0,'type','figure','name','HistHan'))
