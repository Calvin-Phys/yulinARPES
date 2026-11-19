function result = plotbz_agent(action, varargin)
%PLOTBZ_AGENT Configure BZ geometry and manage BZ/ARPES figure overlays.
%   P = plotbz_agent('defaults') returns explicit crystal/plot defaults.
%   P = plotbz_agent('configure', STRUCT) resets to defaults, then applies
%       supplied fields. 'update' instead retains unspecified current fields.
%   P = plotbz_agent('read') reads the live singleton's crystal/plot settings.
%   G = plotbz_agent('plot', TARGET, FIG [, STYLE]) draws BZ outlines.
%   S = plotbz_agent('simulate', PARAMS) draws a fixed-hv or photon scan.
%   G = plotbz_agent('list' [, FIG]) inventories managed graphics, no UI.
%   G = plotbz_agent('clear', FIG [, KIND]) removes managed objects only.
%   TARGET: '3d', 'surface', 'horizontal', 'vertical'. STYLE fields: color,
%   lineWidth. KIND: 'all', 'bz', 'simulation'. See skill examples
%   for crystal and scan fields. All quantities are Angstrom, eV, degrees.

if ~(ischar(action) && isrow(action) || isstring(action) && isscalar(action))
    error('plotbz_agent:InvalidAction', 'Action must be a scalar name.');
end
action = lower(char(action));
switch action
    case 'defaults'
        requireCount(varargin, 0, 0);
        result = defaultCrystal();
    case {'list','clear'}
        result = inventoryAction(action, varargin{:});
    case {'configure','update','read'}
        if strcmp(action, 'read')
            requireCount(varargin, 0, 0);
            result = readCrystal(guidata(plotBZ_V1()));
            return;
        end
        requireCount(varargin, 1, 1);
        supplied = varargin{1};
        if strcmp(action, 'configure')
            candidate = defaultCrystal();
        else
            candidate = readCrystal(guidata(plotBZ_V1()));
        end
        candidate = mergeKnown(candidate, supplied);
        candidate = constrainCrystal(candidate, supplied);
        validateCrystal(candidate);
        panel = plotBZ_V1();
        applyCrystal(guidata(panel), candidate);
        result = readCrystal(guidata(panel));
    case 'plot'
        requireCount(varargin, 2, 3);
        target = exactName(varargin{1}, {'3d','surface','horizontal','vertical'});
        figureNumber = validateFigure(varargin{2});
        style = struct('color','black','lineWidth',1.5);
        if strcmp(target, 'horizontal')
            style.color = 'blue';
        elseif strcmp(target, 'vertical')
            style.color = 'green';
        end
        if numel(varargin) == 3
            style = mergeKnown(style, varargin{3});
        end
        colors = {'black','blue','cyan','green','magenta','red','yellow','white'};
        style.color = exactName(style.color, colors);
        validateattributes(style.lineWidth, {'numeric'}, {'scalar','real','finite','positive'});
        h = guidata(plotBZ_V1());
        preventPanelTarget(h, figureNumber);
        validateCrystal(readCrystal(h));
        prefix = targetPrefix(target);
        set(h.([prefix '_fig']), 'String', num2str(figureNumber,17));
        set(h.([prefix '_color']), 'Value', find(strcmp(colors,style.color)));
        widths = struct('surface','edit93','horizontal','edit92','vertical','edit91');
        widthField = 'ThreeDBZ_width';
        if ~strcmp(target, '3d')
            widthField = widths.(target);
        end
        set(h.(widthField), 'String', num2str(style.lineWidth,17));
        plotBZ_V1([prefix '_plot_Callback'],h.([prefix '_plot']),[],h);
        result = listGraphics(figureNumber);
    case 'simulate'
        requireCount(varargin, 1, 1);
        p = mergeKnown(defaultSimulation(),varargin{1});
        p.mode = exactName(p.mode, {'fixed','photon'});
        if ~isfield(varargin{1}, 'color') && strcmp(p.mode, 'photon')
            p.color = 'purple';
        end
        p.target = exactName(p.target, {'3d','surface','horizontal','vertical'});
        p.color = exactName(p.color, {'orange','purple','blue','green','black'});
        p.figure = validateFigure(p.figure);
        validateattributes(p.alpha, {'numeric'}, {'scalar','real','finite','>=',0,'<=',1});
        numericNames = simulationNumericNames();
        for k = 1:numel(numericNames)
            validateattributes(p.(numericNames{k}), {'numeric'}, ...
                {'scalar','real','finite'});
        end
        plotBZ_V1_arpes_surface(p); % Validate physics before changing fields.
        h = guidata(plotBZ_V1());
        preventPanelTarget(h,p.figure);
        validateCrystal(readCrystal(h));
        applySimulation(h,p);
        result = plotBZ_V1_simulation('plot',h);
    otherwise
        error('plotbz_agent:InvalidAction', 'Unknown action %s.',action);
