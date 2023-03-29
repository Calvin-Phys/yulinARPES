classdef CurrentLineOfFitCut
    % It is IMPORTANT CurrentLineOfFitCut is not a VALUE class (rather than
    % HANDLE class). Because when using
    % currentLineOfFitCutObj.prop = value
    % it will trigger the Pre/PostSet event if it is a value class,
    % while it will not trigger the Pre/PostSet event if it is a handle
    % class.
    properties
        Parent
        Direction
        Index
    end
    properties (Dependent)
        Position
    end
    
    methods
        function currentLineObj = CurrentLineOfFitCut(parent,direction,index)
            switch direction
                case 'x'   
                    currentLineObj.Direction = 'x';
                case 'y'
                    currentLineObj.Direction = 'y';
                otherwise
                    disp('Direction should be either ''x'' or ''y''');            
            end
            currentLineObj.Parent = parent;
            currentLineObj.Index = index;
        end
        function position = get.Position(currentLineObj)
           switch currentLineObj.Direction
                case 'x'   
                    position = ...
                        currentLineObj.Parent.Data.y(currentLineObj.Index);
                case 'y'
                    position = ...
                        currentLineObj.Parent.Data.x(currentLineObj.Index);
                otherwise
                    disp('Direction should be either ''x'' or ''y''');            
           end           
        end
        
    end
    
end

