function result = ARPES_data_browser_v5(action, varargin)
%ARPES_DATA_BROWSER_V5 Browse base-workspace data with groups and details.
%   FIG = ARPES_DATA_BROWSER_V5 opens or raises the independent v5 singleton.
%   STATE = ARPES_DATA_BROWSER_V5('read') returns visible names and selection.
%   ARPES_DATA_BROWSER_V5('refresh') refreshes without resetting selection.
%   ARPES_DATA_BROWSER_V5('select', {'name1','name2'}) selects visible names.
%   ARPES_DATA_BROWSER_V5('group', N) filters group 0 (all) through 4.
%   ARPES_DATA_BROWSER_V5('renamegroup', N, NAME) renames group 1 through 4.
%   ARPES_DATA_BROWSER_V5('membership', 'add'|'move'|'remove', N) changes
%   selected scalar ARPES structs/objects using the same callbacks as the GUI.
%   ARPES_DATA_BROWSER_V5('typefilter', 'all'|'cut'|'map'|'kz'|'4d'|'1d')
%   filters by OX_ARPES class; all includes every workspace variable.
%   Add retains other flags; move clears the active source only; remove uses
%   the active group. Names persist in MATLAB preferences; flags live in INFO.
if nargin == 0, action = 'open'; end
action=validatestring(action, {'open','read','refresh','select','group','renamegroup','membership','typefilter'});
fig = findall(groot,'Type','figure','Tag','ARPESDataBrowserV5');
if isempty(fig)
    fig = buildBrowser;
else
    fig = fig(1);
end
result = fig;
switch lower(action)
    case 'open'
        figure(fig);
    case 'refresh'
        UpdateVarList(fig);
    case 'select'
        handles = guidata(fig);
        names = cellstr(varargin{1});
        [found, indices] = ismember(names, variableNames(handles));
        if ~all(found), error('ARPES:Selection','Select visible variable names.'); end
        setSelectedRows(handles,indices);
        UpdateVarList(fig);
    case 'group'
        setGroup(fig,varargin{1});
    case 'renamegroup'
        applyGroupName(fig,varargin{1},varargin{2});
    case 'typefilter'
        setTypeFilter(fig,varargin{1});
    case 'membership'
        changeMembership(fig,varargin{1},varargin{2});
    case 'read'
        handles = guidata(fig);
        result = struct('figure',fig,'names',{variableNames(handles)}, ...
            'selected',{selectedNames(handles)},'group',activeGroup(handles), ...
            'groupNames',{handles.GroupLabels},'typeFilter',activeTypeFilter(handles));
end

function fig = buildBrowser
handles.mObject = figure('Position',[180 180 600 460], ...
    'Name','ARPES Data Browser v5','NumberTitle','off','MenuBar','none', ...
    'IntegerHandle','off','Tag','ARPESDataBrowserV5','Color',[.95 .96 .98]);
fig = handles.mObject;
handles.GroupLabels = getpref('ARPESDataBrowserV5','GroupNames', ...
    {'Group 1','Group 2','Group 3','Group 4'});
if ~iscellstr(handles.GroupLabels) || numel(handles.GroupLabels) ~= 4
    handles.GroupLabels = {'Group 1','Group 2','Group 3','Group 4'};
end
buildMenus(fig);
root = uiextras.HBox('Parent',fig,'Padding',0,'Spacing',0,'Tag','BrowserColumns');
left = uiextras.VBox('Parent',root,'Padding',3,'Spacing',4,'Tag','WorkspaceColumn');
right = uiextras.VBox('Parent',root,'Padding',3,'Spacing',4,'Tag','DetailsColumn');
set(root,'Sizes',[-1 -1]);
uicontrol('Parent',left,'Style','text','String','WORKSPACE DATA', ...
    'HorizontalAlignment','left','FontWeight','bold','ForegroundColor',[.12 .23 .38]);
searchRow = uiextras.HBox('Parent',left,'Spacing',4);
uicontrol('Parent',searchRow,'Style','text','String','Find name:','HorizontalAlignment','left');
handles.Search = uicontrol('Parent',searchRow,'Style','edit','BackgroundColor','white', ...
    'HorizontalAlignment','left','Tag','Search','Callback',@UpdateVarList, ...
    'TooltipString','Case-insensitive name filter; press Enter to apply.');
uicontrol('Parent',searchRow,'String','Refresh','Callback',@UpdateVarList,'Tag','Refresh');
set(searchRow,'Sizes',[58 -1 60]);
handles.GroupTabs = uitabgroup('Parent',left,'Tag','GroupTabs');
handles.GroupAll = uitab('Parent',handles.GroupTabs,'Title','All', ...
    'Tag','GroupAll','UserData',0);
for k=1:4
    handles.(sprintf('Group%d',k))=uitab('Parent',handles.GroupTabs, ...
        'Title',handles.GroupLabels{k},'Tag',sprintf('Group%d',k),'UserData',k);
end
handles.CurrentFolder=[];
%% VarList Right-click Menu
% Context actions use the selected list entries. Several actions read or write
% those variables in MATLAB's base workspace, so the browser remains coupled to
% the interactive workspace rather than owning a separate data model.
ListBoxMenu = uicontextmenu('Parent',handles.mObject);

uimenu(ListBoxMenu,'Label','Plot selected','Callback',@PlotData);
plotMenu=uimenu(ListBoxMenu,'Label','Plot');
uimenu(plotMenu,'Label','Along x','Callback',{@plot_CallbackFcn,'x'})
uimenu(plotMenu,'Label','Along y','Callback',{@plot_CallbackFcn,'y'})
uimenu(plotMenu,'Label','Along z','Callback',{@plot_CallbackFcn,'z'})
uimenu(plotMenu,'Label','All directions','Callback',{@plot_CallbackFcn,'all'})

plotDOSMenu=uimenu(ListBoxMenu,'Label','Plot DOS');

uimenu(plotDOSMenu,'Label','(V) Raw','Callback',{@plotDos_CallbackFcn,'V','raw'})
uimenu(plotDOSMenu,'Label','(V) Normalise to Mean','Callback',{@plotDos_CallbackFcn,'V','mean'})
uimenu(plotDOSMenu,'Label','(V) Normalise to Peak','Callback',{@plotDos_CallbackFcn,'V','peak'})
uimenu(plotDOSMenu,'Label','(H) Raw','Callback',{@plotDos_CallbackFcn,'H','raw'},'Separator','on')
uimenu(plotDOSMenu,'Label','(H) Normalise to Mean','Callback',{@plotDos_CallbackFcn,'H','mean'})
uimenu(plotDOSMenu,'Label','(H) Normalise to Peak','Callback',{@plotDos_CallbackFcn,'H','peak'})

