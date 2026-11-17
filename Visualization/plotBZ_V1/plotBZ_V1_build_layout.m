function plotBZ_V1_build_layout()
%PLOTBZ_V1_BUILD_LAYOUT Recreate the saved GUIDE interface without plot state.
%   Developer utility. Normal operation opens plotBZ_V1, not this builder.
%   Keep this source synchronized with edits to plotBZ_V1.fig.
folder = fileparts(mfilename('fullpath'));
layoutFile = fullfile(folder, 'plotBZ_V1.fig');
stored = load(layoutFile, 'hgS_070000', '-mat');
f = figure('Visible', 'off', 'Units', 'pixels', ...
    'Position', [80 90 1016 640], 'Name', 'Brillouin zones and ARPES', ...
    'NumberTitle', 'off', 'IntegerHandle', 'off', 'Tag', 'figure1', ...
    'HandleVisibility', 'callback', 'Resize', 'off', ...
    'MenuBar', 'none', 'ToolBar', 'none', 'Color', [0.96 0.96 0.96]);
cleanup = onCleanup(@() delete(f));
% Preserve GUIDE metadata without executing callbacks from the old layout.
if isfield(stored.hgS_070000.properties, 'ApplicationData')
    metadata = stored.hgS_070000.properties.ApplicationData;
    names = fieldnames(metadata);
    for index = 1:numel(names)
        if ~ismember(names{index}, {'UsedByGUIData_m','plotBZInitialized'})
            setappdata(f, names{index}, metadata.(names{index}));
        end
    end
end
guidata(f, []);
crystal = panel(f, 'Crystal and orientation', [8 30 296 602]);
plots = panel(f, 'Brillouin zones', [312 30 334 602]);
simulation = panel(f, 'ARPES experiment simulation', [654 30 354 602]);
buildCrystal(crystal);
buildPlots(plots);
buildSimulation(simulation);
control(f, 'text', 'statusText', ...
    'Lengths: A   |   Momenta: A^-1   |   Angles: degrees   |   Clear buttons preserve unrelated data.', ...
    [12 5 992 18], '');
% A saved invisible figure would launch invisibly through GUIDE.
set(f, 'Visible', 'on');
savefig(f, layoutFile);
end

function buildCrystal(parent)
entry(parent, 551, 'Crystal system', 'LatticeClass', ...
    {'Cubic','Tetragonal','Orthorhombic','Hexagonal', ...
    'Rhombohedral','Monoclinic','Triclinic'}, 'LatticeClass_Callback');
centering = uibuttongroup(parent, 'Title', 'Centering', ...
    'Tag', 'uipanel_LatticeType', 'Units', 'pixels', ...
    'Position', [8 453 280 83], 'FontSize', 9, 'FontWeight', 'bold', ...
    'ForegroundColor', [0.08 0.40 0.43], ...
    'BackgroundColor', [0.96 0.96 0.96]);
control(centering, 'radiobutton', 'radio_primitive', 'primitive', [8 38 124 20], '', 'Value', 1);
control(centering, 'radiobutton', 'radio_bodycentered', 'body-centered', [140 38 132 20], '');
control(centering, 'radiobutton', 'radio_facecentered', 'face-centered', [8 12 124 20], '');
control(centering, 'radiobutton', 'radio_basecentered', 'base-centered', [140 12 132 20], '');
lengths = panel(parent, 'Cell lengths (A)', [8 371 280 73], 'uipanel_Celllength');
tripleFields(lengths, {'a','b','c'}, {'a','b','c'}, {'3.1416','3.1416','3.1416'}, 'a_Callback');
angles = panel(parent, 'Cell angles (deg)', [8 289 280 73], 'uipanel_cellangle');
tripleFields(angles, {'alpha','beta','gamma'}, {'alpha','beta','gamma'}, {'90','90','90'}, 'alpha_Callback');
orientation = panel(parent, 'Surface normal (h k l)', [8 174 280 106]);
tripleFields(orientation, {'h','k','l'}, {'MillerH','MillerK','MillerL'}, {'0','0','1'}, '', 43);
mode = uibuttongroup(orientation, 'BorderType', 'none', 'Units', 'pixels', ...
    'Position', [5 2 267 23], 'BackgroundColor', [0.96 0.96 0.96]);
