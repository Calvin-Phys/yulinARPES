function varargout = plotBZ_V1(varargin)
%PLOTBZ_V1 Configure crystal geometry, plot BZs, and simulate ARPES scans.
%   F = PLOTBZ_V1 opens or raises the singleton control panel. Cell lengths
%   are in angstrom, angles in degrees, and plotted momenta in angstrom^-1.
%   The selected Miller normal becomes +kz in the bulk plotting frame.
%   See plotBZ_V1_simulation and plotBZ_V1_build_layout.

guiState = struct('gui_Name', mfilename, 'gui_Singleton', 1, ...
    'gui_OpeningFcn', @plotBZ_V1_OpeningFcn, ...
    'gui_OutputFcn', @plotBZ_V1_OutputFcn, ...
    'gui_LayoutFcn', [], 'gui_Callback', []);
if nargin && ischar(varargin{1})
    guiState.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(guiState, varargin{:});
else
    gui_mainfcn(guiState, varargin{:});
end
end

function plotBZ_V1_OpeningFcn(figureHandle, ~, handles, varargin)
handles.output = figureHandle;
guidata(figureHandle, handles);
% GUIDE calls OpeningFcn when raising the singleton as well as on creation.
% Initialize once so later calls retain the selected centering and settings.
if ~isappdata(figureHandle, 'plotBZInitialized')
    LatticeClass_Callback([], [], handles);
    SimMode_Callback([], [], handles);
    SectionColor_Callback([], [], handles);
    setappdata(figureHandle, 'plotBZInitialized', true);
end
end

function figureHandle = plotBZ_V1_OutputFcn(~, ~, handles)
figureHandle = handles.output;
end

function LatticeClass_Callback(~, ~, handles)
% Start from unconstrained parameters, then apply the selected cell metric.
classes = get(handles.LatticeClass, 'String');
system = classes{get(handles.LatticeClass, 'Value')};
set([handles.a handles.b handles.c handles.alpha handles.beta handles.gamma], ...
    'Enable', 'on');
set([handles.radio_bodycentered handles.radio_facecentered ...
    handles.radio_basecentered], 'Enable', 'off');
set(handles.uipanel_LatticeType, 'SelectedObject', handles.radio_primitive);
set(handles.radio_primitive, 'Enable', 'on');
switch system
    case 'Cubic'
        set([handles.radio_bodycentered handles.radio_facecentered], 'Enable', 'on');
        constrain(handles.b, get(handles.a, 'String'));
        constrain(handles.c, get(handles.a, 'String'));
        constrain([handles.alpha handles.beta handles.gamma], '90');
    case 'Tetragonal'
        set(handles.radio_bodycentered, 'Enable', 'on');
        constrain(handles.b, get(handles.a, 'String'));
        constrain([handles.alpha handles.beta handles.gamma], '90');
    case 'Orthorhombic'
        set([handles.radio_bodycentered handles.radio_facecentered ...
            handles.radio_basecentered], 'Enable', 'on');
        constrain([handles.alpha handles.beta handles.gamma], '90');
    case 'Hexagonal'
        constrain(handles.b, get(handles.a, 'String'));
        constrain([handles.alpha handles.beta], '90');
        constrain(handles.gamma, '120');
    case 'Rhombohedral'
        constrain([handles.b handles.c], get(handles.a, 'String'));
        constrain([handles.beta handles.gamma], get(handles.alpha, 'String'));
    case 'Monoclinic'
        set(handles.radio_basecentered, 'Enable', 'on');
        constrain([handles.alpha handles.gamma], '90');
    case 'Triclinic'
        % All six independent cell parameters remain editable.
end
end

function constrain(controls, value)
set(controls, 'Enable', 'off', 'String', value);
end

function a_Callback(source, ~, handles)
% Synchronize lengths constrained by the selected crystal system.
fields = {'b', 'c'};
for index = 1:numel(fields)
    control = handles.(fields{index});
    if strcmp(get(control, 'Enable'), 'off')
        set(control, 'String', get(source, 'String'));
    end
end
end

function alpha_Callback(source, ~, handles)
if get(handles.LatticeClass, 'Value') == 5
    set([handles.beta, handles.gamma], 'String', get(source, 'String'));
end
end

function SimMode_Callback(~, ~, handles)
isFixed = get(handles.sim_mode, 'Value') == 1;
set(handles.sim_photonEnergy, 'Enable', onOff(isFixed));
set([handles.sim_polarMin handles.sim_polarMax handles.sim_polarStep], ...
    'Enable', onOff(isFixed));
