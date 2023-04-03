classdef OxArpes_1D_Data
    %OXARPES_1D_DATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name;
        info;

        x_name;
        x_unit;

        x; 
        value; 
    end
    
    methods
        function obj = OxArpes_1D_Data(varargin)
            %OXARPES_1D_DATA Construct an instance of this class
            %   Detailed explanation goes here
            obj.name = '1D scan';
            obj.x = varargin{1};
            obj.value = varargin{2};
        end

        function show(obj)
            h1 = figure('Name',obj.name);
            ha1 = axes('parent',h1);
            
            plot(ha1,obj.x,obj.value);
            xlabel(ha1,[obj.x_name ' (' obj.x_unit ')']);
            title(ha1,obj.name,'interpreter', 'none');
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

