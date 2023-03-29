function varargout = map_cmp(varargin)
% MAP_CMP MATLAB code for map_cmp.fig
%      MAP_CMP, by itself, creates a new MAP_CMP or raises the existing
%      singleton*.
%
%      H = MAP_CMP returns the handle to a new MAP_CMP or the handle to
%      the existing singleton*.
%
%      MAP_CMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAP_CMP.M with the given input arguments.
%
%      MAP_CMP('Property','Value',...) creates a new MAP_CMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before map_cmp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to map_cmp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help map_cmp

% Last Modified by GUIDE v2.5 06-Sep-2013 11:13:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @map_cmp_OpeningFcn, ...
                   'gui_OutputFcn',  @map_cmp_OutputFcn, ...
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


% --- Executes just before map_cmp is made visible.
function map_cmp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to map_cmp (see VARARGIN)

% Choose default command line output for map_cmp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes map_cmp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = map_cmp_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in refresh_variables.
function refresh_variables_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars = evalin('base','who');
set(handles.listbox1,'String',vars);
if isempty(vars)
    set(handles.listbox1,'Value',0);
else
    index=get(handles.listbox1,'Value');
    if index>length(vars)
        set(handles.listbox1,'Value',length(vars));
    elseif index==0
        set(handles.listbox1,'Value',1);
    end
end
set(handles.listbox2,'String',vars);
if isempty(vars)
    set(handles.listbox2,'Value',0);
else
    index=get(handles.listbox2,'Value');
    if index>length(vars)
        set(handles.listbox2,'Value',length(vars));
    elseif index==0
        set(handles.listbox2,'Value',1);
    end
end

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


% --- Executes on button press in compare.
function compare_Callback(hObject, eventdata, handles)
% hObject    handle to compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.listbox1,'String');
index_selected1 = get(handles.listbox1,'Value');
index_selected2 = get(handles.listbox2,'Value');

n1=length(index_selected1);
n2=length(index_selected2);
for i=1:n1
    var_name1{i} = list_entries{index_selected1(i)};  %determine the var in base
    data_map{i}=evalin('base',var_name1{i});
end
for j=1:n2
    var_name2{j} = list_entries{index_selected2(j)};
    data{j}=evalin('base',var_name2{j});
end
for j=1:n2
    x=data{j}.info.Xpos;
    y=data{j}.info.Zpos;
    disp(var_name2{j});
    for i=1:n1
        if isfield(data_map{i},'x')&&isfield(data_map{i},'y')
        x_min=min(min(data_map{i}.x));
        x_max=max(max(data_map{i}.x));
        y_min=min(min(data_map{i}.y));
        y_max=max(max(data_map{i}.y));
        

        if x>=x_min&&x<=x_max
            if y>=y_min&&y<=y_max
                disp(['    ',var_name1{i}]);
            end
        end
        end
    end
end


% --- Executes on button press in plot_all.
function plot_all_Callback(hObject, eventdata, handles)
% hObject    handle to plot_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.listbox1,'String');
index_selected1 = get(handles.listbox1,'Value');
index_selected2 = get(handles.listbox2,'Value');

n1=length(index_selected1);
n2=length(index_selected2);

for i=1:n1
    var_name1{i} = list_entries{index_selected1(i)};  %determine the var in base
    l=length(var_name1{i});
    num1{i}=str2num([var_name1{i}(l-7:l-4),var_name1{i}(l-2:l)]);
    data_map{i}=evalin('base',var_name1{i});
end
for j=1:n2
    var_name2{j} = list_entries{index_selected2(j)};
    l=length(var_name2{j});
    num2{j}=str2num([var_name2{j}(l-7:l-4),var_name2{j}(l-2:l)]);
    data{j}=evalin('base',var_name2{j});
end

for j=1:n2
    x=data{j}.info.Xpos;
    y=data{j}.info.Zpos;
    disp(var_name2{j});
    i0=0;
    % find its position
    for i=1:n1
        if isfield(data_map{i},'x')&&isfield(data_map{i},'y')
        x_min=min(min(data_map{i}.x));
        x_max=max(max(data_map{i}.x));
        y_min=min(min(data_map{i}.y));
        y_max=max(max(data_map{i}.y));
        
            if num1{i}<num2{j}
                if x>=x_min&&x<=x_max
                    if y>=y_min&&y<=y_max
                        i0=i;
                    end
                end
            end
            if strcmp(var_name2{j}(1:4),'SMPM')
                if x>=x_min&&x<=x_max
                    if y>=y_min&&y<=y_max
                        i0=i;
                    end
                end
            end
        end
    end
    
    % plot the map and the dispersion
    
    % plot dispersion
    figure(j);
    subplot(1,2,2);
    pcolor(data{j}.x,data{j}.y,data{j}.value');
    shading interp;
    colormap('gray');
    xlim=get(gca,'XLim');
    ylim=get(gca,'YLim');
    text(xlim(1)-(xlim(2)-xlim(1))*1.0,ylim(1)-(ylim(2)-ylim(1))*0.09,['(',num2str(x),', ',num2str(y),')']);
    %----------- add title -----------
    var_name_new=[]; k=1;    
    for i=1:size(var_name2{j},2)
        try
       if var_name2{j}(i)=='_'
          var_name_new(k)='\';
          k=k+1;
       end
        catch
            display(1);
        end
       var_name_new(k)=var_name2{j}(i);
       k=k+1;
    end
    title(char(var_name_new));
    
    % plot map
    subplot(1,2,1);
    %-- integrate in Energy dimension
    value_tmp=sum(data_map{i0}.value(:,:,:),3);
    pcolor(data_map{i0}.x,data_map{i0}.y,value_tmp');
    shading interp;
    colormap('Gray');
    hold on;
    xlim=get(gca,'XLim');
    ylim=get(gca,'YLim');
    x_cross=[x,x];
    y_cross=ylim;
    %h(1)=line(x_cross,y_cross);
    h(1)=plot(x_cross,y_cross,'r');
    x_cross=xlim;
    y_cross=[y,y];
    %h(2)=line(x_cross,y_cross);
    h(2)=plot(x_cross,y_cross,'r');
    axis equal;
    axis([xlim,ylim]);
    hold off;
    
    
    %----------- add title -----------
    var_name_new=[]; k=1;
    for i=1:size(var_name1{i0},2)
       if var_name1{i0}(i)=='_'
          var_name_new(k)='\';
          k=k+1;
       end
       var_name_new(k)=var_name1{i0}(i);
       k=k+1;
    end
    title(char(var_name_new));
    
    % image save
    %set(gcf,'Position',[200,100,1200,450], 'color','w');
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'points');
    set(gcf, 'PaperPosition', [0 0 600 250]);
    print(gcf, '-dpng',[var_name2{j},'.png'])
    close(j);
    
end
