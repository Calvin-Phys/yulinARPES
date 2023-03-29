


[filename,pathname]=uigetfile('*.bxsf','MultiSelect','on');
if isequal(filename,0)
    return;
end

% take the header from the first file and copy it to the new file
% build new file
new_file_name='CaAgP_combined2.bxsf';
new_file_fullpath=fullfile(pathname,new_file_name);
fid_new=fopen(new_file_fullpath,'w');
% open first old file
fullpath=fullfile(pathname,filename{1});
fid=fopen(fullpath,'r');
tline='t'; %sets tline to arbitrary char

%copy header, but set the number of bands to the new expected number based
%on the number of selected files
while ischar(tline)
    tline = fgetl(fid);
    
    % check if BANDGRID_3D_BANDS line is present. Copy this line, and then
    % read a new line, which is replace in the new document with the new
    % number of bands
    k = strfind(tline, 'BANDGRID_3D_BANDS');
    if ~isempty(k)
        fprintf(fid_new,'%s\n',tline);
        tline = fgetl(fid);
        fprintf(fid_new,'     %d\n',length(filename));
        continue
    end    
    
    k = strfind(tline, 'BAND:');
       if isempty(k)
           fprintf(fid_new,'%s\n',tline);
       else
           break
       end
end
%close first file
fclose(fid);


% now copy the data from one file into the next
for ii=1:length(filename)
    %open file
    fullpath=fullfile(pathname,filename{ii});
    fid=fopen(fullpath,'r');
    tline='t'; %sets tline to arbitrary char
    
    while ischar(tline)
        tline = fgetl(fid);
        % check if BAND: line is present. Copy this line, and then
        % break
        k = strfind(tline, 'BAND:');
        if isempty(k)
            continue
        else
            break
        end    
    end
    
    % now copy this line and all subsequent lines, until   END_BANDGRID_3D
    
    while isempty(strfind(tline, 'END_BANDGRID_3D'))
        fprintf(fid_new,'%s\n',tline);
        tline = fgetl(fid);
    end
    fclose(fid);
end
fprintf(fid_new,'%s\n','  END_BANDGRID_3D');
fprintf(fid_new,'%s\n','END_BLOCK_BANDGRID_3D');
fclose(fid_new);

