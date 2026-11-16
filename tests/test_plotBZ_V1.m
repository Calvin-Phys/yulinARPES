function tests = test_plotBZ_V1
%TEST_PLOTBZ_V1 Regression checks for Brillouin-zone geometry and graphics.
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
rootFolder = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.originalPath = path;
addpath(fullfile(rootFolder, 'Visualization', 'plotBZ_V1'));
addpath(genpath(fullfile(rootFolder, 'third_party', 'matGeom', 'matGeom')));
end

function teardownOnce(testCase)
path(testCase.TestData.originalPath);
end

function testPrimitiveSurfaceAreaAndIntegerSpan(testCase)
% For cubic (hkl) with coprime indices, A_surface = a^2*|hkl|.
a = 3.1416;
bulkBasis = (2*pi/a)*eye(3);
directions = [0 0 1; 1 1 0; 1 1 1; 2 3 4];
for direction = directions'
    miller = direction';
    normal = miller*bulkBasis;
    basis = plotBZ_V1_primitive_surface_basis(bulkBasis, normal);
    actualArea = norm(cross(basis(1, :), basis(2, :)));
    expectedArea = (2*pi/a)^2/norm(miller);
    verifyEqual(testCase, actualArea, expectedArea, 'RelTol', 1e-10);

    projected = bulkBasis - (bulkBasis*normal'/dot(normal, normal))*normal;
    coefficients = basis'\projected';
    verifyLessThan(testCase, max(abs(coefficients - round(coefficients)), [], 'all'), 1e-9);
end
end

function testPlaneSectionTopologies(testCase)
vertices = [-1 -1 -1; 1 -1 -1; 1 1 -1; -1 1 -1; ...
    -1 -1 1; 1 -1 1; 1 1 1; -1 1 1];
faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; ...
    2 3 7 6; 3 4 8 7; 4 1 5 8];

triangle = plotBZ_V1_intersectBZ(vertices, faces, ...
    createPlane([0.9 0.9 0.9], [1 1 1]), 0, 0, 0);
square = plotBZ_V1_intersectBZ(vertices, faces, ...
    createPlane([0 0 0], [1 0 0]), 0, 0, 0);
face = plotBZ_V1_intersectBZ(vertices, faces, ...
    createPlane([1 0 0], [1 0 0]), 0, 0, 0);
disjoint = plotBZ_V1_intersectBZ(vertices, faces, ...
    createPlane([2 0 0], [1 0 0]), 0, 0, 0);
tangent = plotBZ_V1_intersectBZ(vertices, faces, ...
    createPlane([1 1 1], [1 1 1]), 0, 0, 0);

verifySize(testCase, triangle, [3 6]);
verifySize(testCase, square, [4 6]);
verifySize(testCase, face, [4 6]);
verifySize(testCase, disjoint, [0 6]);
verifySize(testCase, tangent, [0 6]);
end

function testHexagonalSurfaceReductionTerminates(testCase)
% The 60-degree tie must not make Gauss reduction alternate forever.
a = 3;
c = 5;
directBasis = [a/2 -a*sqrt(3)/2 0; ...
    a/2 a*sqrt(3)/2 0; 0 0 c];
bulkBasis = 2*pi*inv(directBasis)';
surfaceBasis = plotBZ_V1_primitive_surface_basis(bulkBasis, bulkBasis(3, :));
verifyEqual(testCase, norm(cross(surfaceBasis(1, :), surfaceBasis(2, :))), ...
    norm(cross(bulkBasis(1, :), bulkBasis(2, :))), 'RelTol', 1e-10);
end

function testAllBravaisReciprocalVolumes(testCase)
% Check all 14 GUI choices with noncubic lengths and low-symmetry angles.
previousVisibility = get(groot, 'DefaultFigureVisible');
set(groot, 'DefaultFigureVisible', 'off');
visibilityCleanup = onCleanup(@() set(groot, 'DefaultFigureVisible', previousVisibility));
gui = plotBZ_V1();
guiCleanup = onCleanup(@() delete(gui));
handles = guidata(gui);
choices = {{'radio_primitive', 1; 'radio_bodycentered', 2; 'radio_facecentered', 4}, ...
    {'radio_primitive', 1; 'radio_bodycentered', 2}, ...
    {'radio_primitive', 1; 'radio_bodycentered', 2; ...
        'radio_facecentered', 4; 'radio_basecentered', 2}, ...
    {'radio_primitive', 1}, {'radio_primitive', 1}, ...
    {'radio_primitive', 1; 'radio_basecentered', 2}, {'radio_primitive', 1}};
lengths = [3 3 3; 3 3 5; 3 4 5; 3 3 5; ...
    3 3 3; 3 4 5; 3 4 5];
