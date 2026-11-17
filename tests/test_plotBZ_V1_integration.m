function tests = test_plotBZ_V1_integration
%TEST_PLOTBZ_V1_INTEGRATION Check saved GUI wiring and overlay ownership.
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.originalPath = path;
addpath(fullfile(root, 'Visualization', 'plotBZ_V1'));
addpath(genpath(fullfile(root, 'third_party', 'matGeom', 'matGeom')));
end

function teardownOnce(testCase)
path(testCase.TestData.originalPath);
end

function testRotationContract(testCase)
for axisName = 'xyz'
    rotation = plotBZ_V1_rotation(axisName, 37);
    verifyEqual(testCase, rotation*rotation', eye(3), 'AbsTol', 1e-14);
    verifyEqual(testCase, det(rotation), 1, 'AbsTol', 1e-14);
end
verifyEqual(testCase, plotBZ_V1_rotation('x', 90)*[0;1;0], [0;0;1], 'AbsTol', 1e-14);
verifyEqual(testCase, plotBZ_V1_rotation('z', 90)*[1;0;0], [0;1;0], 'AbsTol', 1e-14);
end

function testSavedLayoutAndComputedVectorRemoval(testCase)
panel = plotBZ_V1();
testCase.addTeardown(@() delete(panel));
set(panel, 'Visible', 'off');
handles = guidata(panel);
verifyTrue(testCase, isfield(handles, 'sim_mode'));
verifyTrue(testCase, isfield(handles, 'sim_target'));
for field = {'b1_vector','b2_vector','b3_vector','s1_vector','s2_vector'}
    verifyEmpty(testCase, findall(panel, 'Tag', field{1}));
end
controls = findall(panel, 'Type', 'uicontrol');
for index = 1:numel(controls)
    position = getpixelposition(controls(index));
    parentPosition = getpixelposition(controls(index).Parent);
    verifyGreaterThanOrEqual(testCase, position(1:2), [0 0]);
    verifyLessThanOrEqual(testCase, position(1:2) + position(3:4), ...
        parentPosition(3:4) + [2 2]);
end
end

function testFourBZActionsPreserveMeasuredOverlay(testCase)
panel = plotBZ_V1();
testCase.addTeardown(@() delete(panel));
set(panel, 'Visible', 'off');
handles = guidata(panel);
% Keep this independent smoke check small; numerical lattice coverage lives
% in test_plotBZ_V1, including all 14 supported Bravais choices.
for field = {'KxStart','KxEnd','KyStart','KyEnd','KzStart','KzEnd', ...
        's1start','s1end','s2start','s2end'}
    set(handles.(field{1}), 'String', '0');
end
actions = {'SurfBZ','TwoDhBZ','TwoDpBZ','ThreeDBZ'};
for index = 1:numel(actions)
    prefix = actions{index};
    target = figure('Visible', 'off');
    targetCleanup = onCleanup(@() delete(target));
    ax = axes('Parent', target);
    measured = plot(ax, [-0.5 0.5], [0.25 -0.25], 'Tag', 'integration_measurement');
    set(ax, 'XLim', [-4 4], 'YLim', [-5 5], 'ZLim', [-6 6], ...
        'NextPlot', 'replace', 'View', [21 31]);
    expectedView = ax.View;
    set(handles.([prefix '_fig']), 'String', num2str(target.Number));
    control = handles.([prefix '_plot']);
    callback = get(control, 'Callback');
    verifyWarningFree(testCase, @() callback(control, []));
    verifyTrue(testCase, isgraphics(measured));
    if isMATLABReleaseOlderThan('R2025a')
        verifyEqual(testCase, target.Renderer, 'painters');
    end
    verifyNotEmpty(testCase, findall(ax, 'Tag', 'plotBZ_V1_generated'));
    verifyEqual(testCase, ax.XLim, [-4 4]);
    verifyEqual(testCase, ax.YLim, [-5 5]);
    verifyEqual(testCase, ax.ZLim, [-6 6]);
    verifyEqual(testCase, ax.View, expectedView);
    verifyEqual(testCase, ax.NextPlot, 'replace');
    plotBZ_V1_clear_graphics(target.Number);
    verifyTrue(testCase, isgraphics(measured));
    verifyEmpty(testCase, findall(ax, 'Tag', 'plotBZ_V1_generated'));
    % Repeat with automatic limits: restoring values must retain their mode.
    set(ax, 'XLimMode', 'auto', 'YLimMode', 'auto', 'ZLimMode', 'auto');
    verifyWarningFree(testCase, @() callback(control, []));
    verifyEqual(testCase, {ax.XLimMode, ax.YLimMode, ax.ZLimMode}, ...
        {'auto','auto','auto'});
    clear targetCleanup
end
end

function testTitleHierarchyAndIndexSpinners(testCase)
panel = plotBZ_V1('Visible', 'off');
testCase.addTeardown(@() delete(panel));
h = guidata(panel);
frames = [findall(panel, 'Type', 'uipanel'); findall(panel, 'Type', 'uibuttongroup')];
for index = 1:numel(frames)
    if ~isempty(frames(index).Title)
        verifyEqual(testCase, frames(index).FontWeight, 'bold');
        if isequal(frames(index).Parent, panel)
            topColor = frames(index).ForegroundColor;
        end
    end
end
verifyNotEqual(testCase, h.uipanel_LatticeType.ForegroundColor, topColor);
starts = {'KxStart','KyStart','KzStart','s1start','s2start'};
ends = {'KxEnd','KyEnd','KzEnd','s1end','s2end'};
for index = 1:numel(starts)
    set(h.(starts{index}), 'String', '0');
    set(h.(ends{index}), 'String', '0');
    up = findall(panel, 'Tag', [starts{index} '_up']);
    down = findall(panel, 'Tag', [ends{index} '_down']);
    callback = up.Callback;
    verifyWarningFree(testCase, @() callback(up, []));
    verifyEqual(testCase, str2double(h.(starts{index}).String), 1);
    verifyEqual(testCase, str2double(h.(ends{index}).String), 1);
    callback = down.Callback;
    verifyWarningFree(testCase, @() callback(down, []));
    verifyEqual(testCase, str2double(h.(starts{index}).String), 0);
    verifyEqual(testCase, str2double(h.(ends{index}).String), 0);
end
set(h.KxStart, 'String', '1+2');
button = findall(panel, 'Tag', 'KxStart_up');
callback = button.Callback;
verifyError(testCase, @() callback(button, []), 'plotBZ_V1:InvalidInput');
verifyEqual(testCase, h.KxStart.String, '1+2');
verifyEqual(testCase, h.KxEnd.String, '0');
end

function testDistinctSectionAndMeasurementColors(testCase)
panel = plotBZ_V1('Visible', 'off');
testCase.addTeardown(@() delete(panel));
h = guidata(panel);
verifyNotEqual(testCase, h.TwoDhBZ_color.Value, h.TwoDpBZ_color.Value);
target = figure('Visible', 'off');
testCase.addTeardown(@() delete(target));
set(h.ThreeDBZ_fig, 'String', num2str(target.Number));
set([h.TwoDh_of3D h.TwoDp_of3D], 'Value', 1);
callback = h.ThreeDBZ_plot.Callback;
verifyWarningFree(testCase, @() callback(h.ThreeDBZ_plot, []));
lines = findall(target, 'Type', 'line', 'Tag', 'plotBZ_V1_generated');
colors = vertcat(lines.Color);
verifyTrue(testCase, any(all(colors == [0 0 1], 2)));
verifyTrue(testCase, any(all(colors == [0 1 0], 2)));
set(h.sim_mode, 'Value', 2);
callback = h.sim_mode.Callback;
callback(h.sim_mode, []);
verifyEqual(testCase, h.sim_color.Value, 2);
set(h.sim_color, 'Value', 4);
callback = h.sim_color.Callback;
callback(h.sim_color, []);
set(h.sim_mode, 'Value', 1);
callback = h.sim_mode.Callback;
callback(h.sim_mode, []);
verifyEqual(testCase, h.sim_color.Value, 1);
set(h.sim_mode, 'Value', 2);
callback(h.sim_mode, []);
verifyEqual(testCase, h.sim_color.Value, 4);
end
