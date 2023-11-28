function dataout=kzconversionV4(datain, latt_constva,latt_constvc,meffective,v0,numofkpar,numofkz,offset,theta_offsetv,theta_positionv)
%modified by Sandy
%this function converts datain with datain.x=Ek at lowest data (Diamond's 
% convention, check the data) or Photon Energy (doesnt matter), datain.y = angle, 
% datain.z=binding energy, datain.ztot = array of Ek at each given x (or 
% given photon energy) to
%dataout.x=kz, dataout.y=k||. meffective is the effective mass of final
%state electron %(in unit of me). v0 is the inner potential,  numofkpar is
%# of k||
%channels and numofkz is # of kz channels. offset is the angle offset, Eph
%is the photon energy of the cut

%assumption = same level in energy window refers to same level of 'energy
%level'

ce=1.6021892e-19;
me=9.109534e-31;
h=6.626176e-34;

offset = offset*pi/180;
latt_constva=latt_constva*1e-10; %converted
latt_constvc=latt_constvc*1e-10; %converted

k_unita=pi/latt_constva;
k_unitc=pi/latt_constvc;

size_x=size(datain.x,2);
size_y=size(datain.y,2);
size_z=size(datain.z,2);


%--------convert points to k space---------------
%slit_angle = zeros(size_x,size_y,size_z);
%ztot_slice = zeros(size_x,size_y,size_z);
kpar = zeros(size_x,size_y,size_z);
kz = zeros(size_x,size_y,size_z);

tic
display('doing kz conversion')
if ~isfield(datain,'ztot')
    xtot=repmat(datain.x-4.7,[length(datain.z),1]);
    ztot=repmat(datain.z',[1,length(datain.x)]);
    datain.ztot = ztot+xtot;
end

ztot_total_array = reshape(datain.ztot,[size_x*size_z,1])';
[slit_angle,ztot_slice] = ndgrid(datain.y,ztot_total_array);
slit_angle = slit_angle*pi/180; %angle deg to rad
kpar = (sqrt(2*me*ztot_slice*ce)*2*pi/h)/k_unita.*sin(slit_angle-offset);
kz = sqrt((2*pi/h)^2*2*me*meffective*(ztot_slice+v0)*ce - (kpar.*k_unita).^2) / k_unitc;

kpar = permute(reshape(kpar,[size_y,size_z,size_x]),[3 1 2]);
kz = permute(reshape(kz,[size_y,size_z,size_x]),[3 1 2]);

if isreal(kz) == 0
    errordlg('kzz imaginary');
    return;
end

total_array = size_x*size_y*size_z;
kpar_array = reshape(kpar,total_array,1); %column format
kz_array = reshape(kz,total_array,1); %column format
eee = reshape(datain.value, [size_x*size_y, size_z]);


%dataout format
dataout.x=linspace(min(kz_array),max(kz_array),numofkz);
Nx = size(dataout.x,2);
dataout.y=linspace(min(kpar_array),max(kpar_array),numofkpar);
Ny = size(dataout.y,2);
dataout.z=datain.z;
Nz = size(datain.z,2);
dataout.value=zeros(Nx,Ny,Nz);



% Build Unit Grid
[kzGrid,kparGrid] = ndgrid(dataout.x,dataout.y);

%do triangulation on each slices

tic

kz_array = reshape(kz,size_x*size_y,size_z);%kz_array = reshape(kz(:,:,i),size_x*size_y,1);
kpar_array = reshape(kpar,size_x*size_y,size_z);%kpar_array = reshape(kpar(:,:,i),size_x*size_y,1);

%build quiries array
kzGrid_array = kzGrid(:);
kparGrid_array = kparGrid(:);


%triangular positioning
tri = delaunayTriangulation(kz_array(:,1), kpar_array(:,1)); %triangulation class
12
t_element = tri(:, :); %return the vertex group that create one triangle on each row
[ti, bc] = pointLocation(tri, [kzGrid_array, kparGrid_array]); %return the row in tri about where the kGrid are with respect to the element and the relatif coordinate (bc)
ti(isnan(ti)) = size_x*size_y+1; %for the element asked outside of the triangles, they put NaN, so we replace with this "anyhow" number to say it is outside
% Interpolation
pt = t_element(ti,:); %return the element where our enquired points are
%obtain the value on each assigned element

triVals3D_1 = eee(pt(:,1),:);
triVals3D_2 = eee(pt(:,2),:);
triVals3D_3 = eee(pt(:,3),:);

%prepare the relative coordinate
bc_1 = repmat(bc(:,1),[1,size_z]);
bc_2 = repmat(bc(:,2),[1,size_z]);
bc_3 = repmat(bc(:,3),[1,size_z]);

%interpolate the value
InterpolatedGrid = bc_1.*triVals3D_1 ...
    +bc_2.*triVals3D_2 ...
    + bc_3.*triVals3D_3;
% Interpolation to gridded data --- no way to do that
DummyValue = reshape(InterpolatedGrid,[Nx,Ny,size_z]);
step_z = abs(datain.ztot(1,1)-datain.ztot(2,1)); %energy step

%ddc = zeros(Nx, Ny, size_z);
Value_m = zeros(Nx, Ny, size_z);
for m = 1:size_z
    % Get Gridded data Value2
    kzGrid_shifted = sqrt((kzGrid*k_unitc).^2 + (2*pi/h)^2*2*me*meffective*step_z*ce.*(m-1))/k_unitc; %new enquiry points along kz is shifted
    Value_m(:,:,m) = interp2(kparGrid,kzGrid_shifted,DummyValue(:,:,m),...
        kparGrid,kzGrid);
end

dataout.value = Value_m;

toc

display('kz conv done')

end