end
end

function p = defaultCrystal()
p = struct('system','Cubic','centering','P','a',3.1416,'b',3.1416, ...
    'c',3.1416,'alpha',90,'beta',90,'gamma',90,'miller',[0 0 1], ...
    'millerBasis','conventional','bulkRange',zeros(3,2), ...
    'surfaceRange',zeros(2,2),'rotation3D',0,'surfaceRotation',0, ...
    'verticalAzimuth',0,'verticalInPlane',0,'horizontalOffset',0, ...
    'showHorizontal',false,'showVertical',false);
end

function p = defaultSimulation()
p = struct('mode','fixed','target','3d','figure',2010,'photonEnergy',60, ...
    'workFunction',4.5,'innerPotential',15,'bindingEnergy',0,'azimuth',0, ...
    'polarMin',-15,'polarMax',15,'polarStep',1,'tiltMin',-15,'tiltMax',15, ...
    'tiltStep',1,'photonMin',20,'photonMax',100,'photonStep',2, ...
    'polarAngle',0,'color','orange','alpha',0.25);
end

function p = mergeKnown(p,supplied)
if ~isstruct(supplied) || ~isscalar(supplied)
    error('plotbz_agent:InvalidOptions', 'Options must be a scalar struct.');
end
names = fieldnames(supplied);
unknown = setdiff(names,fieldnames(p));
if ~isempty(unknown)
    error('plotbz_agent:UnknownField', 'Unknown option %s.',unknown{1});
end
for k = 1:numel(names)
    p.(names{k}) = supplied.(names{k});
end
end

function p = constrainCrystal(p,supplied)
systems = {'Cubic','Tetragonal','Orthorhombic','Hexagonal', ...
    'Rhombohedral','Monoclinic','Triclinic'};
systemName = exactName(p.system, cellfun(@lower, systems, 'UniformOutput', false));
systemIndex = find(strcmpi(systemName, systems), 1);
p.system = systems{systemIndex};
p.centering = upper(exactName(p.centering,{'p','i','f','c'}));
allowed = {'PIF','PI','PIFC','P','P','PC','P'};
if ~contains(allowed{systemIndex},p.centering)
    error('plotbz_agent:InvalidCrystal','Centering %s is unsupported for %s.',p.centering,p.system);
end
switch p.system
    case 'Cubic'
        values = {'b',p.a;'c',p.a;'alpha',90;'beta',90;'gamma',90};
    case 'Tetragonal'
        values = {'b',p.a;'alpha',90;'beta',90;'gamma',90};
    case 'Orthorhombic'
        values = {'alpha',90;'beta',90;'gamma',90};
    case 'Hexagonal'
        values = {'b',p.a;'alpha',90;'beta',90;'gamma',120};
    case 'Rhombohedral'
        values = {'b',p.a;'c',p.a;'beta',p.alpha;'gamma',p.alpha};
    case 'Monoclinic'
        values = {'alpha',90;'gamma',90};
    otherwise
        values = cell(0,2);
end
for k = 1:size(values,1)
    name = values{k,1};
    if isfield(supplied,name) && ~isequal(supplied.(name),values{k,2})
        error('plotbz_agent:CrystalConstraint','%s must equal %g for %s.',name,values{k,2},p.system);
    end
    p.(name) = values{k,2};
end
p.millerBasis = exactName(p.millerBasis,{'conventional','primitive'});
end

function validateCrystal(p)
scalarFields = {'a','b','c','alpha','beta','gamma','rotation3D', ...
    'surfaceRotation','verticalAzimuth','verticalInPlane','horizontalOffset'};
for k = 1:numel(scalarFields)
    validateattributes(p.(scalarFields{k}),{'numeric'},{'scalar','real','finite'});
end
validateattributes([p.a p.b p.c],{'numeric'},{'positive'});
validateattributes([p.alpha p.beta p.gamma],{'numeric'},{'>',0,'<',180});
validateattributes(p.miller,{'numeric'},{'size',[1 3],'real','finite','integer'});
if all(p.miller == 0)
    error('plotbz_agent:InvalidMiller', 'Miller indices cannot all be zero.');
end
validateRange(p.bulkRange,[3 2]);
validateRange(p.surfaceRange,[2 2]);
for name = {'showHorizontal','showVertical'}
    validateattributes(p.(name{1}),{'logical','numeric'},{'scalar','real','finite','binary'});
