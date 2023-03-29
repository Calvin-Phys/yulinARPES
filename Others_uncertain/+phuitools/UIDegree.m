% UIDegree build a panel contains a user interface diagram.
% The user can drag a red dot and get the desirable response.
% obj = UIDegree(parent,...
%               parentFigure,...
%               titleStr,...
%               userWindowButtonMotionFcn,...
%               userWindowButtonUpFcn)
%
% userWindowButtonMotionFcn and userWindowButtonUpFcn should be
% in the form of:
% func=@()userAction(ARGS);
%
% =====================================
% NOTES:
% Be prudent while using anonymous function.
% The args passed to anonymous function will stay invariant as the
% anonymous function was defined.
% Thus, when you neet to pass an object, you may want to use handle class.
% The same trick is often used to set callback functions.
% =====================================
%
% Example:
% -----------
% classdef UIDegreeTest < handle
%     properties
%         figureObj
%         uiDegTheta
%         stateStr
%     end
%     methods
%         function mainObj=UIDegreeTest
%             mainObj.figureObj=figure;
%             VBox = uiextras.VBox('Parent',mainObj.figureObj);
%             func1=@()mainObj.userAction(1);
%             func2=@()mainObj.userAction(2);
%             mainObj.uiDegTheta =...
%                 UIDegree(VBox,mainObj.figureObj,'Theta',func1,func2);
%         end
%         function userAction(mainObj,number)
%             ang=mainObj.uiDegTheta.getDegree;
%             display({ang,number});
%         end
%     end
% end
%
% --------------------------
%
%
% Copy right reserved.
% Han Peng, han.peng@physics.ox.ac.uk

classdef UIDegree <handle
    properties
        parent
        parentFigure
        userWindowButtonMotionFcn
        userWindowButtonUpFcn
        uiAxes
        uiLine
        titleStr
    end
    methods % Create Object
        function obj = UIDegree(parent,...
                                parentFigure,...
                                titleStr,...                                
                                userWindowButtonMotionFcn,...
                                userWindowButtonUpFcn)
            %% Build Layout
            % Build Container
            obj.parent = parent;
            obj.parentFigure = parentFigure;
            obj.userWindowButtonMotionFcn = userWindowButtonMotionFcn;
            obj.userWindowButtonUpFcn = userWindowButtonUpFcn;
            obj.titleStr=titleStr;
            panel = uiextras.Panel(...
                'Parent',           parent,...
                'Title',            titleStr);
            % Build Axes
            obj.uiAxes = axes(...
                'Parent',           panel,...
                'HandleVisibility', 'Off');
            drawCircle(obj.uiAxes,1);
            axis(obj.uiAxes,'equal');
            hold(obj.uiAxes,'on');
            obj.uiLine = line([0,1],[0,0],...
                'Parent',           obj.uiAxes,...
                'Marker',           'o',...
                'MarkerSize',       10,...
                'MarkerEdgeColor',  'r',...
                'MarkerFaceColor',  'r',...
                'Tag',              'uiLine',...
                'ButtonDownFcn', @obj.uiButtonDownFcn);
            hold(obj.uiAxes,'off');
            pause(0.2); % axis off may not function without a pause.
            xlim(obj.uiAxes,[-1.1,1.1]);
            ylim(obj.uiAxes,[-1.1,1.1]);
            title(obj.uiAxes,[obj.titleStr,'=0.00 deg']);
            axis(obj.uiAxes,'off');
        end
    end
    methods
        function deg = getDegree(obj)
            % This function return the degree angle of uiDot in 
            % polar coordinate system.
            
            % NOTES:
%             obj.uiLine=findobj(obj.uiAxes,'Tag','uiLine');
%             % If UIDegree is not a handle class, then the line above is
%             necessary to keep variable obj updated. Otherwise obj will
%             stay the same with that when it is put into anonymous
%             function in:
%             set(obj.uiLine,'ButtonDownFcn', @obj.uiButtonDownFcn);
            uiDotPos = get(obj.uiLine,{'XData','YData'});
            deg =cart2pol(uiDotPos{1}(2),uiDotPos{2}(2));
            deg = deg*180/pi;
        end
        function update(obj,pos)
            % This function update the uiDot position 
            % syntax: obj.update([x,y])
            r=norm(pos);
            if r==0
                r=1;
            end
            pos=pos/r;
            
            % NOTES:
%             obj.uiLine=findobj(obj.uiAxes,'Tag','uiLine');
%             % If UIDegree is not a handle class, then the line above is
%             necessary to keep variable obj updated. Otherwise obj will
%             stay the same with that when it is put into anonymous
%             function in:
%             set(obj.uiLine,'ButtonDownFcn', @obj.uiButtonDownFcn);

            set(obj.uiLine,...
                'XData',            [0,pos(1)],...
                'YData',            [0,pos(2)]);
            title(obj.uiAxes,...
                [obj.titleStr,'=',num2str(obj.getDegree,'%7.2f'),' deg']);
        end
    end
    
    methods % callback functions
        function uiButtonDownFcn(obj,~,~)
            set(obj.parentFigure,...
                'WindowButtonMotionFcn',@obj.userNewWindowButtonMotionFcn,...
                'WindowButtonUpFcn',@obj.userNewWindowButtonUpFcn);
        end
        function userNewWindowButtonMotionFcn(obj,~,~)
            pos = get(obj.uiAxes,'CurrentPoint');
            obj.update([pos(1),pos(4)]);
            obj.userWindowButtonMotionFcn();
        end
        function userNewWindowButtonUpFcn(obj,~,~)
            obj.userWindowButtonUpFcn();
            set(obj.parentFigure,...
                'WindowButtonMotionFcn',[],...
                'WindowButtonUpFcn',[]);            
        end
    end
end
function drawCircle(ax,r)
    % This function draw a circle of radius r in ax.
    theta = 0:0.05:2.1*pi;
    x=r*cos(theta);
    y=r*sin(theta);
    line(x,y,'Parent',ax);
end

