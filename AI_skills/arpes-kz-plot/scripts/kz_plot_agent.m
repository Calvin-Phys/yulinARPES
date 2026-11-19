function result = kz_plot_agent(action, figureNumber, photonEnergy, varargin)
%KZ_PLOT_AGENT Operate managed overlays through kz_plot's GUIDE callbacks.
%   C = kz_plot_agent('list') lists all managed curves without opening a UI.
%   C = kz_plot_agent('list', FIG) restricts inventory to figure FIG.
%   C = kz_plot_agent('add', FIG, HV) adds HV eV using explicit defaults.
%   C = kz_plot_agent('update', FIG, OLDHV, 'NewPhotonEnergy', NEWHV)
%   C = kz_plot_agent('delete', FIG, HV) deletes one uniquely matched curve.
%
%   Options for add/update: WorkFunction, InnerPotential, ThetaStart,
%   ThetaEnd, ThetaStep, LineWidth, Color (green/blue/orange/purple/black).
%   Update also accepts TargetFigure and NewPhotonEnergy. Update/delete
%   accept Curve, a line handle from inventory, to disambiguate duplicates.
%   Updates retain unspecified parameters; adds reset them to tool defaults.
%   Returns inventory entries with Curve, Label, FigureNumber, PhotonEnergy,
%   WorkFunction, InnerPotential, ThetaStart, ThetaEnd, ThetaStep, LineWidth,
%   and Color. Delete returns remaining entries in the original target.

if nargin < 2, figureNumber = []; end
if nargin < 3, photonEnergy = []; end
action = validatestring(action, {'list','add','update','delete'});
if ~isempty(figureNumber)
    validateattributes(figureNumber, {'numeric'}, ...
        {'real','finite','scalar','integer','positive'});
end
inventory = listCurves(figureNumber);
if strcmp(action, 'list')
    if ~isempty(photonEnergy) || ~isempty(varargin)
        error('kz_plot_agent:ListOptions', 'List accepts only an optional figure number.');
    end
    result = inventory;
    return;
end
validateattributes(figureNumber, {'numeric'}, ...
    {'real','finite','scalar','integer','positive','nonempty'});
validateattributes(photonEnergy, {'numeric'}, {'real','finite','scalar','nonnegative'});
parser = inputParser;
parser.PartialMatching = false;
names = {'WorkFunction','InnerPotential','ThetaStart','ThetaEnd', ...
    'ThetaStep','LineWidth','Color','TargetFigure','NewPhotonEnergy','Curve'};
for k = 1:numel(names), addParameter(parser, names{k}, []); end
parse(parser, varargin{:});
options = parser.Results;
supplied = setdiff(names, parser.UsingDefaults);
if strcmp(action, 'delete') && ~isempty(setdiff(supplied, {'Curve'}))
    error('kz_plot_agent:DeleteOptions', 'Delete accepts only the Curve selector.');
end
if strcmp(action, 'add') && ...
        ~isempty(intersect(supplied, {'Curve','TargetFigure','NewPhotonEnergy'}))
    error('kz_plot_agent:AddOptions', 'Add takes its figure and energy positionally.');
end
selected = [];
if ~strcmp(action, 'add')
    matches = find(abs([inventory.PhotonEnergy] - photonEnergy) <= 1e-8);
    if ismember('Curve', supplied)
        if ~isscalar(options.Curve) || ~isgraphics(options.Curve, 'line')
            error('kz_plot_agent:InvalidCurve', 'Curve must be a live managed line handle.');
        end
        matches = matches(arrayfun(@(k) isequal(inventory(k).Curve, options.Curve), matches));
    end
    if numel(matches) ~= 1
        error('kz_plot_agent:NonUniqueMatch', ...
            'Figure %g / %g eV matches %d curves; inspect inventory and disambiguate.', ...
            figureNumber, photonEnergy, numel(matches));
    end
    selected = inventory(matches).Curve;
    p = inventory(matches);
else
    p = struct('FigureNumber', figureNumber, 'PhotonEnergy', photonEnergy, ...
        'WorkFunction', 4.5, 'InnerPotential', 15, 'ThetaStart', -15, ...
        'ThetaEnd', 15, 'ThetaStep', 1, 'LineWidth', 1.5, 'Color', 'green');
end
for name = {'WorkFunction','InnerPotential','ThetaStart','ThetaEnd','ThetaStep','LineWidth','Color'}
    if ismember(name{1}, supplied), p.(name{1}) = options.(name{1}); end
end
if ismember('NewPhotonEnergy', supplied), p.PhotonEnergy = options.NewPhotonEnergy; end
if ismember('TargetFigure', supplied), p.FigureNumber = options.TargetFigure; end
% Validate before touching the panel, avoiding modal GUI validation dialogs.
if ~strcmp(action, 'delete'), p = validateParameters(p); end
panel = kz_plot;
h = guidata(panel);
if isequal(panel.Number, p.FigureNumber)
    error('kz_plot_agent:PanelTarget', 'The control panel cannot be the target figure.');
end
invoke(h.refreshCurves);
h = guidata(panel);
if ~isempty(selected)
    row = find(h.curves == selected, 1);
    if isempty(row), error('kz_plot_agent:StaleCurve', 'Curve disappeared; re-list before retrying.'); end
    set(h.curveList, 'Value', row);
    invoke(h.curveList);
