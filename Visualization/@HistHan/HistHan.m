classdef HistHan < handle
    % HistHan(ParentFigure,TargetFigure,OutputAxes)
    % By Default: ParentFigure == ~, created a new figure window
    %             TargetFigure == ~, gcf
    %             OutputPanel == ~, no histgram output
    % Actually, TargetFigure can be any container with appdata and an axes
    % inside.
    properties 
        % I/O properties
        ParentPanel
        TargetFigure
        OutputPanel        
        % Panel controls
        SliderMin
        SliderMax
        SliderGamma               
        MinValue
        MaxValue
        GammaValue
        
        ColorMap  
        FlipCheckbox 
    end
    
    methods
        histEq(obj,varargin)
        reset(obj,varargin)
        colormap(obj,varargin)
        checkSliderInput(obj,varargin)
        constructFig(obj)
        function obj = HistHan(parpan,tarfig,outpan,varargin)
            if isempty(parpan)
                h=figure(gcf);
                pos=get(h,'Position');
                FIG_POSITION = [pos(1) pos(2) 500 82]; 
                obj.ParentPanel=figure(...
                    'Position',         FIG_POSITION,...
                    'Name',     'HistHan',...
                    'NumberTitle',      'off',...
                    'MenuBar',          'none',...
                    'IntegerHandle',    'off',...
                    'HandleVisibility', 'off',...
                    'Tag',              'HistHan');
            else
                obj.ParentPanel = parpan();
            end
            if isempty(tarfig)
                obj.TargetFigure = @gca;
            else
                obj.TargetFigure = @()tarfig;
            end
            if isempty(outpan)
                obj.OutputPanel = [];
            else
                obj.OutputPanel = outpan;
            end
            obj.constructFig;            
        end
    end
    
end

