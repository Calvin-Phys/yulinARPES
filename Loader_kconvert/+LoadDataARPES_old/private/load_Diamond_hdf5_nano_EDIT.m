function tf=load_Diamond_hdf5_nano_EDIT(varargin)
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

% The data loader is further modified by Han Peng to adapt the big data
% size. Email: han.peng@physics.ox.ac.uk


N = 5; % COMPRESSION RATE. 
% This is a temperary solution. It is a waste of life to further polish it.

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
infodummy = h5info(varargin{1});
if ~strcmpi(infodummy.Groups(1).Name,'/entry1')
% Identify Diamond Data
    tf=false;
    return
end
instrumentName = h5read(varargin{1},'/entry1/instrument/name');
if ~strcmpi(instrumentName,'i05-1')
% Identify Diamond Data i05-1
% The instrument name should be different from i05-1, which is the
% HR-ARPES sub-beamline
    tf=false;
    return
end
%--------------Attributes------------------------
data.info.Energies=h5read(varargin{1},'/entry1/instrument/monochromator/energy');
%---------monochromator-----------
data.info.Exit_slit_size = h5read(varargin{1},'/entry1/instrument/monochromator/exit_slit_size');
%-------------analyser------------------------
data.info.AcquisitionMode = h5read(varargin{1},'/entry1/instrument/analyser/acquisition_mode');
data.info.Cps = h5read(varargin{1},'/entry1/instrument/analyser/cps');
data.info.Entrance_slit_direction = h5read(varargin{1},'/entry1/instrument/analyser/entrance_slit_direction');
data.info.Entrance_slit_setting = h5read(varargin{1},'/entry1/instrument/analyser/entrance_slit_setting');
data.info.Entrance_slit_shape = h5read(varargin{1},'/entry1/instrument/analyser/entrance_slit_shape');
data.info.Entrance_slit_size = h5read(varargin{1},'/entry1/instrument/analyser/entrance_slit_size');
data.info.Lens_mode = h5read(varargin{1},'/entry1/instrument/analyser/lens_mode');
try
data.info.Number_of_cycles = h5read(varargin{1},'/entry1/instrument/analyser/number_of_cycles');
catch
end
data.info.Number_of_frames = h5read(varargin{1},'/entry1/instrument/analyser/number_of_frames');
data.info.PassEnergy = h5read(varargin{1},'/entry1/instrument/analyser/pass_energy');
data.info.Region_origin = h5read(varargin{1},'/entry1/instrument/analyser/region_origin');
data.info.Region_size = h5read(varargin{1},'/entry1/instrument/analyser/region_size');
data.info.Sensor_size = h5read(varargin{1},'/entry1/instrument/analyser/sensor_size');
data.info.Time_per_channel = h5read(varargin{1},'/entry1/instrument/analyser/time_per_channel');
data.info.Ecenter = h5read(varargin{1},'/entry1/instrument/analyser/kinetic_energy_center');
%----------insertion_device---------------
try
data.info.UndulatorGap = h5read(varargin{1},'/entry1/instrument/insertion_device/gap');
catch
end
try
data.info.Polarisation=h5read(varargin{1},'/entry1/instrument/insertion_device/beam/final_polarisation_label');
catch
end
try    
    data.info.Phase_lower = h5read(varargin{1},'/entry1/instrument/insertion_device/phase_lower');
    data.info.Phase_upper = h5read(varargin{1},'/entry1/instrument/insertion_device/phase_upper');
    
catch
end
%----------manipulator--------------------
try
data.info.Xpos = h5read(varargin{1},'/entry1/instrument/manipulator/sax');
data.info.Ypos = h5read(varargin{1},'/entry1/instrument/manipulator/say');
data.info.Zpos = h5read(varargin{1},'/entry1/instrument/manipulator/saz');
data.info.Saazimuth = h5read(varargin{1},'/entry1/instrument/manipulator/saazimuth');
% if max(size(size(data.value)))== 2
%     data.info.theta = h5read(varargin{1},'/entry1/instrument/manipulator/sapolar');
% end
data.info.Sapolar = h5read(varargin{1},'/entry1/instrument/manipulator/sapolar');
data.info.Satilt = h5read(varargin{1},'/entry1/instrument/manipulator/satilt');
catch
end
%---------Sample------------------
data.info.Cryostat_temperature = h5read(varargin{1},'/entry1/sample/cryostat_temperature');
data.info.Heater_percent = h5read(varargin{1},'/entry1/sample/heater_percent');
data.info.Heater_setting = h5read(varargin{1},'/entry1/sample/heater_setting');
data.info.Name = h5read(varargin{1},'/entry1/sample/name');
data.info.Shiled_temperature = h5read(varargin{1},'/entry1/sample/shield_temperature');
data.info.Temperature = h5read(varargin{1},'/entry1/sample/temperature');
data.info.Temperature_demand = h5read(varargin{1},'/entry1/sample/temperature_demand');
%---------User--------------------
data.info.User = h5read(varargin{1},'/entry1/user01/username');