end
if strcmp(action, 'delete')
    label = getappdata(selected, 'kzPlotParameters');
    invoke(h.deleteCurve);
    assert(~isgraphics(selected) && ~isgraphics(label.label), ...
        'kz_plot_agent:DeleteFailed', 'Curve or label survived deletion.');
    result = listCurves(figureNumber);
    return;
end
fields = {'FigNum','hv','w','V0','edit9','edit10','thetaStep','lineWidth'};
values = [p.FigureNumber p.PhotonEnergy p.WorkFunction p.InnerPotential ...
    p.ThetaStart p.ThetaEnd p.ThetaStep p.LineWidth];
for k = 1:numel(fields), set(h.(fields{k}), 'String', num2str(values(k), 17)); end
colors = {'green','blue','orange','purple','black'};
set(h.curveColor, 'Value', find(strcmp(colors, p.Color)));
invoke(h.hv); % Synchronize slider even for fractional or >200 eV entries.
if strcmp(action, 'add'), invoke(h.pushbutton1); else, invoke(h.updateCurve); end
h = guidata(panel);
if strcmp(action, 'add'), selected = h.curves(h.curveList.Value); end
after = listCurves(p.FigureNumber);
index = find(arrayfun(@(c) isequal(c.Curve, selected), after), 1);
assert(~isempty(index), 'kz_plot_agent:ActionFailed', 'Managed curve not found after action.');
result = after(index);
assert(isgraphics(result.Label, 'text'), 'kz_plot_agent:LabelFailed', 'Curve label missing.');
for name = {'FigureNumber','PhotonEnergy','WorkFunction','InnerPotential', ...
        'ThetaStart','ThetaEnd','ThetaStep','LineWidth','Color'}
    assert(isequal(result.(name{1}), p.(name{1})), ...
        'kz_plot_agent:ParameterMismatch', 'Curve parameters did not match the requested action.');
end
assert(numel(result.Curve.XData) == numel(result.Curve.YData) && ...
    all(isfinite(result.Curve.XData)) && all(isfinite(result.Curve.YData)), ...
    'kz_plot_agent:InvalidGraphics', 'Curve contains invalid plotted data.');
end

function invoke(control)
callback = get(control, 'Callback');
feval(callback, control, []);
end

function p = validateParameters(p)
for name = {'FigureNumber','PhotonEnergy','WorkFunction','InnerPotential', ...
        'ThetaStart','ThetaEnd','ThetaStep','LineWidth'}
    validateattributes(p.(name{1}), {'numeric'}, {'real','finite','scalar'});
end
validateattributes(p.FigureNumber, {'numeric'}, {'integer','positive'});
validateattributes(p.WorkFunction, {'numeric'}, {'nonnegative'});
validateattributes(p.ThetaStep, {'numeric'}, {'positive'});
validateattributes(p.LineWidth, {'numeric'}, {'positive'});
if p.PhotonEnergy < p.WorkFunction
    error('kz_plot_agent:InvalidEnergy', 'Photon energy must be at least the work function.');
end
if abs(p.ThetaEnd-p.ThetaStart)/p.ThetaStep > 100000
    error('kz_plot_agent:TooManySamples', 'Increase theta step to limit the sample count.');
end
theta = p.ThetaStart;
if p.ThetaStart ~= p.ThetaEnd
    theta = [p.ThetaStart:sign(p.ThetaEnd-p.ThetaStart)*p.ThetaStep:p.ThetaEnd, p.ThetaEnd];
end
radicand = (p.PhotonEnergy-p.WorkFunction)*cosd(theta).^2 + p.InnerPotential;
if any(~isfinite(radicand)) || any(radicand < 0)
    error('kz_plot_agent:InvalidKz', 'The parameters give non-real or nonfinite kz.');
end
% Exact names prevent a color qualifier from silently mapping to another color.
p.Color = lower(char(string(p.Color)));
if ~ismember(p.Color, {'green','blue','orange','purple','black'})
    error('kz_plot_agent:InvalidColor', 'Choose green, blue, orange, purple, or black.');
end
end

function entries = listCurves(figureNumber)
entries = struct('Curve', {}, 'Label', {}, 'FigureNumber', {}, 'PhotonEnergy', {}, ...
    'WorkFunction', {}, 'InnerPotential', {}, 'ThetaStart', {}, 'ThetaEnd', {}, ...
    'ThetaStep', {}, 'LineWidth', {}, 'Color', {});
curves = findall(groot, 'Type', 'line', 'Tag', 'kz_plot_curve');
colors = {'green','blue','orange','purple','black'};
for k = 1:numel(curves)
    c = curves(k);
    if ~isappdata(c, 'kzPlotParameters'), continue; end
    f = ancestor(c, 'figure');
    if ~isempty(figureNumber) && ~isequal(f.Number, figureNumber), continue; end
    p = getappdata(c, 'kzPlotParameters');
    entries(end+1) = struct('Curve', c, 'Label', p.label, ...
        'FigureNumber', f.Number, 'PhotonEnergy', p.photonEnergy, ...
        'WorkFunction', p.workFunction, 'InnerPotential', p.innerPotential, ...
        'ThetaStart', p.thetaStart, 'ThetaEnd', p.thetaEnd, ...
        'ThetaStep', p.thetaStep, 'LineWidth', p.lineWidth, ...
        'Color', colors{p.colorIndex}); %#ok<AGROW> Small interactive registry.
end
end
