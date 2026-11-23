function position = position_slider_value(slider,varargin)
%POSITION_SLIDER_VALUE Read/write slice position in stored coordinate units.
%   The UIControl's raw Value is normalized on R2025a+; callers must use this
%   accessor for slice calculations, position/index edits and mass plotting.
bounds=getappdata(slider,'PlotSlicesPositionRange');
normalized=getappdata(slider,'PlotSlicesPositionNormalized');
if isempty(varargin)
    if normalized
        fraction=max(0,min(1,double(slider.Value)));
        position=(1-fraction)*bounds(1)+fraction*bounds(2);
    else
        position=double(slider.Value);
    end
else
    validateattributes(varargin{1},{'numeric'},{'real','finite','scalar'});
    position=max(bounds(1),min(bounds(2),double(varargin{1})));
    if normalized
        if bounds(1)==bounds(2)
            slider.Value=0.5;
        else
            slider.Value=(position-bounds(1))/(bounds(2)-bounds(1));
        end
    else
        slider.Value=position;
    end
end
end
