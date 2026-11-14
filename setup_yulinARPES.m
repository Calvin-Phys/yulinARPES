function setup_yulinARPES()
%SETUP_YULINARPES Add supported yulinARPES folders to the MATLAB path.

rootFolder = fileparts(mfilename('fullpath'));
codeFolders = {'Data_enhance', 'Data_process', 'Fitting', ...
    'Loader_kconvert', 'Visualization'};

addpath(rootFolder);
for folderIndex = 1:numel(codeFolders)
    folderPath = fullfile(rootFolder, codeFolders{folderIndex});
    if isfolder(folderPath)
        addpath(genpath(folderPath));
    end
end

supportFolders = { ...
    fullfile(rootFolder, 'Others_uncertain'), ...
    fullfile(rootFolder, 'Others_uncertain', 'SubFunctions'), ...
    fullfile(rootFolder, 'Others_uncertain', 'bxsf2mat'), ...
    fullfile(rootFolder, 'third_party', 'export_fig')};
for folderIndex = 1:numel(supportFolders)
    if isfolder(supportFolders{folderIndex})
        addpath(supportFolders{folderIndex});
    end
end

matGeomFolder = fullfile(rootFolder, 'third_party', 'matGeom', 'matGeom');
if isfolder(matGeomFolder)
    addpath(genpath(matGeomFolder));
end

fprintf('Added yulinARPES paths from %s\n', rootFolder);
fprintf(['Add the separate OX_ARPES checkout to the MATLAB path if you use ' ...
    'its data classes or loader.\n']);
end