end
% The production validators read controls. Use an isolated hidden fixture to
% validate the exact metric, primitive basis and allocation limits before
% changing the user's singleton or any target graphics.
fixture = figure('Visible','off','HandleVisibility','off','IntegerHandle','off');
cleanup = onCleanup(@() delete(fixture));
h = validationHandles(fixture,p);
[b1,b2,b3,normal] = plotBZ_V1_construct_rec_lattice_vectors(h);
plotBZ_V1_construct_bulk_rec_lattice(b1,b2,b3,h);
[s1,s2] = plotBZ_V1_surface_realtime_vector(b1,b2,b3,normal,h);
plotBZ_V1_construct_surf_rec_lattice(s1,s2,h);
end

function validateRange(value,shape)
validateattributes(value,{'numeric'},{'size',shape,'real','finite','integer'});
if any(value(:,1)>value(:,2))
    error('plotbz_agent:InvalidRange','Range starts must not exceed ends.');
end
end

function h = validationHandles(f,p)
[fields,~] = numericMapping(p);
for k = 1:numel(fields)
    h.(fields{k}) = uicontrol(f, 'Style', 'edit');
end
h.LatticeClass = uicontrol(f,'Style','popupmenu','String', ...
    {'Cubic','Tetragonal','Orthorhombic','Hexagonal','Rhombohedral','Monoclinic','Triclinic'});
h.uipanel_LatticeType = uibuttongroup(f);
tags = {'radio_primitive','radio_bodycentered','radio_facecentered','radio_basecentered'};
labels = {'primitive','body-centered','face-centered','base-centered'};
for k = 1:4
    h.(tags{k}) = uicontrol(h.uipanel_LatticeType, ...
        'Style', 'radiobutton', 'String', labels{k});
end
h.radio_hklconv = uicontrol(f, 'Style', 'radiobutton');
h.radio_hklprim = uicontrol(f, 'Style', 'radiobutton');
h.TwoDh_of3D = uicontrol(f, 'Style', 'checkbox');
h.TwoDp_of3D = uicontrol(f, 'Style', 'checkbox');
applyCrystal(h,p,false);
end

function applyCrystal(h,p,runCallback)
if nargin < 3
    runCallback = true;
end
systems = get(h.LatticeClass,'String');
set(h.LatticeClass,'Value',find(strcmp(systems,p.system)));
if runCallback
    plotBZ_V1('LatticeClass_Callback', h.LatticeClass, [], h);
end
tags = {'radio_primitive','radio_bodycentered','radio_facecentered','radio_basecentered'};
centers = 'PIFC';
set(h.uipanel_LatticeType,'SelectedObject',h.(tags{centers==p.centering}));
set(h.radio_hklconv,'Value',strcmp(p.millerBasis,'conventional'));
set(h.radio_hklprim,'Value',strcmp(p.millerBasis,'primitive'));
[fields,values] = numericMapping(p);
for k = 1:numel(fields)
    set(h.(fields{k}), 'String', num2str(values(k),17));
end
set(h.TwoDh_of3D,'Value',p.showHorizontal);
set(h.TwoDp_of3D,'Value',p.showVertical);
end

function [fields,values] = numericMapping(p)
fields = {'a','b','c','alpha','beta','gamma','MillerH','MillerK','MillerL', ...
    'KxStart','KxEnd','KyStart','KyEnd','KzStart','KzEnd', ...
    's1start','s1end','s2start','s2end','rot3DBZ','rotsurBZ', ...
    'rot2DpBZ','rot2DpBZ_inplane','shi2DhBZ'};
values = [p.a p.b p.c p.alpha p.beta p.gamma p.miller ...
    reshape(p.bulkRange',1,[]) reshape(p.surfaceRange',1,[]) ...
    p.rotation3D p.surfaceRotation p.verticalAzimuth p.verticalInPlane p.horizontalOffset];
end

function p = readCrystal(h)
p = defaultCrystal();
systems = get(h.LatticeClass, 'String');
p.system = systems{get(h.LatticeClass, 'Value')};
tags = {'radio_primitive','radio_bodycentered','radio_facecentered','radio_basecentered'};
centers = 'PIFC';
selected = cellfun(@(tag) get(h.(tag),'Value') == 1, tags);
if sum(selected) ~= 1
    error('plotbz_agent:InvalidCentering', 'Select one centering.');
end
p.centering = centers(selected);
p.millerBasis = 'primitive';
if get(h.radio_hklconv, 'Value')
    p.millerBasis = 'conventional';
end
for name = {'a','b','c','alpha','beta','gamma'}
    p.(name{1}) = plotBZ_V1_parse_scalar(h, name{1});
end
p.miller = [plotBZ_V1_parse_scalar(h,'MillerH'), ...
    plotBZ_V1_parse_scalar(h,'MillerK'), plotBZ_V1_parse_scalar(h,'MillerL')];
p.bulkRange = [readPair(h,'KxStart','KxEnd'); ...
    readPair(h,'KyStart','KyEnd'); readPair(h,'KzStart','KzEnd')];