uimenu(ListBoxMenu,'Label','Open data viewer','Callback',@mapViewerNew_CallbackFcn);
% uimenu(plotMenu,'Label','3D Map Viewer','Separator','On','Callback',@mapViewer_CallbackFcn);

uimenu(plotMenu,'Label','Volume Viewer','Callback',@volumeViewerCallback, ...
    'Separator','on');


uimenu(ListBoxMenu,'Label','Rename','Callback',@ListboxItemRename,'Separator','on');
uimenu(ListBoxMenu,'Label','Edit Variable','Callback',@Listbox_openvar);

LBM1 = uimenu(ListBoxMenu,'Label','Group','Separator','on');
LBM2=uimenu(LBM1,'Label','Add to');
    handles.AddMenus(1)=uimenu(LBM2,'Label',handles.GroupLabels{1},'Callback',@AddToGroup1);
    handles.AddMenus(2)=uimenu(LBM2,'Label',handles.GroupLabels{2},'Callback',@AddToGroup2);
    handles.AddMenus(3)=uimenu(LBM2,'Label',handles.GroupLabels{3},'Callback',@AddToGroup3);
    handles.AddMenus(4)=uimenu(LBM2,'Label',handles.GroupLabels{4},'Callback',@AddToGroup4);
LBM3=uimenu(LBM1,'Label','Move to');
    handles.MoveMenus(1)=uimenu(LBM3,'Label',handles.GroupLabels{1},'Callback',@MoveToGroup1);
    handles.MoveMenus(2)=uimenu(LBM3,'Label',handles.GroupLabels{2},'Callback',@MoveToGroup2);
    handles.MoveMenus(3)=uimenu(LBM3,'Label',handles.GroupLabels{3},'Callback',@MoveToGroup3);
    handles.MoveMenus(4)=uimenu(LBM3,'Label',handles.GroupLabels{4},'Callback',@MoveToGroup4);
uimenu(LBM1,'Label','Remove from current group','Callback',@RemoveFromGroup);

CBM1 = uimenu(ListBoxMenu,'Label','Combine');
uimenu(CBM1,'Label','2D cuts -> 3D','Callback',@pb_rearrange_2Dto3D_Callback);
uimenu(CBM1,'Label','Direct','Callback',@pb_combine_data_Callback);
uimenu(CBM1,'Label','Interp','Callback',@pb_combine_data_interp_Callback);
% uimenu(ListBoxMenu,'Label','Add Field','Callback',@pb_add_field_Callback);

NANM1 = uimenu(ListBoxMenu,'Label','Missing values');
uimenu(NANM1,'Label','Interpolate NaNs','Callback',@interp_nans_Callback)
uimenu(NANM1,'Label','Replace NaNs with zero','Callback',@replace_nans_Callback)

% BeamTime=uimenu(ListBoxMenu,'Label','Beamtime Tools','Separator','on');
% uimenu(BeamTime,'Label','Compare APE spin data','Callback',@spin_data_combine);
SVM1 = uimenu(ListBoxMenu,'Label','Save');
uimenu(SVM1,'Label','Save Variable(s)','Callback',@SaveVars_CallbackFcn);
uimenu(SVM1,'Label','Save to Separate Files','Callback',@SaveVarsSeparate_CallbackFcn);

uimenu(ListBoxMenu,'Label','Delete','Separator','on','Callback',@Delete_CallbackFcn);


handles.VarList = uitable('Parent',handles.GroupAll,'Units','normalized', ...
    'Position',[0 0 1 1],'Data',cell(0,3),'ColumnName',{'Name','Class','Size'}, ...
    'ColumnWidth',{130 100 55},'ColumnEditable',[false false false],'RowName',[], ...
    'CellSelectionCallback',@tableSelectionChanged,'KeyPressFcn',@tableKeyPressed, ...
    'UIContextMenu',ListBoxMenu,'Tag','VarList','FontUnits','points','FontSize',8);
setappdata(handles.VarList,'SelectedRows',[]);
actions = uiextras.HBox('Parent',left,'Spacing',3);
handles.GroupTarget = uicontrol('Parent',actions,'Style','popupmenu', ...
    'String',handles.GroupLabels,'Tag','GroupTarget');
uicontrol('Parent',actions,'String','Add','Callback',@(h,~)groupAction(h,'add'));
uicontrol('Parent',actions,'String','Move','Callback',@(h,~)groupAction(h,'move'));
uicontrol('Parent',actions,'String','Remove','Callback',@(h,~)groupAction(h,'remove'), ...
    'TooltipString','Remove selected data from the active group.');
uicontrol('Parent',actions,'String','Rename','Callback',@renameTarget);
set(actions,'Sizes',[-1 40 46 56 58]);
handles.TypeFilter = uibuttongroup('Parent',left,'BorderType','none','Tag','TypeFilter');
filterNames={'all','cut','map','kz','4d','1d'};
filterLabels={'All','Cut','Map','KZ','4D','1D'};
for k=1:numel(filterNames)
    uicontrol('Parent',handles.TypeFilter,'Style','radiobutton','Units','normalized', ...
        'Position',[(k-1)/6 0 1/6 1],'String',filterLabels{k}, ...
        'Tag',['Type_' filterNames{k}],'UserData',filterNames{k},'FontSize',8);
    if ismember(filterNames{k},{'cut','map','kz'})
        rgb=typeTextColor(filterNames{k});
        set(findobj(handles.TypeFilter,'Tag',['Type_' filterNames{k}]),'ForegroundColor',rgb);
    end
end
set(handles.TypeFilter,'SelectedObject',findobj(handles.TypeFilter,'Tag','Type_all'));
set(handles.TypeFilter,'SelectionChangedFcn',@UpdateVarList);
handles.GroupName=uicontrol('Parent',left,'Style','text','HorizontalAlignment','left', ...
    'String','','Tag','GroupStatus');
set(left,'Sizes',[18 24 -1 26 18 18]);
uicontrol('Parent',right,'Style','text','String','SELECTION DETAILS', ...
    'HorizontalAlignment','left','FontWeight','bold','ForegroundColor',[.12 .23 .38]);
uicontrol('Parent',right,'Style','text','String','Coordinates (stored axis units)', ...
    'HorizontalAlignment','left','FontWeight','bold');
handles.AxisTable=uitable('Parent',right,'Data',cell(4,6), ...
    'ColumnName',{'Axis','Min','Max','Count','Step','Check'}, ...
    'RowName',[],'ColumnWidth',{26 42 42 42 54 65},'Tag','AxisDetails');
metadataHeader=uiextras.HBox('Parent',right,'Spacing',3);
uicontrol('Parent',metadataHeader,'Style','text','String','Metadata (data.info)', ...
    'HorizontalAlignment','left','FontWeight','bold');
set(metadataHeader,'Sizes',-1);
handles.Metadata=uitable('Parent',right,'Data',cell(0,2),'RowName',[], ...
    'ColumnName',{'Field','Value / summary'},'ColumnWidth',{100 170},'Tag','Metadata');
