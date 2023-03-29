classdef FitCutPanel < handle
    properties (SetObservable)
        FitCut
    end
    properties        
        Parent
        ParentFigure
        Panel
        Axes
        UIThisLine        
    end
    
    methods
        function obj = FitCutPanel(fitCut,parentObj,parentFigure)                       
            obj.Parent = parentObj;
            obj.ParentFigure = parentFigure;
            obj.FitCut = fitCut;            
            obj.refreshPanelCallbcak;
            addlistener(obj,'FitCut','PostSet',@obj.refreshPanelCallbcak);  
            addlistener(obj.FitCut,'CurrentLine','PostSet',...
                @obj.setPosition);
        end
        
        function refreshPanelCallbcak(obj,~,~)            
            % check input
            if ~isa(obj.FitCut,'FitARPES.FitCut')
                disp('FitCut.Panel should be a FitARPES.FitCut object');
                return;
            end
            % delete old panel
            delete(obj.Panel);
            % build new panel
            obj.Panel = uiextras.Panel(...
                'Parent',           obj.Parent,...
                'Padding',          2,...
                'Title',            'Fit Cut Panel');
            obj.Axes = axes(...
                'Parent',           obj.Panel);
            obj.FitCut.pcolor(obj.Axes);
            hold on;
            obj.FitCut.scatter(obj.Axes);
            hold off;
            obj.UIThisLine = phuitools.UIThisLine(...
                obj.ParentFigure,...
                obj.Axes,...
                obj.FitCut.CurrentLine.Direction,...
                obj.FitCut.CurrentLine.Position,...
                @obj.setFitCutCurrentLinePos,...
                @obj.setFitCutCurrentLinePos,...
                'LineWidth',2,...
                'Color','b');   
        end
        
        function setFitCutCurrentLinePos(obj)
            pos = obj.UIThisLine.Position;          
            obj.FitCut.CurrentLine.Index = obj.FitCut.pos2ind(pos);    
        end
        
        function setPosition(obj,~,~)
            obj.UIThisLine.setPosition(obj.FitCut.CurrentLine.Position);
        end
    end
    
end