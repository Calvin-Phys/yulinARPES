function dataout = kSpaceConversionFromPolar_v2(datain,cone_angle,cone_angle_azimuthpos,latt_constv,numkx,numky)
%Soleil Conventionthis function will convert datain file with format datain.x = phi
%angle coordinate, datain.y = angular position along analyser (not offseted),
%datain.raw.kinetic = energy kinetic, datain.value = 3D value arranged raw
%INTO dataout.x = kx, dataout.y = ky, dataout.z = kinetic, dataout.value =
%value

%add this condition if you have more data format in polar at different
%beamline
% if ~strcmp(data.info.source,'soleil')
%     dataout = 0; 
%     return
%else     
startconv = tic;
%% constant
ce=1.6021892e-19;
me=9.109534e-31;
h=6.626176e-34;
k_unit=pi/(latt_constv*10^-10);

%% offset (convert all to radians here)
tilt_offset = datain.info.theta(1)* pi/180;
%azimuth_offset = 119 * pi/180; %from Soleil's postdoc
cone_angle = (cone_angle) * pi/180 - tilt_offset; %cone angle offset by the tilt offset
cone_angle_azimuthpos = cone_angle_azimuthpos*pi/180;
datain.x = datain.x * pi/180;
datain.y = datain.y * pi/180;


%% start converting
% preallocating
sizearray = size(datain.value);
sizearea12 = sizearray(1)*sizearray(2);
if numel(sizearray) == 2
    sizearray(3)=1;
end
k_x = zeros(sizearray(1),sizearray(2),sizearray(3));
k_y = zeros(sizearray(1),sizearray(2),sizearray(3));



%*****************************kspace converting
% component on sample plate
k0=(sqrt(2*me*datain.z*ce)*2*pi/h)/k_unit;
k_parplate = sin((datain.y - tilt_offset))' * k0;
k_normplate = cos((datain.y - tilt_offset))' * k0;
% k_slit = sin(datain.y)' * k0;
% k_normslit = cos(datain.y)' * k0;

