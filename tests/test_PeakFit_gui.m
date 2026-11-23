function tests = test_PeakFit_gui
%TEST_PEAKFIT_GUI  Behavioural tests of PeakFit_app and the browser menus.
%   Uses base-workspace fixtures prefixed pkftest_ (removed afterwards) and
%   hidden app windows. The browser test opens data_browser_demo_v32 and
%   ARPES_data_browser_v5 and closes only the figures it created.
tests = functiontests(localfunctions);
end

function setupOnce(tc)
root = fileparts(fileparts(mfilename('fullpath')));
tc.TestData.root = root;
tc.TestData.oldPath = addpath(fullfile(root, 'Fitting', 'PeakFit'), root);
names = evalin('base', 'who(''pkftest_*'')');
assert(isempty(names), 'pkftest_ fixtures already exist in the base workspace.');
[mdc, truthFcn] = mdcCut();
assignin('base', 'pkftest_cut', mdc);
assignin('base', 'pkftest_edc', edcCut());
assignin('base', 'pkftest_map3d', struct('x', 1:3, 'y', 1:4, 'z', 1:5, 'value', rand(3, 4, 5)));
assignin('base', 'pkftest_notdata', magic(4));
if exist('OxA_CUT', 'class') == 8
    obj = OxA_CUT(mdc.x, mdc.y, mdc.value);
    obj.info.temperature = 9.5;
    assignin('base', 'pkftest_obj', obj);
end
tc.TestData.truthFcn = truthFcn;
tc.TestData.cut = mdc;
end

function teardownOnce(tc)
evalin('base', 'clear pkftest_*');
path(tc.TestData.oldPath);
end

function setup(tc)
tc.TestData.app = PeakFit_app('Visible', 'off');
end

function teardown(tc)
if isvalid(tc.TestData.app), delete(tc.TestData.app); end
end

% ---------------- startup and data ----------------
function testListFiltersTwoDimensionalCuts(tc)
names = tc.TestData.app.refreshList();
tc.verifyTrue(all(ismember({'pkftest_cut', 'pkftest_edc'}, names)));
tc.verifyFalse(any(ismember({'pkftest_map3d', 'pkftest_notdata'}, names)));
end

function testStartupSignatures(tc)
a = PeakFit_app('pkftest_cut', 'Visible', 'off');
c = onCleanup(@() delete(a));
tc.verifyEqual(a.DataName, 'pkftest_cut');
tc.verifyEqual(a.getState().exportName, 'pkftest_cut_peaks');
b = PeakFit_app(tc.TestData.cut, 'Visible', 'off');
c2 = onCleanup(@() delete(b));
tc.verifyEqual(b.DataName, '');
tc.verifyEqual(b.getState().exportName, 'peakfit_peaks');
before = numel(findall(groot, 'Type', 'figure', 'Tag', 'PeakFit_app'));
tc.verifyError(@() PeakFit_app('pkftest_map3d', 'Visible', 'off'), 'PeakFit:Not2D');
tc.verifyEqual(numel(findall(groot, 'Type', 'figure', 'Tag', 'PeakFit_app')), before);
tc.verifyEmpty(tc.TestData.app.Data);
tc.verifyError(@() tc.TestData.app.fitCurrentSlice(), 'PeakFit:NoData');
end

function testOxACutAndInfoTemperature(tc)
tc.assumeTrue(exist('OxA_CUT', 'class') == 8, 'OX_ARPES not on the path.');
app = tc.TestData.app;
app.selectData('pkftest_obj');
app.setDirection('EDC');
s = app.getState();
tc.verifyEqual(s.fermi.T, 9.5);
tc.verifyEqual(s.fermi.temperatureSource, 'info.temperature');
tc.verifyEqual(app.Data.sourceClass, 'OxA_CUT');
end

