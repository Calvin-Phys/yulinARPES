function tf = load_PEARL(varargin)
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

    [Angle,Energy,Scan,Data,ep,Note]=ReadARPES_PEARL([filename '.h5']);

    if ndims(Data)==3
    % cut upper 10% of data to avoid confusion of AlignEF by edge of
    % detector

        datav_new.value=permute(Data,[3 2 1]);
        if all(Scan == Scan(1))
            datav_new.x=1:length(Scan);
        else
            datav_new.x=Scan;
        end
        datav_new.z=Energy';
        datav_new.y=Angle;
    end
    
    if ndims(Data)==2
        datav_new.value=permute(Data,[2 1]);
        datav_new.x=Angle;
        datav_new.y=Energy';
    end
%     datav_new.info=info;
%     datav_new.info.Note=Note;
    filename = regexprep(filename, ' ', '_');
    filename = regexprep(filename, '-', '_');
    filename = regexprep(filename, '+', 'P');
    filename = regexprep(filename, '\.', 'p');
    filename = regexprep(filename, '=', 'G');

    assignin('base',strcat('SX',filename),datav_new);

end

