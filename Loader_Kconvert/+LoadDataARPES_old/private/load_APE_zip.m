function tf=load_APE_zip(varargin)
% This function load_APE_zip is designed to load APE mapping data, which
% are contained in a zip file.
%
% The function then loads the file into the workspace with the
% variable name the same as the filename.
% The variable contains the field "info", axis information of
% "x", "y" and "z" depending on the measuring data's dimention
% and the field "value" for the bulk data.
%
% In case bugs are found, please contact the author (Cheng Chen) by
% Email: penghan1992@gmail.com

%% check input filepath and ext
tf = true;
if nargin~=1
    tf=false;
    return;
end
[~, ~, ext] = fileparts(varargin{1}); 
if ~strcmpi(ext,'.zip')
    tf=false;
    return;
end


%% Unzip file to temp folder
sourceFile = varargin{1};
tempFolder = ['temp',num2str(randi(1000000000))];
mkdir(tempFolder);
tempPath = fullfile(cd,tempFolder);
unzip(sourceFile,tempPath);


%% Read Viewer File
viewerFile = fullfile(tempPath,'viewer.ini');
fViewer = fopen(viewerFile);
if fViewer == -1
    tf=-1;
    errordlg(['Viewer file missing in ',varargin{1}]);
    return;
end
infoline=fgetl(fViewer);
while ~feof(fViewer)
    if length(infoline)>9
        if strcmp(infoline(end-9:end-1),'channel_1')
            break;
        end
    end
    infoline=fgetl(fViewer);
    [~,EndInd]= regexp(infoline,'.*=');
    if ~isempty(EndInd)
        infoName = infoline(1:EndInd-1);
        infoValue = infoline(EndInd+1:end);
        if strcmp(infoName,'path')
            fileName=infoValue;
            binPath = fullfile(tempPath,fileName);
        elseif strcmp(infoName,'ini_path')
            fileName=infoValue;
            iniPath = fullfile(tempPath,fileName);
        elseif strcmp(infoName,'width')
            nw = str2double(infoValue);
        elseif strcmp(infoName,'height')
            nh = str2double(infoValue);
        elseif strcmp(infoName,'depth')
            nd = str2double(infoValue);
        elseif strcmp(infoName,'width_offset')
            wStart = str2double(infoValue);
        elseif strcmp(infoName,'width_delta')
            wStep = str2double(infoValue);
        elseif strcmp(infoName,'height_offset')
            hStart = str2double(infoValue);
        elseif strcmp(infoName,'height_delta')
            hStep = str2double(infoValue);
        elseif strcmp(infoName,'depth_offset')
            dStart = str2double(infoValue);
        elseif strcmp(infoName,'depth_delta')
            dStep = str2double(infoValue);
        elseif strcmp(infoName,'name')
            dataName = infoValue;
            data.info.DataName=dataName;
        end
    end
end


fileInfo=dir(binPath);
nUnit=fileInfo.bytes/nw/nh/nd;

if nUnit==4
    Precision='single=>double';
elseif nUnit==8
    Precision='double';
else
   errordlg('Size Infomation does not match data in',varargin{1});
   tf=-1;
    return;
end

%% Read Information
fIni = fopen(iniPath);
fData = fopen(binPath);
if fIni==-1
    % Information file not found
    tf=false;
    return;
end
if fData==-1
    % Data file not found
    tf=false;
    return;
end

while ~feof(fIni)
    infoline = fgetl(fIni);
%      [~,EndInd]= regexp(infoline,'.*=');
    if regexp(infoline,'Comments')
        infoName = infoline(1:8);
        infoValue = infoline(10:end);
        infoName=strrep(infoName,' ','');
        infoName=strrep(infoName,'-','');
        data.info.(infoName)=infoValue;
    else
        [~,EndInd]= regexp(infoline,'.*=');
        if ~isempty(EndInd)
            infoName = infoline(1:EndInd-1);
            infoValue = infoline(EndInd+1:end);
            infoName=strrep(infoName,' ','');
            infoName=strrep(infoName,'-','');
%            data.info.(infoName)=infoValue;
        end        
    end
%     while ~feof(fIni)
%     infoline = fgetl(fIni);
%     [~,EndInd]= regexp(infoline,'.*=');
%     if ~isempty(EndInd)
%         infoName = infoline(1:EndInd-1);
%         infoValue = infoline(EndInd+1:end);
%         infoName=strrep(infoName,' ','');
%         infoName=strrep(infoName,'-','');
%         data.info.(infoName)=infoValue;
%     end
    if wStep==0 || hStep==0 || dStep==0
        if strcmp(infoName,'Thetax_Low')
            y1=str2double(infoValue);
        elseif strcmp(infoName,'Thetax_High')
            y2=str2double(infoValue);
        elseif strcmp(infoName,'Thetax_Steps')
            ny=str2double(infoValue);
        elseif strcmp(infoName,'Thetay_Low')
            x1=str2double(infoValue);
        elseif strcmp(infoName,'Thetay_High')
            x2=str2double(infoValue);
        elseif strcmp(infoName,'Thetay_Steps')
            nx=str2double(infoValue);            
        elseif strcmp(infoName,'LowEnergy')
            z1=str2double(infoValue);
        elseif strcmp(infoName,'HighEnergy')
            z2=str2double(infoValue);
        elseif strcmp(infoName,'EnergyStep')
            nz=str2double(infoValue);
        end
    end
end
fclose(fIni);
if wStep==0
    wStep=(z2-z1)/(nz-1);
end
if hStep==0
    hStep=(y2-y1)/(ny-1);
end
if dStep==0
    dStep=(x2-x1)/(nx-1);
end


%% Read Data

% need to be adjusted for the spin data

value0=fread(fData,Inf,Precision);
value0=reshape(value0,[nw,nh,nd]);
data.value=permute(value0,[3 2 1]);
data.x=(0:nd-1)*dStep+dStart;
data.y=(0:nh-1)*hStep+hStart;
data.z=(0:nw-1)*wStep+wStart;

fclose(fData);

[~,dataNameNew,~]=fileparts(sourceFile);
dataNameNew = strrep(dataNameNew,' ','_');
dataNameNew = strrep(dataNameNew,'-','_');
assignin('base',dataNameNew,data);


%% Delete temp folder
fclose('all');
try
%     rmdir(tempPath,'s');
     rmdir(tempFolder,'s');
catch
    disp(['Can not remove folder ',tempPath]);
    disp('You can remove it manually later.');
end
end