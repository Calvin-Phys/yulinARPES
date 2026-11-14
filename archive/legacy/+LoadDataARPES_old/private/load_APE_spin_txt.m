function tf=load_APE_spin_txt(varargin)

% ALWAYS PUT THIS FUNCTION BEFORE load_scienta_manipulator_scan_txt
% Otherwise load_scienta_manipulaor_scan_txt will go to a dead loop.

% The function load_APE_spin_txt(filename) is designed
% to load the scienta manipulator scan data file into the workspace.
% Input "filename" is a string that contain the full filename
% with its path
%
% The function then loads the file into the workspace with the
% variable name start with the filename plus the serial number for each
% theta set (theta is the angle perpendicular to each cut) with the same
% phi angle. For different phi angle sets, the phi angle is automatic
% offseted by the info from the file.
%
%
% The variable contains the field "info", axis information of
% "x", "y" and "z" depending on the measuring data's dimension
% and the field "value" for the bulk data.
%
% In case bugs are found, please contact the author by email: 
% penghan1992@gmail.com

% return true if successfully loaded, otherwise return false.

tf=true;

if nargin~=1
%     errordlg('There should be only one input -- the data filename','Wrong argument No.');
    tf=false;
    return
end

[~,dataName, ext] = fileparts(varargin{1}); 
if ~strcmp(ext,'.txt')
%     errordlg(['The file "' varargin{1} '" is not a .txt file!'],'Wrong file format');
    tf=false;
    return
end
fid=fopen(varargin{1}); % open data file
infoline=fgetl(fid);

%% Data 1
%% Get Information
while ~strncmp(infoline,'[Signal 1]',10)
    infoline = fgetl(fid);
    [~,EndInd]= regexp(infoline,'.*=');
    if ~isempty(EndInd)
        infoName = infoline(1:EndInd-1);
        infoValue = infoline(EndInd+1:end);
        infoName=strrep(infoName,' ','');
        infoName=strrep(infoName,'-','');
        infoName=strrep(infoName,'[','');
        infoName=strrep(infoName,']','');
        data.info.(infoName)=infoValue;
        if strncmp(infoline,'Dimension 2',11)
            tf=false; % Spin data only has one dimension
            return;
        end
    end
end

%% Get Data
dataTemp=fscanf(fid,'%f');
dataTemp=reshape(dataTemp,[2,length(dataTemp)/2]);
data.x=dataTemp(1,:);
data.value=dataTemp(2,:);

%% Assignin data to workspace
dataNameNew = dataName;
dataNameNew = strrep(dataNameNew,' ','_');
dataNameNew = strrep(dataNameNew,'-','_');
dataNameNew = [dataNameNew,'_Signal1'];
assignin('base',dataNameNew,data);
data1=data;

%% Data 2
infoline = fgetl(fid);
while ~strncmp(infoline,'[Signal 2]',10)
    infoline = fgetl(fid);
    if ~ischar(infoline)
        tf = false;
        return;
    else
        [~,EndInd]= regexp(infoline,'.*=');
        if ~isempty(EndInd)
            infoName = infoline(1:EndInd-1);
            infoValue = infoline(EndInd+1:end);
            infoName=strrep(infoName,' ','');
            infoName=strrep(infoName,'-','');
            infoName=strrep(infoName,'[','');
            infoName=strrep(infoName,']','');
            data.info.(infoName)=infoValue;
            if strncmp(infoline,'Dimension 2',11)
                tf=false; % Spin data only has one dimension
                return;
            end
        end
    end
end


%% Get Data
dataTemp=fscanf(fid,'%f');
dataTemp=reshape(dataTemp,[2,length(dataTemp)/2]);
data.x=dataTemp(1,:);
data.value=dataTemp(2,:);

%% Assignin data to workspace
dataNameNew = dataName;
dataNameNew = strrep(dataNameNew,' ','_');
dataNameNew = strrep(dataNameNew,'-','_');
dataNameNew = [dataNameNew,'_Signal2'];
assignin('base',dataNameNew,data);
data2=data;

