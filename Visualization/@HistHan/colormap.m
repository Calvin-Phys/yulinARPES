function colormap(obj,varargin)
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
minSlider=get(obj.SliderMin,'Value');
if minSlider<0
    minSlider=minSlider+1;
else
    minSlider=10^minSlider;
end
minSlider=minSlider*(maxValue-minValue)+minValue;
maxSlider=get(obj.SliderMax,'Value');
if maxSlider<0
    maxSlider=maxSlider+1;
else
    maxSlider=10^maxSlider;
end
maxSlider=maxSlider*(maxValue-minValue)+minValue;
gamma=get(obj.SliderGamma,'Value');
set(obj.GammaValue,'String',num2str(gamma));

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
minPercent=100*(cmin-minValue)/(maxValue-minValue);
maxPercent=100*(cmax-minValue)/(maxValue-minValue);
% Slider Box Value
set(obj.MinValue,'String',num2str(minPercent));
set(obj.MaxValue,'String',num2str(maxPercent));
%% Color Mapping
sliceData(sliceData<cmin)=cmin;
sliceData=(sliceData-cmin)/(cmax-cmin);
sliceData=sliceData.^gamma;
sliceData=sliceData*(cmax-cmin)+cmin;
%% Update Figure
set(hobj,'CData',sliceData);
cmapvar=get(obj.ColorMap,'Value');
cmap=get(obj.ColorMap,'String');
load('Colormap.mat');
cmapData=eval(cmap{cmapvar});
if get(obj.FlipCheckbox,'Value')
    colormap(hax,flipud(cmapData));
else
    colormap(hax,cmapData);
end
caxis(hax,[cmin,cmax]);
end

