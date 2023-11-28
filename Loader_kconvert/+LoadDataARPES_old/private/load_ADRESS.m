function tf = load_ADRESS(varargin)
% The function load_ADRESS(filepath) is designed
% to load the ADRESS hdf5 data file into the workspace.
% Input varargin{1} is a string that contain the full filename
% with its path

% return true if successfully loaded, otherwise return false.
tf=true;
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

    [Angle,Energy,Scan,Data,ep,Note]=ReadARPES([filename '.h5']);
    Notes=splitlines(Note);
    for ii=1:length(Notes)
        tmp=strsplit(Notes{ii},{'=','*'});
        if contains(tmp{1},'hv')
            info.Energies=str2num(tmp{2});
        elseif contains(tmp{1},'Pol')
            info.Polarization=tmp{2};
        elseif contains(tmp{1},'Slit')
            info.exit_slit=str2num(tmp{2});    
        elseif contains(tmp{1},'Epass')
            info.Pass_energy=str2num(tmp{2});    
        elseif contains(tmp{1},'dt')
            info.time_per_frame=str2num(tmp{2});    
        elseif contains(tmp{1},'Theta')
            info.theta=str2num(tmp{2});    
        elseif contains(tmp{1},'Tilt')
            info.tilt=str2num(tmp{2});    
        elseif contains(tmp{1},'Azimuth')
            info.azimuth=str2num(tmp{2});    
        elseif contains(tmp{1},'X')
            info.X=str2num(tmp{2});    
        elseif contains(tmp{1},'Z')
            info.Z=str2num(tmp{2});    
        elseif contains(tmp{1},'Temp')
            info.Temp=str2num(tmp{2});    
        elseif contains(tmp{1},'Y')
            info.Y=str2num(tmp{2});    
        end
    end
    if contains(Note,'ones(')
        tmp=strsplit(Note,'ones(');
        tmp=strsplit(tmp{2},')');
        tmp=tmp{1};
        info.total_time=info.time_per_frame*str2num(tmp);
    end
    
    if ndims(Data)==3
    % cut upper 10% of data to avoid confusion of AlignEF by edge of
    % detector

        datav_new.value=permute(Data,[3 2 1]);
        datav_new.x=Scan;
        datav_new.z=Energy';
        datav_new.y=Angle;
    end
    
    if ndims(Data)==2
        datav_new.value=permute(Data,[2 1]);
        datav_new.x=Angle;
        datav_new.y=Energy';
    end
    datav_new.info=info;
    datav_new.info.Note=Note;
    filename = regexprep(filename, ' ', '_');
    filename = regexprep(filename, '-', '_');
    filename = regexprep(filename, '+', 'P');

    assignin('base',strcat('SX',filename),datav_new);

end