%% Data 3
infoline = fgetl(fid);
while ~strncmp(infoline,'[Signal 3]',10)
    infoline = fgetl(fid);
    if ~ischar(infoline)
        tf = true;
        return;
    else
        [~,EndInd]= regexp(infoline,'.*=');
        if ~isempty(EndInd)
            infoName = infoline(1:EndInd-1);
            infoValue = infoline(EndInd+1:end);
            infoName=strrep(infoName,' ','');
            infoName=strrep(infoName,'-','');
            infoName=strrep(infoName,'[','');
            infoName=strrep(infoName,']','');
            data.info.(infoName)=infoValue;
            if strncmp(infoline,'Dimension 2',11)
                tf=false; % Spin data only has one dimension
                return;
            end
        end
    end
end

%% Get Data
dataTemp=fscanf(fid,'%f');
dataTemp=reshape(dataTemp,[2,length(dataTemp)/2]);
data.x=dataTemp(1,:);
data.value=dataTemp(2,:);

%% Assignin data to workspace
dataNameNew = dataName;
dataNameNew = strrep(dataNameNew,' ','_');
dataNameNew = strrep(dataNameNew,'-','_');
dataNameNew = [dataNameNew,'_Signal3'];
assignin('base',dataNameNew,data);
data3=data;

%% Data 4
infoline = fgetl(fid);
while ~strncmp(infoline,'[Signal 4]',10)
    infoline = fgetl(fid);
    if ~ischar(infoline)
        tf = true;
        return;
    else
        [~,EndInd]= regexp(infoline,'.*=');
        if ~isempty(EndInd)
            infoName = infoline(1:EndInd-1);
            infoValue = infoline(EndInd+1:end);
            infoName=strrep(infoName,' ','');
            infoName=strrep(infoName,'-','');
            infoName=strrep(infoName,'[','');
            infoName=strrep(infoName,']','');
            data.info.(infoName)=infoValue;
            if strncmp(infoline,'Dimension 2',11)
                tf=false; % Spin data only has one dimension
                return;
            end
        end
    end
end


%% Get Data
dataTemp=fscanf(fid,'%f');
dataTemp=reshape(dataTemp,[2,length(dataTemp)/2]);
data.x=dataTemp(1,:);
data.value=dataTemp(2,:);

%% Assignin data to workspace
dataNameNew = dataName;
dataNameNew = strrep(dataNameNew,' ','_');
dataNameNew = strrep(dataNameNew,'-','_');
dataNameNew = [dataNameNew,'_Signal4'];
assignin('base',dataNameNew,data);
data4=data;

%% Data 5
infoline = fgetl(fid);
while ~strncmp(infoline,'[Signal 5]',10)
    infoline = fgetl(fid);
    if ~ischar(infoline)
        tf = true;
        return;
    else
        [~,EndInd]= regexp(infoline,'.*=');
        if ~isempty(EndInd)
            infoName = infoline(1:EndInd-1);
            infoValue = infoline(EndInd+1:end);
            infoName=strrep(infoName,' ','');
            infoName=strrep(infoName,'-','');
            infoName=strrep(infoName,'[','');
            infoName=strrep(infoName,']','');
            data.info.(infoName)=infoValue;
            if strncmp(infoline,'Dimension 2',11)
                tf=false; % Spin data only has one dimension
                return;
            end
        end
    end
end


%% Get Data
dataTemp=fscanf(fid,'%f');
dataTemp=reshape(dataTemp,[2,length(dataTemp)/2]);
data.x=dataTemp(1,:);
data.value=dataTemp(2,:);

%% Assignin data to workspace
dataNameNew = dataName;
dataNameNew = strrep(dataNameNew,' ','_');
dataNameNew = strrep(dataNameNew,'-','_');
dataNameNew = [dataNameNew,'_Signal5'];
assignin('base',dataNameNew,data);
data5=data;

