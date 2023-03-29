function tf=load_Elettra_hdf5(varargin)

% The function load_scienta_general_txt(filename) is designed
% to load the scienta data file into the workspace.
% Input "filename" is a string that contain the full filename
% with its path
%
% The function then loads the file into the workspace with the
% variable name the same as the filename.
% The variable contains the field "info", axis information of
% "x", "y" and "z" depending on the measuring data's dimention
% and the field "value" for the bulk data.
%
% In case bugs are found, please contact the author (Yulin Chen) by
% Email: yulin.chen@gmail.com

% return true if successfully loaded, otherwise return false.

if nargin~=1
%     errordlg('There should be only one input -- the data filename','Wrong argument No.');
    tf=false;
    return
end

[~, ~, ext] = fileparts(varargin{1}); 
if ~strcmpi(ext,'.hdf5')
%     errordlg(['The file "' varargin{1} '" is not a .txt file!'],'Wrong file format');
    tf=false;
    return
end

fid=fopen(varargin{1}); % open data file
info_line=fgetl(fid);
if isempty(strfind(info_line,'‰HDF'))
    tf=false;
    fclose(fid);
    return
end
fclose(fid);

data_file=varargin{1}; % set data file

%=====================function starts=============================
% get infomation from data file
data_info=h5info(data_file);

data.Datasets=data_info.Datasets.Attributes;


% get data info
for i=1:length(data.Datasets)
    if strcmpi(data.Datasets(i).Name,'Sample ID')
        data.info.SampleName=char(data.Datasets(i).Value);
    elseif strcmpi(data.Datasets(i).Name,'Acquisition Type')
        data.info.AcquisitionMode=char(data.Datasets(i).Value);
    elseif strcmpi(data.Datasets(i).Name,'Dim0 Values')
        dim0 = i;
        data.info.EnergyMin=data.Datasets(i).Value(1);
        data.info.EnergyStep=data.Datasets(i).Value(2);
    elseif strcmpi(data.Datasets(i).Name,'Dim1 Values')
        dim1 = i;
        data.info.AngleMin=data.Datasets(i).Value(1);
        data.info.AngleStep=data.Datasets(i).Value(2);
    elseif strcmpi(data.Datasets(i).Name,'Stage Coord (XYZR)')
        data.info.Xpos=data.Datasets(i).Value(1);
        data.info.Ypos=data.Datasets(i).Value(2);
        data.info.Zpos=data.Datasets(i).Value(3);
        data.info.Rpos=data.Datasets(i).Value(4);  % Rpos?
    elseif strcmpi(data.Datasets(i).Name,'Angular Coord')
        data.info.phi=data.Datasets(i).Value(1);
        data.info.theta=data.Datasets(i).Value(2);
    elseif strcmpi(data.Datasets(i).Name,'MCP Voltage')
        data.info.MCPvoltage=data.Datasets(i).Value;
    elseif strcmpi(data.Datasets(i).Name,'Lens Mode')
        data.info.LensMode=char(data.Datasets(i).Value);
    elseif strcmpi(data.Datasets(i).Name,'Ep (eV)')
        data.info.PassEnergy=data.Datasets(i).Value;
    elseif strcmpi(data.Datasets(i).Name,'Dwell Time (s)')
        data.info.StepTime=data.Datasets(i).Value;
    elseif strcmpi(data.Datasets(i).Name,'N of Scans')
        data.info.Nsweeps=data.Datasets(i).Value;
    elseif strcmpi(data.Datasets(i).Name,'Energy Window (eV)')
        % ?
    elseif strcmpi(data.Datasets(i).Name,'Temperature (K)')
        data.info.Tsample=data.Datasets(i).Value(1);    % ?
        data.info.Tcryo=data.Datasets(i).Value(2);      % ?
    elseif strcmpi(data.Datasets(i).Name,'Pressure (mbar)')
        data.info.pressure=[num2str(data.Datasets(i).Value) ' (mbar)'];
    elseif strcmpi(data.Datasets(i).Name,'Ring En (GeV) GAP (mm) Photon (eV)')
        data.info.RingEnergy=data.Datasets(i).Value(1);
        data.info.UndulatorGap=data.Datasets(i).Value(2);
        data.info.PhotonEnergy=data.Datasets(i).Value(3);
    elseif strcmpi(data.Datasets(i).Name,'Ring Current (mA)')
        data.info.RingCurrent1=data.Datasets(i).Value(1);
        data.info.RingCurrent2=data.Datasets(i).Value(2);
    elseif strcmpi(data.Datasets(i).Name,'Date Time Start Stop')
        data.info.StartTime=char(data.Datasets(i).Value(1));
        data.info.StopTime=char(data.Datasets(i).Value(2));
    end
