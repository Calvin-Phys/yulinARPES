function dataout=kzconversion(datain, latt_constva,latt_constvc,meffective,v0,numofkpar,numofkz,offset,theta_offsetv,theta_positionv)
%modified by Sandy
%this function converts datain with datain.x=Ek at lowest data (Diamond's convention, check the data), datain.y = angle, datain.z=binding energy, datain.ztot = array of Ek at each given x (or given photon energy) to
%dataout.x=kz, dataout.y=k||. meffective is the effective mass of final
%state electron %(in unit of me). v0 is the inner potential,  numofkpar is
%# of k||
%channels and numofkz is # of kz channels. offset is the angle offset, Eph
%is the photon energy of the cut

%assumption = same level in energy window refers to same level of 'energy
%level' --> which is wrong remembering the fermi energy level in the energy window (NOTE: not energy value) is decreasing with
%higher photon energy

ce=1.6021892e-19;
me=9.109534e-31;
h=6.626176e-34;

latt_constva=latt_constva*1e-10;
latt_constvc=latt_constvc*1e-10;

k_unita=pi/latt_constva;
k_unitc=pi/latt_constvc;

size_x=size(datain.x,2);
size_y=size(datain.y,2);
size_z=size(datain.z,2);


%--------convert points to k space---------------

%creating dummy cell
%take slice at "equal energy level"

%Edifference = initial_photon - datain.x(1);
% step_z = (max(datain.z) - min(datain.z)) / size_z;
dummyslice = cell(1,size(datain.z,2));
dummyslice2 = dummyslice;
dummyslice3 = dummyslice;

kpar_min_array = zeros(1,size(datain.z,2));
kpar_max_array = kpar_min_array;
kzz_min_array = kpar_min_array;
kzz_max_array = kpar_min_array;

%dummy.photon = datain.x + Edifference;

display('setting dummy slice')
for k = 1:size(datain.z,2) 
    dummy.y = datain.y*pi/180;
    
%    smallestEk = min(datain.ztot);
%    dummy.x = smallestEk  + (k-1)*step_z;
    dummy.x = datain.ztot(k,:);
    dummy.value = datain.value(:,:,k);
    dummyslice{k} = dummy;
end
display('dummy slice done')


display('doing parfor loop')
tic
parfor k = 1:size(datain.z,2)   
    dummyslice2{k} = KzConv.Eslice_conversion(dummyslice{k}, latt_constva,latt_constvc,meffective,v0,offset,theta_offsetv,theta_positionv);
    kx1{k} = dummyslice2{k}.kx1;
    kpar_min_array(k) = dummyslice2{k}.kpar_min;
    kpar_max_array(k) = dummyslice2{k}.kpar_max;
    kzz_min_array(k) = dummyslice2{k}.kzz_min;
    kzz_max_array(k) = dummyslice2{k}.kzz_max;
end
toc
display('parfor loop done')

kpar_min = min(kpar_min_array);
kpar_max = max(kpar_max_array);
kzz_min = min(kzz_min_array);
kzz_max = max(kzz_max_array);

dataout.x = linspace(kzz_min,kzz_max,numofkz);
dataout.y = linspace(kpar_min,kpar_max,numofkpar);
dataout.info = datain.info;

display('finalslicing')
tic
[xgrid,ygrid] = ndgrid(dataout.x,dataout.y);

%dataout.value = zeros(numofkz,numofkpar,size(datain.z,2));
%F=cell(1,size(datain.z,2));
F1 = zeros(numofkz,numofkpar,size(datain.z,2));

%dataout.value=griddata(kxx,kzz,eee,dataout.x,dataout.y');

display('doing parfor')
parfor k =1:size(datain.z,2)
%    F{k}=scatteredInterpolant((dummyslice2{k}.kzz)', (dummyslice2{k}.kpar)', (dummyslice2{k}.value)');
%    F1(:,:,k)=F{k}(xgrid,ygrid);
F1(:,:,k) = griddata(dummyslice2{k}.kzz, dummyslice2{k}.kpar, dummyslice2{k}.value, xgrid, ygrid);
end
display('parfor done')

toc

dataout.value = F1;
dataout.z = datain.z;
dataout.kx1 = kx1;

display('kz conv done')

load chirp;
sound(y, Fs);


end



