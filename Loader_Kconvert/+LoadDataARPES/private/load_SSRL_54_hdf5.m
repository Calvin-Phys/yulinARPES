function tf=load_SSRL_54_hdf5(varargin)
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
if ~strcmpi(ext,'.h5')
%     errordlg(['The file "' varargin{1} '" is not a .nxs file!'],'Wrong file format');
    tf=false;
    return
end
%BLname = h5readatt(varargin{1},'/','beamline');

%beamline recognition
%if ~strcmpi(BLname,'BL5-2')
% Identify BL5-2 data
%    tf=false;
%    return
%end

%--------------Attributes------------------------

%----------manipulator--------------------
try
data.info.Xpos = h5readatt(varargin{1},'/endstation','x');
data.info.Ypos = h5readatt(varargin{1},'/endstation','y');
data.info.Zpos = h5readatt(varargin{1},'/endstation','z');
data.info.Saazimuth = h5readatt(varargin{1},'/endstation','a');
data.info.Sapolar = h5readatt(varargin{1},'/endstation','f');
data.info.Satilt = h5readatt(varargin{1},'/endstation','t');
catch
end
%---------Sample------------------
try
data.info.PhotonEnergy = h5readatt(varargin{1},'/beamline','photon_energy'); 
data.info.Temperature = h5readatt(varargin{1},'/endstation','sample_stage_temperature');
data.info.Cold_head_temperature = h5readatt(varargin{1},'/endstation','cold_head_temperature');
%data.info.Shield_temperature = h5readatt(varargin{1},'/Endstation','radiation_shield_temperature');
%data.info.Cryostat_temperature = h5readatt(varargin{1},'/Endstation','cryo_temperature');
%data.info.Heater_range_sample = h5readatt(varargin{1},'/Endstation','heater_range_sample');
%data.info.Heater_sample = h5readatt(varargin{1},'/Endstation','heater_sample');
%data.info.Heater_range_cryo = h5readatt(varargin{1},'/Endstation','heater_range_cryo');
%data.info.Heater_cryo = h5readatt(varargin{1},'/Endstation','heater_cryo');
catch
end
%---------resolution--------------------
try
%data.info.Resolution_beamline = h5readatt(varargin{1},'/resolution','resolution_beamline');
%data.info.Resolution_analyzer = h5readatt(varargin{1},'/resolution','resolution_analyzer');
%data.info.Resolution_total = h5readatt(varargin{1},'/resolution','resolution_total');
%data.info.Beam_size_v = h5readatt(varargin{1},'/resolution','beam_size_v');
%data.info.Beam_size_h = h5readatt(varargin{1},'/resolution','beam_size_h');
catch
end

% ---------------Load Data----------------------
data_dims = h5readatt(varargin{1},'/data','data_dims');

%-------------------2D data-------------------
if data_dims == 2;
    data_counts = h5read(varargin{1},'/data/counts');
    data_exposure = h5read(varargin{1},'/data/exposure');
    data.value = data_counts./data_exposure;
%    data.value = transpose(data.value);
    data.value = double(data.value);
    data_x_offset = h5readatt(varargin{1},'/data/axis1','offset');
    data_x_delta = h5readatt(varargin{1},'/data/axis1','delta');
    data_y_offset = h5readatt(varargin{1},'/data/axis0','offset');
    data_y_delta = h5readatt(varargin{1},'/data/axis0','delta');
        data.x = zeros(size(data.value,1),1);
        data.y = zeros(size(data.value,2),1);
        for i=1:size(data.value,1)
            data.x(i) = data_x_offset + data_x_delta*(i-1);
        end
        
        for i=1:size(data.value,2)
            data.y(i) = data_y_offset + data_y_delta*(i-1);
        end
end
    

%-------------------3D data-------------------
if data_dims == 3;
    data_counts = h5read(varargin{1},'/data/counts');
    data_exposure = h5read(varargin{1},'/data/exposure');
    data.value = data_counts./data_exposure;
   % data.value = data_counts;
    data.value = double(data.value);
    data.value = permute(data.value,[3 2 1]);
    data_x_offset = h5readatt(varargin{1},'/data/axis0','offset');
    data_x_delta = h5readatt(varargin{1},'/data/axis0','delta');
    data_y_offset = h5readatt(varargin{1},'/data/axis1','offset');
    data_y_delta = h5readatt(varargin{1},'/data/axis1','delta');
    data_z_offset = h5readatt(varargin{1},'/data/axis2','offset');
    data_z_delta = h5readatt(varargin{1},'/data/axis2','delta');
        data.x = zeros(size(data.value,1),1);
        data.y = zeros(size(data.value,2),1);
        data.z = zeros(size(data.value,3),1);
        for i=1:size(data.value,1)
            data.x(i) = data_x_offset + data_x_delta*(i-1);
        end
        
        for i=1:size(data.value,2)
            data.y(i) = data_y_offset + data_y_delta*(i-1);
        end
        
        for i=1:size(data.value,3)
            data.z(i) = data_z_offset + data_z_delta*(i-1);
        end
end

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

n=length(filename);

for i=1:n
    if filename(i)=='-';
        filename(i)='_';
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%

assignin('base',filename,data);
tf = true;