end


% read data 
data.value=h5read(data_file,strcat('/',data_info.Datasets.Name));
if isempty(data.value)
    tf=false;
    return
end
data_size=size(data.value);

% get the axis info which is stored n the column 3/4, 5/6, 7/8
% note the dimension of the data read by Matlab is reversed,
% e.g. m*n*l in data info is actually l*n*m in the array read by matlab.
% ------------------3D data-----------------
if max(size(size(data.value)))==3
    axis_0=data.Datasets(8).Value(1);
    axis_step=data.Datasets(8).Value(2);
    data.x=axis_0:axis_step:axis_0+axis_step*(data_size(1)-1);

    axis_0=data.Datasets(6).Value(1);
    axis_step=data.Datasets(6).Value(2);
    data.y=axis_0:axis_step:axis_0+axis_step*(data_size(2)-1);
    
    axis_0=data.Datasets(4).Value(1);
    axis_step=data.Datasets(4).Value(2);
    data.z=axis_0:axis_step:axis_0+axis_step*(data_size(3)-1);
    
    %--------transpose data dimension to match the beamline convention---
    datanew.x=data.y; datanew.y=data.x; datanew.z=data.z;
    for i=1:size(data.value,3)
        datanew.value(:,:,i)=transpose(data.value(:,:,i));
    end
    data=datanew;
    %--------end of transpose--------------------------------------------
    
    %if the data has one fake dimension (only one value), then remove it.
    data_size=size(data.value);
    if data_size(1)==1
        data.axis=data.x; data.x=data.y; data.y=data.z; data=rmfield(data,'z');
        data.value=reshape(data.value,data_size(2),data_size(3));
    end
    if data_size(2)==1
        data.axis=data.y; data.y=data.z; data=rmfield(data,'z');
        data.value=reshape(data.value,data_size(1),data_size(3));
    end
    if data_size(3)==1
        data.axis=data.z; data=rmfield(data,'z');
        data.value=reshape(data.value,data_size(1),data_size(2));
    end
 %--------------------2D data--------------------    
elseif min(size(data.value))>=2
    axis_0=data.Datasets(dim1).Value(1);
    axis_step=data.Datasets(dim1).Value(2);
    data.x=axis_0:axis_step:axis_0+axis_step*(data_size(1)-1);

    
    axis_0=data.Datasets(dim0).Value(1);
    axis_step=data.Datasets(dim0).Value(2);
    data.y=axis_0:axis_step:axis_0+axis_step*(data_size(2)-1);
    
    %if the data has one fake dimension(only one value), then remove it.
    data_size=size(data.value);
    if data_size(1)==1
        data.axis=data.x; data.x=data.y; data=rmfield(data,'y');
    end
    if data_size(2)==1
        data.axis=data.y;
        data.value=transpose(data.value);
    end
    
else
    axis_0=data.Datasets(4).Value(1);
    axis_step=data.Datasets(4).Value(2);
    data.x=axis_0:axis_step:axis_0+axis_step*(max(data_size)-1);
    %make data 1*n
    data_size=size(data.value);
    if data_size(2)==1
        data.value=transpose(data.value);
    end
end

data.value=double(data.value);
assignin('base',data_info.Datasets.Name,data);
clear axis_0 axis_step data_file data_info data_size data;
tf=true;
%=========================function ends===============================
