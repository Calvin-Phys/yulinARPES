classdef DispersionReconstruction<handle
    %
    
    properties
        % Figure
        Figure
        PbGetFromWorkspace
        PbRender 
        PbFit
        Table
        ParameterTable
        Axis1
        Axis2
        Menu
        % Data
        Data
    end
    
    methods
        figureConstruct(obj)
        menuConstruct(obj)
        getFromWorkspace(obj,varargin)
        fitPar(obj,varargin)
        [Parameter0,ParameterF,ParameterL,ParameterU]=...
            getParameterTable(obj,varargin)
        setParameterTable(obj,Parameter0);
        function obj=DispersionReconstruction()
            obj.figureConstruct;
            obj.menuConstruct;
        end

        function render(obj,varargin)
            Parameter0=obj.getParameterTable;
            data=obj.Data;
            Lx=length(data.x);
            Ly=length(data.y);
            x0=min(data.x);
            stepX=(max(data.x)-min(data.x))/Lx;
            ParameterNormalized=obj.normalizePar(Parameter0,data);
            fPara=fieldnames(ParameterNormalized);
            para=cell(size(fPara));
            for i = 1:length(fPara)
                para{i}=ParameterNormalized.(fPara{i});
            end            
            v=DispersionReconstruction.dipersionRender(Lx,Ly,x0,stepX,para{:});
            pcolor(obj.Axis2,data.x,data.y,v');
            shading(obj.Axis2,'interp');
        end
    end
    
    methods (Static)        
        v=dipersionRender(Lx,Ly,x0,stepX,Ef,Et,Ew,dE,dK,p,m)
        ParameterNormalized = normalizePar(Parameter0,data)
        Parameter0=denormalizePar(ParameterNormalized,data);
    end
    
end
