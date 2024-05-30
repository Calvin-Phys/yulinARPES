% To plot an ARPES data, use PlotSlices(DataName,Direction)
% DataName is the string of the data name. Direction is 'x', 'y' or 'z';
classdef PlotSlices < handle

    properties
        Direction % plotting direction: 'x', 'y', 'z' 
        Data % store the data object/struct
        minValue % min value of all Data.value
        maxValue % max value of all Data.value
        DataName % variable name of Data
        AxisData % Store the axis that the plot is along with
        CorrData % ?

        
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
        EDC_line
        MDC_line
        FigureMDC
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

            % plot the first variable of the list
            if iscell(DataName)
                DataName=DataName{1};
            end
            % initialize
            obj.DataName = DataName;
            obj.Direction = Direction;
            obj.Data = evalin('base',DataName);
            if ~isfield(obj.Data,'value') && ~isprop(obj.Data,'value')
                errordlg('Check data.value');
                return
            end
            if ndims(obj.Data.value) == 2
                obj.data2Dto3D();
            elseif ndims(obj.Data.value) == 4
                return
            end

            obj.minValue = min(obj.Data.value(:));
            obj.maxValue = max(obj.Data.value(:));

            % slider direction
            obj.AxisData = obj.Data.(obj.Direction);

            % construct figure UI / menu
            obj.figureConstruct(DataName);
            obj.setUIMenu();

            % some improvement - default settings
            if Direction == 'z' && ndims(obj.Data.value) == 3 && length(obj.Data.x) ~= 1
                obj.FlipCheckbox.Value = 1;
                obj.Width.String = '0.05';
                
                try
                    if strcmp(obj.Data.x_unit,obj.Data.y_unit)
                        obj.Checkbox.Value = 1;
                    end
                catch
                end

            end

            % plot figure & set menu
            obj.initial_plot();
            

            % hide menubar/toolbar
            ss = allchild(obj.Figure);
            for i = [4,5,6,7,10,11]
                ss(i).Visible = 'off';
            end

            % draw crosshair/guideline
            obj.Crosshair = drawcrosshair('Parent',obj.Axis,'Position',[obj.PosX obj.PosY],'LineWidth',1,'Color',"c",'Visible','off');
            addlistener(obj.Crosshair,'ROIMoved',@(src,data) obj.update_Crosshair_Positions(data.CurrentPosition(1),data.CurrentPosition(2)));

            % draw MDCEDC crosshair
            obj.Crosshair2 = drawcrosshair('Parent',obj.Axis,'Position',[obj.PosX+obj.DX obj.PosY+obj.DY],'LineWidth',1,'Color','w','Visible','off');
            obj.Crosshair2.StripeColor = "c";
            addlistener(obj.Crosshair2,'ROIMoved',@(src,data) obj.update_Crosshair2_Positions(data.CurrentPosition(1),data.CurrentPosition(2)));
        end
        
        function data2Dto3D(obj)
            obj.Direction='x';
            [sizeY,sizeZ]=size(obj.Data.value);
            valueNew=zeros(1,sizeY,sizeZ);
            valueNew(1,:,:)=obj.Data.value;
            
%             data=obj.Data;
            data.x = 1;
            data.y = obj.Data.x;
            data.z = obj.Data.y;
            try
                data.y_name = obj.Data.x_name;
                data.y_unit = obj.Data.x_unit;
                data.z_name = obj.Data.y_name;
                data.z_unit = obj.Data.y_unit;
            catch
            end

            data.value=valueNew;
            obj.Data=data;
            
        end
        
