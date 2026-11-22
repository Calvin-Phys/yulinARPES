%PLOTSLICES Interactive viewer for ARPES data slices.
%   PlotSlices(DataName, Direction) reads the named variable from the MATLAB
%   base workspace and opens a GUI for viewing slices along x, y, or z.
%   The selected variable is expected to provide a numeric VALUE array and
%   coordinate vectors for the requested direction. A 2-D value array is
%   promoted to a single-slice 3-D array for the viewer.
%
%   The GUI provides slice position and width controls, colour limits and
%   gamma controls, interpolation, crosshairs, EDC/MDC plots, and ARPES tools
%   such as k-space conversion and saving the displayed slice. Layout and
%   colormap resources must be available on the MATLAB path.
classdef PlotSlices < handle

    properties
        % Source data and coordinate used to select the displayed slice.
        Direction % plotting direction: 'x', 'y', 'z' 
        Data % store the data object/struct
        minValue % min value of all Data.value
        maxValue % max value of all Data.value
        DataName % variable name of Data
        AxisData % Store the axis that the plot is along with
        CorrData % ?

        % Main figure, axes, controls, and graphics objects owned by the GUI.
        Figure % whole figure handle
        homeVBox % box alignment
        Axis % plot axis
        imag % image handle
        Crosshair % 
        CrosshairMenu
        MDCEDC_Menu
        Crosshair2

        PerpDistributionMenu
        PerpDistributionFigure

        InterpolateMenu
        interpolate_K = 1

        energy_contour_flag = 0
        energy_contour_menu
        energy_contour_lines

        bz_line_flag = 0
        bz_line_menu
        bz_line_lines

        SurfaceObj
        Checkbox
        Slider
        SliderMin
        SliderMax
        SliderGamma
        FigureEDC
        AxisEDC
        EDC_line
        MDC_line
        EDCRegionLines = gobjects(0)
        MDCRegionLines = gobjects(0)
        FigureMDC
        AxisMDC
        MenuMDCEDC
        MenuSaveMDCEDC
        ColorMap
        FlipCheckbox
        ClimCheckbox
        InterpCheckbox
        CrosshairCheckbox
        XYpos_Editfield
        
        Position
        PositionIndex
        Width % integral z direction
        MinValue
        MaxValue
        GammaValue
        PosX
        PosY
        DX
        DY
        VLine
        HLine
        Markers=[]
    end

    methods

        function obj = PlotSlices(DataName,Direction)
            % Accept either one variable name or a list and use the first item.
            if iscell(DataName)
                DataName=DataName{1};
            end
            if isstring(DataName) && isscalar(DataName)
                DataName = char(DataName);
            end
            if ~ischar(DataName) || ~isrow(DataName) || ~isvarname(DataName)
                error('PlotSlices:InvalidVariableName', ...
                    'DataName must be a valid MATLAB base-workspace variable name.');
            end
            if isstring(Direction) && isscalar(Direction)
                Direction = char(Direction);
            end
            if ~ischar(Direction) || ~isrow(Direction) || ...
                    ~any(strcmp(Direction, {'x', 'y', 'z'}))
                error('PlotSlices:InvalidDirection', ...
                    'Direction must be ''x'', ''y'', or ''z''.');
            end

            % Load the selected variable from the base workspace and verify
            % that it has the value array required by the slicing routines.
            obj.DataName = DataName;
            obj.Direction = Direction;
            workspaceNames = evalin('base', 'who');
            if ~any(strcmp(workspaceNames, DataName))
                error('PlotSlices:MissingWorkspaceVariable', ...
                    'The base workspace does not contain variable "%s".', DataName);
            end
            obj.Data = evalin('base', DataName);
            if ~PlotSlices.hasDataMember(obj.Data, 'value')
                error('PlotSlices:InvalidData', ...
                    'The selected variable must contain a value array.');
            end
            if ~isnumeric(obj.Data.value) && ~islogical(obj.Data.value)
                error('PlotSlices:InvalidData', ...
                    'The value array must be numeric or logical.');
            end
            if isa(obj.Data, 'OxArpes_1D_Data')
                error('PlotSlices:UnsupportedDataDimension', ...
                    'PlotSlices requires 2-D or 3-D data; use the 1-D data viewer.');
            end

            % Promote 2-D values for the common slicing implementation.
            valueDimensions = ndims(obj.Data.value);
            if isa(obj.Data, 'OxArpes_2D_Data')
                valueDimensions = 2;
            elseif PlotSlices.hasDataMember(obj.Data, 'z') && ...
                    isscalar(obj.Data.z) && valueDimensions == 2
                % MATLAB omits trailing singleton dimensions from ndims.
                valueDimensions = 3;
            end
            if valueDimensions == 2
                obj.data2Dto3D();
            elseif valueDimensions ~= 3
                error('PlotSlices:UnsupportedDataDimension', ...
                    'PlotSlices supports 2-D or 3-D value arrays, not %d-D arrays.', ...
                    valueDimensions);
            end
            obj.normalizeLegacyMetadata();
            obj.validatePlotData();

            obj.minValue = min(obj.Data.value(:));
            obj.maxValue = max(obj.Data.value(:));

            % The slider moves along the coordinate selected by Direction.
            obj.AxisData = obj.Data.(obj.Direction);

            % construct figure UI / menu
            obj.figureConstruct(DataName);
            obj.setUIMenu();

            % Choose useful default orientation and aspect settings when the
            % stored axis units indicate that two displayed axes are related.
            % Keep automatic equal scaling off for structs: missing units
            % default to empty strings, which would otherwise compare equal.
            if obj.Direction == 'z' && numel(obj.Data.x) ~= 1
                obj.FlipCheckbox.Value = 1;
                obj.Width.String = '0.05';
                
                try
                    if ~isstruct(obj.Data) && strcmp(obj.Data.x_unit,obj.Data.y_unit)
                        obj.Checkbox.Value = 1;
                    end
                catch
                end

            end

            if obj.Direction == 'x'
                try
                    if ~isstruct(obj.Data) && strcmp(obj.Data.y_unit,obj.Data.z_unit)
                        obj.Checkbox.Value = 1;
                    end
                catch
                end
            end

            % Draw the initial slice before adding interactive crosshairs.
            obj.initial_plot();
            

            % hide menubar/toolbar
%             ss = allchild(obj.Figure);
%             for i = [4,5,6,7,10,11]
%                 ss(i).Visible = 'off';
%             end

            % The first crosshair selects one point; moving it refreshes the
            % displayed coordinates and any linked EDC/MDC traces.
            obj.Crosshair = drawcrosshair('Parent', obj.Axis, ...
                'Position', [obj.PosX obj.PosY], 'LineWidth', 1, ...
                'Color', "c", 'Visible', 'off');
            addlistener(obj.Crosshair, 'ROIMoved', ...
                @(src, data) obj.update_Crosshair_Positions( ...
                data.CurrentPosition(1), data.CurrentPosition(2)));

            % The second crosshair defines the integration span for the EDC
            % and MDC plots.
            obj.Crosshair2 = drawcrosshair('Parent', obj.Axis, ...
                'Position', [obj.PosX + obj.DX obj.PosY + obj.DY], ...
                'LineWidth', 1, 'Color', 'w', 'Visible', 'off');
            obj.Crosshair2.StripeColor = "c";
            addlistener(obj.Crosshair2, 'ROIMoved', ...
                @(src, data) obj.update_Crosshair2_Positions( ...
                data.CurrentPosition(1), data.CurrentPosition(2)));
        end
        
        function data2Dto3D(obj)
            % Represent a 2-D dataset as a one-element x dimension. The
            % original x/y coordinates become the viewer's y/z coordinates.
            sourceData = obj.Data;
            if ~PlotSlices.hasDataMember(sourceData, 'x') || ...
                    ~PlotSlices.hasDataMember(sourceData, 'y')
                error('PlotSlices:InvalidAxes', ...
                    'Two-dimensional data must provide x and y coordinates.');
            end
            oldX = sourceData.x(:).';
            oldY = sourceData.y(:).';
            if ~isnumeric(oldX) || ~isnumeric(oldY) || ...
                    numel(oldX) ~= size(sourceData.value, 1) || ...
                    numel(oldY) ~= size(sourceData.value, 2)
                error('PlotSlices:InvalidAxes', ...
                    'The 2-D value dimensions must match the x and y coordinates.');
            end
            value3D = reshape(sourceData.value, 1, numel(oldX), numel(oldY));
            oldXName = '';
            oldXUnit = '';
            oldYName = '';
            oldYUnit = '';
            if PlotSlices.hasDataMember(sourceData, 'x_name')
                oldXName = sourceData.x_name;
            end
            if PlotSlices.hasDataMember(sourceData, 'x_unit')
                oldXUnit = sourceData.x_unit;
            end
            if PlotSlices.hasDataMember(sourceData, 'y_name')
                oldYName = sourceData.y_name;
            end
            if PlotSlices.hasDataMember(sourceData, 'y_unit')
                oldYUnit = sourceData.y_unit;
            end

            if isa(sourceData, 'OxArpes_2D_Data')
                data = OxArpes_3D_Data(1, oldX, oldY, value3D);
                data.name = sourceData.name;
                data.info = sourceData.info;
                data.x_name = 'Index';
                data.x_unit = 'index';
                data.y_name = oldXName;
                data.y_unit = oldXUnit;
                data.z_name = oldYName;
                data.z_unit = oldYUnit;
            else
                % Copy legacy structs (or other public-property objects) so
                % acquisition metadata and repository-specific fields survive.
                if isstruct(sourceData)
                    data = sourceData;
                else
                    data = struct(sourceData);
                end
                data.x = 1;
                data.y = oldX;
                data.z = oldY;
                data.value = value3D;
                data.x_name = '';
                data.x_unit = '';
                data.y_name = oldXName;
                data.y_unit = oldXUnit;
                data.z_name = oldYName;
                data.z_unit = oldYUnit;
                if ~isfield(data, 'info')
                    data.info = struct();
                end
            end

            obj.Data = data;
            obj.Direction = 'x';
        end
        
