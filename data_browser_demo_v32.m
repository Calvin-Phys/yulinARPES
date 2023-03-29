function data_browser_demo_v32
% Bug report: han.peng@physics.ox.ac.uk
%

h=findobj('Tag','DataBrowser');
if ~isempty(h)
    h=h(1);
    figure(h);
    return;
end

handles.mObject = figure('Position',[500 200 300 450],...
    'Name','Data Browser',...
    'NumberTitle','off',...
    'MenuBar','none',...
    'IntegerHandle','off',...
    'HandleVisibility','on',...
    'Tag','DataBrowser');

VBoxHome = uiextras.VBox('Parent',handles.mObject);

%% menu redo
LoaderMenu = uimenu(handles.mObject,'Label','Loader');
uimenu(LoaderMenu,'Label','Load ARPES Data','Callback',@LoadDataARPES.main);
uimenu(LoaderMenu,'Label','Load ARPES Data (Object)','Callback',@loader_UI);
uimenu(LoaderMenu,'Label','Cut conversion','Callback',@k_space_conversion_cut,'Separator','On');
uimenu(LoaderMenu,'Label','Map conversion 1','Callback',@k_space_conversion_demo);
uimenu(LoaderMenu,'Label','Map conversion 2','Callback',@flash_k_space_conversion_v2);
uimenu(LoaderMenu,'Label','KZ conversion','Callback',@plotKZ);
uimenu(LoaderMenu,'Label','Elettra Nano Map','Callback',@CombineData_Micro_new,'Separator','On');

VisualMenu = uimenu(handles.mObject,'Label','Visualization');
uimenu(VisualMenu,'Label','Arbitrary cut plot','Callback',@arbi_cut_plot_demo);
uimenu(VisualMenu,'Label','Arbitrary cut plot 3D','Callback',@arbicut_3d_plot);
uimenu(VisualMenu,'Label','EDC MDC plot','Callback',@EDC_MDC_plot);
uimenu(VisualMenu,'Label','Slice 3D plot','Callback',@slice_3d_plot,'Separator','On');
uimenu(VisualMenu,'Label','Volume 3D plot','Callback',@volume_3d_plot_w_notch);
uimenu(VisualMenu,'Label','Viewer4D','Callback',@Viewer4D.main);
uimenu(VisualMenu,'Label','Plot Tools','Callback',@plot_tools2_demo,'Separator','On');
uimenu(VisualMenu,'Label','Plot BZ','Callback',@plotBZ_V1);
uimenu(VisualMenu,'Label','plot BZ 2','Callback',@brillouin_zone_plot);
uimenu(VisualMenu,'Label','Plot cut in kz','Callback',@kz_plot);
uimenu(VisualMenu,'Label','MiniBZ plotter','Callback',@MiniBZ_plotter);
uimenu(VisualMenu,'Label','RenderDataARPES','Callback',@RenderDataARPES);


ProcessMenu = uimenu(handles.mObject,'Label','Process');
uimenu(ProcessMenu,'Label','Data Interpolation','Callback',@data_interpolation_demo);
uimenu(ProcessMenu,'Label','Data combine/resample','Callback',@data_comb_resamp_demo);
uimenu(ProcessMenu,'Label','Data truncate','Callback',@td_demo);
uimenu(ProcessMenu,'Label','Self Normalization','Callback',@self_normalization_demo);
uimenu(ProcessMenu,'Label','Add two value arrays','Callback',@add_two_value_arrays,'Separator','On');
uimenu(ProcessMenu,'Label','Spin data combine','Callback',@spin_data_combine);
uimenu(ProcessMenu,'Label','Combine Data For KZ','Callback',@CombineDataForKZ,'Separator','On');
uimenu(ProcessMenu,'Label','Combine Data For MAP','Callback',@CombineDataForMAP);



FineStructureMenu = uimenu(ProcessMenu,'Label','Fine Structure','Separator','On');
uimenu(FineStructureMenu,'Label','Curvature','Callback',@Curvature);
uimenu(FineStructureMenu,'Label','Gradient','Callback',@Gradient);
uimenu(FineStructureMenu,'Label','Smooth derivation','Callback',@smooth_derivation_v1);
uimenu(FineStructureMenu,'Label','Mirror','Callback',@data_mirror_symmetrize);
uimenu(FineStructureMenu,'Label','Ridge detection','Callback',@ridge_detection);

ToolsMenu = uimenu(handles.mObject,'Label','Tools');