editRow=uiextras.HBox('Parent',right,'Spacing',3);
uiextras.Empty('Parent',editRow);
handles.EditVariable=uicontrol('Parent',editRow,'String','Edit Variable', ...
    'Callback',@Listbox_openvar,'Tag','EditVariable');
set(editRow,'Sizes',[-1 92]);
set(right,'Sizes',[18 18 96 18 -1 24]);
% Keep labels, headings, edits and buttons consistent without changing the
% coordinate/metadata tables or global graphics defaults. Tabs use OS fonts.
set(findall(fig,'Type','uicontrol'),'FontUnits','points','FontSize',8);
guidata(fig,handles);
set(fig,'SizeChangedFcn',@resizeBrowser);
set(handles.GroupTabs,'SelectionChangedFcn',@groupTabChanged);
UpdateVarList(fig);
installTableMouseHandler(handles.VarList);

function plot_CallbackFcn(hObject,~,Direction)
    % Plot the first selected variable along the requested coordinate axis.
    UpdateVarList(hObject);
    handles=guidata(hObject);
    DataNames=handles.VarNames';

    switch Direction
        case 'x'
            PlotSlices(DataNames{1},'x');
        case 'y'
            PlotSlices(DataNames{1},'y');
        case 'z'
            PlotSlices(DataNames{1},'z');
        otherwise
            PlotSlices(DataNames{1},'x');
            PlotSlices(DataNames{1},'y');
            PlotSlices(DataNames{1},'z');
    end

function plotDos_CallbackFcn(hObject,~,Direction,NormaliseType)
    % Plot an integrated spectrum for each selected variable. Direction sets
    % whether counts or energy are on the horizontal axis; normalization is
    % applied to the integrated trace, not to the source workspace variable.
    % Direction: H or V. NormaliseType: raw, mean, or peak.
    UpdateVarList(hObject);
    handles=guidata(hObject);
    dataName=handles.VarNames';
    titleText = cell(numel(dataName), 1);

    figure;
    hold on

    for i = 1:numel(dataName)
        data = evalin('base',dataName{i});

        if ismatrix(data.value) && ~isvector(data.value)
            x = data.y;
            y = squeeze(sum(data.value,1))';
        elseif ndims(data.value) == 3
            x = data.z;
            data.value(isnan(data.value)) = 0;
            y = squeeze(sum(data.value,[1 2]))';
        elseif isvector(data.value)
            x = data.x;
            y = data.value;
        else
            errordlg('DOS plots support one-, two-, or three-dimensional data.', ...
                'Density of States');
            return;
        end

        switch NormaliseType
            case 'raw' % Keep the integrated values unchanged.
            case 'mean'
                y = y/mean(y,"all");
            case 'peak'
                y = y/max(y,[],"all");
            otherwise
                errordlg('Select a supported DOS normalization option.', ...
                    'Density of States');
                return;
        end

        switch Direction
            case 'H'
                plot(x,y);
                xlabel('Energy (eV)');
                ylabel('Counts (a.u.)');
            case 'V'
                plot(y,x);
                ylabel('Energy (eV)');
                xlabel('Counts (a.u.)');
            otherwise
                errordlg('Select a horizontal or vertical DOS plot.', ...
                    'Density of States');
                return;
        end

        titleText{i} = strrep(dataName{i}, '_', '\_');
    end

    hold off

    if isscalar(dataName)
        title(titleText{1});
    else
        legend(titleText{:});
    end


% function mapViewer_CallbackFcn(hObject,~)
%
%     UpdateVarList(hObject);
%     handles=guidata(hObject);
%     DataNames=handles.VarNames';
%
%     data = evalin('base',DataNames{1});
%     if isstruct(data)
%         data.name = DataNames{1};
%     end
%     OxArpes_DataViewer(data);

function mapViewerNew_CallbackFcn(hObject,~)
    % Dispatch supported 2-D, 3-D, and 4-D data to the matching ARPES viewer.
    UpdateVarList(hObject);
    handles=guidata(hObject);
    DataNames=handles.VarNames';

    data = evalin('base',DataNames{1});
    if isstruct(data)
        data.name = DataNames{1};
    end
    if ~hasDataMember(data, 'value')
        errordlg('The selected variable does not contain ARPES value data.', ...
            'Data Viewer');
        return;
    end
    if isvector(data.value)
        PlotData(hObject);
        return;
    end

    if ndims(data.value) == 3
        OxArpes_DataViewer_3D(data);
    elseif ismatrix(data.value)
        OxArpes_DataViewer_2D(data);
    elseif ndims(data.value) == 4
        OxArpes_DataViewer_4D(data);
    else
        errordlg(sprintf('The data viewer does not support %d-D arrays.', ...
            ndims(data.value)), 'Data Viewer');
    end

function volumeViewerCallback(hObject,~)
    % Open MATLAB's volume viewer for the selected 3-D value array. Scale
    % factors are estimated from the data axes before the viewer is launched.
    UpdateVarList(hObject);
    handles=guidata(hObject);
    DataNames=handles.VarNames';

    data = evalin('base',DataNames{1});
    requiredMembers = {'value', 'x', 'y', 'z'};
    hasRequiredMembers = all(cellfun(@(memberName) ...
        hasDataMember(data, memberName), requiredMembers));
    if ~hasRequiredMembers || ndims(data.value) ~= 3
        errordlg('Select a 3-D ARPES dataset with x, y, and z coordinates.', ...
            'Volume Viewer');
        return;
    end

    xAxis = data.x(:);
    yAxis = data.y(:);
    zAxis = data.z(:);
    if ~isnumeric(data.value) || ~isnumeric(xAxis) || ~isnumeric(yAxis) || ...
            ~isnumeric(zAxis) || ~isvector(data.x) || ~isvector(data.y) || ...
            ~isvector(data.z) || size(data.value, 1) ~= numel(xAxis) || ...
            size(data.value, 2) ~= numel(yAxis) || ...
            size(data.value, 3) ~= numel(zAxis)
        errordlg('The value array dimensions must match the x, y, and z axes.', ...
            'Volume Viewer');
        return;
    end

    xRange = max(xAxis) - min(xAxis);
    yRange = max(yAxis) - min(yAxis);
    zRange = max(zAxis) - min(zAxis);
    meanInPlaneRange = (xRange + yRange) / 2;
    if any(~isfinite(xAxis)) || any(~isfinite(yAxis)) || ...
            any(~isfinite(zAxis)) || ...
            any(~isfinite([xRange, yRange, zRange])) || ...
            any([xRange, yRange, zRange] <= 0) || meanInPlaneRange <= 0
        errordlg('The x, y, and z axes must have finite, nonzero ranges.', ...
            'Volume Viewer');
        return;
    end

    xStep = xRange / numel(xAxis);
    yStep = yRange / numel(yAxis);
    zStep = zRange / numel(zAxis);
    zRangeRatio = zRange / meanInPlaneRange;
    scaleFactors = [xStep / yStep, 1, zStep / yStep / zRangeRatio];
    try
        volumeViewer(permute(data.value, [2 1 3]), ScaleFactors=scaleFactors);
    catch exception
        errordlg(sprintf('MATLAB could not open the volume viewer:\n%s', ...
            exception.message), 'Volume Viewer');
    end



