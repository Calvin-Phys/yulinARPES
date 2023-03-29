% obj = IPeakWindow(fitCutObj,parentObj)
classdef IPeakWindow < handle
    %IPEAKWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        FitCut
        Parent = []
        Figure
        
        PbPrev
        PbNext        
        PbSavePeaks
        
        PbGoPrev
        PbGoNext
        EditNum
        
        PbCancel
        PbDone
        
        FitCutPanel
    end
    
    methods % GUI building
        function obj = IPeakWindow(fitCutObj,parentObj)
            obj.FitCut = fitCutObj.copyObj;
            obj.FitCut = fitCutObj;
            obj.FitCut.ThisLine.ipeak;
            
            if isobject(parentObj)
                obj.Parent = parentObj;
                set(parentObj,'Visible','off');
            end            
            obj.createUIComponents();
            obj.setCallbacks();
        end
        function createUIComponents(obj)
            W = 440;
            H = 300;
            pos = get(1,'Position');
            figPos(1) = pos(1)+pos(3)+15;
            figPos(2) = pos(2)+pos(4)-H-6;
            figPos(3) = W;
            figPos(4) = H;
            obj.Figure=figure(...
                'Position',         figPos,...
                'Name',             'IPeakWindow',...
                'NumberTitle',      'off',...
                'MenuBar',          'none',...
                'IntegerHandle',    'off',...
                'HandleVisibility', 'off',...
                'Tag',              'IPeakWindow');
            homeHBox = uiextras.HBox(...
                'Parent',           obj.Figure);
            controlPanel = uiextras.Panel(...
                'Parent',           homeHBox,...
                'Padding',          2,...
                'Title',            'Control Panel');
            vBox1 = uiextras.VBox(...
                'Parent',           controlPanel);
            hBox1 = uiextras.HBox(...
                'Parent',           vBox1);
            obj.PbPrev = uicontrol(...
                hBox1,...
                'Style',            'PushButton',...
                'String',           '<',...
                'ToolTipString',    'move to previous spectrum');
            obj.PbSavePeaks = uicontrol(...
                hBox1,...
                'Style',            'PushButton',...
                'String',           'Save Peaks',...
                'ToolTipString',    'Save Peaks');
            obj.PbNext = uicontrol(...
                hBox1,...
                'Style',            'PushButton',...
                'String',           '>',...
                'ToolTipString',    'Move to next spectrum');            
            set(hBox1,'Sizes',[-1,-2,-1]);
            
            hBox2 = uiextras.HBox(...
                'Parent',           vBox1); 
            obj.PbGoPrev = uicontrol(...
                hBox2,...
                'Style',            'PushButton',...
                'String',           '<Go',...
                'ToolTipString',    'Auto find peaks for N spectrums');
            obj.EditNum = uicontrol(...
                hBox2,...
                'Style',            'Edit',...
                'String',           '1',...
                'ToolTipString',    'Go for N spectrums, edit N');
            obj.PbGoNext = uicontrol(...
                hBox2,...
                'Style',            'PushButton',...
                'String',           'Go>',...
                'ToolTipString',    'Auto find peaks for N spectrums');            
            set(hBox2,'Sizes',[-2,-3,-2]);
            uiextras.HBox(...
                'Parent',           vBox1);
            hbox3 = uiextras.HBox(...
                'Parent',           vBox1);
            obj.PbCancel = uicontrol(...
                hbox3,...
                'Style',            'PushButton',...
                'String',           'Cancel');
            obj.PbDone = uicontrol(...
                hbox3,...
                'Style',            'PushButton',...
                'String',           'Done');
            
            set(vBox1,'Sizes',[3 3 1 4]*12);
            
            obj.FitCutPanel = FitARPES.GUI.FitCutPanel(...
                obj.FitCut,homeHBox,obj.Figure);   
            
            set(homeHBox,'Sizes',[140,-1]);
        end
        function setCallbacks(obj)
            set(obj.Figure,...
                'CloseRequestFcn',  @obj.closeRequestFcn);
            set(obj.PbPrev,...
                'Callback',         @obj.pbPrevCallback);
            set(obj.PbNext,...
                'Callback',         @obj.pbNextCallback);
            set(obj.PbSavePeaks,...
                'Callback',         @obj.pbSavePeaksCallback);
            set(obj.PbGoPrev,...
                'Callback',         @obj.pbGoPrevCallback);
            set(obj.PbGoNext,...
                'Callback',         @obj.pbGoNextCallback);
            set(obj.PbCancel,...
                'Callback',         @obj.pbCancelCallback);
            set(obj.PbDone,... 
                'Callback',         @obj.pbDoneCallback);
            addlistener(obj.FitCut,'CurrentLine','PostSet',...
                @obj.ipeak);
            
        end
    end % end of GUI building
    methods % Callbacks
        function pbPrevCallback(obj,~,~)
            inputLine = obj.FitCut.CurrentLine;
            inputLine.Index = ...
                obj.FitCut.CurrentLine.Index-1;
            inputLine = obj.FitCut.validateInputCurrentLine(inputLine);
            obj.FitCut.CurrentLine = inputLine;
