function [ raw_data ] = symmetrize_mat( raw_data )
%SYMMETRIZE_MAT Summary of this function goes here
%   Detailed explanation goes here
if ~isfield(raw_data, 'already_symmetrized')
    raw_data.kx=[-1.*flip(raw_data.kx(2:end)) raw_data.kx];
    raw_data.ky=[-1.*flip(raw_data.ky(2:end)) raw_data.ky];
    raw_data.kz=[-1.*flip(raw_data.kz(2:end)) raw_data.kz];
    for ii=1:raw_data.N_band;
         raw_data.E{ii}=cat(2,fliplr(raw_data.E{ii}),raw_data.E{ii}(:,2:end,:));
         raw_data.E{ii}=cat(1,flipud(raw_data.E{ii}),raw_data.E{ii}(2:end,:,:));
         raw_data.E{ii}=cat(3,flip(raw_data.E{ii},3),raw_data.E{ii}(:,:,2:end));

    end;
end

    %set switch that shows that the data was already symmetrized
    raw_data.already_symmetrized=1;

end

