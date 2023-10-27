%% to read .bxsf file in this folder

function tf = bxsfReader(varargin)
% return true if successfully loaded, otherwise return false.

tf=true;

if nargin~=1
%     errordlg('There should be only one input -- the data filename','Wrong argument No.');
    tf=false;
    return
end

[~,dataName, ext] = fileparts(varargin{1}); 
if ~strcmp(ext,'.bxsf')
%     errordlg(['The file "' varargin{1} '" is not a .txt file!'],'Wrong file format');
    tf=false;
    return
end
fid=fopen(varargin{1}); % open data file

%bxsf2mat
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


for j=1:N_band
    str_status=['Load band ' num2str(j) '/' num2str(N_band) ' ...'];
%    set(handles.st_status,'String',str_status,'ForegroundColor',[0 0.8 1]);
    drawnow;
    fgetl(fid);
    M=fscanf(fid,'%f',[1,N]);
    value{j,1}=permute(reshape(M,[Nz Ny Nx]),[3 2 1]);
    E_range(j,1)=min(M(:));
    E_range(j,2)=max(M(:));
    fgetl(fid);
end
fclose(fid);
%set(handles.st_status,'String','Idle','ForegroundColor','g');

Rawdata.E=value;
Rawdata.E_range=E_range;
Rawdata.Ef=Ef;
Rawdata.N_band=N_band;
Rawdata.Nx=Nx;
Rawdata.Ny=Ny;
Rawdata.Nz=Nz;
Rawdata.G0=G0;
Rawdata.v1=v(1,:);
Rawdata.v2=v(2,:);
Rawdata.v3=v(3,:);

[~,varname,~]=fileparts(dataName);
assignin('base',varname,Rawdata);

%zzz_refresh_varlist_Callback(handles);


end