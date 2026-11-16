function color = plotBZ_V1_popup_color(popupHandle)
%PLOTBZ_V1_POPUP_COLOR Convert the shared GUIDE colour menu to a plot code.

colors = 'kbcgmryw';
selection = get(popupHandle, 'Value');
if ~isscalar(selection) || selection ~= fix(selection) || ...
        selection < 1 || selection > numel(colors)
    error('plotBZ_V1:InvalidInput', 'Plot colour selection is invalid.');
end
color = colors(selection);
end
