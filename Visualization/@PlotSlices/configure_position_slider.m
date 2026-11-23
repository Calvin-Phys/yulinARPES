function [position,index] = configure_position_slider(slider,axisData,varargin)
%CONFIGURE_POSITION_SLIDER Configure the legacy UIControl position slider.
%   R2025a+ uses an internal 0..1 range to avoid the reported nonzero-Min
%   rendering/input disagreement. Position fields and slicing use physical
%   coordinates through PlotSlices.position_slider_value on every release.
%   An optional logical third argument selects normalized/physical storage
%   explicitly, allowing both paths to be checked on the same MATLAB release.
validateattributes(axisData,{'numeric'},{'real','finite','vector','nonempty'});
if ~isa(slider,'matlab.ui.control.UIControl') || ~strcmpi(slider.Style,'slider')
    error('PlotSlices:UnsupportedSlider','The position slider must be a slider UIControl.');
end
normalized=~isMATLABReleaseOlderThan('R2025a');
if ~isempty(varargin)
    validateattributes(varargin{1},{'logical'},{'scalar'});
    normalized=varargin{1};
end
coordinates=double(axisData(:));
axisMin=min(coordinates);
axisMax=max(coordinates);
position=axisMin/2+axisMax/2;
[~,index]=min(abs(coordinates-position));
setappdata(slider,'PlotSlicesPositionRange',[axisMin axisMax]);
setappdata(slider,'PlotSlicesPositionNormalized',normalized);
lower=axisMin;
upper=axisMax;
controlValue=position;
if normalized
    lower=0;
    upper=1;
    controlValue=0.5;
elseif lower==upper
    padding=max(1,abs(lower))*eps*8;
    lower=lower-padding;
    upper=upper+padding;
end
% Expand first, so every intermediate bound/value combination stays valid.
slider.Max=max(upper,slider.Max);
slider.Min=min(lower,slider.Min);
slider.Value=controlValue;
slider.Max=upper;
slider.Min=lower;
step=max(1/max(1,numel(coordinates)-1),1e-6+eps);
slider.SliderStep=[step min(1,5*step)];
if axisMin==axisMax, slider.Enable='off'; else, slider.Enable='on'; end
end