angles = [90 90 90; 90 90 90; 90 90 90; 90 90 120; ...
    80 80 80; 90 100 90; 80 100 110];

for classIndex = 1:7
    set(handles.LatticeClass, 'Value', classIndex);
    plotBZ_V1('LatticeClass_Callback', handles.LatticeClass, [], handles);
    for axisIndex = 1:3
        lengthFields = {'a', 'b', 'c'};
        angleFields = {'alpha', 'beta', 'gamma'};
        set(handles.(lengthFields{axisIndex}), 'String', num2str(lengths(classIndex, axisIndex)));
        set(handles.(angleFields{axisIndex}), 'String', num2str(angles(classIndex, axisIndex)));
    end
    a = lengths(classIndex, 1);
    b = lengths(classIndex, 2);
    c = lengths(classIndex, 3);
    alpha = deg2rad(angles(classIndex, 1));
    beta = deg2rad(angles(classIndex, 2));
    gamma = deg2rad(angles(classIndex, 3));
    metric = [a^2 a*b*cos(gamma) a*c*cos(beta); ...
        a*b*cos(gamma) b^2 b*c*cos(alpha); ...
        a*c*cos(beta) b*c*cos(alpha) c^2];
    conventionalVolume = sqrt(det(metric));

    classChoices = choices{classIndex};
    for choiceIndex = 1:size(classChoices, 1)
        set(handles.uipanel_LatticeType, 'SelectedObject', ...
            handles.(classChoices{choiceIndex, 1}));
        for conventionalMillerMode = [1 0]
            set(handles.radio_hklconv, 'Value', conventionalMillerMode);
            [b1, b2, b3, normal] = plotBZ_V1_construct_rec_lattice_vectors(handles);
            bulkBasis = [b1; b2; b3];
            multiplicity = classChoices{choiceIndex, 2};
            expectedVolume = (2*pi)^3*multiplicity/conventionalVolume;
            verifyEqual(testCase, abs(det(bulkBasis)), expectedVolume, 'RelTol', 1e-10);

            surfaceBasis = plotBZ_V1_primitive_surface_basis(bulkBasis, normal);
            verifyGreaterThan(testCase, ...
                norm(cross(surfaceBasis(1, :), surfaceBasis(2, :))), 0);
            projected = bulkBasis - (bulkBasis*normal'/dot(normal, normal))*normal;
            coefficients = surfaceBasis'\projected';
            verifyLessThan(testCase, ...
                max(abs(coefficients - round(coefficients)), [], 'all'), 1e-8);
        end
    end
end
set(handles.MillerH, 'String', '0');
set(handles.MillerK, 'String', '0');
set(handles.MillerL, 'String', '0');
verifyError(testCase, @() plotBZ_V1_construct_rec_lattice_vectors(handles), ...
    'plotBZ_V1:InvalidInput');
end

function testInvalidScalarAndNormal(testCase)
figureHandle = figure('Visible', 'off');
testCase.addTeardown(@() delete(figureHandle));
handles.a = uicontrol(figureHandle, 'Style', 'edit', 'String', '1+2');
verifyError(testCase, @() plotBZ_V1_parse_scalar(handles, 'a', 'positive'), ...
    'plotBZ_V1:InvalidInput');
set(handles.a, 'String', '0');
verifyError(testCase, @() plotBZ_V1_parse_scalar(handles, 'a', 'positive'), ...
    'plotBZ_V1:InvalidInput');
verifyError(testCase, @() plotBZ_V1_primitive_surface_basis(eye(3), [0 0 0]), ...
    'plotBZ_V1:InvalidBasis');
end

function testAdaptivePaddingAndOverlayClear(testCase)
verifyEqual(testCase, plotBZ_V1_lattice_padding(eye(3)), [3 3 3]);
skewBasis = [1 0; 0.99 0.1];
verifyGreaterThan(testCase, max(plotBZ_V1_lattice_padding(skewBasis)), 2);

figureHandle = figure('Visible', 'off');
testCase.addTeardown(@() delete(figureHandle));
axesHandle = axes(figureHandle);
measurement = plot(axesHandle, [0 1], [0 1], 'Tag', 'measurement');
previousGraphics = findall(axesHandle);
hold(axesHandle, 'on');
plot(axesHandle, [0 1], [1 0]);
plotBZ_V1_tag_graphics(axesHandle, previousGraphics);
verifyEqual(testCase, numel(findall(figureHandle, 'Tag', 'plotBZ_V1_generated')), 1);
plotBZ_V1_clear_graphics(figureHandle.Number);
verifyTrue(testCase, isgraphics(measurement));
verifyEmpty(testCase, findall(figureHandle, 'Tag', 'plotBZ_V1_generated'));
end