for i = 1 : size(datain.x,2)
    %rotate azimuth sample plate
    rotazimuth = (cone_angle_azimuthpos - datain.x(i));
    r_azimuth=[[cos(rotazimuth),-sin(rotazimuth),0]',[sin(rotazimuth),cos(rotazimuth),0]',[0,0,1]'];
    %rotate cone and rotate along x axis on it to match the sample
    %direction
    r_cone=[[1,0,0]',[0,cos(cone_angle),sin(cone_angle)]',[0,-sin(cone_angle),cos(cone_angle)]'];
    %total rotation (from sample to slit direction) is to rotate in sample_theta, cone_azimuth then cone
%     r_total =  r_cone*r_azimuth;
r_total =  inv(r_azimuth)*inv(r_cone);
    
    k_x(i,:,:) = r_total(2,1)*k_parplate + r_total(3,1)* k_normplate;
    k_y(i,:,:) = r_total(2,2)* k_parplate  + r_total(3,2)* k_normplate;
%     k_x(i,:,:) = k_slit * r_total(1,2) + k_normslit * r_total(1,3);
%     k_y(i,:,:) = k_slit * r_total(2,2) + k_normslit * r_total(2,3);
    
end
%% to be ignored
%*****************************C shape

if min(k_parplate)>0
    if max(datain.x) - min(datain.x) >= pi
        scenario = 1;
        display('min(k_parplate >0)')
        display('C shape')
        %-------------small portion
        step_y = datain.y(2) - datain.y(1);
        datainy_small = (tilt_offset+0.00001):step_y:(min(datain.y)-0.00001);
        k_parplate_small = sin(( datainy_small - tilt_offset))' * k0;
        k_normplate_small = cos(( datainy_small - tilt_offset))' * k0;
        sizeignored_small12 = (size(datain.x,2)*size(datainy_small,2));
        
        k_x_ignored_small = zeros(sizearray(1),size(datainy_small,2),sizearray(3));
        k_y_ignored_small = zeros(sizearray(1),size(datainy_small,2),sizearray(3));
        
        for i = 1 : size(datain.x,2)
            %rotate azimuth sample plate
            rotazimuth = (cone_angle_azimuthpos - datain.x(i));
            r_azimuth=[[cos(rotazimuth),-sin(rotazimuth),0]',[sin(rotazimuth),cos(rotazimuth),0]',[0,0,1]'];
            %rotate cone and rotate along x axis on it to match the sample
            %direction
            r_cone=[[1,0,0]',[0,cos(cone_angle),sin(cone_angle)]',[0,-sin(cone_angle),cos(cone_angle)]'];
            %total rotation (from sample to slit direction) is to rotate in sample_theta, cone_azimuth then cone
            %     r_total =  r_cone*r_azimuth;
            r_total =  inv(r_azimuth)*inv(r_cone);
            
            k_x_ignored_small(i,:,:) = r_total(2,1)*k_parplate_small + r_total(3,1)* k_normplate_small;
            k_y_ignored_small(i,:,:) = r_total(2,2)* k_parplate_small  + r_total(3,2)* k_normplate_small;
        end
        dataNaN_small = zeros(sizearray(1),size(datainy_small,2),sizearray(3)) - 1000000;
        
        %-------------bigger portion
        step_x = datain.x(2) - datain.x(1);
        dataXignored = (max(datain.x)+0.000001) : step_x : (2*pi-0.00001) ;
        k_x_ignored = zeros(size(dataXignored,2),sizearray(2),sizearray(3));
        k_y_ignored = zeros(size(dataXignored,2),sizearray(2),sizearray(3));
        sizeignored12 = (size(dataXignored,2)*sizearray(2));
        
        
        for i = 1 : size(dataXignored,2)
            %rotate azimuth sample plate
            rotazimuth = (cone_angle_azimuthpos - dataXignored(i));
            r_azimuth=[[cos(rotazimuth),-sin(rotazimuth),0]',[sin(rotazimuth),cos(rotazimuth),0]',[0,0,1]'];
            %rotate cone and rotate along x axis on it to match the sample
            %direction
            r_cone=[[1,0,0]',[0,cos(cone_angle),sin(cone_angle)]',[0,-sin(cone_angle),cos(cone_angle)]'];
            %total rotation (from sample to slit direction) is to rotate in sample_theta, cone_azimuth then cone
            %     r_total =  r_cone*r_azimuth;
            r_total =  inv(r_azimuth)*inv(r_cone);
            
            k_x_ignored(i,:,:) = r_total(2,1)*k_parplate + r_total(3,1)* k_normplate;
            k_y_ignored(i,:,:) = r_total(2,2)* k_parplate  + r_total(3,2)* k_normplate;
        end
        dataNaN = zeros(size(dataXignored,2),sizearray(2),sizearray(3)) - 10000000;
    else
        scenario = 0;
        %-------------small portion ONLY
        step_y = datain.y(2) - datain.y(1);
        datainy_small = (tilt_offset+0.00001):step_y:(min(datain.y)-0.00001);
        k_parplate_small = sin(( datainy_small - tilt_offset))' * k0;
        k_normplate_small = cos(( datainy_small - tilt_offset))' * k0;
        sizeignored_small12 = (size(datain.x,2)*size(datainy_small,2));
        
        k_x_ignored_small = zeros(sizearray(1),size(datainy_small,2),sizearray(3));
        k_y_ignored_small = zeros(sizearray(1),size(datainy_small,2),sizearray(3));
        
        for i = 1 : size(datain.x,2)
            %rotate azimuth sample plate
            rotazimuth = (cone_angle_azimuthpos - datain.x(i));
            r_azimuth=[[cos(rotazimuth),-sin(rotazimuth),0]',[sin(rotazimuth),cos(rotazimuth),0]',[0,0,1]'];
            %rotate cone and rotate along x axis on it to match the sample
            %direction
            r_cone=[[1,0,0]',[0,cos(cone_angle),sin(cone_angle)]',[0,-sin(cone_angle),cos(cone_angle)]'];
            %total rotation (from sample to slit direction) is to rotate in sample_theta, cone_azimuth then cone
            %     r_total =  r_cone*r_azimuth;
            r_total =  inv(r_azimuth)*inv(r_cone);
            
            k_x_ignored_small(i,:,:) = r_total(2,1)*k_parplate_small + r_total(3,1)* k_normplate_small;
            k_y_ignored_small(i,:,:) = r_total(2,2)* k_parplate_small  + r_total(3,2)* k_normplate_small;
        end
        dataNaN_small = zeros(sizearray(1),size(datainy_small,2),sizearray(3)) - 1000000;
    end
    
elseif min(k_parplate)<0
    display('min(k_parplate<0)')
    % ***************************** pacman
    if (max(datain.x) - min(datain.x))>pi %pacman shape!!
        scenario = 2;
        display('pacman')
        % ------------- bigger portion (pizza shape (bigger))
        step_x = datain.x(2) - datain.x(1);
        dataXignored = (max(datain.x)+0.00001) : step_x : (2*pi-0.00001);
        k_parplate_trunc = k_parplate(k_parplate>abs(min(k_parplate)));
        k_normplate_trunc = k_normplate(k_parplate>abs(min(k_parplate)));
    
        k_x_ignored = zeros(size(dataXignored,2),size(k_parplate_trunc',2),sizearray(3));
        k_y_ignored = zeros(size(dataXignored,2),size(k_parplate_trunc',2),sizearray(3));
        sizeignored12 = (size(dataXignored,2)*size(k_parplate_trunc',2));
        
        
        for i = 1 : size(dataXignored,2)
            %rotate azimuth sample plate
            rotazimuth = (cone_angle_azimuthpos - dataXignored(i));
            r_azimuth=[[cos(rotazimuth),-sin(rotazimuth),0]',[sin(rotazimuth),cos(rotazimuth),0]',[0,0,1]'];
            %rotate cone and rotate along x axis on it to match the sample
            %direction
            r_cone=[[1,0,0]',[0,cos(cone_angle),sin(cone_angle)]',[0,-sin(cone_angle),cos(cone_angle)]'];
            %total rotation (from sample to slit direction) is to rotate in sample_theta, cone_azimuth then cone
            %     r_total =  r_cone*r_azimuth;
            r_total =  inv(r_azimuth)*inv(r_cone);
            
            k_x_ignored(i,:,:) = r_total(2,1)*k_parplate_trunc + r_total(3,1)* k_normplate_trunc;
            k_y_ignored(i,:,:) = r_total(2,2)* k_parplate_trunc  + r_total(3,2)* k_normplate_trunc;
        end
        dataNaN = zeros(size(dataXignored,2),size(k_parplate_trunc',2),sizearray(3)) - 10000000;
        
        %-------------small portion we ignore this altogether, the number put is just
        %for dummy
        sizeignored_small12 = 1;
        k_x_ignored_small = 1;
        k_y_ignored_small = 1;
        dataNaN_small = 1;
        
        
    elseif (max(datain.x) - min(datain.x))<pi 
        %*****************************fan shape
        display('fan shape')
        scenario = 3;
        % ------------- big portion (pizza shape (on right side))
        step_x = datain.x(2) - datain.x(1);
        dataXignored = (max(datain.x)+0.00001) : step_x : pi-0.0001;
        k_parplate_trunc = k_parplate; %(no truncate)
        k_normplate_trunc = k_normplate; %no truncate too
    
        k_x_ignored = zeros(size(dataXignored,2),size(k_parplate_trunc',2),sizearray(3));
        k_y_ignored = zeros(size(dataXignored,2),size(k_parplate_trunc',2),sizearray(3));
        sizeignored12 = (size(dataXignored,2)*size(k_parplate_trunc',2));
        
        
        for i = 1 : size(dataXignored,2)
            %rotate azimuth sample plate
            rotazimuth = (cone_angle_azimuthpos - dataXignored(i));
            r_azimuth=[[cos(rotazimuth),-sin(rotazimuth),0]',[sin(rotazimuth),cos(rotazimuth),0]',[0,0,1]'];
            %rotate cone and rotate along x axis on it to match the sample
            %direction
            r_cone=[[1,0,0]',[0,cos(cone_angle),sin(cone_angle)]',[0,-sin(cone_angle),cos(cone_angle)]'];
            %total rotation (from sample to slit direction) is to rotate in sample_theta, cone_azimuth then cone
            %     r_total =  r_cone*r_azimuth;
            r_total =  inv(r_azimuth)*inv(r_cone);
            
            k_x_ignored(i,:,:) = r_total(2,1)*k_parplate_trunc + r_total(3,1)* k_normplate_trunc;
            k_y_ignored(i,:,:) = r_total(2,2)* k_parplate_trunc  + r_total(3,2)* k_normplate_trunc;
        end
        dataNaN = zeros(size(dataXignored,2),size(k_parplate_trunc',2),sizearray(3)) - 10000000;
        
        % ------------- small portion (pizza shape on left side)
        dataXignored_small = pi+max(datain.x)+0.0001 : step_x : 0-0.0001;
    
        k_x_ignored_small = zeros(size(dataXignored_small,2),size(k_parplate_trunc',2),sizearray(3));
        k_y_ignored_small = zeros(size(dataXignored_small,2),size(k_parplate_trunc',2),sizearray(3));
        sizeignored_small12 = (size(dataXignored_small,2)*size(k_parplate_trunc',2));
        
        
        for i = 1 : size(dataXignored_small,2)
            %rotate azimuth sample plate
            rotazimuth = (cone_angle_azimuthpos - dataXignored_small(i));
            r_azimuth=[[cos(rotazimuth),-sin(rotazimuth),0]',[sin(rotazimuth),cos(rotazimuth),0]',[0,0,1]'];
            %rotate cone and rotate along x axis on it to match the sample
            %direction
            r_cone=[[1,0,0]',[0,cos(cone_angle),sin(cone_angle)]',[0,-sin(cone_angle),cos(cone_angle)]'];
            %total rotation (from sample to slit direction) is to rotate in sample_theta, cone_azimuth then cone
            %     r_total =  r_cone*r_azimuth;
            r_total =  inv(r_azimuth)*inv(r_cone);
            
            k_x_ignored_small(i,:,:) = r_total(2,1)*k_parplate_trunc + r_total(3,1)* k_normplate;
            k_y_ignored_small(i,:,:) = r_total(2,2)* k_parplate_trunc  + r_total(3,2)* k_normplate;
        end
        dataNaN_small = zeros(size(dataXignored_small,2),size(k_parplate_trunc',2),sizearray(3)) - 10000000;
    end
else
    %-------------small portion we ignore this altogether, the number put is just
        %for dummy
        sizeignored12 = 1;
        k_x_ignored = 1;
        k_y_ignored = 1;
        dataNaN = 1;
        %-------------small portion we ignore this altogether, the number put is just
        %for dummy
        sizeignored_small12 = 1;
        k_x_ignored_small = 1;
        k_y_ignored_small = 1;
        dataNaN_small = 1;
end

%% reshaping each energy level with mesh
minkx = min(min(min(k_x)));
minky = min(min(min(k_y)));
maxkx = max(max(max(k_x)));
maxky = max(max(max(k_y)));

dataout = datain;
dataout.x = linspace(minkx,maxkx,numkx);
dataout.y = linspace(minky,maxky,numky);
valuedummy = zeros(numkx,numky,sizearray(3));

[meshx, meshy] = meshgrid(dataout.x,dataout.y);
datainvaluedummy = datain.value;

%to exclude somedata, this is only true for no cone angle data
% k_radius = min(k_parplate);
% anglegrid = atan2(-meshx,meshy);
% posanglegrid = anglegrid>0;
% neganglegrid = anglegrid<0;
% anglegrid = anglegrid .* posanglegrid + (2*pi + anglegrid) .* neganglegrid;
% ok_index =  (anglegrid < (max(datain.x) - cone_angle_azimuthpos)) + ((2*pi - cone_angle_azimuthpos) < anglegrid) ;

startdata = tic;
display('doing parfor data')  
parfor i = 1:size(dataout.z,2)
    %reshape into 1D array for griddata 
    x1 = reshape(k_x(:,:,i),1,sizearea12); 
    y1 = reshape(k_y(:,:,i),1,sizearea12);
    v1 = reshape(datainvaluedummy(:,:,i),1,sizearea12);
    
    valuedummy(:,:,i) = (griddata(x1,y1,v1,meshx,meshy))';
end
toc(startdata)


ignored1 = tic;
display('doing parfor data ignored data 1')
parfor i = 1:size(dataout.z,2)
    %ignored value
    %small
    x1ig_small = reshape(k_x_ignored_small(:,:,i),1,sizeignored_small12);
    y1ig_small = reshape(k_y_ignored_small(:,:,i),1,sizeignored_small12);
    v1ig_small = reshape(dataNaN_small(:,:,i),1,sizeignored_small12);
    
    valuedummyig_small(:,:,i) = (griddata(x1ig_small,y1ig_small,v1ig_small,meshx,meshy))';
end
toc(ignored1)

if scenario ~=0
    ignored2 = tic;
    display('doing parfor data ignored data 2')
    parfor i = 1:size(dataout.z,2)
        % bigger
        x1ig = reshape(k_x_ignored(:,:,i),1,sizeignored12);
        y1ig = reshape(k_y_ignored(:,:,i),1,sizeignored12);
        v1ig = reshape(dataNaN(:,:,i),1,sizeignored12);
        valuedummyig(:,:,i) = (griddata(x1ig,y1ig,v1ig,meshx,meshy))';
    end
    toc(ignored2)
end
%% start modifying the three big pieces we have. We have the original data, and we have two blocks we ignore. I call that big and small. Check power point for more presentation.
% the ignored part is set to be either zero or with negative numbers, no
% NaN inside

if scenario ~=0
    valuedummyig(isnan(valuedummyig)) = 0;
    if isempty(valuedummyig)
        valuedummyig = zeros(numkx,numky,size(datain.z,2));
    end
    valuedummy = valuedummy + valuedummyig;
end

valuedummyig_small(isnan(valuedummyig_small)) = 0;
if isempty(valuedummyig_small)
    valuedummyig_small = zeros(numkx,numky,size(datain.z,2));
end
%final combination for the original data and the ignored parts

if scenario ~=0
    valuedummy = valuedummy + valuedummyig_small;
    valuedummy(valuedummy<0) = NaN;
    
    dataout.value = valuedummy;
elseif scenario == 0
    dataout.value = valuedummy;
end
    


toc(startconv)
end
  
