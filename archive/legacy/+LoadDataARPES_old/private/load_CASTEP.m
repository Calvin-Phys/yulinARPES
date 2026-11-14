function tf=load_CASTEP(varargin)

% ALWAYS PUT THIS FUNCTION BEFORE load_scienta_manipulator_scan_txt
% Otherwise load_scienta_manipulaor_scan_txt will go to a dead loop.

% The function load_CASTEP(filename) is designed
% to load the CASTEP BandStr calculation from Material Studio.
% Input "filename" is a string that contain the full filename
% with its path
%
% The function then loads the file into the workspace with the
% variable name start with the filename 
%
%
% The variable contains the field "info",
%
% In case bugs are found, please contact the author (Yulin Chen) by
% Email: fawkes.dx@gmail.com

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
infoline = fgetl(fid);

tf = false;
while ~isnumeric(infoline)
    infoline = fgetl(fid);
    if strcmp(infoline,' |      CCC   AA    SSS  TTTTT  EEEEE  PPPP        |')
        tf = true;
    end
end

if ~tf
    return
end
    
j = 1;
l = 1;

%tf = false;
fid=fopen(varargin{1});
infoline = fgetl(fid);
%% GetData
while ~isnumeric(infoline)
    infoline = fgetl(fid);
    if strncmp(infoline,'  +  Spin=',10)
        infoline(53:71)=[];
        infoline(1:23)=[];
        k{j} = str2num(infoline);
        j = j+1;
        l=1;
    elseif strncmp(infoline,'  +  ',5)
        kanan = size(infoline,2);
        infoline(kanan) = [];
        infoline(1:3) = [];
        if ~isempty(str2num(infoline))
            dummydata(l,:) = str2num(infoline);
            dummyk{j-1} = dummydata;
            l = l+1;
        end
        
    end
end
        
dataout.k = k;
dataout.E = dummyk;

%% Assignin data to workspace
dataName = dataName(find(~isspace(dataName)));
assignin('base',dataName,dataout);


end