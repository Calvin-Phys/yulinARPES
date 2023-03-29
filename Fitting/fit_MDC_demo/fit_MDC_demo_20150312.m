function fit_MDC_demo_20150312(varargin)
% Bug report: han.peng@physics.ox.ac.uk
% Author: Han PENG
%



%% Data Structure:
% Peak
% Peak is a field of data.
% Peak.x{i}(k)
% Peak.y{i}(k)
% Peak.h{i}(k)
% Peak.w{i}(k)
% Peak.y_ind{i}
% Peak.x_f{i}(j=length(data.y))
% Peak.y_f{i}(j)
% Peak.h_f{i}(j)
% Peak.w_f{i}(j)
% Peak.b_f(j)
% Peak.AreaFlag{i}(j)
% Peak.Select{i}(j)
%%%%%%%%%
% UserPeak
% UserPeak is a structure array, with the same length of data.y
% UserPeak(handles.current_y_index).Peak1.x 
% UserPeak(handles.current_y_index).Peak1.y
% UserPeak(handles.current_y_index).Peak1.h
% UserPeak(handles.current_y_index).Peak1.w
% UserPeak(handles.current_y_index).Peak1.b
% UserPeak(handles.current_y_index).Peak1.Select
% UserPeak(handles.current_y_index).Peak1.Ax1Point, 
% UserPeak(handles.current_y_index).Peak1.Ax2Point, Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.Text,     Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.BaseLine, Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.WidthLine,Tag: Ax2Temp
% LorentzPlot,Tag: Ax2TempPlot
% SumPlot,    Tag: Ax2TempPlot


handles.mObject = figure(...
    'Name','fit_MDC_demo',...
    'NumberTitle','off',...
    'MenuBar','none',...
    'IntegerHandle','off',...
    'HandleVisibility','on',...
    'Tag','fit_MDC_demo');

h=findobj('tag','DataBrowser');
if isempty(h)
    warndlg('Please Open Data Browser');
    Position = [10,10,10,10];
else
    Position=getpixelposition(h(1));
end

% ListBoxHBox
  % InfoVBox
    %ButtonPanel1
% SettingPanel
% MDC Panel Uicontextmenu 
% Set test data
% Ending


%% Frame
ScrSiz=get(0,'screensize');
set(handles.mObject,'Position',[Position(1)+Position(3)+6,ScrSiz(4)-730,700,500]);
VBoxHome = uiextras.VBox('Parent',handles.mObject);
HBox1 = uiextras.HBox('Parent',VBoxHome);
HBox2 = uiextras.HBox('Parent',VBoxHome);
StateStringPanel = uiextras.Panel('Parent',VBoxHome,...,
    'BackgroundColor','w','Padding',0);
set(VBoxHome,'Sizes',[150,-1,18]);
ListBoxHBox = uiextras.HBox('Parent',HBox1);
SettingPanel = uiextras.Panel('Parent',HBox1,'Title','Fit Settings');
set(HBox1,'Sizes',[350 350]);
handles.FigPanel1 = uiextras.Panel('Parent',HBox2,'Padding',2,...
    'Title','Image Panel');
FigVBox1 = uiextras.VBox('Parent',handles.FigPanel1);
handles.FigPanel2 = uiextras.Panel('Parent',HBox2,'Padding',2,...
    'Title','MDC Panel');
FigVBox2 = uiextras.VBox('Parent',handles.FigPanel2);
set(HBox2,'Sizes',[-1,-1]);
handles.ax1 = axes('Parent',FigVBox1);
handles.ax2 = axes('Parent',FigVBox2);



%% ListBoxHBox
% InfoVBox
InfoVBox = uiextras.VBox('Parent',ListBoxHBox);
  % VarNamePanel
VarNamePanel=uiextras.Panel('Parent',InfoVBox,'Title','Target Variable',...
    'Padding',3);
handles.VarNameText = uicontrol('Parent',VarNamePanel,...
    'Style','Text','String','test_data_CdAs3_kz','Background','w');
  % Refresh Pushbutton
handles.Refresh=uicontrol('Parent',InfoVBox,'Style','Pushbutton',...
    'String','Refresh',...
    'Callback',@Refresh_callback);
  % ButtonPanel1
ButtonPanel1 = uiextras.Panel('Parent',InfoVBox,'Padding',2,...
    'Title','Peaks');
ButtonHBox1 = uiextras.HBox('Parent',ButtonPanel1);
handles.AddPeak=uicontrol('Parent',ButtonHBox1,...
    'Style','PushButton','String','<html>Add<br>Peak',...
    'Callback',@AddPeak_callback,...
    'UserData',0);
handles.DeletePeak=uicontrol('Parent',ButtonHBox1,...
    'Style','PushButton','String','<html>Delete<br>Peak',...
    'Callback',@DeletePeak_callback);
handles.SelectArea=uicontrol('Parent',ButtonHBox1,...
    'Style','PushButton','String','<html>Select<br>Area',...
    'Callback',@SelectArea_callback,'UserData',0);
set(ButtonHBox1,'Sizes',[-1,-1,-1]);

set(InfoVBox,'Sizes',[-1,40,55]);

% ListBoxPanel
ListBoxMenu=uicontextmenu;
uimenu('Parent',ListBoxMenu,'Label','Export Peak',...
    'Callback',@ListBoxMenu_callback);

ListBoxPanel = uiextras.Panel('Parent',ListBoxHBox,'Title','Peak List');
handles.ListBox = uicontrol('Parent',ListBoxPanel,...
    'Style','ListBox',...
    'Callback',@ListBox_callback,...
    'BackgroundColor','w',...
    'String',{'Show All Peaks','Hide All Peaks','Peak1'},...
    'UiContextMenu',ListBoxMenu);

set(ListBoxHBox,'Sizes',[140,-1]);



