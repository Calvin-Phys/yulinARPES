classdef FitFermiSurface < handle
    properties
        Figure;
        PbGetFromFigure;
        PbGetFromWorkspace;
        PbCorrect;
        PbFit;
        PbOffset;
        Table;
        ParameterTable;
        Axis;
        Menu;
        Data=[];
        DataFitted=[];
        DataCorr=[];
    end
    methods % Constructor
        figureConstruct(obj);
        menuConstruct(obj);
        function obj=FitFermiSurface(hObject,eventdata) 
            obj.figureConstruct;
            obj.menuConstruct;
        end
        
    end
    methods % functions
        getFromFigure(obj,varargin);
        getFromWorkspace(obj,varargin);
        fit(obj,varargin);
        corr(obj,varargin);
        offset_Eaxis(obj,varargin);
    end
    methods (Static)
        yData=fdDistribution(xData,coef);
    end
end