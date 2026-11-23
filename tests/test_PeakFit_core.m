function tests = test_PeakFit_core
%TEST_PEAKFIT_CORE  Numerical tests of the PeakFit backend (Fitting/PeakFit).
%   Synthetic MDC/EDC data with known parameters; the expected values come
%   from the generating formulas, not from the fitter. Base MATLAB only;
%   OxA_CUT checks are skipped when OX_ARPES is not on the path.
tests = functiontests(localfunctions);
end

function setupOnce(tc)
root = fileparts(fileparts(mfilename('fullpath')));
tc.TestData.oldPath = addpath(fullfile(root, 'Fitting', 'PeakFit'));
end

function teardownOnce(tc)
path(tc.TestData.oldPath);
end

% ---------------- model functions ----------------
function testLineshapeHeightAndFWHM(tc)
for eta = [0 0.3 1]
    tc.verifyEqual(pkf_lineshape(0.2, 0.2, 0.05, 7, eta), 7, 'AbsTol', 1e-12);
    tc.verifyEqual(pkf_lineshape(0.2 + 0.025, 0.2, 0.05, 7, eta), 3.5, 'AbsTol', 1e-12);
    tc.verifyEqual(pkf_lineshape(0.2 - 0.025, 0.2, 0.05, 7, eta), 3.5, 'AbsTol', 1e-12);
end
% eta = 1 is the Lorentzian h*(w/2)^2/((u-c)^2+(w/2)^2)
u = linspace(-1, 1, 7);
tc.verifyEqual(pkf_lineshape(u, 0.1, 0.4, 2, 1), 2 * 0.2^2 ./ ((u - 0.1).^2 + 0.2^2), 'AbsTol', 1e-12);
end

function testFermiFunctionIsOverflowSafe(tc)
f = pkf_fermi([-10 0 10], 0, 1e-3);
tc.verifyEqual(f, [1 0.5 0], 'AbsTol', 1e-300);
tc.verifyTrue(all(isfinite(f)));
kT = 8.617333262e-5 * 30;
tc.verifyEqual(pkf_fermi(kT, 0, 30), 1 / (exp(1) + 1), 'RelTol', 1e-12);
tc.verifyEqual(pkf_fermi([-1 0 1], 0, 0), [1 0.5 0]);
end

% ---------------- single-profile fits ----------------
function testLorentzianWithLinearBackgroundRecovery(tc)
u = linspace(-1, 1, 401)';
truth = [0.123 0.08 150 1];
I0 = pkf_lineshape(u, truth(1), truth(2), truth(3), 1) + 12 + 6 * u;
rng(3); I = I0 + randn(size(u));
R = pkf_fit_profile(u, I, struct('centre', 0.1), 'Shape', 'Lorentzian');
tc.verifyTrue(R.ok && R.converged);
P = R.peaks;
tc.verifyEqual(P.centre, truth(1), 'AbsTol', 4 * P.err_centre);
tc.verifyEqual(P.fwhm, truth(2), 'AbsTol', 4 * P.err_fwhm);
tc.verifyEqual(P.height, truth(3), 'AbsTol', 4 * P.err_height);
tc.verifyEqual(P.eta, 1);
tc.verifyEqual(R.background, [12 6], 'AbsTol', 0.5);
tc.verifyEqual(R.chi2_red, 1, 'AbsTol', 0.2);
tc.verifyGreaterThan(R.r2, 0.99);
end

function testUncertaintyCoverage(tc)
% About 68 % of repeated noisy fits should lie within 1 sigma of the truth.
u = linspace(-1, 1, 201)';
I0 = pkf_lineshape(u, -0.2, 0.1, 50, 1) + 5;
rng(7);
hits = 0; n = 60;
for k = 1:n
    R = pkf_fit_profile(u, I0 + randn(size(u)), struct('centre', -0.18), 'FlatBackground', true);
    hits = hits + (abs(R.peaks.centre + 0.2) <= R.peaks.err_centre);
end
tc.verifyGreaterThan(hits / n, 0.5);
tc.verifyLessThan(hits / n, 0.85);
end

