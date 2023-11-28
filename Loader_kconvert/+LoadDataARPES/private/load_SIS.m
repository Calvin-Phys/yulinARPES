function tf = load_SIS(varargin)
% The function load_SIS(filepath) is designed
% to load the SIS h5 data file into the workspace.
% Input varargin{1} is a string that contain the full filename
% with its path

% return true if successfully loaded, otherwise return false.
tf=true;
if nargin~=1
%     errordlg('There should be only one input -- the data varargin{1}','Wrong argument No.');
    tf=false;
    return
end

[~, var_name, ext] = fileparts(varargin{1});
if ~strcmpi(ext,'.h5')
    %     errordlg(['The file "' varargin{1} '" is not a .nxs file!'],'Wrong file format');
    tf=false;
    return
end

% check if it is from SIS
sisinfo = h5info([var_name ext]);
[sischeck,~] = sisinfo.Groups.Name; % need to check if the config of the file changes
if ~strcmpi(sischeck,'/Electron Analyzer')
    %     errordlg(['The file "' varargin{1} '" is not a .nxs file!'],'Wrong file format');
    tf=false;
    return
end
%var_list=get(handles.listbox_Current_Folder,'String');
%var_index=get(handles.listbox_Current_Folder,'Value');
datav_new=[];
datav_new.info.Energies=sisinfo.Groups(1).Datasets.Attributes(30).Value;
%for ii=1:length(var_index)
%var_name=var_list{var_index(ii)};
filename=var_name;
var_name = [var_name ext]; %combine the file name and extension
tic
datav_new.value=h5read(var_name,'/Electron Analyzer/Image Data');
toc
if ndims(datav_new.value)==3
    size3=size(datav_new.value);
    xnum=size3(1);ynum=size3(3);znum=size3(2);
    xaxis=h5readatt(var_name,'/Electron Analyzer/Image Data','Axis2.Scale');
    datav_new.x=xaxis(1):xaxis(2):xaxis(1)+(xnum-1)*xaxis(2);
    yaxis=h5readatt(var_name,'/Electron Analyzer/Image Data','Axis0.Scale');
    datav_new.z=yaxis(1):yaxis(2):yaxis(1)+(ynum-1)*yaxis(2);
    zaxis=h5readatt(var_name,'/Electron Analyzer/Image Data','Axis1.Scale');
    datav_new.y=zaxis(1):zaxis(2):zaxis(1)+(znum-1)*zaxis(2);
end


if ndims(datav_new.value)==2
    size3=size(datav_new.value);
    xnum=size3(1);ynum=size3(2);
    xaxis=h5readatt(var_name,'/Electron Analyzer/Image Data','Axis1.Scale');
    datav_new.x=xaxis(1):xaxis(2):xaxis(1)+(xnum-1)*xaxis(2);
    yaxis=h5readatt(var_name,'/Electron Analyzer/Image Data','Axis0.Scale');
    datav_new.y=yaxis(1):yaxis(2):yaxis(1)+(ynum-1)*yaxis(2);
end
    filename = regexprep(filename, ' ', '_');
    filename = regexprep(filename, '-', '_');
    filename = regexprep(filename, '+', 'P');
    filename = regexprep(filename, '\.', 'p');
    filename = regexprep(filename, '=', 'G');

assignin('base',strcat('SIS_',filename),datav_new);
vars=evalin('base','who');
%set(handles.listbox_Workspace,'String',vars);
%end
end
