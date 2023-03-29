function varargout = FigureWithControls( varargin )
% make a figure with user friendly controls
%   Detailed explanation goes here

if nargin && isnumeric(varargin{1})
   h=figure(varargin{1}); 
   set(h,'Units','points','ResizeFcn',@ResizeFig)
   pos_h=get(h,'Position');
   if nargout
       varargout{1}=h;
   end
end

top=100;

if nargin>1
    userdata=varargin{2};
    set(h,'Position',[pos_h(1)+pos_h(3)-510, pos_h(2)+pos_h(4)-top-300, 510, top+300]);
    % frame for all controls
    h_p=uipanel(h,'Units','points','Position',[1,1,510,top]);
    % variable name, to know which variable you are dealing with
    %uicontrol(h_p,'Style','text','String','Var:','Units','points','Position',[5,top-18,22,12],'HorizontalAlignment','left')
    h_varname=uicontrol(h_p,'Style','text','String','','Units','points','Position',[5,top-18,180,12],'HorizontalAlignment','left');
    % figure name, you can change to whatever you like
    uicontrol(h_p,'Style','text','String','figure(save) name:','Units','points','Position',[190,top-18,70,12],'HorizontalAlignment','left')
    h_figurename=uicontrol(h_p,'Style','edit','String','','Units','points','Position',[260,top-18,135,12],'Callback',@SetFigureName,'HorizontalAlignment','left');
    % save
    h_save=uicontrol(h_p,'Style','pushbutton','String','save','Units','points','Position',[5,top-85,50,20],'Callback',{@SaveFigure,h});
    % selection for plot along which direction
    h_uibg_direction=uibuttongroup('Parent',h_p,'Units','points','Position',[5,top-65,120,45],'SelectionChangeFcn',@SelDirection);
    h_alongx=uicontrol(h_uibg_direction,'Style','Radio','String','Along X or // (Y-Z) plane','HandleVisibility','off','Units','points','Position',[5,30,110,12]);
    h_alongy=uicontrol(h_uibg_direction,'Style','Radio','String','Along Y or // (X-Z) plane','HandleVisibility','off','Units','points','Position',[5,16,110,12]);
    h_alongz=uicontrol(h_uibg_direction,'Style','Radio','String','Along Z or // (X-Y) plane','HandleVisibility','off','Units','points','Position',[5,2,110,12]);
    % selection for plot 1D or 2D data
    h_uibg_1D2D=uibuttongroup('Parent',h_p,'Units','points','Position',[130,top-35,60,15]);
    h_1D=uicontrol(h_uibg_1D2D,'Style','Radio','String','1D','HandleVisibility','off','Units','points','Position',[2,1,25,12]);
    h_2D=uicontrol(h_uibg_1D2D,'Style','Radio','String','2D','HandleVisibility','off','Units','points','Position',[30,1,25,12]);
    % selection for plot type
    h_uibg_type=uibuttongroup('Parent',h_p,'Units','points','Position',[130,top-65,125,29]);
    h_2Dmap=uicontrol(h_uibg_type,'Style','Radio','String','2D Map','HandleVisibility','off','Units','points','Position',[2,14,45,12]);
    h_3Dsurf=uicontrol(h_uibg_type,'Style','Radio','String','3D Surf','HandleVisibility','off','Units','points','Position',[2,1,45,12]);
    h_EDC=uicontrol(h_uibg_type,'Style','Radio','String','Stack EDC (Y)','HandleVisibility','off','Units','points','Position',[50,14,70,12]);
    h_MDC=uicontrol(h_uibg_type,'Style','Radio','String','Stack MDC (X)','HandleVisibility','off','Units','points','Position',[50,1,70,12]);
    % selection for plot parameters in index or real scale
    h_uibg_index_real=uibuttongroup('Parent',h_p,'Units','points','Position',[192,top-35,100,15]);
    h_index=uicontrol(h_uibg_index_real,'Style','Radio','String','index','HandleVisibility','off','Units','points','Position',[2,1,35,12]);
    h_real=uicontrol(h_uibg_index_real,'Style','Radio','String','real scale','HandleVisibility','off','Units','points','Position',[40,1,57,12]);
    % plot parameters
    h_p_prmts=uipanel('Parent',h_p,'Units','points','Position',[295,top-65,100,45]);
    uicontrol(h_p_prmts,'Style','text','String','StepSize','Units','points','Position',[2,30,35,12],'HorizontalAlignment','left');
    uicontrol(h_p_prmts,'Style','text','String','X/From','Units','points','Position',[2,16,35,12],'HorizontalAlignment','left');
    uicontrol(h_p_prmts,'Style','text','String','Y/To','Units','points','Position',[2,2,35,12],'HorizontalAlignment','left');
    h_stepsize=uicontrol(h_p_prmts,'Style','edit','String','1','Units','points','Position',[40,30,55,12]);
    h_xfrom=uicontrol(h_p_prmts,'Style','edit','String','','Units','points','Position',[40,16,55,12],'KeyPressFcn',{@RangeChange,h});
    h_yto=uicontrol(h_p_prmts,'Style','edit','String','','Units','points','Position',[40,2,55,12],'KeyPressFcn',{@RangeChange,h});
    % selection for interp
    h_interp=uicontrol(h_p,'Style','Radio','String','Interp','Units','points','Position',[400,top-20,40,12]);
    % stack parameters
    uicontrol(h_p,'Style','text','String','Stack offset','Units','points','Position',[400,top-35,50,12],'HorizontalAlignment','left');
    h_stackoffset=uicontrol(h_p,'Style','edit','String','-1','Units','points','Position',[452,top-35,50,12]);
    uicontrol(h_p,'Style','text','String','Stack one per','Units','points','Position',[400,top-51,50,12],'HorizontalAlignment','left');
    h_stackrate=uicontrol(h_p,'Style','edit','String','1','Units','points','Position',[452,top-60,20,20]);
    uicontrol(h_p,'Style','text','String','curves','Units','points','Position',[473,top-51,28,12],'HorizontalAlignment','left');
    h_combine=uicontrol(h_p,'Style','checkbox','String','Combine?','Units','points','Position',[400,top-63,50,12]);
    % selection for pcolor (fast in Matlab, save as bitmap) or imagesc
    % (slower in Matlab, save as vector graphics)
    h_uibg_viewmode=uibuttongroup('Parent',h_p,'Units','points','Position',[257,top-65,36,29]);
    h_tif=uicontrol(h_uibg_viewmode,'Style','Radio','String','tif','HandleVisibility','off','Units','points','Position',[2,14,30,12]);
    h_eps=uicontrol(h_uibg_viewmode,'Style','Radio','String','eps','HandleVisibility','off','Units','points','Position',[2,1,30,12]);
    
    if isfield(userdata,'VarName')
        set(h_varname,'String',userdata.VarName);
        set(h_figurename,'String',userdata.VarName);
        SetFigureName(h_varname,'')
    end
    
    if isfield(userdata,'Direction')
        switch userdata.Direction
            case 'along x'
                set(h_alongx,'Value',1)
            case 'along y'
                set(h_alongy,'Value',1)
            case 'along z'
                set(h_alongz,'Value',1)
        end
    end
    
    if isfield(userdata,'PlotDim')
        switch userdata.PlotDim
            case '1D'
                set(h_1D,'Value',1)
            case '2D'
                set(h_2D,'Value',1)
        end
    end
    
    if isfield(userdata,'PlotType')
        switch userdata.PlotType
            case '2Dmap'
                set(h_2Dmap,'Value',1)
            case '3Dsurf'
                set(h_3Dsurf,'Value',1)
            case 'EDC'
                set(h_EDC,'Value',1)
            case 'MDC'
                set(h_MDC,'Value',1)
        end
    end
    
    if isfield(userdata,'IndexOrReal')
        switch userdata.IndexOrReal
            case 'index'
                set(h_index,'Value',1)
            case 'real'
                set(h_real,'Value',1)
        end
    end
    
    if isfield(userdata,'StepSize')
        set(h_stepsize,'String',userdata.StepSize);
    end
    
    if isfield(userdata,'XFrom')
        set(h_xfrom,'String',userdata.XFrom);
    end
    
    if isfield(userdata,'YTo')
        set(h_yto,'String',userdata.YTo);
    end
    
    if isfield(userdata,'is_Interp')
        set(h_interp,'Value',userdata.is_Interp)
    end
    
    if isfield(userdata,'StackOffset')
        set(h_stackoffset,'String',userdata.StackOffset);
    end
    
    if isfield(userdata,'StackRate')
        set(h_stackrate,'String',userdata.StackRate);
    end
    
    if isfield(userdata,'is_Combine')
        set(h_combine,'Value',userdata.is_Combine)
    end
    
    pos=get(h,'Position');
    width=pos(3);
    height=pos(4);
    h_axes=axes('Parent',h,'Units','points','OuterPosition',[1,top+1,width,height-top]);
    PlotData(h_axes,userdata)
    
    % store GUI data
    handles.figure1=h;
    handles.controlpanel=h_p;
    handles.varname=h_varname;
    handles.figurename=h_figurename;
    handles.uibg_direction=h_uibg_direction;
    handles.alongx=h_alongx;
    handles.alongy=h_alongy;
    handles.alongz=h_alongz;
    handles.uibg_1D2D=h_uibg_1D2D;
    handles.d_1D=h_1D;
    handles.d_2D=h_2D;
    handles.uibg_type=h_uibg_type;
    handles.d_2Dmap=h_2Dmap;
    handles.d_3Dsurf=h_3Dsurf;
    handles.d_EDC=h_EDC;
    handles.d_MDC=h_MDC;
    handles.uibg_index_real=h_uibg_index_real;
    handles.index=h_index;
    handles.real=h_real;
    handles.p_prmts=h_p_prmts;
    handles.stepsize=h_stepsize;
    handles.xfrom=h_xfrom;
    handles.yto=h_yto;
    handles.interp=h_interp;
    handles.stackoffset=h_stackoffset;
    handles.stackrate=h_stackrate;
    handles.combine=h_combine;
    handles.tif=h_tif;
    handles.eps=h_eps;
    handles.save=h_save;
    handles.axes=h_axes;
    guidata(h,handles);
