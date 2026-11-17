function tests = test_plotBZ_V1_simulation
%TEST_PLOTBZ_V1_SIMULATION Validate ARPES geometry and managed overlays.
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.originalPath = path;
addpath(fullfile(root,'Visualization','plotBZ_V1'));
addpath(genpath(fullfile(root,'third_party','matGeom','matGeom')));
end

function teardownOnce(testCase)
path(testCase.TestData.originalPath);
end

function params = defaults
params = struct('mode','fixed','photonEnergy',60,'workFunction',4.5, ...
    'innerPotential',15,'bindingEnergy',0,'azimuth',0, ...
    'polarMin',-15,'polarMax',15,'polarStep',1, ...
    'tiltMin',-15,'tiltMax',15,'tiltStep',1);
end

function testFixedEnergyPhysicsAndAzimuth(testCase)
params = defaults;
scan = plotBZ_V1_arpes_surface(params);
factor = sqrt(2*9.1093837139e-31*1.602176634e-19)/1.054571817e-34*1e-10;
verifySize(testCase,scan.kx,[31 31]);
verifyEqual(testCase,scan.kx(16,16),0,'AbsTol',1e-12);
verifyEqual(testCase,scan.ky(16,16),0,'AbsTol',1e-12);
verifyEqual(testCase,scan.kz(16,16),factor*sqrt(70.5),'AbsTol',1e-12);
% The free-electron sphere has radius sqrt(K^2 Ekin + K^2 V0).
radiusSquared = scan.kx.^2 + scan.ky.^2 + scan.kz.^2;
verifyEqual(testCase,radiusSquared,factor^2*70.5*ones(31),'AbsTol',1e-11);
params.azimuth = 90;
rotated = plotBZ_V1_arpes_surface(params);
verifyEqual(testCase,rotated.kx,-scan.ky,'AbsTol',1e-12);
verifyEqual(testCase,rotated.ky,scan.kx,'AbsTol',1e-12);
verifyEqual(testCase,rotated.kz,scan.kz,'AbsTol',1e-12);
end

function testPhotonScanAndSampling(testCase)
params = defaults;
params.mode = 'photon';
params.photonMin = 20; params.photonMax = 25; params.photonStep = 2;
params.polarAngle = 8;
params.tiltStep = 4;
scan = plotBZ_V1_arpes_surface(params);
verifySize(testCase,scan.kx,[4 9]);
verifyEqual(testCase,scan.photonEnergy([1 end],1),[20;25]);
verifyEqual(testCase,scan.tilt(1,[1 end]),[-15 15]);
verifyLessThanOrEqual(testCase,max(diff(scan.photonEnergy(:,1))),2);
params.mode = 'fixed'; params.photonEnergy = 20;
params.polarMin = 8; params.polarMax = 8;
fixed = plotBZ_V1_arpes_surface(params);
verifyEqual(testCase,scan.kx(1,:),fixed.kx,'AbsTol',1e-12);
verifyEqual(testCase,scan.ky(1,:),fixed.ky,'AbsTol',1e-12);
verifyEqual(testCase,scan.kz(1,:),fixed.kz,'AbsTol',1e-12);
end

function testInputRejectionAndDegeneracy(testCase)
params = defaults;
params.polarMin = 0; params.polarMax = 0;
scan = plotBZ_V1_arpes_surface(params);
verifyEqual(testCase,scan.dimension,1);
params.tiltMin = 0; params.tiltMax = 0;
scan = plotBZ_V1_arpes_surface(params);
verifyEqual(testCase,scan.dimension,0);
invalid = defaults; invalid.photonEnergy = 4;
verifyError(testCase,@() plotBZ_V1_arpes_surface(invalid),'plotBZ_V1:InvalidSimulation');
invalid = defaults; invalid.polarStep = 0;
verifyError(testCase,@() plotBZ_V1_arpes_surface(invalid),'plotBZ_V1:InvalidSimulation');
invalid = defaults; invalid.tiltMin = -90;
verifyError(testCase,@() plotBZ_V1_arpes_surface(invalid),'plotBZ_V1:InvalidSimulation');
invalid = defaults; invalid.polarStep = 0.001;
verifyError(testCase,@() plotBZ_V1_arpes_surface(invalid),'plotBZ_V1:InvalidSimulation');
invalid = defaults; invalid.workFunction = NaN;
verifyError(testCase,@() plotBZ_V1_arpes_surface(invalid),'plotBZ_V1:InvalidSimulation');
invalid = defaults; invalid.mode = ["fixed" "photon"];
verifyError(testCase,@() plotBZ_V1_arpes_surface(invalid),'plotBZ_V1:InvalidSimulation');
end

