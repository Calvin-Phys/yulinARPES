function varargout = general_plot_demo(varargin)
% GENERAL_PLOT_DEMO M-file for general_plot_demo.fig
%      GENERAL_PLOT_DEMO, by itself, creates a new GENERAL_PLOT_DEMO or raises the existing
%      singleton*.
%
%      H = GENERAL_PLOT_DEMO returns the handle to a new GENERAL_PLOT_DEMO or the handle to
%      the existing singleton*.
%
%      GENERAL_PLOT_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERAL_PLOT_DEMO.M with the given input arguments.
%
%      GENERAL_PLOT_DEMO('Property','Value',...) creates a new GENERAL_PLOT_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before general_plot_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to general_plot_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to pushbutton13 general_plot_demo

% Last Modified by GUIDE v2.5 26-Apr-2017 17:51:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @general_plot_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @general_plot_demo_OutputFcn, ...
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


% --- Executes just before general_plot_demo is made visible.
function general_plot_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to general_plot_demo (see VARARGIN)

% Choose default command line output for general_plot_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes general_plot_demo wait for user response (see UIRESUME)
% uiwait(handles.general_plot_demo);

% --- Outputs from this function are returned to the command line.
function varargout = general_plot_demo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in along_x.
function along_x_Callback(hObject, eventdata, handles)
% hObject    handle to along_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of along_x

set(handles.along_nv,'Value',0);
set(handles.along_y,'Value',0);
set(handles.along_z,'Value',0);

% --- Executes on button press in along_y.
function along_y_Callback(hObject, eventdata, handles)
% hObject    handle to along_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of along_y

set(handles.along_nv,'Value',0);
set(handles.along_x,'Value',0);
set(handles.along_z,'Value',0);


% --- Executes on button press in along_z.
function along_z_Callback(hObject, eventdata, handles)
% hObject    handle to along_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of along_z

set(handles.along_nv,'Value',0);
set(handles.along_x,'Value',0);
set(handles.along_y,'Value',0);




% --- Executes on button press in along_nv.
function along_nv_Callback(hObject, eventdata, handles)
% hObject    handle to along_nv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of along_nv


set(handles.along_x,'Value',0);
set(handles.along_y,'Value',0);
set(handles.along_z,'Value',0);


% --- Executes on button press in d_1.
function d_1_Callback(hObject, eventdata, handles)
% hObject    handle to d_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of d_1

set(handles.d_2,'Value',0);


% --- Executes on button press in d_2.
function d_2_Callback(hObject, eventdata, handles)
% hObject    handle to d_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of d_2

set(handles.d_1,'Value',0);

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


% --- Executes on button press in index.
function index_Callback(hObject, eventdata, handles)
% hObject    handle to index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of index

set(handles.real_scale,'Value',0);


% --- Executes on button press in real_scale.
function real_scale_Callback(hObject, eventdata, handles)
% hObject    handle to real_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of real_scale

set(handles.index,'Value',0);

% --- Executes on button press in d_2_map.
function d_2_map_Callback(hObject, eventdata, handles)
% hObject    handle to d_2_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of d_2_map

set(handles.d_3_surf,'Value',0);
set(handles.stack_y,'Value',0);
set(handles.stack_x,'Value',0);


% --- Executes on button press in d_3_surf.
function d_3_surf_Callback(hObject, eventdata, handles)
% hObject    handle to d_3_surf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of d_3_surf

set(handles.d_2_map,'Value',0);
set(handles.stack_y,'Value',0);
set(handles.stack_x,'Value',0);

% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%==============================start==================================
%---------------get info-------------------
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
var_name = handles_h.VarNames;
var_name = var_name{1};  %get var_name
datav=evalin('base',var_name); 
if ~isfield(datav,'value')
    data.value=datav;
else
    data=datav;
end
clear datav;

figure_num=str2double(get(handles.figure_no,'String'));
save_plot=get(handles.save_plot_as,'Value');
save_name=get(handles.save_as,'String');
value_from=str2double(get(handles.x_from,'String'));
value_to=str2double(get(handles.y_to,'String'));
color_mapv=get(handles.color_map,'Value');

along_xv=get(handles.along_x,'Value');
along_yv=get(handles.along_y,'Value');
along_zv=get(handles.along_z,'Value');
along_nv=get(handles.along_nv,'Value');

