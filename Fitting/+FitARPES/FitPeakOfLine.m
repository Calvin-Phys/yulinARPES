classdef FitPeakOfLine < handle & matlab.mixin.Copyable
    properties (SetAccess = private)
        Direction   % direction of the line (x or y)
        ParentCut   % Record fitLineofCutObj which is the parent.
    end
    properties        
        Num         % number of the peak
        X           % coordinates along the direction
        Pos         % position of the peak
        Height      % height of the peak
        Width       % width of the peak
        Area        % area of the peak
        Error       % error of fitthing
        ParaFixFlag % Flag that determines whether the parameter is fixed
        Tag=[]      % Tag of the peak (PeakA, PeakB, etc...)
    end
    properties (Dependent)
        Y           % Y is the value derived from the peak properties
    end
    methods
        %% Constructor
        function fitPeakOfLineObj = ...
                FitPeakOfLine(fitLineOfCutObj,...
                peakData)
            
            fitPeakOfLineObj.Direction=fitLineOfCutObj.Direction;
            fitPeakOfLineObj.Num=peakData(1);
            fitPeakOfLineObj.X=fitLineOfCutObj.X;
            fitPeakOfLineObj.Pos=peakData(2);
            fitPeakOfLineObj.Height=peakData(3);
            fitPeakOfLineObj.Width=peakData(4);
            fitPeakOfLineObj.Area=peakData(5);
            fitPeakOfLineObj.Error=peakData(6);
            fitPeakOfLineObj.ParaFixFlag=[false,false,false];
            fitPeakOfLineObj.ParentCut = fitLineOfCutObj;
        end
        function Y=get.Y(fitPeakOfLineObj)
            h = fitPeakOfLineObj.Height;
            p = fitPeakOfLineObj.Pos;
            x = fitPeakOfLineObj.X;
            w = fitPeakOfLineObj.Width;
            c = w/(2*sqrt(2));
            switch fitPeakOfLineObj.ParentCut.ShapeMode                
                case 'Gaussian'
                    Y = h*exp(-(x-p).^2/(2*c^2));                        
                case 'Lorentzian'
                    Y = h*w^2./((x-p).^2+w^2);
                otherwise
                    disp([fitPeakOfLineObj.ParentCut.ShapeMode,...
                        ' is not supported.'])
            end
        end
        %% Visualization Methods
        function h=plot(fitPeakOfLineObj,varargin)
            switch fitPeakOfLineObj.Direction
                case 'x'
                    x=fitPeakOfLineObj.X;
                    y=fitPeakOfLineObj.Y;
                case 'y'
                    x=fitPeakOfLineObj.Y;
                    y=fitPeakOfLineObj.X;
                otherwise
                    disp(fitPeakOfLineObj);
                    error('Invalid direction.');
            end
            if nargin == 1
                h=plot(x,y);
            elseif nargin > 1
                h=plot(x,y,varargin);
            end
        end
    end
    
end

