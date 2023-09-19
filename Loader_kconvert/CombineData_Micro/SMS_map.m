classdef SMS_map < handle
    %SMS_MAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cut_list
        P_array
        P_num
        T_array
        T_num
        CUT_x
        CUT_x_step
        CUT_y
        CUT_y_step
        name
        bkgd
        maps
    end
    
    methods
        function obj = SMS_map(name,bkgd)
            %SMS_MAP Construct an instance of this class
            %   Detailed explanation goes here
            obj.name = name;
            obj.bkgd = evalin('base',bkgd);
        end
        
        function select_cut_list(obj,list_in,tk0,tk1)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here

            obj.cut_list = list_in;
            CUT = evalin('base',list_in{1});
            CUT = CUT.truncate(tk0,tk1,0,100);

            obj.CUT_x = CUT.x;
            obj.CUT_y = CUT.y;

            x = 1:length(obj.CUT_x);
            P = polyfit(x,obj.CUT_x,1);
            obj.CUT_x_step = P(1);


            var_num = length(list_in);

            % get data points
            coord = [];
            break_point = [];
            num_tilt = 1;
            
            for i = 1:var_num
                CUT = evalin('base',list_in{i});
                CUT = CUT.truncate(tk0,tk1,0,100);
            %     fprintf('%5.2f %5.2f \n', CUT.info.phi, CUT.info.theta);
                % theta-P, phi-T
                coord(i,:) = [CUT.info.theta, CUT.info.phi];
                if i~=1 && coord(i,2) - coord(i-1,2) > 3
                    num_tilt = num_tilt + 1;
                    break_point(end+1) = i;
                end
            end
            
            % polar
            PP = reshape(coord(:,1),[],num_tilt);
            PP = mean(PP,2);
            
            x = 1:length(PP);
            P = polyfit(x,PP,1);
            
            P_initial = round( P(1)+P(2) ,1);
            P_final = round( P(1)*length(PP)+P(2) ,1);
            P_step = round( P(1) ,2);

            obj.P_array = P_initial:P_step:P_final;
            obj.P_num = length(obj.P_array);
            
            % tilt
            TT = reshape(coord(:,2),[],num_tilt);
            TT = mean(TT,1);
            
            x = 1:length(TT);
            P = polyfit(x,TT,1);
            
            T_initial = round( P(1)+P(2) ,1);
            T_final = round( P(1)*length(TT)+P(2) ,1);
            T_step = round( P(1) ,2);

            obj.T_array = T_initial:T_step:T_final;
            obj.T_num = length(obj.T_array);
        end

        function direct_combine(obj,tk0,tk1)
            new_bkgd = obj.bkgd.truncate(tk0,tk1,0,100);

            obj.maps = {};
            for i = 1:obj.T_num
                value = zeros(obj.P_num,length(obj.CUT_x),length(obj.CUT_y));
                for j = 1:obj.P_num
                    cut = evalin('base',obj.cut_list{(i-1)*obj.P_num+j});
                    cut = cut.truncate(tk0,tk1,0,100);

                    value(j,:,:) = cut.value./new_bkgd.value;
                end
                map = OxA_MAP(obj.P_array,obj.CUT_x+obj.T_array(i),obj.CUT_y,value);
                obj.maps{i} = map;
                assignin("base",[obj.name '_part' num2str(i)], map);
            end

            % merge maps

            if obj.T_num == 1
                return
            end

            num_total = length(obj.CUT_x);
            num_overlay = round(((max(obj.CUT_x) - min(obj.CUT_x)) - (obj.T_array(2) - obj.T_array(1)))/obj.CUT_x_step);
            num_middle = num_total - 2*num_overlay;

            new_y = linspace(min(obj.CUT_x)+obj.T_array(1),max(obj.CUT_x)+obj.T_array(end), num_total*obj.T_num - num_overlay*(obj.T_num-1));
            new_value = zeros(obj.P_num,num_total*obj.T_num - num_overlay*(obj.T_num-1),length(obj.CUT_y));

            mask = repmat(linspace(0,1,num_overlay),obj.P_num,1,length(obj.CUT_y));
            
            new_value(:,1:num_overlay,:) = obj.maps{1}.value(:,1:num_overlay,:);
            for i = 1:obj.T_num
                new_value(:,num_overlay+(i-1)*(num_total-num_overlay)+1:num_overlay+(i-1)*(num_total-num_overlay)+num_middle,:) = obj.maps{i}.value(:,num_overlay+1:num_overlay+num_middle,:);
            end
            new_value(:,end-num_overlay+1:end,:) = obj.maps{end}.value(:,end-num_overlay+1:end,:);

            for i = 1:(obj.T_num-1)
                new_value(:,i*(num_total-num_overlay)+1:i*(num_total-num_overlay)+num_overlay,:) = obj.maps{i}.value(:,end-num_overlay+1:end,:).*flip(mask,2) + obj.maps{i+1}.value(:,1:num_overlay,:).*mask;
            end

            MAP = OxA_MAP(obj.P_array,new_y,obj.CUT_y,new_value);
            assignin("base",[obj.name '_combined'], MAP);



        end
    
        function k_convert(obj,P0,T0,A0)
            % get data points

            CONST = 0.512316722;

            kk1 = [];
            kk2 = [];
            Eki = min(obj.CUT_y);
            Ekj = max(obj.CUT_y);
            
            tic
            for y_offset = obj.T_array
                % centered at (90,0)
                [ThetaX, ThetaY] = meshgrid(obj.P_array,obj.CUT_x);
                kx = ( cosd(ThetaY).*sind(ThetaX-90) );
                ky = ( cosd(y_offset).*sind(ThetaY) +sind(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );
                kz = ( -sind(y_offset).*sind(ThetaY) +cosd(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );

                % centered at Gamma
                kx_ = cosd(P0-90)*kx - sind(P0-90)*kz;
                ky_ = - sind(P0-90)*sind(T0)*kx + cosd(T0)*ky - cosd(P0-90)*sind(T0)*kz;
                kz_ = sind(P0-90)*cosd(T0)*kx + sind(T0)*ky + cosd(P0-90)*cosd(T0)*kz;

                % rotate azimuth
                kx2 = cosd(A0)*kx_ + sind(A0)*ky_;
                ky2 = -sind(A0)*kx_ + cosd(A0)*ky_;
                
                kk1 = vertcat(kk1,CONST* sqrt(Eki)* [kx2(:), ky2(:), kz_(:)]);
                kk2 = vertcat(kk2,CONST* sqrt(Ekj)* [kx2(:), ky2(:), kz_(:)]);
            
            end
            toc
            
            % plot data points
            figure
            hold on
            scatter3(kk1(:,1),kk1(:,2),kk1(:,3),'r.');
            scatter3(kk2(:,1),kk2(:,2),kk2(:,3),'b.');
            

            Kx_min = min([kk1(:,1);kk2(:,1)]);
            Kx_max = max([kk1(:,1);kk2(:,1)]);
            Ky_min = min([kk1(:,2);kk2(:,2)]);
            Ky_max = max([kk1(:,2);kk2(:,2)]);
        
            kx_axis = linspace(Kx_min,Kx_max, round(1.8*obj.P_num));
            ky_axis = linspace(Ky_min,Ky_max, round(1.4*obj.T_num*length(obj.CUT_x)));
            [KY,KX] = meshgrid(ky_axis,kx_axis);
            scatter(KX(:),KY(:),'.');
            axis equal
            hold off

            %% k_convert
            kmaps = {};
            kmaps_mask = {};

            for i = 1:obj.T_num

                y_offset = obj.T_array(i);

                % centered at (90,0)
                [ThetaX, ThetaY] = meshgrid(obj.P_array,obj.CUT_x);
                kx = ( cosd(ThetaY).*sind(ThetaX-90) );
                ky = ( cosd(y_offset).*sind(ThetaY) +sind(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );
                kz = ( -sind(y_offset).*sind(ThetaY) +cosd(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );

                % centered at Gamma
                kx_ = cosd(P0-90)*kx - sind(P0-90)*kz;
                ky_ = - sind(P0-90)*sind(T0)*kx + cosd(T0)*ky - cosd(P0-90)*sind(T0)*kz;
                kz_ = sind(P0-90)*cosd(T0)*kx + sind(T0)*ky + cosd(P0-90)*cosd(T0)*kz;

                % rotate azimuth
                kx2 = cosd(A0)*kx_ + sind(A0)*ky_;
                ky2 = -sind(A0)*kx_ + cosd(A0)*ky_;
                
                tic

                map = evalin("base",[obj.name '_part' num2str(i) '_s_nor_s_nor_rmbkgd']);
                map = map.Gaussian_smoothen(0.8,0.8);

                value = zeros(length(kx_axis),length(ky_axis),length(obj.CUT_y));
                for j = 1:length(obj.CUT_y)
                    slice = map.value(:,:,j);
                    Eki = obj.CUT_y(j);
                    value(:,:,j) = griddata(0.98*CONST* sqrt(Eki)* kx2', 0.93*CONST* sqrt(Eki)* ky2',slice,KX,KY,'linear');
                end

                kmaps_mask{end+1} = ~isnan(value);

                value(isnan(value)) = 0;
                new_map = OxA_MAP(kx_axis,ky_axis,obj.CUT_y,value);
                kmaps{end+1} = new_map;
                
                assignin("base",[obj.name '_part' num2str(i) '_ksp'], new_map);
                
                toc

            end

            % merge by mask
            for i = 1:(obj.T_num-1)
                overlay_mask = kmaps_mask{i} .* kmaps_mask{i+1};
                slope_mask = overlay_mask;

                for s = 1:size(overlay_mask,1)
                    for t = 1:size(overlay_mask,3)
                        slope_mask(s,:,t) = slope_mask_f(overlay_mask(s,:,t));
                    end
                end
                kmaps_mask_overlay{i} = overlay_mask;
                kmaps_mask_slope{i} = slope_mask;
            end

            new_map_total = OxA_MAP(kx_axis,ky_axis,obj.CUT_y,zeros(length(kx_axis),length(ky_axis),length(obj.CUT_y)));
            for i = 1:obj.T_num
                new_map_total.value = new_map_total.value + kmaps{i}.value;
            end
            for i = 1:(obj.T_num-1)
                new_map_total.value = new_map_total.value - kmaps{i}.value.*kmaps_mask_slope{i} - kmaps{i+1}.value.* (kmaps_mask_overlay{i} - kmaps_mask_slope{i});
            end

            CUT = evalin('base',obj.cut_list{1});
            new_map_total.info = CUT.info;

            new_map_total.x_name = '{\it k}_x';
            new_map_total.x_unit = 'Å^{-1}';
            new_map_total.y_name = '{\it k}_y';
            new_map_total.y_unit = 'Å^{-1}';
            new_map_total.z_name = '{\it E}-{\it E}_F';
            new_map_total.z_unit = 'eV';
            new_map_total.z = new_map_total.z - new_map_total.info.photon_energy + new_map_total.info.workfunction;
            new_map_total.name = [obj.name '_ksp'];



            assignin("base",[obj.name '_combined_ksp'], new_map_total);
            



        end
    end
end

