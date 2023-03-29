function checkSliderInput(obj,varargin)
minInput=str2double(get(obj.MinValue,'String'));
maxInput=str2double(get(obj.MaxValue,'String'));
%% Check Range
if minInput<0
    minInput=0;
end
if minInput>1000
    minInput=1000;
end
if maxInput<0
    maxInput=0;
end
if maxInput>1000
    maxInput=1000;
end
set(obj.MinValue,'String',num2str(minInput));
set(obj.MaxValue,'String',num2str(maxInput));

%% Set Slider
if minInput<100
    minInput=minInput/100-1;
else
    minInput=minInput/100;
    minInput=log10(minInput);
end
if maxInput<100
    maxInput=maxInput/100-1;
else
    maxInput=maxInput/100;
    maxInput=log10(maxInput);
end
set(obj.SliderMin,'Value',minInput);
set(obj.SliderMax,'Value',maxInput);

gammaInput=str2double(get(obj.GammaValue,'String'));
if 0.01>gammaInput
    gammaInput=0.01;
end
if 5<gammaInput
    gammaInput=5;
end
set(obj.SliderGamma,'Value',gammaInput);
end
