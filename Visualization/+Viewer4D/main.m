function main(varargin)
% Viewer4D is used to plot 4D data from Diamond and Elettra.
% Support and Bug Report: han.peng@queens.ox.ac.uk

handles.mObject = figure('Position',[200 400 300 450],...
    'Name','Viewer4D',...
    'NumberTitle','off',...
    'MenuBar','none');

VarListMenu=uicontextmenu();
%% HomeBox: HBox1 + DataInfoPanel
VBoxHome=uiextras.VBox('Parent',handles.mObject);
HBox1=uiextras.HBox('Parent',VBoxHome);
DataInfoPanel=uiextras.Panel('Parent',VBoxHome,'Title','Data Info',...
    'Padding',3); 
set(VBoxHome,'Sizes',[-1 120]);

%% Inside HBox1 VarList + PlotVBox
VarListPanel=uiextras.Panel('Parent',HBox1,'Title','Variable List',...
    'Padding',3);
PlotVBox=uiextras.VBox('Parent',HBox1);
set(HBox1,'Sizes',[-1 150]);

%% Inside VarlistPanel: VarList + VarListFilterPanel
VarListVBox=uiextras.VBox('Parent',VarListPanel);
handles.VarList=uicontrol('Parent',VarListVBox,...
    'Style','ListBox','BackgroundColor','w',...
    'Value',1,...
    'Callback',@VarList_CallbackFcn,...
    'uicontextmenu',VarListMenu);
VarListFilterPanel=...
    uiextras.Panel('Parent',VarListVBox,'Title','Variable Filter',...
    'Padding',3);
set(VarListVBox,'Sizes',[-1,45])
    % VarListFilterPanel
    VarListFilter=uibuttongroup('Parent',VarListFilterPanel);
    handles.FlagAll=uicontrol('Parent',VarListFilter,...
        'Style','RadioButton',...
        'String','All',...
        'Pos',[2 2 40 20]);
    handles.Flag4D=uicontrol('Parent',VarListFilter,...
        'Style','RadioButton',...
        'String','4D',...
        'Pos',[42 2 40 20], ...
        'Value',1);
    handles.Flag3D=uicontrol('Parent',VarListFilter,...
        'Style','RadioButton',...
        'String','3D',...
        'Pos',[82 2 40 20]);
        
    

%% Inside PlotVBox: Plot1Panel + Plot2Panel
Plot1Panel=uiextras.Panel('Parent',PlotVBox,'Title','Real Space Plot',...
    'Padding',3);
Plot2Panel=uiextras.Panel('Parent',PlotVBox,'Title','Dispersion Plot',...
    'Padding',3);