function testGaussianAndPseudoVoigtRecovery(tc)
u = linspace(-0.5, 0.5, 301)';
rng(5);
Ig = pkf_lineshape(u, 0.05, 0.12, 80, 0) + 3 + 0.5 * randn(size(u));
R = pkf_fit_profile(u, Ig, struct('centre', 0.0), 'Shape', 'Gaussian');
tc.verifyEqual(R.peaks.eta, 0);
tc.verifyEqual(R.peaks.centre, 0.05, 'AbsTol', 2e-3);
tc.verifyEqual(R.peaks.fwhm, 0.12, 'RelTol', 0.03);
Ip = pkf_lineshape(u, -0.1, 0.1, 100, 0.4) + 3 + 0.3 * randn(size(u));
R = pkf_fit_profile(u, Ip, struct('centre', -0.08), 'Shape', 'Pseudo-Voigt');
tc.verifyEqual(R.peaks.eta, 0.4, 'AbsTol', 0.05);
tc.verifyEqual(R.peaks.fwhm, 0.1, 'RelTol', 0.02);
tc.verifyEqual(R.peaks.centre, -0.1, 'AbsTol', 1e-3);
tc.verifyGreaterThan(R.peaks.err_eta, 0);
end

function testFlatBackgroundHoldsSlopeAtZero(tc)
u = linspace(-1, 1, 201)';
I = pkf_lineshape(u, 0, 0.2, 10, 1) + 2 + 3 * u;
R = pkf_fit_profile(u, I, struct('centre', 0), 'FlatBackground', true, 'Background', [1 5]);
tc.verifyEqual(R.background(2), 0);
tc.verifyEqual(R.err_background(2), 0);
R2 = pkf_fit_profile(u, I, struct('centre', 0));
tc.verifyEqual(R2.background, [2 3], 'AbsTol', 1e-4);
end

function testTwoOverlappingPeaks(tc)
u = linspace(-1, 1, 401)';
rng(9);
I = pkf_lineshape(u, -0.08, 0.12, 60, 1) + pkf_lineshape(u, 0.10, 0.10, 40, 1) + 4 + 0.5 * randn(size(u));
R = pkf_fit_profile(u, I, struct('centre', {-0.1, 0.12}));
tc.verifyEqual([R.peaks.centre], [-0.08 0.10], 'AbsTol', 3e-3);
tc.verifyEqual([R.peaks.fwhm], [0.12 0.10], 'RelTol', 0.05);
tc.verifyEqual([R.peaks.height], [60 40], 'RelTol', 0.05);
end

function testSixPeakFit(tc)
u = linspace(-3, 3, 1201)';
c = linspace(-2.5, 2.5, 6);
I = 2 * ones(size(u));
for k = 1:6, I = I + pkf_lineshape(u, c(k), 0.15, 20 + 5 * k, 1); end
R = pkf_fit_profile(u, I, struct('centre', num2cell(c + 0.03)));
tc.verifyEqual([R.peaks.centre], c, 'AbsTol', 1e-5);
end

function testEDCFermiCutoffNearEF(tc)
% A peak 15 meV below EF at 30 K: the cutoff model recovers it on the full
% window; a crop below EF leaves only the lower flank.
E = (-0.25:0.002:0.06)';
F = struct('enabled', true, 'EF', 0, 'T', 30);
truth = struct('centre', -0.015, 'fwhm', 0.04, 'height', 300, 'eta', 0.6);
I0 = pkf_model(E, truth, [20 10], struct('uMid', mean([min(E) max(E)]), 'Fermi', F));
rng(4); I = I0 + 2 * randn(size(E));
R = pkf_fit_profile(E, I, struct('centre', -0.03), 'Shape', 'Pseudo-Voigt', 'Fermi', F);
tc.verifyTrue(R.ok);
tc.verifyEqual(R.peaks.centre, truth.centre, 'AbsTol', 1.5e-3);
tc.verifyEqual(R.peaks.fwhm, truth.fwhm, 'RelTol', 0.08);
tc.verifyEqual(R.fermi.T, 30);
tc.verifyLessThan(max(abs(R.fit(R.u > 0.03))), 1);   % the model is cut off above EF
end

