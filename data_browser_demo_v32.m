function data_browser_demo_v32
%DATA_BROWSER_DEMO_V32 Open the GUI for browsing ARPES data in the base workspace.
%   The browser does not load measurements itself. Use the Loader menu to call
%   the repository's loading and conversion tools; loaded variables then appear
%   in the list and can be plotted, grouped, combined, saved, or edited here.
%
%   The GUI expects ARPES variables to expose a numeric VALUE array and, when
%   available, matching X/Y/Z coordinate vectors and an INFO metadata field.
%   It also supports ordinary base-workspace variables in the unfiltered list.
%   Several menus depend on helper functions and GUI Layout Toolbox (uiextras)
%   being available on the MATLAB path.
%
%   The figure is a singleton: calling this function again raises the existing
%   Data Browser window instead of creating another copy.
% Bug report: han.peng@physics.ox.ac.uk
% cheng.peng@physics.ox.ac.uk
%

%% Create main window
% Reuse the tagged figure if it is already open. All callbacks retrieve their
% shared control handles from this figure with GUIDATA.
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

%% menu bar
% These menus are dispatch points to the wider yulinARPES tool collection;
% most loading, fitting, and visualization work is implemented elsewhere.
LoaderMenu = uimenu(handles.mObject,'Label','Loader');
uimenu(LoaderMenu,'Label','Load ARPES Data','Callback',@LoadDataARPES.main);
uimenu(LoaderMenu,'Label','Load ARPES Data (New)','Callback',@(~,~)loader_UI);
uimenu(LoaderMenu,'Label','Auto Sync & Load','Callback',@(~,~)OxArpes_Sync);
uimenu(LoaderMenu,'Label','Cut conversion','Callback',@k_space_conversion_cut,'Separator','On');
uimenu(LoaderMenu,'Label','Map conversion 1','Callback',@k_space_conversion_demo);
uimenu(LoaderMenu,'Label','Map conversion 2','Callback',@flash_k_space_conversion_v2);
uimenu(LoaderMenu,'Label','KZ conversion','Callback',@plotKZ);
uimenu(LoaderMenu,'Label','Elettra Nano Map','Callback',@CombineData_Micro_new,'Separator','On');

VisualMenu = uimenu(handles.mObject,'Label','Visualization');
uimenu(VisualMenu,'Label','Arbitrary cut plot','Callback',@arbi_cut_plot_demo);
uimenu(VisualMenu,'Label','Arbitrary cut plot 3D','Callback',@arbicut_3d_plot);
uimenu(VisualMenu,'Label','EDC MDC plot','Callback',@EDC_MDC_plot);
uimenu(VisualMenu,'Label','Viewer4D','Callback',@Viewer4D.main);
uimenu(VisualMenu,'Label','Slice 3D plot','Callback',@slice_3d_plot,'Separator','On');
uimenu(VisualMenu,'Label','Volume 3D plot','Callback',@volume_3d_plot_w_notch);
uimenu(VisualMenu,'Label','RenderDataARPES','Callback',@RenderDataARPES);
uimenu(VisualMenu,'Label','Plot Tools','Callback',@plot_tools2_demo,'Separator','On');
uimenu(VisualMenu,'Label','Plot BZ','Callback',@brillouin_zone_plot);
uimenu(VisualMenu,'Label','MiniBZ plotter','Callback',@MiniBZ_plotter);
uimenu(VisualMenu,'Label','Plot BZ (new)','Callback',@plotBZ_V1,'Separator','On');
uimenu(VisualMenu,'Label','KZ cut simulation','Callback',@kz_plot);

ProcessMenu = uimenu(handles.mObject,'Label','Process');
uimenu(ProcessMenu,'Label','Data Interpolation','Callback',@data_interpolation_demo);
uimenu(ProcessMenu,'Label','Data combine/resample','Callback',@data_comb_resamp_demo);
uimenu(ProcessMenu,'Label','Data truncate','Callback',@td_demo);
uimenu(ProcessMenu,'Label','Self Normalization','Callback',@self_normalization_demo);
uimenu(ProcessMenu,'Label','Add two value arrays','Callback',@add_two_value_arrays,'Separator','On');
uimenu(ProcessMenu,'Label','Spin data combine','Callback',@spin_data_combine);
uimenu(ProcessMenu,'Label','Combine Data For KZ','Callback',@CombineDataForKZ,'Separator','On');
uimenu(ProcessMenu,'Label','Combine Data For MAP','Callback',@CombineDataForMAP);

