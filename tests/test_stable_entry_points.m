function tests = test_stable_entry_points
tests = functiontests(localfunctions);
end

function setup(testCase)
rootFolder = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.originalPath = path;
addpath(fullfile(rootFolder, 'Data_enhance'));
addpath(fullfile(rootFolder, 'Data_process'));
end

function teardown(testCase)
path(testCase.TestData.originalPath);
end

function testNumericParserAcceptsFiniteScalar(testCase)
verifyEqual(testCase, parse_numeric_scalar('12.5'), 12.5);
verifyEqual(testCase, parse_numeric_scalar('-3.2e1'), -32);
end

function testNumericParserRejectsNonNumericAndNonFiniteInput(testCase)
verifyError(testCase, @() parse_numeric_scalar('NaN'), ...
    'yulinARPES:InvalidNumericInput');
verifyError(testCase, @() parse_numeric_scalar('1+2'), ...
    'yulinARPES:InvalidNumericInput');
verifyError(testCase, @() parse_numeric_scalar(''), ...
    'yulinARPES:InvalidNumericInput');
end

function testRearrangeRejectsUnsupportedMapping(testCase)
verifyError(testCase, @() Rearrange2DTo3D({}, 'unsupported'), ...
    'yulinARPES:InvalidMappingMode');
end

function testRearrangeRejectsEmptyInput(testCase)
verifyError(testCase, @() Rearrange2DTo3D({}, 'index'), ...
    'yulinARPES:EmptyDataList');
end

function testRearrangeIndexMappingPreservesValues(testCase)
first = struct('x', [0 1], 'y', [10 20], 'value', [1 2; 3 4]);
second = struct('x', [0 1], 'y', [10 20], 'value', [5 6; 7 8]);
result = Rearrange2DTo3D({first, second}, 'index');

expected = zeros(2, 2, 2);
expected(1,:,:) = first.value;
expected(2,:,:) = second.value;
verifyEqual(testCase, result.x, [1 2]);
verifyEqual(testCase, result.y, first.x);
verifyEqual(testCase, result.z, first.y);
verifyEqual(testCase, result.value, expected);
end
