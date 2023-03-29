function tf=load_Diamond_hdf5_xmas(varargin)
% The function load_scienta_general_txt(filepath) is designed
% to load the scienta data file into the workspace.
% Input varargin{1} is a string that contain the full filename
% with its path
%
% The function then loads the file into the workspace with the
% variable name the same as the filename.
% The variable contains the field "info", axis information of
% "x", "y" and "z" depending on the measuring data's dimention
% and the field "value" for the bulk data.
%
% In case bugs are found, please contact the author (Cheng Chen) by
% Email: cheng514.ustc@gmail.com

% return true if successfully loaded, otherwise return false.

if nargin~=1
%     errordlg('There should be only one input -- the data varargin{1}','Wrong argument No.');
    tf=false;
    return
end

[~, filename, ext] = fileparts(varargin{1}); 
if ~strcmpi(ext,'.nxs')
%     errordlg(['The file "' varargin{1} '" is not a .nxs file!'],'Wrong file format');
    tf=false;
    return
end


% ---------------Load Data----------------------
data.value = h5read(varargin{1},'/entry1/analyser/data');
title = h5read(varargin{1},'/entry1/title');
try
    data.value = double(h5read(file_path,'/entry1/analyser/data'));
catch

end

photon_energy = h5read(file_path,'/entry1/instrument/monochromator/energy');
pass_energy = h5read(file_path,'/entry1/instrument/analyser/pass_energy');
if pass_energy == 50
    workfunction = 4.4979E-6 *photon_energy.^2 + 1.49105E-3 *photon_energy + 4.40416;
elseif pass_energy == 20
    workfunction = 5.77602E-6 *photon_energy.^2 + 1.23949E-3 *photon_energy + 4.4144;
elseif pass_energy == 10
    workfunction = 5.77602E-6 *photon_energy.^2 + 1.23949E-3 *photon_energy + 4.4144;
else
    workfunction = 4.5;
end

