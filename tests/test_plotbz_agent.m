function tests = test_plotbz_agent
%TEST_PLOTBZ_AGENT Test the skill's public configuration and overlay helper.
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.originalPath = path;
addpath(fullfile(root,'Visualization','plotBZ_V1'));
addpath(fullfile(root,'AI_skills','arpes-plot-bz','scripts'));
addpath(genpath(fullfile(root,'third_party','matGeom','matGeom')));
end

function teardownOnce(testCase)
path(testCase.TestData.originalPath);
end

function testConfigureConstraintsAndValidation(testCase)
panel = plotBZ_V1();
original = plotbz_agent('read');
cleanup = onCleanup(@() plotbz_agent('configure',original));
p = plotbz_agent('configure',struct('system','Hexagonal','a',3.2,'c',5.2, ...
    'miller',[2 3 4],'bulkRange',[-1 1;0 0;0 2]));
verifyEqual(testCase,[p.a p.b p.c],[3.2 3.2 5.2]);
verifyEqual(testCase,[p.alpha p.beta p.gamma],[90 90 120]);
verifyEqual(testCase,p.miller,[2 3 4]);
verifyError(testCase,@() plotbz_agent('update',struct('unknown',1)), ...
    'plotbz_agent:UnknownField');
verifyError(testCase,@() plotbz_agent('configure',struct('system','Hexagonal','b',9)), ...
    'plotbz_agent:CrystalConstraint');
verifyError(testCase,@() plotbz_agent('update',struct('miller',[0 0 0])), ...
    'plotbz_agent:InvalidMiller');
verifyEqual(testCase,plotbz_agent('read'),p);
verifyTrue(testCase,isgraphics(panel));
end

function testPlotScanAndScopedClear(testCase)
original = plotbz_agent('read');
stateCleanup = onCleanup(@() plotbz_agent('configure',original));
plotbz_agent('configure',struct('a',3.8,'bulkRange',zeros(3,2)));
target = figure('Visible','off','IntegerHandle','on');
figureCleanup = onCleanup(@() delete(target));
ax = axes(target);
measured = plot(ax,[0 1],[0 1],'Tag','measured_test');
hold(ax,'on');
plotbz_agent('plot','3d',target.Number);
scan = plotbz_agent('simulate',struct('figure',target.Number,'photonEnergy',60));
verifyNotEmpty(testCase,scan.Graphics);
verifyTrue(testCase,all(isgraphics(scan.Graphics)));
items = plotbz_agent('list',target.Number);
verifyTrue(testCase,any(strcmp({items.Kind},'bz')));
verifyTrue(testCase,any(strcmp({items.Kind},'simulation')));
plotbz_agent('clear',target.Number,'simulation');
verifyTrue(testCase,isgraphics(measured));
items = plotbz_agent('list',target.Number);
verifyFalse(testCase,any(strcmp({items.Kind},'simulation')));
verifyTrue(testCase,any(strcmp({items.Kind},'bz')));
plotbz_agent('clear',target.Number,'all');
verifyEmpty(testCase,plotbz_agent('list',target.Number));
verifyTrue(testCase,isgraphics(measured));
end

function testInvalidInactiveScanFieldPreservesPanel(testCase)
h = guidata(plotBZ_V1());
beforeEnergy = get(h.sim_photonEnergy, 'String');
beforeMode = get(h.sim_mode, 'Value');
rejected = false;
try
    plotbz_agent('simulate',struct('mode','fixed','photonEnergy',75, ...
        'photonMin',struct('bad',1)));
catch
    rejected = true;
end
verifyTrue(testCase, rejected);
verifyEqual(testCase, get(h.sim_photonEnergy,'String'), beforeEnergy);
verifyEqual(testCase, get(h.sim_mode,'Value'), beforeMode);
end

function testMeasurementModeDefaultColors(testCase)
original = plotbz_agent('read');
stateCleanup = onCleanup(@() plotbz_agent('configure',original));
plotbz_agent('configure',struct());
target = figure('Visible','off');
figureCleanup = onCleanup(@() delete(target));
fixed = plotbz_agent('simulate',struct('figure',target.Number));
photon = plotbz_agent('simulate',struct('mode','photon','figure',target.Number));
verifyTrue(testCase, all(isgraphics(fixed.Graphics)));
verifyTrue(testCase, all(isgraphics(photon.Graphics)));
verifyNotEqual(testCase, fixed.Graphics.FaceColor, photon.Graphics.FaceColor);
verifyEqual(testCase, fixed.Graphics.FaceColor, [0.9 0.4 0.05]);
verifyEqual(testCase, photon.Graphics.FaceColor, [0.55 0.25 0.75]);
if isMATLABReleaseOlderThan('R2025a')
    verifyEqual(testCase, target.Renderer, 'painters');
end
custom = plotbz_agent('simulate',struct('mode','photon', ...
    'figure',target.Number,'color','green'));
verifyEqual(testCase, custom.Graphics.FaceColor, [0.1 0.6 0.2]);
vectorPDF = [tempname '.pdf'];
plotBZ_V1_vector_output(target, vectorPDF);
fileCleanup = onCleanup(@() delete(vectorPDF));
pdfContents = fileread(vectorPDF);
verifyTrue(testCase, startsWith(pdfContents, '%PDF-'));
verifyEmpty(testCase, regexp(pdfContents, '/Subtype\s*/Image', 'once'));
verifyNumElements(testCase, findall(target, 'Tag', 'plotBZ_V1_export_vector'), 1);
end

function testCenteredCrystalPersistsWhenRaisingPanel(testCase)
original = plotbz_agent('read');
stateCleanup = onCleanup(@() plotbz_agent('configure',original));
plotbz_agent('configure',struct('centering','F','a',3.8));
state = plotbz_agent('read');
verifyEqual(testCase, state.centering, 'F');
target = figure('Visible','off');
figureCleanup = onCleanup(@() delete(target));
plotbz_agent('plot','3d',target.Number);
state = plotbz_agent('read');
verifyEqual(testCase, state.centering, 'F');
end
