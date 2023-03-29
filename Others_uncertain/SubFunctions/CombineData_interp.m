function datacombined = CombineData_interp(data)
% Credit to Rong YANG, Summer, 2013
% Last edited by Han PENG, Feburary, 2017
% It was a long summer.

num = length(data);

%error
for i = 1:num
    if length(size((data{i}.value))) ~= 3
        error('Temporarily, it can only tackle with 3 dimensional data.');
    end
end

zrange = data{1}.z;
for i = 1:num
    if sum(data{i}.z ~= zrange)
        error('data.z is different');
    end
end

%update data.value

for i = 1:num
    
    datac = data{i};
    
    theta_off=0;
    phi_off=0;
    azi_off=0;

    if isfield(datac,'info')
        if isfield(datac.info,'theta')
            if isnumeric(datac.info.theta) && length(datac.info.theta)==1
                 theta_off=theta_off+datac.info.theta;
            end
        end
        if isfield(datac.info,'theta_offset')
            if isnumeric(datac.info.theta_offset) && length(datac.info.theta_offset)==1
                theta_off=theta_off+datac.info.theta_offset;
            end
        end
            
        if isfield(datac.info,'phi')
            if isnumeric(datac.info.phi) && length(datac.info.phi)==1
                phi_off=phi_off+datac.info.phi;
            end
        end
        if isfield(datac.info,'phi_offset')
            if isnumeric(datac.info.phi_offset) && length(datac.info.phi_offset)==1
                phi_off=phi_off+datac.info.phi_offset;
            end
        end
            
       % if isfield(datac.info,'azi')
       %     if isnumeric(datac.info.azi) && length(datac.info.azi)==1
       %         azi_off=azi_off+datac.info.azi;
       %     end
       % end
       % if isfield(datac.info,'azi_offset')
       %     if isnumeric(datac.info.azi_offset) && length(datac.info.azi_offset)==1
       %         azi_off=azi_off+datac.info.azi_offset;
       %     end
       % end
    end
    
    data{i}.x = data{i}.x+theta_off;
    data{i}.y = data{i}.y+phi_off;
end
clearvars datac;

%find the range and resolution of x, y, z

x_all = [];
y_all = [];

x_r_all = [];
y_r_all = [];

y_1_nofirst = data{1}.y;
y_1_nolast = data{1}.y;
y_1_nofirst(1) = [];
y_1_nolast(length(y_1_nolast)) = [];
y_1_r_all = y_1_nofirst-y_1_nolast;
y_r = min(y_1_r_all);

for i = 1:num
    x_all = [x_all, data{i}.x];
    y_all = [y_all, data{i}.y];
    
    x_i_nofirst = data{i}.x;
    x_i_nolast = data{i}.x;
    x_i_nofirst(1) = [];
    x_i_nolast(length(x_i_nolast)) = [];
    x_i_r_all = x_i_nofirst-x_i_nolast;
    x_r_all = [x_r_all, x_i_r_all];
    
    y_i_nofirst = data{i}.y;
    y_i_nolast = data{i}.y;
    y_i_nofirst(1) = [];
    y_i_nolast(length(y_i_nolast)) = [];
    y_i_r_all = y_i_nofirst-y_i_nolast;
    y_r_all = [y_r_all, y_i_r_all];
end

x_min = min(x_all);
x_max = max(x_all);
y_min = min(y_all);
y_max = max(y_all);

x_r = min(x_r_all);
y_r = max(y_r_all);

if (x_max - x_min)/x_r > 500 || x_r <= 0
    datacombined.x = linspace(x_min, x_max, 500);
else
    datacombined.x = x_min:x_r:x_max;
end

if (y_max - y_min)/y_r > 500 || y_r <= 0
    datacombined.y = linspace(y_min, y_max, 500);
else
    datacombined.y = y_min:y_r:y_max;
end

datacombined.z = zrange;

for j = 1:length(zrange)
    for i = 1:num
        [xx, yy] = ndgrid(data{i}.x, data{i}.y);
        value_b = data{i}.value(:, :, j);
        
        value_af(:, :, i) = griddata(xx, yy, value_b, datacombined.x', datacombined.y)';
    end
    datacombined.value(:, :, j) = nanmean(value_af, 3);
end