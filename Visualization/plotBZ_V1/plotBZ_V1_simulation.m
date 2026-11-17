function result = plotBZ_V1_simulation(action, handles)
%PLOTBZ_V1_SIMULATION Read, draw or clear managed ARPES simulation overlays.
%   READ returns validated parameters from the GUIDE controls. PLOT replaces
%   the same measurement mode and target on the selected axes, preserving
%   other overlays. CLEAR removes simulations for the selected target only.
%   Slit azimuth is measured in the bulk +kx/+ky measurement frame. Surface
%   XY uses its own BZ azimuth control to express the same measurement.
%   Surface XY is a projection; horizontal/vertical views are intersections
%   with exactly the planes and 2-D frame used by the corresponding BZ plot.

arguments
    action (1,:) char
    handles (1,1) struct
end
switch lower(action)
    case 'read'
        result = readParameters(handles);
    case 'plot'
        params = readParameters(handles);
        scan = plotBZ_V1_arpes_surface(params);
        geometry = prepareGeometry(scan, params, handles);
        result = drawOverlay(scan, geometry, params);
    case 'clear'
        target = selectedTarget(handles);
        figureNumber = targetFigure(handles, target);
        figureHandle = findall(groot,'Type','figure','Number',figureNumber);
        if ~isempty(figureHandle)
            ax = get(figureHandle,'CurrentAxes');
            if isempty(ax)
                result = [];
                return;
            end
            objects = findall(ax,'Tag','plotBZ_V1_simulation');
            for index = 1:numel(objects)
                stored = getappdata(objects(index),'plotBZSimulationParameters');
                if isstruct(stored) && isfield(stored,'target') && strcmp(stored.target,target)
                    delete(objects(index));
                end
            end
        end
        result = [];
    otherwise
        error('plotBZ_V1:InvalidSimulation', 'Unknown simulation action: %s.', action);
end
end

function params = readParameters(handles)
modes = {'fixed','photon'};
params.mode = modes{get(handles.sim_mode,'Value')};
fields = {'workFunction','innerPotential','bindingEnergy','azimuth', ...
    'tiltMin','tiltMax','tiltStep'};
if strcmp(params.mode,'fixed')
    fields = [fields, {'photonEnergy','polarMin','polarMax','polarStep'}];
else
    fields = [fields, {'photonMin','photonMax','photonStep','polarAngle'}];
end
for index = 1:numel(fields)
    params.(fields{index}) = plotBZ_V1_parse_scalar(handles,['sim_' fields{index}]);
end
params.target = selectedTarget(handles);
params.figureNumber = targetFigure(handles,params.target);
params.alpha = plotBZ_V1_parse_scalar(handles,'sim_alpha');
if params.alpha < 0 || params.alpha > 1
    error('plotBZ_V1:InvalidSimulation','Simulation opacity must lie between 0 and 1.');
end
colors = [0.9 0.4 0.05;0.55 0.25 0.75;0 0.35 0.85;0.1 0.6 0.2;0 0 0];
params.color = colors(get(handles.sim_color,'Value'),:);
plotBZ_V1_arpes_surface(params); % Validate the physical model before graphics change.
end

function target = selectedTarget(handles)
targets = {'3d','surface','horizontal','vertical'};
target = targets{get(handles.sim_target,'Value')};
end

function number = targetFigure(handles,target)
targets = {'3d','surface','horizontal','vertical'};
fields = {'ThreeDBZ_fig','SurfBZ_fig','TwoDhBZ_fig','TwoDpBZ_fig'};
number = plotBZ_V1_parse_scalar(handles,fields{strcmp(target,targets)},'figure');
if isfield(handles,'figure1') && isgraphics(handles.figure1) && ...
        isequal(number,get(handles.figure1,'Number'))
    error('plotBZ_V1:InvalidSimulation','Choose a target figure other than the control panel.');
end
end