p.surfaceRange = [readPair(h,'s1start','s1end'); readPair(h,'s2start','s2end')];
p.rotation3D = plotBZ_V1_parse_scalar(h, 'rot3DBZ');
p.surfaceRotation = plotBZ_V1_parse_scalar(h, 'rotsurBZ');
p.verticalAzimuth = plotBZ_V1_parse_scalar(h, 'rot2DpBZ');
p.verticalInPlane = plotBZ_V1_parse_scalar(h, 'rot2DpBZ_inplane');
p.horizontalOffset = plotBZ_V1_parse_scalar(h, 'shi2DhBZ');
p.showHorizontal = logical(get(h.TwoDh_of3D, 'Value'));
p.showVertical = logical(get(h.TwoDp_of3D, 'Value'));
end

function pair = readPair(h,first,last)
pair = [plotBZ_V1_parse_scalar(h,first), plotBZ_V1_parse_scalar(h,last)];
end

function names = simulationNumericNames()
names = {'photonEnergy','workFunction','innerPotential','bindingEnergy', ...
    'azimuth','polarMin','polarMax','polarStep','tiltMin','tiltMax','tiltStep', ...
    'photonMin','photonMax','photonStep','polarAngle','alpha'};
end

function applySimulation(h,p)
names = simulationNumericNames();
for k = 1:numel(names)
    set(h.(['sim_' names{k}]), 'String', num2str(p.(names{k}),17));
end
set(h.sim_mode,'Value',find(strcmp({'fixed','photon'},p.mode)));
set(h.sim_target,'Value',find(strcmp({'3d','surface','horizontal','vertical'},p.target)));
prefix = targetPrefix(p.target);
set(h.([prefix '_fig']),'String',num2str(p.figure,17));
plotBZ_V1('SimMode_Callback', h.sim_mode, [], h);
set(h.sim_color,'Value',find(strcmp({'orange','purple','blue','green','black'},p.color)));
plotBZ_V1_simulation_color('change', h);
end

function prefix = targetPrefix(target)
map = struct('x3d','ThreeDBZ','surface','SurfBZ', ...
    'horizontal','TwoDhBZ','vertical','TwoDpBZ');
if strcmp(target, '3d')
    prefix = map.x3d;
else
    prefix = map.(target);
end
end

function result = inventoryAction(action,varargin)
if strcmp(action, 'list')
    requireCount(varargin, 0, 1);
    figureNumber = [];
    if ~isempty(varargin)
        figureNumber = validateFigure(varargin{1});
    end
else
    requireCount(varargin, 1, 2);
    figureNumber = validateFigure(varargin{1});
    kind = 'all';
    if numel(varargin) == 2
        kind = exactName(varargin{2}, {'all','bz','simulation'});
    end
    items = listGraphics(figureNumber);
    for k = 1:numel(items)
        if strcmp(kind, 'all') || strcmp(kind, items(k).Kind)
            delete(items(k).Graphics);
        end
    end
end
result = listGraphics(figureNumber);
end

function entries = listGraphics(figureNumber)
entries = struct('Graphics',{},'FigureNumber',{},'Axes',{},'Kind',{},'Parameters',{});
tags = {'plotBZ_V1_generated','plotBZ_V1_simulation'};
kinds = {'bz','simulation'};
for kind = 1:2
    objects = findall(groot, 'Tag', tags{kind});
    for k = 1:numel(objects)
        object = objects(k);
        f = ancestor(object, 'figure');
        ax = ancestor(object, 'axes');
        if isempty(f) || (~isempty(figureNumber) && ~isequal(f.Number,figureNumber))
            continue;
        end
        parameters = [];
        if isappdata(object, 'plotBZSimulationParameters')
            parameters = getappdata(object, 'plotBZSimulationParameters');
        end
        entries(end+1) = struct('Graphics',object,'FigureNumber',f.Number, ...
            'Axes',ax,'Kind',kinds{kind},'Parameters',parameters); %#ok<AGROW>
    end
end
end

function value = exactName(value,allowed)
if ~(ischar(value) && isrow(value) || isstring(value) && isscalar(value))
    error('plotbz_agent:InvalidName','Expected a scalar name.');
end
value = lower(char(value));
if ~ismember(value, allowed)
    error('plotbz_agent:InvalidName', 'Unsupported name %s.', value);
end
end

function figureNumber = validateFigure(figureNumber)
validateattributes(figureNumber,{'numeric'},{'scalar','real','finite','integer','positive'});
end

function preventPanelTarget(h,figureNumber)
panel = ancestor(h.LatticeClass, 'figure');
if isequal(panel.Number, figureNumber)
    error('plotbz_agent:PanelTarget','The control panel cannot be the target figure.');
end
end

function requireCount(args,minimum,maximum)
if numel(args)<minimum || numel(args)>maximum
    error('plotbz_agent:ArgumentCount','Unexpected number of action arguments.');
end
end
