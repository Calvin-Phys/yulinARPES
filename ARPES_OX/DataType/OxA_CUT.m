classdef OxA_CUT < OxArpes_2D_Data
    % OxA_CUT: A class for handling 2D ARPES data - CUT.
    % This class inherits from the OxArpes_2D_Data class and adds methods
    % for processing ARPES data, such as converting to k-space, smoothing,
    % and calculating second derivatives and curvature.
    
    properties
    end
    
    methods
        function obj = OxA_CUT(varargin)
            % OxA_CUT: Class constructor.
            % Initializes the properties of the class with default values.
            obj@OxArpes_2D_Data(varargin{:});

            obj.name = 'CUT';
            obj.x_name = 'Theta Y';
            obj.x_unit = 'deg';
            obj.y_name = 'Kinetic Energy';
            obj.y_unit = 'eV';

            obj.info.thetay_offset = 0;
            obj.info.photon_energy = 21.2;
            obj.info.workfunction = 4.5;
        end

        function KCUT = kconvert(obj)
            % kconvert: Converts the theta values of ARPES data to k-space.
            % Uses a simple formula to convert the theta values to k-space.
            % Returns a new OxA_CUT object with k-space data.

            % electron mass = 9.1093837 × 10-31 kilograms
            % hbar = 6.582119569...×10−16 eV⋅s
            % k (A-1) = CONST * sqrt(Ek (eV)) * sin(theta)
            CONST = 0.512316722;

            theta_offset = obj.x - obj.info.thetay_offset;

            theta_max = max(theta_offset);
            theta_min = min(theta_offset);
            energy_min = min(obj.y);
            
            
            k_max = CONST * sqrt(energy_min) * sind(theta_max);
            k_min = CONST * sqrt(energy_min) * sind(theta_min);
            
            kn = length(theta_offset);
            kx = linspace(k_min,k_max,kn);

            data_new = zeros(size(obj.value));
            for i = 1:length(obj.y)
                theta_new = asind(kx/CONST./sqrt(obj.y(i)));
                data_new(:,i) = interp1(theta_offset,obj.value(:,i),theta_new,'pchip');
            end

            be = obj.y - (obj.info.photon_energy - obj.info.workfunction);
            KCUT = OxA_CUT(kx,be,data_new);
            KCUT.x_name = '{\it k}_y';
            KCUT.x_unit = 'Å^{-1}';
            KCUT.y_name = '{\it E}-{\it E}_F';
            KCUT.y_unit = 'eV';
            KCUT.name = [obj.name '_ksp'];
            KCUT.info = obj.info;
        end
        
        function SCUT = Gaussian_smoothen(obj,sig_x,sig_y)
            % Gaussian_smoothen: Smoothens the ARPES data using a Gaussian filter.
            % Applies a Gaussian filter with specified standard deviations
            % sig_x and sig_y to smooth the data. Returns a new OxA_CUT object
            % with smoothed data.
            
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
            
            ma = obj.value;
            w1 = rad_x;
            w2 = rad_y;
            L = size(ma,1); % x
            J = size(ma,2); % z
            
            map = zeros(L+2*w1, J+2*w2);
            map(1+w1:L+w1, 1+w2:J+w2) = ma;

            map(1:w1,:) = flip(map(1+w1:2*w1,:),1);
            map(w1+L+1:L+2*w1,:) = flip(map(L+1:L+w1,:),1);
            map(:,1:w2) = flip(map(:,1+w2:2*w2),2);
            map(:,w2+J+1:J+2*w2) = flip(map(:,J+1:J+w2),2);
            
%             meshc(map);

            map = conv2(map,G,'same');

            SCUT = obj;
            SCUT.value = map(1+w1:L+w1,1+w2:J+w2);
            SCUT.name = [obj.name ' smooth'];

        end

        function [D2x_CUT,D2y_CUT] = second_derivative(obj,sig_x,sig_y)
            % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            % Gaussian Smooth 
            
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
            
            ma = obj.value;
            w1 = rad_x;
            w2 = rad_y;
            L = size(ma,1); % x
            J = size(ma,2); % z
            
            map = zeros(L+2*w1, J+2*w2);
            map(1+w1:L+w1, 1+w2:J+w2) = ma;

            map(1:w1,:) = flip(map(1+w1:2*w1,:),1);
            map(w1+L+1:L+2*w1,:) = flip(map(L+1:L+w1,:),1);
            map(:,1:w2) = flip(map(:,1+w2:2*w2),2);
            map(:,w2+J+1:J+2*w2) = flip(map(:,J+1:J+w2),2);
            
%             meshc(map);

            map = conv2(map,G,'same');
            
            % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            % Second Derivative
            
            [Fu,Fv] = gradient(map); % Dy Dx
            [Fuu,~] = gradient(Fu);
            [~,Fvv] = gradient(Fv);
            
            D2y = -Fuu;
            D2x = -Fvv;
    
            D2x_CUT = obj;
            D2x_CUT.name = [obj.name ' sd-x'];
            D2x_CUT.value = D2x(1+w1:L+w1,1+w2:J+w2);
            
            D2y_CUT = obj;
            D2y_CUT.name = [obj.name ' sd-y'];
            D2y_CUT.value = D2y(1+w1:L+w1,1+w2:J+w2);
        end

        function [D2x_CUT,D2y_CUT] = curvature(obj,sig_x,sig_y,C1,C2)
                        % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            % Gaussian Smooth 
            
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
            
            ma = obj.value;
            w1 = rad_x;
            w2 = rad_y;
            L = size(ma,1); % x
            J = size(ma,2); % z
            
            map = zeros(L+2*w1, J+2*w2);
            map(1+w1:L+w1, 1+w2:J+w2) = ma;

            map(1:w1,:) = flip(map(1+w1:2*w1,:),1);
            map(w1+L+1:L+2*w1,:) = flip(map(L+1:L+w1,:),1);
            map(:,1:w2) = flip(map(:,1+w2:2*w2),2);
            map(:,w2+J+1:J+2*w2) = flip(map(:,J+1:J+w2),2);
            
%             meshc(map);

            map = conv2(map,G,'same');
            
            % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            % Second Derivative
            
            [Fu,Fv] = gradient(map); % Dy Dx
            [Fuu,~] = gradient(Fu);
            [~,Fvv] = gradient(Fv);
            
            A1 = max(Fu.^2,[],"all");
            A2 = max(Fv.^2,[],"all");

            D2y = -Fuu./(C1*A1+Fu.^2).^(3/2);
            D2x = -Fvv./(C2*A2+Fv.^2).^(3/2);
    
            D2y(D2y<0) = 0;
            D2x(D2x<0) = 0;
            
            D2x_CUT = obj;
            D2x_CUT.name = [obj.name ' sd-x'];
            D2x_CUT.value = D2x(1+w1:L+w1,1+w2:J+w2);
            
            D2y_CUT = obj;
            D2y_CUT.name = [obj.name ' sd-y'];
            D2y_CUT.value = D2y(1+w1:L+w1,1+w2:J+w2);
        end

    end
end