end

end

function ResizeFig(src, evt)
    pos=get(gcbo,'Position');
    handles=guidata(src);
    if isfield(handles,'axes')
        set(handles.axes,'OuterPosition',[1,101,pos(3),pos(4)-100])
    end
end

function SetFigureName(src,evt)
    s=get(src,'String');
    set(gcf,'Name',s)
end

% uparrow or downarrow keypress
function RangeChange(src,evt,hFig)
handles=guidata(hFig);
x_from=str2double(get(handles.xfrom,'String'));
y_to=str2double(get(handles.yto,'String'));
stepsize=str2double(get(handles.stepsize,'String'));

switch evt.Key
    case 'uparrow'
        set(handles.xfrom,'String',num2str(x_from+stepsize));
        set(handles.yto,'String',num2str(y_to+stepsize));
        guidata(hFig, handles);
        PlotData(handles.axes,RetrieveUserdata(hFig))
    case 'downarrow'
        set(handles.xfrom,'String',num2str(x_from-stepsize));
        set(handles.yto,'String',num2str(y_to-stepsize));
        guidata(hFig, handles);
        PlotData(handles.axes,RetrieveUserdata(hFig))
end
end

function userdata=RetrieveUserdata(hFig)
    handles=guidata(hFig);
    userdata.VarName=get(handles.varname,'String');
    userdata.FigureName=get(handles.figurename,'String');
    if get(handles.alongx,'Value')
        userdata.Direction='along x';
    elseif get(handles.alongy,'Value');
        userdata.Direction='along y';
    elseif get(handles.alongz,'Value');
        userdata.Direction='along z';
    end
    if get(handles.d_1D,'Value')
        userdata.PlotDim='1D';
    elseif get(handles.d_2D,'Value')
        userdata.PlotDim='2D';
    end
    if get(handles.d_2Dmap,'value')
        userdata.PlotType='2Dmap';
    elseif get(handles.d_3Dsurf,'value')
        userdata.PlotType='3Dsurf';
    elseif get(handles.d_EDC,'value')
        userdata.PlotType='EDC';
    elseif get(handles.d_MDC,'value')
        userdata.PlotType='MDC';
    end
    if get(handles.index,'Value')
        userdata.IndexOrReal='index';
    elseif get(handles.real,'Value')
        userdata.IndexOrReal='real';
    end
    if get(handles.tif,'Value')
        userdata.TifOrEps='tif';
    elseif get(handles.eps,'Value')
        userdata.TifOrEps='eps';
    end
    userdata.StepSize=get(handles.stepsize,'String');
    userdata.XFrom=get(handles.xfrom,'String');
    userdata.YTo=get(handles.yto,'String');
    userdata.StackOffset=get(handles.stackoffset,'String');
    userdata.StackRate=get(handles.stackrate,'String');
    userdata.is_Interp=get(handles.interp,'Value');
    userdata.is_Combine=get(handles.combine,'Value');