%% SettingPanel
SettingHBox = uiextras.HBox('Parent',SettingPanel);
cnames = {'Peak','PosX','PosY','Width','Heigt','Fix'};
handles.SettingTable=uitable('Parent',SettingHBox,...
    'ColumnName',cnames,'RowName',[],...
    'ColumnWidth',{49},...
    'ColumnEditable',[false false false false true],...
    'RowStriping','off',...
    'CellEditCallback',@SettingTable_edit_callback,...
    'CellSelectionCallback',@SettingTable_select_callback,...
    'Data',{0 0 0 0 0 false},...
    'UserData',[]);
SettingVBox=uiextras.VBox('Parent',SettingHBox);
uicontrol('Parent',SettingVBox,...
    'Style','PushButton','String','<html>Start<br>Fitting',...
    'Callback',@fit_callback);
% uicontrol('Parent',SettingHBox,...
%     'Style','PushButton','String','<html>Update<br>MDC Panel',...
%     'Callback',@update_MDC_callback);
uicontrol('Parent',SettingVBox,...
    'Style','PushButton','String','<html>Save<br>Peaks',...
    'Callback',@save_peaks);
set(SettingVBox,'Sizes',[-2,-1]);
set(SettingHBox,'Sizes',[-1,50]);

%% Uicontextmenu 
% EDC Panel Menu
handles.Fig1PointsContextMenu=uicontextmenu;
uimenu(handles.Fig1PointsContextMenu,'Label','Go to Point''s MDC',...
    'Callback',@GoToPointMDC_callback);
uimenu(handles.Fig1PointsContextMenu,'Label','Delete Point',...
    'Callback',@DeletePoint_callback);

handles.MDCPanelMenu=uicontextmenu;
AddAPeakPoint=uimenu(handles.MDCPanelMenu,'Label','Add New Point');
DeletePeakPoint=uimenu(handles.MDCPanelMenu,'Label','Delete Peak Point');
uimenu('parent',AddAPeakPoint,'Label',['to ','Peak1'],...
    'Callback',{@AddAPeakPoint_callback,'Peak1'});
uimenu('parent',DeletePeakPoint,'Label',['to ','Peak1'],...
    'Callback',{@DeletePeakPoint_callback,'Peak1'});


set(handles.ax2,'UIContextmenu',handles.MDCPanelMenu);

