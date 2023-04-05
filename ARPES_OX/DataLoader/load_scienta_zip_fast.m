function MAP = load_scienta_zip_fast(file_path)
    % Load 3D data from a Scienta zip file and return an OxA_MAP object

    % Unzip the input file into a temporary folder
    [folder_path, viewer_path] = unzip_to_temp_folder(file_path);

    % Ensure the temporary folder is removed when the function exits
    % Create an onCleanup object to remove the temporary folder when the function exits
    cleanupObj = onCleanup(@() remove_temp_folder(folder_path));

    % Extract data headers from the 'viewer.ini' file
    [nz, ny, nx, bin_path, z0, dz, y0, dy, x0, dx, Precision] = extract_data_header(folder_path,viewer_path);

    % Read the data from the binary file
    value = read_data(bin_path, Precision);

    % Reshape and permute the `value` variable
    [value, x, y, z] = process_data(value, nx, ny, nz, dx, dy, dz, x0, y0, z0);

    % Create an `OxA_MAP` object and set the contrast
    MAP = OxA_MAP(x, y, z, value);
    MAP = MAP.set_contrast();

end

% Additional functions
function [folder_path, viewer_path] = unzip_to_temp_folder(file_path)
    [path, file, ext] = fileparts(file_path);
    folder_path = fullfile(path,[file '_tmp']);
    viewer_path = fullfile(folder_path, 'viewer.ini');
    unzip(file_path,folder_path);
end

function [nz, ny, nx, bin_path, z0, dz, y0, dy, x0, dx, Precision] = extract_data_header(folder_path,viewer_path)
    % Add code to extract data header
    fileID = fopen(viewer_path);
    tline = fgetl(fileID);

    while ~startsWith(tline,'width=')
        tline = fgetl(fileID);
    end
    nz = str2num(tline(7:end));
    tline = fgetl(fileID);
    ny = str2num(tline(8:end));
    tline = fgetl(fileID);
    nx = str2num(tline(7:end));

    while ~startsWith(tline,'path=')
        tline = fgetl(fileID);
    end
    bin_path = fullfile(folder_path, tline(6:end));
    tline = fgetl(fileID);

    z0 = str2double(tline(14:end));
    tline = fgetl(fileID);
    dz = str2double(tline(13:end));
    tline = fgetl(fileID);
    tline = fgetl(fileID);

    y0 = str2double(tline(15:end));
    tline = fgetl(fileID);
    dy = str2double(tline(14:end));
    tline = fgetl(fileID);
    tline = fgetl(fileID);

    x0 = str2double(tline(14:end));
    tline = fgetl(fileID);
    dx = str2double(tline(13:end));

    fclose(fileID);

    fileID = fopen([bin_path(1:end-3) 'ini']);

    tline = fgetl(fileID);
    while ~startsWith(tline,'byteperpoint=')
        tline = fgetl(fileID);
    end
    nUnit = str2double(tline(14:end));
    fclose(fileID);
    if nUnit == 4
        Precision = 'single';
    elseif nUnit == 8
        Precision = 'double';
    end

end

function value = read_data(bin_path, Precision)
    % Add code to read the data from the binary file
    fileID = fopen(bin_path);
    value = fread(fileID, Precision);
    fclose(fileID);
end

function [value, x, y, z] = process_data(value, nx, ny, nz, dx, dy, dz, x0, y0, z0)
    % Add code to reshape and permute the `value` variable
    z = (1:nz)*dz + z0;
    y = (1:ny)*dy + y0;
    x = (1:nx)*dx + x0;
    value = reshape(value,[nz,ny,nx]);
    value = permute(value,[3 2 1]);
end

function remove_temp_folder(folder_path)
    while ~rmdir(folder_path,'s')
        pause(0.01);
    end
end


% function MAP = load_scienta_zip_fast(file_path)
% 
%     [path, file, ext] = fileparts(file_path);
%     folder_path = fullfile(path,[file '_tmp']);
%     viewer_path = fullfile(folder_path, 'viewer.ini');
% 
%     unzip(file_path,folder_path);
% 
%     % extract data header
%     fileID = fopen(viewer_path);
%     tline = fgetl(fileID);
% 
%     while ~startsWith(tline,'width=')
%         tline = fgetl(fileID);
%     end
%     nz = str2num(tline(7:end));
%     tline = fgetl(fileID);
%     ny = str2num(tline(8:end));
%     tline = fgetl(fileID);
%     nx = str2num(tline(7:end));
% 
%     while ~startsWith(tline,'path=')
%         tline = fgetl(fileID);
%     end
%     bin_path = fullfile(folder_path, tline(6:end));
%     tline = fgetl(fileID);
% 
%     z0 = str2double(tline(14:end));
%     tline = fgetl(fileID);
%     dz = str2double(tline(13:end));
%     tline = fgetl(fileID);
%     tline = fgetl(fileID);
% 
%     y0 = str2double(tline(15:end));
%     tline = fgetl(fileID);
%     dy = str2double(tline(14:end));
%     tline = fgetl(fileID);
%     tline = fgetl(fileID);
% 
%     x0 = str2double(tline(14:end));
%     tline = fgetl(fileID);
%     dx = str2double(tline(13:end));
% 
%     fclose(fileID);
% 
% 
%     fileID = fopen([bin_path(1:end-3) 'ini']);
%     tline = fgetl(fileID);
%     while ~startsWith(tline,'byteperpoint=')
%         tline = fgetl(fileID);
%     end
%     nUnit = str2double(tline(14:end));
%     fclose(fileID);
%     if nUnit == 4
%         Precision = 'single';
%     elseif nUnit == 8
%         Precision = 'double';
%     end
% 
%     fileID = fopen(bin_path);
%     value = fread(fileID, Precision);
%     fclose(fileID);
% 
% 
%     z = (1:nz)*dz + z0;
%     y = (1:ny)*dy + y0;
%     x = (1:nx)*dx + x0;
%     value = reshape(value,[nz,ny,nx]);
%     value = permute(value,[3 2 1]);
%     
%     MAP = OxA_MAP(x,y,z,value);
%     MAP = MAP.set_contrast();
% 
%     while ~rmdir(folder_path,'s')
%         pause(0.01);
%     end
% end
% 
