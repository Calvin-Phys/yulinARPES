

function [Rawdata]=load_bxsf_v2(convert_Ry_to_eV_switch)
%This function loads bxsf files according to Teng's conventions
% This file was copied from Teng's original program
[filename,pathname]=uigetfile('*.bxsf');
if isequal(filename,0)
    return;
end
fullpath=fullfile(pathname,filename);

% set energy conversion factor
if convert_Ry_to_eV_switch
    conversion_factor=13.6057;
else
    conversion_factor=1;
end

%% pre-processing
%%%%%remove empty lines
% Read the file as cell string line by line:
fid = fopen(fullpath, 'r');
if fid < 0, error('Cannot open file: %s', FileName); end
Data = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(fid);

% Remove empty lines:
C    = deblank(Data{1});   % [EDITED]: deblank added
C(cellfun('isempty', C)) = [];

% Write the cell string:
fid = fopen(fullpath, 'w');
if fid < 0, error('Cannot open file: %s', FileName); end
fprintf(fid, '%s\n', C{:});
fclose(fid);
%%% end remove empty lines


%% reading the header
fid=fopen(fullpath,'r');
tline='t'; %sets tline to arbitrary char
Ef=[];
bandgrid_counter=0;
N=[];

while ischar(tline)
    tline = fgetl(fid);
    
    if ~ischar(tline)
        continue;
    else
        tline=strtrim(tline);
    end
        
    if isempty(tline) || tline(1)=='#' 
        continue
    end
    
    if isempty(Ef)
        k = strfind(tline, 'Fermi Energy:');
        if ~isempty(k)
            Ef = textscan(tline,'%s %s %f');
            Ef=Ef{1,3};
        end
    elseif isempty(N)
        
        k = strfind(tline, 'BANDGRID_3D');
        
        if ~isempty(k)
            bandgrid_counter=bandgrid_counter+1;
        end

        if bandgrid_counter==2 
        counter=1; %sets counter to read the next 6 meaningful lines
            while counter <= 6
                tline = fgetl(fid);
                if ~ischar(tline)
                    continue;
                else
                    tline=strtrim(tline);
                end

                if isempty(tline) || tline(1)=='#'
                    continue
                end

            switch counter
                case 1
                    N_band=str2num(tline);
                case 2
                    dummy=textscan(tline, '%f %f %f');
                    Nx=dummy{1};
                    Ny=dummy{2};
                    Nz=dummy{3};
                    N=Nx*Ny*Nz;
                case 3
                    dummy=textscan(tline, '%f %f %f');
                    G0=cell2mat(dummy);
                case 4
                    dummy=textscan(tline, '%f %f %f');
                    v1=cell2mat(dummy);
                case 5
                    dummy=textscan(tline, '%f %f %f');
                    v2=cell2mat(dummy);
                case 6
                    dummy=textscan(tline, '%f %f %f');
                    v3=cell2mat(dummy);

            end   

            counter=counter+1;

            end
            break
            
        end
    
    end
    

    
end

%% reading the data, convert Ry to eV if necessary

for j=1:N_band
    test=fgetl(fid);
    M=fscanf(fid,'%f',[1,N]);
    value{j,1}=conversion_factor.*permute(reshape(M,[Nz Ny Nx]),[3 2 1]);
    E_range(j,1)=conversion_factor.*min(M(:));
    E_range(j,2)=conversion_factor.*max(M(:));
    test=fgetl(fid);
    display(['loaded band number ',num2str(j)])
end

fclose(fid);

%% transferring the data to the output

Rawdata.E=value;
Rawdata.E_range=E_range;
Rawdata.Ef=conversion_factor.*Ef;
Rawdata.N_band=N_band;
Rawdata.Nx=double(Nx);
Rawdata.Ny=double(Ny);
Rawdata.Nz=double(Nz);
Rawdata.G0=G0;
Rawdata.v1=v1;
Rawdata.v2=v2;
Rawdata.v3=v3;
end