control(mode, 'radiobutton', 'radio_hklconv', 'Conventional', [2 1 132 20], '', 'Value', 1);
control(mode, 'radiobutton', 'radio_hklprim', 'Primitive', [140 1 122 20], '');
entry(parent, 148, 'Bulk rotation about kz', 'rot3DBZ', '0', '', ...
    'Positive right-handed rotation about the aligned surface normal.');
ranges = panel(parent, 'BZ centers: integer index ranges', [8 8 280 135]);
control(ranges, 'text', '', 'Basis', [8 94 92 18], '');
control(ranges, 'text', '', 'Start', [112 94 70 18], '');
control(ranges, 'text', '', 'End', [193 94 70 18], '');
names = {'Bulk b1','Bulk b2','Bulk b3','Surface s1','Surface s2'};
starts = {'KxStart','KyStart','KzStart','s1start','s2start'};
ends = {'KxEnd','KyEnd','KzEnd','s1end','s2end'};
for index = 1:5
    y = 94 - index*18;
    control(ranges, 'text', '', names{index}, [8 y 92 17], '');
    indexSpinner(ranges, starts{index}, ends{index}, true, 112, y);
    indexSpinner(ranges, ends{index}, starts{index}, false, 193, y);
end
end

function buildPlots(parent)
three = panel(parent, '3D bulk BZ', [8 447 318 130]);
plotTarget(three, 'ThreeDBZ', 91, '2020');
style(three, 'ThreeDBZ_width', 65, '1');
control(three, 'checkbox', 'TwoDh_of3D', 'Horizontal section', [8 40 150 20], '', ...
    'ForegroundColor', 'blue');
control(three, 'checkbox', 'TwoDp_of3D', 'Vertical section', [160 40 150 20], '', ...
    'ForegroundColor', 'green');
plotButtons(three, 'ThreeDBZ', 10);

surface = panel(parent, '2D projected surface BZ', [8 305 318 134]);
plotTarget(surface, 'SurfBZ', 95, '2021');
style(surface, 'edit93', 69, '1.5');
entry(surface, 41, 'In-plane rotation (deg)', 'rotsurBZ', '0', '');
plotButtons(surface, 'SurfBZ', 10);

horizontal = panel(parent, '2D horizontal bulk section', [8 161 318 136]);
set(horizontal, 'ForegroundColor', [0 0.30 0.75]);
plotTarget(horizontal, 'TwoDhBZ', 97, '2022');
style(horizontal, 'edit92', 71, '1.5');
entry(horizontal, 43, 'Offset (% of g_hkl)', 'shi2DhBZ', '0', '', ...
    'Plane position is offset/100 times the selected reciprocal normal.');
plotButtons(horizontal, 'TwoDhBZ', 10);

vertical = panel(parent, '2D vertical bulk section', [8 8 318 145]);
set(vertical, 'ForegroundColor', [0.08 0.48 0.22]);
plotTarget(vertical, 'TwoDpBZ', 106, '2023');
style(vertical, 'edit91', 80, '1.5');
entry(vertical, 54, 'Plane azimuth (deg)', 'rot2DpBZ', '0', '');
entry(vertical, 29, 'Display rotation (deg)', 'rot2DpBZ_inplane', '-90', '');
plotButtons(vertical, 'TwoDpBZ', 3);
end

function buildSimulation(parent)
entry(parent, 551, 'Measurement', 'sim_mode', ...
    {'Fixed photon energy','Photon energy scan'}, 'SimMode_Callback');
