function info=loadinfo_soleil_nxs(varargin)
% return true if successfully loaded, otherwise return false.

if nargin~=1
    info=[];
    return;
end

fullfilename=varargin{1};
[~, filename, ext] = fileparts(fullfilename);
if ~strcmpi(ext,'.nxs')
    info=[];
    return;
end

% ---------------Load Data----------------------
info.DataType='map';
info.sax = h5read(fullfilename,['/H_0/Scienta_0_0/PI-X']);
info.say = h5read(fullfilename,['/H_0/Scienta_0_0/PI-Y']);
info.saz = h5read(fullfilename,['/H_0/Scienta_0_0/PI-Z']);
info.satilt = h5read(fullfilename,['/H_0/Scienta_0_0/Theta']);

%--------------Monochromator------------------------
info.Ephoton=h5read(fullfilename,'/H_0/ANTARES/Monochromator/energy/data');
info.ExitSlit = h5read(fullfilename,'/H_0/ANTARES/Monochromator/exitSlitAperture/data');
%--------------Attributes-------------------------
val= h5read(fullfilename,'/H_0/ANTARES/ScientaAtt1/lensMode/data');
val=val{1};
if strncmp(val,'Ang',3)
    val(2:3)=[];
end
info.LensMode=val;
val = h5read(fullfilename,'/H_0/ANTARES/ScientaAtt1/mode/data');
info.AcquisitionMode=val{1};
info.Epass= h5read(fullfilename,'/H_0/ANTARES/ScientaAtt1/passEnergy/data');
info.TimePerCut = h5read(fullfilename,'/H_0/ANTARES/ScientaAtt1/stepTime/data');