uimenu(ProcessMenu,'Label','Curvature','Callback',@Curvature,'Separator','On');
uimenu(ProcessMenu,'Label','Gradient','Callback',@Gradient);
uimenu(ProcessMenu,'Label','Smooth derivation','Callback',@smooth_derivation_v1);
uimenu(ProcessMenu,'Label','Mirror','Callback',@(~,~)data_mirror_symmetrize);
uimenu(ProcessMenu,'Label','Ridge detection','Callback',@ridge_detection);

ToolsMenu = uimenu(handles.mObject,'Label','Tools');
uimenu(ToolsMenu,'Label','Fit MDC ','Callback',@fit_MDC_demo_20150312);
uimenu(ToolsMenu,'Label','Fit Fermi Level','Callback',@FitFermiSurface);
uimenu(ToolsMenu,'Label','Tight Binding 2D','Callback',@GUI_for_2D,'Separator','On');
uimenu(ToolsMenu,'Label','Tight Binding 3D','Callback',@GUI_for_3D);
uimenu(ToolsMenu,'Label','Emass Fitting','Callback',@EmassFitting);
uimenu(ToolsMenu,'Label','Wien2k','Callback',@quick_bxsf2mat);
uimenu(ToolsMenu,'Label','Resolution Cal.','Callback',@(~,~)OxArpes_ResolutionCalculator,'Separator','On');
uimenu(ToolsMenu,'Label','Fine Structure','Callback',@(~,~)OxArpes_FineStructure);
uimenu(ToolsMenu,'Label','Normalise','Callback',@(~,~)OxArpes_Normalise);
uimenu(ToolsMenu,'Label','Data Process All','Callback',@(~,~)OxArpes_DataProcess);


%% Group Choice Panel
% Group membership is stored on each ARPES variable in data.info.GroupInfo.
% The five buttons select either the unfiltered workspace list or one of four
% groups; the context menus rename the four user-defined group labels.

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

handles.GroupName=uicontrol('Parent',VBoxHome,...
    'Style','text','String','Current Folder: All');



%% VarList Right-click Menu 
% Context actions use the selected list entries. Several actions read or write
% those variables in MATLAB's base workspace, so the browser remains coupled to
% the interactive workspace rather than owning a separate data model.
ListBoxMenu = uicontextmenu;

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

uimenu(ListBoxMenu,'Label','Data Viewer (new)','Callback',@mapViewerNew_CallbackFcn);
% uimenu(plotMenu,'Label','3D Map Viewer','Separator','On','Callback',@mapViewer_CallbackFcn);

uimenu(plotMenu,'Label','Volume Viewer','Callback',@volumeViewerCallback, ...
    'Separator','on');


uimenu(ListBoxMenu,'Label','Rename','Callback',@ListboxItemRename,'Separator','on');
uimenu(ListBoxMenu,'Label','Edit Variable','Callback',@Listbox_openvar);

LBM1 = uimenu(ListBoxMenu,'Label','Group','Separator','on');
LBM2=uimenu(LBM1,'Label','Add to');
    uimenu(LBM2,'Label','Group 1','Callback',@AddToGroup1);
    uimenu(LBM2,'Label','Group 2','Callback',@AddToGroup2);
    uimenu(LBM2,'Label','Group 3','Callback',@AddToGroup3);
    uimenu(LBM2,'Label','Group 4','Callback',@AddToGroup4);
LBM3=uimenu(LBM1,'Label','Move to');
    uimenu(LBM3,'Label','Group 1','Callback',@MoveToGroup1);
    uimenu(LBM3,'Label','Group 2','Callback',@MoveToGroup2);
    uimenu(LBM3,'Label','Group 3','Callback',@MoveToGroup3);
    uimenu(LBM3,'Label','Group 4','Callback',@MoveToGroup4);
uimenu(LBM1,'Label','Remove','Callback',@RemoveFromGroup);

CBM1 = uimenu(ListBoxMenu,'Label','Combine');
uimenu(CBM1,'Label','2D cuts -> 3D','Callback',@pb_rearrange_2Dto3D_Callback);
uimenu(CBM1,'Label','Direct','Callback',@pb_combine_data_Callback);
uimenu(CBM1,'Label','Interp','Callback',@pb_combine_data_interp_Callback);
% uimenu(ListBoxMenu,'Label','Add Field','Callback',@pb_add_field_Callback);

