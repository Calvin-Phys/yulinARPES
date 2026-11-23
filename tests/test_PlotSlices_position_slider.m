function tests = test_PlotSlices_position_slider
% Run after setup_yulinARPES; requires GUI Layout Toolbox and drawcrosshair.
tests = functiontests(localfunctions);
end

function setup(testCase)
fixtureName='plotSlicesSliderCompatibilityFixture';
assert(~evalin('base',sprintf('exist(''%s'',''var'')',fixtureName)), ...
    'Slider fixture name already exists in the base workspace.');
testCase.TestData.fixtureName=fixtureName;
testCase.TestData.initialFigures=findall(groot,'Type','figure');
end

function teardown(testCase)
evalin('base',['clear ' testCase.TestData.fixtureName]);
figures=findall(groot,'Type','figure');
delete(figures(~ismember(figures,testCase.TestData.initialFigures)));
end

function testCoordinateMappingWithLegacyControl(testCase)
f=figure('Visible','off');
slider=uicontrol(f,'Style','slider');
for normalized=[false true]
    for coordinates={[20 22 24],[-8 -6 -4 -2],[-2 0 2], ...
            [0.002 0.003 0.004],[24 21 20], ...
            linspace(154.2140,155.7863,5),-2}
        axisData=coordinates{1};
        [position,index]=PlotSlices.configure_position_slider(slider,axisData,normalized);
        drawnow;
        verifyClass(testCase,slider,'matlab.ui.control.UIControl');
        verifyEqual(testCase,PlotSlices.position_slider_value(slider),position,'AbsTol',1e-10);
        [~,expectedIndex]=min(abs(double(axisData)-position));
        verifyEqual(testCase,index,expectedIndex);
        if normalized
            verifyEqual(testCase,[slider.Min slider.Max],[0 1]);
        elseif ~isscalar(axisData)
            verifyEqual(testCase,[slider.Min slider.Max],[min(axisData) max(axisData)]);
        end
        for endpoint=[min(axisData) max(axisData)]
            PlotSlices.position_slider_value(slider,endpoint);
            verifyEqual(testCase,PlotSlices.position_slider_value(slider),endpoint,'AbsTol',1e-10);
        end
        if normalized && ~isscalar(axisData)
            % The mouse/control uses zero at the left end; the application
            % must interpret that as the first physical coordinate, not zero.
            slider.Value=0;
            verifyEqual(testCase,PlotSlices.position_slider_value(slider),min(axisData));
            slider.Value=1;
            verifyEqual(testCase,PlotSlices.position_slider_value(slider),max(axisData));
        end
        if isscalar(axisData), verifyEqual(testCase,slider.Enable,'off'); end
    end
end
end

function testCoordinateRangesAndEndpointSlices(testCase)
data=struct('value',reshape(1:24,3,4,2), ...
    'x',[20 22 24],'y',[-8 -6 -4 -2],'z',[100 101]);
