% RenderDataARPES works with data_browser. It will volume render an image of
% a 3D ARPES data.
% 
% To start the gui, simply call 
% RenderDataARPES();
% 
% 
% GUI Layout Toolbox is PREREQUISITE:
%
% GUI Layout Toolbox is required to run this gui (and most guis built purely
% by code). Please download the proper version from Mathwork website. 
% Incorrect GUI Layout Toolbox version will result in error.
%
% For Matlab 2014a (or earlier version) users, please use old version Gui
% Layout Toolbox.
% http://uk.mathworks.com/matlabcentral/fileexchange/27758-gui-layout-toolbox
%
% For Matlab 2014b (or newer version) users, please use new version Gui
% Layout Toolbox.
% http://www.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox
%
%
% This GUI is written by Han Peng
% han.peng@physics.ox.ac.uk
% Uinversity of Oxford (April 2015)
%
%
% The core function render.m is written by Dr.D.Kroon
% University of Twente (April 2009) 

classdef RenderDataARPES < handle                      
    properties % Figure and uicontrols
        Figure
        
        % LOAD DATA
        StrDataName
        PbLoadData
        PbLoadDataResize
        % % resize data
        InputSizeZ
        InputSizeXY
                      
        % PLOT
        PbPlot
        % % Plot Options
        FlagAutoUpdate
        InputFigNum
        % % Render Options
        SelectRenderType
        SelectShadingMaterial
        InAlphaMin
        InputAlphaMax
        SelectColorMapStyle
        FlagColorMapFlip      
        uiDegTheta
        uiDegPhi
        % % Movie Options
        PbMakeMovie
        PbMakeVRMovie
        InputFileName
        InputTotalFrames
        InputFPS
        % STATUS
        StrStatus
        % Cutting slices in different directions
        XSlice
        XSliceCheck
        YSlice
        YSliceCheck
        ZSlice
        ZSliceCheck
        % Light
        XLight
        XLightCheck
        XRight
        XLeft
        %Export PointCloud
        Data
        PbExportPointCloud
        GammaValue
        SliderGamma
        DensityValue
        SliderDensity
        Gamma
        Density
    end
    
    %% Build Gui
    methods % Constructor & Initialization methods
        function obj=RenderDataARPES(varargin)
            % Build Gui layout and set callbacks
            obj = obj.createUIComponents();
            obj = obj.setCallbacks();
            obj = obj.openningFunction();
        end
        function obj = createUIComponents(obj)
            % CONVENTION OF PREFIX
            % s = select
            % i = input
            % f = flag
            % ui = user interface
            % pb = push button
            % str = string
            STR_WIDTH=90;
            STR_HEIGHT=25;
            PB_HEIGHT=40;
            UIANG_SIZE=150;
            LOADDATA_HEIGHT=125;
            PLOT_HEIGHT=340;
            MAKEMOVIE_HEIGHT=125;
            
            FIG_POSITION = [500 50 320 700];
            
            obj.Figure=figure(...
                'Position',         FIG_POSITION,...
                'Name',             'RenderDataARPES',...
                'NumberTitle',      'off',...
                'MenuBar',          'none',...
                'IntegerHandle',    'off',...
                'HandleVisibility', 'off',...
                'Tag',              'RenderDataARPES');
            
            homeVBox = uiextras.VBox('Parent',obj.Figure);
            %% Load Panel
            try
            panelLoadData = uiextras.Panel(...
                'Parent',           homeVBox,...
                'Title',            'Load Data',...
                'Padding',          5);
            catch
                errMsg = ...
                    {['Unable to create GUI, please check your ',...
                    'GUI Layout Toolbox version. ',...
                    'For more information, run: '],...
                    ''' help RenderDataARPES ''.'};
                errordlg(errMsg);
                return;
            end
            vBoxPanelLoadData = uiextras.VBox('Parent',panelLoadData);
            
            
            % LOAD DATA
            obj.StrDataName = uicontrol(...
                'Parent',           vBoxPanelLoadData,...
                'Style',            'Text',...
                'String',           'Empty Data',...
                'BackgroundColor',  'w');
            
            hBoxLoadData = uiextras.HBox('Parent',vBoxPanelLoadData);
            obj.PbLoadData = uicontrol(...
                'Parent',           hBoxLoadData,...
                'Style',             'PushButton',...
                'String',           'Load Data');
            obj.PbLoadDataResize = uicontrol(...
                'Parent',           hBoxLoadData,...
                'Style',             'PushButton',...
                'String',           'Load Data & Resize');
            set(hBoxLoadData,'Sizes',[-1,-1]);
            %

            
            % % resize data
            hBoxSize = uiextras.HBox('Parent',vBoxPanelLoadData);
            uicontrol(...
                'Parent',           hBoxSize,...
                'Style',             'Text',...
                'String',           'Size of Z');
            obj.InputSizeZ = uicontrol(...
                'Parent',           hBoxSize,...
                'Style',             'Edit',...
                'String',           '150');
            %
            uicontrol(...
                'Parent',           hBoxSize,...
                'Style',             'Text',...
                'String',           'Size of // axis');
            obj.InputSizeXY = uicontrol(...
                'Parent',           hBoxSize,...
                'Style',             'Edit',...
                'String',           '200');
            set(hBoxSize,'Sizes',...
                [STR_WIDTH,STR_WIDTH/2,STR_WIDTH,STR_WIDTH/2]);
            %
            set(vBoxPanelLoadData,...
                'Sizes',        [STR_HEIGHT,PB_HEIGHT,STR_HEIGHT]);
            
            
            %% Plot Panel
            % PLOT
            panelPlot = uiextras.Panel(...
                'Parent',           homeVBox,...
                'Title',            'Plot',...
                'Padding',          5);
            vBoxPanelPlot = uiextras.VBox(...
                'Parent',           panelPlot);
            obj.PbPlot = uicontrol(...
                'Parent',           vBoxPanelPlot,...
                'Style',            'PushButton',...
                'String',           'Plot');
            
            
            % % Plot Options
            %
            hBoxFigNum = uiextras.HBox(...
                'Parent',           vBoxPanelPlot);
            obj.FlagAutoUpdate = uicontrol(...
                'Parent',           hBoxFigNum,...
                'Style',            'CheckBox',...
                'String',           'Auto Update Figure',...
                'Value',            0);
            uicontrol(...
                'Parent',           hBoxFigNum,...
                'Style',            'Text',...
                'String',           'Fig Num');
            obj.InputFigNum = uicontrol(...
                'Parent',           hBoxFigNum,...
                'Style',            'Edit',...
                'String',           '100');
            set(hBoxFigNum,'Sizes',[STR_WIDTH*3/2+10,STR_WIDTH,STR_WIDTH/2]);
            
            % % Render Options
            selectRenderType = ...
                {'mip','bw','color','shaded'};
            selectShadingMaterial = ...
                {'shiny','dull','metal'};
            hBoxRenderType = uiextras.HBox(...
                'Parent',           vBoxPanelPlot);
            uicontrol(...
                'Parent',           hBoxRenderType,...
                'Style',            'Text',...
                'String',           'Render Type');
            obj.SelectRenderType = uicontrol(...
                'Parent',           hBoxRenderType,...
                'Style',            'PopupMenu',...
                'String',           selectRenderType,...
                'Value',            1,...
                'Tag',              'RenderOption');   
            uicontrol(...
                'Parent',           hBoxRenderType,...
                'Style',            'Text',...
                'String',           'Shading Material');
            obj.SelectShadingMaterial = uicontrol(...
                'Parent',           hBoxRenderType,...
                'Style',            'PopupMenu',...
                'String',           selectShadingMaterial,...
                'Value',            1,...
                'Tag',              'RenderOption');
            set(hBoxRenderType,...
                'Sizes',...
                [STR_WIDTH,STR_WIDTH/2+10,STR_WIDTH,STR_WIDTH/2+10]);
            %
            hBoxAlphaMin = uiextras.HBox(...
                'Parent',           vBoxPanelPlot);
            uicontrol(...
                'Parent',           hBoxAlphaMin,...
                'Style',            'Text',...
                'String',           'Valve Min');
            obj.InAlphaMin = uicontrol(...
                'Parent',           hBoxAlphaMin,...
                'Style',            'Slider',...
                'String',           'Valve Min',...
                'Value',            0,...
                'Min',              0,...
                'Max',              100,...
                'Tag',              'RenderOption');
            set(hBoxAlphaMin,'Sizes',[STR_WIDTH,-1]);
            %
            hBoxAlphaMax = uiextras.HBox(...
                'Parent',           vBoxPanelPlot);
            uicontrol(...
                'Parent',           hBoxAlphaMax,...
                'Style',            'Text',...
                'String',           'Valve Max');    
            obj.InputAlphaMax = uicontrol(...
                'Parent',           hBoxAlphaMax,...
                'Style',            'Slider',...
                'String',           'Valve Max',...
                'Value',            100,...
                'Min',              0,...
                'Max',              100,...
                'Tag',              'RenderOption');
            set(hBoxAlphaMax,'Sizes',[STR_WIDTH,-1]);
            
            %
            hBoxColorMapStyle = uiextras.HBox(...
                'Parent',           vBoxPanelPlot);
            uicontrol(...
                'Parent',           hBoxColorMapStyle,...
                'Style',            'Text',...
                'String',           'Color Map');   
            selectionColorMap = {...
                'gray','jet','hsv','hot','copper','cool',...
                'spring','summer','autumn','winter','cm_blackbody',...
                'cm_blue','cm_bluehot','cm_blueredgreen','cm_copper',...
                'cm_cyan','cm_cyanmagenta','cm_geo','cm_gold','cm_green',...
                'cm_landandsea','cm_magenta','cm_pastels','cm_pastelsmap',...
                'cm_planetearth','cm_rainbow','red','cm_redwhiteblue',...
                'cm_redwhitegreen','cm_relief','cm_spectrum','cm_terrain',...
                'cm_yellow','cm_yellowhot'};
            obj.SelectColorMapStyle = uicontrol(...
                'Parent',           hBoxColorMapStyle,...
                'Style',            'PopupMenu',...
                'String',           selectionColorMap,...
                'Value',            1,...
                'Tag',              'RenderOption'); 
            uicontrol(...
                'Parent',           hBoxColorMapStyle,...
                'Style',            'Text',...
                'String',           ''); 
            obj.FlagColorMapFlip = uicontrol(...
                'Parent',           hBoxColorMapStyle,...
                'Style',            'CheckBox',...
                'String',           'Color Flip',...
                'Value',            0,...
                'Tag',              'RenderOption'); 
            set(hBoxColorMapStyle,...
                'Sizes',...
                [STR_WIDTH,STR_WIDTH,20,STR_WIDTH]);
            
            %
            hBoxSlices = uiextras.HBox(...
                'Parent',           vBoxPanelPlot);
            obj.XSliceCheck=uicontrol(...
                'Parent',       hBoxSlices,...
                'Style',        'Checkbox',...
                'String',       'x');
            obj.XSlice = uicontrol(...
                'Parent',           hBoxSlices,...
                'Style',            'Slider',...
                'Value',            1,...
                'Min',              1);
            addlistener(obj.XSlice,'Value','PostSet',@obj.sliceRender);
            obj.YSliceCheck=uicontrol(...
                'Parent',       hBoxSlices,...
                'Style',        'Checkbox',...
                'String',       'y');
            obj.YSlice = uicontrol(...
                'Parent',           hBoxSlices,...
                'Style',            'Slider',...
                'Value',            1,...
                'Min',              1);
            addlistener(obj.YSlice,'Value','PostSet',@obj.sliceRender);
            obj.ZSliceCheck=uicontrol(...
                'Parent',       hBoxSlices,...
                'Style',        'Checkbox',...
                'String',       'z');
            obj.ZSlice = uicontrol(...
                'Parent',           hBoxSlices,...
                'Style',            'Slider',...
                'Value',            1,...
                'Min',              1);
            addlistener(obj.ZSlice,'Value','PostSet',@obj.sliceRender);
            set(hBoxSlices,'Sizes',[25,-1,25,-1,25,-1]);
            

            %
            hBoxrender = uiextras.HBox(...
                'Parent',           vBoxPanelPlot);
            obj.XLightCheck=uicontrol(...
                'Parent',       hBoxrender,...
                'Style',        'Checkbox',...
                'String',       'x');
            obj.XLeft = uicontrol(...
                'Parent',           hBoxrender,...
                'Style',            'Edit',...
                'String',           '3.0');
            obj.XLight = uicontrol(...
                'Parent',           hBoxrender,...
                'Style',            'Slider',...
                'Value',            1,...
                'Min',              1);
            addlistener(obj.XLight,'Value','PostSet',@obj.light);
            obj.XRight = uicontrol(...
                'Parent',           hBoxrender,...
                'Style',            'Edit',...
                'String',           '1.5');
            set(hBoxrender,'Sizes',[35,25,-1,25]);
            %
            func1=@()obj.UIDegreeUpdate(1);
            func2=@()obj.UIDegreeUpdate(2);
            hBoxDeg = uiextras.HBox(...
                'Parent',           vBoxPanelPlot);
            hBoxDeg1=uiextras.HBox(...
                'Parent',           hBoxDeg);
            hBoxDeg2=uiextras.HBox(...
                'Parent',           hBoxDeg);
            set(hBoxDeg,'Sizes',[UIANG_SIZE UIANG_SIZE]);
            set(vBoxPanelPlot,...
                'Sizes',...
                [PB_HEIGHT*0.75,...
                STR_HEIGHT,...
                STR_HEIGHT,...
                STR_HEIGHT,...
                STR_HEIGHT,...
                STR_HEIGHT,...
                STR_HEIGHT*0.75,...
                STR_HEIGHT*0.75,...
                UIANG_SIZE]);
            pause(0.1);
            obj.uiDegTheta = ...
                phuitools.UIDegree(hBoxDeg1,obj.Figure,'Theta',func1,func2);
            obj.uiDegPhi = ...
                phuitools.UIDegree(hBoxDeg2,obj.Figure,'Phi',func1,func2);
            %

            %% Make Movie Panel
            % % Movie Options
            panelMakeMovie = uiextras.Panel(...
                'Parent',           homeVBox,...
                'Title',            'Make Movie',...
                'Padding',          5);
            vBoxPanelMakeMovie = uiextras.VBox(...
                'Parent',           panelMakeMovie);
            hBoxMakeMovie = uiextras.HBox(...
                'Parent',           vBoxPanelMakeMovie);
            obj.PbMakeMovie = uicontrol(...
                'Parent',           hBoxMakeMovie,...
                'Style',            'PushButton',...
                'String',           'Make Movie');
            obj.PbMakeVRMovie = uicontrol(...
                'Parent',           hBoxMakeMovie,...
                'Style',            'PushButton',...
                'String',           'Make VR Movie');
            hBoxFileName = uiextras.HBox(...
                'Parent',           vBoxPanelMakeMovie);
            uicontrol(...
                'Parent',           hBoxFileName,...
                'Style',            'Text',...
                'String',           'Output File Name');   
            obj.InputFileName = uicontrol(...
                'Parent',           hBoxFileName,...
                'Style',            'Edit',...
                'String',           'RenderOutput.mp4'); 
            set(hBoxFileName,'Sizes',[STR_WIDTH,-1]);
            %
            hBoxTotalFrames = uiextras.HBox(...
                'Parent',           vBoxPanelMakeMovie);
            uicontrol(...
                'Parent',           hBoxTotalFrames,...
                'Style',            'Text',...
                'String',           'Total Frames');   
            obj.InputTotalFrames = uicontrol(...
                'Parent',           hBoxTotalFrames,...
                'Style',            'Edit',...
                'String',           '360'); 
            uicontrol(...
                'Parent',           hBoxTotalFrames,...
                'Style',            'Text',...
                'String',           'FPS');   
            obj.InputFPS = uicontrol(...
                'Parent',           hBoxTotalFrames,...
                'Style',            'Edit',...
                'String',           '20'); 
            set(hBoxTotalFrames,...
            'Sizes',[STR_WIDTH,STR_WIDTH/2,STR_WIDTH,STR_WIDTH/2]);
            %
            set(vBoxPanelMakeMovie,...
                'Sizes',...
                [PB_HEIGHT,STR_HEIGHT,STR_HEIGHT]);
            
            % Status String
            hBoxStatus = uiextras.HBox(...
                'Parent',           homeVBox);
            uicontrol(...
                'Parent',           hBoxStatus,...
                'Style',            'Text',...
                'String',           'Status: '); 
            obj.StrStatus = uicontrol(...
                'Parent',           hBoxStatus,...
                'Style',            'Text',...
                'String',           'No data loaded.',...
                'HorizontalAlignment','Left',...
                'BackgroundColor',  'w'); 
            set(hBoxStatus,'Sizes',[60,-1]);
            set(homeVBox,...
                'Sizes',...
                [LOADDATA_HEIGHT, PLOT_HEIGHT,MAKEMOVIE_HEIGHT,STR_HEIGHT]);
            
            %% Export PointCloud Panel
            panelExportPointCloud = uiextras.Panel(...
                'Parent',       homeVBox,...
                'Title',        'Export PointCloud',...
                'Padding',      5);
            vBoxPanelExportPointCloud = uiextras.VBox(...
                'Parent',       panelExportPointCloud);
            obj.PbExportPointCloud = uicontrol(...
                'Parent',       vBoxPanelExportPointCloud,...
                'Style',        'PushButton',...
                'String',       'Export PointCloud');
            hBoxGamma=uiextras.HBox('Parent',vBoxPanelExportPointCloud);
            hBoxDensity=uiextras.HBox('Parent',vBoxPanelExportPointCloud);
            uicontrol(...
                'Parent',       hBoxGamma,...
                'Style',        'Text',...
                'String',       'Gamma');
            obj.GammaValue=uicontrol(...
                'Parent',       hBoxGamma,...
                'Style',        'Text',...
                'String',       '1');
            obj.SliderGamma=uicontrol(...
                'Parent',       hBoxGamma,...
                'Style',        'Slider',...
                'Min',          0.01,...
                'Max',          5,...
                'Value',        1);
            addlistener(obj.SliderGamma,'Value','PostSet',@obj.setpointcloud);
            set(hBoxGamma,'Sizes',[STR_WIDTH/2,STR_WIDTH/2,-1]);
            
            uicontrol(...
                'Parent',       hBoxDensity,...
                'Style',        'Text',...
                'String',       'density');
            obj.DensityValue=uicontrol(...
                'Parent',       hBoxDensity,...
                'Style',        'Text',...
                'String',       '1');
            obj.SliderDensity=uicontrol(...
                'Parent',       hBoxDensity,...
                'Style',        'Slider',...
                'Min',          1,...
                'Max',          30,...
                'Value',        1);
            addlistener(obj.SliderDensity,'Value','PostSet',@obj.setpointcloud);
            set(hBoxDensity,'Sizes',[STR_WIDTH/2,STR_WIDTH/2,-1]);
%             set(vBoxPanelExportPointCloud,...
%                 'Sizes',        [PB_HEIGHT,STR_HEIGHT,STR_HEIGHT]);
            set(vBoxPanelExportPointCloud,...
                'Sizes',        [-1,-1,-1]);
            
        end
        
        %% Set Callbacks
        function obj=setCallbacks(obj)
            % This function set all callbacks
            % except for UIDegree objects
            
            % % Load Data
            set(obj.PbLoadData,...
                'Callback',{@obj.pbLoadCallback,0});
            set(obj.PbLoadDataResize,...
                'Callback',{@obj.pbLoadCallback,1});
            
            % % Plot
            set(obj.PbPlot,...
                'Callback',@obj.PbPlotCallback);
            % obj.sRenderOptionCallback
            set(obj.SelectColorMapStyle,...
                'Callback',@obj.sRenderOptionCallback);
            set(obj.SelectRenderType,...
                'Callback',@obj.sRenderOptionCallback);
            set(obj.SelectShadingMaterial,...
                'Callback',@obj.sRenderOptionCallback);
            set(obj.FlagColorMapFlip,...
                'Callback',@obj.sRenderOptionCallback);
            % obj.updatePlotData
            set(obj.InputAlphaMax,...
                'Callback',@obj.updatePlotData);
            set(obj.InAlphaMin,...
                'Callback',@obj.updatePlotData);
            
            % % Make Movie
            set(obj.PbMakeMovie,...
                'Callback',@obj.PbMakeMovieCallback);
            set(obj.PbMakeVRMovie,...
                'Callback',@obj.PbMakeVRMovieCallback);
            % % Export PointCloud
            set(obj.PbExportPointCloud,...
                'Callback',@obj.PbExportPointCloudCallback);
        end
        function sliceRender(obj,varargin)
            multiple=2;
            sliceX=round(get(obj.XSlice,'Value'));
            sliceY=round(get(obj.YSlice,'Value'));
            sliceZ=round(get(obj.ZSlice,'Value'));
            data=getappdata(obj.Figure,'dataHighResPlot');
            maxValue=max(max(max(data.value)));
            data.value(1,1,1)=multiple*maxValue;
            if get(obj.XSliceCheck,'Value')
                data.value(sliceX,:,:)=multiple*data.value(sliceX,:,:);
            end
            if get(obj.YSliceCheck,'Value')
                data.value(:,sliceY,:)=multiple*data.value(:,sliceY,:);
            end
            if get(obj.ZSliceCheck,'Value')
                data.value(:,:,sliceZ)=multiple*data.value(:,:,sliceZ);
            end
            if (get(obj.XSliceCheck,'Value')&&get(obj.YSliceCheck,'Value'))
                data.value(sliceX,sliceY,:)=data.value(sliceX,sliceY,:)/multiple;
            end
            if (get(obj.XSliceCheck,'Value')&&get(obj.ZSliceCheck,'Value'))
                data.value(sliceX,:,sliceZ)=data.value(sliceX,:,sliceZ)/multiple;
            end
            if (get(obj.YSliceCheck,'Value')&&get(obj.ZSliceCheck,'Value'))
                data.value(:,sliceY,sliceZ)=data.value(:,sliceY,sliceZ)/multiple;
            end
            renderOption=obj.getRenderOption();
            plotOption=obj.getPlotOption();
            obj.renderAndPlot(data,renderOption,plotOption);
        end
        function light(obj,varargin)
            multiple=2;
            data=getappdata(obj.Figure,'dataHighResPlot');
            sliceX=round(get(obj.XLight,'Value'));
            lightLeftLimit=str2double(get(obj.XLeft,'String'));
            lightRightLimit=str2double(get(obj.XRight,'String'));
            xMax=get(obj.XLight,'Max');
            if get(obj.XLightCheck,'Value')
                for i=(sliceX+1):xMax
                    data.value(i,:,:)=(multiple+(i-sliceX)*(lightLeftLimit-multiple)/(xMax-sliceX))*data.value(i,:,:);
                end
                for i=1:(sliceX-1)
                    data.value(i,:,:)=(lightRightLimit+(i-1)*(multiple-lightRightLimit)/(sliceX-1))*data.value(i,:,:);
                end
                renderOption=obj.getRenderOption();
                plotOption=obj.getPlotOption();
                obj.renderAndPlot(data,renderOption,plotOption);
            end
        end
        function obj = openningFunction(obj)
            handles = findall(0,'Tag','DataBrowser');
            if isempty(handles)
                dataBrowser;
            end
        end            
    end
    
    
    %% Method: Callbacks
    methods % callbacks
        function pbLoadCallback(obj,~,~,fResize)
            set(obj.StrStatus,'String','Loading Data...');
            drawnow;
            LOW_RES = 64;
            % High Resolution Data
            varNames=getDataNames();
            dataName=varNames{1};
            dataHighRes = evalin('base',dataName);
            % check input
            xflag = ~isfield(dataHighRes,'x') && ~isprop(dataHighRes,'x');
            yflag = ~isfield(dataHighRes,'y') && ~isprop(dataHighRes,'y');
            zflag = ~isfield(dataHighRes,'z') && ~isprop(dataHighRes,'z');
            vflag = (~isfield(dataHighRes,'value') && ~isprop(dataHighRes,'value'))||...
                (ndims(dataHighRes.value)~=3);
            if xflag||yflag||zflag||vflag
                errordlg(['Target data set is not typical 3D ARPES data.',...
                    ' Only 3D ARPES map is accepted.']);
                return
            end
            
            % Preprocessing
            hMsg=msgbox('Preprocessing Data...','Busy');
            dataHighRes.value(isnan(dataHighRes.value))=0;
            
            ResizeOption=obj.getResizeOption();
            
            % Read Original/High Resolution Data
            if fResize == 1
                % resize data
                xmin=min(dataHighRes.x);
                xmax=max(dataHighRes.x);
                ymin=min(dataHighRes.y);
                ymax=max(dataHighRes.y);
                Lx=xmax-xmin;
                Ly=ymax-ymin;
                sizeXY=ResizeOption.sizeXY;
                if Lx>Ly
                    sizeX=sizeXY;
                    sizeY=ceil(Ly/Lx*sizeXY);
                else
                    sizeY=sizeXY;
                    sizeX=ceil(Lx/Ly*sizeXY);
                end
                sizeZ=ResizeOption.sizeZ;
                dataHighRes=resizeData(dataHighRes,sizeX,sizeY,sizeZ);
            else
                sizeX=length(dataHighRes.x);
                sizeY=length(dataHighRes.y);
                sizeZ=length(dataHighRes.z);
                sizeXY=max([sizeX,sizeY]);
                Lx=sizeX;
                Ly=sizeY;
            end  % end of fResize == 1          
            setappdata(obj.Figure,'dataHighRes',dataHighRes);
            setappdata(obj.Figure,'dataHighResPlot',dataHighRes); 
            
            % Read Low Resolution Data
            if Lx>Ly
                sizeXLowRes=LOW_RES;
                sizeYLowRes=ceil(Ly/Lx*LOW_RES);
            else
                sizeYLowRes=LOW_RES;
                sizeXLowRes=ceil(Lx/Ly*LOW_RES);
            end
            sizeZLowRes=sizeZ*LOW_RES/sizeXY;
            dataLowRes=resizeData(...
                dataHighRes,sizeXLowRes,sizeYLowRes,sizeZLowRes);
            setappdata(obj.Figure,'dataLowRes',dataLowRes);
            setappdata(obj.Figure,'dataLowResPlot',dataLowRes); 
            delete(hMsg);
            % Ending
            set(obj.StrDataName,'String',dataName);
            set(obj.StrStatus,'String','Data Loaded. Ready.');
        end % end of pbLoadCallback
                
        function PbPlotCallback(obj,varargin)
            data=getappdata(obj.Figure,'dataHighResPlot');
            set(obj.XSlice,'Max',length(data.x));
            set(obj.XLight,'Max',length(data.x));
            set(obj.YSlice,'Max',length(data.y));
            set(obj.ZSlice,'Max',length(data.z));
            renderOption=obj.getRenderOption();
            plotOption=obj.getPlotOption();
            obj.renderAndPlot(data,renderOption,plotOption);         
        end % end of PbPlotCallback
        
        function sRenderOptionCallback(obj,varargin)
            plotOption=obj.getPlotOption();
            if plotOption.AutoUpdate
                % Render and Plot
                data=getappdata(obj.Figure,'dataHighResPlot');
                renderOption=obj.getRenderOption();
                plotOption=obj.getPlotOption();
                obj.renderAndPlot(data,renderOption,plotOption);
            else
                return;
            end
        end
        
        function updatePlotData(obj,varargin)
            AlphaOption=obj.getAlphaOption();
            % High Resolution
            data=getappdata(obj.Figure,'dataHighRes');
            maxData=max(data.value(:));
            alphaMin=maxData*AlphaOption.AlphaMin/100;
            alphaMax=maxData*AlphaOption.AlphaMax/100;
            data.value(data.value<alphaMin)=alphaMin;
            data.value(data.value>alphaMax)=alphaMax;
            setappdata(obj.Figure,'dataHighResPlot',data);
            % Low Resolution
            data=getappdata(obj.Figure,'dataLowRes');
            maxData=max(data.value(:));
            alphaMin=maxData*AlphaOption.AlphaMin/100;
            alphaMax=maxData*AlphaOption.AlphaMax/100;
            data.value(data.value<alphaMin)=alphaMin;
            data.value(data.value>alphaMax)=alphaMax;
            setappdata(obj.Figure,'dataLowResPlot',data);
            % Render and Plot
            data=getappdata(obj.Figure,'dataHighResPlot');
            renderOption=obj.getRenderOption();
            plotOption=obj.getPlotOption();
            obj.renderAndPlot(data,renderOption,plotOption);
        end % end of updatePlotData
        
        function UIDegreeUpdate(obj,actionType,varargin)
            plotOption=obj.getPlotOption();
            if plotOption.AutoUpdate==0
                return
            end
            if actionType==1
                data=getappdata(obj.Figure,'dataLowResPlot');  
            elseif actionType==2
                data=getappdata(obj.Figure,'dataHighResPlot');
            else
                return;
            end
            % Render And Plot
            renderOption=obj.getRenderOption();
            plotOption=obj.getPlotOption();
            obj.renderAndPlot(data,renderOption,plotOption);
        end % end of UIDegreeUpdate
        
        function PbMakeMovieCallback(obj,varargin)
            
            movieOption = obj.getMovieOption();
            plotOption = obj.getPlotOption();
            renderOption = obj.getRenderOption();
            data = getappdata(obj.Figure,'dataHighResPlot');
            
            writerObj = VideoWriter(movieOption.FileName,'MPEG-4');
            writerObj.FrameRate=movieOption.FPS;
            n = movieOption.TotalFrames;
            open(writerObj);
            hWaitbar=waitbar(0,'Making movie... 0%','Name','Please wait');
            
            
            for i=1:n
                % Render and Plot
                % Mview
                Theta=obj.uiDegTheta.getDegree();
                Phi=i*360/n;
                v=[0 Theta Phi];
                renderOption.Mview=makeViewMatrix(v,[1 1 1],[0 0 0]);
                obj.renderAndPlot(data,renderOption,plotOption);
                frame=getframe;
                writeVideo(writerObj,frame);
                % Update hWaitbar
                waitbar(i/n,hWaitbar,...
                    [num2str(i/n*100,'Making movie... %6.2f%%'),...
                    ' phi=',num2str(i*360/n)]);
            end
            close(writerObj);
            close(hWaitbar);
        end
        
        function PbMakeVRMovieCallback(obj,varargin)
            
            movieOption = obj.getMovieOption();
            plotOption = obj.getPlotOption();
            renderOption = obj.getRenderOption();
            data = getappdata(obj.Figure,'dataHighResPlot');
            
            writerObj = VideoWriter(movieOption.FileName,'MPEG-4');
            writerObj.FrameRate=movieOption.FPS;
            n = movieOption.TotalFrames;
            open(writerObj);
            hWaitbar=waitbar(0,'Making movie... 0%','Name','Please wait');
            
            % Calculate Image Size
            sizeX=length(data.x);
            sizeY=length(data.y);
            sizeZ=length(data.z);
            sizeD=ceil(norm([sizeX,sizeY,sizeZ])*1.07/16)*16;
            valueCube1 = zeros(sizeD,sizeD,3,n);
            
            % Build a cross
            crossMat=zeros(50,50);
            crossMat(22:28,:)=1;
            crossMat(:,22:28)=1;
            crossMatBig=zeros(sizeD,sizeD);
            crossMatBig((75-25):(75+24),...
                (ceil(sizeD)/2-25):(ceil(sizeD)/2+24))=crossMat;
            crossMat3=repmat(crossMatBig,[1,1,3]);
            
            for i=1:n
                % Render and Plot
                % Mview
                Theta=obj.uiDegTheta.getDegree();
                Phi=i*360/n;
                v=[0 Theta Phi];
                renderOption.Mview=makeViewMatrix(v,[1 1 1],[0 0 0]);
                value = obj.getRenderData(data,renderOption);
                value(crossMat3==1)=1;
                valueCube1(:,:,:,i)= value;
                % Update hWaitbar
                waitbar(i/n,hWaitbar,...
                    [num2str(i/n*100,'Making movie... %6.2f%%'),...
                    ' phi=',num2str(i*360/n)]);
            end
            
            step = ceil(8/(360/n));
            valueCube2 =  zeros(sizeD,sizeD,3,n);
            valueCube2(:,:,:,(1+step):n)=valueCube1(:,:,:,1:(n-step));
            valueCube2(:,:,:,1:step)=valueCube1(:,:,:,(n-step+1):n);
            
            valueCube = cat(2,valueCube1,valueCube2);
            
            for i=1:n
                set(figure(plotOption.FigNum),...
                    'Position',[0,0,2*sizeD+10,sizeD+10])
                figure(plotOption.FigNum);
                imshow(valueCube(:,:,:,i));
                axis equal;
                axis off;
                frame=getframe;
                writeVideo(writerObj,frame);
            end
            close(writerObj);
            close(hWaitbar);
            
        end
        
        function setpointcloud(obj,varargin)
            obj.Data=getappdata(obj.Figure,'dataHighResPlot');
            obj.Gamma=get(obj.SliderGamma,'Value');
            obj.Density=get(obj.SliderDensity,'Value');
            set(obj.GammaValue,'String',num2str(obj.Gamma));
            set(obj.DensityValue,'String',num2str(obj.Density));
        end
        
        function PbExportPointCloudCallback(obj,varargin)
            % obj.Data.z=obj.Data.z*3;
            p=zeros(50000000,4);
            sizeOfX=length(obj.Data.x);
            rangeOfX=obj.Data.x(sizeOfX)-obj.Data.x(1);
            sizeOfY=length(obj.Data.y);
            rangeOfY=obj.Data.y(sizeOfY)-obj.Data.y(1);
            sizeOfZ=length(obj.Data.z);
            rangeOfZ=obj.Data.z(sizeOfZ)-obj.Data.z(1);
            %             sizeOfV=length(obj.Data.value);
            %             rangeOfV=obj.Data.value(sizeOfV)-obj.Data.value(1);
            mag=obj.Density;%magnification
            gamma=obj.Gamma;
            maxValue=max(obj.Data.value(:));
            xStep=rangeOfX/(sizeOfX-1);
            yStep=rangeOfY/(sizeOfY-1);
            zStep=rangeOfZ/(sizeOfZ-1);
            density=(obj.Data.value/maxValue).^gamma*mag;
            num(1:sizeOfX,1:sizeOfY,1:sizeOfZ)=round(density);
            count=0;
            h=waitbar(0);
            for i=1:sizeOfX
                for j=1:sizeOfY
                    for k=1:sizeOfZ
                        for m=1:num(i,j,k)
                            count=count+1;
                            p(count,1)=obj.Data.x(i)+(rand-0.5)*xStep;
                            p(count,2)=obj.Data.y(j)+(rand-0.5)*yStep;
                            p(count,3)=obj.Data.z(k)+(rand-0.5)*zStep;
                            p(count,4)=obj.Data.value(i,j,k);
                        end
                    end
                end
                waitbar(i/sizeOfX);
            end
            p(all(p==0,2),:)=[];
            delete(h);
            varNames=getDataNames();
            dataName=varNames{1};
            SaveName=inputdlg({'Data Name'},...
                'Save Slice',...
                1,...
                {[dataName,'_cloud.txt']});
            save(SaveName{1},'p','-ascii');
        end
    end
    
    
    %% Method: Helper functions
    methods % helper functions
        function renderAndPlot(obj,data,renderOption,plotOption)
            renderData=obj.getRenderData(data,renderOption);
            figure(plotOption.FigNum);
            imshow(renderData);
            axis off;
            set(obj.StrStatus,'String','Ready.');
        end % end of renderAndPlot
        
        function renderData = getRenderData(obj,data,renderOption)
            sizeX=length(data.x);
            sizeY=length(data.y);
            sizeZ=length(data.z);
            if sizeX>128||sizeY>128
                set(obj.StrStatus,'String','Rendering... Please wait.');
                drawnow;
            end
            sizeD=ceil(norm([sizeX,sizeY,sizeZ])*1.07/16)*16;
            renderOption.ImageSize=[sizeD,sizeD];
            renderData=render(data.value,renderOption);
        end % end of renderAndPlot
        
        function ResizeOption=getResizeOption(obj)
            ResizeOption.sizeZ = str2double(get(obj.InputSizeZ,'String'));
            ResizeOption.sizeXY = str2double(get(obj.InputSizeXY,'String'));
        end
        
        function PlotOption=getPlotOption(obj)
            PlotOption.AutoUpdate=get(obj.FlagAutoUpdate,'Value');
            PlotOption.FigNum=str2double(get(obj.InputFigNum,'String'));
        end
        
        function RenderOption=getRenderOption(obj)
            % RenderType
            selectRenderType=get(obj.SelectRenderType,'String');
            ind=get(obj.SelectRenderType,'Value');
            RenderOption.RenderType=selectRenderType{ind};
            % ShadingMaterial
            selectShadingMaterial=get(obj.SelectShadingMaterial,'String');
            ind=get(obj.SelectShadingMaterial,'Value');
            RenderOption.ShadingMaterial=selectShadingMaterial{ind};
            % ColorTable
            selectColorMapStyle=get(obj.SelectColorMapStyle,'String');
            ind=get(obj.SelectColorMapStyle,'Value');
            flagColorMapFlip=get(obj.FlagColorMapFlip,'Value');
            load('Colormap.mat');
            ColorMapTable=eval(selectColorMapStyle{ind});
            if flagColorMapFlip
                ColorMapTable=flipud(ColorMapTable);
            else
            end
            RenderOption.ColorTable=ColorMapTable;
            % Mview
            Theta=obj.uiDegTheta.getDegree();
            Phi=obj.uiDegPhi.getDegree();
            v=[0 Theta Phi];
            RenderOption.Mview=makeViewMatrix(v,[1 1 1],[0 0 0]);           
        end % end of getRenderOption
        
        function AlphaOption=getAlphaOption(obj)
            % Alpha Setting
            AlphaOption.AlphaMin=get(obj.InAlphaMin,'Value');
            AlphaOption.AlphaMax=get(obj.InputAlphaMax,'Value');
        end % end of getAlphaOption
        
        function MovieOption = getMovieOption(obj)
            MovieOption.FileName = get(obj.InputFileName,'String');
            MovieOption.TotalFrames = str2double(...
                get(obj.InputTotalFrames,'String'));
            MovieOption.FPS = str2double(get(obj.InputFPS,'String'));
        end

    end
end
        
