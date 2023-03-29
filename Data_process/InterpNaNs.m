function data_inan=InterpNaNs(data)
%InterpNaNs Summary of this function goes here
%   Detailed explanation goes here
% data: 2D or 3D
di=ndims(data.value);
data_inan=data;
if di==2
    data_inan.value=inpaint_nans(data.value);
elseif di==3
    for j=1:size(data.value,3)
        data_inan.value(:,:,j)=inpaint_nans(data.value(:,:,j));
    end
end


end