function testBoundsAreEnforced(tc)
u = linspace(-1, 1, 201)';
I = pkf_lineshape(u, 0.5, 0.1, 30, 1) + 1;
% Centre bounded to [-0.2 0.2] cannot reach the true 0.5.
R = pkf_fit_profile(u, I, struct('centre', 0, 'lo', -0.2, 'hi', 0.2));
tc.verifyLessThanOrEqual(R.peaks.centre, 0.2);
tc.verifyGreaterThanOrEqual(R.peaks.centre, -0.2);
tc.verifyTrue(any(contains(R.warnings, 'bound')));
% A start centre outside the window is clamped inside; the window crops the data.
R = pkf_fit_profile(u, I, struct('centre', 0.9), 'Window', [0.2 0.8]);
tc.verifyEqual(R.window, [0.2 0.8]);
tc.verifyTrue(all(R.u >= 0.2 & R.u <= 0.8));
tc.verifyTrue(R.peaks.centre >= 0.2 && R.peaks.centre <= 0.8);
R = pkf_fit_profile(u, I, struct('centre', 0.55), 'Window', [0.2 0.8]);
tc.verifyEqual(R.peaks.centre, 0.5, 'AbsTol', 1e-4);
% A dip (negative peak) cannot produce a negative height.
R = pkf_fit_profile(u, 10 - pkf_lineshape(u, 0, 0.2, 5, 1), struct('centre', 0));
tc.verifyGreaterThanOrEqual(R.peaks.height, 0);
tc.verifyGreaterThanOrEqual(R.peaks.fwhm, 0.005);
end

function testHeldValuesAreUsedExactly(tc)
u = linspace(-1, 1, 201)';
I = pkf_lineshape(u, 0.1, 0.2, 30, 1) + 1;
R = pkf_fit_profile(u, I, struct('centre', 0.123456, 'fixCentre', true, 'fwhm', 0.25, 'fixFWHM', true));
tc.verifyEqual(R.peaks.centre, 0.123456);
tc.verifyEqual(R.peaks.fwhm, 0.25);
tc.verifyEqual([R.peaks.err_centre R.peaks.err_fwhm], [0 0]);
tc.verifyError(@() pkf_fit_profile(u, I, struct('centre', 0, 'fwhm', 0, 'fixFWHM', true)), ...
    'PeakFit:InvalidParameter');
tc.verifyError(@() pkf_fit_profile(u, I, struct('centre', 0), 'Shape', 'cauchy'), 'PeakFit:InvalidShape');
tc.verifyError(@() pkf_fit_profile(u, I, struct('centre', 0), 'Fermi', struct('enabled', true, 'EF', 0, 'T', 0)), ...
    'PeakFit:InvalidFermi');
end

function testNaNAndEmptyProfiles(tc)
u = linspace(-1, 1, 201)';
I = pkf_lineshape(u, 0.1, 0.2, 30, 1) + 1;
I(1:20:end) = NaN; I(5) = Inf;
R = pkf_fit_profile(u, I, struct('centre', 0));
tc.verifyTrue(R.ok);
tc.verifyEqual(R.nPoints, nnz(isfinite(I)));
tc.verifyEqual(R.peaks.centre, 0.1, 'AbsTol', 1e-6);
R = pkf_fit_profile(u, nan(size(u)), struct('centre', 0));
tc.verifyFalse(R.ok);
tc.verifyTrue(contains(R.message, 'not fitted'));
tc.verifyTrue(isnan(R.peaks.err_centre) && isnan(R.chi2_red));
end

% ---------------- input, profiles, peak finding ----------------
function testInputStructAndOxACut(tc)
c = makeMDCCut();
D = pkf_input(c, 'syn');
tc.verifyEqual(D.value, c.value);
tc.verifyEqual(D.temperature, 12);
tc.verifyEqual(D.name, 'syn');
tc.assumeTrue(exist('OxA_CUT', 'class') == 8, 'OX_ARPES not on the path.');
obj = OxA_CUT(c.x, c.y, c.value);
obj.info.temperature = 7;
D2 = pkf_input(obj);
tc.verifyEqual(D2.sourceClass, 'OxA_CUT');
tc.verifyEqual(D2.value, c.value);
tc.verifyEqual(D2.temperature, 7);
tc.verifyEqual(D2.xLabel, 'Angle Y (deg)');
end