end

function PlotData(hObject, userdata)
% hObject    handle to axes
% userdata  all required information for plot

%==============================start==================================
%---------------get info-------------------
if ~isfield(userdata,'VarName') || ~isfield(userdata,'XFrom') || ~isfield(userdata,'YTo') || ...
        ~isfield(userdata,'StepSize') || ~isfield(userdata,'Direction') || ~isfield(userdata,'PlotDim') || ...
        ~isfield(userdata,'PlotType') || ~isfield(userdata,'IndexOrReal') || ~isfield(userdata,'is_Interp') || ...
        ~isfield(userdata,'StackOffset') || ~isfield(userdata,'StackRate') || ~isfield(userdata,'is_Combine')
    return
end
datav=evalin('base',userdata.VarName);
if ~isfield(datav,'value')
    data.value=datav;
else data=datav;
end
clear datav;

value_from=str2double(userdata.XFrom);
value_to=str2double(userdata.YTo);

along_xv=0; along_yv=0;  along_zv=0;
switch userdata.Direction
    case 'along x'
        along_xv=1;
    case 'along y'
        along_yv=1;
    case 'along z'
        along_zv=1;
end

d_1v=0; d_2v=0;
switch userdata.PlotDim
    case '1D'
        d_1v=1;
    case '2D'
        d_2v=1;
