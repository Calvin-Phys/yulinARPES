function varargout = kz_plot(varargin)
%KZ_PLOT Manage photon-energy cut overlays in the (kz,kx) plane.
%   KZ_PLOT opens a singleton GUIDE interface. Add curve creates an overlay;
%   selecting a list entry loads its parameters for Update or Delete.
%   Energies are in eV, angles in degrees, and momenta in inverse angstroms.
%   Curves retain their parameters on the line graphics object, so reopening
%   this panel can recover overlays still present in open MATLAB figures.
%
%   H = KZ_PLOT returns the panel figure. The accompanying kz_plot.fig stores
%   the layout and callback bindings. Existing GUIDE callback dispatch and
%   property/value launch arguments are supported by gui_mainfcn.

gui_State = struct('gui_Name', mfilename, 'gui_Singleton', 1, ...
    'gui_OpeningFcn', @kz_plot_OpeningFcn, ...
    'gui_OutputFcn', @kz_plot_OutputFcn, ...
    'gui_LayoutFcn', [], 'gui_Callback', []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end

function kz_plot_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
handles.curves = gobjects(0);
guidata(hObject, handles);
refreshCurves(hObject, []);
end

function varargout = kz_plot_OutputFcn(~, ~, handles)
varargout{1} = handles.output;
end

function pushbutton1_Callback(hObject, ~, ~)
% Keep the original GUIDE button entry point for the Add action.
applyCurve(hObject, false);
end

function updateCurve_Callback(hObject, ~, ~)
applyCurve(hObject, true);
end

function applyCurve(source, updating)
handles = guidata(source);
selected = selectedCurve(handles);
if updating && isempty(selected)
    set(handles.statusText, 'String', 'Select an attached curve to update.');
    return;
end
try
    p = readParameters(handles);
    [kz, kx] = calculateCut(p);
catch exception
    errordlg(exception.message, 'Invalid cut parameters', 'modal');
    return;
end
% Preserve an existing plot's view and NextPlot state. New axes autoscale.
targetFigure = figure(p.figureNumber);
ax = get(targetFigure, 'CurrentAxes');
if isempty(ax)
    ax = axes('Parent', targetFigure);
end
hasContent = ~isempty(allchild(ax));
oldXLim = xlim(ax);
oldYLim = ylim(ax);
nextPlot = get(ax, 'NextPlot');
restorePlot = onCleanup(@() set(ax, 'NextPlot', nextPlot));
set(ax, 'NextPlot', 'add');
if updating
    curve = selected;
    previous = getappdata(curve, 'kzPlotParameters');
    label = previous.label;
    set(curve, 'Parent', ax, 'XData', kz, 'YData', kx, ...
        'Color', p.color, 'LineWidth', p.lineWidth);
    if isgraphics(label, 'text')
        set(label, 'Parent', ax, 'Position', [kz(1), kx(1), 0], ...
            'String', sprintf('%g eV', p.photonEnergy), 'Color', p.color);
    else
        label = createLabel(ax, kz, kx, p);
    end
else
    curve = plot(ax, kz, kx, 'Color', p.color, 'LineWidth', p.lineWidth, ...
        'Tag', 'kz_plot_curve');
    label = createLabel(ax, kz, kx, p);
end
p.label = label;
setappdata(curve, 'kzPlotParameters', p);
if hasContent
    xlim(ax, oldXLim);
    ylim(ax, oldYLim);
end
set(curve, 'DisplayName', sprintf('hnu = %g eV', p.photonEnergy), ...
    'DeleteFcn', @(s,e) kz_plot('curveDeleted_Callback', s, e));
refreshCurves(source, curve);
if updating
    message = 'Selected curve updated.';
else
    message = 'Curve added. Select a row to edit or delete.';
end
set(handles.statusText, 'String', message);
end

function label = createLabel(ax, kz, kx, p)
label = text(ax, kz(1), kx(1), sprintf('%g eV', p.photonEnergy), ...
    'Color', p.color, 'Tag', 'kz_plot_label', 'Interpreter', 'none');
end

function p = readParameters(h)
% Parse plain scalar numbers; never evaluate UI text as MATLAB code.
p.figureNumber = str2double(get(h.FigNum, 'String'));
p.photonEnergy = str2double(get(h.hv, 'String'));
p.workFunction = str2double(get(h.w, 'String'));
p.innerPotential = str2double(get(h.V0, 'String'));
p.thetaStart = str2double(get(h.edit9, 'String'));
p.thetaEnd = str2double(get(h.edit10, 'String'));
p.thetaStep = str2double(get(h.thetaStep, 'String'));
p.lineWidth = str2double(get(h.lineWidth, 'String'));
values = [p.figureNumber, p.photonEnergy, p.workFunction, ...
    p.innerPotential, p.thetaStart, p.thetaEnd, p.thetaStep, p.lineWidth];
if ~isreal(values) || any(~isfinite(values))
    error('kz_plot:InvalidNumber', 'All entries must be finite real numbers.');
end
if p.figureNumber < 1 || p.figureNumber ~= fix(p.figureNumber)
    error('kz_plot:InvalidFigure', 'Figure number must be a positive integer.');
end
if isequal(get(h.output, 'Number'), p.figureNumber)
    error('kz_plot:PanelTarget', 'Choose a target figure other than this control panel.');
end
if p.photonEnergy < p.workFunction || p.workFunction < 0
    error('kz_plot:InvalidEnergy', ...
        'Require photon energy >= work function >= 0 eV.');
end
if p.thetaStep <= 0 || p.lineWidth <= 0
    error('kz_plot:InvalidStep', 'Theta step and line width must be positive.');
end
if abs(p.thetaEnd - p.thetaStart) / p.thetaStep > 100000
    error('kz_plot:TooManyPoints', 'Increase theta step to use at most 100001 samples.');
end
colors = curveColors();
p.colorIndex = get(h.curveColor, 'Value');
p.color = colors(p.colorIndex, :);
end

function [kz, kx] = calculateCut(p)
% The step is a positive spacing magnitude, including for descending ranges.
direction = sign(p.thetaEnd - p.thetaStart);
if direction == 0
    theta = p.thetaStart;
else
    theta = p.thetaStart : direction*p.thetaStep : p.thetaEnd;
    % Include the final angle; a final interval may be shorter than the step.
    if abs(theta(end) - p.thetaEnd) > 1e-10
        theta(end+1) = p.thetaEnd;
    end
end
kineticEnergy = p.photonEnergy - p.workFunction;
momentumConversion = 0.512316722; % (A^-1)/sqrt(eV)
% Free-electron final-state model at EF; cosd avoids tangent singularities.
kzRadicand = kineticEnergy .* cosd(theta).^2 + p.innerPotential;
if any(kzRadicand < 0) || any(~isfinite(kzRadicand))
    error('kz_plot:InvalidKz', 'Inner potential gives non-real or nonfinite kz.');
end
kx = momentumConversion * sqrt(kineticEnergy) .* sind(theta);
kz = momentumConversion * sqrt(kzRadicand);
end

function curve = selectedCurve(h)
curve = [];
index = get(h.curveList, 'Value');
if index >= 1 && index <= numel(h.curves) && isgraphics(h.curves(index), 'line')
    curve = h.curves(index);
end
end

function refresh_Callback(hObject, ~, ~)
refreshCurves(hObject, []);
end

function refreshCurves(source, preferred)
% Discover managed overlays across open figures, also after reopening panel.
h = guidata(source);
if isempty(preferred)
    preferred = selectedCurve(h);
end
curves = findall(groot, 'Type', 'line', 'Tag', 'kz_plot_curve');
valid = arrayfun(@(c) isappdata(c, 'kzPlotParameters'), curves);
h.curves = flipud(curves(valid));
count = numel(h.curves);
entries = cell(count, 1);
for k = 1:count
    p = getappdata(h.curves(k), 'kzPlotParameters');
    entries{k} = sprintf('F%g | %g eV | %g:%g:%g', ...
        p.figureNumber, p.photonEnergy, p.thetaStart, p.thetaStep, p.thetaEnd);
end
index = [];
if ~isempty(preferred)
    index = find(h.curves == preferred, 1);
end
if isempty(index), index = 1; end
if count == 0
    entries = {'No attached curves'};
    enabled = 'off';
else
    enabled = 'on';
end
set(h.curveList, 'String', entries, 'Value', index, 'Enable', enabled);
set(h.curveCount, 'String', sprintf('Attached curves (%d)', count));
set([h.updateCurve, h.deleteCurve], 'Enable', enabled);
guidata(h.output, h);
end

function curveList_Callback(hObject, ~, ~)
h = guidata(hObject);
curve = selectedCurve(h);
if isempty(curve)
    refreshCurves(hObject, []);
    return;
end
p = getappdata(curve, 'kzPlotParameters');
tags = {'FigNum','hv','w','V0','edit9','edit10','thetaStep','lineWidth'};
values = [p.figureNumber, p.photonEnergy, p.workFunction, p.innerPotential, ...
    p.thetaStart, p.thetaEnd, p.thetaStep, p.lineWidth];
for k = 1:numel(tags)
    set(h.(tags{k}), 'String', num2str(values(k), 12));
end
set(h.curveColor, 'Value', p.colorIndex);
syncSlider(h, p.photonEnergy);
set(h.statusText, 'String', 'Parameters loaded. Edit fields, then click Update.');
end

function deleteCurve_Callback(hObject, ~, ~)
h = guidata(hObject);
curve = selectedCurve(h);
if ~isempty(curve)
    delete(curve); % DeleteFcn removes only this curve's associated label.
end
refreshCurves(hObject, []);
set(h.statusText, 'String', 'Selected curve deleted.');
end

function curveDeleted_Callback(curve, ~)
% Also clean up the label if a user deletes the line from the target figure.
if isappdata(curve, 'kzPlotParameters')
    p = getappdata(curve, 'kzPlotParameters');
    if isgraphics(p.label, 'text'), delete(p.label); end
end
end

function hv_Callback(hObject, ~, ~)
h = guidata(hObject);
value = str2double(get(h.hv, 'String'));
if isscalar(value) && isreal(value) && isfinite(value) && value >= 0
    syncSlider(h, value);
end
end

function syncSlider(h, value)
% Expand the initial 0--200 eV range to accommodate typed larger values.
maximum = max(200, ceil(value));
set(h.hvSlider, 'Min', 0, 'Max', maximum, 'Value', value, ...
    'SliderStep', [1/maximum, 1/maximum]);
set(h.sliderRange, 'String', sprintf('0 - %g eV', maximum));
end

function hvSlider_Callback(hObject, ~, ~)
h = guidata(hObject);
% Snap thumb dragging as well as arrow/page clicks to whole eV values.
value = round(get(hObject, 'Value'));
set(hObject, 'Value', value);
set(h.hv, 'String', num2str(value, 8));
end

function colors = curveColors()
colors = [0.4660 0.6740 0.1880; 0 0.4470 0.7410; ...
    0.8500 0.3250 0.0980; 0.4940 0.1840 0.5560; 0 0 0];
end
