function tf=load_Diamond_hdf5_nano(varargin)
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
% size. Email: peiding123@gmail.com


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
infodummy = h5info(varargin{1});
if ~strcmpi(infodummy.Attributes(4).Name,'SIStem Version')
% Identify Diamond Data
    tf=false;
    return
end



%% ---------------Load Data----------------------

 data.value=h5read(varargin{1},'/Electron Analyzer/Image Data');
 if ndims(data.value)==3
        size3=size(data.value);
        xnum=size3(1);ynum=size3(3);znum=size3(2);
        xaxis=h5readatt(varargin{1},'/Electron Analyzer/Image Data','Axis2.Scale');
        data.x=xaxis(1):xaxis(2):xaxis(1)+(xnum-1)*xaxis(2);
        yaxis=h5readatt(varargin{1},'/Electron Analyzer/Image Data','Axis0.Scale');
        data.z=yaxis(1):yaxis(2):yaxis(1)+(ynum-1)*yaxis(2);
        zaxis=h5readatt(varargin{1},'/Electron Analyzer/Image Data','Axis1.Scale');
        data.y=zaxis(1):zaxis(2):zaxis(1)+(znum-1)*zaxis(2);
    end
 if ndims(data.value)==2
        size3=size(data.value);
        xnum=size3(1);ynum=size3(2);
        xaxis=h5readatt(varargin{1},'/Electron Analyzer/Image Data','Axis1.Scale');
        data.x=xaxis(1):xaxis(2):xaxis(1)+(xnum-1)*xaxis(2);
        yaxis=h5readatt(varargin{1},'/Electron Analyzer/Image Data','Axis0.Scale');
        data.y=yaxis(1):yaxis(2):yaxis(1)+(ynum-1)*yaxis(2);
    end  

assignin('base',filename,data);
tf = true;


