classdef FitCut < handle & matlab.mixin.Copyable
    properties
        Data        % cut data
        XLines      % FitARPES.FitLineOfCut objects in X direction
        YLines      % FitARPES.FitLineOfCut objects in Y direction
    end
    properties (SetObservable)
        CurrentLine
    end
    properties (Dependent)
        ThisLine
    end
    methods
        %% Constructor and related methods
        function fitCutObj = FitCut(data)
            % Object Constructor
            fitCutObj.Data = data;
            fitCutObj.XLines = fitCutObj.createXLines;
            fitCutObj.YLines = fitCutObj.createYLines;
            fitCutObj.CurrentLine = FitARPES.CurrentLineOfFitCut(...
                fitCutObj,'x',1);
        end % end of constructor
        
        function xLines = createXLines(fitCutObj)
            yLength = length(fitCutObj.Data.y);            
            for i = 1:yLength
                xLines(i) = ...
                    FitARPES.FitLineOfCut(...
                    fitCutObj.Data,...
                    'x',...
                    i,...
                    'Lorentzian');
            end
        end % end of createXLines
        
        function yLines = createYLines(fitCutObj)
            xLength = length(fitCutObj.Data.x);
            for i = 1:xLength
                yLines(i) =...
                    FitARPES.FitLineOfCut(...
                    fitCutObj.Data,...
                    'y',...
                    i,...
                    'Lorentzian');
            end
        end % end of createYLines     
        
        %% Visualization Methods
        function h=pcolor(fitCutObj,axisHandle,varargin)
            % create a surface from the 2D cut
            data=fitCutObj.Data;
            h=pcolor(axisHandle,data.x,data.y,data.value');
            colormap(gray);
            shading(axisHandle,'interp');
        end
        
        function h=scatter(fitCutObj,varargin)
            % scatter marks all the peaks in the 2D cut plane
            % varargin is for the additional Property-Value pairs
            [x,y,height,~]=fitCutObj.getPeaks;
            if nargin == 2
                h=scatter(x,y,height*20/max(height),'r',...
                    'Marker','o');
            elseif nargin > 2
                h=scatter(x,y,height*20/max(height),'r',...
                    'Marker','o',varargin);
            end
            
        end
        
        function [x,y,height,width]=getPeaks(fitCutObj)
            % getPeaks get all the peaks containing in X/YLines objects.
            x=[];
            y=[];
            height=[];
            width=[];
            switch fitCutObj.CurrentLine.Direction
                case 'x'
                    k=0;
                    n=length(fitCutObj.XLines);
                    for i = 1:n
                        m=length(fitCutObj.XLines(i).Peaks);
                        for j=1:m
                            xt=fitCutObj.XLines(i).Peaks(j).Pos;
                            yt=fitCutObj.XLines(i).Pos;
                            ht=fitCutObj.XLines(i).Peaks(j).Height;
                            wt=fitCutObj.XLines(i).Peaks(j).Width;
                            isxValid=~(isinf(xt)||isnan(xt));
                            isyValid=~(isinf(yt)||isnan(yt));
                            ishValid=~(isinf(ht)||isnan(ht));
                            iswValid=~(isinf(wt)||isnan(wt));
                            if isxValid&&isyValid&&ishValid&&iswValid
                                k=k+1;
                                x(k)=fitCutObj.XLines(i).Peaks(j).Pos;
                                y(k)=fitCutObj.XLines(i).Pos;
                                height(k)=fitCutObj.XLines(i).Peaks(j).Height;
                                width(k)=fitCutObj.XLines(i).Peaks(j).Width;
                            end
                        end
                    end
                case 'y'
                    k=0;
                    n=length(fitCutObj.YLines);
                    for i = 1:n
                        m=length(fitCutObj.YLines(i).Peaks);
                        for j=1:m
                            xt=fitCutObj.YLines(i).Peaks(j).Pos;
                            yt=fitCutObj.YLines(i).Pos;
                            ht=fitCutObj.YLines(i).Peaks(j).Height;
                            wt=fitCutObj.YLines(i).Peaks(j).Width;
                            isxValid=~(isinf(xt)||isnan(xt));
                            isyValid=~(isinf(yt)||isnan(yt));
                            ishValid=~(isinf(ht)||isnan(ht));
                            iswValid=~(isinf(wt)||isnan(wt));
                            isPeakValid=isxValid&&isyValid&&ishValid&&iswValid;
                            if isPeakValid
                                k=k+1;
                                y(k)=fitCutObj.YLines(i).Peaks(j).Pos;
                                x(k)=fitCutObj.YLines(i).Pos;
                                height(k)=fitCutObj.YLines(i).Peaks(j).Height;
                                width(k)=fitCutObj.YLines(i).Peaks(j).Width;
                            end
                        end
                    end
                otherwise
                    error('direction can be either x or y');
            end
        end
        %% ipeak
        function ipeak(fitCutObj,~,~)
            fitCutObj.ThisLine.ipeak;
        end
        %% Copy
        function newObj = copyObj(oldObj)
            newObj=oldObj.copy;
            n=length(newObj.XLines);
            for i = 1:n
                newObj.XLines(i) = oldObj.XLines(i).copyObj;
            end
            m=length(newObj.YLines);
            for i = 1:m
                newObj.YLines(i) = oldObj.YLines(i).copyObj;
            end
        end
        
        function copyValue(oldObj,newObj)
            % newObj will copy all properties from oldObj, but reserve its
            % own listeners.
            % oldObj and newObj should belong to the same class
            newObj.Data=oldObj.Data;
            newObj.CurrentLine=oldObj.CurrentLine;
            n=length(newObj.XLines);
            for i = 1:n
                newObj.XLines(i) = oldObj.XLines(i).copyObj;
            end
            m=length(newObj.YLines);
            for i = 1:m
                newObj.YLines(i) = oldObj.YLines(i).copyObj;
            end
        end
        
        %% Validate
        function [inputLine,flag] = validateInputCurrentLine(fitCutObj,inputLine)
            flag = 1;
            switch inputLine.Direction
                case 'x'
                    indMax = length(fitCutObj.Data.y);
                case 'y'
                    indMax = length(fitCutObj.Data.x);
                otherwise
                    error('Direction should be either ''x'' or ''y''.')
            end
            indMin = 1;
            if inputLine.Index<indMin
                inputLine.Index = indMin;
                flag = 0;
            end
            if inputLine.Index>indMax
                inputLine.Index = indMax;
                flag = 0;
            end
        end
        
        %% get method
        function ThisLine = get.ThisLine(fitCutObj)
            switch fitCutObj.CurrentLine.Direction
                case 'x'
                    Lines = 'XLines';
                case 'y'
                    Lines = 'YLines';                   
                otherwise
                    error('Direction should be either ''x'' or ''y''');                    
            end
            Index = fitCutObj.CurrentLine.Index;
            IndMax = length(fitCutObj.(Lines));
            if Index > IndMax
                Index = IndMax;
            end
            if Index < 1
                Index = 1;
            end
            ThisLine = fitCutObj.(Lines)(Index);                
        end
        
        function index = pos2ind(fitCutObj,position)
            switch fitCutObj.CurrentLine.Direction
                case 'x'
                    [~,index] =...
                        min(abs(fitCutObj.Data.y-position));
                case 'y'
                    [~,index] =...
                        min(abs(fitCutObj.Data.x-position));                   
                otherwise
                    error('Direction should be either ''x'' or ''y''');                    
            end
        end
        
        %% Destructor
        function delete(fitCutObj)
            % Object Destructor
            for i = 1:length(fitCutObj.XLines)
                delete(fitCutObj.XLines(i));
            end
            for i = 1:length(fitCutObj.YLines)
                delete(fitCutObj.YLines(i));
            end
        end % end of destructor
        
    end
    
    methods (Static)
        function fitCutObj = createFrom3DData(data3D,direction,index)
            % createFrom3dData create a FitCut object using a volume
            % ARPES data. 
            % data3D should be 3D ARPES data. 
            % The direction of the cut can be 'xy', 'yz', or 'xz'
            % Index is the index position of the 2D cut in the 3D data.
            
            % Check Input
            FitARPES.is3DARPESData(data3D);

            % Create fiCutObj
            switch direction
                case 'xy'
                    data.x=data3D.x;
                    data.y=data3D.y;
                    data.value=data3D(:,:,index);
                    data.value=squeeze(data.value);
                    fitCutObj=FitCut(data);
                case 'yz'
                    data.x=data3D.y;
                    data.y=data3D.z;
                    data.value=data3D(index,:,:);
                    data.value=squeeze(data.value);
                    fitCutObj=FitCut(data);
                case 'xz'
                    data.x=data3D.x;
                    data.y=data3D.z;
                    data.value=data3D(:,index,:);
                    data.value=squeeze(data.value);
                    fitCutObj=FitCut(data);
                otherwise
                    errormsg('direction should be either xy, yz or xz')
                    return;
            end
        end % end of fitCutObj
    end
    
end

