# MATLAB batch fallback

Use this reference only when the live connector cannot complete a task that can
also be fulfilled through independent file inputs and saved outputs. Read
[SKILL.md](../SKILL.md) and [session guidance](../../MATLAB_SETUP.md) first.
Batch does not repair invalid data, missing calibration, or a numerical error.

## Launch a separate process

Create a job file in a writable temporary directory. With the intended MATLAB
executable on `PATH`, run from the directory containing that job:

```sh
matlab -batch "run('batch_arpes_job.m')"
```

Otherwise use the discovered executable's absolute path with the calling shell's
normal quoting. Do not assume a MATLAB install directory or operating system.
The process cannot change an already-open desktop workspace or keep interactive
figures after exit. For a request requiring those effects, restore live access
instead of reporting a batch result as a completed desktop operation.

## Job file pattern

Supply these environment variables before launch, using actual discovered or
user-selected paths: `YULIN_ARPES_ROOT`, `OX_ARPES_ROOT`, `ARPES_INPUT_FILE`,
and `ARPES_OUTPUT_FILE`. Alternatively, put the task's explicit path values in
the job configuration. These are per-job inputs, not repository settings.

```matlab
yulinRoot = getenv('YULIN_ARPES_ROOT');
oxRoot = getenv('OX_ARPES_ROOT');
inputPath = getenv('ARPES_INPUT_FILE');
matPath = getenv('ARPES_OUTPUT_FILE');
assert(isfile(fullfile(yulinRoot, 'setup_yulinARPES.m')), ...
    'Configure the yulinARPES checkout root.');
assert(isfolder(fullfile(oxRoot, 'DataType')), ...
    'Configure the matching OX_ARPES checkout root.');
assert(isfile(inputPath), 'Choose an existing input file.');
assert(~isempty(matPath) && isfolder(fileparts(matPath)), ...
    'Choose an output file in an existing writable directory.');
assert(~isfile(matPath), 'Output already exists; choose another destination.');
addpath(yulinRoot);
setup_yulinARPES;
addpath(fullfile(oxRoot, 'DataType'));
addpath(genpath(fullfile(oxRoot, 'DataLoader')));
addpath(genpath(fullfile(oxRoot, 'DataAnalysis')));
addpath(fullfile(oxRoot, 'GUI'));

[raw, report] = load_arpes(inputPath);
if isempty(raw) || ~report.validated
    error('ARPES load did not return validated data: %s', inputPath);
end
% Perform only the requested operation here, using the class-specific
% metadata/conversion/export contract in momentum-and-export.md.
save(matPath, 'raw', 'report', '-v7.3');
assert(isfile(matPath), 'Batch output was not created.');
savedVariables = whos('-file', matPath);
assert(all(ismember({'raw', 'report'}, {savedVariables.name})), ...
    'Expected saved variables are missing.');
fprintf('Saved %s\n', matPath);
```

This loading example assumes an ARPES object supported by `load_arpes`; `.mat`
inputs return structures and require a different inspection contract. Check the
actual loader signature for the OX_ARPES version in use.

Check the process exit status, warnings, and saved outputs. For requested
conversion/export, use [momentum-and-export.md](momentum-and-export.md), retain
the source, save the intended derived values, and verify the resulting artifact.
Do not silently narrow a full-volume conversion to a Fermi window. Report file
paths, source identity, effective calibration/slice parameters, and the fact
that results belong to a separate process.
