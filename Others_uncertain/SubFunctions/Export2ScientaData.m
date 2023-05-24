function output = Export2ScientaData( filename, data )
%Export2ScientaData Summary of this function goes here
%   Detailed explanation goes here
if (isfield(data,'value') && isfield(data,'x') && isfield(data,'y')) ||...
        (isprop(data,'value') && isprop(data,'x') && isprop(data,'y'))
    if ndims(data.value)==2
        photonenergy=0;
        if isfield(data,'info')
            if isfield(data.info,'PhotonEnergy')
                photonenergy=data.info.PhotonEnergy;
            end
        end
        output = ExportAsScientaData( filename, data.x, data.y, data.value, photonenergy );
        return
    end
end
output=0;
end