function testSurfacePlaneAndCurveIntersections(testCase)
scan = plotBZ_V1_arpes_surface(defaults);
[segments,coplanar] = plotBZ_V1_surface_section(scan,[0 1 0],0);
verifyFalse(testCase,coplanar);
verifyNotEmpty(testCase,segments);
verifyEqual(testCase,segments(:,[2 5]),zeros(size(segments,1),2),'AbsTol',1e-11);
[segments,coplanar] = plotBZ_V1_surface_section(scan,[0 0 1],100);
verifyEmpty(testCase,segments); verifyFalse(testCase,coplanar);
params = defaults; params.mode = 'photon'; params.photonMin = 20;
params.photonMax = 30; params.photonStep = 2; params.polarAngle = 0;
scan = plotBZ_V1_arpes_surface(params);
[segments,coplanar] = plotBZ_V1_surface_section(scan,[1 0 0],0);
verifyTrue(testCase,coplanar); verifyEmpty(testCase,segments);
params = defaults; params.polarMin = 0; params.polarMax = 0;
scan = plotBZ_V1_arpes_surface(params);
segments = plotBZ_V1_surface_section(scan,[0 1 0],0);
verifyNotEmpty(testCase,segments);
verifyEqual(testCase,segments(:,1:3),segments(:,4:6),'AbsTol',1e-12);
end

function testManagedGUIOverlayAndClear(testCase)
gui = plotBZ_V1('Visible','off');
cleanup = onCleanup(@() closeOwned(gui));
handles = guidata(gui);
% Numbered figures are the public GUI contract; choose a high unoccupied ID.
number = 89321;
while ~isempty(findall(groot,'Type','figure','Number',number))
    number = number+1;
end
target = figure(number); target.Visible = 'off';
targetCleanup = onCleanup(@() closeOwned(target));
ax = axes('Parent',target);
data = plot(ax,[-1 1],[0 0],'k');
initialView = ax.View;
initialRatioMode = ax.DataAspectRatioMode;
set(handles.ThreeDBZ_fig,'String',num2str(number));
set(handles.SurfBZ_fig,'String',num2str(number));
set(handles.sim_target,'Value',1);
set(handles.sim_mode,'Value',1);
first = plotBZ_V1_simulation('plot',handles);
verifyTrue(testCase,isgraphics(data));
verifyEqual(testCase,numel(first.Graphics),1);
verifyEqual(testCase,ax.XLimMode,'auto');
verifyEqual(testCase,ax.YLimMode,'auto');
verifyEqual(testCase,ax.ZLimMode,'auto');
verifyEqual(testCase,ax.View,initialView);
verifyEqual(testCase,ax.DataAspectRatioMode,initialRatioMode);
second = plotBZ_V1_simulation('plot',handles);
verifyFalse(testCase,isgraphics(first.Graphics));
verifyTrue(testCase,isgraphics(second.Graphics));
set(handles.sim_mode,'Value',2);
photon = plotBZ_V1_simulation('plot',handles);
verifyTrue(testCase,isgraphics(second.Graphics));
verifyTrue(testCase,isgraphics(photon.Graphics));
set(handles.sim_photonMin,'String','0');
verifyError(testCase,@() plotBZ_V1_simulation('plot',handles),'plotBZ_V1:InvalidSimulation');
verifyTrue(testCase,isgraphics(photon.Graphics));
plotBZ_V1_simulation('clear',handles);
verifyFalse(testCase,isgraphics(second.Graphics));
verifyFalse(testCase,isgraphics(photon.Graphics));
verifyTrue(testCase,isgraphics(data));
set(handles.sim_mode,'Value',1);
set(handles.sim_target,'Value',3);
set(handles.TwoDhBZ_fig,'String',num2str(number));
set(handles.shi2DhBZ,'String','10000');
emptySection = plotBZ_V1_simulation('plot',handles);
verifyEmpty(testCase,emptySection.Graphics);
verifyTrue(testCase,isgraphics(data));
clear targetCleanup cleanup;
end

function closeOwned(handle)
if isgraphics(handle)
    delete(handle);
end
end
