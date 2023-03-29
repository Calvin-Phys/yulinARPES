function is3DARPESData( data3D )
%IS3DARPESDATA Summary of this function goes here
%   Detailed explanation goes here
if ~isfield(data3D,'value')
    error('data3D should be ARPES data.')
end
if ndims(data3D.value)~=3
    error('data3D should be 3D ARPES data.')
end

