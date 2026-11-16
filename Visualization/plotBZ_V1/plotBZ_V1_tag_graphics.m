function plotBZ_V1_tag_graphics(axesHandle, previousGraphics)
%PLOTBZ_V1_TAG_GRAPHICS Mark only graphics added by the latest BZ plot.
%   A data overlay may share the axes, so Clear must not delete it.

newGraphics = setdiff(findall(axesHandle), previousGraphics);
newGraphics = newGraphics(isgraphics(newGraphics));
if ~isempty(newGraphics)
    set(newGraphics, 'Tag', 'plotBZ_V1_generated');
end
end