%% Set test data
data=generate_testdata;
set(handles.mObject,'UserData',data);
%% Save Data Backup
set(handles.Refresh,'UserData',data);
%
handles.Fig1 = pcolor(handles.ax1,data.x,data.y,data.value');
shading(handles.ax1,'interp');
colormap(handles.ax1,'gray');

[y0,y_index]=min(abs(data.y(:)));
handles.current_y_index=y_index;
handles.current_y_position=y0;
y=data.value(:,y_index);

handles.BlueLine=line([min(data.x),max(data.x)],[y0,y0],...
    'Color','b','Parent',handles.ax1,...
    'LineWidth',2,'ButtonDownFcn',@DragBlueLine);

handles.MDCScatter=scatter(handles.ax2,data.x,y,'b','Marker','.');
%
%% Initialize UserData
InitializeUserData(handles);

%% Ending
handles.StateString = uicontrol('Parent',StateStringPanel,...
    'Style','text','Background','w',...
    'String','Ready. Drag the blue line to change MDC position.',...
    'HorizontalAlignment','Left');
guidata(handles.mObject,handles);

function ListBoxMenu_callback(handle,~)
% Peak
% Peak is a field of data.
% Peak.x{i}(k)
% Peak.y{i}(k)
% Peak.h{i}(k)
% Peak.w{i}(k)
% Peak.y_ind{i}
% Peak.x_f{i}(j=length(data.y))
% Peak.y_f{i}(j)
% Peak.h_f{i}(j)
% Peak.w_f{i}(j)
% Peak.b_f(j)
% Peak.AreaFlag{i}(j)
% Peak.Select{i}(j)

handles = guidata(handle);
data=get(handles.mObject,'UserData');
if ~isfield(data,'FitPeak')
    errordlg('You should fit a peak first.');
    return;
end
Peak=data.FitPeak;
PeakNames=get(handles.ListBox,'String');
Num=get(handles.ListBox,'Value');
PeakName=PeakNames{Num};
if strcmp(PeakName,'Show All Peaks')||strcmp(PeakName,'Hide All Peaks')
    return;
end
i=str2double(PeakName(end));
AreaFlag=Peak.AreaFlag{i};
PeakExport.x=Peak.x_f{i}(AreaFlag==1);
PeakExport.y=Peak.y_f{i}(AreaFlag==1);
PeakExport.h=Peak.h_f{i}(AreaFlag==1);
PeakExport.w=Peak.w_f{i}(AreaFlag==1);
PeakExport.b=Peak.b_f(AreaFlag==1);
VarNameText=get(handles.VarNameText,'String');
ExportName=[VarNameText,'_',PeakName];
assignin('base',ExportName,PeakExport);
assignin('base',[ExportName,'_x'],PeakExport.x);
assignin('base',[ExportName,'_y'],PeakExport.y);
function Refresh_callback(handle,~)
refresh_panel(handle);

function refresh_panel(handle)    
handles=guidata(handle);
flag=questdlg('Would you like to load new data without saving current data?',...
    'Loading new data',...
    'Yes','Cancel','Save&Load','Yes');

switch flag
    case 'Save&Load'
        assignin('base',get(handles.VarNameText,'String'),get(handles.mObject,'UserData'));
    case 'Cancel'
        return;
end
h1=findobj('Tag','DataBrowser');
if isempty(h1)
    warndlg('Please Open Data Browser');
end
h1=guidata(h1(1));
handles.VarName=h1.VarNames{1};
clear h1;
data=evalin('base',handles.VarName);
if (isfield(data,'value') || isprop(data,'value')) && length(size(data.value))==2
    set(handles.VarNameText,'String',handles.VarName);
    set(handles.mObject,'UserData',data);
    %% Save Data Backup
    set(handles.Refresh,'UserData',data);
    %
else
    warndlg('Data must be 2D structure with field ''value''');
    return
end
hold off
pcolor(handles.ax1,data.x,data.y,data.value');
shading(handles.ax1,'interp');
ymin=min(data.y);
ylen=max(data.y)-ymin;
y0=ymin+2/3*ylen;
[~,handles.current_y_index]=min(abs(data.y(:)-y0));
handles.current_y_position=data.y(handles.current_y_index);
handles.BlueLine=line([min(data.x),max(data.x)],...
    [handles.current_y_position,handles.current_y_position],...
    'Color','b','Parent',handles.ax1,...
    'LineWidth',2,'ButtonDownFcn',@DragBlueLine);
%% need to refresh all
% need to refresh all
delete(findobj(handles.ax2,'-regexp','Tag','.*Temp.*'));
delete(findobj(handles.ax1,'-regexp','Tag','.*Temp.*'));
InitializeUserData(handles);

%% Save changes
guidata(handles.mObject,handles);


function InitializeUserData(handles)
% This function will delete exsisted UserData and then initialize it.
data=get(handles.mObject,'UserData');
ly=length(data.y);
temp=cell(ly,1);
UserPeak=struct('Peak1',temp);
[UserPeak(:).b]=deal(0);
% UserPeak=rmfield(UserPeak,'temp');
set(handles.SettingTable,'UserData',UserPeak);


function ListBox_callback(handle,~)
% function update_MDC_callback(handle,evt)
handles=guidata(handle);
UpdatePeaksPlot(handles);

function SettingTable_edit_callback(~,evt)
disp(evt);
function SettingTable_select_callback(~,evt)
disp(evt);

function fit_callback(handle,~)
%% Peak:
% Peak.x{i}(k)
% Peak.y{i}(k)
% Peak.h{i}(k)
% Peak.w{i}(k)
% Peak.y_ind{i}
% Peak.x_f{i}(j=length(data.y))
% Peak.y_f{i}(j)
% Peak.h_f{i}(j)
% Peak.w_f{i}(j)
% Peak.b_f(j)
% Peak.AreaFlag{i}(j)
% Peak.Select{i}(j)
%% Read Data
handles=guidata(handle);
%% Select Area
% Position=get(handles.SelectAreaRect,'Position');
% xlim_1=Position(1);
% xlim_2=xlim_1+Position(3);
%% Select Area Done
data=get(handles.mObject,'UserData');
UserPeak=get(handles.SettingTable,'UserData');
names=fieldnames(UserPeak);
s=size(names);
delete(findobj(handles.ax1,'-regexp','Tag','.*Ax1FitPlot.*'));
if s(1)~=1
    names=names';
end
names_joint=strjoin(names);
names=regexp(names_joint,'Peak[0-9]','match');


for i=1:length(names)
    %% Identify Peak Area
    % select_flag(i,j) represents whether data.y(j) is in the area of Peaki
    %  
    k=0;
    name=names{i};
    color_list={'r','g','b','y','m','c','r','g','b','y'};
    c=color_list{str2double(name(end))};
    Peak.x_f{i}=zeros(1,length(data.y));
    Peak.y_f{i}=data.y;
    Peak.h_f{i}=zeros(1,length(data.y));
    Peak.w_f{i}=zeros(1,length(data.y));
    Peak.b_f=zeros(1,length(data.y));
    Peak.AreaFlag{i}=zeros(1,length(data.y));
    for j=1:length(UserPeak)
        if isfield(UserPeak(j).(name),'Select')          
            Peak.AreaFlag{i}(j)=UserPeak(j).(name).Select;
            if UserPeak(j).(name).Select
                k=k+1;
                Peak.x{i}(k)=UserPeak(j).(name).x;
                Peak.h{i}(k)=UserPeak(j).(name).h;
                Peak.y{i}(k)=data.y(j);
                Peak.w{i}(k)=UserPeak(j).(name).w;
                Peak.w_f{i}(j)=UserPeak(j).(name).w;
                Peak.b_f(j)=UserPeak(j).b;
                Peak.y_ind{i}=j;
            end
        else
            Peak.AreaFlag{i}(j)=false;
        end
    end
    j1=find(Peak.AreaFlag{i}(:),1,'first');
    j2=find(Peak.AreaFlag{i}(:),1,'last');
    Peak.Select{i}=Peak.AreaFlag{i};
    Peak.AreaFlag{i}(1,j1:j2)=true;
    
    %% Get Initial Values
    % Get Peak Positions
    Peak.x_f{i}(Peak.AreaFlag{i}(:)==1)=interp1(Peak.y{i},Peak.x{i},...
        data.y(Peak.AreaFlag{i}(:)==1),'spline');
    Peak.h_f{i}(Peak.AreaFlag{i}(:)==1)=interp1(Peak.y{i},Peak.h{i},...
        data.y(Peak.AreaFlag{i}(:)==1),'spline');
    Peak.w_f{i}(Peak.AreaFlag{i}(:)==1)=interp1(Peak.y{i},Peak.w{i},...
        data.y(Peak.AreaFlag{i}(:)==1),'spline');
    hold(handles.ax1,'on');
    height_list=Peak.h_f{i}(Peak.AreaFlag{i}(:)==1);
    sizes_list=(abs(height_list)/max(max(data.value)))*36;
    scatter(handles.ax1,Peak.x_f{i}(Peak.AreaFlag{i}(:)==1),...
        data.y(Peak.AreaFlag{i}(:)==1),sizes_list,c,'Marker','o',...
        'Tag',['Ax1FitPlot',name]);
    hold(handles.ax1,'off');
end


%% Fitting
% Selecting Area need to be added
for j=1:length(data.y)
    % Get the Peaks to be fitted
    k=0;
    x0=[];
    x_lb=[];
    x_ub=[];
    i_s=[];
    h_max=max(data.value(:,j));
    for i=1:length(Peak.x_f)        
        if Peak.AreaFlag{i}(j)==1
            k=k+1;
            i_s(k)=i;  %#ok<AGROW>
        end
    end
    if ~isempty(i_s)
        for i=i_s
%             if ~Peak.Select{i}(j)
%                 Peak.w_f{i}(j)=Peak.w_f{i}(j-1);
%             end
            x0=[x0,Peak.x_f{i}(j),Peak.h_f{i}(j),Peak.w_f{i}(j)]; %#ok<AGROW>
            x_lb=[x_lb,Peak.x_f{i}(j)-Peak.w_f{i}(j),Peak.h_f{i}(j)/2,Peak.w_f{i}(j)/3]; %#ok<AGROW>
            x_ub=[x_ub,Peak.x_f{i}(j)+Peak.w_f{i}(j),h_max,5/3*Peak.w_f{i}(j)]; %#ok<AGROW>
        end
        
        x0=[x0,Peak.b_f(j)]; %#ok<AGROW>
%         x_lb=[x_lb,0]; %#ok<AGROW>
%         x_ub=[x_ub,abs(Peak.b_f(j))*2+abs(max(data.value(:,j)))/2]; %#ok<AGROW>
        %     myfun=@(x,y)LorentzFitFcn(x,y,x0);
        %         [var_f,resnorm]=lsqnonlin(@LorentzFitFcn,x0,x_lb,x_ub,[],data.x,data.value(:,j)');
        datav=data.value(:,j)';
        datav_mask=~isnan(datav);        
%         datax_mask=(data.x>xlim_1).*(data.x<xlim_2);
%         mask=datax_mask.*datav_mask;
        mask=datav_mask;
        datav=datav(mask==1);
        datax=data.x(mask==1);        
        [var_f,~]=fminsearch(@LorentzFitFcn,x0,[],datax,datav);
        k=0;
        for i=i_s
            k=k+1;
            Peak.x_f{i}(j)=var_f(k);
            k=k+1;
            Peak.h_f{i}(j)=var_f(k);
            k=k+1;
            Peak.w_f{i}(j)=var_f(k);
        end
        k=k+1;
        Peak.b(j)=var_f(k);
    end
    %% Update Panel 
    if j<length(data.y)
        handles.current_y_index=j;
        handles.current_y_position=data.y(j);
        set(handles.BlueLine,'YData',[data.y(j),data.y(j)]);
        UpdateFittingPlot(handles,Peak,names);
        UpdateMDC(handles);
        UpdateMDCPeakElements(handles,j);
        UpdateMDCPeakPlot(handles,j);
        UpdateMDCPeakPlot_fit(handles,j);
    end
end
j=floor(2/3*length(data.y));
handles.current_y_index=j;
handles.current_y_position=data.y(j);
set(handles.BlueLine,'YData',[data.y(j),data.y(j)]);
UpdateFittingPlot(handles,Peak,names);
UpdateMDC(handles);
UpdateMDCPeakElements(handles,j);
UpdateMDCPeakPlot(handles,j);
UpdateMDCPeakPlot_fit(handles,j);
data.FitPeak=Peak;
set(handles.mObject,'UserData',data);

function UpdateFittingPlot(handles,Peak,names)
data=get(handles.mObject,'UserData');
for i=1:length(names)
    h=findobj(handles.ax1,'Tag',['Ax1FitPlot',names{i}]);
    height_list=Peak.h_f{i}(Peak.AreaFlag{i}(:)==1);
    sizes_list=...
        (abs(height_list)/...
        max(max(data.value)))*36;
    x_list=Peak.x_f{i}(Peak.AreaFlag{i}(:)==1);
    set(h,'XData',x_list,'SizeData',sizes_list);
    drawnow;
end

function diff=LorentzFitFcn(x0,x,y)
len=length(x0)-1;
b=x0(end);
par=reshape(x0(1:end-1),[3,len/3]);
y_data=0;
for i=1:len/3
    y_data=y_data+LorentzPlot(x,par(1,i),par(2,i),par(3,i));
end
diff=y_data+b-y;
diff=sum(diff.^2);

function save_peaks(handle,~)
handles=guidata(handle);
assignin('base',get(handles.VarNameText,'String'),...
    get(handles.mObject,'UserData'));

function AddPeak_callback(handle,~)
handles=guidata(handle);
UserPeak=get(handles.SettingTable,'UserData');
names=fieldnames(UserPeak);
s=size(names);
if s(1)~=1
    names=names';
end
names_joint=strjoin(names);
names=regexp(names_joint,'Peak[0-9]','match');
% if isempty(names)
%     [UserPeak(:).peak1]=deal([]);
%     names={'Peak1'};
% end
if length(names)==6
    errordlg('Maximum Peak Number is 6.');
    return;
else
    names=regexp(names_joint,'Peak[0-9]','match');
    if isempty(names)
        i0=1;
    else
        L=length(names);
        num=zeros(1,L);
        for i=1:length(names)
            num(i)=str2double(names{i}(end));
        end
        for i=1:9
            if ~(num==i)
                i0=i;
                break;
            end
        end
    end
    name=['Peak',num2str(i0)];
    [UserPeak(:).(name)]=deal([]); % dynamic structure field
end
set(handles.SettingTable,'UserData',UserPeak);
names=fieldnames(UserPeak);
s=size(names);
if s(1)~=1
    names=names';
end
names_joint=strjoin(names);
names=regexp(names_joint,'Peak[0-9]','match');
names_pre={'Show All Peaks';'Hide All Peaks'};
names_new={names_pre{:},names{:}}; %#ok<CCAT>
set(handles.ListBox,'String',names_new);
if isfield(handles,'MDCPanelMenu')
    h=findobj(handles.MDCPanelMenu);
    delete(h);
end
handles.MDCPanelMenu=uicontextmenu;

AddAPeakPoint=uimenu(handles.MDCPanelMenu,'Label','Add New Point');
DeletePeakPoint=uimenu(handles.MDCPanelMenu,'Label','Delete Peak Point');
for i = 1:length(names)
    uimenu('parent',AddAPeakPoint,'Label',['to ',names{i}],...
        'Callback',{@AddAPeakPoint_callback,names{i}});
    uimenu('parent',DeletePeakPoint,'Label',['to ',names{i}],...
        'Callback',{@DeletePeakPoint_callback,names{i}});
end

set(handles.ax2,'UIContextmenu',handles.MDCPanelMenu);
guidata(handles.mObject,handles);

function DeletePeak_callback(handle,~)
%% Get Information
handles=guidata(handle);
UserPeak=get(handles.SettingTable,'UserData');
SelectPeak = get(handles.ListBox,'String');
ind = get(handles.ListBox,'Value');
if isempty(UserPeak)||ind<=3
    return;
end

%% Remove Selected Peak Data
UserPeak=rmfield(UserPeak,SelectPeak{ind});
set(handles.SettingTable,'UserData',UserPeak);
UpdateMDCPeakElements(handles,handles.current_y_index);
UpdateMDCPeakPlot(handles,handles.current_y_index);
delete(findobj(handles.ax1,'-regexp','Tag',['.*',SelectPeak{ind},'.*']));
%% Set ListBox
names=fieldnames(UserPeak);
s=size(names);
if s(1)~=1
    names=names';
end
names_joint=strjoin(names);
names=regexp(names_joint,'Peak[0-9]','match');
% Codes above are designed to prevent UserData contain fields
% other than '.PeakN'
names_pre={'Show All Peaks';'Hide All Peaks'};
names_new={names_pre{:},names{:}}; %#ok<CCAT>
set(handles.ListBox,'String',names_new);
set(handles.ListBox,'Value',ind-1);

%% Refresh MDC Panel Menu
if isfield(handles,'MDCPanelMenu')
    h=findobj(handles.MDCPanelMenu);
    delete(h);
end
handles.MDCPanelMenu=uicontextmenu;
AddAPeakPoint=uimenu(handles.MDCPanelMenu,'Label','Add New Point');
DeletePeakPoint=uimenu(handles.MDCPanelMenu,'Label','Delete Peak Point');
for i = 1:length(names)
    uimenu('parent',AddAPeakPoint,'Label',['to ',names{i}],...
        'Callback',{@AddAPeakPoint_callback,names{i}});
    uimenu('parent',DeletePeakPoint,'Label',[names{i}],...
        'Callback',{@DeletePeakPoint_callback,names{i}});
end
set(handles.ax2,'UIContextmenu',handles.MDCPanelMenu);
guidata(handles.mObject,handles);

%% Update Peaks Plot
UpdatePeaksPlot(handles);


function SelectArea_callback(handle,~)
handles = guidata(handle);
flag=get(handles.SelectArea,'UserData');

if flag==0
    flag=1;
    set(handles.SelectArea,'UserData',flag);
    set(handles.SelectArea,'String','Done');
    h1=findobj(handles.ax1,'Tag','TempSelectArea');
    if ~isempty(h1)        
        Position = get(h1,'Position');
        delete(h1);
        handles.SelectAreaRect=imrect(handles.ax1,Position); 
    else
        handles.SelectAreaRect=imrect(handles.ax1);
    end    
    set(handles.StateString,...
        'String',...
        ['Busy. Set the rectangle position properly and press ''DONE''',...
        'before doing anything']);
    guidata(handles.mObject,handles)
else
    flag=0;
    set(handles.SelectArea,'UserData',flag);
    set(handles.SelectArea,'String','<html>Select<br>Area');

    Position = getPosition(handles.SelectAreaRect);
    delete(handles.SelectAreaRect);
    handles=rmfield(handles,'SelectAreaRect');
    rectangle('Position',Position,...
        'Parent',handles.ax1,...
        'EdgeColor','g',...
        'LineStyle','--',...
        'Tag','TempSelectArea'); 
    guidata(handles.mObject,handles);    
    set(handles.StateString,...
        'String','Ready. Drag the blue line to change MDC position.');
    %% Set Data Area
    data=get(handles.Refresh,'UserData');
    xlim_1=Position(1);
    xlim_2=xlim_1+Position(3);
    datax_mask=(data.x>xlim_1).*(data.x<xlim_2);
    x_new=data.x(datax_mask==1);
    %     datav_mask=repmat(datax_mask,length(data.y),1);
    i1=find(datax_mask,1,'first');
    i2=find(datax_mask,1,'last');
    v_new=data.value(i1:i2,:);
    data.x=x_new;
    data.value=v_new;    
    set(handles.mObject,'UserData',data);
    UpdateMDC(handles);
    UpdateMDCPeakElements(handles,handles.current_y_index);
    UpdateMDCPeakPlot(handles,handles.current_y_index);
    UpdateMDCPeakPlot_fit(handles,handles.current_y_index);
    %
    
end

function GoToPointMDC_callback(~,~)

function DeletePoint_callback(~)

function UpdatePeaksPlot(~)

function UpdateMDC(handles)
data=get(handles.mObject,'UserData');
y=data.value(:,handles.current_y_index);
set(handles.MDCScatter,'YData',y);

function UpdateSettingTable(~)
% handles

function DragBlueLine(handle,~)
handles=guidata(handle);
delete(findobj(handles.ax2,'-regexp','Tag','.*Ax2Temp.*'));
set(handles.mObject,'WindowButtonMotionFcn',@MoveBlueLine);
set(handles.mObject,'WindowButtonUpFcn',@DropBlueLine);
set(handles.mObject,'Pointer','Bottom');


function MoveBlueLine(handle,~)
handles=guidata(handle);
Position=get(handles.ax1,'CurrentPoint');

%

data = get(handles.mObject,'UserData');
[~,handles.current_y_index]=min(abs(data.y(:)-Position(1,2)));
handles.current_y_position=data.y(handles.current_y_index);

%

set(handles.BlueLine,'YData',...
    [handles.current_y_position,handles.current_y_position]);
UpdateMDC(handles);
UpdateMDCPeakPlot_fit(handles,handles.current_y_index);
guidata(handles.mObject,handles);

function DropBlueLine(handle,~)
set(handle,'WindowButtonMotionFcn','');
set(handle,'WindowButtonUpFcn','');
set(handle,'Pointer','Arrow');
handles=guidata(handle);
h=findobj(handles.ax2);
delete(h(2:end));
data=get(handles.mObject,'UserData');
y=data.value(:,handles.current_y_index);
handles.MDCScatter=scatter(handles.ax2,data.x,y,'b','Marker','.');
guidata(handles.mObject,handles)
UpdateMDCPeakElements(handles,handles.current_y_index);
UpdateMDCPeakPlot(handles,handles.current_y_index);
UpdateMDCPeakPlot_fit(handles,handles.current_y_index);

function DeletePeakPoint_callback(handle,~,name)
handles=guidata(handle);
UserPeak=get(handles.SettingTable,'UserData');
UserPeak(handles.current_y_index).(name)=[];
set(handles.SettingTable,'UserData',UserPeak);
UpdateMDCPeakElements(handles,handles.current_y_index);
UpdateMDCPeakPlot(handles,handles.current_y_index);

function AddAPeakPoint_callback(handle,~,name)
handles=guidata(handle);
UserPeak=get(handles.SettingTable,'UserData');
if ~isfield(UserPeak,name)
    errordlg('Unknown Error. Please save data and restart panel.');
    return;
end

%% Add a new Peak Point to the Data Base %%
%  -------------------------------------  %                                        

%% Get Peak Data from data base
y_pos=handles.current_y_position; 
y_ind=handles.current_y_index; 
Peak = UserPeak(y_ind).(name);
%% Verification of existed peaks
if ~isempty(Peak)&&Peak.Select
    warndlg(['A peak point belonging to ',name,' already exists.']);
    return;
end
Pos=get(handles.ax2,'CurrentPoint');

%% Peak data structure
% UserPeak is a structure array, with the same length of data.y
% UserPeak(handles.current_y_index).Peak1.x 
% UserPeak(handles.current_y_index).Peak1.y
% UserPeak(handles.current_y_index).Peak1.h
% UserPeak(handles.current_y_index).Peak1.w
% UserPeak(handles.current_y_index).Peak1.b
% UserPeak(handles.current_y_index).Peak1.Select
% UserPeak(handles.current_y_index).Peak1.Ax1Point, 
% UserPeak(handles.current_y_index).Peak1.Ax2Point, Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.Text,     Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.BaseLine, Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.WidthLine,Tag: Ax2Temp
% LorentzPlot,Tag: Ax2TempPlot
% SumPlot,    Tag: Ax2TempPlot
% --------------------------------------------------------------

%% Initialize Peak Properties
x_lim=xlim(handles.ax2);
xlen=x_lim(2)-x_lim(1);
Peak.x=Pos(1);
Peak.y=y_pos(1);
Peak.h=Pos(3);
Peak.w=xlen/8;
UserPeak(handles.current_y_index).b=Peak.h/10;
Peak.Select=true;
% Create Interactive Obj
hold(handles.ax1,'on');
color_list={'r','g','b','y','m','c','r','g','b','y'};
c=color_list{str2double(name(end))};
Peak.Ax1Point=line('XData',Peak.x,'YData',handles.current_y_position,...
    'Parent',handles.ax1,'Color',c,...
    'Marker','+','MarkerSize',10,'LineWidth',2,...
    'Tag',['Ax1TempElement',name]);
hold(handles.ax1,'on');
%% Save Changes
UserPeak(y_ind).(name)=Peak;
set(handles.SettingTable,'UserData',UserPeak);
guidata(handles.mObject,handles);

%% Update Panel
UpdateMDCPeakElements(handles,y_ind);
UpdateMDCPeakPlot(handles,y_ind);
UpdateSettingTable(handles);


function UpdateMDCPeakElements(handles,y_ind)
%% Peak data structure
% UserPeak is a structure array, with the same length of data.y
% UserPeak(handles.current_y_index).Peak1.x 
% UserPeak(handles.current_y_index).Peak1.y
% UserPeak(handles.current_y_index).Peak1.h
% UserPeak(handles.current_y_index).Peak1.w
% UserPeak(handles.current_y_index).b
% UserPeak(handles.current_y_index).Peak1.Select
% UserPeak(handles.current_y_index).Peak1.Ax1Point, Tag: Ax1TempElement
% UserPeak(handles.current_y_index).Peak1.Ax2Point, Tag: Ax2TempElement
% UserPeak(handles.current_y_index).Peak1.Text,     Tag: Ax2TempElement
% UserPeak(handles.current_y_index).Peak1.BaseLine, Tag: Ax2TempElement
% UserPeak(handles.current_y_index).Peak1.WidthLine,Tag: Ax2TempElement
% LorentzPlot,Tag: Ax2TempPlot
% SumPlot,    Tag: Ax2TempPlot


%% Clear Formal Plot
% This is not an efficient way to redraw the MDC axis (handles.ax2),
% but it is an efficient way to write it.

delete(findobj(handles.ax2,'-regexp','Tag','.*TempElement.*'));
drawnow;
%

%% Get Data
data=get(handles.mObject,'UserData');
UserPeak=get(handles.SettingTable,'UserData');
names=fieldnames(UserPeak);
s=size(names);
if s(1)~=1
    names=names';
end
names_joint=strjoin(names);
names=regexp(names_joint,'Peak[0-9]','match');
%% Plot
hold(handles.ax1,'on');
hold(handles.ax2,'on');
flag=0;
for i = 1:length(names)
    name=names{i};
    Peak=UserPeak(y_ind).(name);
    b=UserPeak(y_ind).b;
    if ~isempty(Peak)&&Peak.Select
        %% Test Part
        flag=1;
        color_list={'r','g','b','y','m','c','r','g','b','y'};
        c=color_list{str2double(name(end))};
        Peak.Ax2Point=line('XData',Peak.x,'YData',Peak.h,...
            'Parent',handles.ax2,'Color',c,...
            'Marker','+','MarkerSize',10,'LineWidth',2,...
            'Tag','Ax2TempElement',...
            'ButtonDownFcn',{@UpdateUserPeak,name,y_ind,'PosMove'});
        Peak.Text=text(Peak.x,Peak.h,name(end),...
            'Parent',handles.ax2,'EdgeColor',c,'Tag','Ax2TempElement');
        set(Peak.Text,'Unit','pixels');
        textpos=get(Peak.Text,'Position');
        set(Peak.Text,'Position',textpos-[0,20,0]);
        %     set(Peak.Text,'Unit','data');
        Peak.WidthLine=line([Peak.x-Peak.w,Peak.x+Peak.w],[Peak.h/2,Peak.h/2],...
            'Parent',handles.ax2,'LineWidth',2,...,
            'LineStyle','--','Color','k','Tag','Ax2TempElement',...
            'ButtonDownFcn',{@UpdateUserPeak,name,y_ind,'WidthMove'});      
        %%
        uistack(Peak.Ax2Point,'top');
        UserPeak(y_ind).(name)=Peak;
    end
end
if flag
    UserPeak(handles.current_y_index).BaseLine=line([data.x(1),data.x(end)],...
        [b,b],'Parent',handles.ax2,'LineWidth',2,'Color','k',...
        'Tag','Ax2TempElement',...
        'ButtonDownFcn',{@UpdateUserPeak,name,y_ind,'BaseMove'});
end
set(handles.SettingTable,'UserData',UserPeak);
hold(handles.ax2,'off');
hold(handles.ax2,'off');

function UpdateMDCPeakPlot_fit(handles,y_index)
%% Peak:
% Peak.x{i}(k)
% Peak.y{i}(k)
% Peak.h{i}(k)
% Peak.w{i}(k)
% Peak.y_ind{i}
% Peak.x_f{i}(j=length(data.y))
% Peak.y_f{i}(j)
% Peak.h_f{i}(j)
% Peak.w_f{i}(j)
% Peak.b_f(j)
% Peak.AreaFlag{i}(j)
% Peak.Select{i}(j)

delete(findobj(handles.ax2,'-regexp','Tag','.*Ax2TempFit.*'));
%% Get Data
data=get(handles.mObject,'UserData');
if isfield(data,'FitPeak')
    sumplot=0;
    flag=0;
    Peak=data.FitPeak;
    for i=1:length(Peak.x)
        if Peak.AreaFlag{i}(y_index)
            flag=1;
            ydata=LorentzPlot(data.x,Peak.x_f{i}(y_index),...
                Peak.h_f{i}(y_index),Peak.w_f{i}(y_index));
            sumplot=sumplot+ydata;
        end
    end
    if flag==1
        sumplot=sumplot+Peak.b(y_index);
        hold(handles.ax2,'on');
        plot(handles.ax2,data.x,sumplot,'c','Tag','Ax2TempFit');
        hold(handles.ax2,'off');
    end
end

function UpdateMDCPeakPlot(handles,y_ind)
%% Peak data structure
% UserPeak is a structure array, with the same length of data.y
% UserPeak(handles.current_y_index).Peak1.x 
% UserPeak(handles.current_y_index).Peak1.y
% UserPeak(handles.current_y_index).Peak1.h
% UserPeak(handles.current_y_index).Peak1.w
% UserPeak(handles.current_y_index).Peak1.b
% UserPeak(handles.current_y_index).Peak1.Select
% UserPeak(handles.current_y_index).Peak1.Ax1Point, 
% UserPeak(handles.current_y_index).Peak1.Ax2Point, Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.Text,     Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.BaseLine, Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.WidthLine,Tag: Ax2Temp
% LorentzPlot,Tag: Ax2TempPlot
% SumPlot,    Tag: Ax2TempPlot
%% 

%% Clear Formal Plot
% This is not an efficient way to redraw the MDC axis (handles.ax2),
% but it is an efficient way to write it.
delete(findobj(handles.ax2,'-regexp','Tag','.*Ax2TempPlot.*'));
%

%% Get Data
data=get(handles.mObject,'UserData');
UserPeak=get(handles.SettingTable,'UserData');
names=fieldnames(UserPeak);
s=size(names);
if s(1)~=1
    names=names';
end
names_joint=strjoin(names);
names=regexp(names_joint,'Peak[0-9]','match');
%% Plot
hold(handles.ax2,'on');
sumplot=zeros(size(data.x));
flag=0;
for i = 1:length(names)
    name=names{i};
    Peak=UserPeak(y_ind).(name);  
    if ~isempty(Peak)
        flag=1;
        %%
        peakpos=Peak.x;
        height=Peak.h;
        width=Peak.w;
        base=UserPeak(y_ind).b;
        ydata=LorentzPlot(data.x,peakpos,height,width);
        sumplot=sumplot+ydata;
        plot(handles.ax2,data.x,ydata,'k','Tag','Ax2TempPlot');
    end
end
if flag
    sumplot=sumplot+base;
    plot(handles.ax2,data.x,sumplot,'r','Tag','Ax2TempPlot');
end
hold(handles.ax2,'off');
function ydata=LorentzPlot(xdata,peakpos,height,width)
ydata=height*width^2./((xdata-peakpos).^2+width^2);

function UpdateUserPeak(handle,~,name,Peak_ind,Method)
%% Peak data structure
% UserPeak is a structure array, with the same length of data.y
% UserPeak(handles.current_y_index).Peak1.x 
% UserPeak(handles.current_y_index).Peak1.y
% UserPeak(handles.current_y_index).Peak1.h
% UserPeak(handles.current_y_index).Peak1.w
% UserPeak(handles.current_y_index).Peak1.b
% UserPeak(handles.current_y_index).Peak1.Select
% UserPeak(handles.current_y_index).Peak1.Ax1Point, Tag: Ax1Temp
% UserPeak(handles.current_y_index).Peak1.Ax2Point, Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.Text,     Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.BaseLine, Tag: Ax2Temp
% UserPeak(handles.current_y_index).Peak1.WidthLine,Tag: Ax2Temp
% LorentzPlot,Tag: Ax2TempPlot
% SumPlot,    Tag: Ax2TempPlot
%% Method 'PosMove' 'WidthMove' 'BaseMove'
% Peak.Ax2Point=scatter(handles.ax2,Peak.x,Peak.h,100,c,'+',...
%     'LineWidth',2,'Tag','Ax2TempElement',...
%     'ButtonDownFcn',{@UpdateUserPeak,name,y_ind,'PosMove'});
% Peak.Text=text(Peak.x,Peak.h,name(end),...
%     'Parent',handles.ax2,'EdgeColor',c,'Tag','Ax2TempElement',...
%     'ButtonDownFcn',{@UpdateUserPeak,name,y_ind,'PosMove'});
% set(Peak.Text,'Unit','pixels');
% textpos=get(Peak.Text,'Position');
% set(Peak.Text,'Position',textpos-[0,20,0]);
% %     set(Peak.Text,'Unit','data');
% Peak.WidthLine=line([Peak.x-Peak.w,Peak.x+Peak.w],[Peak.h/2,Peak.h/2],...
%     'Parent',handles.ax2,'LineWidth',2,...,
%     'LineStyle','--','Color','k','Tag','Ax2TempElement',...
%     'ButtonDownFcn',{@UpdateUserPeak,name,y_ind,'WidthMove'});
% if name(end)=='1'
%     UserPeak(handles.current_y_index).BaseLine=line([data.x(1),data.x(end)],...
%         [b,b],...
%         'Parent',handles.ax2,'LineWidth',2,'Color','k',...
%         'ButtonDownFcn',{@UpdateUserPeak,name,y_ind,'BaseMove'});
% end
handles=guidata(handle);
set(handles.mObject,'WindowButtonMotionFcn',...
    {@UpdateUserPeak_motion,name,Peak_ind,Method});
set(handles.mObject,'WindowButtonUpFcn',...
    @UpdateUserPeak_up);

function UpdateUserPeak_motion(handle,~,name,~,Method)
handles=guidata(handle);
UserPeak=get(handles.SettingTable,'UserData');
Peak=UserPeak(handles.current_y_index).(name);
Position=get(handles.ax2,'CurrentPoint');
x_pos=Position(1,1);
y_pos=Position(1,2);
switch Method
    case 'PosMove'       
        Peak.x=x_pos;
        Peak.h=y_pos;
        set(Peak.Ax1Point,'XData',Peak.x);
        set(Peak.Ax2Point,'XData',Peak.x,'YData',Peak.h);
        set(Peak.Text,'Position',[Peak.x,Peak.h,0]);
        set(Peak.Text,'Unit','pixels');
        textpos=get(Peak.Text,'Position');
        set(Peak.Text,'Position',textpos-[0,20,0]);
        set(Peak.Text,'Unit','data');
        set(Peak.WidthLine,'XData',[Peak.x-Peak.w,Peak.x+Peak.w],...
            'YData',[Peak.h/2,Peak.h/2])
        
        UserPeak(handles.current_y_index).(name)=Peak;
        set(handles.SettingTable,'UserData',UserPeak);
        UpdateMDCPeakPlot(handles,handles.current_y_index);
    case 'WidthMove'
        Peak.w=abs(x_pos-Peak.x);
        set(Peak.WidthLine,'XData',[Peak.x-Peak.w,Peak.x+Peak.w]);
        UserPeak(handles.current_y_index).(name)=Peak;
        set(handles.SettingTable,'UserData',UserPeak);
        UpdateMDCPeakPlot(handles,handles.current_y_index);
    case 'BaseMove'
        UserPeak(handles.current_y_index).b=y_pos;
        set(UserPeak(handles.current_y_index).BaseLine,'YData',[y_pos,y_pos]);
        set(handles.SettingTable,'UserData',UserPeak);
        UpdateMDCPeakPlot(handles,handles.current_y_index);
end


function UpdateUserPeak_up(handle,~)
handles=guidata(handle);
set(handles.mObject,'WindowButtonMotionFcn',[]);
set(handles.mObject,'WindowButtonUpFcn',[]);

function data=generate_testdata
% This is a theoretical distribution

%% Test data
E0=-0.2;
K0=65;
x1=linspace(65,71,100);
y1=linspace(-0.25,0.05,100); 
Ef=0;
Et=0.02;
Ew=0.03;
dE=0.005;
dK=0.05;

a=0.05;
x=x1-K0;
y=y1-E0;
Ef=Ef-E0;
m1=0;
m2=0;

mask=1+m1*x+m2*x.^2;
mask=repmat(mask',[1,length(y)]);

[xx,yy]=ndgrid(x,y);
stepx=abs(xx(2,1)-xx(1,1));
stepy=abs(yy(1,2)-yy(1,1));


% Original Dispersion
v=1./((yy-a.*xx).^2+Ew^2);
v=v.*(1./(exp((yy-Ef)/Et)+1));
v=v.*mask;
% Resolution
nx=round(dK*4/stepx);
ny=round(dE*4/stepy);
res_x=linspace(-2*stepx,2*stepx,nx);
res_y=linspace(-2*stepy,2*stepy,ny);
[res_x,res_y]=ndgrid(res_x,res_y);
% log2?
res=exp(-log(2)/2*((res_x/dK).^2+(res_y/dE).^2));

% Broaden Dispersion
v = conv2(v,res,'same');
data.value=v/sum(sum(v));
data.value = data.value+rand(100)/10000/3;
data.x=x1;
data.y=y1;
if sum(sum(isnan(v)))~=0
    disp('nan');
end
return;

