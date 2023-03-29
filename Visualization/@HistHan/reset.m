function reset(obj,varargin)
h = obj.TargetFigure();
sliceData = getappdata(h,'SliceData');
if isempty(sliceData)
return;
end
hobjlist = findobj(obj.TargetFigure());
for i = 1:length(hobjlist)
    if isa(hobjlist(i),'matlab.graphics.primitive.Surface')
        hobj = hobjlist(i);
        break;
    end
end
if isempty(hobj)
    return; % no surface object found in the figure
end
set(obj.SliderMin,'Value',-1);
set(obj.SliderMax,'Value',0);
set(obj.SliderGamma,'Value',1);
set(hobj,'CData',sliceData);
end