% ------------------3D data---------------------
if ndims(data.value)== 3
    data.value = permute(data.value,[3,2,1]);
    if contains(title,'scan deflector_x')
        data.x = h5read(varargin{1},'/entry1/analyser/deflector_x');
        data.y = h5read(varargin{1},'/entry1/analyser/angles');
        data.z = mean(h5read(varargin{1},'/entry1/analyser/energies'),2);
    elseif contains(title,'scan pathgroup')
        data.x = h5read(varargin{1},'/entry1/analyser/sapolar');
        data.y = h5read(varargin{1},'/entry1/analyser/angles');
        data.z = h5read(varargin{1},'/entry1/analyser/energies');
    elseif contains(title,'scan scan_group')
        data.x = h5read(varargin{1},'/entry1/analyser/sapolar');
        data.y = h5read(varargin{1},'/entry1/analyser/angles');
        data.z = mean(h5read(varargin{1},'/entry1/analyser/energies'),2);
    elseif contains(title,'scan energy_group')
        data.value = flip(data.value,1);
        data.x = flip(h5read(varargin{1},'/entry1/analyser/value'));
        data.y = h5read(varargin{1},'/entry1/analyser/angles');

        ZZ = h5read(varargin{1},'/entry1/analyser/energies');
        HHVV = repmat(photon_energy',size(ZZ,1),1);
        WW = repmat(workfunction',size(ZZ,1),1);
        data.z = mean(ZZ - (HHVV - WW),2);
    elseif contains(title,'scan energy') && ~contains(title,'scan energy_group')
        data.value = flip(data.value,1);
        data.x = flip(h5read(varargin{1},'/entry1/analyser/energy'));
        data.y = h5read(varargin{1},'/entry1/analyser/angles');

        ZZ = h5read(varargin{1},'/entry1/analyser/energies');
        HHVV = repmat(photon_energy',size(ZZ,1),1);
        WW = repmat(workfunction',size(ZZ,1),1);
        data.z = mean(ZZ - (HHVV - WW),2);

    end

    % conversion
    data.x = data.x';
    data.y = data.y';
    data.z = data.z';


% ------------------2D data---------------------
elseif ndims(data.value)== 2
    data.value = transpose(data.value);
    data.x = h5read(varargin{1},'/entry1/analyser/angles');
    data.y = h5read(varargin{1},'/entry1/analyser/energies');

    % conversion
    data.x = data.x';
    data.y = data.y';
else
    data = [];
end   


%--------------Attributes------------------------
%-------------analyser------------------------
% data.info.AcquisitionMode = h5read(varargin{1},'/entry1/instrument/analyser/acquisition_mode');
% data.info.Cps = h5read(varargin{1},'/entry1/instrument/analyser/cps');
% data.info.Entrance_slit_direction = h5read(varargin{1},'/entry1/instrument/analyser/entrance_slit_direction');
% data.info.Entrance_slit_setting = h5read(varargin{1},'/entry1/instrument/analyser/entrance_slit_setting');
% data.info.Entrance_slit_shape = h5read(varargin{1},'/entry1/instrument/analyser/entrance_slit_shape');
% data.info.Entrance_slit_size = h5read(varargin{1},'/entry1/instrument/analyser/entrance_slit_size');
% data.info.Lens_mode = h5read(varargin{1},'/entry1/instrument/analyser/lens_mode');
% data.info.Number_of_cycles = h5read(varargin{1},'/entry1/instrument/analyser/number_of_cycles');
% data.info.Number_of_frames = h5read(varargin{1},'/entry1/instrument/analyser/number_of_frames');
% data.info.PassEnergy = h5read(varargin{1},'/entry1/instrument/analyser/pass_energy');
% data.info.Region_origin = h5read(varargin{1},'/entry1/instrument/analyser/region_origin');
% data.info.Region_size = h5read(varargin{1},'/entry1/instrument/analyser/region_size');
% data.info.Sensor_size = h5read(varargin{1},'/entry1/instrument/analyser/sensor_size');
% data.info.Time_per_channel = h5read(varargin{1},'/entry1/instrument/analyser/time_per_channel');
% %----------insertion_device---------------
% data.info.UndulatorGap = h5read(varargin{1},'/entry1/instrument/insertion_device/gap');
% try    
%     data.info.Phase_lower = h5read(varargin{1},'/entry1/instrument/insertion_device/phase_lower');
%     data.info.Phase_upper = h5read(varargin{1},'/entry1/instrument/insertion_device/phase_upper');
% catch
% end
% %----------manipulator--------------------
% data.info.Xpos = h5read(varargin{1},'/entry1/instrument/manipulator/sax');
% data.info.Ypos = h5read(varargin{1},'/entry1/instrument/manipulator/say');
% data.info.Zpos = h5read(varargin{1},'/entry1/instrument/manipulator/saz');
% data.info.Saazimuth = h5read(varargin{1},'/entry1/instrument/manipulator/saazimuth');
% if max(size(size(data.value)))== 2
%     data.info.theta = h5read(varargin{1},'/entry1/instrument/manipulator/sapolar');
% end
% data.info.Satilt = h5read(varargin{1},'/entry1/instrument/manipulator/satilt');
% %---------Sample------------------
% data.info.Cryostat_temperature = h5read(varargin{1},'/entry1/sample/cryostat_temperature');
% data.info.Heater_percent = h5read(varargin{1},'/entry1/sample/heater_percent');
% data.info.Heater_setting = h5read(varargin{1},'/entry1/sample/heater_setting');
% data.info.Name = h5read(varargin{1},'/entry1/sample/name');
% data.info.Shiled_temperature = h5read(varargin{1},'/entry1/sample/shield_temperature');
% data.info.Temperature = h5read(varargin{1},'/entry1/sample/temperature');
% data.info.Temperature_demand = h5read(varargin{1},'/entry1/sample/temperature_demand');
% %---------User--------------------
% data.info.User = h5read(varargin{1},'/entry1/user01/username');

n=length(filename);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Adjust data reading
% if isfield(data,'x')
% if iscolumn(data.x)
%     data.x=data.x';
% end
% end
% 
% if isfield(data,'y')
%     if iscolumn(data.y)
%         data.y=data.y';
%     end
% end
% 
% if isfield(data,'z')
%     if iscolumn(data.z)
%         data.z=data.z';
%     end
% end
% 
% data_size=size(data.value);
% if ~isfield(data,'x')
% data.x=1:data_size(1);
% end
% if ~isfield(data,'y')
% data.y=1:data_size(2);
% end
% if ~isfield(data,'z') && length(data.value)==3
% data.z=1:data_size(3);
% end
% if length(size(data.value))==3 && size(data.z,1)~=1
%     data.ztot=data.z;
% %     data.x=data.ztot(1,:);
%     data.z=data.ztot(:,1)';
% end
%%

for i=1:n
    if filename(i)=='-'
        filename(i)='_';
    end
end

data.value=double(data.value);

assignin('base',filename,data);
tf = true;


end 