%% ---------------Load Data----------------------
% Need more elegant solution for big data
data_value_info = h5info(varargin{1},'/entry1/analyser/data');
data_size = data_value_info.Dataspace.Size;


%-------------------4D data-------------------
% for now we collapse the energy and momentum of the real space map of each
% cuts
if length(data_size)== 4
   
    start = [1,1,1,1];
    count = [floor((data_size(1)-1)/N+1),floor((data_size(2)-1)/N+1),...
        data_size(3),data_size(4)];
    stride = [N,N,1,1];
    datai = h5info(varargin{1},'/entry1/analyser/'); % Read meta data
    %% Classification of realspace scan type
    % Existed combination: smx-smy, ssx-ssy, smy-smz
    % I guess some unlucky future summer students should consider the
    % additional data types developed from time to time.
    % Best wishes from H.P..
    n = length(datai.Datasets);
    names = cell(n,1);
    for i = 1:n
        names{i} = datai.Datasets(i).Name;
    end
    
    if sum(strcmp(names,'smx'))
        dimension1='smx';
    elseif sum(strcmp(names,'ssx'))
        dimension1='ssx';
    end
    if sum(strcmp(names,'smy'))
        if sum(strcmp(names,'smz'))
            dimension1='smy';
            dimension2='smz';
        else
            dimension2='smy';
        end
    elseif sum(strcmp(names,'ssy'))
        dimension2='ssy';
    end
    data.value = h5read(varargin{1},'/entry1/analyser/data',start,count,stride);
    

    
    %% -------4d data  x-y scan ------------------
    try
        data.value=permute(data.value,[3,4,2,1]);
        temp=h5read(varargin{1},['/entry1/analyser/',dimension1]);
        if abs(temp(1,1)-temp(1,2))>abs(temp(1,1)-temp(2,1))
            data.x=temp(1,:)';
        else
            data.x=temp(:,1);
        end
    catch
    end
    try
        temp=h5read(varargin{1},['/entry1/analyser/',dimension2]);
        if abs(temp(1,1)-temp(1,2))>abs(temp(1,1)-temp(2,1))
            data.y=temp(1,:);
        else
            data.y=temp(:,1)';
        end
    catch
    end
    try
        start = 1;
        count = floor((data_size(2)-1)/N+1);
        stride = N;
        data.k = h5read(varargin{1},'/entry1/analyser/angles',start,count,stride);
    catch
    end
    try
        start = 1;
        count = floor((data_size(1)-1)/N+1);
        stride = N;
        data.z = h5read(varargin{1},'/entry1/analyser/energies',start,count,stride);
    catch
    end
    
    
    
    %%
    % ------------------3D data---------------------
else
    data.value = h5read(varargin{1},'/entry1/analyser/data');
    if max(size(size(data.value)))== 3
        value = zeros(size(data.value,3),size(data.value,2),size(data.value,1));
        for i=1:size(data.value,2)
            value(:,i,:)=squeeze(data.value(:,i,:))';
        end
        data.value=value;
        try
            data.x = h5read(varargin{1},'/entry1/analyser/sapolar');
        catch
        end
        try
            data.y = h5read(varargin{1},'/entry1/analyser/angles');
        catch
        end
        try
            data.z = h5read(varargin{1},'/entry1/analyser/energies');
        catch
        end
        % ------------------2D data---------------------
    else
        data.value=transpose(data.value);
        data.x = h5read(varargin{1},'/entry1/analyser/angles');
        data.y = h5read(varargin{1},'/entry1/analyser/energies');
    end
end




n=length(filename);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(data,'x')
if iscolumn(data.x)
    data.x=data.x';
end
end

if isfield(data,'y')
    if iscolumn(data.y)
        data.y=data.y';
    end
end

if isfield(data,'z')
    if iscolumn(data.z)
        data.z=data.z';
    end
end

if isfield(data,'k')
    if iscolumn(data.k)
        data.k=data.k';
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n
    if filename(i)=='-'
        filename(i)='_';
    end
end

data.value=double(data.value);

data_size=size(data.value);
if ~isfield(data,'x')
data.x=1:data_size(1);
end
if ~isfield(data,'y')
data.y=1:data_size(2);
end
if ~isfield(data,'z')&&length(data_size)==3
data.z=1:data_size(3);
end
if isfield(data,'z')
    [n,m]=size(data.z);
    if ndims(data.z)==2&&(n~=1&&m~=1) %#ok<ISMAT> %if photon energy dependent mearsurement
        try
            data.ztot=data.z;
            data.z=data.ztot(:,1)';
            data.z=data.z-data.z(end);
            data.x=data.info.Energies';
        catch
        end
    end
end


assignin('base',filename,data);
tf = true;