end

interp_v=userdata.is_Interp;

scale_index=0;  scale_real=0;
switch userdata.IndexOrReal
    case 'index'
        scale_index=1;
    case 'real'
        scale_real=1;
end

plot_2d=0;
plot_3d=0;
plot_stacky=0;
plot_stackx=0;
switch userdata.PlotType
    case '2Dmap'
        plot_2d=1;
    case '3Dsurf'
        plot_3d=1;
    case 'EDC'
        plot_stacky=1;
    case 'MDC'
        plot_stackx=1;
end

if plot_stacky || plot_stackx
    combinev=userdata.is_Combine;
    %    lc=get(handles.line_color,'Value');
    stack_offsetv=str2double(userdata.StackOffset);
end
%----------------end of geting info-----------------------


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
            
            plot(hObject,plot_data.x,plot_data.value);
        end
        if along_yv==1
            plot_data.value=reshape(data.value(index_x,:,index_y),1,size(data.value(index_x,:,index_y),2));
            if isfield(data,'y');
                plot_data.x=data.y;
            else
                plot_data.x=(1:size(plot_data.value,2));
            end
            
            plot(hObject,plot_data.x,plot_data.value);
        end
        if along_zv==1
            plot_data.value=reshape(data.value(index_x,index_y,:),1,size(data.value(index_x,index_y,:),3));
            if isfield(data,'z');
                plot_data.x=data.z;
            else
                plot_data.x=(1:size(plot_data.value,2));
            end
            
            plot(hObject,plot_data.x,plot_data.value);
        end
    else
        if along_xv==1
            plot_data.value=data.value(:,index_y);
            if isfield(data,'x');
                plot_data.x=data.x;
            else
                plot_data.x=(1:size(plot_data.value,2));
            end
            
            plot(hObject,plot_data.x,plot_data.value);
        end
        if along_yv==1
            plot_data.value=data.value(index_x,:);
            if isfield(data,'y');
                plot_data.x=data.y;
            else
                plot_data.x=(1:size(plot_data.value,2));
            end
            
            plot(hObject,plot_data.x,plot_data.value);
        end
    end
    
    return;