x0=str2num(get(handles.nv_x0,'String'));
y0=str2num(get(handles.nv_y0,'String'));
x1=str2num(get(handles.nv_x1,'String'));
y1=str2num(get(handles.nv_y1,'String'));


d_1v=get(handles.d_1,'Value');
d_2v=get(handles.d_2,'Value');
interp_v=get(handles.interp_select,'Value');

scale_index=get(handles.index,'Value');
scale_real=get(handles.real_scale,'Value');

plot_2d=get(handles.d_2_map,'Value');
plot_3d=get(handles.d_3_surf,'Value');
plot_stacky=get(handles.stack_y,'Value');
plot_stackx=get(handles.stack_x,'Value');

if plot_stacky==1 || plot_stackx==1
    combinev=get(handles.combine,'Value');
    lc=get(handles.line_color,'Value');
    stack_offsetv=str2num(get(handles.stack_offset,'String'));
end
%----------------end of geting info-----------------------

%----------------judge & give error message---------------
if save_plot==1 && isempty(save_name)
    errordlg('By checking "Save plot as",...you need to give the var name you want to save!','Please input save-name','modal');
    return
end

%----------------- plot data ------------------------

%------------ 1-D plot-------------------------------
if d_1v==1
    
    %------------------------get the co-ordinate of the line-------------
        if scale_index==1
            index_x=value_from;
            index_y=value_to;
        else
            if size(size(data.value),2)==3
                if along_xv==1
                    index_x=round(1+(value_from-data.y(1))/(data.y(2)-data.y(1)));
                    index_y=round(1+(value_to-data.z(1))/(data.z(2)-data.z(1)));
                end
                if along_yv==1
                    index_x=round(1+(value_from-data.x(1))/(data.x(2)-data.x(1)));
                    index_y=round(1+(value_to-data.z(1))/(data.z(2)-data.z(1)));
                end
                if along_zv==1
                    index_x=round(1+(value_from-data.x(1))/(data.x(2)-data.x(1)));
                    index_y=round(1+(value_to-data.y(1))/(data.y(2)-data.y(1)));
                end
            else
                if along_xv==1
                    index_y=round(1+(value_to-data.y(1))/(data.y(2)-data.y(1)));
                end
                if along_yv==1
                    index_x=round(1+(value_from-data.x(1))/(data.x(2)-data.x(1)));
                end
            end
        end
    %--------------------------------plot & save ----------------------------------    
    if size(size(data.value),2)==3
        if along_xv==1
            plot_data.value=reshape(data.value(:,index_x,index_y),1,size(data.value(:,index_x,index_y),1));
            if isfield(data,'x'); %-----if there is real-scale info, use it, otherwise use index
                plot_data.x=data.x;
            else
                plot_data.x=(1:size(plot_data.value,2));
            end
                
            figure(figure_num);
            plot(plot_data.x,plot_data.value);
            
        end
        if along_yv==1
            plot_data.value=reshape(data.value(index_x,:,index_y),1,size(data.value(index_x,:,index_y),2));
            if isfield(data,'y');
                plot_data.x=data.y;
            else
                plot_data.x=(1:size(plot_data.value,2));
            end
                
            figure(figure_num);
            plot(plot_data.x,plot_data.value);
        end
        if along_zv==1
            plot_data.value=reshape(data.value(index_x,index_y,:),1,size(data.value(index_x,index_y,:),3));
            if isfield(data,'z');
                plot_data.x=data.z;
            else
                plot_data.x=(1:size(plot_data.value,2));
            end
                
            figure(figure_num);
            plot(plot_data.x,plot_data.value);
        end
    else
        if along_xv==1
            plot_data.value=data.value(:,index_y);
            if isfield(data,'x');
                plot_data.x=data.x;
            else
                plot_data.x=(1:size(plot_data.value,2));
            end
                
            figure(figure_num);
            plot(plot_data.x,plot_data.value);
        end
        if along_yv==1
            plot_data.value=data.value(index_x,:);
            if isfield(data,'y');
                plot_data.x=data.y;
            else
                plot_data.x=(1:size(plot_data.value,2));
            end
                
            figure(figure_num);
            plot(plot_data.x,plot_data.value);
        end
    end
    
    if save_plot==1
        assignin('base',save_name,plot_data);
    end
    
    %----------- add title -----------
    var_name_new=[]; j=1;
    for i=1:size(var_name,2)
       if var_name(i)=='_'
          var_name_new(j)='\';
          j=j+1;
       end
       var_name_new(j)=var_name(i);
       j=j+1;
    end
    title(char(var_name_new));
    if get(handles.axeq,'Value')
        axis equal;
    end
    %set background color
    set(gcf,'Color','white');
    figure_num=str2num(get(handles.figure_no,'String'));
    
    list_entries = get(handles.color_map,'String');
    index_selected = get(handles.color_map,'Value');
    colormap_v = list_entries{index_selected(1)};
    
    figure(figure_num);
    colormap(colormap_v);
    return;
