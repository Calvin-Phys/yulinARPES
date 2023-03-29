classdef FitInfoForIPeak
    %FITINFOFORIPEAK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        AmpThreshold=[]
        SlopeThreshold=[]
        SmoothWidth=[]
        FitWidth=[]
%         center=[]
%         window=[]
%         AUTOZERO=[]
    end
    
    methods 
        function fitInfoObj=getFromIPeak(fitInfoObj,fitLineOfCutObj)
            % get fit information from ipeak
            
            % The interface of ipeak: global variables. HORRIBLE.
            global AmpThreshold SlopeThreshold SmoothWidth
            global FitWidth  
%             global AUTOZERO xx
%             if isempty(xx)
%                 fitInfoObj.xx=fitLineOfCutObj.X;
%             else
%                 fitInfoObj.xx=xx;
%             end
            fitInfoObj.AmpThreshold=AmpThreshold;
            fitInfoObj.SlopeThreshold=SlopeThreshold;
            fitInfoObj.SmoothWidth=SmoothWidth;
            fitInfoObj.FitWidth=FitWidth;
%             fitInfoObj.center=(max(fitInfoObj.xx)+min(fitInfoObj.xx))/2;
%             fitInfoObj.AUTOZERO=AUTOZERO;
%             fitInfoObj.window=max(fitInfoObj.xx)-min(fitInfoObj.xx);
        end % end of getFromIPeak
        
        function initialflag=isInitialized(fitInfoObj)
            % check whether the line has been initialized or not
            names=fieldnames(fitInfoObj);
            n=length(names);
            flags=zeros(1,n);
            % if any field of FitInfo is empty, the object is
            % uninitialized.
            for i = 1:n
                flags(i) = ~isempty(fitInfoObj.(names{i}));
            end
            initialflag = prod(flags);
            
        end
    end
    
end

