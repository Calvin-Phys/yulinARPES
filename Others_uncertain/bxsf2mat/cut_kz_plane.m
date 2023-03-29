function [ kz_plane_data ] = cut_kz_plane( raw4D_data,kz_direction, kz_plane_intercept,length_kz_cut_plane_side,resolution_cut )
%CUT_KZ_PLANE Summary of this function goes here
%   Detailed explanation goes here

% load 4D data


if norm(kz_direction-[0 0 1])<0.001
    [~,kz_index]=min(abs(raw4D_data.kz-kz_plane_intercept));
    raw4D_data.kz=raw4D_data.kz(kz_index);
%     kz_cut_data=raw_data;
%     kz_cut_data.kz=kz_cut_data.kz(kz_index);
    for ii=1:raw4D_data.N_band
    raw4D_data.E{ii}=squeeze(raw4D_data.E{ii}(:,:,kz_index));
    end
    plane=createPlane(kz_plane_intercept*kz_direction,kz_direction);
else
    % build list of 3D points forming 2D plane by defining
    % orthogonal vectors to g_hkl vector. Choose first vector as projection of
    % the z-axis to the new plane (only seems to work for other planes than 
    % 1 0 0, 0 1 0, 0 0 1 
    origin_plane=kz_plane_intercept*kz_direction;
    plane=createPlane(origin_plane,kz_direction);
    kz_point=projPointOnPlane([0 0 1],plane);
    ky_2D_unit=round(kz_point-origin_plane,5);%needs better normalization
    ky_2D_unit=ky_2D_unit./norm(ky_2D_unit);
    kx_2D_unit=cross(kz_direction,ky_2D_unit);%needs normalization

    % generate meshgrid of coordinate vectors for new 2D plane system
    kx_ky_vectors=linspace(-length_kz_cut_plane_side,length_kz_cut_plane_side,resolution_cut);
    [X,Y]=meshgrid(kx_ky_vectors);
    origin_offset=ones(numel(X),1);

    % with the coordinate vectors and 3D basis vectors of plane, construct set
    % of 3D points that are evenly spaced on the plane
    temp=X(:)*kx_2D_unit+Y(:)*ky_2D_unit+origin_offset(:)*origin_plane;
    kx_2D=kx_ky_vectors*norm(kx_2D_unit);
    ky_2D=kx_ky_vectors*norm(ky_2D_unit);

    [KX,KY,KZ]=meshgrid(raw4D_data.kx,raw4D_data.ky,raw4D_data.kz);
    for ii=1:raw4D_data.N_band
        data_2D_plane=interp3(KX,KY,KZ, raw4D_data.E{ii},temp(:,1),temp(:,2),temp(:,3));  
        raw4D_data.E{ii}=reshape(data_2D_plane,length(kx_2D), length(ky_2D));
    end
    raw4D_data.kx=kx_2D;
    raw4D_data.ky=ky_2D;
    raw4D_data.kz=kz_plane_intercept;
end
kz_plane_data.kx=raw4D_data.kx;
kz_plane_data.ky=raw4D_data.ky;
kz_plane_data.kz=raw4D_data.kz;
kz_plane_data.kz_plane=plane;
kz_plane_data.E=raw4D_data.E;

end

