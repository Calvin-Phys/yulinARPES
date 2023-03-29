classdef FitBackgroundOfLine < handle    
    properties (SetAccess = private)
        Direction   % direction of the line (x or y)
    end
    properties
        X           % coordinates along the direction
        % y = a*x.^2 + b*x + c
        a
        b
        c
        ParaFixFlag % Flag that determines whether the parameter is fixed
    end
    properties (Dependent)
        Y           % value of basement
    end
    
    methods
        %% Constructor
        function fitBackgroundOfLineObj = ...
                FitBackgroundOfLine(fitLineOfCutObj,Points)
            fitBackgroundOfLineObj.Direction = fitLineOfCutObj.Direction;
            fitBackgroundOfLineObj.X = fitLineOfCutObj.X;
            [av,bv,cv]=phuitools.getParabola(...
                fitBackgroundOfLineObj.Direction,Points);
            fitBackgroundOfLineObj.a=av;
            fitBackgroundOfLineObj.b=bv;
            fitBackgroundOfLineObj.c=cv;
            fitBackgroundOfLineObj.ParaFixFlag=[false,false,false];
        end
        
        function y = get.Y(fitBackgroundOfLineObj)
            x=fitBackgroundOfLineObj.X;
            av=fitBackgroundOfLineObj.a;
            bv=fitBackgroundOfLineObj.b;
            cv=fitBackgroundOfLineObj.c;            
            y = av*x.^2 + bv*x + cv;
        end
        %% Visualization Method
        function h = plot(fitBackgroundOfLineObj,varargin)
            switch fitBackgroundOfLineObj.Direction
                case 'x'
                    x=fitBackgroundOfLineObj.X;
                    y=fitBackgroundOfLineObj.Y;
                case 'y'
                    x=fitBackgroundOfLineObj.Y;
                    y=fitBackgroundOfLineObj.X;
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
    
    methods (Static)
        function fitBackgroundOfLineObj=test()
            figure(100);
            fitLineOfCutObj = evalin('base','fitCut.YLines(60)');
            fitLineOfCutObj.scatter;
            [vx,vy]=getpts;
            fitBackgroundOfLineObj = FitARPES.FitBackgroundOfLine(...
                fitLineOfCutObj,[vx,vy]);
            hold on;
            fitBackgroundOfLineObj.plot;
            hold off
        end
    end
    
end