%         function data4Dto3D(obj)
%             return; % to be added
%         end
        
        function figureConstruct(obj,DataName)
            % Build the main figure, slice controls, and colour controls.
            %% Figure layout
            obj.Figure = figure('Name', DataName, 'MenuBar', 'none', ...
                'ToolBar', 'none', ...
                'CloseRequestFcn', @obj.closeMainFigure);

            obj.homeVBox=uiextras.VBox('Parent',obj.Figure,'BackgroundColor','w');

            infoHBox=uiextras.HBox('Parent',obj.homeVBox); 
            colorHBox=uiextras.HBox('Parent',obj.homeVBox);
%             optionHBox = uiextras.HBox('Parent',obj.homeVBox);
            obj.Axis=axes('Parent',obj.homeVBox);

            colorleftVBox=uiextras.VBox('Parent',colorHBox);
            colorrightVBox=uiextras.VBox('Parent',colorHBox);
            colorMinHBox=uiextras.HBox('Parent',colorleftVBox);
            colorMaxHBox=uiextras.HBox('Parent',colorleftVBox);
            colorGammaHBox=uiextras.HBox('Parent',colorrightVBox);
            colormapHBox=uiextras.HBox('Parent',colorrightVBox);

            
            if isscalar(obj.Data.x)
                set(obj.homeVBox,'Sizes',[0,40,-1]);
            else
                set(obj.homeVBox,'Sizes',[20,40,-1]);
            end
            set(colorHBox,'Sizes',[-1,-1]);
            set(colorleftVBox,'Sizes',[-1,-1]);
            set(colorrightVBox,'Sizes',[-1,-1]);

            axisMin=min(obj.AxisData);
            axisMax=max(obj.AxisData);
            step=1/numel(obj.AxisData);
            
            %% Controls for slice position and averaging width
            uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'Text',...
                'String',       ['Along ',obj.Direction],...
                'BackgroundColor','w');
            obj.Checkbox=uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'Checkbox',...
                'String',       'Ax Equal',...
                'Callback',     @obj.setAx);
            obj.Slider=uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'Slider',...
                'Min',          axisMin,...
                'Max',          axisMax,...
                'Value',        mean([axisMin,axisMax]),...
                'SliderStep',   [step,5*step]);
            addlistener(obj.Slider,'Value','PostSet',@obj.update_CData);
            uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'Text',...
                'String',       'Pos');
            obj.Position=uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'Edit',...
                'String',       num2str(round(mean([axisMin,axisMax]),3)),...
                'BackgroundColor','w',...
                'Callback',     @obj.setPos);
            %%
            uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'Text',...
                'String',       'Width');
            obj.Width=uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'Edit',...
                'String',       '0',...
                'BackgroundColor','w',...
                'Callback',     @obj.update_CData);
            %%
            uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'Text',...
                'String',       'Ind');
            uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'PushButton',...
                'String',       '<',...
                'Callback',     {@obj.setInd,'-'});
            obj.PositionIndex=uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'Edit',...
                'String',       num2str(round((1+numel(obj.AxisData)/2))),...
                'BackgroundColor','w',...
                'Callback',     {@obj.setInd,'='});
            uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'PushButton',...
                'String',       '>',...
                'Callback',     {@obj.setInd,'+'});
            set(infoHBox,'Sizes',[45,70,-1,20,50,30,30,20,15,30,15]);
            
            %% Controls for colour limits, gamma, and colormap
            uicontrol(...
                'Parent',       colorMinHBox,...
                'Style',        'Text',...
                'String',       'Min(%)');
            obj.MinValue=uicontrol(...
                'Parent',       colorMinHBox,...
                'Style',        'Edit',...
                'String',       '0',...
                'BackgroundColor','w',...
                'Callback',     @obj.sliderinput);
            obj.SliderMin=uicontrol(...
                'Parent',       colorMinHBox,...
                'Style',        'Slider',...
                'Min',          0,...
                'Max',          3,...
                'Value',        0);
            addlistener(obj.SliderMin,'Value','PostSet',@obj.setClim);
            set(colorMinHBox,'Sizes',[40,40,-1]);
            
            uicontrol(...
                'Parent',       colorMaxHBox,...
                'Style',        'Text',...
                'String',       'Max(%)');
            obj.MaxValue=uicontrol(...
                'Parent',       colorMaxHBox,...
                'Style',        'Edit',...
                'String',       '100',...
                'BackgroundColor','w',...
                'Callback',     @obj.sliderinput);
            obj.SliderMax=uicontrol(...
                'Parent',       colorMaxHBox,...
                'Style',        'Slider',...
                'Min',          0,...
                'Max',          3,...
                'Value',        log10(100+1));
            addlistener(obj.SliderMax,'Value','PostSet',@obj.setClim);
            set(colorMaxHBox,'Sizes',[40,40,-1]);
            
            uicontrol(...
                'Parent',       colorGammaHBox,...
                'Style',        'Text',...
                'String',       'γ');
            obj.GammaValue=uicontrol(...
                'Parent',       colorGammaHBox,...
                'Style',        'Edit',...
                'String',       '1',...
                'BackgroundColor','w',...
                'Callback',     @obj.setGamma);
            obj.SliderGamma=uicontrol(...
                'Parent',       colorGammaHBox,...
                'Style',        'Slider',...
                'Min',          0,...
                'Max',          3,...
                'Value',        1);
            addlistener(obj.SliderGamma,'Value','PostSet',@obj.update_CData);
            obj.CrosshairCheckbox=uicontrol(...
                'Parent',       colorGammaHBox,...
                'Style',        'Checkbox',...
                'String',       'Cursor',...
                'Value',        0,...
                'Callback',     @obj.crosshair_menu_callback);

            obj.XYpos_Editfield = uicontrol(...
                'Parent',       colorGammaHBox,...
                'Style',        'Text',...
                'String',       '()',...
                'BackgroundColor','w');

            set(colorGammaHBox,'Sizes',[20,30,-1,55,85]);

            obj.ClimCheckbox=uicontrol(...
                'Parent',       colormapHBox,...
                'Style',        'Checkbox',...
                'String',       'Fix Clim',...
                'Value',        1,...
                'Callback',     @obj.setClim);
            obj.InterpCheckbox=uicontrol(...
                'Parent',       colormapHBox,...
                'Style',        'Checkbox',...
                'String',       'Interp',...
                'Value',        0,...
                'Callback',     @obj.interpolate_menu_callback);
            obj.FlipCheckbox=uicontrol(...
                'Parent',       colormapHBox,...
                'Style',        'Checkbox',...
                'String',       'Flip',...
                'Value',        1,...
                'Callback',     @obj.setColor);
            obj.ColorMap=uicontrol(...
                'Parent',       colormapHBox,...
                'Style',        'popup',...
                'String',       {...
                    ... % usual
                    'gray','cm_blue','heat','arctic','cm_redwhiteblue','cm_terrain',...
                    ... % system
                    'copper','pink','hot','cool','sky','abyss','Blues',...
                    'spring','summer','autumn','winter','jet','hsv','turbo','parula' ...
                    ... % user defined: single color
                    'cm_red', 'cm_green','cm_cyan','cm_magenta','cm_yellow', ...
                    'cm_gold','cm_copper',...
                    ... % two colors
                    'cm_bluehot','cm_yellowhot','cm_cyanmagenta','cm_redwhite', ...
                    ... % three colors
                    'cm_blueredgreen','cm_redwhitegreen','cm_blueblackred'...
                    ... % more
                    'cm_geo','cm_landandsea','cm_pastels','cm_pastelsmap',...
                    'cm_planetearth','cm_rainbow','cm_relief','cm_spectrum', ...
                    'cm_blackbody'},...
                'Callback',     @obj.setColor);
            set(colormapHBox,'Sizes',[60,50,40,-1]);    
        end
        
        function setUIMenu(obj)
            % Add commands for saving/cutting slices, toggling overlays, and
            % opening alternate plot layouts. Some commands are direction-only.
            hmenu=uimenu(obj.Figure,'Label','ARPES Tools');

            cutMenu=uimenu(hmenu,'Label','Cut','Callback',@obj.cut);
            if ~strcmp(obj.Direction,'z')
                set(cutMenu,'Enable','off');
            end
            uimenu(hmenu,'Label','Save Slice','Callback',@obj.save_slice);
            uimenu(hmenu,'Label','Sub plot in new figure',...
                'Callback',@obj.newFigureSubPlot);
%             obj.MenuMDCEDC=uimenu(hmenu,'Label','MDC/EDC',...
%                 'Callback',@obj.mdcedc); 
%             obj.MenuSaveMDCEDC=uimenu(hmenu,'Label','Save MDC/EDC',...
%                 'Callback',@obj.saveMdcEdc);
%             set(obj.MenuSaveMDCEDC,'Enable','off');
            corMenu=uimenu(hmenu,'Label','Square correction',...
                'Callback',@obj.sqCorrection);
            if strcmp(obj.Direction,'z')
                set(corMenu,'Enable','off');
            end
            corrMenu=uimenu(hmenu,'Label','Fermi Surface correction','Callback',@obj.correction);
            %Along x or y is permitted
            if strcmp(obj.Direction,'z')
                set(corrMenu,'Enable','off');
            end

            obj.CrosshairMenu=uimenu(hmenu,'Label','Crosshair',...
                'Separator','on','Callback',@obj.crosshair_menu_callback);
            obj.MDCEDC_Menu=uimenu(hmenu,'Label','EDC/MDC',...
                'Callback',@obj.MDCEDC_menu_callback);
            obj.PerpDistributionMenu=uimenu(hmenu,'Label','Perp-Distribution',...
                'Callback',@obj.perp_DC_menu_callback);
            uimenu(hmenu,'Label','Histogram','Callback',@obj.histogram_menu_callback);


            uimenu(hmenu,'Label','K-Convert (new)', ...
                'Separator','on','Callback',@obj.quick_KConvert);
            obj.InterpolateMenu=uimenu(hmenu,'Label','Interploate',...
                'Callback',@obj.interpolate_menu_callback);
            
            obj.energy_contour_menu=uimenu(hmenu,'Label','Energy contour',...
                'Separator','on','Callback',@obj.energy_contour_menu_callback);
            obj.bz_line_menu=uimenu(hmenu,'Label','Brillouin zone',...
                'Callback',@obj.bz_line_menu_callback);
            
