classdef FermiDiracDistributionCorr<handle
    properties
        Figure
        Menu
        Data
        SelectFigure
        InputFigureNum
        SelectVariable
        SelectDirection
        InputTemperature
        InputEnergyResolution
        InputEf
        InputThreshold
        
        Axis
        LineOfEf
        CurveOfEDC
        CurveOfFDD
        CurveOfCorrEDC                
    end
    methods % Figure Constructors
        figureConstruct(obj);
        menuConstruct(obj);
    end
    methods % Callbacks
        getEDCFromFigure(obj,varargin);
        getEDCFromVariable(obj,varargin);
        plot(obj,varargin);
    end
    methods
        function obj=FermiDiracDistributionCorr(varargin)
            obj.figureConstruct;
            obj.menuConstruct;
        end
    end      
end

