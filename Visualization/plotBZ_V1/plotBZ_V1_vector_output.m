function plotBZ_V1_vector_output(figureHandle, fileName)
%PLOTBZ_V1_VECTOR_OUTPUT Configure vector rendering and optional PDF export.
%   PLOTBZ_V1_VECTOR_OUTPUT(F) selects painters on MATLAB before R2025a and
%   adds an Export vector PDF menu to F. Passing a PDF filename also exports
%   with ContentType='vector', independently of renderer changes in R2025a.

arguments
    figureHandle (1,1) matlab.ui.Figure
    fileName (1,1) string = ""
end
if strlength(fileName) > 0
    [~, ~, extension] = fileparts(fileName);
    if ~strcmpi(extension, '.pdf')
        error('plotBZ_V1:InvalidExport', 'Vector export requires a .pdf filename.');
    end
end
% Renderer is effective in the supported R2022a-R2024a desktop releases.
% R2025a and newer control saved vector content through exportgraphics.
if isMATLABReleaseOlderThan('R2025a')
    set(figureHandle, 'Renderer', 'painters');
end
if isempty(findall(figureHandle, 'Type', 'uimenu', 'Tag', 'plotBZ_V1_export_vector'))
    uimenu(figureHandle, 'Label', 'Export vector PDF...', ...
        'Tag', 'plotBZ_V1_export_vector', ...
        'Callback', @(source,~) choosePDF(ancestor(source,'figure')));
end
if strlength(fileName) > 0
    exportgraphics(figureHandle, fileName, 'ContentType', 'vector');
end
end

function choosePDF(figureHandle)
[fileName, folder] = uiputfile({'*.pdf','Vector PDF (*.pdf)'}, ...
    'Export Plot BZ as vector PDF', 'plotBZ.pdf');
if isequal(fileName, 0)
    return;
end
plotBZ_V1_vector_output(figureHandle, fullfile(folder,fileName));
end
