classdef HistAdjust < handle
    properties
        Figure      
        Axis
        FigureNum
        AnchorNum
        GetHistButton
        Reset
        
        Max
        Min
        Gamma
        
        CurrentObj
        DataIn = []
        DataOut
        FixPoints        
    end
    
    methods
        function obj=HistAdjust(varargin)            
            FIG_POSITION = [500 50 350 375];    
            if ~isempty(findobj('Tag','HistAdjust'))
                return;
            end
            obj.Figure=figure(...
                'Position',         FIG_POSITION,...
                'Name',             'HistAdjust',...
                'NumberTitle',      'off',...
                'MenuBar',          'none',...
                'IntegerHandle',    'off',...
                'HandleVisibility', 'off',...
                'Tag',              'HistAdjust',...
                'WindowButtonDownFcn',@obj.uiPlot);
            
            HomeVBox = uiextras.VBox(...
                'Parent',           obj.Figure);
            PanelHBox1 = uiextras.HBox(...
                'Parent',           HomeVBox);
            PanelHBox2 = uiextras.HBox(...
                'Parent',           HomeVBox);
            AxPanel = uipanel(...
                'Parent',           HomeVBox);
            obj.Axis = axes(...
                'Parent',           AxPanel,...
                'ButtonDownFcn',    @obj.uiPlot);  
            set(HomeVBox,'Sizes',[25,25,-1]);
            uicontrol(...
                'Parent',           PanelHBox1,...
                'Style',            'text',...
                'String',           'FigNum');            
            obj.FigureNum = uicontrol(...
                'Parent',           PanelHBox1,...
                'Style',            'edit',...
                'String',           '100');
            uicontrol(...
                'Parent',           PanelHBox1,...
                'Style',            'text',...
                'String',           'AnchorNum');
            obj.AnchorNum = uicontrol(...
                'Parent',           PanelHBox1,...
                'Style',            'edit',...
                'String',           '8');
            obj.GetHistButton = uicontrol(...
                'Parent',           PanelHBox1,...
                'Style',            'pushbutton',...
                'String',           'Get Hist Figure',...
                'Callback',         @obj.getHist);
            obj.Reset = uicontrol(...
                'Parent',           PanelHBox1,...
                'Style',            'pushbutton',...
                'String',           'Reset',...
                'Callback',         @obj.reset);
            helpstr = {'To move anchor points',...
                '       Vertically: Click&Drag,',...
                '       Horizontally: Ctrl+Click&Drag'};
            func = @(varargin)msgbox(helpstr,'Help','Help');
            uicontrol(...
                'Parent',           PanelHBox1,...
                'Style',            'Pushbutton',...
                'String',           'Help',...
                'Callback',         func);
            
            set(PanelHBox1,'Sizes',[40,30,60,30,80,60,50]);
            
            hold(obj.Axis,'on');
            obj.FixPoints.Points = ...
                scatter(obj.Axis,linspace(0,1,8),linspace(0,1,8));
            xlist = linspace(0,1,1000);
            ylist = xlist;
            obj.FixPoints.Plot = ...
                line('Parent',obj.Axis,'XData',xlist,'YData',ylist);            
            set(obj.FixPoints.Plot,'ButtonDownFcn',@obj.uiPlot);
            xlim(obj.Axis,[-0.1,1.1])
            ylim(obj.Axis,[-0.1,1.1])
            line('Parent',obj.Axis,'XData',[-0.1,1.1],'YData',[0,0],'Color','black');
            line('Parent',obj.Axis,'XData',[-0.1,1.1],'YData',[1,1],'Color','black');
            line('Parent',obj.Axis,'XData',[0 0],'YData',[-0.1 1.1],'Color','black');
            line('Parent',obj.Axis,'XData',[1 1],'YData',[-0.1 1.1],'Color','black');
            xlabel(obj.Axis,'Colormap In');
            ylabel(obj.Axis,'Colormap Out');
        end
        function getHist(obj,varargin)
            cla(obj.Axis);
            FigNum = str2double(get(obj.FigureNum,'String'));
            m = str2double(get(obj.AnchorNum,'String'));
            h = findobj(FigNum);
            for i = 1:length(h)
                if isa(h(i),'matlab.graphics.axis.Axes')
                    obj.CurrentObj = h(i);
                end
            end
            obj.DataIn = colormap(obj.CurrentObj);
            [n,~]=size(obj.DataIn);
            hold(obj.Axis,'on');
            obj.FixPoints.Points = ...
                scatter(obj.Axis,linspace(0,1,m),linspace(0,1,m));
            xlist = linspace(0,1,n);
            ylist = xlist;
            obj.FixPoints.Plot = ...
                line(obj.Axis,xlist,ylist);
            xlim(obj.Axis,[-0.1,1.1])
            ylim(obj.Axis,[-0.1,1.1])
            line('Parent',obj.Axis,'XData',[-0.1,1.1],'YData',[0,0],'Color','black');
            line('Parent',obj.Axis,'XData',[-0.1,1.1],'YData',[1,1],'Color','black');
            line('Parent',obj.Axis,'XData',[0 0],'YData',[-0.1 1.1],'Color','black');
            line('Parent',obj.Axis,'XData',[1 1],'YData',[-0.1 1.1],'Color','black');
        end
        function outHist(obj,varargin)
            %% Make Table
            [n,~] = size(obj.DataIn);
            ylist = linspace(0,1,n);
            xlist = interp1(...
                obj.FixPoints.Points.YData,...
                obj.FixPoints.Points.XData,...
                ylist);
            obj.FixPoints.Plot.XData = xlist;
            ylim(obj.Axis,[-0.1,1.1])
            %% Output
            obj.DataOut = obj.DataIn;
            for i = 1:3
                obj.DataOut(:,i) = interp1(linspace(0,1,n),...
                    obj.DataIn(:,i),xlist);
            end
            colormap(obj.CurrentObj,obj.DataOut);
        end
        function adjustHistManual(obj,varargin)
            %% Get Color Mapping
            if isempty(obj.DataIn)
                return;
            end
            pos=get(obj.Axis,'CurrentPoint');
            xpos=pos(1,1);
            ypos=pos(1,2);
            [~,selected] = min(abs(xpos-obj.FixPoints.Points.XData));
            if ypos<0||ypos>1
                return
            end
            selected=selected+2;
            yTemp = ones(1,length(obj.FixPoints.Points.YData)+4);
            yTemp(1:2)=0;
            yTemp(3:end-2)=obj.FixPoints.Points.YData;  
            
            offset = ypos-yTemp(selected);
            if offset>0
                distance = ...
                    yTemp(selected+2)-yTemp((selected-1):(selected+1));
            elseif offset < 0
                distance = ...
                    yTemp(selected-2)-yTemp((selected-1):(selected+1));
            else 
                return
            end
            offsetlist = distance.*[0.3,1,0.3]*offset/distance(2);
            yTemp((selected-1):(selected+1))=...
                yTemp((selected-1):(selected+1))+offsetlist;
            if (ypos<=yTemp(selected-1))||(ypos<=0)
                return;
            end
            if (ypos>=yTemp(selected+1))||(ypos>=1)
                return;
            end
            obj.FixPoints.Points.YData = yTemp(3:end-2);
            obj.FixPoints.Points.YData(1)=0;
            obj.FixPoints.Points.YData(end)=1;
            obj.outHist;
            %%
        end

        function setAnchor(obj,varargin)
            pos=get(obj.Axis,'CurrentPoint');
            xpos=pos(1,1);
            if xpos<0||xpos>1
                return
            end
            [~,selected] = min(abs(xpos-obj.FixPoints.Points.XData));
            obj.FixPoints.Points.XData(selected)=xpos;
            xlist = obj.FixPoints.Plot.XData;
            ylist = obj.FixPoints.Plot.YData;
            ypos = interp1(xlist,ylist,xpos);
            obj.FixPoints.Points.YData(selected)=ypos;
        end

        function uiPlot(obj,varargin)
            switch obj.Figure.SelectionType
                case 'normal'
                    set(obj.Figure,'WindowButtonMotionFcn',@obj.adjustHistManual);
                case 'alt'
                    set(obj.Figure,'WindowButtonMotionFcn',@obj.setAnchor);
                case 'open'
                    set(obj.Figure,'WindowButtonMotionFcn',@obj.setAnchor);            
            end
            set(obj.Figure,'WindowButtonUpFcn',@obj.stop);
        end
        function stop(obj,varargin)
            set(obj.Figure,'WindowButtonMotionFcn','');
            set(obj.Figure,'WindowButtonUpFcn','');
        end
        function reset(obj,varargin)
            if isempty(obj.DataIn)
                return;
            end
            m = str2double(get(obj.AnchorNum,'String'));
            [n,~] = size(obj.DataIn);
            colormap(obj.CurrentObj,obj.DataIn);
            set(obj.FixPoints.Plot,'XData',linspace(0,1,n),...
                'YData',linspace(0,1,n));
            set(obj.FixPoints.Points,'XData',linspace(0,1,m),...
                'YData',linspace(0,1,m));
        end
        
    end
    
end