for descending=[false true]
    if descending
        data.x=[24 21 20]; data.y=[-2 -3 -6 -8]; data.z=[101 100];
    end
    assignin('base',testCase.TestData.fixtureName,data);
    for direction='xyz'
        viewer=PlotSlices(testCase.TestData.fixtureName,direction);
        drawnow;
        axisValues=data.(direction);
        verifyStorageAndLayout(testCase,viewer,axisValues);
        [~,index]=min(abs(axisValues-PlotSlices.position_slider_value(viewer.Slider)));
        verifyEqual(testCase,str2double(viewer.PositionIndex.String),index);
        viewer.Width.String='0';
        for endpoint=[min(axisValues) max(axisValues)]
            PlotSlices.position_slider_value(viewer.Slider,endpoint);
            % The actual UIControl Value listener must refresh the image.
            index=find(axisValues==endpoint,1);
            verifyEqual(testCase,str2double(viewer.PositionIndex.String),index);
            switch direction
                case 'x', expected=squeeze(data.value(index,:,:));
                case 'y', expected=squeeze(data.value(:,index,:));
                case 'z', expected=squeeze(data.value(:,:,index));
            end
            verifyEqual(testCase,viewer.imag.CData,expected');
        end
        viewer.Position.String=num2str(max(axisValues)+100);
        feval(viewer.Position.Callback,viewer.Position,[]);
        verifyEqual(testCase,PlotSlices.position_slider_value(viewer.Slider),max(axisValues),'AbsTol',1e-10);
        viewer.Position.String='NaN';
        feval(viewer.Position.Callback,viewer.Position,[]);
        verifyEqual(testCase,PlotSlices.position_slider_value(viewer.Slider),max(axisValues),'AbsTol',1e-10);
        delete(viewer.Figure);
    end
end
end

function testReportedEnergyRangeAndIndexEdits(testCase)
data=struct('value',reshape(1:60,3,4,5), ...
    'x',1:3,'y',1:4,'z',linspace(154.2140,155.7863,5));
assignin('base',testCase.TestData.fixtureName,data);
viewer=PlotSlices(testCase.TestData.fixtureName,'z');
viewer.Width.String='0';
drawnow;
verifyStorageAndLayout(testCase,viewer,data.z);
for index=[1 5 3]
    viewer.PositionIndex.String=num2str(index);
    cb=viewer.PositionIndex.Callback;
    feval(cb{1},viewer.PositionIndex,[],cb{2:end});
    verifyEqual(testCase,PlotSlices.position_slider_value(viewer.Slider),data.z(index),'AbsTol',1e-10);
    verifyEqual(testCase,viewer.imag.CData,data.value(:,:,index)');
end
original=PlotSlices.position_slider_value(viewer.Slider);
restore=onCleanup(@()PlotSlices.position_slider_value(viewer.Slider,original));
PlotSlices.position_slider_value(viewer.Slider,data.z(1));
clear restore
verifyEqual(testCase,PlotSlices.position_slider_value(viewer.Slider),original,'AbsTol',1e-10);
verifyEqual(testCase,viewer.imag.CData,data.value(:,:,3)');
end

function testSingletonAndPromoted2D(testCase)
data=struct('value',reshape(1:12,3,4),'x',1:3,'y',1:4,'z',-2);
assignin('base',testCase.TestData.fixtureName,data);
viewer=PlotSlices(testCase.TestData.fixtureName,'z');
verifyClass(testCase,viewer.Slider,'matlab.ui.control.UIControl');
verifyEqual(testCase,viewer.Slider.Enable,'off');
verifyLessThan(testCase,viewer.Slider.Min,viewer.Slider.Max);
verifyEqual(testCase,PlotSlices.position_slider_value(viewer.Slider),-2);
verifyEqual(testCase,str2double(viewer.PositionIndex.String),1);
delete(viewer.Figure);
data=rmfield(data,'z');
assignin('base',testCase.TestData.fixtureName,data);
viewer=PlotSlices(testCase.TestData.fixtureName,'x');
verifyEqual(testCase,viewer.Slider.Enable,'off');
verifyEqual(testCase,PlotSlices.position_slider_value(viewer.Slider),1);
end

function verifyStorageAndLayout(testCase,viewer,axisValues)
verifyClass(testCase,viewer.Slider,'matlab.ui.control.UIControl');
verifyEqual(testCase,viewer.Slider.Parent,viewer.Checkbox.Parent);
verifyEmpty(testCase,findall(viewer.Figure,'Tag','PositionSliderHost'));
sizes=get(viewer.Slider.Parent,'Sizes');
verifyEqual(testCase,sizes(:)',[45 70 -1 20 50 30 30 20 15 30 15]);
normalized=getappdata(viewer.Slider,'PlotSlicesPositionNormalized');
verifyEqual(testCase,normalized,~isMATLABReleaseOlderThan('R2025a'));
if normalized
    verifyEqual(testCase,[viewer.Slider.Min viewer.Slider.Max],[0 1]);
else
    verifyEqual(testCase,[viewer.Slider.Min viewer.Slider.Max],[min(axisValues) max(axisValues)]);
end
steps=viewer.Slider.SliderStep;
verifyEqual(testCase,steps(1),1/(numel(axisValues)-1),'AbsTol',1e-12);
verifyLessThanOrEqual(testCase,steps(2),1);
verifyClass(testCase,viewer.SliderMin,'matlab.ui.control.UIControl');
verifyClass(testCase,viewer.SliderMax,'matlab.ui.control.UIControl');
verifyClass(testCase,viewer.SliderGamma,'matlab.ui.control.UIControl');
end