uimenu(ToolsMenu,'Label','Fit MDC ','Callback',@fit_MDC_demo_20150312);
uimenu(ToolsMenu,'Label','Fit Fermi Level','Callback',@FitFermiSurface);
uimenu(ToolsMenu,'Label','Tight Binding 2D','Callback',@GUI_for_2D,'Separator','On');
uimenu(ToolsMenu,'Label','Tight Binding 3D','Callback',@GUI_for_3D);
uimenu(ToolsMenu,'Label','Emass Fitting','Callback',@EmassFitting);
uimenu(ToolsMenu,'Label','Wien2k','Callback',@quick_bxsf2mat);



%% VarList Menu
ListBoxMenu = uicontextmenu;
uimenu(ListBoxMenu,'Label','Rename','Callback',@ListboxItemRename);
LBM2=uimenu(ListBoxMenu,'Label','Add to Group');
    uimenu(LBM2,'Label','To Group 1','Callback',@AddToGroup1);
    uimenu(LBM2,'Label','To Group 2','Callback',@AddToGroup2);
    uimenu(LBM2,'Label','To Group 3','Callback',@AddToGroup3);
    uimenu(LBM2,'Label','To Group 4','Callback',@AddToGroup4);
LBM3=uimenu(ListBoxMenu,'Label','Move to Group');
    uimenu(LBM3,'Label','To Group 1','Callback',@MoveToGroup1);
    uimenu(LBM3,'Label','To Group 2','Callback',@MoveToGroup2);
    uimenu(LBM3,'Label','To Group 3','Callback',@MoveToGroup3);
    uimenu(LBM3,'Label','To Group 4','Callback',@MoveToGroup4);
uimenu(ListBoxMenu,'Label','Remove from Group','Callback',@RemoveFromGroup);
uimenu(ListBoxMenu,'Label','Combine 2D cuts -> 3D','Separator','On','Callback',@pb_rearrange_2Dto3D_Callback);
uimenu(ListBoxMenu,'Label','Combine Data (Direct)','Callback',@pb_combine_data_Callback);
uimenu(ListBoxMenu,'Label','Combine Data (Interp)','Callback',@pb_combine_data_interp_Callback);
uimenu(ListBoxMenu,'Label','Add Field','Callback',@pb_add_field_Callback);
uimenu(ListBoxMenu,'Label','Interp NaNs','Separator','on','Callback',@interp_nans_Callback)
uimenu(ListBoxMenu,'Label','Replace NaNs with zero','Callback',@replace_nans_Callback)
plotMenu=uimenu(ListBoxMenu,'Label','Plot','Separator','on');
uimenu(plotMenu,'Label','Along x','Callback',{@plot_CallbackFcn,'x'})
uimenu(plotMenu,'Label','Along y','Callback',{@plot_CallbackFcn,'y'})
uimenu(plotMenu,'Label','Along z','Callback',{@plot_CallbackFcn,'z'})
uimenu(plotMenu,'Label','All directions','Callback',{@plot_CallbackFcn,'all'})
uimenu(plotMenu,'Label','DOS, Vertical','Separator','On',...
    'Callback',{@plotDos_CallbackFcn,'V'})
uimenu(plotMenu,'Label','DOS, Horizontal',...
    'Callback',{@plotDos_CallbackFcn,'H'})
uimenu(plotMenu,'Label','3D Map Viewer','Separator','On',...
    'Callback',@mapViewer_CallbackFcn);
BeamTime=uimenu(ListBoxMenu,'Label','Beamtime Tools','Separator','on');
uimenu(BeamTime,'Label','Compare APE spin data','Callback',@spin_data_combine);

uimenu(ListBoxMenu,'Label','Save Variable(s)','Separator','on','Callback',@SaveVars_CallbackFcn);
uimenu(ListBoxMenu,'Label','Save Vars to Separate Files','Callback',@SaveVarsSeparate_CallbackFcn);
uimenu(ListBoxMenu,'Label','Delete Variable(s)','Separator','on','Callback',@Delete_CallbackFcn);


%% Group Choice Panel
% Panel: Group Choice

GroupMenu0=uicontextmenu();
%uimenu('Parent',GroupMenu0,'Label','Rename',...
%    'Callback',@Rename0_CallbackFcn)
GroupMenu1=uicontextmenu();
uimenu('Parent',GroupMenu1,'Label','Rename',...
    'Callback',@Rename1_CallbackFcn)