NANM1 = uimenu(ListBoxMenu,'Label','NaNs!');
uimenu(NANM1,'Label','Interp NaNs','Callback',@interp_nans_Callback)
uimenu(NANM1,'Label','Replace NaNs with zero','Callback',@replace_nans_Callback)

% BeamTime=uimenu(ListBoxMenu,'Label','Beamtime Tools','Separator','on');
% uimenu(BeamTime,'Label','Compare APE spin data','Callback',@spin_data_combine);
SVM1 = uimenu(ListBoxMenu,'Label','Save');
uimenu(SVM1,'Label','Save Variable(s)','Callback',@SaveVars_CallbackFcn);
uimenu(SVM1,'Label','Save to Separate Files','Callback',@SaveVarsSeparate_CallbackFcn);

uimenu(ListBoxMenu,'Label','Delete','Separator','on','Callback',@Delete_CallbackFcn);

%% Variable Listbox: Varlist
% The list is refreshed from BASE WORKSPACE variables by UpdateVarList.
handles.VarList=uicontrol('Parent',VBoxHome,...
    'Style','ListBox','BackgroundColor','w',...
    'Value',1,'Max',100,...
    'Callback',@VarList_CallbackFcn,...
    'uicontextmenu',ListBoxMenu,...
    'Tag','VarList');

%% Panel: Data Information
% This panel displays basic coordinate ranges and sample counts for the
% currently selected ARPES variable when its VALUE and axis fields are present.
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


%% finalise and set size
set(VBoxHome,'Sizes',[25,15,-1,100]);
handles.CurrentFolder = [];
guidata(handles.mObject,handles);