%             obj.FitCut.ThisLine.ipeak;
        end
        function pbNextCallback(obj,~,~)   
            inputLine = obj.FitCut.CurrentLine;
            inputLine.Index = ...
                obj.FitCut.CurrentLine.Index+1;
            inputLine = obj.FitCut.validateInputCurrentLine(inputLine);
            obj.FitCut.CurrentLine = inputLine;  
%             obj.FitCut.ThisLine.ipeak;
        end
        function pbSavePeaksCallback(obj,~,~)
%             obj.FitCut.ThisLine.ipeak;
            obj.FitCut.ThisLine.getPeaksFromIPeak;
        end
        function pbGoPrevCallback(obj,~,~)
            n = str2double(get(obj.EditNum,'String'));
%             obj.FitCut.ThisLine.ipeak;
            obj.FitCut.ThisLine.getPeaksFromIPeak;
            for i = 1:n
                % check range
                fitInfo = obj.FitCut.ThisLine.FitInfo;
                inputLine=obj.FitCut.CurrentLine;
                inputLine.Index=inputLine.Index-1;
                [~,flag]=obj.FitCut.validateInputCurrentLine(inputLine);
                if flag == 0
                    break;
                end
                obj.FitCut.CurrentLine = inputLine;
                % set fit info
                obj.FitCut.ThisLine.FitInfo = fitInfo;
                % get peaks
                obj.FitCut.ThisLine.ipeak;
                obj.FitCut.ThisLine.getPeaksFromIPeak;
                drawnow;
            end
        end
        function pbGoNextCallback(obj,~,~)
            n = str2double(get(obj.EditNum,'String'));
%             obj.FitCut.ThisLine.ipeak;
            obj.FitCut.ThisLine.getPeaksFromIPeak;
            for i = 1:n
                % check range
                fitInfo = obj.FitCut.ThisLine.FitInfo;
                inputLine=obj.FitCut.CurrentLine;
                inputLine.Index=inputLine.Index+1;
                [~,flag]=obj.FitCut.validateInputCurrentLine(inputLine);
                if flag == 0
                    break;
                end
                obj.FitCut.CurrentLine = inputLine;
                % set fit info
                obj.FitCut.ThisLine.FitInfo = fitInfo;
                % get peaks
                obj.FitCut.ThisLine.ipeak;
                obj.FitCut.ThisLine.getPeaksFromIPeak;
                drawnow;
            end
        end
        function pbCancelCallback(obj,~,~)     
            close(obj.Figure);
        end
        function pbDoneCallback(obj,~,~)   
            if isobject(obj.Parent)
                copyValue(obj.FitCut,obj.Parent.FitCut);
                % copyValue(oldObj,newObj), Method, @FitCut
            end
            delete(obj.Figure);
        end
        function ipeak(obj,~,~)
            obj.FitCut.ThisLine.ipeak;
        end
        function updatePosition(obj,~,~)
            obj.FitCutPanel.UIThisLine.updatePosition;
        end
        function closeRequestFcn(obj,~,~)
            button = questdlg(...
                'Exit to main fitting panel without saving changes?',...
                'Quit Without Save?','Yes','No','Yes');
            if ~strcmp(button,'Yes')
                return;
            end
            if isobject(obj.Parent)
                set(obj.Parent,'Visibility','on');
            end
            delete(obj.Figure);
        end        
    end
    
end