set(PlotVBox,'Sizes',[90 220]);

    %% Plot1Panel: FigNum1 + Plot1FromToHBox + Plot1
    Plot1Box=uiextras.VBox('Parent',Plot1Panel);
    FigNum1HBox=uiextras.HBox('Parent',Plot1Box);
    uicontrol('Parent',FigNum1HBox,'Style','text',...
        'String','Figure Num 1',...
        'TooltipString','Figure Number for Real Space Plot');
    handles.Plot1FigNum=...
        uicontrol('Parent',FigNum1HBox,'Style','edit','String','100',...
        'BackgroundColor','w',...
        'TooltipString','Figure Number for Real Space Plot');
    Plot1FromToBox=uiextras.HBox('Parent',Plot1Box);
    handles.Plot1=...
        uicontrol('Parent',Plot1Box,'Style','pushbutton',...
        'String','<html>Plot Real Space</html>',...
        'Callback',@Plot1_CallbackFcn);
    set(Plot1Box,'Sizes',[20 20 30]);
        % Plot1HBox
        
        Plot1FromHBox=uiextras.HBox('Parent',Plot1FromToBox);
        ToHBox=uiextras.HBox('Parent',Plot1FromToBox);
        uicontrol('Parent',Plot1FromHBox,'Style','text','String','From');
        handles.Plot1From=...
            uicontrol('Parent',Plot1FromHBox,'Style','edit',...
            'String','Min','BackgroundColor','w',...
            'TooltipString','Range of integration for data.z');
        uicontrol('Parent',ToHBox,'Style','text','String','To');
        handles.Plot1To=...
            uicontrol('Parent',ToHBox,'Style','edit',...
            'String','Max','BackgroundColor','w',...
            'TooltipString','Range of integration for data.z');
            
    %% Plot2Panel: FigNum2 + Settings + Plot2
    Plot2VBox=uiextras.VBox('Parent',Plot2Panel);
    FigNum2HBox=uiextras.HBox('Parent',Plot2VBox);
    uicontrol('Parent',FigNum2HBox,'Style','text',...
        'String','Figure Num 2',...
        'TooltipString','Figure Number for EDC/Angle Cut Plot');
    handles.Plot2FigNum=...
        uicontrol('Parent',FigNum2HBox,'Style','edit','String','101',...
        'BackgroundColor','w',...
        'TooltipString','Figure Number for EDC/Angle Cut Plot');
    SettingsPanel=...
        uiextras.Panel('Parent',Plot2VBox,'Padding',3,'Title','Settings');
    SettingsVBox=uiextras.VBox('Parent',SettingsPanel);
    handles.Plot2=...
        uicontrol('Parent',Plot2VBox,'Style','pushbutton',...
        'String','Plot Dispersion','Callback',@Plot2_CallbackFcn);
    set(Plot2VBox,'Sizes',[20 135 -1]);
    
        % SettingsPanel, SettingsVBox: Position + EDC + Angle
        PositionVBox=uiextras.VBox('Parent',SettingsVBox); 
        Plot2Setting=uibuttongroup('Parent',SettingsVBox);
        set(SettingsVBox,'Sizes',[65 -1])
            
            % Plot2Setting
            handles.Plot2EDCFlag=uicontrol('Parent',Plot2Setting,...
                'Style','RadioButton','String','EDC',...
                'Value',1,'Pos',[5 24 50 20]);
            handles.Plot2EDCFrom=uicontrol('Parent',Plot2Setting,'Style','edit',...
            'BackgroundColor','w','Pos',[50 24 35 20],...
            'String','Min',...
            'TooltipString','<html>EDC Plot Integration Range.<br>Default: Min to Max');
            handles.Plot2EDCTo=uicontrol('Parent',Plot2Setting,'Style','edit',...
            'BackgroundColor','w','Pos',[85 24 35 20],...
            'String','Max',...
            'TooltipString','<html>EDC Plot Integration Range.<br>Default: Min to Max');
            handles.Plot2AngleFlag=uicontrol('Parent',Plot2Setting,...
                'Style','RadioButton','String','Angle',...
                'Value',0,'Pos',[5 2 100 20]);
            
            % PositionVBox           
            PositionHBox1=uiextras.HBox('Parent',PositionVBox);
            PositionHBox2=uiextras.HBox('Parent',PositionVBox);
            set(PositionVBox,'Sizes',[20,40]);
            CheckHBox=uiextras.HBox('Parent',PositionHBox1);
            XPosHBox=uiextras.HBox('Parent',PositionHBox1);
            YPosHBox=uiextras.HBox('Parent',PositionHBox1);
            set(PositionHBox1,'Sizes',[20,-1,-1]);
            uicontrol('Parent',XPosHBox,'Style','text','String','X');
            handles.CheckIndex=...
                uicontrol('Parent',CheckHBox,'Style','Checkbox',...
                'Value',0,...
                'TooltipString',['Check: Index. Uncheck: Real.']);
            handles.Plot2PosX=...
                uicontrol('Parent',XPosHBox,'Style','edit',...
                'BackgroundColor','w',...
                'TooltipString',['<html>Position of EDC/Angle Cut Plot.',...
                '<br>Get from Real Space Plot.']);
            uicontrol('Parent',YPosHBox,'Style','text','String','Y');
            handles.Plot2PosY=...
                uicontrol('Parent',YPosHBox,'Style','edit',...
                'BackgroundColor','w',...
                'TooltipString',['<html>Position of EDC/Angle Cut Plot.',...
                '<br>Get from Real Space Plot.']);
            handles.Plot2PosGet=...
                uicontrol('Parent',PositionHBox2,'Style','pushbutton',...
                'String','<html>Get Pos<br>FigNum1</html>',...
                'Callback',@Plot2GetPos_CallbackFcn);
            handles.Plot2GetEDCs=...
                uicontrol('Parent',PositionHBox2,'Style','pushbutton',...
                'String','<html>Get EDCs<br>FigNum1</html>',...
                'Callback',@Plot2GetEDCs_CallbackFcn,...
                'TooltipString',['<html>Select points and combine the EDCs.',...
                '<br>Get from Real Space Plot.']);
            set(PositionHBox2,'Sizes',[-1,-1]);
        