%         function data4Dto3D(obj)
%             return; % to be added
%         end
        
        function figureConstruct(obj,DataName)
            %% Frames
            obj.Figure = figure('Name',DataName);

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

            
            if obj.Data.x == 1
                set(obj.homeVBox,'Sizes',[0,40,-1]);
            else
                set(obj.homeVBox,'Sizes',[20,40,-1]);
            end
            set(colorHBox,'Sizes',[-1,-1]);
            set(colorleftVBox,'Sizes',[-1,-1]);
            set(colorrightVBox,'Sizes',[-1,-1]);

            axisMin=min(obj.AxisData);
            axisMax=max(obj.AxisData);
            step=1/length(obj.AxisData);
            
            %% uicontrols for slice control
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
                'String',       num2str(round((1+length(obj.AxisData)/2))),...
                'BackgroundColor','w',...
                'Callback',     {@obj.setInd,'='});
            uicontrol(...
                'Parent',       infoHBox,...
                'Style',        'PushButton',...
                'String',       '>',...
                'Callback',     {@obj.setInd,'+'});
            set(infoHBox,'Sizes',[45,70,-1,20,50,30,30,20,15,30,15]);
            
            %% uicontrols for color correction
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
                    'gray','jet','hsv','hot','copper','cool',...
                    'spring','summer','autumn','winter','cm_blackbody',...
                    'cm_blue','cm_bluehot','cm_blueredgreen','cm_copper',...
                    'cm_cyan','cm_cyanmagenta','cm_geo','cm_gold','cm_green',...
                    'cm_landandsea','cm_magenta','cm_pastels','cm_pastelsmap',...
                    'cm_planetearth','cm_rainbow','red','cm_redwhiteblue',...
                    'cm_redwhitegreen','cm_relief','cm_spectrum','cm_terrain',...
                    'cm_yellow','cm_yellowhot'},...
                'Callback',     @obj.setColor);
            set(colormapHBox,'Sizes',[60,50,40,-1]);    
        end
        
        function setUIMenu(obj)
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

            obj.MDCEDC_Menu=uimenu(hmenu,'Label','EDC/MDC',...
                'Separator','on','Callback',@obj.MDCEDC_menu_callback);

            uimenu(hmenu,'Label','Histogram','Callback',@obj.histogram_menu_callback);

            obj.CrosshairMenu=uimenu(hmenu,'Label','Crosshair',...
                'Separator','on','Callback',@obj.crosshair_menu_callback);
            uimenu(hmenu,'Label','K-Convert (object)','Callback',@obj.quick_KConvert);
            obj.PerpDistributionMenu=uimenu(hmenu,'Label','Perp-Distribution',...
                'Callback',@obj.perp_DC_menu_callback);
            obj.InterpolateMenu=uimenu(hmenu,'Label','Interploate',...
                'Separator','on','Callback',@obj.interpolate_menu_callback);
            obj.energy_contour_menu=uimenu(hmenu,'Label','Energy contour',...
                'Callback',@obj.energy_contour_menu_callback);
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
            uimenu(plotMenu,'Label','copy axis test','Separator','On',...
                'Callback',@obj.copy_axis);
            uimenu(plotMenu,'Label','Mass Plot',...
                'Callback',@obj.mass_plot);
%             uimenu(plotMenu,'Label','Copy to Clipboard',...
%                 'Callback',{@print,obj.Figure,'-clipboard','-dpng'});
        end
        
     
        function initial_plot(obj,varargin)

            

 
            %% get sliced data
            % get position and width
            pos = get(obj.Slider,'Value');
            width = str2double(get(obj.Width, 'String'));

            % slice data
            sliceData = [];
            switch obj.Direction
                case 'x'
                    xData = obj.Data.y;
                    yData = obj.Data.z;
                    try
                    xData_label = [obj.Data.y_name ' (' obj.Data.y_unit ')'];
                    yData_label = [obj.Data.z_name ' (' obj.Data.z_unit ')'];
                    catch
                    end
                    cond = ( abs(obj.AxisData - pos) <= width/2 );
                    if ~any(cond)
                        [~,cond] = min(abs(obj.AxisData - pos));
                    end
                    sliceData = squeeze(mean(obj.Data.value(cond,:,:),1));
                case 'y'
                    xData = obj.Data.x;
                    yData = obj.Data.z;
                    try
                    xData_label = [obj.Data.x_name ' (' obj.Data.x_unit ')'];
                    yData_label = [obj.Data.z_name ' (' obj.Data.z_unit ')'];
                    catch
                    end
                    cond = ( abs(obj.AxisData - pos) <= width/2 );
                    if ~any(cond)
                        [~,cond] = min(abs(obj.AxisData - pos));
                    end
                    sliceData = squeeze(mean(obj.Data.value(:,cond,:),2));
                otherwise
                    xData = obj.Data.x;
                    yData = obj.Data.y;
                    try
                    xData_label = [obj.Data.x_name ' (' obj.Data.x_unit ')'];
                    yData_label = [obj.Data.y_name ' (' obj.Data.y_unit ')'];
                    catch
                    end
                    cond = ( abs(obj.AxisData - pos) <= width/2 );
                    if ~any(cond)
                        [~,cond] = min(abs(obj.AxisData - pos));
                    end
                    sliceData = squeeze(mean(obj.Data.value(:,:,cond),3));
            end

            %% sliced data operation, enhance

            %% data enhance
            % interpolate
