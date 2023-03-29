function data_new=Rearrange2DTo3D(data_list,mapping_by)
%Rearrange2DTo3D Summary of this function goes here
%   Detailed explanation goes here
% data_list: cell array
% mapping_by: 'theta' or 'phi'
n_data=length(data_list);
% check validity
theta=NaN(1,n_data);
theta_offset=zeros(1,n_data);
phi=NaN(1,n_data);
phi_offset=zeros(1,n_data);
vdata_temp=[];
data_new=[];

% Get value matrix
for i=1:n_data
    data=data_list{i};
    
    if ndims(data.value)~=2
        errordlg('Selections contain 3D data.')
        return
    end
    
    if isempty(vdata_temp)
        vdata_temp=data;
        y_min=min(data.x);
        y_max=max(data.x);
    else
        if size(data.value,1)==size(vdata_temp.value,1) ...
                && size(data.value,2)==size(vdata_temp.value,2)
            vdata_temp=data;
            if min(data.x)<y_min
                y_min=min(data.x);
            end
            if max(data.x)>y_max
                y_max=max(data.x);
            end
        else
            errordlg('Dimensions do not match each other.')
            return
        end
    end
    
    if isfield(data,'info')
        if isfield(data.info,'theta')
            theta(i)=data.info.theta;
        end
        if isfield(data.info,'theta_offset')
            theta_offset(i)=data.info.theta_offset;
        end
        if isfield(data.info,'phi')
            phi(i)=data.info.phi;
        else
            phi(i)=0;
        end
        if isfield(data.info,'phi_offset')
            phi_offset(i)=data.info.phi_offset;
        end
    end
end




% data_new=data;
% data_new=rmfield(data_new,'value');
% mapping by theta/phi/index/
if  strcmpi(mapping_by,'index')
    data_new.x = 1:n_data;
    data_new.y = data.x;
    data_new.z = data.y;
    data_new.value = zeros(n_data,size(data.value,1),size(data.value,2));
    for i = 1:n_data
        data_new.value(i,:,:) = data_list{i}.value;
    end
else
    check_theta=isnan(theta);
    check_phi=isnan(phi);
    if sum(check_theta) || sum(check_phi)
        errordlg('Some selections do not have info of theta and phi.')
        return
    end
    
    theta=theta-theta_offset;
    phi=phi-phi_offset;
    switch mapping_by
        case 'phi'
            data_new.x=phi;
            y_shifts=theta-mean(theta);
            data_new.info.theta=mean(theta);
            data_new.info.phi=sort(phi);
        case 'theta'
            data_new.x=theta;
            y_shifts=phi-mean(phi);
            data_new.info.theta=sort(theta);
            data_new.info.phi=mean(phi);
    end
    % in case the angle other than the mapping angle doesn't keep constant
    % (moved in a small range due to motor)
    % Each cut should shift accordingly to make the 3D matrix
    dy=min(diff(vdata_temp.x));
    data_new.y=y_min+min(y_shifts):dy:y_max+max(y_shifts);
    data_new.z=vdata_temp.y;
    [data_new.x,IX]=sort(data_new.x);
    for i=1:n_data
        data=data_list{IX(i)};
        
        [XX,YY]=meshgrid(data.x+y_shifts(IX(i)),data.y);
        [XXX,YYY]=meshgrid(data_new.y,data_new.z);
        data_shift=interp2(XX,YY,data.value',XXX,YYY);
        data_new.value(i,:,:)=data_shift';
    end
end




end

