% MenuCopyObj creates a UIContextMenu in the designated object and returns
% its handle in menuHandle.menu . The UIContextMenu contains a menu called
% 'plot', whose callback copies the target object to a new figure.
%
% obj = MenuCopyObj(parentFigure,targetObj)
%
% targetObj is the object which uses the created MenuCopyObj as 
% UIContextMenu. 
% parentFigure is the targetObj's parent figure.
% obj.menu is the handle of the UIContext menu.
% parentFigure and targetObj are also properties of a MenuCopyObj object.
%
%
% Written by Han Peng, han.peng@physics.ox.ac.uk


classdef MenuCopyObj < handle
    properties
        menu
        parentFigure
        targetObj
    end
    
    methods 
        function obj = MenuCopyObj(parentFigure,targetObj)
            obj.parentFigure = parentFigure;
            obj.targetObj = targetObj;
            obj.menu = uicontextmenu('Parent',parentFigure);
            
            uimenu(...
                'Parent',           obj.menu,...
                'Label',            'Plot',...
                'Callback',         @obj.axisMenuCallback);
            
            set(obj.targetObj,'UiContextMenu',obj.menu);
            
        end
        function axisMenuCallback(obj,varargin)
            h=axes('Parent',figure);
            objElementList=findobj(obj.targetObj);
            for i = 1:length(objElementList)
                if isElegible(objElementList(i))
                    copyobj(objElementList(i),h);
                end
            end
        end
    end
    
end

function flag = isElegible(objElement)
    flag=true;
    if ~isprop(objElement,'XData')
        flag=false;
        return;
    end
    if length(get(objElement,'XData'))<=3
        flag=false;
        return;
    end
end
