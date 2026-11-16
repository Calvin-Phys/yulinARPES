function plotBZ_V1_clear_graphics(figureNumber)
%PLOTBZ_V1_CLEAR_GRAPHICS Delete only objects created by plotBZ_V1.
%   Do not create a figure when the requested number does not exist.

targetFigure = findobj(groot, 'Type', 'figure', 'Number', figureNumber);
if isempty(targetFigure)
    return;
end
delete(findall(targetFigure, 'Tag', 'plotBZ_V1_generated'));
end
