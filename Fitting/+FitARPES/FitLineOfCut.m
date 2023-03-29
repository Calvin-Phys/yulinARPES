classdef FitLineOfCut < handle & matlab.mixin.Copyable
    events
        FitDone
    end
    properties (SetAccess = private)
        Direction   % direction of the line (x or y)
    end
    properties
        Pos         % position of the line
        IndPos      % index postion    
        X           % coodinates along the direction
        Y           % value   
        FitInfo = FitARPES.FitInfoForIPeak
                    % fitting information using in ipeak
        Peaks       % FitARPES.FitPeakOfLine objects
        Background  % baseline
        ShapeMode   % Gaussian or Lorentzian
    end
    properties (Dependent)
        YFitSum     % value given by the fitting result
    end
    
    methods         
        %% Constructor
        function fitLineOfCutObj = ...
                FitLineOfCut(data,direction,index,ShapeMode)
            % Object Constructor
            FitARPES.is2DARPESData(data);
            fitLineOfCutObj.Direction=lower(direction);
            fitLineOfCutObj.IndPos = index;
            switch fitLineOfCutObj.Direction
                case 'x'
                    fitLineOfCutObj.X = data.x;
                    fitLineOfCutObj.Y = data.value(:,index)';
                    fitLineOfCutObj.Pos = data.y(index);
                case 'y'
                    fitLineOfCutObj.X = data.y;
                    fitLineOfCutObj.Y = data.value(index,:);
                    fitLineOfCutObj.Pos = data.x(index);
                otherwise
                    error('direction should be either x or y')                    
            end
            fitLineOfCutObj.ShapeMode = ShapeMode;
        end % end of Object Constructor        

        %% Visualization Methods
        function h=scatter(fitLineOfCutObj,varargin)
            % scatter plot a line
            switch fitLineOfCutObj.Direction
                case 'x'
                    x=fitLineOfCutObj.X;
                    y=fitLineOfCutObj.Y;
                case 'y'
                    x=fitLineOfCutObj.Y;
                    y=fitLineOfCutObj.X;
                otherwise
                    disp(fitLineOfCutObj);
                    error('Invalid direction.');
            end
            if nargin == 1
                h=scatter(x,y,'b');
            elseif nargin > 1
                h=scatter(x,y,'b',varargin);
            end
        end % end of scatter
        
        function h=plot(fitLineOfCutObj,varargin)
            % plot a line
            switch fitLineOfCutObj.Direction
                case 'x'
                    x=fitLineOfCutObj.X;
                    y=fitLineOfCutObj.Y;
                case 'y'
                    x=fitLineOfCutObj.Y;
                    y=fitLineOfCutObj.X;
                otherwise
                    disp(fitLineOfCutObj);
                    error('Invalid direction.');
            end
            if nargin == 1
                h=plot(x,y);
            elseif nargin > 1
                h=plot(x,y,varargin{:});
            end
        end % end of plot
        
        function h=plotSum(fitLineOfCutObj,varargin)            
            % plotSum plots the sum of all peaks of a line
            x=fitLineOfCutObj.X;
            y=fitLineOfCutObj.YFitSum;
            switch fitLineOfCutObj.Direction
                case 'x'
                    xdata=x;
                    ydata=y;
                case 'y'
                    ydata=x;
                    xdata=y;
                otherwise
                    disp(fitLineOfCutObj);
                    error('Invalid direction.');
            end
            if nargin == 1
                h=plot(xdata,ydata);
            elseif nargin > 1
                h=plot(xdata,ydata,varargin{:});
            end
        end % end of plotSum
        
        function y=get.YFitSum(fitLineOfCutObj)
            n=length(fitLineOfCutObj.Peaks);
            y=0;
            for i = 1:n
                y = y + fitLineOfCutObj.Peaks(i).Y;
            end
            y = y+fitLineOfCutObj.Background.Y;
        end
        %% Interface for ipeak
        function getPeaksFromIPeak(fitLineOfCutObj)
            % use ipeak to get peaks
            global P
            % In case obj hasn't been initialized:
            fitLineOfCutObj.FitInfo=...
                fitLineOfCutObj.FitInfo.getFromIPeak(fitLineOfCutObj);            
            % Get number of peaks:
            n=size(P,1);
            % Delete existed peaks and background:
            delete(fitLineOfCutObj.Peaks);
            fitLineOfCutObj.Peaks=[];
            delete(fitLineOfCutObj.Background);
            fitLineOfCutObj.Background=[];
            % Create new peaks objectd and background:
            for i = 1:n
                fitPeaks(i)=...
                    FitARPES.FitPeakOfLine(fitLineOfCutObj,P(i,:));
            end
            fitLineOfCutObj.Peaks=fitPeaks;
            fitLineOfCutObj.Background=...
                FitARPES.FitBackgroundOfLine(fitLineOfCutObj,[0,0]);
        end % end of getPeaksFromIPeak
        
        function ipeak(fitLineOfCutObj)
            % ipeak method overloads ipeak function
            % If the obj has not been initialized (i.e. FitInfo has not...
            % been defined yet), ipeak will initialize it.
            try % some spectrum is not suitble for ipeak
                if ~fitLineOfCutObj.FitInfo.isInitialized
                    ipeak(fitLineOfCutObj.X,fitLineOfCutObj.Y,4);
                    fitLineOfCutObj.FitInfo=...
                        fitLineOfCutObj.FitInfo.getFromIPeak;
                end
                xcenter = (max(fitLineOfCutObj.X)+min(fitLineOfCutObj.X))/2;
                xrange = max(fitLineOfCutObj.X)-min(fitLineOfCutObj.X);
                ipeak([fitLineOfCutObj.X;fitLineOfCutObj.Y],...
                    0,...
                    fitLineOfCutObj.FitInfo.AmpThreshold,...
                    fitLineOfCutObj.FitInfo.SlopeThreshold,...
                    fitLineOfCutObj.FitInfo.SmoothWidth,...
                    fitLineOfCutObj.FitInfo.FitWidth,...
                    xcenter,...
                    xrange) ;
            catch ME
                disp(['Fit Failed for ', fitLineOfCutObj.Direction,...
                    num2str(fitLineOfCutObj.IndPos)]);
                ME.rethrow;
            end % end try
         
        end
        

        
               
        %% fitting method
        function fit(fitLineOfCutObj)
            % get initial value
            n=length(fitLineOfCutObj.Peaks);
            k=0;
            for i = 1:n
                if ~fitLineOfCutObj.Peaks(i).ParaFixFlag(1)
                    k=k+1;
                    para(k)=fitLineOfCutObj.Peaks(i).Pos; %#ok<*AGROW>
                end
                if ~fitLineOfCutObj.Peaks(i).ParaFixFlag(2)
                    k=k+1;
                    para(k)=fitLineOfCutObj.Peaks(i).Height;
                end
                if ~fitLineOfCutObj.Peaks(i).ParaFixFlag(3)
                    k=k+1;
                    para(k)=fitLineOfCutObj.Peaks(i).Width;
                end
            end
            if ~fitLineOfCutObj.Background.ParaFixFlag(1)
                k=k+1;
                para(k)=fitLineOfCutObj.Background.a;
            end
            if ~fitLineOfCutObj.Background.ParaFixFlag(2)
                k=k+1;
                para(k)=fitLineOfCutObj.Background.b;
            end
            if ~fitLineOfCutObj.Background.ParaFixFlag(3)
                k=k+1;
                para(k)=fitLineOfCutObj.Background.c;
            end
            % fitting
            para0=para;
            [para, res, ExitFlag]=...
                fminsearch(@fitLineOfCutObj.getVariance,para);
            if ExitFlag == -1
                warning(['Fitting unsuccessful for ',...
                    num2str(fitLineOfCutObj.IndPos)])
            end
            if ExitFlag == 0
                warning(['Fitting reached max num of iterations for ',...
                    num2str(fitLineOfCutObj.IndPos)])
            end
            notify(fitLineOfCutObj,'FitDone');
        end % end of fit
        
        function Variance=getVariance(fitLineOfCutObj,para)
            % getVariance get variance of fitting result and experiment
            % result.
            
            % Get parameters:
            n=length(fitLineOfCutObj.Peaks);
            k=0;
            for i = 1:n
                if ~fitLineOfCutObj.Peaks(i).ParaFixFlag(1)
                    k=k+1;
                    fitLineOfCutObj.Peaks(i).Pos = para(k);
                end
                if ~fitLineOfCutObj.Peaks(i).ParaFixFlag(2)
                    k=k+1;
                    fitLineOfCutObj.Peaks(i).Height = para(k);
                end
                if ~fitLineOfCutObj.Peaks(i).ParaFixFlag(3)
                    k=k+1;
                    fitLineOfCutObj.Peaks(i).Width = para(k);
                end
            end
            if ~fitLineOfCutObj.Background.ParaFixFlag(1)
                k=k+1;
                fitLineOfCutObj.Background.a = para(k);
            end
            if ~~fitLineOfCutObj.Background.ParaFixFlag(2)
                k=k+1;
                fitLineOfCutObj.Background.b = para(k);
            end
            if ~fitLineOfCutObj.Background.ParaFixFlag(3)
                k=k+1;
                fitLineOfCutObj.Background.c = para(k);
            end        
            % Get variance
            % The fitting methods are within objects.
            VarianceArray = fitLineOfCutObj.YFitSum-fitLineOfCutObj.Y;
            Variance = sqrt(sum(VarianceArray.^2)/length(VarianceArray));
        end       
        
        %% Copy
        function newObj = copyObj(oldObj)
            newObj=oldObj.copy;
            n=length(newObj.Peaks);
            for i = 1:n
                newObj.Peaks(i) = oldObj.Peaks(i).copy;
            end
        end
       
    end
    methods (Static)
        function test()
            % test. fitCut is resulted from
            % fitCut = FitARPES.FitCut(CutData), 
            % with necessary initialization
                        
            fitCut=evalin('base','fitCut');
            figure(100);
            fitCut.XLines(60).scatter;
            hold on
            fitCut.XLines(60).Peaks(1).Pos=...
                fitCut.XLines(60).Peaks(1).Pos+1;
            fitCut.XLines(60).plotSum('Color','y');
            fitCut.XLines(60).fit;
            fitCut.XLines(60).plotSum('Color','g');
            hold off
        end
    end
end



