%% DataInfoPanel
handles.DataInfoTable=...
    uitable('Parent',DataInfoPanel,...
    'Data',zeros(4),...
    'ColumnName',{'x','y','k','z'},...
    'RowName',{'Min','Max','Step','Size'},...
    'ColumnWidth',{58 58 58 58});
        
        
guidata(handles.mObject,handles);

        
function VarList_CallbackFcn(hObject,~)
handles=guidata(hObject);
if get(handles.FlagAll,'value')
    VarFlag=0;
elseif get(handles.Flag3D,'value')
    VarFlag=3;
elseif get(handles.Flag4D,'value')
    VarFlag=4;
end
VarNames=NameFilter(VarFlag);
index=get(handles.VarList,'Value');
if isempty(VarNames)
    VarNames{1}='Empty';
end
if isempty(index)
    index=1;
    set(handles.VarList,'Value',index);
end
if index>length(VarNames)
    index=length(VarNames);
    set(handles.VarList,'Value',index);
end
set(handles.VarList,'String',VarNames);
SetDataInfo(hObject);

function SetDataInfo(hObject)
handles=guidata(hObject);
VarNameNum=get(handles.VarList,'Value');
VarName=get(handles.VarList,'String');

Data=zeros(4);

if isempty(VarName);
    set(handles.DataInfoTable,'Data',Data);
    return;
end

VarName=VarName{VarNameNum};

if strcmp(VarName,'Empty');
    set(handles.DataInfoTable,'Data',Data);
    return;
end


data=evalin('base',VarName);

if ~isfield(data,'value') && ~isprop(data,'value')
    set(handles.DataInfoTable,'Data',Data);
    return;
end

% if length(size(data.value))==2
%     data.k=[0,0];
%     data.z=[0,0];
% end
% if length(size(data.value))==3
%     data.k=[0 0];
% end

lx=length(data.x);
ly=length(data.y);
lk=length(data.k);
lz=length(data.z);
if lk>1
Data=...
    [data.x(1),data.y(1),data.k(1),data.z(1);...
    data.x(lx),data.y(ly),data.k(lk),data.z(lz);...
    data.x(2)-data.x(1),data.y(2)-data.y(1),data.k(2)-data.k(1),...
    data.z(2)-data.z(1);
    lx,ly,lk,lz];
else
    Data=...
    [data.x(1),data.y(1),data.k(1),data.z(1);...
    data.x(lx),data.y(ly),data.k(lk),data.z(lz);...
    data.x(2)-data.x(1),data.y(2)-data.y(1),0,...
    data.z(2)-data.z(1);
    lx,ly,lk,lz];
end
set(handles.DataInfoTable,'Data',Data);

function Plot2GetPos_CallbackFcn(hObject,~)
handles=guidata(hObject);
VarName=get(handles.VarList,'String');
VarNameNum=get(handles.VarList,'Value');
if isempty(VarName);
    errordlg('No Data Find. Check Workspace.');
    return;
end
VarName=VarName{VarNameNum};
if strcmp(VarName,'Empty');
    errordlg('No Data Find. Check Workspace.');
    return;
end
data=evalin('base',VarName);
FigNum=get(handles.Plot1FigNum,'String');
FigNum=str2double(FigNum);
IndexFlag=get(handles.CheckIndex,'Value');
[PosX,PosY]=getpts(figure(FigNum));
for ii=1:length(PosX)
    txt=strcat(num2str(PosX(ii)),',',num2str(PosY(ii)));
    figure(FigNum);hold on
    scatter(PosX(ii),PosY(ii),'r*');
    text(PosX(ii),PosY(ii),txt,'Color','red');
