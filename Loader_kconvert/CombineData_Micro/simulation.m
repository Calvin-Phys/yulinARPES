function simulation()
    name = 'SM_';
    P_initial = 50;
    P_step = 0.5;
    P_final = 90;
    P_array = P_initial:P_step:P_final;

    T_inital = 0;
    T_step = 13.5;
    T_final = 13.5;
    T_array = T_inital:T_step:T_final;

    CUT_x = -7.296:0.1216:8.2688;
    CUT_y = 68.4:0.01:71.32;

    P0 = 90;
    T0 = 6;
    A0 = -4;

    CONST = 0.512316722;


    EE = {};
    
    tic
    for y_offset = T_array
        % centered at (90,0)
        [ThetaX, ThetaY] = meshgrid(P_array,CUT_x);
        ux = ( cosd(ThetaY).*sind(ThetaX-90) );
        uy = ( cosd(y_offset).*sind(ThetaY) +sind(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );
        uz = ( -sind(y_offset).*sind(ThetaY) +cosd(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );

        % centered at Gamma
%         gux = ( cosd(T0).*sind(P0-90) );
%         guy = ( sind(T0) );
%         guz = ( cosd(T0).*cosd(P0-90) );

        vx = ux *cosd(P0-90) - uz *sind(P0-90);
        vy = - sind(P0-90)*sind(T0)*ux + cosd(T0)*uy - cosd(P0-90)*sind(T0)*uz;

        % rotate azimuth
        vx2 = cosd(A0)*vx + sind(A0)*vy;
        vy2 = -sind(A0)*vx + cosd(A0)*vy;

        value = zeros(length(P_array),length(CUT_x),length(CUT_y));

        for j = 1:length(CUT_y)

            value(:,:,j) = ( mod(CONST* sqrt(CUT_y(j))*vx2,0.44) < 0.05 )';
            value(:,:,j) = value(:,:,j) + ( mod(CONST* sqrt(CUT_y(j))*vy2,0.77) < 0.05 )';

        end

        EE{end+1} = value;
    
    end

    ind = 1;
    for Ti = 1:length(T_array)
        for Pi = 1:length(P_array)
            cut.x = CUT_x;
            cut.y = CUT_y;
            cut.value = squeeze(EE{Ti}(Pi,:,:));

            CUT = OxA_CUT(cut);
            CUT.info.theta = P_array(Pi);
            CUT.info.phi = T_array(Ti);

            assignin('base',[name, sprintf('%03.0f', ind)], CUT);
            ind = ind + 1;
        end
    end


    toc



end