%             %Along x or y is permitted
%             if ~strcmp(obj.Direction,'z') 
%                 set(corrMenu,'Enable','off');
%             end

            plotMenu=uimenu(obj.Figure,'Label','New plot');
            uimenu(plotMenu,'Label','2D Plot',...
                'Callback',{@obj.newFigure,2});
            uimenu(plotMenu,'Label','3D Plot',...
                'Callback',{@obj.newFigure,3});
            uimenu(plotMenu,'Label','2D Plot: Interpolate',...
                'Callback',{@obj.newFigure,4});
            uimenu(plotMenu,'Label','Mass Plot',...
                'Callback',@obj.mass_plot);
%             uimenu(plotMenu,'Label','Copy to Clipboard',...
%                 'Callback',{@print,obj.Figure,'-clipboard','-dpng'});
        end
        
     
        function initial_plot(obj,varargin)

       
 
             % Select the initial slab around the current slider position.
             % If the width contains no samples, use the nearest axis point.
            pos = get(obj.Slider,'Value');
            width = str2double(get(obj.Width, 'String'));

            % slice data
            switch obj.Direction
                case 'x'
                    xData = obj.Data.y;
                    yData = obj.Data.z;
                    xData_label = arpes_axis_label(obj.Data, 'y');
                    yData_label = arpes_axis_label(obj.Data, 'z');
                    cond = ( abs(obj.AxisData - pos) <= width/2 );
                    if ~any(cond)
                        [~,cond] = min(abs(obj.AxisData - pos));
                    end
                    sliceData = squeeze(mean(obj.Data.value(cond,:,:),1));
                case 'y'
                    xData = obj.Data.x;
                    yData = obj.Data.z;
                    xData_label = arpes_axis_label(obj.Data, 'x');
                    yData_label = arpes_axis_label(obj.Data, 'z');
                    cond = ( abs(obj.AxisData - pos) <= width/2 );
                    if ~any(cond)
                        [~,cond] = min(abs(obj.AxisData - pos));
                    end
                    sliceData = squeeze(mean(obj.Data.value(:,cond,:),2));
                otherwise
                    xData = obj.Data.x;
                    yData = obj.Data.y;
                    xData_label = arpes_axis_label(obj.Data, 'x');
                    yData_label = arpes_axis_label(obj.Data, 'y');
                    cond = ( abs(obj.AxisData - pos) <= width/2 );
                    if ~any(cond)
                        [~,cond] = min(abs(obj.AxisData - pos));
                    end
                    sliceData = squeeze(mean(obj.Data.value(:,:,cond),3));
            end

             % Optional interpolation and gamma correction prepare the slice
             % before it is drawn. Plot-type arguments can target a new axes.
