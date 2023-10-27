function v_return=load_soleil_nxs(varargin)
% return true if successfully loaded, otherwise return false.

if nargin~=1
    v_return=false;
    return;
end

fullfilename=varargin{1};
[~, filename, ext] = fileparts(fullfilename);
if ~strcmpi(ext,'.nxs')
    v_return=false;
    return;
end

% ---------------Load Data----------------------


hinfo = h5info(varargin{1});
rootPath=hinfo.Groups(1).Name;
rootPath2=hinfo.Groups(end).Name;
%% If Map Data
% isMapData
n1 = length(hinfo.Groups);
k = 0;
UnsortedGroupList={};
for i = 1:n1
    n2 = length(hinfo.Groups(i).Groups);
    for j = 1:n2
        startInd = regexp(hinfo.Groups(i).Groups(j).Name,'/Scienta_0_\d*');
        if ~isempty(startInd)
            k=k+1;
            UnsortedGroupList{k}.path = hinfo.Groups(i).Groups(j).Name;
            UnsortedGroupList{k}.num = str2double(...
                UnsortedGroupList{k}.path(startInd+11:end));
        end
    end
end
n=length(UnsortedGroupList);
if n>0     % if '/Scienta_0' exists, then it is map data.
    data.info.DataType='map';
    SortedGroupPath=cell(1,n);
    for i = 1:n
        newNum = UnsortedGroupList{i}.num+1;
        path = UnsortedGroupList{i}.path;
        SortedGroupPath{newNum} = path;
    end
    % get data.x, data.y, data.z and data.value
    for j = 1:length(SortedGroupPath)
        datavaluedummy = h5read(varargin{1},[SortedGroupPath{j},'/data1']);
        data.value(j,:,:) = datavaluedummy';
        %phi is rotated while theta stays the same (sample position)
        data.x(j) = h5read(varargin{1},[SortedGroupPath{j},'/Phi']);
        data.y = h5read(varargin{1},[SortedGroupPath{j},'/sliceScale1'])';
        data.z = h5read(varargin{1},[SortedGroupPath{j},'/channelScale1'])';
        data.EDC = h5read(varargin{1},[SortedGroupPath{j},'/sumData1'])';
    end
    data.info.saazimuth=data.x;
    %----------manipulator and smple position info--------------------
    try
    data.info.sax = h5read(fullfilename,[rootPath2, '/Scienta_0_0/PI-X']);
    data.info.say = h5read(fullfilename,[rootPath2, '/Scienta_0_0/PI-Y']);
    data.info.saz = h5read(fullfilename,[rootPath2, '/Scienta_0_0/PI-Z']);
    data.info.satilt = h5read(fullfilename,[rootPath2, '/Scienta_0_0/Theta']);
    catch
        warning([fullfilename,...
            ' data.info.sax,',...
            ' data.info.say,',...
            ' data.info.saz,',...
            ' data.info.satilt',...
            ' are missing']);
    end
end

