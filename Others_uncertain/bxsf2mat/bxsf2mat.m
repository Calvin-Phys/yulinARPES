function [mat_data]=bxsf2mat(bxsf_rawdata,no_interpolation_points,interpolation_length,alignment_vector)
%bxsf2mat interpolates bxsf data (which is generally in a non-orthoginal)
%into orthogonal cartesian coordinates in inverse Angstroms
%   bxsf_rawdata is in the format specified by Teng's loader, as given by
%   load_bxsf

% fundamental idea: start with cartesian coordinates, then transform them
% into coodinates of reciprocal lattice vectors and interpolate in that
% system

% if we would start with the coordinate vectors[1 0 0] [0 1 0] [0 0 1] the
% transformation matrix would take the form:
% matrix_bxsf_vect=[bxsf_rawdata.v1' bxsf_rawdata.v2' bxsf_rawdata.v3'];
% however, to simplify the subsequent plotting, we choose a cartesian
% coordinate system that has the z axis aligned with the last vector if the
% bxsf reciprocal lattice file. Thus, we will need to rotate the reciprocal
% lattice vectors of the bxsf file such that the third vector is aligned
% with the z axis

% load bxsf vectors
b_1=bxsf_rawdata.v1';
b_2=bxsf_rawdata.v2';
b_3=bxsf_rawdata.v3';

% build a transformation matrix to align the data along a preferred axis
alignment_vector=alignment_vector(1)*b_1+alignment_vector(2)*b_2+alignment_vector(3)*b_3;
[azimuth,elevation,~] = cart2sph(alignment_vector(1),alignment_vector(2),alignment_vector(3));
First_trafo_matrix=roty(rad2deg(elevation)-90)*rotz(-rad2deg(azimuth));

%transform vectors and copy them to the file
matrix_bxsf_vect=First_trafo_matrix*[b_1,b_2,b_3];
bxsf_rawdata.v1=matrix_bxsf_vect(:,1);
bxsf_rawdata.v2=matrix_bxsf_vect(:,2);
bxsf_rawdata.v3=matrix_bxsf_vect(:,3);

%invert the matrix to get trafo from cartesian to bxfs vectos
trafo_matrix_cart_2_bxsf_vect_space=inv(matrix_bxsf_vect);

% create cartesian meshgrid
cartesian_length_vect=linspace(-1*interpolation_length,1*interpolation_length,no_interpolation_points); %here we use cube with side length 2
[X_1,Y_1,Z_1] = meshgrid(cartesian_length_vect,...
    cartesian_length_vect,...
    cartesian_length_vect);

% Create an N x 3 matrix of coordinates
points_cartesian = [X_1(:), Y_1(:), Z_1(:)];

% Transform the coordinates
% points_transformed =  trafo_matrix_cart_2_bxsf_vect_space * points_cartesian (there was a major bug here earlier that had this product the other way around ;
points_transformed = (trafo_matrix_cart_2_bxsf_vect_space * points_cartesian')';

mat_data=bxsf_rawdata;
mat_data.kx=cartesian_length_vect;
mat_data.ky=cartesian_length_vect;
mat_data.kz=cartesian_length_vect;
mat_data.N_band_E_range=num2cell(mat_data.E_range,2);

% compile list of bands crossing Ef
band_numbers_crossing_Ef=[];
for ii=1:mat_data.N_band
    if (mat_data.Ef<max(mat_data.N_band_E_range{ii})) && (mat_data.Ef>min(mat_data.N_band_E_range{ii}))
    band_numbers_crossing_Ef=[band_numbers_crossing_Ef,ii];
    end;
end;
mat_data.band_numbers_crossing_Ef=band_numbers_crossing_Ef;


% clean fields from Teng's data 
mat_data=rmfield(mat_data,{'Nx','Ny','Nz','G0','E_range'});


%generate normalized meshgrid for interpolation (since we are in the
%non-orthogonal space, which is now treated as a cartesian cube)
cartesian_length_vect1=linspace(-2,2,4*bxsf_rawdata.Nx-3); %range goes from -2 to 2 since we extend to larger cube during interpolation
cartesian_length_vect2=linspace(-2,2,4*bxsf_rawdata.Ny-3); %note that -3 originates from not counting the boundary between cubes twice
cartesian_length_vect3=linspace(-2,2,4*bxsf_rawdata.Nz-3);

[X,Y,Z] = ndgrid(cartesian_length_vect1,...
    cartesian_length_vect2,...
    cartesian_length_vect3);
for ii=1:bxsf_rawdata.N_band
    %// interpolate the energies of the transformed cartesian coordinates.
    
    %copy the raw data that is defined over positive quadrant kx=[0
    %1],ky=[0 1],kz=[0 1] to full quadrant kx=[-2
    %2],ky=[-2 2],kz=[-2 2]. since bxsf data is using general grids, not
    %periodic ones (see section "bandgrids" in http://www.xcrysden.org/doc/XSF.html
    % we will need to avoid copying the redundant boundary of the data grid
    % twice, hence the subsequent 2:end parts of the code
    tmp=bxsf_rawdata.E{ii};
    tmp=cat(1,tmp,tmp(2:end,:,:));
    tmp=cat(2,tmp,tmp(:,2:end,:));
    tmp=cat(3,tmp,tmp(:,:,2:end));
    tmp=cat(1,tmp,tmp(2:end,:,:));
    tmp=cat(2,tmp,tmp(:,2:end,:));
    tmp=cat(3,tmp,tmp(:,:,2:end));

    
    % now interpolation happens on enlarged grid
    data_cartesian=interpn(X,Y,Z, tmp, points_transformed(:,1), points_transformed(:,2), points_transformed(:,3));
    mat_data.E{ii}=reshape(data_cartesian,[no_interpolation_points,no_interpolation_points,no_interpolation_points]);
    mat_data.E{ii}=mat_data.E{ii}-mat_data.Ef;
end;
a=5;
end