GroupMenu2=uicontextmenu();
uimenu('Parent',GroupMenu2,'Label','Rename',...
    'Callback',@Rename2_CallbackFcn)
GroupMenu3=uicontextmenu();
uimenu('Parent',GroupMenu3,'Label','Rename',...
    'Callback',@Rename3_CallbackFcn)
GroupMenu4=uicontextmenu();
uimenu('Parent',GroupMenu4,'Label','Rename',...
    'Callback',@Rename4_CallbackFcn)

% Panel: Group Choice
panel_GroupChoice=uiextras.HBox('Parent',VBoxHome);
handles.GroupAll=uicontrol('Parent',panel_GroupChoice,...
    'Style','pushbutton','String','ALL','Value',[0 0 0 0],...
    'uicontextmenu',GroupMenu0,...
    'CallBack',@Group0,'BackgroundColor',[248 248 235]/256);
handles.Group1=uicontrol('Parent',panel_GroupChoice,...
    'Style','pushbutton','String','Group1',...
    'uicontextmenu',GroupMenu1,...
    'CallBack',@Group1,'BackGroundColor',[255 222 173]/256);
handles.Group2=uicontrol('Parent',panel_GroupChoice,...
    'Style','pushbutton','String','Group2',...
    'uicontextmenu',GroupMenu2,...
    'CallBack',@Group2,'BackGroundColor',[107 142 35]/256);
handles.Group3=uicontrol('Parent',panel_GroupChoice,...
    'Style','pushbutton','String','Group3',...
    'uicontextmenu',GroupMenu3,...
    'CallBack',@Group3,'BackGroundColor',[147 112 219]/256);
handles.Group4=uicontrol('Parent',panel_GroupChoice,...
    'Style','pushbutton','String','Group4',...
    'uicontextmenu',GroupMenu4,...
    'CallBack',@Group4,'BackGroundColor',[126 192 238]/256);

%% Variable Listbox: Varlist
handles.GroupName=uicontrol('Parent',VBoxHome,...
    'Style','text','String','Current Folder: All');
handles.VarList=uicontrol('Parent',VBoxHome,...
    'Style','ListBox','BackgroundColor','w',...
    'Value',1,'Max',100,...
    'Callback',@VarList_CallbackFcn,...
    'uicontextmenu',ListBoxMenu,...
    'Tag','VarList');

%% Panel: Data Information
panel_DataInfo=uiextras.Panel('Parent',VBoxHome,'Title','Data Information',...
    'Padding',2,'ForegroundColor','blue','BorderType', 'etchedout');
grid1_panel_datainfo=uiextras.Grid('Parent',panel_DataInfo,'Spacing',3);
uiextras.Empty('Parent',grid1_panel_datainfo);
uicontrol('Parent',grid1_panel_datainfo,'Style','text','String','min')
uicontrol('Parent',grid1_panel_datainfo,'Style','text','String','max')
uicontrol('Parent',grid1_panel_datainfo,'Style','text','String','num')
uicontrol('Parent',grid1_panel_datainfo,'Style','text','String','step')
uicontrol('Parent',grid1_panel_datainfo,'Style','text','String','X')
handles.datainfo_x_min=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
handles.datainfo_x_max=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
handles.datainfo_x_no=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
handles.datainfo_x_stepsize=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
uicontrol('Parent',grid1_panel_datainfo,'Style','text','String','Y');
handles.datainfo_y_min=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
handles.datainfo_y_max=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
handles.datainfo_y_no=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
handles.datainfo_y_stepsize=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
uicontrol('Parent',grid1_panel_datainfo,'Style','text','String','Z');
handles.datainfo_z_min=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
handles.datainfo_z_max=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
handles.datainfo_z_no=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
handles.datainfo_z_stepsize=uicontrol('Parent',grid1_panel_datainfo,'Style','text','BackgroundColor','white');
set(grid1_panel_datainfo,'ColumnSizes',[25 -1 -1 -1],'RowSizes',[-1 -1 -1 -1 -1])


%% 
set(VBoxHome,'Sizes',[25,15,-1,100]);
handles.CurrentFolder = [];
guidata(handles.mObject,handles);

%% ========= Mainmenu Callback Functions ================
function help_callpack(hObject,~)
handles = guidata(hObject);
h = msgbox('Bug report: han.peng@physics.ox.ac.uk','Help and About');
Position0 = getpixelposition(handles.mObject);
Position = getpixelposition(h);
setpixelposition(h,[Position0(1)+Position0(3)/5,Position0(2)+3*Position0(4)/4,...
    Position(3),Position(4)])

