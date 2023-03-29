function dataout = Eslice_conversion(datain, latt_constva,latt_constvc,meffective,v0,phi_offsetv,theta_offsetv,theta_positionv)
%sandy's program to convert equal energy slice into k_par kz data
%datain.x = Ek array ('same energy level'), datain.y = angle (offset) 

ce=1.6021892e-19;
me=9.109534e-31;
h=6.626176e-34;

%lattice constants were converted in the parent funtion

k_unita=pi/latt_constva;
k_unitc=pi/latt_constvc;

size_x=size(datain.x,2);
size_y=size(datain.y,2);

phi_offsetv = phi_offsetv * pi/180;
theta_offsetv = theta_offsetv * pi/180;
theta_positionv = theta_positionv * pi/180;

%============ start conversion ===============
%kx1 kx11 is to check the deviation along the other component of parallel
%momentum
kpar = zeros(1,size_x*size_y);
kx1 = zeros(1,size_x*size_y);
kx11 = zeros(1,size_x*size_y);
kzz = zeros(1,size_x*size_y);
valuev = zeros(1,size_x*size_y);
k = 1;


% rotation matrix (sandy 150302) (modified for negative angle value ---
% offset = angle and NOT minus angle as Yulin's program
rx=[[1,0,0]',[0,cos(-phi_offsetv),-sin(-phi_offsetv)]',[0,sin(-phi_offsetv),cos(-phi_offsetv)]'];
ry=[[cos(theta_offsetv),0,sin(theta_offsetv)]',[0,1,0]',[-sin(theta_offsetv),0,cos(theta_offsetv)]'];
%rz=[[cos(sample_rotationv),-sin(sample_rotationv),0]',[sin(sample_rotationv),cos(sample_rotationv),0]',[0,0,1]'];
%R=rz*rx*ry;
R = rx*ry;

% (sandy 151213) (modified for several thetaposition)
%modified for non symmetry point analysis
for i = 1:size_x
    for j = 1:size_y
        kx0=sin(theta_positionv)*cos(datain.y(j));
        ky0=sin(datain.y(j));
        kz0=cos(theta_positionv)*cos(datain.y(j));
        
        kx11(k)=R(1,1)*kx0+R(1,2)*ky0+R(1,3)*kz0;
        ky1 = R(2,1)*kx0+R(2,2)*ky0+R(2,3)*kz0;
        
        kx1(k) = (sqrt(2*me*datain.x(i)*ce)*2*pi/h)/k_unita.*kx11(k);
        kpar(k)=(sqrt(2*me*datain.x(i)*ce)*2*pi/h)/k_unita.*ky1; 
%         kpar(k)=(sqrt(2*me*datain.x(i)*ce)*2*pi/h)/k_unita.*sin(datain.y(j)); 
        
        kzz(k)=sqrt((2*pi/h)^2*2*me*meffective*(datain.x(i)+v0)*ce - (kpar(k)*k_unita)^2) / k_unitc;
        if isreal(kzz(k)) == 0
            errordlg('kzz imaginary');
            return;
        end
        valuev(k)=datain.value(i,j);
        k=k+1;
        
%             if kpar(k)>=0
%                 kpar_dummy = mod(kpar(k),1)*k_unita;
%                 kzz(k)=sqrt((2*pi/h)^2*2*me*meffective*(datain.x(i)+v0)*ce - (kpar_dummy)^2) / k_unitc;
% %                kzz(k)=sqrt((2*pi/h)^2*2*me*meffective*(datain.photon(i)-datain.x(i)-v0)*ce - (kpar_dummy)^2) / k_unitc;
%                 if isreal(kzz(k)) == 0
% %                    kxx(k)
%                      errordlg('kzz imaginary');
%                      return;
%                 end
%                 valuev(k)=datain.value(i,j);
%                 k=k+1;
%                 
%             else
%                 kpar_dummy = mod(kpar(k),-1)*k_unita;
%                  kzz(k)=sqrt((2*pi/h)^2*2*me*meffective*(datain.x(i)+v0)*ce - (kpar_dummy)^2) / k_unitc;
% %                kzz(k)=sqrt((2*pi/h)^2*2*me*meffective*(datain.photon(i)-datain.x(i)-v0)*ce - (kpar_dummy)^2) / k_unitc;
%                 if isreal(kzz(k)) == 0
% %                    kxx(k)
%                      errordlg('kzz imaginary');
%                      return;
%                 end
%                 valuev(k)=datain.value(i,j);
%                 k=k+1;
%             end
    end
end

kpar_min = min(kpar) ; kpar_max = max(kpar);
kzz_min = min(kzz) ; kzz_max = max(kzz);

dataout.kpar_min = kpar_min;
dataout.kpar_max = kpar_max;
dataout.kzz_min = kzz_min;
dataout.kzz_max = kzz_max;
dataout.kpar = kpar;
dataout.kzz = kzz;
dataout.value = valuev;
dataout.kx1 = kx1;

%dataout.x = linspace(kzz_min,kzz_max,size_x);
%dataout.y = linspace(kpar_min,kpar_max,size_y);

%dataout.value=griddata(kpar,kzz,valuev,dataout.x,dataout.y');
end
