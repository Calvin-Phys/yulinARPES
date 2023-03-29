%% draw contour for NbAs_bulk_miller112 surface
%all variables in this program are in the form "x_x"
%bug report :sunshu@mail.ustc.edu.cn
clear;

%% input indices (h_1,h_2,h_3) of crystallographic cut plane in conventional unit cell
h_1=1;
h_2=1;
h_3=2;
select_case=1;  %if(select_case==1) cut plane passes gamma point in k_z direction, 
                %esle passes zero piont

%% load '.bxsf' rawdata
Rawdata=pb_load_bxsf_Callback;  

v_1=Rawdata.v1;
v_2=Rawdata.v2;
v_3=Rawdata.v3; %v_i, base vector of BZ
N_1=double(Rawdata.Nx);
N_2=double(Rawdata.Ny);
N_3=double(Rawdata.Nz);%N_i, the num of points in v_i base, dividing it into N_i-1 parts
    %default double/int is int, so double()

%% get orthogonal bases in k-space, G_t, G_x, G_y (only for BCT crystal lattice)
t_1=h_3+h_2-h_1;
t_2=h_3-h_2+h_1;
t_3=-h_3+h_2+h_1;
divisor_t=gcd(gcd(t_1,t_2),t_3);
t_1=t_1/divisor_t;
t_2=t_2/divisor_t;
t_3=t_3/divisor_t;
G_t=t_1*v_1+t_2*v_2+t_3*v_3;
syms G_x1 G_x2 G_x3 G_y1 G_y2 G_y3; 
G_x1=1;
G_x2=0;
G_y2=1; %arbitrary three num 
G_x=G_x1*v_1+G_x2*v_2+G_x3*v_3;
G_y=G_y1*v_1+G_y2*v_2+G_y3*v_3;
[G_x3,G_y1,G_y3]=solve(G_x*G_y'==0,G_x*G_t'==0,G_y*G_t'==0,G_x3,G_y1,G_y3);
G_x=G_x1*v_1+G_x2*v_2+G_x3*v_3;
G_y=G_y1*v_1+G_y2*v_2+G_y3*v_3;
G_x=double(G_x/sqrt(G_x*G_x'));
G_y=double(G_y/sqrt(G_y*G_y')); %normalization, double() here is necessary 
    
%% interpolate bulk 3D band data  
[X,Y,Z]=ndgrid(1/N_1:1/N_1:1,1/N_2:1/N_2:1,1/N_3:1/N_3:1);
F_E=cell(Rawdata.N_band,1); %type(E)=cell, so F_E=cell() as interpolant function
for i=1:Rawdata.N_band
    F_E{i}=griddedInterpolant(X,Y,Z,Rawdata.E{i});
end
%F_E(x,y,z), xyz in v_i bases. [1/N_i,1], interp,more accurate; outside the domain, extrap

%% get 2D band E_k(k_x,k_y), at point 'k_x*G_x+k_y*G_y' where G_x & G_y are normalized bases 
    %% 1st, 2D k_x*k_y meshgrid
bound_bz=max(max(max(abs(v_1)),max(abs(v_2))),max(abs(v_3))); 
Num_div=2000; 
min_kx=-5;
max_kx=0;
min_ky=-5;
max_ky=0;
k_x=linspace(min_kx,max_kx,Num_div);
k_y=linspace(min_ky,max_ky,Num_div);
    %% 2nd, calculate corresponding energy value
E_k=zeros(Num_div,Num_div,Rawdata.N_band);  
%3D matrix E_k(k_x,k_y,band_num), use [E_k(:,:,k)] to get whole k band

for i=1:Num_div
    for j=1:Num_div
        point_k=k_x(1,i)*G_x+k_y(1,j)*G_y;
        p_1=point_k*v_1'/sqrt(v_1*v_1');
        p_2=point_k*v_2'/sqrt(v_2*v_2');
        p_3=point_k*v_3'/sqrt(v_3*v_3'); 
        if select_case==1        %pass gamma point, just a translation of the zero point, 
                                 %none affecting periodicity in cut plane
              p_1=p_1-0.5*t_1;
              p_2=p_2-0.5*t_2;
              p_3=p_3-0.5*t_3;  
        
        end
        %same point,coordinate trans, from 'k_x*G_x+k_y*G_y' to 'p_i*v_i', where G_xy & v_i are bases
        p_1=p_1-floor(p_1);
        p_2=p_2-floor(p_2);
        p_3=p_3-floor(p_3); %translate all points to 1st BZ 
        for k=1:Rawdata.N_band
            E_k(i,j,k)=F_E{k}([p_1,p_2,p_3]);
        end
    end
end


%% draw contour 
%  (check every point in the mesh, not using build-in function 'contourf', different from Teng)
E_contour=Rawdata.Ef;  
E_resolution=0.001;
kx_contour=zeros(1,Num_div*Num_div);
ky_contour=zeros(1,Num_div*Num_div);
num_contour=0; %record point num in contour surface
for i=1:Num_div
    for j=1:Num_div
        for k=1:Rawdata.N_band
            if abs(E_k(i,j,k)-E_contour)<E_resolution  
                kx_contour(1,num_contour+1)=min_kx+(i-1)*(max_kx-min_kx)/(Num_div-1);
                ky_contour(1,num_contour+1)=min_ky+(j-1)*(max_ky-min_ky)/(Num_div-1);
                num_contour=num_contour+1;
                break;
            end
        end
    end
end
k_x_con=zeros(1,num_contour);
k_y_con=zeros(1,num_contour);
for i=1:num_contour
    k_x_con(1,i)=kx_contour(1,i);
    k_y_con(1,i)=ky_contour(1,i);
end
figure;
scatter(k_x_con,k_y_con);
axis equal;
title(['E= ',num2str(E_contour),'eV']);