% ---------------- MDC workflow ----------------
function testMDCClickFitTrackAndExport(tc)
app = tc.TestData.app; f = tc.TestData.truthFcn;
app.selectData('pkftest_cut');
s = app.getState();
tc.verifyEqual(s.direction, 'MDC');
tc.verifyEqual(s.shape, 'Lorentzian');
app.setSlice(-0.15);
app.simulateProfileClick([f(-0.15) + 0.01, 90]);           % click-to-add
tc.verifyEqual(height(app.getState().peaks), 1);
R = app.fitCurrentSlice();
tc.verifyEqual(R.peaks.centre, f(app.SliceValue), 'AbsTol', 2e-3);
s = app.getState();
tc.verifyEqual(s.fitStatus, 'Done');
tc.verifyEqual(s.peaks.Centre, R.peaks.centre);
tc.verifyGreaterThan(s.peaks.ErrCentre, 0);
T = app.fitRange();
tc.verifyEqual(nnz(all(T.valid, 2)), numel(T.slice_values));
tc.verifyLessThan(max(abs(T.centre - f(T.slice_values))), 2e-3);
tc.verifyEqual(app.getState().fitStatus, 'Done');
tc.verifyNotEmpty(findobj(app.Handles.Image, 'Tag', 'pkf_dispersion'));
original = evalin('base', 'pkftest_cut');
name = app.exportPeaks();
tc.addTeardown(@() evalin('base', ['clear ' name]));
S = evalin('base', name);
tc.verifyEqual(name, 'pkftest_cut_peaks');
tc.verifyEqual(S.peaks(1).x, T.centre(T.valid));
tc.verifyEqual(S.source_name, 'pkftest_cut');
tc.verifyTrue(isequal(evalin('base', 'pkftest_cut'), original));   % source untouched
end

function testExportNeverOverwritesSource(tc)
app = tc.TestData.app; f = tc.TestData.truthFcn;
app.selectData('pkftest_cut');
tc.verifyError(@() app.exportPeaks('x1'), 'PeakFit:NoFit');
app.addPeak(f(app.SliceValue));
app.fitCurrentSlice();
tc.verifyError(@() app.exportPeaks('pkftest_cut'), 'PeakFit:WouldOverwriteSource');
tc.verifyError(@() app.exportPeaks('not a name'), 'PeakFit:InvalidName');
assignin('base', 'pkftest_out', 1);
tc.verifyError(@() app.exportPeaks('pkftest_out'), 'PeakFit:VariableExists');
tc.verifyEqual(evalin('base', 'pkftest_out'), 1);
app.exportPeaks('pkftest_out', 'Overwrite', true);
S = evalin('base', 'pkftest_out');
tc.verifyEqual(numel(S.slice_values), 1);
tc.verifyEqual(S.direction, 'MDC');
end

function testDragAndTableEditing(tc)
app = tc.TestData.app;
app.selectData('pkftest_cut');
app.addPeak(0.0);
app.simulateDrag(1, [0.05, 80]);
s = app.getState();
tc.verifyEqual(s.peaks.Centre, 0.05, 'AbsTol', 1e-12);
tc.verifyGreaterThan(s.peaks.Height, 0);
app.simulateTableEdit(1, 3, 0.07);                             % FWHM
tc.verifyEqual(app.getState().peaks.FWHM, 0.07);
app.simulateTableEdit(1, 3, -1);                               % invalid: reverted
tc.verifyEqual(app.getState().peaks.FWHM, 0.07);
tc.verifyTrue(startsWith(app.Handles.Status.Text, 'Error'));
app.simulateTableEdit(1, 5, 0.3);                              % eta fixed by Lorentzian
tc.verifyEqual(app.getState().peaks.eta, 1);
app.setModel('Pseudo-Voigt');
app.simulateTableEdit(1, 5, 0.3);
tc.verifyEqual(app.getState().peaks.eta, 0.3);
app.simulateTableEdit(1, 6, true);                             % Fix centre
R = app.fitCurrentSlice();
tc.verifyEqual(R.peaks.centre, 0.05);
app.simulateTableEdit(1, 10, 0.2); app.simulateTableEdit(1, 11, 0.1);   % min > max rejected
tc.verifyEqual(app.getState().peaks.CentreMax, Inf);
end

