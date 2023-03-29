function getEDCFromVariable(obj,varargin)
direction=get(obj.SelectDirection,'String');
num=get(obj.SelectDirection,'Value');
direction=direction{num};

DataName=getDataNames;
DataName=DataName{1};
data=evalin('base',DataName);
%% Check input data
if ~isfield(data,'value')
    errordlg(['Input should be an ARPES EDC data.',...
        'data.value missing']);
    return;
end
if ~ismatrix(data.value)
    errordlg(['Input should be an ARPES EDC data.',...
        'data.value should be 1xN array']);
    return;
end
if ismatrix(data.value)
    if min(size(data.value))~=1
        errordlg(['Input should be an ARPES EDC data.',...
            'data.value should be 1xN array']);
        return;
    end
end
% End of check input data

%% Get data
switch direction
    case 'x-y'
        obj.Data.x=data.x;
        obj.Data.y=data.value/max(data.value(:));
    case 'y-x'
        obj.Data.x=data.value/max(data.value(:));
        obj.Data.y=data.x;
end
% end of get data
obj.plot;
end