%             if obj.interpolate_K ~= 1
% %                 sliceData = interp2(sliceData,obj.interpolate_K,'spline');
%                 sliceData = interp2(sliceData,obj.interpolate_K,'makima');
%                 sliceData(sliceData<0) = 0;
%             end

            gamma = get(obj.SliderGamma,'Value');
            if gamma~=1
                if gamma==0
                    obj.imag.CData = log(sliceData'+0.1);
                else
                    sliceData = (sliceData/max(sliceData,[],"all")).^gamma .* sliceData;
                end
            end

            % Color Mapping


            %% set plot axes, get plot options
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

            % set colormap
            cmapvar=get(obj.ColorMap,'Value');
            cmap=get(obj.ColorMap,'String');
            load('Colormap.mat');
            cmapData=eval(cmap{cmapvar});
            if get(obj.FlipCheckbox,'Value')
                colormap(axPlot,flipud(cmapData));
            else
                colormap(axPlot,cmapData);
            end

            % set Clim
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
                axis normal;
            end
            set(gca,'linewidth',1.5);
            set(gca,'fontsize',12);

%             % plot energy contour
            if obj.energy_contour_flag == 1
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
            if obj.bz_line_flag == 1
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
                obj.imag.CData = (sliceData'/max(sliceData,[],"all")).^gamma .* sliceData';
            end

            %% set value
            set(obj.Position,'String',num2str(round(pos,3)));
            [~,cond] = min(abs(obj.AxisData - pos));
            set(obj.PositionIndex,'String',num2str(cond));
            set(obj.GammaValue,'String',num2str(round(gamma,3)));

            obj.setClim();
%             % plot energy contour
            if obj.energy_contour_flag == 1

                for i = 1:length(obj.energy_contour_lines)
                    delete(obj.energy_contour_lines{i})
                end

                obj.energy_contour_lines = obj.Data.info.BZBS.plotEnergyContourOnAxes(pos,width,obj.Axis);
            end
%              % plot brillouin zone
            if obj.bz_line_flag == 1

                for i = 1:length(obj.bz_line_lines)
                    delete(obj.bz_line_lines{i})
                end

                obj.bz_line_lines = obj.Data.info.BZBS.plotBrillouinZoneOnAxes(obj.Axis);
            end


        end

        %% menu callback function
        function newFigure(obj,varargin)
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
        
%         function newFigureSubPlot(obj,varargin)
%             inputText=inputdlg('Input Positions');
%             plotArray=inputText{1};
%             plotArray=str2num(plotArray);
%             sliderMin=get(obj.Slider,'Min');           
%             sliderMax=get(obj.Slider,'Max');
%             if isnan(plotArray)
%                 errordlg('Input Array should not be NaN');
%                 return;
%             end
%             if sum(plotArray<sliderMin)
%                 errordlg('Exeeds Min');
%                 return;
%             end
%             if sum(plotArray>sliderMax)
%                 errordlg('Exeeds Max');
%                 return;
%             end
%             n=length(plotArray);
%             for i = 1:ceil(n/9)
%                 figure('Name',[obj.DataName,' ',obj.Direction],...
%                     'Color','w');
%                 for j=1:9
%                     k=(i-1)*9+j;
%                     if k<=n
%                         set(obj.Slider,'Value',plotArray(k));
%                         hAx=subplot(3,3,j);
%                         obj.plot('new',hAx);
%                         title([obj.Direction,'=',num2str(plotArray(k))]);
%                     end
%                 end
%             end
%         end
        
%         function ButtonMotionFcn(obj,~,~)
%             obj.plotCrossHair;
%         end
%         
%         function ButtonUpFcn(obj,~,~)
%             set(obj.Figure,...
%                 'WindowButtonMotionFcn',[],...
%                 'WindowButtonUpFcn',[]);
%         end
        
        function setInd(obj,~,~,SetMethod)
            switch SetMethod
                case '+'
                    posInd = str2double(get(obj.PositionIndex,'String'))+1;                    
                case '-'
                    posInd = str2double(get(obj.PositionIndex,'String'))-1;
                case '='
                    posInd = str2double(get(obj.PositionIndex,'String'));
            end
            if posInd > length(obj.AxisData)
                posInd = length(obj.AxisData);
            end
            if posInd < 1
                posInd = 1;
            end
            pos = obj.AxisData(posInd);
            set(obj.Slider,'Value',pos);
            obj.update_CData();
        end
        
        function setPos(obj,~,~)
            pos = str2double(get(obj.Position,'String'));
            set(obj.Slider,'Value',pos);
            obj.update_CData();
        end
        
        function setAx(obj,~,~)
            if get(obj.Checkbox,'Value')
                set(obj.Axis,'DataAspectRatio',[1 1 1]);
            else
                axis normal;
            end
        end

        function setColor(obj,~,~)
            cmapvar=get(obj.ColorMap,'Value');
            cmap=get(obj.ColorMap,'String');
            load('Colormap.mat');
            cmapData=eval(cmap{cmapvar});
            if get(obj.FlipCheckbox,'Value')
                colormap(obj.Axis,flipud(cmapData));
            else
                colormap(obj.Axis,cmapData);
            end
        end

        function setClim(obj,~,~)

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
            gamma = str2num(get(obj.GammaValue,'String'));
            if gamma > 3
                gamma = 3;
            elseif gamma < 0
                gamma = 0;
            end
            set(obj.SliderGamma,'Value',gamma);
            obj.update_CData();
        end

        function sliderinput(obj,varargin)
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
            obj.PosX = x;
            obj.PosY = y;

            set(obj.XYpos_Editfield,'String', [num2str(round(x,3)) ', ' num2str(round(y,3))]);
            obj.Crosshair2.Position = [obj.PosX + obj.DX, obj.PosY + obj.DY];

            if get(obj.MDCEDC_Menu,'Checked')
                obj.updata_EDCMDC_lines();
            end

        end

        function update_Crosshair2_Positions(obj,x,y)
            obj.DX = x - obj.PosX;
            obj.DY = y - obj.PosY;

            obj.updata_EDCMDC_lines();
        end

        function updata_EDCMDC_lines(obj)
            % updata MDC EDC figure
            xl = min(obj.PosX,obj.PosX+obj.DX);
            xr = max(obj.PosX,obj.PosX+obj.DX);
            [~,xn1] = min(abs(obj.imag.XData-xl));
            [~,xn2] = min(abs(obj.imag.XData-xr));
            x = mean(obj.imag.CData(:,xn1:xn2),2);
            obj.EDC_line.XData = x;

            yd = min(obj.PosY,obj.PosY+obj.DY);
            yu = max(obj.PosY,obj.PosY+obj.DY);
            [~,yn1] = min(abs(obj.imag.YData-yd));
            [~,yn2] = min(abs(obj.imag.YData-yu));
            y = mean(obj.imag.CData(yn1:yn2,:),1);
            obj.MDC_line.YData = y;
        end

        function crosshair_menu_callback(obj,~,~)
            if obj.Crosshair.Visible == 1
                if get(obj.MDCEDC_Menu,'Checked')
                    obj.Crosshair2.Visible = 'off';
                    set(obj.MDCEDC_Menu,'Checked','off');
                    close(obj.FigureEDC);
                    close(obj.FigureMDC);
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
            if get(obj.MDCEDC_Menu,'Checked')
                obj.Crosshair2.Visible = 'off';
                set(obj.MDCEDC_Menu,'Checked','off');
                close(obj.FigureEDC);
                close(obj.FigureMDC);
            else
                if ~get(obj.CrosshairMenu,'Checked')
                    obj.Crosshair.Visible = 'on';
                    set(obj.CrosshairMenu,'Checked','on');
                end

                obj.Crosshair2.Visible = 'on';
                set(obj.MDCEDC_Menu,'Checked','on');

                FigPos = get(obj.Figure,'Position');

                obj.FigureEDC = figure('name','EDC','Position',[FigPos(1)+FigPos(3),FigPos(2),200,FigPos(4)-40]);

                y = obj.imag.YData;
                xl = min(obj.PosX,obj.PosX+obj.DX);
                xr = max(obj.PosX,obj.PosX+obj.DX);
                [~,xn1] = min(abs(obj.imag.XData-xl));
                [~,xn2] = min(abs(obj.imag.XData-xr));
                x = mean(obj.imag.CData(:,xn1:xn2),2);
                obj.EDC_line = plot(x,y,'LineWidth',1.5);

                obj.FigureMDC = figure('name','MDC','Position',[FigPos(1),FigPos(2)-150,FigPos(3),150]);

                x = obj.imag.XData;
                yd = min(obj.PosY,obj.PosY+obj.DY);
                yu = max(obj.PosY,obj.PosY+obj.DY);
                [~,yn1] = min(abs(obj.imag.YData-yd));
                [~,yn2] = min(abs(obj.imag.YData-yu));
                y = mean(obj.imag.CData(yn1:yn2,:),1);
                obj.MDC_line = plot(x,y,'LineWidth',1.5);

                figure(obj.Figure);


            end
        end

        function histogram_menu_callback(obj,~,~)
            figure;
            histogram(obj.imag.CData);
        end

        function perp_DC_menu_callback(obj,~,~)
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

            if obj.Data.x == 1 % cut

                CUT = evalin("base",obj.DataName);
                if class(CUT) ~= "OxA_CUT"
                    return
                end
                CUT.info.thetay_offset = obj.PosX;

                prompt = {'Photon Energy (eV)','Work Function (eV)', 'Y offset (deg)'};
                dlgtitle = 'Cut K-space Conversion';
                definput = {num2str(CUT.info.photon_energy),num2str(CUT.info.workfunction), ...
                    num2str(CUT.info.thetay_offset)};
                dims = [1 60];
                answer = inputdlg(prompt,dlgtitle,dims,definput);
                if isempty(answer)
                    return
                end

                CUT.info.photon_energy = str2num(answer{1});
                CUT.info.workfunction = str2num(answer{2});
                CUT.info.thetay_offset = str2num(answer{3});

                KCUT = CUT.kconvert();
                assignin("base",[obj.DataName '_ksp'],KCUT);

            elseif class(obj.Data) == "OxA_MAP"

                MAP = evalin("base",obj.DataName);
                if obj.Direction == 'z'
                    MAP.info.thetax_offset = obj.PosX;
                    MAP.info.thetay_offset = obj.PosY;
                else
                    disp("Unsupported direction!");
                    return
                end

                prompt = {'Enter azimuth offset (deg): + clockwise, - anticlockwise',...
                    'Photon Energy (eV)','Work Function (eV)', 'X offset (deg)',...
                    'Y offset (deg)'};
                dlgtitle = 'Map K-space Conversion';
                definput = {num2str(MAP.info.azimuth_offset),num2str(MAP.info.photon_energy),...
                    num2str(MAP.info.workfunction), num2str(MAP.info.thetax_offset),...
                    num2str(MAP.info.thetay_offset)};
                dims = [1 60];
                answer = inputdlg(prompt,dlgtitle,dims,definput);
                if isempty(answer)
                    return
                end

                MAP.info.azimuth_offset = str2num(answer{1});
                MAP.info.photon_energy = str2num(answer{2});
                MAP.info.workfunction = str2num(answer{3});
                MAP.info.thetax_offset = str2num(answer{4});
                MAP.info.thetay_offset = str2num(answer{5});

                KMAP = MAP.kconvert();
                assignin("base",[obj.DataName '_ksp'],KMAP);

            elseif class(obj.Data) == "OxA_KZ"

                KZ = evalin("base",obj.DataName);
                if obj.Direction == 'z'
                    KZ.info.thetay_offset = obj.PosY;
                elseif obj.Direction == 'x'
                    KZ.info.thetay_offset = obj.PosX;
                else
                    disp("Unsupported direction!");
                    return
                end

                try 
                    V0 = KZ.info.inner_energy;
                catch
                    V0 = 15;
                end

                prompt = {'Enter Inner Energy (eV)', 'Y offset (deg)'};
                dlgtitle = 'hv Scan K-space Conversion';
                definput = {num2str(V0),num2str(KZ.info.thetay_offset)};
                dims = [1 60];
                answer = inputdlg(prompt,dlgtitle,dims,definput);
                if isempty(answer)
                    return
                end

                KZ.info.inner_energy = str2num(answer{1});
                KZ.info.thetay_offset = str2num(answer{2});


                KKZ = KZ.kconvert();
                assignin("base",[obj.DataName '_ksp'],KKZ);
            end
        end

        %% mass plot
        function copy_axis(obj,~,~)
%             ax1Chil = obj.Axis.Children;
            ax1Chil = obj.Axis;
            f2 = figure();
            ha2 = axes('parent',f2);
            copyobj(ax1Chil,ha2);
        end

        function mass_plot(obj,~,~)

            % create input dialog window and get parameters
            Erng = '(0:-0.1:-1.9)';
            def_cmd = Erng;

            prompt = {'Enter number of columns:','Enter number of rows:','Enter position array:','Save figure:'};
            dlgtitle = 'Input';
            dims = [1 35];
            definput = {'5','4',def_cmd,'0'};
            answer = inputdlg(prompt,dlgtitle,dims,definput);
            if isempty(answer)
                return
            end

            column = str2num(answer{1});
            row = str2num(answer{2});
            posi = str2num(answer{3});
            sf = str2num(answer{4});

            % plot 

            pos0 = get(obj.Slider,'Value');
            
            % create the figure
            if sf == 0 % whether save the figure
                Fig = figure('Name',obj.Data.name);
                Fig.Position = [0 0 1200 800];
                set(Fig, 'color', 'white');
            else
                Fig = figure('Name',obj.Data.name,'visible','off');
                Fig.Position = [0 0 1600 1000];
            end

            for i = 1:length(posi)
                obj.Slider.Value = posi(i);
%                 pause(0.1)
                ha1 = subplot(row,column,i,'parent',Fig);
                
                if get(obj.InterpolateMenu,'Checked')
                    obj.initial_plot('new2intp',ha1);
                else
                    obj.initial_plot('new2',ha1);
                end

                set(ha1,'xlabel',[]);
                set(ha1,'ylabel',[]);

                posi_i = num2str(posi(i));
                switch obj.Direction
                    case 'x'
                        nn = obj.Data.x_name;
                        uu = obj.Data.x_unit;

                        if strcmp(nn,'Photon Energy')
                            nn = 'hv';
                        end
                    case 'y'
                        nn = obj.Data.y_name;
                        uu = obj.Data.y_unit;
                    case 'z'
                        nn = obj.Data.z_name;
                        uu = obj.Data.z_unit;

                        if strcmp(nn,'{\it E}-{\it E}_F')
                            nn = 'BE';
                            posi_i = num2str(-posi(i));
                        elseif strcmp(nn,'Kinetic Energy')
                            nn = 'KE';
                        end
                end
                title(ha1,[nn '= ' posi_i ' ' uu]);

                % copy line objects
                lines = findall(obj.Axis,'Type','line');
                copyobj(lines,ha1);

            end

            % generate group title
            SGT = obj.DataName;

            try 
                [r,c] = size(obj.Data.info.photon_energy);
                if r*c>1
                    hv_max = max(obj.Data.info.photon_energy);
                    hv_min = min(obj.Data.info.photon_energy);
                    hv_step = (hv_max - hv_min)/(r*c-1);
                    HV_str = [num2str(round(hv_min,1)) '/' num2str(hv_step) '/' num2str(round(hv_max,1))];
                else
                    HV_str = num2str(round(obj.Data.info.photon_energy,1));
                end

                SGT = [SGT ': ' HV_str ' eV '];
            catch
            end

            try
                SGT = [SGT char(obj.Data.info.polarization)];
            catch
            end

            if strcmp(obj.Direction,'z')
                SGT = [SGT ' (ΔE=' get(obj.Width,'String') 'eV)'];
            end

            sgtitle(Fig,SGT,'interpreter', 'none');


%             try
%                 sgtitle(Fig,[obj.Data.name ': ' num2str(round(obj.Data.info.photon_energy,1)) 'eV ' char(obj.Data.info.polarization)],'interpreter', 'none');
%             catch
%                 try
%                     sgtitle(Fig,[obj.Data.name ': ' num2str(round(obj.Data.info.photon_energy,1)) 'eV '],'interpreter', 'none');
%                 catch
%                     sgtitle(Fig,obj.Data.name,'interpreter', 'none');
%                 end
%             end

            obj.Slider.Value = pos0;

            if sf == 1

                exportgraphics(Fig,[obj.Data.name,'.jpg'],'Resolution',300);
                close(Fig);
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
            
            x = obj.imag.XData;
            y = obj.imag.YData;
            value = obj.imag.CData';
            data = OxA_CUT(x,y,value);
            data.info = obj.Data.info;

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
            assignin('base',SaveName{1},data);
        end    
        
        function cut(obj,varargin)

            [xlist,ylist]=getpts(obj.Axis);
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

            assignin('base',SaveName{1},data);
        end
    end
end