set([handles.sim_photonMin handles.sim_photonMax handles.sim_photonStep ...
    handles.sim_polarAngle], 'Enable', onOff(~isFixed));
plotBZ_V1_simulation_color('mode', handles);
end

function SimColor_Callback(~, ~, handles)
plotBZ_V1_simulation_color('change', handles);
end

function SectionColor_Callback(~, ~, handles)
% The 3D section indicators follow the same colors as the 2D section plots.
set(handles.TwoDh_of3D, 'ForegroundColor', ...
    plotBZ_V1_popup_color(handles.TwoDhBZ_color));
set(handles.TwoDp_of3D, 'ForegroundColor', ...
    plotBZ_V1_popup_color(handles.TwoDpBZ_color));
end

function RangeStep_Callback(source, ~, handles)
% Read both fields first so a malformed bound never causes a partial change.
data = get(source, 'UserData');
value = plotBZ_V1_parse_scalar(handles, data.field, 'integer');
pairedValue = plotBZ_V1_parse_scalar(handles, data.pairedField, 'integer');
updatedValue = value + data.step;
if ~isfinite(updatedValue) || updatedValue - value ~= data.step
    error('plotBZ_V1:InvalidInput', 'This index cannot be changed by one at its current magnitude.');
end
if (data.isStart && updatedValue > pairedValue) || ...
        (~data.isStart && updatedValue < pairedValue)
    pairedValue = updatedValue;
end
set(handles.(data.field), 'String', sprintf('%.0f', updatedValue));
set(handles.(data.pairedField), 'String', sprintf('%.0f', pairedValue));
end

function value = onOff(condition)
if condition
    value = 'on';
else
    value = 'off';
end
end

function SurfBZ_plot_Callback(~, ~, handles)
plotZone(handles, 'surface');
end

function TwoDpBZ_plot_Callback(~, ~, handles)
plotZone(handles, 'vertical');
end

function TwoDhBZ_plot_Callback(~, ~, handles)
plotZone(handles, 'horizontal');
end

function ThreeDBZ_plot_Callback(~, ~, handles)
plotZone(handles, '3d');
end

function SurfBZ_clear_Callback(~, ~, handles)
clearZone(handles, 'SurfBZ_fig');
end

function TwoDpBZ_clear_Callback(~, ~, handles)
clearZone(handles, 'TwoDpBZ_fig');
end

function TwoDhBZ_clear_Callback(~, ~, handles)
clearZone(handles, 'TwoDhBZ_fig');
end

function ThreeDBZ_clear_Callback(~, ~, handles)
clearZone(handles, 'ThreeDBZ_fig');
end

function clearZone(handles, field)
number = plotBZ_V1_parse_scalar(handles, field, 'figure');
validateTarget(handles, number);
plotBZ_V1_clear_graphics(number);
end

function plotZone(handles, kind)
% Validate and construct geometry before changing the target figure.
SectionColor_Callback([], [], handles);
[prefix, widthField] = plotFields(kind);
number = plotBZ_V1_parse_scalar(handles, [prefix '_fig'], 'figure');
validateTarget(handles, number);
color = plotBZ_V1_popup_color(handles.([prefix '_color']));
width = 1;
if ~isempty(widthField)
    width = plotBZ_V1_parse_scalar(handles, widthField, 'positive');
end
[b1, b2, b3, normal] = plotBZ_V1_construct_rec_lattice_vectors(handles);
if strcmp(kind, 'surface')
    [s1, s2] = plotBZ_V1_surface_realtime_vector(b1, b2, b3, normal, handles);
    [sites, rows] = plotBZ_V1_construct_surf_rec_lattice(s1, s2, handles);
else
    [b1, b2, b3, normal] = ...
        plotBZ_V1_bulk_realtime_vector(b1, b2, b3, normal, handles);
    [sites, rows] = plotBZ_V1_construct_bulk_rec_lattice(b1, b2, b3, handles);
end
[vertices, cells] = voronoin(sites);
[horizontal, vertical, inPlane] = sectionPlanes(handles, normal, kind);