function SaveVarsSeparate_CallbackFcn(hObject,~)
    % Save each selected base-workspace variable to its own MAT-file in a
    % folder chosen by the user.
    UpdateVarList(hObject);
    handles=guidata(hObject);
    DataNames=handles.VarNames';
    if isempty(DataNames)
        return;
    end
    selpath = uigetdir;
    if isequal(selpath,0)
        return;
    end

    for i =1:length(DataNames)
        saveBaseVariables(fullfile(selpath,DataNames{i}),DataNames(i),false);
        disp(['Save ',DataNames{i}]);
    end

function SaveVars_CallbackFcn(hObject,~)
    % Save selected variables together. If the target file exists, the user
    % chooses whether to append, overwrite, or cancel.
    UpdateVarList(hObject);
    handles=guidata(hObject);
    DataNames=handles.VarNames';
    if isempty(DataNames)
        return;
    end
    [filename,pathname]=uiputfile('NewDataFile.mat',...
        'Select an existed file or input a new file name');
    % 'uisave' is more convenient, but it does not allow you to append vars,
    % thus I use uiputfile here.
    if isequal(filename,0)
        return;
    end
    fullfilename=fullfile(pathname,filename);
    if exist(fullfilename,'file')
        AppendFlag=questdlg([filename,...
            ' already exists. Would you like to append to it or overwrite it?'],...
            'Append or Overwrite','Append','Overwrite','Cancel','Append');
        switch AppendFlag
            case 'Append'
                saveBaseVariables(fullfilename,DataNames,true);
                disp(['Append to ',fullfilename]);
            case 'Overwrite'
                saveBaseVariables(fullfilename,DataNames,false);
                disp(['Overwrite ',fullfilename]);
            case 'Cancel'
                return;
        end
    else
        saveBaseVariables(fullfilename,DataNames,false);
        disp(['Save ',fullfilename]);
    end

function Delete_CallbackFcn(hObject,~)
    % Delete selected variables from the base workspace after confirmation.
    UpdateVarList(hObject);
    handles=guidata(hObject);
    %% Delete
    DataNames=handles.VarNames';
    Y='Yes';
    N='No';
    Msgs=cat(1,{'Are you sure to DELETE: '},DataNames);
    Option=questdlg(Msgs,'Variable Delete Warning',Y,N,'Cancel',Y);
    if ~strcmp(Option,Y)
        return;
    end
    for i=1:length(DataNames)
        evalin('base',['clear ',DataNames{i}]);
    end
    UpdateVarList(hObject);

function Listbox_openvar(hObject,~)
    % Open the first selected workspace variable in MATLAB's variable editor.
    UpdateVarList(hObject);
    handles=guidata(hObject);
    if isempty(handles.VarNames), return; end
    DataName=handles.VarNames{1};
    openvar(DataName);