function testInputRejectsUnsupportedData(tc)
c = makeMDCCut();
m = struct('x', 1:3, 'y', 1:4, 'z', 1:5, 'value', rand(3, 4, 5));
tc.verifyError(@() pkf_input(m), 'PeakFit:Not2D');
tc.verifyError(@() pkf_input(struct('x', 1:3, 'y', 1:4, 'value', rand(4, 3))), 'PeakFit:SizeMismatch');
tc.verifyError(@() pkf_input(struct('x', [1 3 2], 'y', 1:4, 'value', rand(3, 4))), 'PeakFit:InvalidAxis');
tc.verifyError(@() pkf_input(magic(3)), 'PeakFit:InvalidData');
tc.verifyError(@() pkf_input('pkf_no_such_variable_xyz'), 'PeakFit:UnknownVariable');
c.value = c.value(:, :, [1 1]);
tc.verifyError(@() pkf_input(c), 'PeakFit:Not2D');
if exist('OxA_MAP', 'class') == 8
    tc.verifyError(@() pkf_input(OxA_MAP(1:3, 1:4, 1:5, rand(3, 4, 5))), 'PeakFit:Not2D');
end
end

function testProfilesBothDirectionsAndIntegration(tc)
x = [3 2 1]; y = [10 20 30 40];          % descending x
v = [1 2 3 4; 5 6 7 8; 9 10 11 12];      % v(x, y)
D = pkf_input(struct('x', x, 'y', y, 'value', v));
[u, I, info] = pkf_extract_profile(D, 'MDC', 21, 0);
tc.verifyEqual(u.', [1 2 3]);             % sorted ascending
tc.verifyEqual(I.', [10 6 2]);
tc.verifyEqual(info.sliceValue, 20);
[~, I] = pkf_extract_profile(D, 'MDC', 20, 10);   % averages y = 10, 20, 30
tc.verifyEqual(I.', [10 6 2]);
[u, I] = pkf_extract_profile(D, 'Vertical', 2, 0);
tc.verifyEqual(u.', y);
tc.verifyEqual(I.', [5 6 7 8]);
[~, I] = pkf_extract_profile(D, 'EDC', 2, 1);       % averages all x
tc.verifyEqual(I.', [5 6 7 8]);
tc.verifyError(@() pkf_extract_profile(D, 'diagonal', 2, 0), 'PeakFit:InvalidDirection');
end

function testFindPeaksSuggestions(tc)
u = linspace(-1, 1, 501)';
I = pkf_lineshape(u, -0.4, 0.1, 50, 1) + pkf_lineshape(u, 0.3, 0.1, 30, 1) + ...
    pkf_lineshape(u, 0.7, 0.05, 2, 1) + 5;
c = pkf_find_peaks(u, I, 'Prominence', 0.1);
tc.verifyEqual(c, [-0.4 0.3], 'AbsTol', 0.01);
c = pkf_find_peaks(u, I, 'Prominence', 0.01);
tc.verifyEqual(numel(c), 3);
c = pkf_find_peaks(u, I, 'Prominence', 0.01, 'MaxPeaks', 1);
tc.verifyEqual(c, -0.4, 'AbsTol', 0.01);
c = pkf_find_peaks(u, I, 'Window', [0 1]);
tc.verifyEqual(c, 0.3, 'AbsTol', 0.01);
end

function testDefaultFermiLevel(tc)
D = pkf_input(makeMDCCut());
tc.verifyEqual(pkf_default_ef(D), 0);
c = makeMDCCut();
c.y = c.y + 100; c.info.photon_energy = 105; c.info.workfunction = 5;
[EF, src] = pkf_default_ef(pkf_input(c));
tc.verifyEqual(EF, 100, 'AbsTol', 1e-12);
c.info.workfunction = 3;   % hv - wf = 102 lies outside the axis
tc.verifyEqual(pkf_default_ef(pkf_input(c)), 0);
tc.verifyTrue(contains(src, 'photon_energy'));
end

% ---------------- tracking ----------------
function testTrackMDCFromSingleSeedBothWays(tc)
[c, truthFcn] = makeMDCCut();
D = pkf_input(c);
T = pkf_track(D, struct('centre', truthFcn(-0.15) + 0.01), 'Direction', 'MDC', 'Start', -0.15);
tc.verifyEqual(numel(T.slice_values), numel(c.y));
tc.verifyTrue(all(T.valid));
err = T.centre - truthFcn(T.slice_values);
tc.verifyLessThan(max(abs(err)), 2e-3);
tc.verifyLessThan(median(abs(err) ./ T.err_centre), 2);
tc.verifyEqual(T.fwhm, 0.06 * ones(size(T.fwhm)), 'AbsTol', 6e-3);
tc.verifyEqual(T.slice_values(T.slice_index == T.start_index), c.y(T.start_index));
end

function testTrackEDCDispersion(tc)
[c, bandFcn] = makeEDCCut();
D = pkf_input(c);
seed = struct('centre', bandFcn(0) + 0.01);
T = pkf_track(D, seed, 'Direction', 'EDC', 'Start', 0, 'Range', [-0.3 0.3], 'Shape', 'Pseudo-Voigt', ...
    'Window', [-0.35 0.04], 'Fermi', struct('enabled', true, 'EF', 0, 'T', 20));
tc.verifyGreaterThan(T.nValid, 0.9 * numel(T.slice_values));
v = T.valid;
err = T.centre(v) - bandFcn(T.slice_values(v));
tc.verifyLessThan(max(abs(err)), 3e-3);
tc.verifyEqual(median(T.eta(v)), 0.5, 'AbsTol', 0.1);
end

function testTrackSkipsNaNSlicesAndRejectsJumps(tc)
[c, truthFcn] = makeMDCCut();
c.value(:, 30) = NaN;
D = pkf_input(c);
T = pkf_track(D, struct('centre', truthFcn(c.y(60))), 'Direction', 'MDC', 'Start', c.y(60));
row = find(T.slice_index == 30);
tc.verifyFalse(T.ok(row));
tc.verifyTrue(all(T.ok([1:row - 1 row + 1:end])));
tc.verifyTrue(contains(T.message{row}, 'not fitted'));
% A very small MaxJump rejects slices; StopAfter ends the walk.
T = pkf_track(D, struct('centre', truthFcn(c.y(60))), 'Start', c.y(60), 'MaxJump', 1e-3, 'StopAfter', 2);
tc.verifyLessThan(nnz(T.attempted), numel(T.slice_values));
tc.verifyTrue(any(T.flagged(:)));
tc.verifyFalse(any(T.valid(T.flagged)));
end

function testTrackStopFcnAndProgress(tc)
[c, truthFcn] = makeMDCCut();
D = pkf_input(c);
count = 0;
    function tf = stopAfterTen()
        count = count + 1; tf = count > 10;
    end
calls = 0;
    function progress(~, ~)
        calls = calls + 1;
    end
T = pkf_track(D, struct('centre', truthFcn(-0.1)), 'Start', -0.1, 'StopFcn', @stopAfterTen, ...
    'Progress', @progress);
tc.verifyTrue(T.stopped);
tc.verifyEqual(nnz(T.attempted), 10);
tc.verifyEqual(calls, 10);
end

function testTrackGuideSteersStartCentre(tc)
% Two bands; a guide keeps the tracked peak on the second band.
k = linspace(-1, 1, 301); E = linspace(-0.3, 0, 61);
v = zeros(numel(k), numel(E));
for j = 1:numel(E)
    v(:, j) = pkf_lineshape(k, -0.4 + E(j), 0.05, 80, 1) + pkf_lineshape(k, 0.4 - E(j), 0.05, 80, 1) + 3;
end
D = pkf_input(struct('x', k, 'y', E, 'value', v));
G = {[E(1) 0.4 - E(1); E(end) 0.4 - E(end)]};
T = pkf_track(D, struct('centre', 0.55), 'Start', -0.15, 'Guides', G);
tc.verifyEqual(T.centre, 0.4 - T.slice_values, 'AbsTol', 1e-3);
end

% ---------------- export ----------------
function testExportCoordinatesAndFields(tc)
[c, truthFcn] = makeMDCCut();
D = pkf_input(c, 'syn');
T = pkf_track(D, struct('centre', truthFcn(-0.1)), 'Start', -0.1, 'Range', [-0.2 0]);
S = pkf_export(T, D);
tc.verifyEqual(S.direction, 'MDC');
tc.verifyEqual(S.source_name, 'syn');
tc.verifyEqual(S.peaks(1).x, T.centre(T.valid));     % MDC: x = centre
tc.verifyEqual(S.peaks(1).y, T.slice_values(T.valid)); % y = energy
tc.verifyEqual(S.x, S.peaks(1).x);
for f = {'fwhm', 'height', 'eta', 'err', 'valid'}
    tc.verifyTrue(isfield(S.peaks, f{1}));
end
for f = {'model', 'slice_axis', 'slice_values', 'background', 'chi2_red', 'r2', 'source_name'}
    tc.verifyTrue(isfield(S, f{1}));
end
[ce, bandFcn] = makeEDCCut();
De = pkf_input(ce, 'edc');
Te = pkf_track(De, struct('centre', bandFcn(0)), 'Direction', 'EDC', 'Start', 0, 'Range', [-0.1 0.1], ...
    'Shape', 'Pseudo-Voigt', 'Window', [-0.35 0.04], 'Fermi', struct('enabled', true, 'EF', 0, 'T', 20));
Se = pkf_export(Te, De);
tc.verifyEqual(Se.peaks(1).x, Te.slice_values(Te.valid));   % EDC: x = momentum
tc.verifyEqual(Se.peaks(1).y, Te.centre(Te.valid));         % y = fitted energy
% Single-slice export
[u, I] = pkf_extract_profile(D, 'MDC', -0.1, 0);
R = pkf_fit_profile(u, I, struct('centre', truthFcn(-0.1)));
S1 = pkf_export(R, D, 'SliceValue', -0.1, 'Direction', 'MDC');
tc.verifyEqual(S1.peaks(1).x, R.peaks.centre);
tc.verifyEqual(S1.peaks(1).y, -0.1);
end

% ---------------- fixtures ----------------
function [c, truthFcn] = makeMDCCut()
% Linear MDC band k = E/1.5 + 0.2, Lorentzian FWHM 0.06, sloped background.
k = linspace(-1, 1, 301); E = linspace(-0.3, 0.02, 81);
truthFcn = @(e) e / 1.5 + 0.2;
v = zeros(numel(k), numel(E));
for j = 1:numel(E)
    v(:, j) = pkf_lineshape(k, truthFcn(E(j)), 0.06, 100, 1) + 10 + 5 * k;
end
s = RandStream('mt19937ar', 'Seed', 21);
v = v + randn(s, size(v));
c = struct('x', k, 'y', E, 'value', v, 'info', struct('temperature', 12));
end

function [c, bandFcn] = makeEDCCut()
% Parabolic band E = -0.2 + 0.8 k^2, pseudo-Voigt (eta 0.5, FWHM 40 meV),
% linear background, all multiplied by the Fermi function at 20 K.
k = linspace(-0.4, 0.4, 41); E = (-0.4:0.002:0.06);
bandFcn = @(kk) -0.2 + 0.8 * kk.^2;
F = struct('enabled', true, 'EF', 0, 'T', 20);
v = zeros(numel(k), numel(E));
for i = 1:numel(k)
    pk = struct('centre', bandFcn(k(i)), 'fwhm', 0.04, 'height', 200, 'eta', 0.5);
    v(i, :) = pkf_model(E(:), pk, [20 15], struct('uMid', -0.155, 'Fermi', F)).';
end
s = RandStream('mt19937ar', 'Seed', 22);
v = v + 2 * randn(s, size(v));
c = struct('x', k, 'y', E, 'value', v, 'info', struct('temperature', 20));
end