%% Data 6
infoline = fgetl(fid);
while ~strncmp(infoline,'[Signal 6]',10)
    infoline = fgetl(fid);
    if ~ischar(infoline)
        tf = true;
        return;
    else
        [~,EndInd]= regexp(infoline,'.*=');
        if ~isempty(EndInd)
            infoName = infoline(1:EndInd-1);
            infoValue = infoline(EndInd+1:end);
            infoName=strrep(infoName,' ','');
            infoName=strrep(infoName,'-','');
            infoName=strrep(infoName,'[','');
            infoName=strrep(infoName,']','');
            data.info.(infoName)=infoValue;
            if strncmp(infoline,'Dimension 2',11)
                tf=false; % Spin data only has one dimension
                return;
            end
        end
    end
end


%% Get Data
dataTemp=fscanf(fid,'%f');
dataTemp=reshape(dataTemp,[2,length(dataTemp)/2]);
data.x=dataTemp(1,:);
data.value=dataTemp(2,:);

%% Assignin data to workspace
dataNameNew = dataName;
dataNameNew = strrep(dataNameNew,' ','_');
dataNameNew = strrep(dataNameNew,'-','_');
dataNameNew = [dataNameNew,'_Signal6'];
assignin('base',dataNameNew,data);
data6=data;

%% Data 7
infoline = fgetl(fid);
while ~strncmp(infoline,'[Signal 7]',10)
    infoline = fgetl(fid);
    if ~ischar(infoline)
        tf = true;
        return;
    else
        [~,EndInd]= regexp(infoline,'.*=');
        if ~isempty(EndInd)
            infoName = infoline(1:EndInd-1);
            infoValue = infoline(EndInd+1:end);
            infoName=strrep(infoName,' ','');
            infoName=strrep(infoName,'-','');
            infoName=strrep(infoName,'[','');
            infoName=strrep(infoName,']','');
            data.info.(infoName)=infoValue;
            if strncmp(infoline,'Dimension 2',11)
                tf=false; % Spin data only has one dimension
                return;
            end
        end
    end
end


%% Get Data
dataTemp=fscanf(fid,'%f');
dataTemp=reshape(dataTemp,[2,length(dataTemp)/2]);
data.x=dataTemp(1,:);
data.value=dataTemp(2,:);

%% Assignin data to workspace
dataNameNew = dataName;
dataNameNew = strrep(dataNameNew,' ','_');
dataNameNew = strrep(dataNameNew,'-','_');
dataNameNew = [dataNameNew,'_Signal7'];
assignin('base',dataNameNew,data);
data7=data;

%% Data 8
infoline = fgetl(fid);
while ~strncmp(infoline,'[Signal 8]',10)
    infoline = fgetl(fid);
    if ~ischar(infoline)
        tf = true;
        return;
    else
        [~,EndInd]= regexp(infoline,'.*=');
        if ~isempty(EndInd)
            infoName = infoline(1:EndInd-1);
            infoValue = infoline(EndInd+1:end);
            infoName=strrep(infoName,' ','');
            infoName=strrep(infoName,'-','');
            infoName=strrep(infoName,'[','');
            infoName=strrep(infoName,']','');
            data.info.(infoName)=infoValue;
            if strncmp(infoline,'Dimension 2',11)
                tf=false; % Spin data only has one dimension
                return;
            end
        end
    end
end


%% Get Data
dataTemp=fscanf(fid,'%f');
dataTemp=reshape(dataTemp,[2,length(dataTemp)/2]);
data.x=dataTemp(1,:);
data.value=dataTemp(2,:);

%% Assignin data to workspace
dataNameNew = dataName;
dataNameNew = strrep(dataNameNew,' ','_');
dataNameNew = strrep(dataNameNew,'-','_');
dataNameNew = [dataNameNew,'_Signal8'];
assignin('base',dataNameNew,data);
data8=data;

% %% Difference
% data3=data2;
% data3.value=(data1.value-data2.value)/(data1.value+data2.value);
% dataNameNew = dataName;
% dataNameNew = strrep(dataNameNew,' ','_');
% dataNameNew = strrep(dataNameNew,'-','_');
% dataNameNew = [dataNameNew,'_Diff'];
% assignin('base',dataNameNew,data3);
end