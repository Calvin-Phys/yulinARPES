function loader_UI(varargin)
    % load ARPES data to pre-defined class object.
    
    % memorize last opened directory
    persistent lastPath path
    if isempty(lastPath) 
        lastPath = 0;
    end
    
    % select folder
    if lastPath == 0
        [file, path] = uigetfile_with_lastpath(pwd);
    else
        [file, path] = uigetfile_with_lastpath(lastPath);
    end

    % empty
    if path == 0
        return
    else
        lastPath = path;
    end

    % one file
    if ~iscell(file)
        file = {file};
    end
    N = length(file);

    % multiply file
    f = waitbar(0, '');
    f.Children.Title.Interpreter = 'none';

    for i = 1:N
        % get file name and ext
        filename = file{i};
        [~, basename, ext] = fileparts(filename);

        waitbar(i/N, f, ['Loading selected data [', filename, '] ... ', num2str(i), '/', num2str(N)]);

        % Simplify the string replacements for the basename variable
        if contains(basename,'-')
            basename = strrep(basename,'-','_');
        end
        if contains(basename,' ')
            basename = strrep(basename,' ','_');
        end

        % Call the separate function to handle file extensions and loading functions
        data = load_data_by_ext(fullfile(path, filename), ext);

        % assign the data to base workspace
        if ~isempty(data)
            data.name = basename;
            assignin('base', basename, data);
        end
    end

    close(f)
end

function [file, path] = uigetfile_with_lastpath(lastPath)
    [file, path] = uigetfile({'*.*', 'All Files (*.*)'; ...
                              '*.txt;*.zip', 'Scienta CUT/MAP (*.txt, *.zip)'; ...
                              '*.hdf5', 'Elettra Nano (*.hdf5)'; ...
                              '*.h5', 'PSI ULTRA/ADRESS (*.h5)'; ...
                              '*.nxs', 'DLS io5 (*.nxs)'; ...
                              '*.ibw', 'Bessy 1^3 (*.ibw)'; ...
                              '*.mat', 'MAT-files (*.mat)'}, ...
                              'Select One or More Files', 'MultiSelect', 'on', lastPath);
end

function data = load_data_by_ext(filepath, ext)
    % Replace the if...elseif... block with a switch block
    switch ext
        case '.mat'
            evalin('base', append("load('", filepath, "');"));
            data = [];
        case '.txt'
            data = load_scienta_txt_fast(filepath);
        case '.zip'
            data = load_scienta_zip_fast(filepath);
        case '.hdf5'
            data = load_Elettra_Spectromicroscopy(filepath);
        case '.h5'
            data = load_PSI_ULTRA(filepath);
        case '.nxs'
            data = load_DLS_io5(filepath);
        case '.ibw'
            data = load_Bessy_IBW(filepath);
        otherwise
            warning(['Fail to load ' filepath '. Check data type.']);
            data = [];
    end
end



% function loader_UI(varargin)
% % load ARPES data to pre-defined class object.
% 
%     % memorize last opened directory
%     persistent lastPath path
%     if isempty(lastPath) 
%         lastPath = 0;
%     end
%     
%     % select folder
%     if lastPath == 0
%         [file,path] = uigetfile({'*.*','All Files (*.*)'; '*.txt;*.zip','Scienta CUT/MAP (*.txt, *.zip)'; ...
%             '*.hdf5','Elettra Nano (*.hdf5)';'*.h5','PSI ULTRA/ADRESS (*.h5)';'*.nxs','DLS io5 (*.nxs)'; ...
%             '*.ibw','Bessy 1^3 (*.ibw)';'*.mat','MAT-files (*.mat)' }, ...
%             'Select One or More Files','MultiSelect', 'on');
%     else 
%         [file,path] = uigetfile({'*.*','All Files (*.*)'; '*.txt;*.zip','Scienta CUT/MAP (*.txt, *.zip)'; ...
%             '*.hdf5','Elettra Nano (*.hdf5)';'*.h5','PSI ULTRA/ADRESS (*.h5)';'*.nxs','DLS io5 (*.nxs)'; ...
%             '*.ibw','Bessy 1^3 (*.ibw)';'*.mat','MAT-files (*.mat)' }, ...
%             'Select One or More Files','MultiSelect', 'on',lastPath);
%     end
% 
%     % empty
%     if path == 0
%         return
%     else
%         lastPath = path;
%     end
% 
%     % one file
%     if ~iscell(file)
%         file = {file};
%     end
%     N = length(file);
% 
%     % multiply file
%     f = waitbar(0,'');
%     f.Children.Title.Interpreter = 'none';
% 
% %     tic
%     for i = 1:N
% 
%         % get file name and ext
%         filename = file{i};
%         [~,basename,ext] = fileparts(filename);
% 
%         waitbar(i/N,f,['Loading selected data [', filename ,'] ... ',num2str(i),'/',num2str(N)]);
% 
%         if strcmp(ext,'.mat')
%             evalin('base',append("load('",fullfile(path, filename),"');"));
%             continue
%         end
% 
%         if strcmp(ext,'.txt')
%             data = load_scienta_txt_fast(fullfile(path, filename));
%         elseif strcmp(ext,'.zip')
%             data = load_scienta_zip_fast(fullfile(path, filename));
%         elseif strcmp(ext,'.hdf5')
%             data = load_Elettra_Spectromicroscopy(fullfile(path, filename));
%         elseif strcmp(ext,'.h5')
%             data = load_PSI_ULTRA(fullfile(path, filename));
%         elseif strcmp(ext,'.nxs')
%             data = load_DLS_io5(fullfile(path, filename));
%         elseif strcmp(ext,'.ibw')
%             data = load_Bessy_IBW(fullfile(path, filename));
%             
%         else
%             warning(['Fail to load ' filename '. Check data type.']);
%             continue
%         end
%         
%         if contains(basename,'-')
%             basename = strrep(basename,'-','_');
%         end
%         if contains(basename,' ')
%             basename = strrep(basename,' ','_');
%         end
% 
%         data.name = basename;
%         assignin('base',basename,data);
% 
%         
%     end
% %     toc
% 
%     close(f)
% end