function testAutoFindAddDeleteClear(tc)
app = tc.TestData.app; f = tc.TestData.truthFcn;
app.selectData('pkftest_cut');
c = app.autoFindPeaks('Prominence', 0.2);
tc.verifyEqual(numel(c), 1);
tc.verifyEqual(c, f(app.SliceValue), 'AbsTol', 0.02);
app.addPeak(-0.5);
tc.verifyEqual(height(app.getState().peaks), 2);
app.removePeak(2);
tc.verifyEqual(height(app.getState().peaks), 1);
app.Handles.AddPeak.ButtonPushedFcn(app.Handles.AddPeak, []);   % residual-based Add
tc.verifyEqual(height(app.getState().peaks), 2);
app.clearPeaks();
tc.verifyEqual(height(app.getState().peaks), 0);
tc.verifyError(@() app.fitRange(), 'PeakFit:NoPeaks');
end

function testImageClickMovesSliceAndAddsGuides(tc)
app = tc.TestData.app;
app.selectData('pkftest_cut');
app.simulateImageClick([0.1, -0.2]);
tc.verifyEqual(app.SliceValue, -0.2, 'AbsTol', 0.0045);   % nearest of 41 slices (step 0.008)
app.addPeak(0.07);
app.Handles.GuideMode.Value = true;
app.simulateImageClick([0.0, -0.3]);
app.simulateImageClick([0.2, 0.0]);
s = app.getState();
tc.verifyEqual(s.guides{1}, [-0.3 0.0; 0.0 0.2]);
tc.verifyEqual(app.SliceValue, -0.2, 'AbsTol', 0.0045);   % guide clicks do not move the slice
tc.verifyNotEmpty(findobj(app.Handles.Image, 'Tag', 'pkf_guide'));
app.clearGuides();
tc.verifyEmpty(app.getState().guides{1});
end

function testWindowAndIntegration(tc)
app = tc.TestData.app;
app.selectData('pkftest_cut');
app.setWindow([0.5 -0.5]);
tc.verifyEqual(app.getState().window, [-0.5 0.5]);
tc.verifyError(@() app.setWindow([2 3]), 'PeakFit:InvalidWindow');
app.setWindow([]);
tc.verifyEqual(app.getState().window, [-1 1]);
app.setIntegration(0.01);
tc.verifyNotEmpty(findobj(app.Handles.Image, 'Tag', 'pkf_band'));
tc.verifyError(@() app.setIntegration(-1), 'PeakFit:InvalidWidth');
end

% ---------------- EDC workflow ----------------
function testEDCWithFermiCutoff(tc)
app = tc.TestData.app;
app.selectData('pkftest_edc');
tc.verifyError(@() app.setFermi(true), 'PeakFit:FermiNeedsEDC');
app.setDirection('EDC');
s = app.getState();
tc.verifyEqual(s.shape, 'Pseudo-Voigt');
tc.verifyEqual(s.fermi.T, 20);
tc.verifyEqual(s.fermi.EF, 0);
app.setSlice(0);
app.setWindow([-0.35 0.04]);
app.setFermi(true);
app.addPeak(-0.19);
R = app.fitCurrentSlice();
tc.verifyTrue(R.fermi.enabled);
tc.verifyEqual(R.peaks.centre, -0.2, 'AbsTol', 2e-3);
T = app.fitRange([-0.2 0.2]);
v = all(T.valid, 2);
tc.verifyGreaterThan(nnz(v), 0.9 * numel(v));
tc.verifyLessThan(max(abs(T.centre(v) - (-0.2 + 0.8 * T.slice_values(v).^2))), 3e-3);
name = app.exportPeaks('pkftest_edc_peaks');
S = evalin('base', name);
tc.verifyEqual(S.direction, 'EDC');
tc.verifyEqual(S.peaks(1).y, T.centre(T.valid));
tc.verifyTrue(S.fermi.enabled);
app.setDirection('MDC');
s = app.getState();
tc.verifyFalse(s.fermi.enabled);
tc.verifyEqual(s.shape, 'Lorentzian');
tc.verifyEqual(height(s.peaks), 0);
end

