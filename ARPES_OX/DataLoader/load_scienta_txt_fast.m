function CUT = load_scienta_txt_fast(file_path)
    % Load 2D data from a Scienta text file and return an OxA_CUT object

    % Open the file and read all lines
    fileID = fopen(file_path);
    raw_lines = textscan(fileID, '%s', 'Delimiter', '\n');
    fclose(fileID);
    lines = raw_lines{1};

    % Find the line starting with 'Dimension 1 scale=' and extract the y scale
    y_line = lines{find(startsWith(lines, 'Dimension 1 scale='), 1)};
    y = sscanf(y_line(19:end), '%f')';

    % Find the line starting with 'Dimension 2 scale=' and extract the x scale
    x_line = lines{find(startsWith(lines, 'Dimension 2 scale='), 1)};
    x = sscanf(x_line(19:end), '%f')';

    % Find the index of the line starting with '[Data', indicating the start of the data section
    data_start_idx = find(startsWith(lines, '[Data'), 1);

    % Initialize the 'value' matrix and read the data from the lines
    value = zeros(length(x), length(y));
    for i = 1:length(y)
        data_line = lines{data_start_idx + i};
        value(:, i) = sscanf(data_line(25:end), '%f');
    end

    % Create an OxA_CUT object with the extracted data (x, y, value)
    CUT = OxA_CUT(x, y, value);
end

% function CUT = load_scienta_txt_fast(file_path)
% 
%     % extract data header
%     fileID = fopen(file_path);
%     tline = fgetl(fileID);
%     
%     while ~startsWith(tline,'Dimension 1 scale=')
%         tline = fgetl(fileID);
%     end
%     y = cell2mat(textscan(tline(19:end),'%f'))';
% 
%     while ~startsWith(tline,'Dimension 2 scale=')
%         tline = fgetl(fileID);
%     end
%     x = cell2mat(textscan(tline(19:end),'%f'))';
% 
%     while ~startsWith(tline,'[Data')
%         tline = fgetl(fileID);
%     end
% 
%     value = zeros(length(x),length(y));
%     for i=1:length(y)
%         tline = fgetl(fileID);
%         value(:,i) = cell2mat(textscan(tline(25:end),'%f'));
%     end
% 
%     fclose(fileID);
% 
%     CUT = OxA_CUT(x,y,value);
% 
% end