end

%------------------------------2-D plot------------------------------

if d_2v==1
    
    %------------------------get the co-ordinate of the line-------------
        if scale_index==1
            index_x=value_from;
            index_y=value_to;
        else %-------real scale------------
            if ndims(data.value)==3||ndims(data.value)==4
                
                if ~isfield(data,'x') | ~isfield(data,'y') | ~isfield(data,'z')
                    errordlg('If you choose real-scale, the data should include the scale info','Wrong choice');
                    return;
                end                  
       
                if along_xv==1
                    index_x=round(1+(value_from-data.x(1))/(data.x(2)-data.x(1)));
                    index_y=round(1+(value_to-data.x(1))/(data.x(2)-data.x(1)));
                end
                if along_yv==1
                    index_x=round(1+(value_from-data.y(1))/(data.y(2)-data.y(1)));
                    index_y=round(1+(value_to-data.y(1))/(data.y(2)-data.y(1)));
                end
                if along_zv==1
                    index_x=round(1+(value_from-data.z(1))/(data.z(2)-data.z(1)));
                    index_y=round(1+(value_to-data.z(1))/(data.z(2)-data.z(1)));
                end
            else    % if the source data is 2-D, then just plot itself
                
                if ~isfield(data,'x') | ~isfield(data,'y')
                    errordlg('If you choose real-scale, the data should include the scale info','Wrong choice');
                    return;
                end                  

                
                if along_xv==1
                    errordlg('2-D plot can not choose along_x direction on 2-D data','Wrong choice');
                    return;
                end
                if along_yv==1
                    errordlg('2-D plot can not choose along_y direction on 2-D data','Wrong choice');
                    return;
                end
                if along_yv==1
                    index_x=1;
                    index_y=1;
                end

            end
        end
        

    %--------------------------------plot & save ----------------------------------    
    if ndims(data.value)==3||ndims(data.value)==4
        if along_xv==1 % -------------along x-direction----------------------------
            plot_data.value(:,:)=sum(data.value(index_x:index_y,:,:),1);
            if isfield(data,'y') & isfield(data,'z') %-----if there is real-scale info, use it, otherwise use index
                plot_data.x=data.y;
                plot_data.y=data.z;
            else
                plot_data.x=(1:size(plot_data.value,1));
                plot_data.y=(1:size(plot_data.value,2));
            end
        end
        
        if along_yv==1 % -------------along y-direction----------------------------
            plot_data.value(:,:)=sum(data.value(:,index_x:index_y,:),2);
            if isfield(data,'x') & isfield(data,'z') %-----if there is real-scale info, use it, otherwise use index
                plot_data.x=data.x;
                plot_data.y=data.z;
            else
                plot_data.x=(1:size(plot_data.value,1));
                plot_data.y=(1:size(plot_data.value,2));
            end
        end

            % plot a line on the equal energy surface that corresponds to cut
    if get(handles.checkbox_plot_line,'Value')
        if along_yv==1
            fig_line_plot=str2num(get(handles.edit_line_fig,'String'));
            figure(fig_line_plot)
            %first delete all existing lines
            h = findobj(gca,'Type','line');
            delete(h(:));            
            %now plot new lines
            axis_value=axis;
            hold on;
            plot(axis_value(1:2),[value_from,value_from],'blue');
            plot(axis_value(1:2),[value_to,value_to],'blue');

        elseif along_xv==1
            fig_line_plot=str2num(get(handles.edit_line_fig,'String'));
            figure(fig_line_plot)
            %first delete all existing lines
            h = findobj(gca,'Type','line');
            delete(h(:));            
            %now plot new lines
            axis_value=axis;
            hold on;
            plot([value_from,value_from],axis_value(3:4),'blue');
            plot([value_to,value_to],axis_value(3:4),'blue');
        end
    end
    

        if along_zv==1 % -------------along z-direction----------------------------
            if ndims(data.value)==4
                data.value=squeeze(sum(data.value,3));
            end
            plot_data.value(:,:)=sum(data.value(:,:,index_x:index_y),3);
            if isfield(data,'x') && isfield(data,'y') %-----if there is real-scale info, use it, otherwise use index
                plot_data.x=data.x;
                plot_data.y=data.y;
            else
                plot_data.x=(1:size(plot_data.value,1));
                plot_data.y=(1:size(plot_data.value,2));
            end
        end
        
        if along_nv==1 %---------------along n-direction
            [x,y,r]=area_secant_ph(data.x,data.y,x0,y0,x1,y1);
            [x_grid,y_grid,z_grid]=meshgrid(data.x,data.y,data.z);
            %This step may take a while...
            %F=scatteredInterpolant(x_grid(:),y_grid(:),z_grid(:),data.value(:));
            xx=repmat(x,max(size(data.z)),1);
            yy=repmat(y,max(size(data.z)),1);
            zz=repmat(data.z',1,max(size(x)));
            plot_data.value=interp3(x_grid,y_grid,z_grid, permute(data.value,[2,1,3]),xx,yy,zz);
            plot_data.value=plot_data.value';
            plot_data.x=r;
            plot_data.y=data.z;
            
        end
        
        
    elseif size(size(data.value),2)==2 %--------------if source is 2-D, then no need to specify direction
        plot_data.value=data.value;
        if isfield(data,'x') & isfield(data,'y') %-----if there is real-scale info, use it, otherwise use index
                plot_data.x=data.x;
                plot_data.y=data.y;
        else
                plot_data.x=(1:size(plot_data.value,1));
                plot_data.y=(1:size(plot_data.value,2));
        end
   end
   
    
    %---------start plotting-------------
    figure(figure_num);
    hAllAxes = findobj(gcf,'type','axes');
    if ~isempty(hAllAxes)
        climits=caxis; %copies current color map if there already exists one
    end
    if plot_2d==1
        pcolor(plot_data.x,plot_data.y,plot_data.value');
        if ~isempty(hAllAxes)
        caxis(climits); %copies current color map if there already exists one
        end
    elseif plot_3d==1
        surf(plot_data.x,plot_data.y,plot_data.value');
    else
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
        
        if plot_stacky==1
            st_sz=str2num(get(handles.stack_rate,'String'));
            for i=1:st_sz:size(plot_data.value,1)
                %plot(plot_data.y,plot_data.value(i,:)+(i-1)*stack_offsetv/st_sz,lcc);
                    if combinev==1 && (i+st_sz-1)<=size(plot_data.value,1)
                        plot(plot_data.y,sum(plot_data.value(i:i+st_sz-1,:),1)/st_sz+(i-1)*stack_offsetv/st_sz,lcc);
                    elseif combinev==0
                        plot(plot_data.y,plot_data.value(i,:)+(i-1)*stack_offsetv/st_sz,lcc);
                    end
                hold on;
            end
        end
            
        if plot_stackx==1
            st_sz=str2num(get(handles.stack_rate,'String'));
            for i=1:st_sz:size(plot_data.value,2)
                %plot(plot_data.x,plot_data.value(:,i)+(i-1)*stack_offsetv/st_sz,lcc);
                    if combinev==1 && (i+st_sz-1)<=size(plot_data.value,2)
                        plot(plot_data.x,sum(plot_data.value(:,i:i+st_sz-1),2)/st_sz+(i-1)*stack_offsetv/st_sz,lcc);
                    elseif combinev==0
                        plot(plot_data.x,plot_data.value(:,i)+(i-1)*stack_offsetv/st_sz,lcc);
                    end
                hold on;
            end
        end
        hold off;
           
    end
        
    % save data
    if save_plot==1
        assignin('base',save_name,plot_data);
    end

    if interp_v==1
        shading interp;
    end
    %----------- add title -----------
    var_name_new=[]; j=1;
    for i=1:size(var_name,2)
        if var_name(i)=='_'
            var_name_new(j)='\';
            j=j+1;
        end
        var_name_new(j)=var_name(i);
        j=j+1;
    end
    title(char(var_name_new));
    if get(handles.axeq,'Value')
        axis equal;
    end
    %set background color
    set(gcf,'Color','white');
    figure_num=str2num(get(handles.figure_no,'String'));
    
%     list_entries = get(handles.color_map,'String');
%     index_selected = get(handles.color_map,'Value');
%     colormap_v = list_entries{index_selected(1)};
    
    figure(figure_num);
%     colormap(colormap_v);
    return;
end

%==============================end====================================


% --- Executes on button press in grid_on.
function grid_on_Callback(hObject, eventdata, handles)
% hObject    handle to grid_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure_num=str2num(get(handles.figure_no,'String'));
figure(figure_num);
grid on;

% --- Executes on button press in grid_off.
function grid_off_Callback(hObject, eventdata, handles)
% hObject    handle to grid_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure_num=str2num(get(handles.figure_no,'String'));
figure(figure_num);
grid off;

% --- Executes on button press in x_ef_line.
function x_ef_line_Callback(hObject, eventdata, handles)
% hObject    handle to x_ef_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x0=str2num(get(handles.ef,'String'));
figure_num=str2num(get(handles.figure_no,'String'));
figure(figure_num);
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

% --- Executes on button press in interp.
function interp_Callback(hObject, eventdata, handles)
% hObject    handle to interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure_num=str2num(get(handles.figure_no,'String'));
figure(figure_num);
shading interp;


% --- Executes during object creation, after setting all properties.
function figure_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function figure_no_Callback(hObject, eventdata, handles)
% hObject    handle to figure_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figure_no as text
%        str2double(get(hObject,'String')) returns contents of figure_no as a double


% --- Executes during object creation, after setting all properties.
function color_map_CreateFcn(hObject, eventdata, handles)
% hObject    handle to color_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in color_map.
function color_map_Callback(hObject, eventdata, handles)
% hObject    handle to color_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns color_map contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        color_map


% --- Executes on button press in stack_y.
function stack_y_Callback(hObject, eventdata, handles)
% hObject    handle to stack_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stack_y

set(handles.d_2_map,'Value',0);
set(handles.d_3_surf,'Value',0);
set(handles.stack_x,'Value',0);

% --- Executes on button press in stack_x.
function stack_x_Callback(hObject, eventdata, handles)
% hObject    handle to stack_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stack_x

set(handles.d_2_map,'Value',0);
set(handles.d_3_surf,'Value',0);
set(handles.stack_y,'Value',0);

% --- Executes during object creation, after setting all properties.
function stack_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stack_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stack_offset_Callback(hObject, eventdata, handles)
% hObject    handle to stack_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stack_offset as text
%        str2double(get(hObject,'String')) returns contents of stack_offset as a double



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


% --- Executes on button press in save_plotted_data.
function save_plotted_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_plotted_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function save_as_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function save_as_Callback(hObject, eventdata, handles)
% hObject    handle to save_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_as as text
%        str2double(get(hObject,'String')) returns contents of save_as as a double


% --- Executes on button press in figure_less.
function figure_less_Callback(hObject, eventdata, handles)
% hObject    handle to figure_less (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure_num=str2num(get(handles.figure_no,'String'));
figure_num=figure_num-1;
set(handles.figure_no,'String',num2str(figure_num));

% --- Executes on button press in figure_more.
function figure_more_Callback(hObject, eventdata, handles)
% hObject    handle to figure_more (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure_num=str2num(get(handles.figure_no,'String'));
figure_num=figure_num+1;
set(handles.figure_no,'String',num2str(figure_num));


% --- Executes on button press in save_plot_as.
function save_plot_as_Callback(hObject, eventdata, handles)
% hObject    handle to save_plot_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_plot_as


% --- Executes on button press in y_ef_line.
function y_ef_line_Callback(hObject, eventdata, handles)
% hObject    handle to y_ef_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y0=str2num(get(handles.ef,'String'));
figure_num=str2num(get(handles.figure_no,'String'));
figure(figure_num);
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

% --- Executes on button press in colormap_button.
function colormap_button_Callback(hObject, eventdata, handles)
% hObject    handle to colormap_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure_num=str2num(get(handles.figure_no,'String'));

list_entries = get(handles.color_map,'String');
index_selected = get(handles.color_map,'Value');
colormap_v = list_entries{index_selected(1)}; 

figure(figure_num);
colormap(colormap_v);



% --- Executes during object creation, after setting all properties.
function line_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to line_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in line_color.
function line_color_Callback(hObject, eventdata, handles)
% hObject    handle to line_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns line_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from line_color


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function dimension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dimension_Callback(hObject, eventdata, handles)
% hObject    handle to dimension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimension as text
%        str2double(get(hObject,'String')) returns contents of dimension as a double


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
function x_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_end_Callback(hObject, eventdata, handles)
% hObject    handle to x_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_end as text
%        str2double(get(hObject,'String')) returns contents of x_end as a double


% --- Executes during object creation, after setting all properties.
function y_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_start_Callback(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_start as text
%        str2double(get(hObject,'String')) returns contents of y_start as a double


% --- Executes during object creation, after setting all properties.
function y_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_end_Callback(hObject, eventdata, handles)
% hObject    handle to y_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_end as text
%        str2double(get(hObject,'String')) returns contents of y_end as a double


% --- Executes during object creation, after setting all properties.
function z_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function z_start_Callback(hObject, eventdata, handles)
% hObject    handle to z_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_start as text
%        str2double(get(hObject,'String')) returns contents of z_start as a double


% --- Executes during object creation, after setting all properties.
function z_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function z_end_Callback(hObject, eventdata, handles)
% hObject    handle to z_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_end as text
%        str2double(get(hObject,'String')) returns contents of z_end as a double


% --- Executes during object creation, after setting all properties.
function no_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function no_x_Callback(hObject, eventdata, handles)
% hObject    handle to no_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_x as text
%        str2double(get(hObject,'String')) returns contents of no_x as a double


% --- Executes during object creation, after setting all properties.
function no_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function no_y_Callback(hObject, eventdata, handles)
% hObject    handle to no_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_y as text
%        str2double(get(hObject,'String')) returns contents of no_y as a double


% --- Executes during object creation, after setting all properties.
function no_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function no_z_Callback(hObject, eventdata, handles)
% hObject    handle to no_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_z as text
%        str2double(get(hObject,'String')) returns contents of no_z as a double


% --- Executes during object creation, after setting all properties.
function x_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_start_Callback(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_start as text
%        str2double(get(hObject,'String')) returns contents of x_start as a double


% --- Executes during object creation, after setting all properties.
function Ef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Ef_Callback(hObject, eventdata, handles)
% hObject    handle to Ef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ef as text
%        str2double(get(hObject,'String')) returns contents of Ef as a double


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


% --- Executes during object creation, after setting all properties.
function stack_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stack_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stack_rate_Callback(hObject, eventdata, handles)
% hObject    handle to stack_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stack_rate as text
%        str2double(get(hObject,'String')) returns contents of stack_rate as a double


% --- Executes on button press in stack_dec.
function stack_dec_Callback(hObject, eventdata, handles)
% hObject    handle to stack_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

st_no=str2num(get(handles.stack_rate,'String'));
st_no=st_no-1;
set(handles.stack_rate,'String',num2str(st_no));

% --- Executes on button press in stack_inc.
function stack_inc_Callback(hObject, eventdata, handles)
% hObject    handle to stack_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

st_no=str2num(get(handles.stack_rate,'String'));
st_no=st_no+1;
set(handles.stack_rate,'String',num2str(st_no));


% --- Executes on button press in x_from_dec.
function x_from_dec_Callback(hObject, eventdata, handles)
% hObject    handle to x_from_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

step_sizev=str2num(get(handles.stepsize,'String'));
x_fromv=str2num(get(handles.x_from,'String'));
%indexv=get(handles.index,'Value');
%if indexv==1
%    x_fromv=x_fromv-1;
%else
%    x_fromv=x_fromv-0.01;
%end
set(handles.x_from,'String',num2str(x_fromv-step_sizev));

% --- Executes on button press in x_from_inc.
function x_from_inc_Callback(hObject, eventdata, handles)
% hObject    handle to x_from_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x_fromv=str2num(get(handles.x_from,'String'));
step_sizev=str2num(get(handles.stepsize,'String'));
%indexv=get(handles.index,'Value');
%if indexv==1
%    x_fromv=x_fromv+1;
%else
%    x_fromv=x_fromv+0.01;
%end
set(handles.x_from,'String',num2str(x_fromv+step_sizev));

% --- Executes on button press in y_to_dec.
function y_to_dec_Callback(hObject, eventdata, handles)
% hObject    handle to y_to_dec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y_tov=str2num(get(handles.y_to,'String'));
step_sizev=str2num(get(handles.stepsize,'String'));
%indexv=get(handles.index,'Value');
%if indexv==1
%    y_tov=y_tov-1;
%else
%    y_tov=y_tov-0.01;
%end
set(handles.y_to,'String',num2str(y_tov-step_sizev));

% --- Executes on button press in y_to_inc.
function y_to_inc_Callback(hObject, eventdata, handles)
% hObject    handle to y_to_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y_tov=str2num(get(handles.y_to,'String'));
step_sizev=str2num(get(handles.stepsize,'String'));
%indexv=get(handles.index,'Value');
%if indexv==1
%    y_tov=y_tov+1;
%else
%    y_tov=y_tov+0.01;
%end

set(handles.y_to,'String',num2str(y_tov+step_sizev));


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


% --- Executes during object creation, after setting all properties.
function stepsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stepsize_Callback(hObject, eventdata, handles)
% hObject    handle to stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepsize as text
%        str2double(get(hObject,'String')) returns contents of stepsize as a double


% --- Executes on button press in combine.
function combine_Callback(hObject, eventdata, handles)
% hObject    handle to combine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of combine


% --- Executes during object creation, after setting all properties.
function sz_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sz_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function sz_x_Callback(hObject, eventdata, handles)
% hObject    handle to sz_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sz_x as text
%        str2double(get(hObject,'String')) returns contents of sz_x as a double


% --- Executes during object creation, after setting all properties.
function sz_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sz_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function sz_y_Callback(hObject, eventdata, handles)
% hObject    handle to sz_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sz_y as text
%        str2double(get(hObject,'String')) returns contents of sz_y as a double


% --- Executes during object creation, after setting all properties.
function sz_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sz_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function sz_z_Callback(hObject, eventdata, handles)
% hObject    handle to sz_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sz_z as text
%        str2double(get(hObject,'String')) returns contents of sz_z as a double


% --- Executes on button press in interp_select.
function interp_select_Callback(hObject, eventdata, handles)
% hObject    handle to interp_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of interp_select




% --- Executes on key press with focus on x_from and none of its controls.
function x_from_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to x_from (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
x_from=str2double(get(handles.x_from,'String'));
y_to=str2double(get(handles.y_to,'String'));
stepsize=str2double(get(handles.stepsize,'String'));

switch eventdata.Key
    case 'uparrow'
        set(handles.x_from,'String',num2str(x_from+stepsize));
        set(handles.y_to,'String',num2str(y_to+stepsize));
        guidata(handles.general_plot_demo, handles);
        plot_Callback(handles.plot, eventdata, handles)
        uicontrol(handles.x_from)
    case 'downarrow'
        set(handles.x_from,'String',num2str(x_from-stepsize));
        set(handles.y_to,'String',num2str(y_to-stepsize));
        guidata(handles.general_plot_demo, handles);
        plot_Callback(handles.plot, eventdata, handles)
        uicontrol(handles.x_from)
end


% --- Executes on key press with focus on y_to and none of its controls.
function y_to_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to y_to (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

x_from=str2double(get(handles.x_from,'String'));
y_to=str2double(get(handles.y_to,'String'));
stepsize=str2double(get(handles.stepsize,'String'));

switch eventdata.Key
    case 'uparrow'
        set(handles.x_from,'String',num2str(x_from+stepsize));
        set(handles.y_to,'String',num2str(y_to+stepsize));
        guidata(handles.general_plot_demo, handles);
        plot_Callback(handles.plot, eventdata, handles)
        set(gcf,'KeyPressFcn',@y_to_KeyPressFcn);
        uicontrol(handles.y_to)
    case 'downarrow'
        set(handles.x_from,'String',num2str(x_from-stepsize));
        set(handles.y_to,'String',num2str(y_to-stepsize));
        guidata(handles.general_plot_demo, handles);
        plot_Callback(handles.plot, eventdata, handles)
        uicontrol(handles.y_to)
end


% --- Executes on button press in PlotWithControls.
function PlotWithControls_Callback(hObject, eventdata, handles)
% hObject    handle to PlotWithControls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%==============================start==================================
%---------------get info-------------------
h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
handles_h = guidata(h);
VarNames = handles_h.VarNames;
var_name = VarNames{1};  %determine the var in base

figure_num=str2double(get(handles.figure_no,'String'));
value_from=str2double(get(handles.x_from,'String'));
value_to=str2double(get(handles.y_to,'String'));

along_xv=get(handles.along_x,'Value');
along_yv=get(handles.along_y,'Value');
along_zv=get(handles.along_z,'Value');

d_1v=get(handles.d_1,'Value');
d_2v=get(handles.d_2,'Value');
interp_v=get(handles.interp_select,'Value');

scale_index=get(handles.index,'Value');
scale_real=get(handles.real_scale,'Value');

plot_2d=get(handles.d_2_map,'Value');
plot_3d=get(handles.d_3_surf,'Value');
plot_stacky=get(handles.stack_y,'Value');
plot_stackx=get(handles.stack_x,'Value');

%----------------end of geting info-----------------------

userdata.VarName=var_name;
if along_xv
    userdata.Direction='along x';
elseif along_yv
    userdata.Direction='along y';
elseif along_zv
    userdata.Direction='along z';
elseif along_nv
    userdata.Direction=['along nv ',num2str(x0),' ',num2str(y0),...
        ' ',num2str(x1),' ',num2str(y1)];
end
if d_1v
    userdata.PlotDim='1D';
elseif d_2v
    userdata.PlotDim='2D';
end
if scale_index
    userdata.IndexOrReal='index';
elseif scale_real
    userdata.IndexOrReal='real';
end
if plot_2d
    userdata.PlotType='2Dmap';
elseif plot_3d
    userdata.PlotType='3Dsurf';
elseif plot_stacky
    userdata.PlotType='EDC';
elseif plot_stackx
    userdata.PlotType='MDC';
end
userdata.XFrom=num2str(value_from);
userdata.YTo=num2str(value_to);
userdata.StepSize=get(handles.stepsize,'String');
userdata.is_Combine=get(handles.combine,'Value');
userdata.StackOffset=get(handles.stack_offset,'String');
userdata.StackRate=get(handles.stack_rate,'String');
userdata.is_Interp=interp_v;
userdata.TifOrEps='tif';
FigureWithControls(figure_num,userdata)
%==============================end====================================






function nv_x0_Callback(hObject, eventdata, handles)
% hObject    handle to nv_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nv_x0 as text
%        str2double(get(hObject,'String')) returns contents of nv_x0 as a double


% --- Executes during object creation, after setting all properties.
function nv_x0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nv_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nv_y0_Callback(hObject, eventdata, handles)
% hObject    handle to nv_y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nv_y0 as text
%        str2double(get(hObject,'String')) returns contents of nv_y0 as a double


% --- Executes during object creation, after setting all properties.
function nv_y0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nv_y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nv_x1_Callback(hObject, eventdata, handles)
% hObject    handle to nv_x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nv_x1 as text
%        str2double(get(hObject,'String')) returns contents of nv_x1 as a double


% --- Executes during object creation, after setting all properties.
function nv_x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nv_x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nv_y1_Callback(hObject, eventdata, handles)
% hObject    handle to nv_y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nv_y1 as text
%        str2double(get(hObject,'String')) returns contents of nv_y1 as a double


% --- Executes during object creation, after setting all properties.
function nv_y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nv_y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in axeq.
function axeq_Callback(hObject, eventdata, handles)
% hObject    handle to axeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of axeq


% --- Executes when general_plot_demo is resized.
function general_plot_demo_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to general_plot_demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in get.
function get_Callback(hObject, eventdata, handles)
% hObject    handle to get (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig=get(handles.figure_no,'String');
fig=str2double(fig);
handles=guidata(hObject);
[x,y]=getline(figure(fig));
if length(x)<2
    return
end
set(handles.nv_x0,'String',num2str(x(1)));
set(handles.nv_y0,'String',num2str(y(1)));
set(handles.nv_x1,'String',num2str(x(2)));
set(handles.nv_y1,'String',num2str(y(2)));
fig=fig+1;
fig=num2str(fig);
set(handles.figure_no,'String',fig);
delete(findobj(hObject,'Type','Axes'));



% --- Executes on button press in checkbox_plot_line.
function checkbox_plot_line_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plot_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_plot_line



function edit_line_fig_Callback(hObject, eventdata, handles)
% hObject    handle to edit_line_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_line_fig as text
%        str2double(get(hObject,'String')) returns contents of edit_line_fig as a double


% --- Executes during object creation, after setting all properties.
function edit_line_fig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_line_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