common = panel(parent, 'Shared final-state model', [8 381 338 159]);
entry(common, 116, 'Work function (eV)', 'sim_workFunction', '4.5', '');
entry(common, 88, 'Inner potential (eV)', 'sim_innerPotential', '15', '');
entry(common, 60, 'Binding energy (eV)', 'sim_bindingEnergy', '0', '');
entry(common, 32, 'Slit azimuth (deg)', 'sim_azimuth', '0', '');
control(common, 'text', '', 'Free-electron model; no photon momentum.', [8 4 320 20], '');
fixed = panel(parent, 'Fixed photon energy', [8 310 338 63]);
set(fixed, 'ForegroundColor', [0.75 0.29 0.02]);
entry(fixed, 20, 'Photon energy (eV)', 'sim_photonEnergy', '60', '');
angles = panel(parent, 'Angular sampling (deg)', [8 203 338 99]);
control(angles, 'text', '', 'Angle', [8 54 90 18], '');
control(angles, 'text', '', 'Start', [122 54 60 18], '');
control(angles, 'text', '', 'End', [194 54 60 18], '');
control(angles, 'text', '', 'Step', [266 54 60 18], '');
rangeRow(angles, 31, 'Polar', {'sim_polarMin','sim_polarMax','sim_polarStep'}, {'-15','15','1'});
rangeRow(angles, 6, 'Tilt (both modes)', {'sim_tiltMin','sim_tiltMax','sim_tiltStep'}, {'-15','15','1'});
photon = panel(parent, 'Photon energy scan', [8 99 338 96]);
set(photon, 'ForegroundColor', [0.50 0.20 0.67]);
control(photon, 'text', '', 'Energy (eV)', [8 52 90 18], '');
rangeRow(photon, 30, '', {'sim_photonMin','sim_photonMax','sim_photonStep'}, {'20','100','2'});
control(photon, 'text', '', 'Start / End / Step', [120 55 206 16], '');
entry(photon, 5, 'Fixed polar angle (deg)', 'sim_polarAngle', '0', '');
entry(parent, 69, 'Draw alongside', 'sim_target', ...
    {'3D BZ','Surface XY projection','Horizontal BZ section','Vertical BZ section'}, '');
control(parent, 'text', '', 'Color', [8 43 42 18], '');
control(parent, 'popupmenu', 'sim_color', {'Orange','Purple','Blue','Green','Black'}, ...
    [52 41 103 22], 'SimColor_Callback', ...
    'TooltipString', 'Color for the selected measurement mode; each mode remembers its own choice.');
control(parent, 'text', '', 'Opacity', [173 43 65 18], '');
control(parent, 'edit', 'sim_alpha', '0.25', [259 41 79 22], '');
control(parent, 'pushbutton', 'sim_plot', 'Plot / replace scan', [8 9 164 26], 'simulation_plot');
control(parent, 'pushbutton', 'sim_clear', 'Clear scan', [181 9 157 26], 'simulation_clear');
end

function tripleFields(parent, labels, tags, values, firstCallback, baseY)
if nargin < 6
    baseY = 11;
end
for index = 1:3
    x = 8 + (index-1)*91;
    control(parent, 'text', '', labels{index}, [x baseY+22 80 18], '');
    callback = '';
    if index == 1
        callback = firstCallback;
    end
    control(parent, 'edit', tags{index}, values{index}, [x baseY 80 22], callback);
end
end

function plotTarget(parent, prefix, y, number)
control(parent, 'text', '', 'Figure', [8 y+2 44 18], '');
control(parent, 'edit', [prefix '_fig'], number, [54 y 66 22], '');
control(parent, 'text', '', 'Color', [136 y+2 44 18], '');
selection = 1;
callback = '';
if strcmp(prefix, 'TwoDhBZ')
    selection = 2;
    callback = 'SectionColor_Callback';
