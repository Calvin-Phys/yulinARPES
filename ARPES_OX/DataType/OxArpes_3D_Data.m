classdef OxArpes_3D_Data
    %OXARPES_3D_DATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name;
        info;

        x_name;
        x_unit;
        y_name;
        y_unit;
        z_name;
        z_unit;

        x; % deflector angle - Theta X [deg]
        y; % angle - Theta Y [deg]
        z; % kinetic energy - Energy [eV]
        value; % data
    end
    
    methods
        function obj = OxArpes_3D_Data(varargin)
            if nargin == 4
                obj.x = varargin{1};
                obj.y = varargin{2};
                obj.z = varargin{3};
                obj.value = varargin{4};
            elseif nargin == 1
                obj.x = varargin{1}.x;
                obj.y = varargin{1}.y;
                obj.z = varargin{1}.z;
                obj.value = varargin{1}.value;
            end
        end

        function show(obj)

            UI = OxArpes_DataViewer(obj);

        end

        function obj = set_contrast(obj)
            n_data = sort(obj.value(:));
            upbound = n_data(round(0.995*length(n_data)));
            obj.value(obj.value>upbound) = upbound;
        end
        
        function SDATA = Gaussian_smoothen(obj,sig_x,sig_y)

            % sigma - standard deviation
            rad_x = ceil(3.5*sig_x);
            rad_y = ceil(3.5*sig_y);
            x = -rad_x : rad_x;
            y = -rad_y : rad_y;
            [Y,X] = meshgrid(y,x);
            R = (X/sig_x).^2 + (Y/sig_y).^2;
            
            G = exp(-R/2);
            % normalize gaussian filter
            S = sum(G,'all');
            G = G./S;

            SDATA = obj;
            SDATA.name = [obj.name ' smooth'];
            
            for i = 1:size(obj.value,1)
                ma = squeeze(obj.value(i,:,:));
                w1 = rad_x;
                w2 = rad_y;
                L = size(ma,1); % y
                J = size(ma,2); % z
                
                map = zeros(L+2*w1, J+2*w2);
                map(1+w1:L+w1, 1+w2:J+w2) = ma;
    
                map(1:w1,:) = flip(map(1+w1:2*w1,:),1);
                map(w1+L+1:L+2*w1,:) = flip(map(L+1:L+w1,:),1);
                map(:,1:w2) = flip(map(:,1+w2:2*w2),2);
                map(:,w2+J+1:J+2*w2) = flip(map(:,J+1:J+w2),2);
    
                map = conv2(map,G,'same');

                SDATA.value(i,:,:) = map(1+w1:L+w1,1+w2:J+w2);
            end

            

        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

