function data_ans = ridge_detection_3_standalone(data,...
    radius, tol, thres, gamma, use_cuda)
% Arguments:
% data: struct, the std data structure of chen group;
% radius: int, radius of gaussian blur, number in k space;
% tol: double, tolerence for ridge detection equality check;
% thres: double, threshold for rejecting blunt ridges;
% gamma: double, gamma value to modulate the representation of the sharpness of ridge;

% Returns:
% data_ans: struct, the std data structure of chen group;

% gaussian convolution to smooth the image
mat_source = data.value;
delta_x = abs(data.x(2) - data.x(1));
delta_y = abs(data.y(2) - data.y(1));
delta_z = abs(data.z(2) - data.z(1));
if use_cuda == true
    mat_source = gpuArray(double(mat_source));
else
    mat_source = double(mat_source);
end
sigma = [radius / delta_x, radius / delta_y, radius / delta_z];
mat_smooth = imgaussfilt3(mat2gray(mat_source), sigma);
% generate the 3*3*3 moved matrix
% the commented lines are moved matrix not in use
[x_index_max, y_index_max, z_index_max] = size(mat_smooth);
% map111 = mat_smooth( 1:(end-2), 1:(end-2), 1:(end-2) );
map112 = mat_smooth( 1:(end-2), 1:(end-2), 2:(end-1) );
% map113 = mat_smooth( 1:(end-2), 1:(end-2), 3:(end-0) );
map121 = mat_smooth( 1:(end-2), 2:(end-1), 1:(end-2) );
map122 = mat_smooth( 1:(end-2), 2:(end-1), 2:(end-1) );
map123 = mat_smooth( 1:(end-2), 2:(end-1), 3:(end-0) );
% map131 = mat_smooth( 1:(end-2), 3:(end-0), 1:(end-2) );
map132 = mat_smooth( 1:(end-2), 3:(end-0), 2:(end-1) );
% map133 = mat_smooth( 1:(end-2), 3:(end-0), 3:(end-0) );
map211 = mat_smooth( 2:(end-1), 1:(end-2), 1:(end-2) );
map212 = mat_smooth( 2:(end-1), 1:(end-2), 2:(end-1) );
map213 = mat_smooth( 2:(end-1), 1:(end-2), 3:(end-0) );
map221 = mat_smooth( 2:(end-1), 2:(end-1), 1:(end-2) );
map222 = mat_smooth( 2:(end-1), 2:(end-1), 2:(end-1) );
map223 = mat_smooth( 2:(end-1), 2:(end-1), 3:(end-0) );
map231 = mat_smooth( 2:(end-1), 3:(end-0), 1:(end-2) );
map232 = mat_smooth( 2:(end-1), 3:(end-0), 2:(end-1) );
map233 = mat_smooth( 2:(end-1), 3:(end-0), 3:(end-0) );
% map311 = mat_smooth( 3:(end-0), 1:(end-2), 1:(end-2) );
map312 = mat_smooth( 3:(end-0), 1:(end-2), 2:(end-1) );
% map313 = mat_smooth( 3:(end-0), 1:(end-2), 3:(end-0) );
map321 = mat_smooth( 3:(end-0), 2:(end-1), 1:(end-2) );
map322 = mat_smooth( 3:(end-0), 2:(end-1), 2:(end-1) );
map323 = mat_smooth( 3:(end-0), 2:(end-1), 3:(end-0) );
% map331 = mat_smooth( 3:(end-0), 3:(end-0), 1:(end-2) );
map332 = mat_smooth( 3:(end-0), 3:(end-0), 2:(end-1) );
% map333 = mat_smooth( 3:(end-0), 3:(end-0), 3:(end-0) );
% calculate the numerical gradient
gradient_x = (map322 - map122) / (2.0 * delta_x);
gradient_y = (map232 - map212) / (2.0 * delta_y);
gradient_z = (map223 - map221) / (2.0 * delta_z);
% calculate the numerical hessian
hessian_xx = (map322 + map122 - 2.0 * map222) / (delta_x ^ 2);
hessian_yy = (map232 + map212 - 2.0 * map222) / (delta_y ^ 2);
hessian_zz = (map223 + map221 - 2.0 * map222) / (delta_z ^ 2);
hessian_xy = (map332 + map112 - map132 - map312) / (4 * delta_x * delta_y);
hessian_xz = (map323 + map121 - map123 - map321) / (4 * delta_x * delta_z);
hessian_yz = (map233 + map211 - map213 - map231) / (4 * delta_y * delta_z);
% compute the mat_ans in a parallel way
mat_relative = zeros(x_index_max - 2, y_index_max - 2, z_index_max - 2);
tol_mat_slice = ones(x_index_max - 2, y_index_max - 2) * tol;
thres_mat_slice = ones(x_index_max - 2, y_index_max - 2) * thres;
parfor k = 1:(z_index_max - 2)
    mat_relative(:,:,k) = arrayfun(@is_ridge,...
    gradient_x(:,:,k), gradient_y(:,:,k), gradient_z(:,:,k),...
    hessian_xx(:,:,k), hessian_yy(:,:,k), hessian_zz(:,:,k),...
    hessian_xy(:,:,k), hessian_xz(:,:,k), hessian_yz(:,:,k),...
    tol_mat_slice, thres_mat_slice);
end
% gamma modulation
mat_ans = mat2gray(mat_relative).^gamma;
% construct data struct
data_ans.value = mat_ans;
data_ans.x = data.x(2:(end-1));
data_ans.y = data.y(2:(end-1));
data_ans.z = data.z(2:(end-1));

% function to check the ridge condition
function pixel_value = is_ridge(gradient_x, gradient_y, gradient_z,...
    hessian_xx, hessian_yy, hessian_zz,...
    hessian_xy, hessian_xz, hessian_yz,...
    tol, thres)
hessian = [hessian_xx, hessian_xy, hessian_xz;...
           hessian_xy, hessian_yy, hessian_yz;...
           hessian_xz, hessian_yz, hessian_zz];
gradient = [gradient_x, gradient_y, gradient_z];
[eigenvectors, diagonal_mat] = eig(hessian);
eigenvalues = diag(diagonal_mat);
if eigenvalues(1) < 0 && abs(gradient * eigenvectors(:,1))<tol && abs(eigenvalues(1)) > thres
    pixel_value = abs(eigenvalues(1));
else
    pixel_value = 0;
end


