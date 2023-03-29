function fit_MDC_tools
handles.mObject = figure('Position',[1100 500 200 200],...
    'Name','fit_MDC_tools',...
    'NumberTitle','off',...
    'Tag','fit_MDC_tools',...
    'HandleVisibility','On',...
    'MenuBar','none');
hmenu=uicontextmenu();
uimenu('Parent',hmenu,'Label','Linear Fitting',...
    'Callback',@fit_linear)
uimenu('Parent',hmenu,'Label','Delete','separator','On',...
    'Callback',@Delete_CallbackFcn);
HBoxHome=uiextras.HBox('Parent',handles.mObject);
handles.VarList=uicontrol('Parent',HBoxHome,...
    'Style','ListBox','BackgroundColor','w',...
    'Value',1,'Max',100,...
    'Callback',@VarList_CallbackFcn,...
    'uicontextmenu',hmenu);

guidata(handles.mObject,handles);
function VarList_CallbackFcn(hObject,~)
UpdateVarList(hObject);


function fit_linear(hObject,~)
handles=guidata(hObject);
VarNames=get(handles.VarList,'String');
index=get(handles.VarList,'Value');
if strcmp(VarNames{index(1)},'Empty')
    return;
end
for i = 1:length(VarNames);
    Peak=evalin('base',VarNames{index(i)});
    fitObj=fit(Peak.x',Peak.y','Poly1');
    a=fitObj.p1;
    Ah=1e-10/6.58e-16; % for vf calculation
    vf=a*Ah;
    Peak.a=a;
    Peak.vf=vf;
    assignin('base',VarNames{index(i)},Peak);
end

function UpdateVarList(hObject)
handles=guidata(hObject);
VarNames=evalin('base','who');
index=get(handles.VarList,'Value');
if length(VarNames)==1;
    VarNamesTemp=VarNames;
    VarNames={};
    VarNames{1}=VarNamesTemp;
end
j=0;
VarNames_Peaks={};
for i=1:length(VarNames)
    Temp=regexp(VarNames{i},'.*Peak.*','Once');
    if ~isempty(Temp)
        j=j+1;
        VarNames_Peaks{j}=VarNames{i}; %#ok<AGROW>
    end
end
VarNames={}; %#ok<NASGU>
VarNames=VarNames_Peaks;

if isempty(VarNames)
    VarNames{1}='Empty';
end
if isempty(index)
    index=1;
    set(handles.VarList,'Value',index);
end
if index>length(VarNames)
    index=length(VarNames);
    set(handles.VarList,'Value',index(1));
end
set(handles.VarList,'String',VarNames);


function Delete_CallbackFcn(hObject,~)
%% Load data from VarList
UpdateVarList(hObject);
handles=guidata(hObject);
VarNames=evalin('base','who');
index=get(handles.VarList,'Value');
%%
DataName=VarNames{index};
Y='You shall not stop me!';
N='Wise advice...';
Option=questdlg(['My lord, Really want to DELETE ',DataName,'?'],'From your humble man:',Y,N,Y);
if ~strcmp(Option,Y)
    return;
end
evalin('base',['clear ',DataName]);
UpdateVarList(hObject);



