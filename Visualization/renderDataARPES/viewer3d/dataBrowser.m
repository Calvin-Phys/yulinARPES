function dataBrowser
% Bug report: han.peng@physics.ox.ac.uk
%
handles.mObject = figure('Position',[500 200 300 450],...
    'Name','Data Browser',...
    'NumberTitle','off',...
    'MenuBar','none',...
    'IntegerHandle','off',...
    'HandleVisibility','on',...
    'Tag','DataBrowser');
VBoxHome = uiextras.VBox('Parent',handles.mObject);
%% Variable Listbox: Varlist
handles.VarList=uicontrol('Parent',VBoxHome,...
    'Style','ListBox','BackgroundColor','w',...
    'Value',1,'Max',100,...
    'Callback',@VarList_CallbackFcn,...
    'Tag','VarList');

guidata(handles.mObject,handles);

function VarList_CallbackFcn(hObject,event)
UpdateVarList(hObject);

function UpdateVarList(hObject)
handles=guidata(hObject);
VarNames = evalin('base','who');

% if selection is out of range
if isempty(VarNames)
    VarNames={'Empty'};
    set(handles.VarList,'String',VarNames);
    set(handles.VarList,'Value',1,'ListboxTop',1);
else
    index=get(handles.VarList,'Value');
    if isempty(index)
        set(handles.VarList,'Value',1,'ListboxTop',1);
    else
        if max(index)>length(VarNames)
            set(handles.VarList,'Value',length(VarNames),'ListboxTop',1);      
        end
    end
    set(handles.VarList,'String',VarNames);
end

index=get(handles.VarList,'Value');
handles.VarNames={};
for i = 1:length(index)
    handles.VarNames{i}=VarNames{index(i)};
end

guidata(handles.mObject,handles);