elseif strcmp(prefix, 'TwoDpBZ')
    selection = 4;
    callback = 'SectionColor_Callback';
end
control(parent, 'popupmenu', [prefix '_color'], ...
    {'Black','Blue','Cyan','Green','Magenta','Red','Yellow','White'}, ...
    [183 y 125 22], callback, 'Value', selection);
end

function indexSpinner(parent, field, pairedField, isStart, x, y)
% Keep GUIDE edit tags stable while adding one-index decrement/increment.
control(parent, 'edit', field, '0', [x+18 y 34 18], '', ...
    'TooltipString', 'Integer zone index; use minus/plus to change by one.');
directions = [-1 1];
suffixes = {'_down','_up'};
labels = {'-','+'};
for index = 1:2
    data = struct('field', field, 'pairedField', pairedField, ...
        'step', directions(index), 'isStart', isStart);
    control(parent, 'pushbutton', [field suffixes{index}], labels{index}, ...
        [x+(index-1)*52 y 18 18], 'RangeStep_Callback', ...
        'FontSize', 8, 'UserData', data, ...
        'TooltipString', 'Change this index by one; keep the start/end range ordered.');
end
end

function style(parent, tag, y, value)
control(parent, 'text', '', 'Line width (pt)', [8 y+2 170 18], '');
control(parent, 'edit', tag, value, [183 y 125 22], '');
end

function plotButtons(parent, prefix, y)
control(parent, 'pushbutton', [prefix '_plot'], 'Plot BZ', [8 y 146 25], [prefix '_plot_Callback']);
control(parent, 'pushbutton', [prefix '_clear'], 'Clear BZ', [162 y 146 25], [prefix '_clear_Callback']);
end

function rangeRow(parent, y, label, tags, values)
control(parent, 'text', '', label, [8 y+1 112 20], '');
for index = 1:3
    control(parent, 'edit', tags{index}, values{index}, [122+(index-1)*72 y 60 22], '');
end
end

function entry(parent, y, label, tag, value, callback, tooltip)
if nargin < 7
    tooltip = '';
end
width = get(parent, 'Position');
width = width(3);
control(parent, 'text', '', label, [8 y+2 169 20], '');
styleName = 'edit';
if iscell(value)
    styleName = 'popupmenu';
end
control(parent, styleName, tag, value, [183 y width-193 22], callback, ...
    'TooltipString', tooltip);
end

function h = panel(parent, title, position, tag)
if nargin < 4
    tag = '';
end
h = uipanel(parent, 'Title', title, 'Tag', tag, 'Units', 'pixels', ...
    'Position', position, 'FontSize', 9, 'FontWeight', 'bold', ...
    'BackgroundColor', [0.96 0.96 0.96]);
if isgraphics(parent, 'figure')
    set(h, 'ForegroundColor', [0.10 0.21 0.37]);
else
    set(h, 'ForegroundColor', [0.08 0.40 0.43]);
end
end

function h = control(parent, styleName, tag, label, position, callback, varargin)
h = uicontrol(parent, 'Style', styleName, 'Tag', tag, 'String', label, ...
    'Units', 'pixels', 'Position', position, 'FontSize', 9, varargin{:});
if any(strcmp(styleName, {'text','radiobutton','checkbox'}))
    set(h, 'HorizontalAlignment', 'left', 'BackgroundColor', [0.96 0.96 0.96]);
elseif any(strcmp(styleName, {'edit','popupmenu'}))
    set(h, 'BackgroundColor', 'white');
end
if strcmp(callback, 'simulation_plot')
    set(h, 'Callback', @(s,~) plotBZ_V1_simulation('plot', guidata(s)));
elseif strcmp(callback, 'simulation_clear')
    set(h, 'Callback', @(s,~) plotBZ_V1_simulation('clear', guidata(s)));
elseif ~isempty(callback)
    set(h, 'Callback', @(s,e) plotBZ_V1(callback, s, e, guidata(s)));
end
end
