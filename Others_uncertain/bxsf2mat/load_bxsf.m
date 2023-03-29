function [Rawdata]=load_bxsf()
%This function loads bxsf files according to Teng's conventions
% This file was copied from Teng's original program
[filename,pathname]=uigetfile('*.bxsf');
if isequal(filename,0)
    return;
end
fullpath=fullfile(pathname,filename);

%bxsf2mat
fid=fopen(fullpath,'r');
for j=1:9
    temp=fgetl(fid);
end
cell_tmp=textscan(temp,'%s%s%f','delimiter',' ','MultipleDelimsAsOne',1);
Ef=cell_tmp{3};
for j=1:6
    temp=fgetl(fid);
end
cell_tmp=textscan(temp,'%d','delimiter',' ','MultipleDelimsAsOne',1);
N_band=cell_tmp{1};
temp=fgetl(fid);
cell_tmp=textscan(temp,'%d%d%d','delimiter',' ','MultipleDelimsAsOne',1);
Nx=cell_tmp{1};
Ny=cell_tmp{2};
Nz=cell_tmp{3};
N=Nx*Ny*Nz;
temp=fgetl(fid);
cell_tmp=textscan(temp,'%f%f%f','delimiter',' ','MultipleDelimsAsOne',1);
G0=cell2mat(cell_tmp);
for j=1:3
    temp=fgetl(fid);
    cell_tmp=textscan(temp,'%f%f%f','delimiter',' ','MultipleDelimsAsOne',1);
    v(j,1:3)=cell2mat(cell_tmp);
end

tic;
for j=1:N_band
    fgetl(fid);
    M=fscanf(fid,'%f',[1,N]);
    value{j,1}=permute(reshape(M,[Nz Ny Nx]),[3 2 1]);
    E_range(j,1)=min(M(:));
    E_range(j,2)=max(M(:));
    fgetl(fid);
end
fclose(fid);
toc;

Rawdata.E=value;
Rawdata.E_range=E_range;
Rawdata.Ef=Ef;
Rawdata.N_band=N_band;
Rawdata.Nx=double(Nx);
Rawdata.Ny=double(Ny);
Rawdata.Nz=double(Nz);
Rawdata.G0=G0;
Rawdata.v1=v(1,:);
Rawdata.v2=v(2,:);
Rawdata.v3=v(3,:);
end