end
if IndexFlag==1
    PosXTemp=[];PosYTemp=[];
    for ii=1:length(PosX)
        [~,PosXTempi]=min(abs(PosX(ii)-data.x));
        [~,PosYTempi]=min(abs(PosY(ii)-data.y));
        PosXTemp=[PosXTemp,PosXTempi];
        PosYTemp=[PosYTemp,PosYTempi];
    end
    PosX=PosXTemp;PosY=PosYTemp;
    set(handles.Plot2PosX,'String',num2str(PosX(:)'));
    set(handles.Plot2PosY,'String',num2str(PosY(:)'));
else
    set(handles.Plot2PosX,'String',num2str(PosX(:)'));
    set(handles.Plot2PosY,'String',num2str(PosY(:)'));
end    
Plot2_CallbackFcn(hObject);


function Plot2GetEDCs_CallbackFcn(hObject,~)
handles=guidata(hObject);
VarNameNum=get(handles.VarList,'Value');
VarName=get(handles.VarList,'String');
if isempty(VarName);
    errordlg('No Data Find. Check Workspace.');
    return;
end
VarName=VarName{VarNameNum};
if strcmp(VarName,'Empty');
    errordlg('No Data Find. Check Workspace.');
    return;
end
data=evalin('base',VarName);
FigNum=get(handles.Plot1FigNum,'String');
FigNum=str2double(FigNum);
FigNum2=get(handles.Plot2FigNum,'String');
FigNum2=str2double(FigNum2);
From=get(handles.Plot1From,'String');
To=get(handles.Plot1To,'String');
if strcmp(From,'Min')
    FromIndex=2;
    ToIndex=length(data.z);
else
    From=str2double(From);
    To=str2double(To);
    [~,FromIndex]=min(abs(data.z-From));
    [~,ToIndex]=min(abs(data.z-To));
end
[PosX,PosY]=getpts(figure(FigNum));

n=length(PosX);
dataEDC.value=0;
dataEDC.x=data.z(FromIndex:ToIndex);
dataEDC.VarName=VarName;
for i=1:n
    [~,PosXIndex]=min(abs(data.x-PosX(i)));
    [~,PosYIndex]=min(abs(data.y-PosY(i)));
    if length(size(data.value))==3
       dataEDC.value=dataEDC.value+data.value(PosXIndex,PosYIndex,FromIndex:ToIndex);
    elseif length(size(data.value))==4
        value=squeeze(sum(data.value(Pos(1),Pos(2),:,FromIndex:ToIndex),3));
        dataEDC.value=dataEDC.value+value;
    end
end
dataEDC.value=squeeze(dataEDC.value)/n;
VarNameNew=inputdlg('Variable Name in work space:','Save as',1,{[VarName,'_EDC']});
assignin('base',VarNameNew{1},dataEDC);
figure(FigNum2)
plot(dataEDC.x,dataEDC.value);

function Plot1_CallbackFcn(hObject,~)
%% Load Data and Get Information
handles=guidata(hObject);
VarNameNum=get(handles.VarList,'Value');
VarName=get(handles.VarList,'String');

if isempty(VarName)
    errordlg('No Data Find. Check Workspace.');
    return;
end

VarName=VarName{VarNameNum};

if strcmp(VarName,'Empty')
    errordlg('No Data Find. Check Workspace.');
    return;
end

data=evalin('base',VarName);

if ~isfield(data,'value') && ~isprop(data,'value')
    errordlg('Data Type Not Match.');
    return;
elseif length(size(data.value))~=3&&length(size(data.value))~=4
    errordlg('Data Dimension should be 3 or 4');
    return;
end

FigNum=get(handles.Plot1FigNum,'String');
FigNum=str2double(FigNum);

From=get(handles.Plot1From,'String');
To=get(handles.Plot1To,'String');
if strcmp(From,'Min')
    FromIndex=1;
    ToIndex=length(data.z);
else
    From=str2double(From);
    To=str2double(To);
    [~,FromIndex]=min(abs(data.z-From));
    [~,ToIndex]=min(abs(data.z-To));
end

figure(FigNum);
cla;
PlotRealSpace(data,[FromIndex ToIndex]);


function Plot2_CallbackFcn(hObject,~)
%% Load Data and Get Information
handles=guidata(hObject);
VarNameNum=get(handles.VarList,'Value');
VarName=get(handles.VarList,'String');

if isempty(VarName);
    errordlg('No Data Find. Check Workspace.');
    return;
end

VarName=VarName{VarNameNum};

if strcmp(VarName,'Empty');
    errordlg('No Data Find. Check Workspace.');
    return;
end


data=evalin('base',VarName);

if ~isfield(data,'value') && ~isprop(data,'value')
    errordlg('Data Type Not Match.');
    return;
elseif length(size(data.value))~=3&&length(size(data.value))~=4
    errordlg('Data Dimension should be 3 or 4');
    return;
end

FigNum=get(handles.Plot2FigNum,'String');
FigNum=str2double(FigNum);


if get(handles.Plot2EDCFlag,'Value');
    From=1;
    To=1;
    if length(size(data.value))==4
        From=get(handles.Plot2EDCFrom,'String');
        To=get(handles.Plot2EDCTo,'String');
        if strcmp(From,'Min')
            From=1;
            To=length(data.k);
        else
            From=str2double(From);
            To=str2double(To);
            Step=data.k(2)-data.k(1);
            From=round((From-data.k(1))/Step)+1;
            To=round((To-data.k(1))/Step)+1;
        end
    end
end

PosX=get(handles.Plot2PosX,'String');
PosY=get(handles.Plot2PosY,'String');
PosX=str2num(PosX);
PosY=str2num(PosY);
if isempty(PosX)||isempty(PosY)
    errordlg('Please Check Position Setting. X and Y must be real.');
    return;
end
IndexFlag = get(handles.CheckIndex,'Value');
if IndexFlag==0
    PosXTemp=[];PosYTemp=[];
    for ii=1:length(PosX)
        [~,PosXTempi]=min(abs(PosX(ii)-data.x));
        [~,PosYTempi]=min(abs(PosY(ii)-data.y));
        PosXTemp=[PosXTemp,PosXTempi];
        PosYTemp=[PosYTemp,PosYTempi];
    end
    PosX=PosXTemp;PosY=PosYTemp;
end
%% Plot
figure(FigNum);
N=ceil(sqrt(length(PosX)));
for ii=1:length(PosX)
    subplot(N,N,ii);
    txt=strcat(num2str(data.x(PosX(ii))),',',num2str(data.y(PosY(ii))));
    if get(handles.Plot2EDCFlag,'Value')
        PlotEDC4(data,[From To],[PosX(ii) PosY(ii)]);
    elseif get(handles.Plot2AngleFlag,'Value')
        PlotAngle4(data,[PosX(ii) PosY(ii)]);
    else
        errorlog('Please Select EDC or Angle Plot.')
        return;
    end
    title(txt);
end

function NameListOut=NameFilter(VarFlag)
NameListIn=evalin('base','who');
Length=length(NameListIn);
NameListOut={};
if ~VarFlag
    NameListOut=NameListIn;
else
    j=0;
    for i=1:Length
        data=evalin('base',NameListIn{i});
        try
            if length(size(data.value))==VarFlag && (isfield(data,'x') || isprop(data,'x'))
                j=j+1;
                NameListOut{j}=NameListIn{i}; %#ok<AGROW>
            end
        catch
        end
    end
end


function PlotRealSpace(data,Lim)
% %% Get Plot Data
% if(Lim(1)<1)
%     msgbox('''From'' exceeds z range.');
%     Lim(1)=1;
% end
% %% For Elettra Data
% if length(size(data.value))==3
%     if(Lim(1)<2)
%         Lim(1)=2;
%     end
% end
% if Lim(2)>length(data.z)
%     msgbox('''To'' exceeds z range.');
%     Lim(2)=length(data.z);
% end


%%

if length(size(data.value))==4
    value = squeeze(sum(data.value,3));
end
plot_value=sum(value(:,:,Lim(1):Lim(2)),3);

%% Plot

pcolor(data.x,data.y,plot_value');
shading interp;
colormap('jet');
axis equal;
axis tight;

function PlotEDC4(data,Lim,Pos)
if length(size(data.value))==3
    %% For Elettra Data
    plot(data.z(2:length(data.z)),squeeze(data.value(Pos(1),Pos(2),2:length(data.z))));
    %%
elseif length(size(data.value))==4
    if(Lim(1)<1)
        msgbox('''From'' exceeds k range.');
        Lim(1)=1;
    end
    if Lim(2)>length(data.k)
        msgbox('''To'' exceeds k range.');
        Lim(2)=length(data.k);
    end
    value=squeeze(sum(data.value(Pos(1),Pos(2),Lim(1):Lim(2),:),3));
    plot(data.z,value);
end

function PlotAngle4(data,Pos)
if length(size(data.value))==3
    errordlg('Only 4D data can be used to plot an angle cut');
    return;
elseif length(data.k)<2
    errordlg('Only 4D data can be used to plot an angle cut');
    return;
elseif length(size(data.value))==4
    value=squeeze(data.value(Pos(1),Pos(2),:,:));
    pcolor(data.k,data.z,value');
    shading interp;
    colormap('Gray');
end
