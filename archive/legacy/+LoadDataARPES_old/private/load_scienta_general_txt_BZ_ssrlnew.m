function tf=load_scienta_general_txt(varargin)

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
    errordlg('There should be only one input -- the data filename','Wrong argument No.');
    tf=false;
    return
end

[~, file_name, ext] = fileparts(varargin{1}); 
if ~strcmp(ext,'.txt')
%     errordlg(['The file "' varargin{1} '" is not a .txt file!'],'Wrong file format');
    tf=false;
    return
end

fid=fopen(varargin{1}); % open data file

% get file modified date for auto loading
listing=dir(varargin{1});
data.info.FileModifiedDate=listing.date;

%--------------gathering data information & scale---------------------
data.header=fgetl(fid);   % start getting data.header
if ~strncmpi(data.header,'[Info]',6)
    tf=false;
    return
end
info_line=fgetl(fid);
scale1=[];scale2=[];scale3=[];  %initialize all three scales, and for later judgement
location='';

while ~strncmp(info_line,'nonli',5)
    if ~strncmp(info_line,'Dimension',9)    %as Dimension info is long, filter it out
        data.header=char(data.header,info_line);
    end
    %----------get scale info---------------
    if strncmp(info_line, 'Location=', 9)
        location=info_line(10:end);
    elseif strncmp(info_line, 'Dimension 1 scale=',18)
        % dimension 1 is energy which in terms of Yulin's def, should be
        % data.z in 3_d case and data.y in 2_d case
        scale1=sscanf(info_line(19:end),'%f');
        data.x=scale1';  % first 1D, if 2D or 3D adjust as below
    elseif strncmp(info_line, 'Dimension 2 scale=',18)
        % dimension 2 is angle -> data.x (2D) and data.y (3D)
        data.y=data.x;
        scale2=sscanf(info_line(19:end),'%f');
        data.x=scale2';  % first 2D, if 3D adjust as below
    elseif strncmp(info_line, 'Dimension 3 scale=',18)
        % if there is a dimension 3, change dim1 and dim2's def above
        data.z=data.y;
        data.y=data.x;
        scale3=sscanf(info_line(19:end),'%f');
        data.x=scale3';    
    %----------end of getting scale info & scale-----
    %----------get header info-----------------------
    elseif strncmp(info_line, 'Sample Stage Temperature=',25)
        data.info.SampleStageTemperature=sscanf(info_line(26:end),'%f');
    elseif strncmp(info_line, 'Sample Temperature Estimate=',28)
        data.info.SampleTemperatureEstimate=sscanf(info_line(29:end),'%f');    
    elseif strncmp(info_line, 'Excitation Energy=',18)
        data.info.PhotonEnergy=sscanf(info_line(19:end),'%f');
    elseif strncmp(info_line, 'Pass Energy=',12)
        data.info.PassEnergy=sscanf(info_line(13:end),'%f');
    elseif strncmp(info_line, 'Low Energy=',11)
        data.info.LowEnergy=sscanf(info_line(12:end),'%f');
    elseif strncmp(info_line, 'High Energy=',12)
        data.info.HighEnergy=sscanf(info_line(13:end),'%f');
    elseif strncmp(info_line, 'Energy Step=',12)
        data.info.EnergyStep=sscanf(info_line(13:end),'%f');
    elseif strncmp(info_line, 'Step Time=',10)
        data.info.StepTime=sscanf(info_line(11:end),'%f');
    elseif strncmp(info_line, 'Detector First X-Channel=', 25)
        data.info.FirstXChannel=sscanf(info_line(26:end),'%d');
    elseif strncmp(info_line, 'Detector Last X-Channel=', 24)
        data.info.LastXChannel=sscanf(info_line(25:end),'%d');
    elseif strncmp(info_line, 'Detector First Y-Channel=', 25)
        data.info.FirstYChannel=sscanf(info_line(26:end),'%d');
    elseif strncmp(info_line, 'Detector Last Y-Channel=', 24)
        data.info.LastYChannel=sscanf(info_line(25:end),'%d');
    elseif strncmp(info_line, 'Number of Slices=', 17)
        data.info.NSlices=sscanf(info_line(18:end),'%d');
    elseif strncmp(info_line, 'Number of Sweeps=', 17)
        data.info.Nsweeps=sscanf(info_line(18:end),'%d');
    elseif strncmp(info_line, 'Comments=', 9)
        data.info.Comments=info_line(10:end);
    elseif strncmp(info_line, 'theta=', 6)
        data.info.theta=sscanf(info_line(7:end),'%f');
    elseif strncmp(info_line, 'phi=', 4)
        data.info.phi=sscanf(info_line(5:end),'%f');
    elseif strncmp(info_line, 'azi=', 4)
        data.info.azi=sscanf(info_line(5:end),'%f');
    elseif strncmp(info_line, 'T=', 2)
        if strncmpi(location,'SSRL',4)
            data.info.theta=sscanf(info_line(3:end),'%f');
        else
            data.info.Tsample=info_line(3:end);
        end
    elseif strncmp(info_line, 'F=', 2)
        if strncmpi(location,'SSRL',4)
            data.info.phi=sscanf(info_line(3:end),'%f');
        end
    elseif strncmp(info_line, 'epu=', 4)
        data.info.Polarization=info_line(5:end);
        if strncmpi(location,'SSRL',4)
            epu=str2double(data.info.Polarization);
            if abs(epu)<0.05
                data.info.Polarization='LH';
            elseif abs(epu-0.5)<0.05
                data.info.Polarization='LV';                    
            elseif abs(epu-0.25)<0.05
                data.info.Polarization='CR';
            elseif abs(epu+0.25)<0.05
                data.info.Polarization='CL';
            end
        end
    elseif strncmp(info_line, 'Tflip=', 6)
        data.info.Tsample=sscanf(info_line(7:end),'%f');
    elseif strncmp(info_line, 'X=', 2)
        data.info.Xpos=sscanf(info_line(3:end),'%f'); 
    elseif strncmp(info_line, 'Y=', 2)
        data.info.Ypos=sscanf(info_line(3:end),'%f');
    elseif strncmp(info_line, 'Z=', 2)
        data.info.Zpos=sscanf(info_line(3:end),'%f');
    elseif strncmp(info_line, 'I0=', 3)
        data.info.I0=sscanf(info_line(4:end),'%f');
    elseif strncmp(info_line, 'mono=', 5)
        data.info.PhotonEnergy=sscanf(info_line(6:end),'%f');
    elseif strncmp(info_line, 'total_resolution=',17)
        data.info.TotalResolution=sscanf(info_line(18:end),'%f');
    elseif strncmp(info_line, 'EF=', 3)
        data.info.FermiEnergy=sscanf(info_line(4:end),'%f');
    elseif strncmp(info_line, 'Time=', 5)
        data.info.Time=info_line(6:end);
    end
    %----------end of getting header info------------
    info_line=fgetl(fid);
    if info_line==-1
        tf=false;
        return
    end
end
%--------------end of gathering data info---------------------

%--------------get data---------------------------------------
if isempty(scale3)  % 1D and 2D data can be input the same way
    datavalue=zeros(length(scale1),length(scale2));
    for i=1:length(scale1)
        line_data=sscanf(fgetl(fid),'%f');
        datavalue(i,:)=line_data(2:length(line_data));
    end
    data.value=datavalue';
else %3D case such as Stanford Helm manipulator scan
    %***
end
fclose(fid);
%--------------end of getting data----------------------------


%--------------assign variable into workspace-----------------
%if 1st char of file_name is a number, should add a letter in front of it
if ~isletter( file_name(1) )
    file_name=['A',file_name];
end
assignin('base',file_name,data);
tf=true;
