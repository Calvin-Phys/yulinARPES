% uiDegreeTest is a test for class uiDegree

classdef UIDegreeTest < handle
    properties
        figureObj
        uiDegTheta
        stateStr
    end
    methods
        function mainObj=uiDegreeTest
            mainObj.figureObj=figure;
            VBox = uiextras.VBox('Parent',mainObj.figureObj);
            func1=@()mainObj.userAction(1);
            func2=@()mainObj.userAction(2);
            mainObj.uiDegTheta =...
                uiDegree(VBox,mainObj.figureObj,'Theta',func1,func2);
        end
        function userAction(mainObj,number)
            ang=mainObj.uiDegTheta.getDegree;
            display({ang,number});
        end
    end
end