%% ============= Group Selector Callback Functions===============
% Group selection changes the list filter. Add/Move/Remove callbacks below
% update the GroupInfo flags stored in each ARPES data object's INFO metadata.
function ListboxItemRename(hObject,varargin)
    % Rename the first selected base-workspace variable while preserving its
    % value. MATLAB variable-name rules are checked before assignment.
    handles=guidata(hObject);
    list_entries=variableNames(handles);
    index_selected=selectedRows(handles);
    if isempty(index_selected)
        return
    end
    oldname=list_entries{index_selected(1)};
    data=evalin('base',oldname);
    previousname=oldname;
    while(1)
       newname=inputdlg(['Please input the new name for ''' oldname ''''],'Rename',1,{previousname});
       if isempty(newname)
           return
       end
       if isvarname(newname{1})
           break
       end
       previousname=newname{1};
    end
    if evalin('base',['exist(''' newname{1} ''',''var'')'])==1
        errordlg(['''' newname{1} ''' already exists!']);
    else
        assignin('base',newname{1},data)
        evalin('base',['clear(''' oldname ''')'])
    end
    UpdateVarList(hObject);
%part092501
function AddToGroup1(hObject,varargin)
    AddToGroup(hObject,1);
function AddToGroup2(hObject,varargin)
    AddToGroup(hObject,2);
function AddToGroup3(hObject,varargin)
    AddToGroup(hObject,3);
function AddToGroup4(hObject,varargin)
    AddToGroup(hObject,4);

function AddToGroup(hObject,GroupNumber)
    changeMembership(hObject,'add',GroupNumber);

%part092501
function MoveToGroup1(hObject,varargin)
    MoveToGroup(hObject,1);
function MoveToGroup2(hObject,varargin)
    MoveToGroup(hObject,2);
function MoveToGroup3(hObject,varargin)
    MoveToGroup(hObject,3);
function MoveToGroup4(hObject,varargin)
    MoveToGroup(hObject,4);

function MoveToGroup(hObject,GroupNumber)
    changeMembership(hObject,'move',GroupNumber);

function RemoveFromGroup(hObject,varargin)
    changeMembership(hObject,'remove',0);

function pb_rearrange_2Dto3D_Callback(hObject,~)
% Collect selected datasets and prompt for the mapping coordinate used when
% arranging multiple 2-D cuts into one 3-D dataset.
handles=guidata(hObject);
listEntries = variableNames(handles);
selectedIndices = selectedRows(handles);
if isempty(selectedIndices) || all(strcmp(listEntries(selectedIndices), 'Empty'))
    errordlg('Select at least one dataset to rearrange.', 'Rearrange Data');
    return;
end
dataList = cell(numel(selectedIndices), 1);
for dataIndex = 1:numel(selectedIndices)
    variableName = listEntries{selectedIndices(dataIndex)};
    dataList{dataIndex} = evalin('base', variableName);
end

% create window for input of file name
filenamewindow = figure( 'Position', [500 400 200 150], ...
    'Name','Save 2D -> 3D',...
    'NumberTitle','off',...
    'MenuBar','none',...
    'IntegerHandle','off',...
    'HandleVisibility','on',...
    'Tag','enter file name');

% create vertical arrange of elements
vbox = uiextras.VBox('Parent', filenamewindow);

% create mapping selection
uicontrol('Parent',vbox,...
    'Style','text',...
    'String','Mapping by:');
Mapping_Selection = uicontrol('Parent',vbox,...
    'Style', 'popup',...
    'String', {'theta','phi','index'});

% create file name input
uicontrol('Parent', vbox,...
    'Style','text',...
    'String','Enter file name:');
FileName_Input = uicontrol('Parent',vbox,...
    'Style','edit',...
    'String','Map');

% save button
uicontrol('Parent',vbox,...
    'Style','pushbutton',...
    'String','Save',...
    'Callback',{@Rearrange_2Dto3D_Processing,FileName_Input,Mapping_Selection, ...
    dataList,filenamewindow});

function Rearrange_2Dto3D_Processing(~, ~, fileNameInput, mappingSelection, ...
        dataList, filenameWindow)
% Convert the selected mapping menu item to the mode expected by
% Rearrange2DTo3D, then publish the result in the base workspace.
outputName = strtrim(get(fileNameInput, 'String'));
mappingValue = get(mappingSelection, 'Value');
switch mappingValue
    case 1
        mappingBy = 'theta';
    case 2
        mappingBy = 'phi';
    case 3
        mappingBy = 'index';
    otherwise
        errordlg('Choose a valid mapping coordinate.', 'Rearrange Data');
        return;
end

if ~isvarname(outputName)
    errordlg('Enter a valid MATLAB variable name for the output.', ...
        'Rearrange Data');
    return;
end

dataOut = Rearrange2DTo3D(dataList, mappingBy);
assignin('base', outputName, dataOut);
set(filenameWindow, 'Visible', 'off');

%% Combine data
function pb_combine_data_Callback(hObject, ~)
% Concatenate selected maps directly when their Y axes match, then sort the
% combined X axis and reorder VALUE along its first dimension. The result is
% assigned to the fixed base-workspace name combinedMap.
handles=guidata(hObject);

listEntries = variableNames(handles);
selectedIndices = selectedRows(handles);
if isempty(selectedIndices) || all(strcmp(listEntries(selectedIndices), 'Empty'))
    errordlg('Select at least one ARPES dataset to combine.', 'Combine Data');
    return;
end

selectedData = cell(numel(selectedIndices), 1);
xAxes = cell(numel(selectedIndices), 1);
valueArrays = cell(numel(selectedIndices), 1);
for dataIndex = 1:numel(selectedIndices)
    variableName = listEntries{selectedIndices(dataIndex)};
    candidate = evalin('base', variableName);
    requiredMembers = {'value', 'x', 'y'};
    hasRequiredMembers = all(cellfun(@(memberName) ...
        hasDataMember(candidate, memberName), requiredMembers));
    if ~hasRequiredMembers
        errordlg(sprintf('Variable "%s" must contain value, x, and y data.', ...
            variableName), 'Combine Data');
        return;
    end

    value = candidate.value;
    xAxis = candidate.x(:);
    yAxis = candidate.y(:);
    if ~isnumeric(value) || ~isnumeric(xAxis) || ~isnumeric(yAxis) || ...
            ~isvector(candidate.x) || ~isvector(candidate.y) || ...
            any(~isfinite(xAxis)) || any(~isfinite(yAxis)) || ...
            ndims(value) > 3 || size(value, 1) ~= numel(xAxis) || ...
            size(value, 2) ~= numel(yAxis)
        errordlg(sprintf('Variable "%s" has invalid axes or array dimensions.', ...
            variableName), 'Combine Data');
        return;
    end

    if ndims(value) == 3
        if ~hasDataMember(candidate, 'z') || ~isnumeric(candidate.z) || ...
                ~isvector(candidate.z) || ...
                size(value, 3) ~= numel(candidate.z) || ...
                any(~isfinite(candidate.z(:)))
            errordlg(sprintf('Variable "%s" must have a valid z axis.', ...
                variableName), 'Combine Data');
            return;
        end
    end

    if dataIndex > 1
        reference = selectedData{1};
        referenceSize = size(reference.value);
        candidateSize = size(value);
        compatibleShape = isequal(referenceSize(2:end), candidateSize(2:end));
        compatibleAxes = isequal(reference.y(:), yAxis);
        if compatibleShape && ndims(value) == 3
            compatibleAxes = compatibleAxes && isequal(reference.z(:), candidate.z(:));
        end
        if ~compatibleShape || ~compatibleAxes
            errordlg(sprintf(['Variable "%s" has axes or dimensions that do not ' ...
                'match the first selected dataset. No result was created.'], ...
                variableName), 'Combine Data');
            return;
        end
    end

    selectedData{dataIndex} = candidate;
    xAxes{dataIndex} = xAxis;
    valueArrays{dataIndex} = value;
end

dataOut = selectedData{1};
try
    dataOut.x = vertcat(xAxes{:});
    dataOut.value = cat(1, valueArrays{:});
    [dataOut.x, sortOrder] = sort(dataOut.x);
    dataOut.value = dataOut.value(sortOrder, :, :);
catch exception
    errordlg(sprintf('The selected datasets could not be combined:\n%s', ...
        exception.message), 'Combine Data');
    return;
end
assignin('base', 'combinedMap', dataOut);

function pb_combine_data_interp_Callback(hObject, ~)
% Delegate coordinate alignment and combination to CombineData_interp. A
% nonempty result is assigned to the fixed workspace name combinedMapIn.
handles = guidata(hObject);
listEntries = variableNames(handles);
selectedIndices = selectedRows(handles);
if isempty(selectedIndices) || all(strcmp(listEntries(selectedIndices), 'Empty'))
    errordlg('Select at least one dataset to combine.', 'Combine Data');
    return;
end

selectedData = cell(numel(selectedIndices), 1);
for dataIndex = 1:numel(selectedIndices)
    variableName = listEntries{selectedIndices(dataIndex)};
    selectedData{dataIndex} = evalin('base', variableName);
end

combinedData = CombineData_interp(selectedData);
if ~isempty(combinedData)
    assignin('base', 'combinedMapIn', combinedData);
end

%% Rename callbacks
function tableSelectionChanged(hObject,event)
handles=guidata(hObject);
if isempty(event.Indices), return; end
setSelectedRows(handles,unique(event.Indices(:,1),'stable'));
handles.VarNames=selectedNames(handles);
guidata(handles.mObject,handles);
updateCounts(handles);
updateDetails(handles);

function installTableMouseHandler(table)
% The classic uitable consumes cell clicks before figure mouse callbacks.
% Isolate its legacy Swing bridge here; no Java handles escape the browser.
drawnow;
warningState=warning;
restoreWarnings=onCleanup(@()warning(warningState));
warning('off','MATLAB:ui:javaframe:PropertyToBeRemoved');
scroll=findjobj_2013(table);
peer=handle(scroll.getViewport.getView,'CallbackProperties');
set(peer,'MouseClickedCallback',@(~,event)tableMouseClicked(table,event));
setappdata(table,'MousePeer',peer);

function tableMouseClicked(table,event)
if ~isgraphics(table) || event.getButton()~=1 || event.getClickCount()~=2
    return;
end
% Resolve the clicked row, not a previously cached selection. Header and
% empty-space clicks return -1 and cannot plot an unrelated variable.
peer=event.getSource();
row=double(peer.rowAtPoint(event.getPoint()))+1;
handles=guidata(table);
if row<1 || row>numel(variableNames(handles)), return; end
setSelectedRows(handles,row);
handles.VarNames=selectedNames(handles);
guidata(handles.mObject,handles);
updateCounts(handles);
updateDetails(handles);
PlotData(table);

function tableKeyPressed(hObject,event)
if strcmp(event.Key,'return'), PlotData(hObject); end

function PlotData(hObject,varargin)
% Plot a selected variable according to its value-array dimensionality. The
% OxArpes_1D_Data class supplies its own SHOW method; other 1-D arrays use PLOT.

    handles = guidata(hObject);
    listEntries = variableNames(handles);
    selectedIndices = selectedRows(handles);
    if isempty(selectedIndices)
        return;
    end

    variableName = listEntries{selectedIndices(1)};
    data = evalin('base', variableName);
    if ~hasDataMember(data, 'value')
        return;
    end

    if isvector(data.value)
        if isa(data, 'OxArpes_1D_Data')
            data.show();
            return;
        end

        if hasDataMember(data, 'x') && numel(data.x) == numel(data.value)
            xAxis = data.x(:);
            xLabel = 'x';
        else
            xAxis = (1:numel(data.value))';
            xLabel = 'Index';
        end
        figure;
        plot(xAxis, data.value(:));
        if isstruct(data)
            xLabel = arpes_axis_label(data, 'x');
            ylabel(arpes_axis_label(data, 'v'));
        end
        xlabel(xLabel);
    elseif ismatrix(data.value) || ndims(data.value) == 3
        PlotSlices(variableName, 'z');
    elseif ndims(data.value) == 4
        OxArpes_DataViewer_4D(data);
    else
        errordlg(sprintf('Plotting is not supported for %d-D arrays.', ...
            ndims(data.value)), 'Data Browser');
    end

%% Refresh variable list and selected-data information
function hasMember = hasDataMember(data, memberName)
% Test for a field or property on a scalar ARPES data value.
    if isstruct(data)
        hasMember = isscalar(data) && isfield(data, memberName);
    elseif isobject(data)
        hasMember = isscalar(data) && isprop(data, memberName);
    else
        hasMember = false;
    end

%% NaNs
function interp_nans_Callback(hObject, ~)
    % Interpolate missing values via InterpNaNs and store each result under a
    % new name ending in _inan; source variables are left unchanged.
    handles=guidata(hObject);
    list_entries = handles.VarNames;

    for i=1:length(list_entries)
        varname=list_entries{i};
        data=evalin('base',varname);
        data_inan=InterpNaNs(data);
        assignin('base',[varname '_inan'],data_inan)
    end
    UpdateVarList(hObject);

function replace_nans_Callback(hObject, ~)
    % Replace NaNs in a local copy and publish it under the _onan suffix; the
    % original base-workspace variable remains unchanged.
    handles=guidata(hObject);
    list_entries = handles.VarNames;

    for i=1:length(list_entries)
        varname=list_entries{i};
        data=evalin('base',varname);
        data.value(isnan(data.value))=0;
        assignin('base',[varname '_onan'],data)
    end
    UpdateVarList(hObject);

function saveBaseVariables(fileName,variableNames,appendToFile)
    % Collect named variables from the base workspace into a struct and save
    % its fields, either creating/replacing the MAT-file or appending to it.
    if ischar(variableNames)
        variableNames={variableNames};
    end
    baseVariables=struct();
    for variableIndex=1:numel(variableNames)
        variableName=variableNames{variableIndex};
        if ~isvarname(variableName) || ~evalin('base',sprintf('exist(''%s'',''var'')',variableName))
            error('yulinARPES:MissingWorkspaceVariable', ...
                'Workspace variable ''%s'' is no longer available.',variableName);
        end
        baseVariables.(variableName)=evalin('base',variableName);
    end
    if appendToFile
        save(fileName,'-struct','baseVariables','-append');
    else
        save(fileName,'-struct','baseVariables');
    end

function buildMenus(fig)
top=uimenu(fig,'Label','Load');
uimenu(top,'Label','ARPES loader (new)','Callback',@(~,~)loader_UI);
parent=uimenu(top,'Label','Import data');
uimenu(parent,'Label','ARPES loader (classic)','Callback',@LoadDataARPES.main);
uimenu(parent,'Label','Sync and load','Callback',@(~,~)OxArpes_Sync);
parent=uimenu(top,'Label','Convert coordinates');
uimenu(parent,'Label','Cut to momentum','Callback',@k_space_conversion_cut);
uimenu(parent,'Label','Map to momentum (method 1)','Callback',@k_space_conversion_demo);
uimenu(parent,'Label','Map to momentum (method 2)','Callback',@flash_k_space_conversion_v2);
uimenu(parent,'Label','Photon scan to kz','Callback',@plotKZ);
uimenu(parent,'Label','Elettra nano map','Callback',@CombineData_Micro_new);
top=uimenu(fig,'Label','Visualize');
parent=uimenu(top,'Label','Cuts and spectra');
uimenu(parent,'Label','Arbitrary cut (2D)','Callback',@arbi_cut_plot_demo);
uimenu(parent,'Label','Arbitrary cut (3D)','Callback',@arbicut_3d_plot);
uimenu(parent,'Label','EDC / MDC spectra','Callback',@EDC_MDC_plot);
parent=uimenu(top,'Label','Volumes and viewers');
uimenu(parent,'Label','4D viewer','Callback',@Viewer4D.main);
uimenu(parent,'Label','3D slices','Callback',@slice_3d_plot);
uimenu(parent,'Label','3D volume','Callback',@volume_3d_plot_w_notch);
uimenu(parent,'Label','Render ARPES data','Callback',@RenderDataARPES);
parent=uimenu(top,'Label','Plot tools');
uimenu(parent,'Label','Plot formatting tools','Callback',@plot_tools2_demo);
uimenu(parent,'Label','Plot BZ','Callback',@brillouin_zone_plot);
uimenu(parent,'Label','Mini BZ plotter','Callback',@MiniBZ_plotter);
parent=top;
uimenu(parent,'Label','Plot BZ (new)','Callback',@plotBZ_V1,'Separator','on');
uimenu(parent,'Label','KZ cut simulation','Callback',@kz_plot);
top=uimenu(fig,'Label','Process');
parent=uimenu(top,'Label','Resample and crop');
uimenu(parent,'Label','Interpolate data','Callback',@data_interpolation_demo);
uimenu(parent,'Label','Combine / resample','Callback',@data_comb_resamp_demo);
uimenu(parent,'Label','Crop data','Callback',@td_demo);
parent=uimenu(top,'Label','Combine data');
uimenu(parent,'Label','Add value arrays','Callback',@add_two_value_arrays);
uimenu(parent,'Label','Combine spin data','Callback',@spin_data_combine);
uimenu(parent,'Label','Combine kz scan','Callback',@CombineDataForKZ);
uimenu(parent,'Label','Combine maps','Callback',@CombineDataForMAP);
parent=uimenu(top,'Label','Normalize');
uimenu(parent,'Label','Self normalization','Callback',@self_normalization_demo);
uimenu(parent,'Label','Normalization tool','Callback',@(~,~)OxArpes_Normalise);
parent=uimenu(top,'Label','Fine structure');
uimenu(parent,'Label','Curvature','Callback',@Curvature);
uimenu(parent,'Label','Gradient','Callback',@Gradient);
uimenu(parent,'Label','Smooth derivation','Callback',@smooth_derivation_v1);
uimenu(parent,'Label','Mirror','Callback',@(~,~)data_mirror_symmetrize);
uimenu(parent,'Label','Ridge detection','Callback',@ridge_detection);
uimenu(parent,'Label','Fine structure tool','Callback',@(~,~)OxArpes_FineStructure);
uimenu(top,'Label','Processing toolbox','Callback',@(~,~)OxArpes_DataProcess,'Separator','on');
top=uimenu(fig,'Label','Analyze');
parent=uimenu(top,'Label','Fit spectra');
uimenu(parent,'Label','Fit MDC','Callback',@fit_MDC_demo_20150312);
uimenu(parent,'Label','Fit Fermi level','Callback',@FitFermiSurface);
uimenu(parent,'Label','Fit effective mass','Callback',@EmassFitting);
parent=uimenu(top,'Label','Models and calculations');
uimenu(parent,'Label','Tight binding (2D)','Callback',@GUI_for_2D);
uimenu(parent,'Label','Tight binding (3D)','Callback',@GUI_for_3D);
uimenu(parent,'Label','Import WIEN2k / BXSF','Callback',@quick_bxsf2mat);
uimenu(parent,'Label','Resolution calculator','Callback',@(~,~)OxArpes_ResolutionCalculator);
function names = selectedNames(handles)
entries=cellstr(variableNames(handles));
indices=selectedRows(handles);
indices=indices(indices>=1 & indices<=numel(entries));
names=entries(indices);
names=names(~cellfun('isempty',names));

function group = activeGroup(handles)
group=get(get(handles.GroupTabs,'SelectedTab'),'UserData');

function setGroup(hObject,group)
validateattributes(group,{'numeric'},{'scalar','integer','>=',0,'<=',4});
handles=guidata(hObject);
if group==0, tab=handles.GroupAll; else, tab=handles.(sprintf('Group%d',group)); end
set(handles.GroupTabs,'SelectedTab',tab);
UpdateVarList(hObject);

function groupTabChanged(hObject,~)
UpdateVarList(hObject);

function groupAction(hObject,mode)
handles=guidata(hObject);
changeMembership(hObject,mode,get(handles.GroupTarget,'Value'));

function renameTarget(hObject,~)
handles=guidata(hObject);
k=get(handles.GroupTarget,'Value');
name=inputdlg('Group name:','Rename group',1,handles.GroupLabels(k));
if ~isempty(name), applyGroupName(hObject,k,name{1}); end

function applyGroupName(hObject,k,name)
validateattributes(k,{'numeric'},{'scalar','integer','>=',1,'<=',4});
name=strtrim(char(name));
if isempty(name) || size(name,1)~=1 || numel(name)>24
    error('ARPES:GroupName','Use a group name of 1 to 24 characters.');
end
handles=guidata(hObject);
handles.GroupLabels{k}=name;
setpref('ARPESDataBrowserV5','GroupNames',handles.GroupLabels);
set(handles.GroupTarget,'String',handles.GroupLabels);
set(handles.AddMenus(k),'Label',name);
set(handles.MoveMenus(k),'Label',name);
guidata(handles.mObject,handles);
UpdateVarList(hObject);

function flags = membership(data)
flags=false(1,4);
if hasDataMember(data,'info') && isstruct(data.info) && isscalar(data.info) && ...
        isfield(data.info,'GroupInfo')
    raw=data.info.GroupInfo;
    if (isnumeric(raw) || islogical(raw)) && isreal(raw)
        n=min(4,numel(raw));
        flags(1:n)=raw(1:n)==1;
    end
end

function changeMembership(hObject,mode,target)
mode=validatestring(mode,{'add','move','remove'});
validateattributes(target,{'numeric'},{'scalar','integer','>=',0,'<=',4});
handles=guidata(hObject);
source=activeGroup(handles);
if strcmp(mode,'remove')
    target=source;
end
if target==0
    set(handles.GroupName,'TooltipString','Choose a group before removing membership.');
    return;
end
names=selectedNames(handles);
changed=0; skipped=0;
for k=1:numel(names)
    data=evalin('base',names{k});
    if ~hasDataMember(data,'value') || (~isstruct(data) && ~hasDataMember(data,'info'))
        skipped=skipped+1; continue;
    end
    if hasDataMember(data,'info') && ~isempty(data.info) && ...
            (~isstruct(data.info) || ~isscalar(data.info))
        skipped=skipped+1; continue;
    end
    flags=membership(data);
    if strcmp(mode,'remove')
        flags(target)=false;
    else
        if strcmp(mode,'move') && source>0 && source~=target
            flags(source)=false;
        end
        flags(target)=true;
    end
    if ~hasDataMember(data,'info') || isempty(data.info), data.info=struct; end
    data.info.GroupInfo=double(flags);
    assignin('base',names{k},data);
    changed=changed+1;
end
UpdateVarList(hObject);
set(handles.GroupName,'TooltipString',sprintf('%d updated; %d skipped (unsupported metadata).',changed,skipped));

function UpdateVarList(hObject,varargin)
handles=guidata(hObject);
previous=selectedNames(handles);
names=evalin('base','who');
counts=zeros(1,4);
flags=false(numel(names),4);
typeMatches=false(size(names));
filter=activeTypeFilter(handles);
for k=1:numel(names)
    data=evalin('base',names{k});
    flags(k,:)=membership(data);
    typeMatches(k)=matchesDataType(data,filter);
end
counts(:)=sum(flags,1);
group=activeGroup(handles);
for k=1:4
    set(handles.(sprintf('Group%d',k)),'Title',handles.GroupLabels{k});
end
tab=get(handles.GroupTabs,'SelectedTab');
if ~isequal(get(handles.VarList,'Parent'),tab)
    set(handles.VarList,'Parent',tab);
end
keep=typeMatches;
if group>0, keep=keep & flags(:,group); end
query=lower(strtrim(get(handles.Search,'String')));
if ~isempty(query), keep=keep & contains(lower(string(names)),query); end
names=names(keep);
[found,indices]=ismember(previous,names);
indices=indices(found);
workspace=evalin('base','whos');
[~,locations]=ismember(names,{workspace.name});
tableData=cell(numel(names),3);
for k=1:numel(names)
    item=workspace(locations(k));
    tableData(k,:)={names{k},coloredClassText(item.class),storageSize(item.bytes)};
end
set(handles.VarList,'Data',tableData);
if isempty(indices) && ~isempty(names), indices=1; end
setSelectedRows(handles,indices);
handles.VarNames=selectedNames(handles);
handles.WorkspaceCount=size(flags,1);
if group==0, handles.GroupCount=size(flags,1); else, handles.GroupCount=counts(group); end
updateCounts(handles);
guidata(handles.mObject,handles);
updateDetails(handles);

function updateDetails(handles)
names=selectedNames(handles);
set(handles.AxisTable,'Data',cell(0,6));
set(handles.Metadata,'Data',cell(0,2));
set(handles.EditVariable,'Enable','off');
if isempty(names), return; end
set(handles.EditVariable,'Enable','on');
data=evalin('base',names{1});
value=data;
if hasDataMember(data,'value'), value=data.value; end
if hasDataMember(data,'value')
    axisNames={'x','y','z','t'};
    dimensions=ndims(value);
    if isvector(value), dimensions=1; end
    rows=cell(dimensions,6);
    for k=1:size(rows,1)
        axisName=axisNames{min(k,4)};
        n=size(value,k);
        if k==1 && isvector(value), n=numel(value); end
        row={upper(axisName),'index','index',n,'index','No coordinate axis'};
        if hasDataMember(data,axisName)
            a=data.(axisName);
            if isnumeric(a) && isreal(a) && isvector(a) && ~isempty(a) && all(isfinite(a(:)))
                row={upper(axisName),sprintf('%.2f',min(a)),sprintf('%.2f',max(a)),numel(a),'n/a','OK'};
                if numel(a)>1
                    d=diff(double(a(:)));
                    if max(abs(d-d(1)))<=max(1e-12,1e-6*max(abs(d)))
                        row{5}=d(1);
                    else
                        row{5}='nonuniform';
                    end
                end
                if numel(a)~=n, row{6}=sprintf('Expected %d samples',n); end
            else
                row={upper(axisName),'invalid','invalid',numel(a),'n/a','Check coordinate axis'};
            end
        end
        rows(k,:)=row;
    end
    set(handles.AxisTable,'Data',rows);
end
metadata=cell(0,2);
if hasDataMember(data,'info')
    contents=data.info;
    if isstruct(contents) && isscalar(contents)
        fields=fieldnames(contents);
        metadata=cell(numel(fields),2);
        for k=1:numel(fields)
            metadata(k,:)={fields{k},describeValue(contents.(fields{k}))};
        end
    elseif ~isempty(contents)
        metadata={'info',describeValue(contents)};
    end
end
set(handles.Metadata,'Data',metadata);

function text = describeValue(value)
if ischar(value) && isrow(value)
    text=value;
elseif isstring(value) && isscalar(value)
    text=char(value);
elseif (isnumeric(value) || islogical(value)) && ismatrix(value) && numel(value)<=12
    text=mat2str(value,6);
else
    text=sprintf('%s [%s]',class(value),strjoin(cellstr(string(size(value))),' x '));
end
if numel(text)>400, text=[text(1:397) '...']; end

function resizeBrowser(fig,~)
position=get(fig,'Position');
minimum=[600 450];
if any(position(3:4)<minimum)
    position(3:4)=max(position(3:4),minimum);
    set(fig,'Position',position);
end

function names = variableNames(handles)
data=get(handles.VarList,'Data');
names=data(:,1);

function rows = selectedRows(handles)
rows=getappdata(handles.VarList,'SelectedRows');
rows=rows(rows>=1 & rows<=size(get(handles.VarList,'Data'),1));

function setSelectedRows(handles,rows)
rows=unique(rows(:)','stable');
n=size(get(handles.VarList,'Data'),1);
rows=rows(rows>=1 & rows<=n);
setappdata(handles.VarList,'SelectedRows',rows);
% Classic figures lack the documented programmatic Selection property.
% Full-row background colours also make API-selected rows visible.
colors=repmat([1 1 1],max(1,n),1);
colors(2:2:end,:)=repmat([.95 .98 .95],floor(max(1,n)/2),1);
colors(rows,:)=repmat([.77 .87 .97],numel(rows),1);
set(handles.VarList,'BackgroundColor',colors);

function updateCounts(handles)
set(handles.GroupName,'String',sprintf('All: %d | Group: %d | Shown: %d | Selected: %d', ...
    handles.WorkspaceCount,handles.GroupCount,numel(variableNames(handles)),numel(selectedRows(handles))));

function text = storageSize(bytes)
units={'B','KiB','MiB','GiB','TiB','PiB'};
value=double(bytes); unit=1;
% Promote before 3-digit rounding would produce a four-digit mantissa.
while value>=999.5 && unit<numel(units)
    value=value/1024; unit=unit+1;
end
text=sprintf('%.3g %s',value,units{unit});

function type = activeTypeFilter(handles)
type=get(get(handles.TypeFilter,'SelectedObject'),'UserData');

function setTypeFilter(fig,type)
type=validatestring(type,{'all','cut','map','kz','4d','1d'});
handles=guidata(fig);
set(handles.TypeFilter,'SelectedObject',findobj(handles.TypeFilter,'Tag',['Type_' type]));
UpdateVarList(fig);

function match = matchesDataType(data,type)
switch type
    case 'all'
        match=true;
    case 'cut'
        match=isa(data,'OxA_CUT');
    case 'map'
        match=isa(data,'OxA_MAP') || isa(data,'OxA_MAP_ToF');
    case 'kz'
        match=isa(data,'OxA_KZ');
    case '4d'
        match=isa(data,'OxArpes_4D_Data');
    case '1d'
        match=isa(data,'OxArpes_1D_Data');
end

function text = coloredClassText(className)
switch className
    case 'OxA_CUT'
        type='cut';
    case {'OxA_MAP','OxA_MAP_ToF'}
        type='map';
    case 'OxA_KZ'
        type='kz';
    otherwise
        text=className;
        return;
end
rgb=typeTextColor(type);
hex=sprintf('#%02X%02X%02X',round(255*rgb));
% Only class cells contain markup; variable names stay literal for callbacks.
text=sprintf('<html><font color="%s">%s</font></html>',hex,className);

function rgb = typeTextColor(type)
switch type
    case 'cut'
        rgb=[23 102 166]/255;
    case 'map'
        rgb=[22 115 74]/255;
    case 'kz'
        rgb=[138 62 168]/255;
end
