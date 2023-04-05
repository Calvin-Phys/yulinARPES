classdef OxA_RSImage < OxArpes_3D_Data
    %OXA_RSI Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = OxA_RSImage(varargin)
            %OXA_RSI Construct an instance of this class
            %   Detailed explanation goes here
            obj@OxArpes_3D_Data(varargin{:});

            obj.name = 'Real Space Image';
            obj.x_name = 'X position';
            obj.x_unit = 'µm';
            obj.y_name = 'Y position';
            obj.y_unit = 'µm';
            obj.z_name = 'Kinetic Energy';
            obj.z_unit = 'eV';

        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