end

%------------------------------2-D plot------------------------------

if d_2v==1
    
    %------------------------get the co-ordinate of the line-------------
    if scale_index==1
        index_x=value_from;
        index_y=value_to;
    else %-------real scale------------
        if size(size(data.value),2)==3
            
            if ~isfield(data,'x') || ~isfield(data,'y') || ~isfield(data,'z')
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
            
            if ~isfield(data,'x') || ~isfield(data,'y')
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
    if size(size(data.value),2)==3
        if along_xv==1 % -------------along x-direction----------------------------
            plot_data.value(:,:)=sum(data.value(index_x:index_y,:,:),1);
            if isfield(data,'y') && isfield(data,'z') %-----if there is real-scale info, use it, otherwise use index
                plot_data.x=data.y;
                plot_data.y=data.z;
            else
                plot_data.x=(1:size(plot_data.value,1));
                plot_data.y=(1:size(plot_data.value,2));
            end
        end
        
        if along_yv==1 % -------------along y-direction----------------------------
            plot_data.value(:,:)=sum(data.value(:,index_x:index_y,:),2);
            if isfield(data,'x') && isfield(data,'z') %-----if there is real-scale info, use it, otherwise use index
                plot_data.x=data.x;
                plot_data.y=data.z;
            else
                plot_data.x=(1:size(plot_data.value,1));
                plot_data.y=(1:size(plot_data.value,2));
            end
        end
        
        if along_zv==1 % -------------along z-direction----------------------------
            plot_data.value(:,:)=sum(data.value(:,:,index_x:index_y),3);
            if isfield(data,'x') && isfield(data,'y') %-----if there is real-scale info, use it, otherwise use index
                plot_data.x=data.x;
                plot_data.y=data.y;
            else
                plot_data.x=(1:size(plot_data.value,1));
                plot_data.y=(1:size(plot_data.value,2));
            end
        end
    elseif size(size(data.value),2)==2 %--------------if source is 2-D, then no need to specify direction
        plot_data.value=data.value;
        if isfield(data,'x') && isfield(data,'y') %-----if there is real-scale info, use it, otherwise use index
            plot_data.x=data.x;
            plot_data.y=data.y;
        else
            plot_data.x=(1:size(plot_data.value,1));
            plot_data.y=(1:size(plot_data.value,2));
        end
    end
    
    
    %---------start plotting-------------
    if plot_2d==1
        switch userdata.TifOrEps
            case 'tif'
                %--pcolor is not good for saving as eps vector graphics
                pcolor(hObject,plot_data.x,plot_data.y,plot_data.value');
                if along_xv==1
                    axis(hObject,'normal')
                end
                if along_yv==1
                    axis(hObject,'normal')
                end
                if along_zv==1
                    axis(hObject,'equal')
                end
            case 'eps'
                %--use imagesc instead. x, y may be non-equidistant.
                nx=length(plot_data.x);
                ny=length(plot_data.y);
                plot_data_xsort=sort(plot_data.x);
                plot_data_ysort=sort(plot_data.y);
                % obtain the minimum spaces
                dxv=plot_data_xsort(2:nx)-plot_data_xsort(1:nx-1);
                dyv=plot_data_ysort(2:ny)-plot_data_ysort(1:ny-1);
                dx_min=min(dxv);
                dx_max=max(dxv);
                dy_min=min(dyv);
                dy_max=max(dyv);
                %determine the final grid
                plot_data_x1=plot_data_xsort(1);
                plot_data_y1=plot_data_ysort(1);
                if (dx_max-dx_min)/dx_min>0.1  % deviation more than +-5%
                    dx=dx_min;
                    plot_data_x2=plot_data_xsort(1)+ceil((plot_data_xsort(nx)-plot_data_xsort(1))/dx)*dx;
                else
                    dx=(plot_data_xsort(nx)-plot_data_xsort(1))/(nx-1);
                    plot_data_x2=plot_data_xsort(nx);
                end
                if (dy_max-dy_min)/dy_min>0.1  % deviation more than 5%
                    dy=dy_min;
                    plot_data_y2=plot_data_ysort(1)+ceil((plot_data_ysort(ny)-plot_data_ysort(1))/dy)*dy;
                else
                    dy=(plot_data_ysort(ny)-plot_data_ysort(1))/(ny-1);
                    plot_data_y2=plot_data_ysort(ny);
                end
                % newplot is for low level plotting, hold won't work
                axes(hObject);
                newplot
                if (dx_max-dx_min)/dx_min>0.1 || (dy_max-dy_min)/dy_min>0.1
                    % in case at one dimension is non-equidistant
                    [qx,qy]=meshgrid(plot_data_x1:dx:plot_data_x2,plot_data_y1:dy:plot_data_y2);
                    % interpolate from non-uniform spaced data to uniform spaced image
                    X=repmat(plot_data.x',ny,1);
                    Y=reshape(repmat(plot_data.y,nx,1),nx*ny,1);
                    V=reshape(plot_data.value,nx*ny,1);
                    F=TriScatteredInterp(X,Y,V);
                    qz=F(qx,qy);
                    imagesc('Parent',hObject,'XData',[plot_data_x1,plot_data_x2],'YData',[plot_data_y1,plot_data_y2],'CData',qz);
                else
                    % in case both dimensions are equidistant
                    imagesc('Parent',hObject,'XData',[plot_data.x(1),plot_data.x(nx)],'YData',[plot_data.y(1),plot_data.y(ny)],'CData',plot_data.value')
                end
                % set axis style
                axis(hObject,'tight')
                if along_xv==1
                    axis(hObject,'normal')
                end
                if along_yv==1
                    axis(hObject,'normal')
                end
                if along_zv==1
                    axis(hObject,'equal')
                end
                drawnow
        end
        
    elseif plot_3d==1
        surf(hObject,plot_data.x,plot_data.y,plot_data.value');
    else
        lc=1;
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
        
        st_sz=str2double(userdata.StackRate);
        if plot_stacky==1
            for i=1:st_sz:size(plot_data.value,1)
                %plot(plot_data.y,plot_data.value(i,:)+(i-1)*stack_offsetv/st_sz,lcc);
                    if combinev==1 && (i+st_sz-1)<=size(plot_data.value,1)
                        plot(hObject,plot_data.y,sum(plot_data.value(i:i+st_sz-1,:),1)/st_sz+(i-1)*stack_offsetv/st_sz,lcc);
                    elseif combinev==0
                        plot(hObject,plot_data.y,plot_data.value(i,:)+(i-1)*stack_offsetv/st_sz,lcc);
                    end
                hold on;
            end
        end
            
        if plot_stackx==1
            for i=1:st_sz:size(plot_data.value,2)
                %plot(plot_data.x,plot_data.value(:,i)+(i-1)*stack_offsetv/st_sz,lcc);
                    if combinev==1 && (i+st_sz-1)<=size(plot_data.value,2)
                        plot(hObject,plot_data.x,sum(plot_data.value(:,i:i+st_sz-1),2)/st_sz+(i-1)*stack_offsetv/st_sz,lcc);
                    elseif combinev==0
                        plot(hObject,plot_data.x,plot_data.value(:,i)+(i-1)*stack_offsetv/st_sz,lcc);
                    end
                hold on;
            end
        end
        hold off;
           
    end
        
    if interp_v==1
        shading interp;
    end
    
   return;
end
end


function SaveFigure(src,evt,hFig)
userdata=RetrieveUserdata(hFig);
filename=userdata.FigureName;
handles=guidata(hFig);
fpos=get(hFig,'Position');
outerpos=get(handles.axes,'OuterPosition');
pos=get(handles.axes,'Position');
h=figure('Units','points','Position',[fpos(1)+outerpos(1),fpos(2)+outerpos(2),outerpos(3),outerpos(4)]);
h_axes=axes('Parent',h,'Units','points','Position',[pos(1)-outerpos(1)+1,pos(2)-outerpos(2)+1,pos(3),pos(4)]);
PlotData(h_axes, userdata)
switch userdata.TifOrEps
    case 'tif'
        print(h,'-dtiff', filename,'-noui','-opengl','-r300')
    case 'eps'
        print(h,'-depsc',filename,'-noui','-painters')
end
close(h)
end