% %% ========= Mainmenu Callback Functions ================
% 
% % help and about
% function help_callpack(hObject,~)
%     handles = guidata(hObject);
%     h = msgbox('Bug report: han.peng@physics.ox.ac.uk','Help and About');
%     Position0 = getpixelposition(handles.mObject);
%     Position = getpixelposition(h);
%     setpixelposition(h,[Position0(1)+Position0(3)/5,Position0(2)+3*Position0(4)/4,...
%         Position(3),Position(4)])
% 
% % save and retrive panel size settings
% function SavePanelSetting(hObject,evt)
%     handles = guidata(hObject);
%     GuiList = handles.GuiList;
%     Option=questdlg('Really want to save current configuration?',...
%         'Save Configuration?','Yes','No','Cancel','Yes');
%     if ~strcmp(Option,'Yes')
%         return;
%     end
%     p=which(mfilename);
%     p=regexp(p,'.*\','match');
%     p=[p{1},'data_browser_config.mat'];
%     h=findall(0,'Tag',GuiList{1}{1}.Tag);
%     index = 1;
%     if isempty(h)
%         errordlg('Please open Data Browser');
%     end
%     if length(h)>1
%         errordlg('Please Close Extra Data Browser Panels and Keep Only One')
%     end
%     Position0=getpixelposition(h);
%     data_browser_config{index}.Tag = 'DataBrowser';
%     data_browser_config{index}.Position = [0,0,Position0(3),Position0(4)];
%     
%     for i =2:length(GuiList)
%         for j = 1:length(GuiList{i})
%         h1=findall(0,'Tag',GuiList{i}{j}.Tag);
%         if ~isempty(h1)
%             index = index+1;
%             Position=getpixelposition(h1(1));
%             Position(1)=Position(1)-Position0(1);
%             Position(2)=Position(2)-Position0(2);
%             data_browser_config{index}.Tag = GuiList{i}{j}.Tag;
%             data_browser_config{index}.Position = Position;
%         end
%         end
%     end
%     save(p,'data_browser_config','-append');
% 
% function LoadPanelSetting(hObject,evt)
%     p=which(mfilename);
%     p=regexp(p,'.*\','match');
%     p=[p{1},'data_browser_config.mat'];
%     try
%         load(p);
%     catch
%         errordlg('Faild to load config file. Please save a config first.')
%     end
%     
%     
%     h0=findall(0,'Tag','DataBrowser');
%     if isempty(h0)
%         errordlg('Please open Data Browser');
%     end
%     if length(h0)>1
%         errordlg('Please Close Extra Data Browser Panels and Keep Only One')
%     end
%     Position0=getpixelposition(h0);
%     for i = 1:length(data_browser_config);
%         Tag=data_browser_config{i}.Tag;
%         Position=data_browser_config{i}.Position+[Position0(1),Position0(2),0,0];
%         h=findall(0,'Tag',Tag);
%         if ~isempty(h)
%             setpixelposition(h(1),Position);
%             figure(h(1));
%         end
%     end
%     figure(h0);
% 
% function PanelSetting0(hObject,evt)
%     p=which(mfilename);
%     p=regexp(p,'.*\','match');
%     p=[p{1},'data_browser_config.mat'];
%     try
%         load(p);
%     catch
%         errordlg('Faild to find config file.')
%     end
%     
%     
%     h=findall(0,'Tag','DataBrowser');
%     if isempty(h)
%         errordlg('Please open Data Browser');
%     end
%     if length(h)>1
%         errordlg('Please Close Extra Data Browser Panels and Keep Only One')
%     end
%     Position0=getpixelposition(h);
%     for i = 1:length(data_browser_config_def);
%         Tag=data_browser_config_def{i}.Tag;
%         Position=data_browser_config_def{i}.Position+[Position0(1),Position0(2),0,0];
%         h=findall(0,'Tag',Tag);
%         if ~isempty(h)
%             setpixelposition(h(1),Position);
%             figure(h(1));
%         end
%     end
% 
% %% some old functions for loading data, not sure if there are useful anymore
% function load_data_auto( hObject, eventdata )
%     % hObject    handle to pb_load (see GCBO)
%     % eventdata  reserved - to be defined in a future version of MATLAB
%     handles=guidata( hObject );
%     %%
%     DirRes=dir(handles.LoadPath);
%     % Get the files + directories names
%     [ListNames{1:length(DirRes),1}] = deal(DirRes.name);
%     
%     % Get directories only
%     [DirOnly{1:length(DirRes),1}] = deal(DirRes.isdir);
%     
%     % Turn into logical vector and take complement to get indexes of files
%     FilesOnly = ~cat(1, DirOnly{:});
%     list_entries = ListNames(FilesOnly);
%     n=length(list_entries);
%     
%     h=waitbar(0,'0%','Name','Loading');
%     for i=1:n
%         name = list_entries{i};
%         try
%         if load_scienta_general_txt_BZ(fullfile(handles.LoadPath,name))
%         elseif load_scienta_manipulator_scan_txt_BZ(fullfile(handles.LoadPath,name))
%         elseif load_Elettra_hdf5_BZ(fullfile(handles.LoadPath,name))
%         elseif load_fits_file_fun_BZ(fullfile(handles.LoadPath,name))
%         elseif load_Diamond_hdf5_xmas(fullfile(handles.LoadPath,name))
%     %        disp('1');
%     %     elseif load_fits_file_fun_BL7_BZ(fullfile(cd,name))
%         end
%         catch
%             disp(['Failed to load ',name]);
%         end
%         waitbar(i/n,h,[num2str(round(i*100/n)) '%'])
%     end
%     close(h)
% 
% function load_data_auto_set( hObject,eventdata )
%     handles=guidata( hObject );
%     NewLoadPath = uigetdir(handles.LoadPath);
%     if NewLoadPath~=0
%         handles.LoadPath = NewLoadPath;
%         guidata(handles.mObject,handles);
%     end

%%  ==================== Varlist Menu ==================================
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
    DataName=handles.VarNames{1};
    openvar(DataName);



%% ============= Group Selector Callback Functions===============
% Group selection changes the list filter. Add/Move/Remove callbacks below
% update the GroupInfo flags stored in each ARPES data object's INFO metadata.
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
    % Rename the first selected base-workspace variable while preserving its
    % value. MATLAB variable-name rules are checked before assignment.
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
    % Add selected ARPES variables to a group without clearing other flags.
    handles=guidata(hObject);
    list_entries=get(handles.VarList,'String');
    index_selected=get(handles.VarList,'Value');
    n_index=length(index_selected);
    for i=1:n_index
        data = evalin('base',list_entries{index_selected(i)});

        if isfield(data,'value') || isprop(data,'value') % is ARPES data
            % edit the tab
            if ~isfield(data.info,'GroupInfo')
                data.info.GroupInfo = [0 0 0 0];
            end
            data.info.GroupInfo(GroupNumber) = 1;
            assignin('base',list_entries{index_selected(i)},data);
        end
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
    % Move selected ARPES variables into one group, clearing the active group's
    % flag first. Other group memberships are retained.
    handles=guidata(hObject);
    list_entries=get(handles.VarList,'String');
    index_selected=get(handles.VarList,'Value');
    n_index=length(index_selected);

    CurrentList=get(handles.GroupAll,'Value');
    CurrentList=find(CurrentList,1,'last');

    for i=1:n_index

        data = evalin('base',list_entries{index_selected(i)});

        if isfield(data,'value') || isprop(data,'value') % is ARPES data
            % edit the tab
            if ~isfield(data.info,'GroupInfo')
                data.info.GroupInfo = [0 0 0 0];
            end
            data.info.GroupInfo(GroupNumber) = 1;
            if ~isempty(CurrentList)
                data.info.GroupInfo(CurrentList)=0;
            end
            assignin('base',list_entries{index_selected(i)},data);
        end
    end
    UpdateVarList(hObject);
    
function RemoveFromGroup(hObject,varargin)
    % Remove selected ARPES variables from the currently active group.
    handles=guidata(hObject);
    list_entries=get(handles.VarList,'String');
    index_selected=get(handles.VarList,'Value');
    n_index=length(index_selected);
    CurrentList=get(handles.GroupAll,'Value');
    CurrentList=find(CurrentList,1,'last');
    for i=1:n_index
        data=evalin('base',list_entries{index_selected(i)});

        if isfield(data,'value') || isprop(data,'value') % is ARPES data
            % edit the tab
            if isfield(data.info,'GroupInfo')
                data.info.GroupInfo(CurrentList)=0;
                assignin('base',list_entries{index_selected(i)},data);
            end
        end

    end
    UpdateVarList(hObject);
 
%% combine 2D -> 3D
function pb_rearrange_2Dto3D_Callback(hObject,~)
% Collect selected datasets and prompt for the mapping coordinate used when
% arranging multiple 2-D cuts into one 3-D dataset.
handles=guidata(hObject);
listEntries = get(handles.VarList, 'String');
selectedIndices = get(handles.VarList, 'Value');
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

listEntries = get(handles.VarList, 'String');
selectedIndices = get(handles.VarList, 'Value');
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
listEntries = get(handles.VarList, 'String');
selectedIndices = get(handles.VarList, 'Value');
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
function Rename1_CallbackFcn(hObject,varargin)
renameGroup(hObject, 1);
function Rename2_CallbackFcn(hObject,varargin)
renameGroup(hObject, 2);
function Rename3_CallbackFcn(hObject,varargin)
renameGroup(hObject, 3);
function Rename4_CallbackFcn(hObject,varargin)
renameGroup(hObject, 4);

function renameGroup(hObject, groupNumber)
% Update the displayed label for one of the four user-defined group buttons.
handles = guidata(hObject);
groupField = sprintf('Group%d', groupNumber);
groupButton = handles.(groupField);
currentName = get(groupButton, 'String');
newName = inputdlg(sprintf('Enter a new name for "%s":', currentName), ...
    'Rename Group', 1, {currentName});
if ~isempty(newName)
    set(groupButton, 'String', strtrim(newName{1}));
end

%% ======================== Update VarList =====================================
%part092501


function VarList_CallbackFcn(hObject,varargin)
    % A double-click plots the first selected ARPES variable; a single click
    % refreshes the selection-dependent data-information panel.
    handles=guidata(hObject);
    SelectionTypeFlag=get(handles.mObject,'SelectionType');
    switch SelectionTypeFlag
        case 'open' % double click
            PlotData(hObject)
        case 'normal' % single click
           UpdateVarList(hObject);
        otherwise
            return
    end


function PlotData(hObject)
% Plot a selected variable according to its value-array dimensionality. The
% OxArpes_1D_Data class supplies its own SHOW method; other 1-D arrays use PLOT.

    handles = guidata(hObject);
    listEntries = get(handles.VarList, 'String');
    selectedIndices = get(handles.VarList, 'Value');
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
            xLabel = PlotSlices.arpes_axis_label(data, 'x');
            ylabel(PlotSlices.arpes_axis_label(data, 'v'));
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
function UpdateVarList(hObject)
    % Read names from the base workspace and apply the active group filter.
    handles = guidata(hObject);
    allVariableNames = evalin('base', 'who');
    activeGroup = find(get(handles.GroupAll, 'Value'), 1, 'last');

    if isempty(activeGroup)
        variableNames = allVariableNames;
    else
        variableNames = cell(numel(allVariableNames), 1);
        matchCount = 0;
        for variableIndex = 1:numel(allVariableNames)
            workspaceValue = evalin('base', allVariableNames{variableIndex});
            if hasDataMember(workspaceValue, 'info') && ...
                    isstruct(workspaceValue.info) && ...
                    isfield(workspaceValue.info, 'GroupInfo')
                groupInfo = workspaceValue.info.GroupInfo;
                if isnumeric(groupInfo) && numel(groupInfo) >= activeGroup && ...
                        groupInfo(activeGroup) == 1
                    matchCount = matchCount + 1;
                    variableNames{matchCount} = allVariableNames{variableIndex};
                end
            end
        end
        variableNames = variableNames(1:matchCount);
    end

    % Keep a visible placeholder for an empty group, but never treat it as a
    % real workspace variable when updating the data-information panel.
    if isempty(variableNames)
        variableNames = {'Empty'};
    end
    set(handles.VarList, 'String', variableNames);

    selectedIndices = get(handles.VarList, 'Value');
    selectedIndices = selectedIndices(selectedIndices >= 1 & ...
        selectedIndices <= numel(variableNames));
    if isempty(selectedIndices)
        selectedIndices = 1;
    end
    topIndex = min(max(get(handles.VarList, 'ListboxTop'), 1), ...
        numel(variableNames));
    set(handles.VarList, 'Value', selectedIndices, 'ListboxTop', topIndex);
    handles.VarNames = variableNames(selectedIndices);

    % Clear the previous selection's axis details before populating new data.
    axisNames = {'x', 'y', 'z'};
    for axisIndex = 1:numel(axisNames)
        axisName = axisNames{axisIndex};
        controlSuffixes = {'min', 'max', 'no', 'stepsize'};
        for suffixIndex = 1:numel(controlSuffixes)
            controlName = sprintf('datainfo_%s_%s', axisName, ...
                controlSuffixes{suffixIndex});
            set(handles.(controlName), 'String', '');
        end
    end

    variableName = handles.VarNames{1};
    if strcmp(variableName, 'Empty')
        guidata(handles.mObject, handles);
        return;
    end

    data = evalin('base', variableName);
    if ~hasDataMember(data, 'value')
        guidata(handles.mObject, handles);
        return;
    end

    valueSize = size(data.value);
    axisValues = cell(1, 3);
    for axisIndex = 1:min(ndims(data.value), 3)
        axisName = axisNames{axisIndex};
        if hasDataMember(data, axisName)
            axisValues{axisIndex} = data.(axisName);
        else
            axisValues{axisIndex} = [];
        end
        updateAxisSummary(handles, axisName, axisValues{axisIndex}, ...
            valueSize(axisIndex));
    end

    guidata(handles.mObject, handles);

function updateAxisSummary(handles, axisName, axisValues, dimensionSize)
% Display a coordinate range safely, including empty and single-point axes.
    controlNames = {sprintf('datainfo_%s_min', axisName), ...
        sprintf('datainfo_%s_max', axisName), ...
        sprintf('datainfo_%s_no', axisName), ...
        sprintf('datainfo_%s_stepsize', axisName)};

    if isempty(axisValues)
        displayValues = {'index', 'index', num2str(dimensionSize), 'index'};
    elseif ~isnumeric(axisValues) || ~isvector(axisValues) || ...
            any(~isfinite(axisValues(:)))
        displayValues = {'invalid', 'invalid', num2str(dimensionSize), 'invalid'};
    else
        axisValues = axisValues(:);
        displayCount = num2str(numel(axisValues));
        if numel(axisValues) ~= dimensionSize
            displayCount = sprintf('%d (expected %d)', ...
                numel(axisValues), dimensionSize);
        end
        if isscalar(axisValues)
            stepSize = 'n/a';
        else
            stepSize = num2str(axisValues(2) - axisValues(1));
        end
        displayValues = {num2str(min(axisValues)), num2str(max(axisValues)), ...
            displayCount, stepSize};
    end

    for valueIndex = 1:numel(controlNames)
        set(handles.(controlNames{valueIndex}), 'String', ...
            displayValues{valueIndex});
    end

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
