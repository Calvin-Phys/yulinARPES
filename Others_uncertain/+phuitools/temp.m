classdef temp < handle
    properties (SetObservable)
        testprop=phuitools.temptest(1);
    end
    methods
        function obj=temp()
            addlistener(obj,'testprop','PostSet',@obj.showEvent);            
        end
        function showEvent(obj,~,~)
            disp(obj.testprop.testdata);
        end
    end
end
    