function geometry = prepareGeometry(scan,params,handles)
% Use the same normal and rotations as BZ callbacks, including the legacy
% section frame. Simulations stay fixed while rot3DBZ rotates the crystal.
[b1,b2,b3,normal] = plotBZ_V1_construct_rec_lattice_vectors(handles);
[~,~,~,normal] = plotBZ_V1_bulk_realtime_vector(b1,b2,b3,normal,handles);
points = [scan.kx(:),scan.ky(:),scan.kz(:)];
geometry.dimension = scan.dimension;
geometry.firstDimensionVaries = scan.firstDimensionVaries;
geometry.size = size(scan.kx);
geometry.segments = zeros(0,6);
geometry.section = false;
switch params.target
    case '3d'
        geometry.points = points;
    case 'surface'
        % Surface and bulk BZ panels have independent azimuth controls.
        angle = plotBZ_V1_parse_scalar(handles,'rotsurBZ') - ...
            plotBZ_V1_parse_scalar(handles,'rot3DBZ');
        geometry.points = points*plotBZ_V1_rotation('z',angle)';
    otherwise
        if strcmp(params.target,'horizontal')
            origin = plotBZ_V1_parse_scalar(handles,'shi2DhBZ')/100*normal;
            angle = 180;
        else
            origin = [0 0 0];
            azimuth = plotBZ_V1_parse_scalar(handles,'rot2DpBZ');
            normal = (plotBZ_V1_rotation('z',azimuth)* ...
                plotBZ_V1_rotation('x',90)*normal')';
            angle = plotBZ_V1_parse_scalar(handles,'rot2DpBZ_inplane');
        end
        [segments,coplanar] = plotBZ_V1_surface_section(scan,normal,dot(origin,normal));
        [azimuth,elevation] = cart2sph(normal(1),normal(2),normal(3));
        rotation = plotBZ_V1_rotation('z',angle)* ...
            plotBZ_V1_rotation('x',90-rad2deg(elevation))* ...
            plotBZ_V1_rotation('z',90-rad2deg(azimuth));
        geometry.points = points*rotation';
        if ~coplanar
            geometry.section = true;
            geometry.segments = [segments(:,1:3)*rotation',segments(:,4:6)*rotation'];
        end
end
end

function result = drawOverlay(scan,geometry,params)
figureHandle = figure(params.figureNumber);
plotBZ_V1_vector_output(figureHandle);
ax = get(figureHandle,'CurrentAxes');
if isempty(ax)
    ax = axes('Parent',figureHandle);
end
previous = findall(ax,'Tag','plotBZ_V1_simulation');
replaced = gobjects(0);
for index = 1:numel(previous)
    stored = getappdata(previous(index),'plotBZSimulationParameters');
    if isstruct(stored) && isfield(stored,'mode') && isfield(stored,'target') && ...
            strcmp(stored.mode,params.mode) && strcmp(stored.target,params.target)
        replaced(end+1,1) = previous(index); %#ok<AGROW> At most one object per existing overlay.
    end
end
hasData = ~isempty(get(ax,'Children'));
state = struct('NextPlot',ax.NextPlot,'XLim',ax.XLim,'YLim',ax.YLim, ...
    'ZLim',ax.ZLim,'XLimMode',ax.XLimMode,'YLimMode',ax.YLimMode, ...
    'ZLimMode',ax.ZLimMode,'View',ax.View, 'DataAspectRatio',ax.DataAspectRatio, ...
    'DataAspectRatioMode',ax.DataAspectRatioMode);
ax.NextPlot = 'add';
cleanup = onCleanup(@() restoreAxes(ax,state,hasData));
objects = gobjects(0);
try
    objects = drawGeometry(ax,geometry,params);
    for index = 1:numel(objects)
        set(objects(index),'Tag','plotBZ_V1_simulation', ...
            'DisplayName',sprintf('ARPES %s (%s)',params.mode,params.target));
        setappdata(objects(index),'plotBZSimulationParameters',params);
    end
    delete(replaced);
catch exception
    delete(objects(isgraphics(objects)));
    rethrow(exception);
end
if ~hasData
    axis(ax,'equal');
    if strcmp(params.target,'3d')
        view(ax,3);
        xlabel(ax,'k_x (Angstrom^{-1})'); ylabel(ax,'k_y (Angstrom^{-1})'); zlabel(ax,'k_z (Angstrom^{-1})');
    else
        view(ax,2);
    end
end
result = struct('Graphics',objects,'Figure',figureHandle,'Axes',ax, ...
    'Parameters',params,'Scan',scan);
clear cleanup;
end

function objects = drawGeometry(ax,geometry,params)
if geometry.section
    segments = geometry.segments;
    if isempty(segments)
        objects = gobjects(0);
        return;
    end
    x = reshape([segments(:,1),segments(:,4),nan(size(segments,1),1)]',[],1);
    y = reshape([segments(:,2),segments(:,5),nan(size(segments,1),1)]',[],1);
    objects = line(ax,x,y,'Color',params.color,'LineWidth',1.5);
    if all(vecnorm(segments(:,1:3)-segments(:,4:6),2,2) < 1e-12)
        set(objects,'Marker','.','MarkerSize',12);
    end
    return;
end
points = geometry.points;
is3d = strcmp(params.target,'3d');
dimension = geometry.dimension;
if ~is3d && dimension == 2 && rank(points(:,1:2)-points(1,1:2),1e-10) < 2
    % A projected surface may collapse to a curve; show its sampled points.
    objects = line(ax,points(:,1),points(:,2),'Color',params.color, ...
        'LineStyle','none','Marker','.','MarkerSize',5);
elseif dimension == 2
    indices = reshape(1:size(points,1),geometry.size);
    a = indices(1:end-1,1:end-1); b = indices(2:end,1:end-1);
    c = indices(1:end-1,2:end); d = indices(2:end,2:end);
    faces = [a(:),b(:),c(:); d(:),c(:),b(:)];
    if ~is3d
        points = points(:,1:2);
    end
    objects = patch(ax,'Vertices',points,'Faces',faces,'FaceColor',params.color, ...
        'FaceAlpha',params.alpha,'EdgeColor','none');
else
    indices = reshape(1:size(points,1),geometry.size);
    if dimension == 0
        selection = 1;
    elseif geometry.firstDimensionVaries
        selection = indices(:,1);
    else
        selection = indices(1,:);
    end
    points = points(selection,:);
    if is3d
        objects = line(ax,points(:,1),points(:,2),points(:,3),'Color',params.color,'LineWidth',1.5);
    else
        objects = line(ax,points(:,1),points(:,2),'Color',params.color,'LineWidth',1.5);
    end
    if dimension == 0
        set(objects,'Marker','.','MarkerSize',15);
    end
end
end

function restoreAxes(ax,state,hasData)
if ~isgraphics(ax)
    return;
end
ax.NextPlot = state.NextPlot;
if hasData
    ax.XLim = state.XLim; ax.YLim = state.YLim; ax.ZLim = state.ZLim;
    ax.XLimMode = state.XLimMode; ax.YLimMode = state.YLimMode;
    ax.ZLimMode = state.ZLimMode;
    ax.View = state.View;
    ax.DataAspectRatio = state.DataAspectRatio;
    ax.DataAspectRatioMode = state.DataAspectRatioMode;
end
end