targetFigure = figure(number);
plotBZ_V1_vector_output(targetFigure);
ax = gca;
previousGraphics = findall(ax);
state = captureAxes(ax);
axesCleanup = onCleanup(@() restoreAxes(ax, state));
hold(ax, 'on');
for row = rows
    cellVertices = vertices(cells{row}, :);
    if strcmp(kind, 'surface')
        boundary = convhull(cellVertices);
        plot(ax, cellVertices(boundary, 1), cellVertices(boundary, 2), ...
            'LineWidth', width, 'Color', color);
        continue
    end
    triangles = convhull(cellVertices, 'Simplify', true);
    faces = mergeCoplanarFaces(cellVertices, triangles);
    switch kind
        case '3d'
            drawPoint3d(sites(row, :));
            drawMesh(cellVertices, faces, 'FaceColor', 'none', 'EdgeColor', color, 'LineWidth', width);
            if get(handles.TwoDh_of3D, 'Value')
                drawSection(cellVertices, faces, horizontal, 180, number, 0, ...
                    plotBZ_V1_popup_color(handles.TwoDhBZ_color), 1);
            end
            if get(handles.TwoDp_of3D, 'Value')
                drawSection(cellVertices, faces, vertical, -90, number, 0, ...
                    plotBZ_V1_popup_color(handles.TwoDpBZ_color), 1);
            end
        case 'horizontal'
            drawSection(cellVertices, faces, horizontal, 180, 0, number, color, width);
        case 'vertical'
            drawSection(cellVertices, faces, vertical, inPlane, 0, number, color, width);
    end
end
plotBZ_V1_tag_graphics(ax, previousGraphics);
if ~state.hasData
    axis(ax, 'equal');
    if strcmp(kind, '3d')
        view(ax, 3);
        xlabel(ax, 'k_x (A^{-1})'); ylabel(ax, 'k_y (A^{-1})');
        zlabel(ax, 'k_z (A^{-1})');
    elseif strcmp(kind, 'surface')
        xlabel(ax, 'k_x (A^{-1})'); ylabel(ax, 'k_y (A^{-1})');
    end
end
end

function [prefix, widthField] = plotFields(kind)
switch kind
    case 'surface'
        prefix = 'SurfBZ'; widthField = 'edit93';
    case 'horizontal'
        prefix = 'TwoDhBZ'; widthField = 'edit92';
    case 'vertical'
        prefix = 'TwoDpBZ'; widthField = 'edit91';
    case '3d'
        prefix = 'ThreeDBZ'; widthField = 'ThreeDBZ_width';
end
end

function [horizontal, vertical, inPlane] = sectionPlanes(handles, normal, kind)
horizontal = []; vertical = []; inPlane = 0;
if strcmp(kind, 'horizontal') || strcmp(kind, '3d')
    offset = plotBZ_V1_parse_scalar(handles, 'shi2DhBZ');
    horizontal = createPlane((offset/100)*normal, normal);
end
if strcmp(kind, 'vertical') || strcmp(kind, '3d')
    azimuth = plotBZ_V1_parse_scalar(handles, 'rot2DpBZ');
    direction = (plotBZ_V1_rotation('z', azimuth)* ...
        plotBZ_V1_rotation('x', 90)*normal')';
    vertical = createPlane([0 0 0], direction);
    inPlane = plotBZ_V1_parse_scalar(handles, 'rot2DpBZ_inplane');
end
end

function drawSection(vertices, faces, plane, rotation, figure3d, figure2d, color, width)
plotBZ_V1_intersectBZ(vertices, faces, plane, rotation, figure3d, figure2d, ...
    'LineWidth', width, 'Color', color);
end

function state = captureAxes(ax)
state.hasData = ~isempty(get(ax, 'Children'));
state.nextPlot = get(ax, 'NextPlot');
state.limits = [xlim(ax); ylim(ax); zlim(ax)];
state.view = get(ax, 'View');
state.aspect = get(ax, 'DataAspectRatio');
state.aspectMode = get(ax, 'DataAspectRatioMode');
state.limitModes = {get(ax, 'XLimMode'), get(ax, 'YLimMode'), get(ax, 'ZLimMode')};
end

function restoreAxes(ax, state)
if ~isgraphics(ax)
    return
end
set(ax, 'NextPlot', state.nextPlot);
if state.hasData
    xlim(ax, state.limits(1, :));
    ylim(ax, state.limits(2, :));
    zlim(ax, state.limits(3, :));
    set(ax, 'View', state.view, 'DataAspectRatio', state.aspect, ...
        'DataAspectRatioMode', state.aspectMode);
    set(ax, 'XLimMode', state.limitModes{1}, ...
        'YLimMode', state.limitModes{2}, 'ZLimMode', state.limitModes{3});
end
end

function validateTarget(handles, number)
if isfield(handles, 'figure1') && isgraphics(handles.figure1) && ...
        isequal(get(handles.figure1, 'Number'), number)
    error('plotBZ_V1:InvalidInput', 'Select a plot figure, not the control panel.');
end
end