%             if obj.interpolate_K ~= 1
% %                 sliceData = interp2(sliceData,obj.interpolate_K,'spline');
%                 sliceData = interp2(sliceData,obj.interpolate_K,'makima');
%                 sliceData(sliceData<0) = 0;
%             end

            gamma = get(obj.SliderGamma,'Value');
            if gamma~=1
                if gamma==0
                    sliceData = log(sliceData+0.1);
                else
                    sliceData = (sliceData/max(sliceData,[],"all")).^gamma .* max(sliceData,[],"all");
                end
            end

            % Color Mapping


             % Select the main axes or the alternate axes requested by the
             % New Plot menu (2-D, 3-D mesh, or interpolated 2-D plot).
            axPlot=obj.Axis;
            axFlag=0;
            if ~isempty(varargin)
                if isa(varargin{1},'char')
                    if strcmp(varargin{1},'new2')
                        axPlot=varargin{2};
                        axFlag=1;
                    elseif strcmp(varargin{1},'new3')
                        axPlot=varargin{2};
                        axFlag=2;
                    elseif strcmp(varargin{1},'new2intp')
                        axPlot=varargin{2};
                        axFlag=3;
                    end
                end
            end

            if axFlag == 0
                obj.imag = imagesc(obj.Axis,xData,yData,sliceData');
                set(obj.Axis,'YDir','normal');
                try
                    xlabel(obj.Axis,xData_label);
                    ylabel(obj.Axis,yData_label);
                catch
                end
            elseif axFlag == 1
                imagesc(axPlot,xData,yData,sliceData');
                set(axPlot,'YDir','normal');
                try
                    xlabel(axPlot,xData_label);
                    ylabel(axPlot,yData_label);
                catch
                end
            elseif axFlag == 2
                mesh(axPlot,xData,yData,sliceData');
                set(axPlot,'YDir','normal');
                try
                    xlabel(axPlot,xData_label);
                    ylabel(axPlot,yData_label);
                catch
                end
            elseif axFlag == 3
                K = 3;
                sliceData_new = interp2(sliceData',K,'spline');
                sliceData_new(sliceData_new<0) = 0;
                imagesc(axPlot,xData,yData,sliceData_new);
                set(axPlot,'YDir','normal');
                try
                    xlabel(axPlot,xData_label);
                    ylabel(axPlot,yData_label);
                catch
                end

            end

             % Load the selected named colormap and optionally reverse it.
            colorMapNames = get(obj.ColorMap, 'String');
            colorMapName = colorMapNames{get(obj.ColorMap, 'Value')};
            cmapData = obj.loadColormap(colorMapName);
            if get(obj.FlipCheckbox,'Value')
                colormap(axPlot,flipud(cmapData));
            else
                colormap(axPlot,cmapData);
            end

             % Map the percentage controls to colour limits for either the
             % current slice or the full source dataset.
            minSlider = 10^get(obj.SliderMin,'Value') -1;
            maxSlider = 10^get(obj.SliderMax,'Value') -1;
            minPercent = min(maxSlider,minSlider);
            maxPercent = max(maxSlider,minSlider);

            slice_data_max = max(sliceData,[],"all");

            if get(obj.ClimCheckbox,'Value')
                if minPercent/100*slice_data_max == maxPercent/100*slice_data_max
                    clim(axPlot,[minPercent/100*obj.maxValue maxPercent/100*obj.maxValue]);
                else
                    clim(axPlot,[minPercent/100*slice_data_max maxPercent/100*slice_data_max]);
                end

            else
                valueRange = (obj.maxValue - obj.minValue);
                clim(axPlot,[minPercent maxPercent]/100*valueRange + obj.minValue);
            end

            %set Axis equal or not
            if get(obj.Checkbox,'Value') && axFlag~=2
                set(axPlot,'DataAspectRatio',[1 1 1]);
            else
                axis(axPlot,'normal');
            end
            set(axPlot, 'LineWidth', 1.5, 'FontSize', 12, ...
                'FontName', 'Arial', 'Box', 'on', 'Layer', 'top');

%             % plot energy contour
            if obj.energy_contour_flag == 1 && ...
                    isfield(obj.Data.info, 'BZBS')
                if axFlag == 0
                    for i = 1:length(obj.energy_contour_lines)
                        delete(obj.energy_contour_lines{i})
                    end
                    obj.energy_contour_lines = obj.Data.info.BZBS.plotEnergyContourOnAxes(pos,width,axPlot);
                elseif axFlag == 1 || axFlag == 3
                    obj.Data.info.BZBS.plotEnergyContourOnAxes(pos,width,axPlot);
                end
            end
%             % plot brillouin zone
            if obj.bz_line_flag == 1 && isfield(obj.Data.info, 'BZBS')
                if axFlag == 0
                    for i = 1:length(obj.bz_line_lines)
                        delete(obj.bz_line_lines{i});
                    end
                    obj.bz_line_lines = obj.Data.info.BZBS.plotBrillouinZoneOnAxes(axPlot);

                elseif axFlag == 1 || axFlag == 3
                    obj.Data.info.BZBS.plotBrillouinZoneOnAxes(axPlot);
                end
            end
            
%             % for crosshair
            obj.PosX = mean(xData);
            obj.PosY = mean(yData);
            obj.DX = 0.1*(max(xData) - min(xData));
            obj.DY = 0.1*(max(yData) - min(yData));

%             % set EDC/MDC
%             flagMDCEDC = get(obj.MenuMDCEDC,'Checked');
%             if strcmp(flagMDCEDC,'on')
%                 obj.plotCrossHair;
%             end
        end

        function update_CData(obj,varargin)
            % Recompute the slab after a slider, width, interpolation, or
            % gamma change, then refresh overlays and linked axis controls.
            %% get sliced data
            pos = get(obj.Slider,'Value');
            width = str2double(get(obj.Width, 'String'));
            
            switch obj.Direction
                case 'x'
                    cond = ( abs(obj.AxisData - pos) <= width/2 );
                    if ~any(cond)
                        [~,cond] = min(abs(obj.AxisData - pos));
                    end
                    sliceData = squeeze(mean(obj.Data.value(cond,:,:),1));
                case 'y'
                    cond = ( abs(obj.AxisData - pos) <= width/2 );
                    if ~any(cond)
                        [~,cond] = min(abs(obj.AxisData - pos));
                    end
                    sliceData = squeeze(mean(obj.Data.value(:,cond,:),2));
                otherwise
                    cond = ( abs(obj.AxisData - pos) <= width/2 );
                    if ~any(cond)
                        [~,cond] = min(abs(obj.AxisData - pos));
                    end
                    sliceData = squeeze(mean(obj.Data.value(:,:,cond),3));
            end

            %% data enhance
            % interpolate
            if obj.interpolate_K ~= 1
%                 sliceData = interp2(sliceData,obj.interpolate_K,'spline');
                sliceData = interp2(sliceData,obj.interpolate_K,'makima');
                sliceData(sliceData<0) = 0;
            end

            gamma = get(obj.SliderGamma,'Value');
            if gamma==1
                obj.imag.CData = sliceData';
            elseif gamma==0
                obj.imag.CData = log(sliceData'+0.1);
            else
                obj.imag.CData = (sliceData'/max(sliceData,[],"all")).^gamma .* max(sliceData,[],"all");
            end

            %% set value
            set(obj.Position,'String',num2str(round(pos,3)));
            [~,cond] = min(abs(obj.AxisData - pos));
            set(obj.PositionIndex,'String',num2str(cond));
            set(obj.GammaValue,'String',num2str(round(gamma,3)));

            obj.setClim();
%             % plot energy contour
            if obj.energy_contour_flag == 1 && ...
                    isfield(obj.Data.info, 'BZBS')

                for i = 1:length(obj.energy_contour_lines)
                    delete(obj.energy_contour_lines{i})
                end

                obj.energy_contour_lines = obj.Data.info.BZBS.plotEnergyContourOnAxes(pos,width,obj.Axis);
            end
%              % plot brillouin zone
            if obj.bz_line_flag == 1 && isfield(obj.Data.info, 'BZBS')

                for i = 1:length(obj.bz_line_lines)
                    delete(obj.bz_line_lines{i})
                end

                obj.bz_line_lines = obj.Data.info.BZBS.plotBrillouinZoneOnAxes(obj.Axis);
            end

            if strcmp(get(obj.MDCEDC_Menu, 'Checked'), 'on')
                obj.updateEDCMDCPlots();
            end
        end

        %% menu callback function
        function newFigure(obj,varargin)
            % Reuse the current slice to create a separate 2-D, 3-D, or
            % interpolated figure without changing the main viewer axes.
            plotType=varargin{3};
            pos=get(obj.Position,'String');
            posInd=get(obj.PositionIndex,'String');
            hFig=figure('Name',[obj.DataName,' ',obj.Direction,'=',pos,' ','index=',posInd],'Color','w');
            h=axes('Parent',hFig);
            if plotType==2
                obj.initial_plot('new2',h);
            elseif plotType==3
                obj.initial_plot('new3',h);
            elseif plotType==4
                obj.initial_plot('new2intp',h);
            end
            % copy line objects
            lines = findall(obj.Axis,'Type','line');
            copyobj(lines,h);

        end
        
        function setInd(obj,~,~,SetMethod)
            % Move the slice index by one, or use the edited index directly.
            switch SetMethod
                case '+'
                    posInd = str2double(get(obj.PositionIndex,'String'))+1;                    
                case '-'
                    posInd = str2double(get(obj.PositionIndex,'String'))-1;
                case '='
                    posInd = str2double(get(obj.PositionIndex,'String'));
            end
            if posInd > numel(obj.AxisData)
                posInd = numel(obj.AxisData);
            end
            if posInd < 1
                posInd = 1;
            end
            pos = obj.AxisData(posInd);
            set(obj.Slider,'Value',pos);
            obj.update_CData();
        end
        
        function setPos(obj,~,~)
            % Apply the numeric position entered in the slice-position field.
            pos = str2double(get(obj.Position,'String'));
            set(obj.Slider,'Value',pos);
            obj.update_CData();
        end
        
        function setAx(obj,~,~)
            % Toggle equal data-unit scaling on the main viewer axes.
            if get(obj.Checkbox,'Value')
                set(obj.Axis,'DataAspectRatio',[1 1 1]);
            else
                axis normal;
            end
        end

        function setColor(obj,~,~)
            % Apply the selected colormap to the main axes, optionally flipped.
            colorMapNames = get(obj.ColorMap, 'String');
            colorMapName = colorMapNames{get(obj.ColorMap, 'Value')};
            cmapData = obj.loadColormap(colorMapName);
            if get(obj.FlipCheckbox,'Value')
                colormap(obj.Axis,flipud(cmapData));
            else
                colormap(obj.Axis,cmapData);
            end
        end

        function setClim(obj,~,~)
            % Convert the logarithmic slider values into colour limits and
            % synchronize the editable percentage fields.
            % set Clim
            minSlider = 10^get(obj.SliderMin,'Value') -1;
            maxSlider = 10^get(obj.SliderMax,'Value') -1;
            minPercent = min(maxSlider,minSlider);
            maxPercent = max(maxSlider,minSlider);

            slice_data_max = max(obj.imag.CData,[],"all");

            if get(obj.ClimCheckbox,'Value')
                if minPercent/100*slice_data_max == maxPercent/100*slice_data_max
                    clim(obj.Axis,[minPercent/100*obj.maxValue maxPercent/100*obj.maxValue]);
                else
                    clim(obj.Axis,[minPercent/100*slice_data_max maxPercent/100*slice_data_max]);
                end
                
            else
                valueRange = (obj.maxValue - obj.minValue);
                clim(obj.Axis,[minPercent maxPercent]/100*valueRange + obj.minValue);
            end

            set(obj.MinValue,'String',num2str(round(minSlider,2)));
            set(obj.MaxValue,'String',num2str(round(maxSlider,2)));

        end

        %% remove
        %         function setAutoClim(obj,~,~)
        %             % set Clim
        %             minSlider = 10^get(obj.SliderMin,'Value') -1;
        %             maxSlider = 10^get(obj.SliderMax,'Value') -1;
        %             minPercent = min(maxSlider,minSlider);
        %             maxPercent = max(maxSlider,minSlider);
        % 
        %             slice_data_max = max(obj.imag.CData,[],"all");
        % 
        %             if get(obj.ClimCheckbox,'Value')
        %                 clim(obj.Axis,[minPercent/100*slice_data_max maxPercent/100*slice_data_max]);
        %             else
        %                 clim(obj.Axis,[minPercent/100*obj.maxValue maxPercent/100*obj.maxValue]);
        %             end
        % 
        %             set(obj.MinValue,'String',num2str(minSlider));
        %             set(obj.MaxValue,'String',num2str(maxSlider));
        %         end


        function setGamma(obj,~,~)
            % Clamp the entered gamma value to the slider's supported range.
            gamma = str2double(get(obj.GammaValue,'String'));
            if ~isscalar(gamma) || ~isfinite(gamma)
                errordlg('Gamma must be a finite numeric scalar.', 'Invalid Gamma');
                set(obj.GammaValue, 'String', num2str(get(obj.SliderGamma, 'Value')));
                return
            end
            if gamma > 3
                gamma = 3;
            elseif gamma < 0
                gamma = 0;
            end
            set(obj.SliderGamma,'Value',gamma);
            obj.update_CData();
        end

        function sliderinput(obj,varargin)
            % Convert the editable min/max percentages to the logarithmic
            % scale used by their sliders, then refresh the colour limits.
            minInput=str2double(get(obj.MinValue,'String'));
            if minInput<0
                minInput=0;
            else
                minInput=log10(minInput+1);
            end
            set(obj.SliderMin,'Value',round(minInput,3));
            
            maxInput=str2double(get(obj.MaxValue,'String'));
            if maxInput<0
                maxInput=0;
            else
                maxInput=log10(maxInput+1);
            end
            set(obj.SliderMax,'Value',round(maxInput,3));
            
            obj.setClim();
%             gammaInput=str2double(get(obj.GammaValue,'String'));
%             if 0.001>gammaInputEditfield
%                 gammaInput=0.001;
%             end
%             if 5<gammaInput
%                 gammaInput=5;
%             end
%             set(obj.SliderGamma,'Value',gammaInput);
%             plot(obj,obj.Axis);
        end

        %% convert cut
        function update_Crosshair_Positions(obj,x,y)
            % Store the primary cursor position and move the linked span cursor.
            obj.PosX = x;
            obj.PosY = y;

            set(obj.XYpos_Editfield,'String', [num2str(round(x,3)) ', ' num2str(round(y,3))]);
            obj.Crosshair2.Position = [obj.PosX + obj.DX, obj.PosY + obj.DY];

            if strcmp(get(obj.MDCEDC_Menu, 'Checked'), 'on')
                obj.updateEDCMDCPlots();
            end

        end

        function update_Crosshair2_Positions(obj,x,y)
            % Store the second cursor offset and recompute EDC/MDC integrations.
            obj.DX = x - obj.PosX;
            obj.DY = y - obj.PosY;

            if strcmp(get(obj.MDCEDC_Menu, 'Checked'), 'on')
                obj.updateEDCMDCPlots();
            end
        end

        function updateEDCMDCPlots(obj)
            % Average the image inside the cursor rectangle and refresh both traces.
            if ~isgraphics(obj.EDC_line) || ~isgraphics(obj.MDC_line)
                return
            end
            xl = min(obj.PosX,obj.PosX+obj.DX);
            xr = max(obj.PosX,obj.PosX+obj.DX);
            [~,xn1] = min(abs(obj.imag.XData-xl));
            [~,xn2] = min(abs(obj.imag.XData-xr));
            xIndices = sort([xn1, xn2]);
            edcValues = mean(obj.imag.CData(:, xIndices(1):xIndices(2)), 2);
            obj.EDC_line.XData = edcValues(:).';
            obj.EDC_line.YData = obj.imag.YData(:).';

            yd = min(obj.PosY,obj.PosY+obj.DY);
            yu = max(obj.PosY,obj.PosY+obj.DY);
            [~,yn1] = min(abs(obj.imag.YData-yd));
            [~,yn2] = min(abs(obj.imag.YData-yu));
            yIndices = sort([yn1, yn2]);
            mdcValues = mean(obj.imag.CData(yIndices(1):yIndices(2), :), 1);
            obj.MDC_line.XData = obj.imag.XData(:).';
            obj.MDC_line.YData = mdcValues;

            if numel(obj.EDCRegionLines) == 2 && all(isgraphics(obj.EDCRegionLines))
                regionY = [obj.PosY, obj.PosY + obj.DY];
                for lineIndex = 1:2
                    obj.EDCRegionLines(lineIndex).Value = regionY(lineIndex);
                end
            end
            if numel(obj.MDCRegionLines) == 2 && all(isgraphics(obj.MDCRegionLines))
                regionX = [obj.PosX, obj.PosX + obj.DX];
                for lineIndex = 1:2
                    obj.MDCRegionLines(lineIndex).Value = regionX(lineIndex);
                end
            end
        end

        function crosshair_menu_callback(obj,~,~)
            % Toggle the primary cursor. Turning it off also closes linked
            % EDC/MDC figures because those plots require a cursor position.
            if strcmp(obj.Crosshair.Visible, 'on')
                if strcmp(get(obj.MDCEDC_Menu, 'Checked'), 'on')
                    obj.Crosshair2.Visible = 'off';
                    obj.closeEDCMDCFigures();
                end
                obj.Crosshair.Visible = 'off';
                set(obj.CrosshairMenu,'Checked','off');
                set(obj.CrosshairCheckbox,'Value',0);
            else
                obj.Crosshair.Visible = 'on';
                set(obj.CrosshairMenu,'Checked','on');
                set(obj.CrosshairCheckbox,'Value',1);
            end
        end

        function MDCEDC_menu_callback(obj,~,~)
            % Create or close EDC and MDC figures based on the span cursor.
            if strcmp(get(obj.MDCEDC_Menu, 'Checked'), 'on')
                obj.Crosshair2.Visible = 'off';
                obj.closeEDCMDCFigures();
            else
                if ~strcmp(get(obj.CrosshairMenu, 'Checked'), 'on')
                    obj.Crosshair.Visible = 'on';
                    set(obj.CrosshairMenu,'Checked','on');
                    set(obj.CrosshairCheckbox, 'Value', 1);
                end

                obj.Crosshair2.Visible = 'on';
                set(obj.MDCEDC_Menu,'Checked','on');
                obj.createEDCMDCFigures();
                obj.updateEDCMDCPlots();
            end
        end

        function histogram_menu_callback(obj,~,~)
            % Show the intensity distribution of the currently displayed slice.
            figure;
            histogram(obj.imag.CData,'EdgeColor','none');
        end

        function perp_DC_menu_callback(obj,~,~)
            % Toggle the perpendicular-distribution window. Its plotting body
            % is currently a placeholder for a future implementation.
            if get(obj.PerpDistributionMenu,'Checked')
                close(obj.PerpDistributionFigure);
                set(obj.PerpDistributionMenu,'Checked','off');
            else
                obj.PerpDistributionFigure = figure();
                % display data
                
                set(obj.PerpDistributionMenu,'Checked','on');
            end
        end

        function interpolate_menu_callback(obj,~,~)
            % Toggle the interpolation factor used when each slice is redrawn.
            if obj.interpolate_K == 1
                 obj.interpolate_K = 3;
                 set(obj.InterpolateMenu,'Checked','on');
                 set(obj.InterpCheckbox,'Value',1);
            else
                obj.interpolate_K = 1;
                 set(obj.InterpolateMenu,'Checked','off');
                 set(obj.InterpCheckbox,'Value',0);
            end

            obj.update_CData();
        end

        function energy_contour_menu_callback(obj,~,~)
            % Toggle energy-contour overlays supplied by the dataset's BZBS
            % metadata object.
            if get(obj.energy_contour_menu,'Checked')
                set(obj.energy_contour_menu,'Checked','off');
                obj.energy_contour_flag = 0;
                % clear all lines
                for i = 1:length(obj.energy_contour_lines)
                    delete(obj.energy_contour_lines{i})
                end
            else
                set(obj.energy_contour_menu,'Checked','on');
                obj.energy_contour_flag = 1;
                obj.update_CData();
            end
        end

        function bz_line_menu_callback(obj,~,~)
            % Toggle Brillouin-zone overlays supplied by the dataset's BZBS
            % metadata object.
            if get(obj.bz_line_menu,'Checked')
                set(obj.bz_line_menu,'Checked','off');
                obj.bz_line_flag = 0;
                % clear all lines
                for i = 1:length(obj.bz_line_lines)
                    delete(obj.bz_line_lines{i})
                end
            else
                set(obj.bz_line_menu,'Checked','on');
                obj.bz_line_flag = 1;
                obj.update_CData();
            end
        end

        function quick_KConvert(obj,~,~)
            % Accept native OX_ARPES conversion objects and legacy structs.
            sourceData = evalin('base', obj.DataName);
            [conversionData, conversionKind] = obj.prepareConversionData(sourceData);
            if isempty(conversionKind)
                errordlg('K-space conversion is available for CUT, MAP, and KZ data.', ...
                    'Unsupported Data');
                return
            end

            if strcmp(conversionKind, 'cut')
                conversionData.info.thetay_offset = obj.PosX;
                prompts = {'Photon Energy (eV)', 'Work Function (eV)', 'Y offset (deg)'};
                defaults = {num2str(obj.infoValue(conversionData.info, 'photon_energy', 21.2)), ...
                    num2str(obj.infoValue(conversionData.info, 'workfunction', 4.5)), ...
                    num2str(obj.infoValue(conversionData.info, 'thetay_offset', obj.PosX))};
                titleText = 'Cut K-space Conversion';
                infoFields = {'photon_energy', 'workfunction', 'thetay_offset'};
            elseif strcmp(conversionKind, 'map')
                if obj.Direction ~= 'z'
                    errordlg('Map conversion requires the z direction.', 'Unsupported Direction');
                    return
                end
                conversionData.info.thetax_offset = obj.PosX;
                conversionData.info.thetay_offset = obj.PosY;
                prompts = {'Azimuth offset (deg): + clockwise, - anticlockwise', ...
                    'Photon Energy (eV)', 'Work Function (eV)', ...
                    'X offset (deg)', 'Y offset (deg)'};
                defaults = {num2str(obj.infoValue(conversionData.info, 'azimuth_offset', 0)), ...
                    num2str(obj.infoValue(conversionData.info, 'photon_energy', 21.2)), ...
                    num2str(obj.infoValue(conversionData.info, 'workfunction', 4.5)), ...
                    num2str(obj.infoValue(conversionData.info, 'thetax_offset', obj.PosX)), ...
                    num2str(obj.infoValue(conversionData.info, 'thetay_offset', obj.PosY))};
                titleText = 'Map K-space Conversion';
                infoFields = {'azimuth_offset', 'photon_energy', 'workfunction', ...
                    'thetax_offset', 'thetay_offset'};
            else
                if obj.Direction == 'z'
                    defaultOffset = obj.PosY;
                elseif obj.Direction == 'x'
                    defaultOffset = obj.PosX;
                else
                    errordlg('KZ conversion supports the x or z direction.', ...
                        'Unsupported Direction');
                    return
                end
                conversionData.info.thetay_offset = defaultOffset;
                prompts = {'Inner Energy (eV)', 'Y offset (deg)', 'Work Function (eV)'};
                defaults = {num2str(obj.infoValue(conversionData.info, 'inner_energy', 15)), ...
                    num2str(obj.infoValue(conversionData.info, 'thetay_offset', defaultOffset)), ...
                    num2str(obj.infoValue(conversionData.info, 'workfunction', 4.5))};
                titleText = 'Photon-energy Scan K-space Conversion';
                infoFields = {'inner_energy', 'thetay_offset', 'workfunction'};
            end

            answer = inputdlg(prompts, titleText, [1 60], defaults);
            if isempty(answer)
                return
            end
            values = cellfun(@str2double, answer);
            if any(~isfinite(values))
                errordlg('Conversion parameters must be finite numeric scalars.', ...
                    'Invalid Conversion Parameters');
                return
            end
            for parameterIndex = 1:numel(infoFields)
                conversionData.info.(infoFields{parameterIndex}) = values(parameterIndex);
            end

            try
                convertedData = conversionData.kconvert();
                obj.saveWorkspaceVariable([obj.DataName '_ksp'], convertedData, ...
                    'Save K-space Conversion');
            catch exception
                errordlg(exception.message, 'K-space Conversion Failed');
            end
        end

        function mass_plot(obj, ~, ~, varargin)
            % Plot energy slices below E_F or distribute other slices across
            % the selected axis in an editable grid.
            axisMin = min(obj.AxisData);
            axisMax = max(obj.AxisData);
            [startReference, referenceLabel, isFermiRelative, isKinetic] = ...
                obj.massPlotReference(axisMin, axisMax);

            tolerance = 64 * eps(max(1, max(abs(obj.AxisData))));
            axisUnit = char(obj.Data.([obj.Direction '_unit']));
            if strcmp(obj.Direction, 'z')
                stepQuantum = 0.05;
                defaultStep = '0.1';
                shiftPrompt = sprintf('Start shift from %s (%.10g %s):', ...
                    referenceLabel, startReference, axisUnit);
                stepPrompt = 'Step size (positive multiple of 0.05):';
            else
                stepQuantum = 0.5;
                defaultStep = num2str(obj.massPlotSuggestedStep(axisMin, axisMax));
                shiftPrompt = sprintf('Series center shift (%s; zero retained):', axisUnit);
                stepPrompt = 'Fixed step between panels (positive multiple of 0.5):';
            end
            prompt = {'Number of columns:', 'Number of rows:', ...
                stepPrompt, shiftPrompt};
            defaultInput = {'4', '3', defaultStep, '0'};
            if isempty(varargin)
                answer = inputdlg(prompt, 'Mass Plot', [1 48], defaultInput);
            else
                answer = varargin{1};
            end
            if isempty(answer)
                return
            end
            if numel(answer) ~= 4
                errordlg('Enter columns, rows, step size, and start shift.', ...
                    'Invalid Mass Plot Settings');
                return
            end

            columns = str2double(answer{1});
            rows = str2double(answer{2});
            step = str2double(answer{3});
            shift = str2double(answer{4});
            stepUnits = step / stepQuantum;
            if ~isfinite(columns) || columns < 1 || columns ~= fix(columns) || ...
                    ~isfinite(rows) || rows < 1 || rows ~= fix(rows) || ...
                    columns * rows > 100 || ~isfinite(stepUnits) || ...
                    stepUnits <= 0 || abs(stepUnits - round(stepUnits)) > 1e-8 || ...
                    ~isfinite(shift)
                errordlg(sprintf(['Enter positive integer rows/columns (at most 100 panels), ' ...
                    'a positive multiple of %g for the step, and a finite shift.'], ...
                    stepQuantum), ...
                    'Invalid Mass Plot Settings');
                return
            end

            if strcmp(obj.Direction, 'z')
                startPosition = startReference + shift;
                if startPosition < axisMin || startPosition > axisMax
                    errordlg('The shifted start must lie within the selected axis range.', ...
                        'Invalid Mass Plot Settings');
                    return
                end
                availableCount = 1 + floor((startPosition - axisMin + tolerance) / step);
                availableSamples = nnz(obj.AxisData <= startPosition + tolerance);
                plotCount = min([rows * columns, availableSamples, availableCount]);
                positions = max(axisMin, startPosition - (0:plotCount-1) * step);
            else
                plotCount = min(rows * columns, numel(obj.AxisData));
                positions = obj.massPlotPositions( ...
                    plotCount, step, shift, axisMin, axisMax);
                plotCount = numel(positions);
            end

            axisLabel = char(obj.Data.([obj.Direction '_name']));
            if strcmp(obj.Direction, 'x') && strcmp(axisLabel, 'Photon Energy')
                axisLabel = 'hv';
            elseif strcmp(obj.Direction, 'z') && isFermiRelative
                axisLabel = 'BE';
            elseif strcmp(obj.Direction, 'z') && isKinetic
                axisLabel = 'KE';
            end

            originalPosition = obj.Slider.Value;
            restorePosition = onCleanup(@() set(obj.Slider, 'Value', originalPosition));
            rootUnits = get(groot, 'Units');
            set(groot, 'Units', 'pixels');
            restoreRootUnits = onCleanup(@() set(groot, 'Units', rootUnits));
            screenSize = get(groot, 'ScreenSize');
            clear restoreRootUnits
            figureWidth = min(900, floor(0.8 * screenSize(3)));
            figureHeight = min(600, floor(0.8 * screenSize(4)));
            figurePosition = [screenSize(1) + floor((screenSize(3) - figureWidth) / 2), ...
                screenSize(2) + floor((screenSize(4) - figureHeight) / 2), ...
                figureWidth, figureHeight];
            plotFigure = figure('Name', obj.Data.name, 'Color', 'white', ...
                'Units', 'pixels', ...
                'Position', figurePosition);
            layout = tiledlayout(plotFigure, rows, columns, ...
                'TileSpacing', 'compact', 'Padding', 'compact');
            useInterpolation = strcmp(obj.InterpolateMenu.Checked, 'on');

            for plotIndex = 1:plotCount
                obj.Slider.Value = positions(plotIndex);
                plotAxis = nexttile(layout, plotIndex);
                if useInterpolation
                    obj.initial_plot('new2intp', plotAxis);
                else
                    obj.initial_plot('new2', plotAxis);
                end
                xlabel(plotAxis, '');
                ylabel(plotAxis, '');

                displayPosition = positions(plotIndex);
                if strcmp(obj.Direction, 'z') && isFermiRelative
                    displayPosition = -displayPosition;
                end
                title(plotAxis, sprintf('%s= %s %s', ...
                    axisLabel, num2str(displayPosition), axisUnit));

                % Overlays on the main viewer can change with each position.
                lineObjects = findall(obj.Axis, 'Type', 'line');
                if ~isempty(lineObjects)
                    copyobj(lineObjects, plotAxis);
                end
            end

            sgtitle(plotFigure, obj.massPlotTitle(), 'Interpreter', 'none');
        end
    end

    methods (Access = private)
        function step = massPlotSuggestedStep(obj, axisMin, axisMax)
            % Balance range coverage against unused slots in the 4-by-3 grid.
            targetCount = min(12, numel(obj.AxisData));
            step = 0.5;
            if targetCount <= 1 || axisMin == axisMax
                return
            end

            targetSpacing = (axisMax - axisMin) / (targetCount - 1);
            targetUnits = targetSpacing / 0.5;
            candidateUnits = max(1, floor(targetUnits) - 3):ceil(targetUnits) + 3;
            bestScore = Inf;
            for units = candidateUnits
                candidateStep = units * 0.5;
                positions = obj.massPlotPositions( ...
                    targetCount, candidateStep, 0, axisMin, axisMax);
                uncoveredRange = (axisMax - axisMin) - ...
                    (max(positions) - min(positions));
                unusedSlots = targetCount - numel(positions);
                score = uncoveredRange + unusedSlots * targetSpacing / 2;
                if score < bestScore
                    bestScore = score;
                    step = candidateStep;
                end
            end
        end

        function positions = massPlotPositions(~, count, step, shift, axisMin, axisMax)
            % Use one contiguous step lattice; keep zero when it lies in range.
            zeroInRange = axisMin <= 0 && axisMax >= 0;
            if axisMin == axisMax || (count == 1 && zeroInRange)
                if zeroInRange
                    positions = 0;
                else
                    positions = (axisMin + axisMax) / 2;
                end
                return
            end

            tolerance = 64 * eps(max(1, max(abs([axisMin, axisMax]))));
            firstGridIndex = ceil((axisMin - tolerance) / step);
            lastGridIndex = floor((axisMax + tolerance) / step);
            gridCount = lastGridIndex - firstGridIndex + 1;
            if gridCount < 1
                positions = (axisMin + axisMax) / 2;
                return
            end

            plotCount = min(count, gridCount);
            desiredCenter = axisMin + (axisMax - axisMin) / 2 + shift;
            desiredFirstIndex = round(desiredCenter / step - (plotCount - 1) / 2);
            if zeroInRange
                minimumFirstIndex = max(firstGridIndex, 1 - plotCount);
                maximumFirstIndex = min(lastGridIndex - plotCount + 1, 0);
            else
                minimumFirstIndex = firstGridIndex;
                maximumFirstIndex = lastGridIndex - plotCount + 1;
            end
            firstIndex = min(maximumFirstIndex, ...
                max(minimumFirstIndex, desiredFirstIndex));
            positions = fliplr((firstIndex:firstIndex + plotCount - 1) * step);
        end

        function [reference, label, isFermiRelative, isKinetic] = ...
                massPlotReference(obj, axisMin, axisMax)
            % Identify the energy convention and a usable starting position.
            energyAxisName = lower(char(obj.Data.z_name));
            energyAxisName = strrep(energyAxisName, '\it', '');
            energyAxisName = regexprep(energyAxisName, '[^a-z]', '');
            isFermiRelative = strcmp(energyAxisName, 'eef');
            isKinetic = contains(energyAxisName, 'kinetic');

            reference = axisMax;
            label = 'axis maximum';
            if ~strcmp(obj.Direction, 'z')
                return
            end
            if isFermiRelative
                reference = 0;
                label = 'E_F';
            elseif isKinetic && PlotSlices.hasDataMember(obj.Data, 'info') && ...
                    isstruct(obj.Data.info) && ...
                    all(isfield(obj.Data.info, {'photon_energy', 'workfunction'}))
                photonEnergy = obj.Data.info.photon_energy;
                workfunction = obj.Data.info.workfunction;
                if isnumeric(photonEnergy) && isreal(photonEnergy) && ...
                        ~isempty(photonEnergy) && all(isfinite(photonEnergy(:))) && ...
                        isnumeric(workfunction) && isreal(workfunction) && ...
                        ~isempty(workfunction) && all(isfinite(workfunction(:)))
                    reference = median(photonEnergy(:)) - median(workfunction(:));
                    label = 'estimated E_F';
                end
            end
            if reference < axisMin || reference > axisMax
                reference = axisMax;
                label = 'axis maximum (E_F outside range)';
            end
        end

        function groupTitle = massPlotTitle(obj)
            % Add available acquisition metadata to the figure title.
            groupTitle = obj.DataName;
            if PlotSlices.hasDataMember(obj.Data, 'info') && isstruct(obj.Data.info)
                info = obj.Data.info;
                if isfield(info, 'photon_energy')
                    photonEnergy = info.photon_energy;
                    if isnumeric(photonEnergy) && isreal(photonEnergy) && ...
                            ~isempty(photonEnergy) && all(isfinite(photonEnergy(:)))
                        if isscalar(photonEnergy)
                            energyText = sprintf('%.1f', photonEnergy);
                        else
                            energyMin = min(photonEnergy(:));
                            energyMax = max(photonEnergy(:));
                            meanStep = (energyMax - energyMin) / (numel(photonEnergy) - 1);
                            energyText = sprintf('%g/%g/%g', ...
                                round(energyMin, 1), meanStep, round(energyMax, 1));
                        end
                        groupTitle = sprintf('%s: %s eV', groupTitle, energyText);
                    end
                end
                if isfield(info, 'polarization') && ...
                        (ischar(info.polarization) || ...
                        (isstring(info.polarization) && isscalar(info.polarization)))
                    groupTitle = sprintf('%s %s', groupTitle, char(info.polarization));
                end
            end
            if strcmp(obj.Direction, 'z')
                groupTitle = sprintf('%s (ΔE=%s eV)', ...
                    groupTitle, get(obj.Width, 'String'));
            end
        end

        function createEDCMDCFigures(obj)
            % Size linked plot boxes to the main axes' effective data plot box.
            figurePosition = get(obj.Figure, 'Position');
            plotBox = obj.getEffectivePlotBox();
            plotBoxWidth = max(1, round(plotBox(3)));
            plotBoxHeight = max(1, round(plotBox(4)));
            linkedFont = get(obj.Axis, 'FontName');
            linkedFontSize = get(obj.Axis, 'FontSize');
            linkedLineWidth = get(obj.Axis, 'LineWidth');

            mdcPlotHeight = 180;
            edcPlotWidth = mdcPlotHeight;
            edcWidth = edcPlotWidth + 100;
            edcHeight = plotBoxHeight + 75;
            edcPosition = [figurePosition(1) + figurePosition(3) + 10, ...
                figurePosition(2) + plotBox(2) - 45, edcWidth, edcHeight];
            obj.FigureEDC = figure('Name', 'EDC', 'NumberTitle', 'off', ...
                'Color', 'w', 'Position', edcPosition, ...
                'CloseRequestFcn', @obj.closeLinkedFigure);
            obj.AxisEDC = axes('Parent', obj.FigureEDC, 'Units', 'pixels', ...
                'Position', [75, 45, edcPlotWidth, plotBoxHeight]);
            obj.EDC_line = plot(obj.AxisEDC, nan(size(obj.imag.YData)), ...
                obj.imag.YData, 'LineWidth', linkedLineWidth);
            xlabel(obj.AxisEDC, 'Mean intensity');
            ylabel(obj.AxisEDC, obj.Axis.YLabel.String);
            obj.styleLinkedAxes(obj.AxisEDC, linkedFont, linkedFontSize, linkedLineWidth);
            ylim(obj.AxisEDC, ylim(obj.Axis));
            obj.EDCRegionLines(1) = yline(obj.AxisEDC, obj.PosY, '--', ...
                'Color', [0 0.6 0.6], 'LineWidth', linkedLineWidth);
            obj.EDCRegionLines(2) = yline(obj.AxisEDC, obj.PosY + obj.DY, '--', ...
                'Color', [0.35 0.35 0.35], 'LineWidth', linkedLineWidth);

            mdcFigureHeight = mdcPlotHeight + 90;
            mdcWidth = plotBoxWidth + 90;
            mdcAxesBottom = 55;
            mdcGap = 24;
            mdcPosition = [figurePosition(1) + plotBox(1) - 70, ...
                figurePosition(2) - mdcGap - mdcAxesBottom - mdcPlotHeight, ...
                mdcWidth, mdcFigureHeight];
            obj.FigureMDC = figure('Name', 'MDC', 'NumberTitle', 'off', ...
                'Color', 'w', 'Position', mdcPosition, ...
                'CloseRequestFcn', @obj.closeLinkedFigure);
            obj.AxisMDC = axes('Parent', obj.FigureMDC, 'Units', 'pixels', ...
                'Position', [70, mdcAxesBottom, plotBoxWidth, mdcPlotHeight]);
            obj.MDC_line = plot(obj.AxisMDC, obj.imag.XData, ...
                nan(size(obj.imag.XData)), 'LineWidth', linkedLineWidth);
            xlabel(obj.AxisMDC, obj.Axis.XLabel.String);
            ylabel(obj.AxisMDC, 'Mean intensity');
            obj.styleLinkedAxes(obj.AxisMDC, linkedFont, linkedFontSize, linkedLineWidth);
            xlim(obj.AxisMDC, xlim(obj.Axis));
            obj.MDCRegionLines(1) = xline(obj.AxisMDC, obj.PosX, '--', ...
                'Color', [0 0.6 0.6], 'LineWidth', linkedLineWidth);
            obj.MDCRegionLines(2) = xline(obj.AxisMDC, obj.PosX + obj.DX, '--', ...
                'Color', [0.35 0.35 0.35], 'LineWidth', linkedLineWidth);
            figure(obj.Figure);
        end

        function plotBox = getEffectivePlotBox(obj)
            % Account for data-aspect constraints such as axis equal.
            plotBox = getpixelposition(obj.Axis, true);
            if strcmp(get(obj.Axis, 'DataAspectRatioMode'), 'manual')
                xLimits = xlim(obj.Axis);
                yLimits = ylim(obj.Axis);
                dataAspect = get(obj.Axis, 'DataAspectRatio');
                xSpan = abs(diff(xLimits));
                ySpan = abs(diff(yLimits));
                if xSpan == 0 || ySpan == 0
                    return
                end
                targetRatio = (xSpan * dataAspect(1)) / ...
                    (ySpan * dataAspect(2));
            elseif strcmp(get(obj.Axis, 'PlotBoxAspectRatioMode'), 'manual')
                plotAspect = get(obj.Axis, 'PlotBoxAspectRatio');
                targetRatio = plotAspect(1) / plotAspect(2);
            else
                return
            end
            if ~isfinite(targetRatio) || targetRatio <= 0 || ...
                    plotBox(3) <= 0 || plotBox(4) <= 0
                return
            end
            availableRatio = plotBox(3) / plotBox(4);
            if targetRatio < availableRatio
                adjustedWidth = plotBox(4) * targetRatio;
                plotBox(1) = plotBox(1) + (plotBox(3) - adjustedWidth) / 2;
                plotBox(3) = adjustedWidth;
            else
                adjustedHeight = plotBox(3) / targetRatio;
                plotBox(2) = plotBox(2) + (plotBox(4) - adjustedHeight) / 2;
                plotBox(4) = adjustedHeight;
            end
        end

        function styleLinkedAxes(~, axesHandle, fontName, fontSize, lineWidth)
            % Match linked plots to the main viewer axes typography and weight.
            set(axesHandle, 'FontName', fontName, 'FontSize', fontSize, ...
                'LineWidth', lineWidth, 'Box', 'on', 'Layer', 'top');
            set([axesHandle.XLabel, axesHandle.YLabel], ...
                'FontName', fontName, 'FontSize', fontSize);
            grid(axesHandle, 'off');
        end

        function closeLinkedFigure(obj, sourceFigure, ~)
            % Closing either linked window closes the pair and clears the mode.
            if isgraphics(sourceFigure)
                delete(sourceFigure);
            end
            obj.closeEDCMDCFigures();
        end

        function closeEDCMDCFigures(obj)
            % Delete linked figures without recursively invoking close callbacks.
            figureHandles = {obj.FigureEDC, obj.FigureMDC};
            for figureIndex = 1:numel(figureHandles)
                figureHandle = figureHandles{figureIndex};
                if isgraphics(figureHandle)
                    delete(figureHandle);
                end
            end
            obj.FigureEDC = [];
            obj.AxisEDC = [];
            obj.EDC_line = [];
            obj.EDCRegionLines = gobjects(0);
            obj.FigureMDC = [];
            obj.AxisMDC = [];
            obj.MDC_line = [];
            obj.MDCRegionLines = gobjects(0);
            if isgraphics(obj.Crosshair2)
                obj.Crosshair2.Visible = 'off';
            end
            if isgraphics(obj.MDCEDC_Menu)
                set(obj.MDCEDC_Menu, 'Checked', 'off');
            end
        end

        function closeMainFigure(obj, sourceFigure, ~)
            % Close linked windows and overlays when the main viewer closes.
            obj.closeEDCMDCFigures();
            if isgraphics(obj.PerpDistributionFigure)
                delete(obj.PerpDistributionFigure);
                obj.PerpDistributionFigure = [];
            end
            if isgraphics(sourceFigure)
                delete(sourceFigure);
            end
            obj.Figure = [];
        end

        function normalizeLegacyMetadata(obj)
            % Keep absent axis metadata blank for older bare structs.
            if ~isstruct(obj.Data) || ~isscalar(obj.Data)
                return
            end
            defaults = struct('name', obj.DataName, ...
                'x_name', '', 'x_unit', '', ...
                'y_name', '', 'y_unit', '', ...
                'z_name', '', 'z_unit', '');
            defaultFields = fieldnames(defaults);
            for fieldIndex = 1:numel(defaultFields)
                fieldName = defaultFields{fieldIndex};
                if ~isfield(obj.Data, fieldName) || isempty(obj.Data.(fieldName))
                    obj.Data.(fieldName) = defaults.(fieldName);
                end
            end
            if ~isfield(obj.Data, 'info') || ~isstruct(obj.Data.info)
                obj.Data.info = struct();
            end
        end

        function validatePlotData(obj)
            % Validate the common three-axis representation used by the GUI.
            axesNames = {'x', 'y', 'z'};
            valueSize = size(obj.Data.value);
            for axisIndex = 1:numel(axesNames)
                axisName = axesNames{axisIndex};
                if ~PlotSlices.hasDataMember(obj.Data, axisName)
                    error('PlotSlices:InvalidAxes', ...
                        'The selected data must provide x, y, and z coordinates.');
                end
                axisValues = obj.Data.(axisName);
                if ~isnumeric(axisValues) || ~isreal(axisValues) || ...
                        ~isvector(axisValues) || isempty(axisValues) || ...
                        any(~isfinite(axisValues(:)))
                    error('PlotSlices:InvalidAxes', ...
                        'Coordinate %s must be a nonempty finite numeric vector.', axisName);
                end
                if numel(axisValues) ~= valueSize(axisIndex)
                    error('PlotSlices:InvalidAxes', ...
                        'The %s coordinate length must match value dimension %d.', ...
                        axisName, axisIndex);
                end
            end
            if ~any(strcmp(obj.Direction, axesNames))
                error('PlotSlices:InvalidDirection', ...
                    'Direction must be ''x'', ''y'', or ''z''.');
            end
        end

        function cmapData = loadColormap(~, colorMapName)
            % Load custom maps beside this class; use MATLAB maps as fallback.
            visualizationFolder = fileparts(fileparts(mfilename('fullpath')));
            colorMapFile = fullfile(visualizationFolder, 'Colormap.mat');
            if isfile(colorMapFile)
                savedVariables = whos('-file', colorMapFile);
                savedMapNames = {savedVariables.name};
                if any(strcmp(savedMapNames, colorMapName))
                    savedMaps = load(colorMapFile, colorMapName);
                    cmapData = savedMaps.(colorMapName);
                    return
                end
            end
            try
                cmapData = feval(colorMapName, 256);
            catch
                error('PlotSlices:MissingColormap', ...
                    'Colormap "%s" is not available in Colormap.mat or MATLAB.', ...
                    colorMapName);
            end
        end

        function saveWorkspaceVariable(~, variableName, value, dialogTitle)
            % Validate a requested variable name and confirm replacements.
            variableName = strtrim(variableName);
            if ~isvarname(variableName)
                errordlg('Enter a valid MATLAB variable name.', 'Invalid Data Name');
                return
            end
            workspaceNames = evalin('base', 'who');
            if any(strcmp(workspaceNames, variableName))
                choice = questdlg(sprintf('Variable "%s" already exists. Overwrite it?', ...
                    variableName), dialogTitle, 'Overwrite', 'Cancel', 'Cancel');
                if ~strcmp(choice, 'Overwrite')
                    return
                end
            end
            assignin('base', variableName, value);
        end

        function [conversionData, conversionKind] = prepareConversionData(~, sourceData)
            % Return native conversion objects for OX_ARPES objects or old structs.
            conversionData = [];
            conversionKind = '';
            if isa(sourceData, 'OxA_CUT')
                conversionData = sourceData;
                conversionKind = 'cut';
                return
            elseif isa(sourceData, 'OxA_MAP_ToF') || isa(sourceData, 'OxA_MAP')
                conversionData = sourceData;
                conversionKind = 'map';
                return
            elseif isa(sourceData, 'OxA_KZ')
                conversionData = sourceData;
                conversionKind = 'kz';
                return
            end
            if ~isstruct(sourceData) || ~isscalar(sourceData) || ...
                    ~all(isfield(sourceData, {'x', 'y', 'value'}))
                return
            end

            sourceInfo = struct();
            if isfield(sourceData, 'info') && isstruct(sourceData.info)
                sourceInfo = sourceData.info;
            end
            if ismatrix(sourceData.value)
                conversionKind = 'cut';
                conversionData = OxA_CUT(sourceData.x, sourceData.y, sourceData.value);
            elseif ndims(sourceData.value) == 3 && isfield(sourceData, 'z')
                if isfield(sourceInfo, 'inner_energy') || ...
                        (isfield(sourceData, 'x_name') && ...
                        contains(lower(char(sourceData.x_name)), 'photon'))
                    conversionKind = 'kz';
                    conversionData = OxA_KZ(sourceData.x, sourceData.y, ...
                        sourceData.z, sourceData.value);
                elseif isfield(sourceInfo, 'azimuth_offset') || ...
                        PlotSlices.hasAngleAxisName(sourceData)
                    conversionKind = 'map';
                    conversionData = OxA_MAP(sourceData.x, sourceData.y, ...
                        sourceData.z, sourceData.value);
                end
            end
            if isempty(conversionKind)
                return
            end

            % Carry the source's naming, units, and acquisition metadata over
            % while retaining defaults required by the OX_ARPES converter.
            if isfield(sourceData, 'name')
                conversionData.name = sourceData.name;
            end
            axisFields = {'x_name', 'x_unit', 'y_name', 'y_unit', ...
                'z_name', 'z_unit'};
            for fieldIndex = 1:numel(axisFields)
                fieldName = axisFields{fieldIndex};
                if isfield(sourceData, fieldName)
                    conversionData.(fieldName) = sourceData.(fieldName);
                end
            end
            sourceInfoFields = fieldnames(sourceInfo);
            for fieldIndex = 1:numel(sourceInfoFields)
                fieldName = sourceInfoFields{fieldIndex};
                conversionData.info.(fieldName) = sourceInfo.(fieldName);
            end
        end

        function value = infoValue(~, info, fieldName, defaultValue)
            % Read a scalar conversion setting while tolerating old metadata.
            value = defaultValue;
            if isstruct(info) && isfield(info, fieldName)
                candidate = info.(fieldName);
                if isnumeric(candidate) && isscalar(candidate) && isfinite(candidate)
                    value = candidate;
                end
            end
        end
    end

    methods (Static, Access = private)
        function hasMember = hasDataMember(data, memberName)
            % Test struct fields and object properties through one interface.
            if isstruct(data)
                hasMember = isscalar(data) && isfield(data, memberName);
            elseif isobject(data)
                hasMember = isscalar(data) && isprop(data, memberName);
            else
                hasMember = false;
            end
        end

        function hasAngleName = hasAngleAxisName(data)
            % Recognize legacy maps from coordinate labels when metadata is sparse.
            hasAngleName = false;
            nameFields = {'x_name', 'y_name'};
            for fieldIndex = 1:numel(nameFields)
                fieldName = nameFields{fieldIndex};
                if isfield(data, fieldName) && ...
                        contains(lower(char(data.(fieldName))), 'angle')
                    hasAngleName = true;
                    return
                end
            end
        end

    end

    methods % separate files
        correction(obj,varargin) % Fermi surface correction
        plotCrossHair(obj,~,~) % plotCrossHair and EDC/MDC plot drawing
        ButtonDownFcn(obj,~,~) % mouse click action
        saveMdcEdc(obj,varargin) % save data of EDC/MDC plots
        sqCorrection(obj,varargin) % Square Correction for data set

        function save_slice(obj,varargin)
            % Package the displayed image data and axes into an OxA_CUT object,
            % then save it to the base workspace under a user-entered name.
            x = obj.imag.XData;
            y = obj.imag.YData;
            value = obj.imag.CData';
            data = OxA_CUT(x,y,value);
            if PlotSlices.hasDataMember(obj.Data, 'info') && isstruct(obj.Data.info)
                data.info = obj.Data.info;
            end

            try
                switch obj.Direction
                    case 'x'
                        data.x_name = obj.Data.y_name;
                        data.x_unit = obj.Data.y_unit;
                        data.y_name = obj.Data.z_name;
                        data.y_unit = obj.Data.z_unit;
                    case 'y'
                        data.x_name = obj.Data.x_name;
                        data.x_unit = obj.Data.x_unit;
                        data.y_name = obj.Data.z_name;
                        data.y_unit = obj.Data.z_unit;
                    otherwise
                        data.x_name = obj.Data.x_name;
                        data.x_unit = obj.Data.x_unit;
                        data.y_name = obj.Data.y_name;
                        data.y_unit = obj.Data.y_unit;
                end
            catch
            end

            SaveName=inputdlg({'Data Name'},'Save Slice',1,{[obj.DataName,'_sa']});
            if isempty(SaveName)
                return;
            end
            obj.saveWorkspaceVariable(SaveName{1}, data, 'Save Slice');
        end    
        
        function cut(obj,varargin)
            % Ask the user to define a line in the main 2-D plane, interpolate
            % the 3-D volume along that line, and save the resulting cut data.
            [xlist,ylist]=getpts(obj.Axis);
            if numel(xlist) ~= 2 || numel(ylist) ~= 2
                errordlg('Select exactly two points to define the cut.', 'Invalid Cut');
                return
            end
            x0=xlist(1);
            y0=ylist(1);
            x1=xlist(2);
            y1=ylist(2);
            [x,y,r]=area_secant_ph(obj.Data.x,obj.Data.y,x0,y0,x1,y1);
            [x_grid,y_grid,z_grid]=meshgrid(obj.Data.x,obj.Data.y,obj.Data.z);
            xx=repmat(x,max(size(obj.Data.z)),1);
            yy=repmat(y,max(size(obj.Data.z)),1);
            zz=repmat(reshape(obj.Data.z,[length(obj.Data.z) 1]),1,max(size(x)));

            data=struct(obj.Data);

            data=rmfield(data,'z');
            try
                data.y_unit = data.z_unit;
                data.y_name = data.z_name;
                data=rmfield(data,'z_unit');
                data=rmfield(data,'z_name');
            catch
            end
            
            
            data.value=interp3(x_grid,y_grid,z_grid, permute(obj.Data.value,[2,1,3]),xx,yy,zz);
%             % Temp for 3D visualization
%             figure;
%             surf(xx,yy,zz,data.value);
%             %% Temp End
            data.value=data.value';
            data.x=r;
            data.y=obj.Data.z;
            figure;
            imagesc(data.x,data.y,data.value');
%             shading interp;
            % save 
            data.SliceInfo.Direction='nv';
            data.SliceInfo.pos=[xlist,ylist];
            data.SliceInfo.parentData=obj.DataName;
            SaveName=inputdlg({'Data Name'},...
                'Save Slice',...
                1,...
                {[obj.DataName,'_sa']});
            if isempty(SaveName)
                return;
            end

            obj.saveWorkspaceVariable(SaveName{1}, data, 'Save Cut');
        end
    end
end