function testFailedSliceSetsFailedLamp(tc)
app = tc.TestData.app;
c = tc.TestData.cut;
c.value(:, 40) = NaN;
app.selectData(c);
app.setSlice(c.y(40));
app.addPeak(0.0, 'FWHM', 0.06, 'Height', 50);
R = app.fitCurrentSlice();
tc.verifyFalse(R.ok);
s = app.getState();
tc.verifyEqual(s.fitStatus, 'Failed');
tc.verifyEqual(app.Handles.StatusLamp.Color, app.StatusColors(4, :));
tc.verifyEqual(char(app.Handles.FitSlice.Enable), 'on');
tc.verifyEqual(char(app.Handles.Stop.Enable), 'off');
end

% ---------------- browser menus ----------------
function testBrowserMenusOpenPeakFit(tc)
before = findall(groot, 'Type', 'figure');
tc.addTeardown(@() closeNew(before));
v5 = ARPES_data_browser_v5;
data_browser_demo_v32;
v32 = findall(groot, 'Tag', 'DataBrowser');
v32 = v32(1);
for fig = [v32 v5]
    item = findall(fig, 'Type', 'uimenu', 'Tag', 'FitPeaksNew');
    tc.verifyNumElements(item, 1);
    tc.verifyEqual(char(item.Label), 'Fit Peaks (MDC/EDC)');
    tc.verifyEqual(func2str(item.Callback), 'pkf_open_from_browser');
    tc.verifyEmpty(findall(fig, 'Type', 'uimenu', 'Label', 'Fit MDC'));
    tc.verifyEmpty(findall(fig, 'Type', 'uimenu', 'Label', 'Fit MDC '));
    h = guidata(fig);
    h.VarNames = {'pkftest_cut'};
    guidata(fig, h);
    app = item.Callback(item, []);
    tc.verifyEqual(app.DataName, 'pkftest_cut');
    delete(app);
    h.VarNames = {'pkftest_map3d'};
    guidata(fig, h);
    app = item.Callback(item, []);
    tc.verifyEmpty(app.Data);
    tc.verifyTrue(contains(app.Handles.Status.Text, '2D cuts only'));
    delete(app);
end
v5item = findall(v5, 'Type', 'uimenu', 'Tag', 'FitPeaksNew');
tc.verifyEqual(char(v5item.Parent.Label), 'Fit spectra');
v32item = findall(v32, 'Type', 'uimenu', 'Tag', 'FitPeaksNew');
tc.verifyEqual(char(v32item.Parent.Label), 'Tools');
end

% ---------------- fixtures ----------------
function closeNew(before)
after = findall(groot, 'Type', 'figure');
delete(setdiff(after, before));
end

function [c, truthFcn] = mdcCut()
k = linspace(-1, 1, 201); E = linspace(-0.3, 0.02, 41);
truthFcn = @(e) e / 1.5 + 0.2;
v = zeros(numel(k), numel(E));
for j = 1:numel(E)
    v(:, j) = pkf_lineshape(k, truthFcn(E(j)), 0.06, 100, 1) + 10 + 5 * k;
end
s = RandStream('mt19937ar', 'Seed', 31);
c = struct('x', k, 'y', E, 'value', v + randn(s, size(v)), 'info', struct('temperature', 15));
end

function c = edcCut()
k = linspace(-0.3, 0.3, 31); E = (-0.4:0.002:0.06);
F = struct('enabled', true, 'EF', 0, 'T', 20);
v = zeros(numel(k), numel(E));
for i = 1:numel(k)
    pk = struct('centre', -0.2 + 0.8 * k(i)^2, 'fwhm', 0.04, 'height', 200, 'eta', 0.5);
    v(i, :) = pkf_model(E(:), pk, [20 15], struct('uMid', -0.155, 'Fermi', F)).';
end
s = RandStream('mt19937ar', 'Seed', 32);
c = struct('x', k, 'y', E, 'value', v + 2 * randn(s, size(v)), 'info', struct('temperature', 20));
end
