function histEq(obj,varargin)
%% Get Data
h = obj.TargetFigure();
sliceData = getappdata(h,'SliceData');
hobj = [];
hobjlist = findobj(h);
for i = 1:length(hobjlist)
    if isa(hobjlist(i),'matlab.graphics.primitive.Surface')
        hobj = hobjlist(i);
    end
    if isa(hobjlist(i),'matlab.graphics.axis.Axes')
        hax = hobjlist(i);
    end
end
if isempty(hobj)
    return; % no surface object found in the figure
end
if isempty(hax)
    return; % no axes
end
if isempty(sliceData)

    sliceData = get(hobj,'CData');
    setappdata(h,'SliceData',sliceData);
end
%% Gather Color Info
minValue=min(sliceData(:));
maxValue=max(sliceData(:));
% Slider Value Interpretation
minSlider = get(obj.SliderMin,'Value');
maxSlider = get(obj.SliderMax,'Value');
if minSlider<0
    minSlider=minSlider+1;
else
    minSlider=10^minSlider;
end
minSlider=minSlider*(maxValue-minValue)+minValue;
if maxSlider<0
    maxSlider=maxSlider+1;
else
    maxSlider=10^maxSlider;
end
maxSlider=maxSlider*(maxValue-minValue)+minValue;

if minSlider<maxSlider
    cmin=minSlider;
    cmax=maxSlider;
else
    cmin=maxSlider;
    cmax=minSlider;
end
if cmax==cmin
    cmax=cmin+1;
end
%% Get proper gamma, min, max
gamma0 = 1;
gamma1 = fminsearch(@(gamma)histCmp(sliceData,cmin,cmax,gamma),gamma0);
if gamma1<0.01||gamma1>5
    return;
end
set(obj.SliderGamma,'Value',gamma1);
end

function s = histCmp(sliceData,cmin,cmax,gamma)
s1 = sliceData(sliceData>cmin);
s2 = s1(s1<cmax);
s2=(s2-cmin)/(cmax-cmin);
s2=s2.^gamma;
cDistribution = histcounts(s2(:),64);
s = var(cDistribution(:));

end