%% If Real Space Scan Data
idx=strfind(rootPath,'salsaentry_1');
if ~isempty(idx)
    idx=strfind(rootPath,'salsaentry_1_1');
    if ~isempty(idx)
        data.info.DataType='PIx-PIy';
        M4=h5read(fullfilename,[rootPath '/scan_data/data_04']);
    else
        data.info.DataType='PIx-ZPs';
        M4=h5read(fullfilename,[rootPath '/scan_data/data_02']);
    end
    data.x=h5read(fullfilename,[rootPath '/scan_data/trajectory_2_1']);
    data.y=h5read(fullfilename,[rootPath '/scan_data/trajectory_1_1']);
    
    try
        data.k= h5read(fullfilename,[rootPath,...
            '/ANTARES/ScientaAtt1/sliceScale/data']);
    catch
        warning([fullfilename,...
            ' data.z',...
            ' is missing.',...
            ' Index are adopted.']);
        data.k=1:size(M4,1);
    end
    try
        data.z= h5read(fullfilename,[rootPath,...
            '/ANTARES/ScientaAtt1/channelScale/data']);
    catch
        warning([fullfilename,...
            ' data.z',...
            ' is missing.',...
            ' Index are adopted.']);
        data.z=1:size(M4,2);
    end
    try % Deal with memory limitation
        data.value=permute(M4,[4 3 2 1]);
    catch ME
        switch ME.identifier
            case 'MATLAB:nomem' % If memory is not enough, then combine data
                warning([fullfilename,...
                    ' out of memory. Energy axis combined']);
                % combine data
                % combine k
                nsize=size(M4);
                nsize(2)=floor(nsize(2)/2);
                n=nsize(2);                
                nOdd = (0:n-1)*2+1;
                nEven = (1:n)*2;
                M4New=zeros(nsize);
                for i = 1:size(M4,1)
                    M3Odd=M4(i,nOdd,:,:);
                    M3Even=M4(i,nEven,:,:);
                    M3Total=M3Odd+M3Even;
                    M4New(i,:,:,:)=M3Total;
                end
                M4=M4New;
                clear M4New;
                data.k=data.k(nOdd);
                % combine z
                nsize(1)=floor(nsize(1)/2);
                n=nsize(1);
                nOdd = (0:n-1)*2+1;
                nEven = (1:n)*2;
                M4New=zeros(nsize);
                for i = 1:size(M4,2)
                    M3Odd=M4(nOdd,i,:,:);
                    M3Even=M4(nEven,i,:,:);
                    M3Total=M3Odd+M3Even;
                    M4New(:,i,:,:)=M3Total;
                end
                M4=M4New;
                clear M4New;
                data.z=data.z(nOdd);
                data.value=permute(M4,[4 3 2 1]);                
            otherwise
                throw(ME);
        end
    end
    if size(data.value,3)~=length(data.k)
        data.k=1:size(data.value,3);
    end
    if size(data.value,4)~=length(data.z)
        data.z=1:size(data.value,4);
    end
end


%% data.info builder
try
val=h5read(fullfilename,[rootPath '/experiment_identifier']);
data.info.experiment_identifier=val{1};
val=h5read(fullfilename,[rootPath '/start_time']);
data.info.start_time=val{1};
%--------------Monochromator------------------------
data.info.Ephoton=h5read(fullfilename,[rootPath '/ANTARES/Monochromator/energy/data']);
data.info.ExitSlit = h5read(fullfilename,[rootPath '/ANTARES/Monochromator/exitSlitAperture/data']);
Advanced_info.GratingName = h5read(fullfilename,[rootPath '/ANTARES/Monochromator/currentGratingName/data']);
Advanced_info.monochromator_resolution = h5read(fullfilename,[rootPath '/ANTARES/Monochromator/resolution/data']);
%--------------Attributes-------------------------
val= h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/lensMode/data']);
val=val{1};
if strncmp(val,'Ang',3)
    val(2:3)=[];
end
data.info.LensMode=val;
val = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/mode/data']);
data.info.AcquisitionMode=val{1};
data.info.Epass= h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/passEnergy/data']);
data.info.TimePerCut = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/stepTime/data']);
Advanced_info.detectorSlices = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/detectorSlices/data']);
Advanced_info.energyStep = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/energyStep/data']);
Advanced_info.excitationEnergy = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/excitationEnergy/data']);
Advanced_info.fixEnergy = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/fixEnergy/data']);
Advanced_info.highEnergy = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/highEnergy/data']);
Advanced_info.lowEnergy = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/lowEnergy/data']);
Advanced_info.sliceScale = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/sliceScale/data']);
Advanced_info.slices = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/slices/data']);
Advanced_info.sweeps = h5read(fullfilename,[rootPath '/ANTARES/ScientaAtt1/sweeps/data']);
data.Advanced_info=Advanced_info;
catch 
    warning(['failed to load ', fullfilename, '.info']);
end %debuug
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

filename(filename=='-')='_';
data.value=double(data.value);

assignin('base',filename,data);
v_return = true;