function SavePanelSetting(hObject,evt)
handles = guidata(hObject);
GuiList = handles.GuiList;
Option=questdlg('Really want to save current configuration?',...
    'Save Configuration?','Yes','No','Cancel','Yes');
if ~strcmp(Option,'Yes')
    return;
end
p=which(mfilename);
p=regexp(p,'.*\','match');
p=[p{1},'data_browser_config.mat'];
h=findall(0,'Tag',GuiList{1}{1}.Tag);
index = 1;
if isempty(h)
    errordlg('Please open Data Browser');
end
if length(h)>1
    errordlg('Please Close Extra Data Browser Panels and Keep Only One')
end
Position0=getpixelposition(h);
data_browser_config{index}.Tag = 'DataBrowser';
data_browser_config{index}.Position = [0,0,Position0(3),Position0(4)];

for i =2:length(GuiList)
    for j = 1:length(GuiList{i})
    h1=findall(0,'Tag',GuiList{i}{j}.Tag);
    if ~isempty(h1)
        index = index+1;
        Position=getpixelposition(h1(1));
        Position(1)=Position(1)-Position0(1);
        Position(2)=Position(2)-Position0(2);
        data_browser_config{index}.Tag = GuiList{i}{j}.Tag;
        data_browser_config{index}.Position = Position;
    end
    end
end
save(p,'data_browser_config','-append');

function LoadPanelSetting(hObject,evt)
p=which(mfilename);
p=regexp(p,'.*\','match');
p=[p{1},'data_browser_config.mat'];
try
    load(p);
catch
    errordlg('Faild to load config file. Please save a config first.')
end


h0=findall(0,'Tag','DataBrowser');
if isempty(h0)
    errordlg('Please open Data Browser');
end
if length(h0)>1
    errordlg('Please Close Extra Data Browser Panels and Keep Only One')
end
Position0=getpixelposition(h0);
for i = 1:length(data_browser_config);
    Tag=data_browser_config{i}.Tag;
    Position=data_browser_config{i}.Position+[Position0(1),Position0(2),0,0];
    h=findall(0,'Tag',Tag);
    if ~isempty(h)
        setpixelposition(h(1),Position);
        figure(h(1));
    end
end
figure(h0);

function PanelSetting0(hObject,evt)
p=which(mfilename);
p=regexp(p,'.*\','match');
p=[p{1},'data_browser_config.mat'];
try
    load(p);
catch
    errordlg('Faild to find config file.')
end


h=findall(0,'Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
end
if length(h)>1
    errordlg('Please Close Extra Data Browser Panels and Keep Only One')
end
Position0=getpixelposition(h);
for i = 1:length(data_browser_config_def);
    Tag=data_browser_config_def{i}.Tag;
    Position=data_browser_config_def{i}.Position+[Position0(1),Position0(2),0,0];
    h=findall(0,'Tag',Tag);
    if ~isempty(h)
        setpixelposition(h(1),Position);
        figure(h(1));
    end
end

function load_data_auto( hObject, eventdata )
% hObject    handle to pb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles=guidata( hObject );
%%
DirRes=dir(handles.LoadPath);
% Get the files + directories names
[ListNames{1:length(DirRes),1}] = deal(DirRes.name);

% Get directories only
[DirOnly{1:length(DirRes),1}] = deal(DirRes.isdir);

% Turn into logical vector and take complement to get indexes of files
FilesOnly = ~cat(1, DirOnly{:});
list_entries = ListNames(FilesOnly);
n=length(list_entries);

h=waitbar(0,'0%','Name','Loading');
for i=1:n
    name = list_entries{i};
    try
    if load_scienta_general_txt_BZ(fullfile(handles.LoadPath,name))
    elseif load_scienta_manipulator_scan_txt_BZ(fullfile(handles.LoadPath,name))
    elseif load_Elettra_hdf5_BZ(fullfile(handles.LoadPath,name))
    elseif load_fits_file_fun_BZ(fullfile(handles.LoadPath,name))
    elseif load_Diamond_hdf5_xmas(fullfile(handles.LoadPath,name))
%        disp('1');
%     elseif load_fits_file_fun_BL7_BZ(fullfile(cd,name))
    end
    catch
        disp(['Failed to load ',name]);
    end
    waitbar(i/n,h,[num2str(round(i*100/n)) '%'])
end
close(h)

function load_data_auto_set( hObject,eventdata )
handles=guidata( hObject );
NewLoadPath = uigetdir(handles.LoadPath);
if NewLoadPath~=0
    handles.LoadPath = NewLoadPath;
    guidata(handles.mObject,handles);
end

%%  ==================== Varlist Menu ==================================
function plot_CallbackFcn(~,~,Direction)
DataNames=getDataNames;
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

function plotDos_CallbackFcn(~,~,Direction)
    dataName = getDataNames;
    figure;

    hold on

    for i = 1:length(dataName)
        data = evalin('base',dataName{i});
%         if ~ismatrix(data.value)
%             return;
%         end

        if ndims(data.value) == 2 && min(size(data.value)) ~= 1
            x = data.y;
            y = squeeze(sum(data.value,1))';
        elseif ndims(data.value) == 3
            x = data.z;
            data.value(isnan(data.value)) = 0;
            y = squeeze(sum(data.value,[1 2]))';
        elseif ndims(data.value) == 2 && min(size(data.value)) == 1
            x = data.x;
            y = data.value;
        end

        if length(dataName) > 1
            y = y/mean(y,"all");
        end

        switch Direction
            case 'H'
                plot(x,y);
                xlabel('{\it E} - {\it E}_F (eV)');
                ylabel('Counts (a.u.)');
            case 'V'
                plot(y,x);
        end



        TitleText{i} = processTitle(dataName{i});
    end
    
    hold off

    if length(dataName)==1
        TitleText = processTitle(dataName{1});
        title(TitleText);
    else
        legend(TitleText{:});
    end

function mapViewer_CallbackFcn(~,~)

    DataNames=getDataNames;
    data = evalin('base',DataNames{1});
    if isstruct(data)
        data.name = DataNames{1};
    end
    OxArpes_DataViewer(data);


function SaveVarsSeparate_CallbackFcn(hObject,varargin)
%% Load data from VarList
UpdateVarList(hObject);
handles=guidata(hObject);
DataNames=handles.VarNames';
if isempty(DataNames)
    return;
end
for i =1:length(DataNames)
    evalin('base',['save(''',DataNames{i},''',''',DataNames{i},''')']);
    disp(['Save ',DataNames{i}]);
end

function SaveVars_CallbackFcn(hObject,eventdata)
%% Load data from VarList
UpdateVarList(hObject);
handles=guidata(hObject);
DataNames=handles.VarNames';
if isempty(DataNames)
    return;
end
DataNamesString=['''',DataNames{1}];
for i = 2:length(DataNames)
    DataNamesString=[DataNamesString,''',''',DataNames{i}];
end
DataNamesString=[DataNamesString,''''];
[filename,pathname]=uiputfile('NewDataFile.mat',...
    'Select an existed file or input a new file name');
% 'uisave' is more convenient, but it does not allow you to append vars,
% thus I use uiputfile here.
if filename==0
    return;
end
fullfilename=[pathname,filename];
if exist(fullfilename,'file')
    AppendFlag=questdlg([filename,...
        ' already exists. Would you like to append to it or overwrite it?'],...
        'Append or Overwrite','Append','Overwrite','Cancel','Append');
    switch AppendFlag
        case 'Append'
            evalin('base',['save(''',fullfilename,''',',DataNamesString,',''-append'')']);
            disp(['Append to ',fullfilename]);
        case 'Overwrite'
            evalin('base',['save(''',fullfilename,''',',DataNamesString,')']);
            disp(['Overwrite ',fullfilename]);
        case 'Cancel'
            return;
    end            
else
    evalin('base',['save(''',fullfilename,''',',DataNamesString,')']);
    disp(['Save ',fullfilename]);
end

function Delete_CallbackFcn(hObject,eventdata)
%% Load data from VarList
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

%% ============= Group Selector Callback Functions===============
%part092501
function Group0(hObject,varargin)
    handles=guidata(hObject);
    setcolors(handles);
    set(handles.GroupAll,'BackgroundColor',[248 248 255]/256);
    set(handles.GroupAll,'Value', [0 0 0 0]);
    set(handles.GroupName,'String','Current Group: All')
    UpdateVarList(hObject)
function Group1(hObject,varargin)
    handles=guidata(hObject);
    setcolors(handles);
    set(handles.Group1,'BackgroundColor',[255 248 220]/256);
    set(handles.GroupAll,'Value', [1 0 0 0]);
    GroupName = get(handles.Group1,'String');
    set(handles.GroupName,'String',['Current Group: ',GroupName])
    UpdateVarList(hObject)
function Group2(hObject,varargin)
    handles=guidata(hObject);
    setcolors(handles);
    set(handles.Group2,'BackgroundColor',[240 255 255]/256);
    set(handles.GroupAll,'Value', [0 1 0 0]);
    GroupName = get(handles.Group2,'String');
    set(handles.GroupName,'String',['Current Group: ',GroupName])
    UpdateVarList(hObject)
function Group3(hObject,varargin)
    handles=guidata(hObject);
    setcolors(handles);
    set(handles.Group3,'BackgroundColor',[255 250 250]/256);
    set(handles.GroupAll,'Value', [0 0 1 0]);
    GroupName = get(handles.Group3,'String');
    set(handles.GroupName,'String',['Current Group: ',GroupName])
    UpdateVarList(hObject)
function Group4(hObject,varargin)
    handles=guidata(hObject);
    setcolors(handles);
    set(handles.Group4,'BackgroundColor',[255 255 255]/256);
    set(handles.GroupAll,'Value', [0 0 0 1]);
    GroupName = get(handles.Group4,'String');
    set(handles.GroupName,'String',['Current Group: ',GroupName])
    UpdateVarList(hObject)
function setcolors(handles)
    set(handles.GroupAll,'BackgroundColor',[220 220 220]/256);
    set(handles.Group1,'BackgroundColor',[255 222 173]/256);
    set(handles.Group2,'BackgroundColor',[107 142 35]/256);
    set(handles.Group3,'BackgroundColor',[147 112 219]/256);
    set(handles.Group4,'BackgroundColor',[126 192 238]/256);
function ListboxItemRename(hObject,varargin)
    handles=guidata(hObject);
    list_entries=get(handles.VarList,'String');
    index_selected=get(handles.VarList,'Value');
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
    handles=guidata(hObject);
    list_entries=get(handles.VarList,'String');
    index_selected=get(handles.VarList,'Value');
    n_index=length(index_selected);
    for i=1:n_index
        data=evalin('base',list_entries{index_selected(i)});
        if isstruct(data)
            if ~isfield(data,'GroupInfo')
                data.GroupInfo=[0 0 0 0];
                assignin('base',list_entries{index_selected(i)},data);
            end
            data.GroupInfo(GroupNumber)=1;
        end
        assignin('base',list_entries{index_selected(i)},data);
    end
    UpdateVarList(hObject);
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
    handles=guidata(hObject);
    list_entries=get(handles.VarList,'String');
    index_selected=get(handles.VarList,'Value');
    n_index=length(index_selected);
    CurrentList=get(handles.GroupAll,'Value');
    CurrentList=find(CurrentList,1,'last');
    for i=1:n_index
        data=evalin('base',list_entries{index_selected(i)});
        if isstruct(data)
            if ~isfield(data,'GroupInfo')
                data.GroupInfo=[0 0 0 0];
            end
            data.GroupInfo(GroupNumber)=1;
            if ~isempty(CurrentList)
                data.GroupInfo(CurrentList)=0;
            end
            assignin('base',list_entries{index_selected(i)},data);
        end
    end
    UpdateVarList(hObject);
    
function RemoveFromGroup(hObject,varargin)
    handles=guidata(hObject);
    list_entries=get(handles.VarList,'String');
    index_selected=get(handles.VarList,'Value');
    n_index=length(index_selected);
    CurrentList=get(handles.GroupAll,'Value');
    CurrentList=find(CurrentList,1,'last');
    for i=1:n_index
        data=evalin('base',list_entries{index_selected(i)});
        if isstruct(data)
            if ~isfield(data,'GroupInfo')
                data.GroupInfo=[0 0 0 0];
            end
            if ~isempty(CurrentList)
                data.GroupInfo(CurrentList)=0;
            end
            assignin('base',list_entries{index_selected(i)},data);
        end
    end
    UpdateVarList(hObject);
 
function pb_rearrange_2Dto3D_Callback(hObject,varargin)
handles=guidata(hObject);
list_entries=get(handles.VarList,'String');
index_selected=get(handles.VarList,'Value');
n_index=length(index_selected);
for i=1:n_index
    varname=list_entries{index_selected(i)};
    data_list{i}=evalin('base',varname);
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

MappingMenu = uicontextmenu;
% create mapping selection
Mapping_String = uicontrol('Parent',vbox,...
    'Style','text',...
    'String','Mapping by:');
Mapping_Selection = uicontrol('Parent',vbox,...
    'Style', 'popup',...
    'String', {'theta','phi','index'});

% create file name input
FileName_String = uicontrol('Parent', vbox,...
    'Style','text',...
    'String','Enter file name:');
FileName_Input = uicontrol('Parent',vbox,...
    'Style','edit',...
    'String','Map');

% save button
SaveButton = uicontrol('Parent',vbox,...
    'Style','pushbutton',...
    'String','Save',...
    'Callback',{@Rearrange_2Dto3D_Processing,FileName_Input,Mapping_Selection,data_list,filenamewindow});

function Rearrange_2Dto3D_Processing(hObject, eventobj, FileName_Input,Mapping_Selection,data_list,filenamewindow)
Mapping_Filename = get(FileName_Input,'String');
Mapping_Value = get(Mapping_Selection,'Value');
switch Mapping_Value
    case 1
        mapping_by = 'theta';
    case 2
        mapping_by = 'phi';
    case 3
        mapping_by = 'index';
end

data_new = Rearrange2DTo3D(data_list,mapping_by);
assignin('base', Mapping_Filename,data_new)
set (filenamewindow, 'Visible','off')

function pb_combine_data_Callback(hObject, eventdata)
% hObject    handle to pb_interp_nans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles=guidata(hObject);

list_entries = get(handles.VarList,'String');
index_selected = get(handles.VarList,'Value');

for i=1:length(index_selected)
    varname=list_entries{index_selected(i)};
    data{i}=evalin('base',varname);
end

% put the first file
dataout = data{1};

for i = 2:size(index_selected,2)
    datain = data{i};
    if dataout.y == datain.y
        dataout.x = cat(2,dataout.x, datain.x);
        dataout.value = cat(1,dataout.value,datain.value);
    else
        errordlg(['data ',num2str(i),' is not the same as previous'])
    end
end

[dataout.x,I] = sort(dataout.x);
dataout.value = dataout.value(I,:,:);

var_name_out='combinedMap';
assignin('base',var_name_out,dataout);

function pb_combine_data_interp_Callback(hObject, eventdata)
% hObject    handle to pb_interp_nans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles=guidata(hObject);

list_entries = get(handles.VarList,'String');
index_selected = get(handles.VarList,'Value');

for i=1:length(index_selected)
    varname=list_entries{index_selected(i)};
    data{i}=evalin('base',varname);
end

data_cm=CombineData_interp(data);
if ~isempty(data_cm)
    assignin('base','combinedMapIn',data_cm)
end 
    
%
function Rename1_CallbackFcn(hObject,varargin)
Rename(hObject,1)
function Rename2_CallbackFcn(hObject,varargin)
Rename(hObject,2)
function Rename3_CallbackFcn(hObject,varargin)
Rename(hObject,3)
function Rename4_CallbackFcn(hObject,varargin)
Rename(hObject,4)

function Rename(hObject,num)
handles = guidata(hObject);
Group = ['Group',num2str(num)];
h = ['handles.',Group];
OldName = eval(['get(',h,',''String'')']);
NewName=inputdlg(['Please input the new name for ''' OldName ''''],'Rename',1,{OldName});
if ~isempty(NewName)
    eval(['set(',h,',''String'',''',NewName{1},''');']);
end

%% ======================== Update VarList =====================================
%part092501

function VarList_CallbackFcn(hObject,varargin)
handles=guidata(hObject);
SelectionTypeFlag=get(handles.mObject,'SelectionType');
switch SelectionTypeFlag
    case 'open'
        PlotData()
    case 'normal'
       UpdateVarList(hObject);
    otherwise
        return;PlotSlices
end

function PlotData()
VarNames=getDataNames;
if isempty(VarNames)
    return;
end
data=evalin('base',VarNames{1});
if isfield(data,'value') || isprop(data,'value')
    switch ndims(squeeze(data.value))
        case 2
            if size(data.value,1)==1||size(data.value,2)==1
                plotData1(VarNames{1});
            else
                PlotSlices(VarNames{1},'z');
            end
        case 3
            PlotSlices(VarNames{1},'z');
    end
end

function plotData1(VarName)

data=evalin('base',VarName);
if class(data) == "OxArpes_1D_Data"
    data.show();
else
    figure;
    plot(data.x(:),data.value(:));
end

function UpdateVarList(hObject)
handles=guidata(hObject);
VarNamesAll = evalin('base','who');
% get dims for list

CurrentList=get(handles.GroupAll,'Value');
CurrentList=find(CurrentList,1,'last');
% for group selection
% part092501
if ~isempty(CurrentList)
    index=1;
    VarNames={};
    for i=1:length(VarNamesAll)
        data=evalin('base',VarNamesAll{i});
        if isstruct(data)
            if ~isfield(data,'GroupInfo')
                data.GroupInfo=[0 0 0 0];
                assignin('base',VarNamesAll{i},data);
            end
            if data.GroupInfo(CurrentList)
                VarNames{index}=VarNamesAll{i};
                index=index+1;
            end
        end
    end
else
    VarNames = VarNamesAll;
end
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

%% Data Info Setting

set(handles.datainfo_x_min,'String','')
set(handles.datainfo_x_max,'String','')
set(handles.datainfo_x_no,'String','')
set(handles.datainfo_x_stepsize,'String','')
set(handles.datainfo_y_min,'String','')
set(handles.datainfo_y_max,'String','')
set(handles.datainfo_y_no,'String','')
set(handles.datainfo_y_stepsize,'String','')
set(handles.datainfo_z_min,'String','')
set(handles.datainfo_z_max,'String','')
set(handles.datainfo_z_no,'String','')
set(handles.datainfo_z_stepsize,'String','')

varname=handles.VarNames{i};
if isempty(varname) || isempty(evalin('base',['who(''' varname ''')']))
    return
end

data=evalin('base',varname);
% data=[];
% if ~isstruct(datav)
%     data.value=datav;
% elseif isfield(datav,'value') || isprop(datav,'value')
%     data=datav;
% end

if isempty(data)
    return
end

if isstruct(data) || (isobject(data) && isprop(data,'value'))
    di=size(size(data.value),2);

%set(handles.hTitle_panel_datainfo,'String',['info: ' varname ' - ' num2str(di) 'D']);

if isfield(data,'x') || isprop(data,'x')
    size_x=max(size(data.x));
    set(handles.datainfo_x_no,'String',num2str(size_x));
    set(handles.datainfo_x_min,'String',num2str(data.x(1)));
    set(handles.datainfo_x_max,'String',num2str(data.x(size_x)));
    set(handles.datainfo_x_stepsize,'String',num2str(data.x(2)-data.x(1)));
else
    size_x=size(data.value,1);
    set(handles.datainfo_x_no,'String',num2str(size_x));
    set(handles.datainfo_x_min,'String','index');
    set(handles.datainfo_x_max,'String','index');
    set(handles.datainfo_x_stepsize,'String','index');
end

if isfield(data,'y') || isprop(data,'y')
    size_y=max(size(data.y));
    set(handles.datainfo_y_no,'String',num2str(size_y));
    set(handles.datainfo_y_min,'String',num2str(data.y(1)));
    set(handles.datainfo_y_max,'String',num2str(data.y(size_y)));
    set(handles.datainfo_y_stepsize,'String',num2str(data.y(2)-data.y(1)));
else
    size_y=size(data.value,1);
    set(handles.datainfo_y_no,'String',num2str(size_y));
    set(handles.datainfo_y_min,'String','index');
    set(handles.datainfo_y_max,'String','index');
    set(handles.datainfo_y_stepsize,'String','index');
end

if di==3
    if isfield(data,'z') || isprop(data,'z')
        size_z=max(size(data.z));
        set(handles.datainfo_z_no,'String',num2str(size_z));
        set(handles.datainfo_z_min,'String',num2str(data.z(1)));
        set(handles.datainfo_z_max,'String',num2str(data.z(size_z)));
        set(handles.datainfo_z_stepsize,'String',num2str(data.z(2)-data.z(1)));
    else
        size_z=size(data.value,1);
        set(handles.datainfo_z_no,'String',num2str(size_z));
        set(handles.datainfo_z_min,'String','index');
        set(handles.datainfo_z_max,'String','index');
        set(handles.datainfo_z_stepsize,'String','index');
    end
end
end

guidata(handles.mObject,handles);


function interp_nans_Callback(hObject, ~)
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
handles=guidata(hObject);
list_entries = handles.VarNames;

for i=1:length(list_entries)
    varname=list_entries{i};
    data=evalin('base',varname);
    data.value(isnan(data.value))=0;
    assignin('base',[varname '_onan'],data)
end
UpdateVarList(hObject);
