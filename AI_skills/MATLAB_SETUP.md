# MATLAB setup and session guidance

Use this shared reference from the [skills map](SKILLS_MAP.md). It establishes
paths and runtime ownership; individual skills define their scientific actions.

## Resolve paths from the checkout

If `setup_yulinARPES` already resolves in the intended MATLAB session:

```matlab
yulinRoot = fileparts(which('setup_yulinARPES'));
assert(~isempty(yulinRoot), 'Locate the yulinARPES checkout first.');
setup_yulinARPES;
```

For initial interactive setup, make the checkout root the current folder and
run `setup_yulinARPES`. For automation, obtain the absolute checkout path from
the selected project or user-provided location, add that root, then call setup.
Do not change a live session's working directory simply to copy an example.
Use `fullfile` for paths; do not assume a drive letter, account name, sibling
repository, or globally installed skill location.

The setup function adds the maintained source and active support directories.
It excludes `archive` and does not add `AI_skills/*/scripts`; an operation skill
adds its helper explicitly. Check `which <entry-point> -all` when multiple
checkouts may be present, and confirm that the intended implementation resolves.
Avoid `addpath(genpath(yulinRoot))`, which can expose archived/duplicate code.

## Dependencies by workflow

| Workflow | Dependencies |
|---|---|
| Browser v32, browser v5, and `PlotSlices` | Desktop MATLAB and GUI Layout Toolbox (`uiextras`); external viewers/processors have additional dependencies. |
| Scripted measured-data loading, class methods, and new viewers | The matching OX_ARPES checkout; add `DataType`, `DataLoader`, `DataAnalysis`, and `GUI` as needed. Confirm the expected loader signature against that version. |
| `kz_plot` simulations | yulinARPES `Visualization`; no measured data or OX_ARPES classes required. |
| `plotBZ_V1` geometry and simulations | Its package folder and bundled `third_party/matGeom/matGeom`, both added by setup. No separate BZ plotting checkout is required. |
| Browser v5 native double-click handling | The classic desktop JVM and bundled `findjobj_2013` compatibility helper. This is a legacy UI boundary; Enter/context plotting are alternative interactions. |

The user manual describes MATLAB R2022a–R2024a; the retained runtime evidence
was primarily recorded in R2024a. Check the installed release and required
toolboxes for the chosen operation rather than assuming every menu is covered
by the browser's startup dependencies.

To add a separately located OX_ARPES checkout, set `oxRoot` to its discovered
absolute root, then use:

```matlab
assert(isfolder(fullfile(oxRoot, 'DataType')), 'Check the OX_ARPES root.');
addpath(fullfile(oxRoot, 'DataType'));
addpath(genpath(fullfile(oxRoot, 'DataLoader')));
addpath(genpath(fullfile(oxRoot, 'DataAnalysis')));
addpath(fullfile(oxRoot, 'GUI'));
which loader_UI -all
which PlotSlices -all
```

`oxRoot` is a session-specific input, not a literal placeholder to execute.
For tool availability, inspect `which`, installed help, and the actual API
before installing or changing dependencies.

## Verify the live session

An MCP connection can attach to a different MATLAB from the one holding the
data. Before processing or editing figures, establish the intended session and
verify expected workspace names, classes/shapes, dataset metadata, and figure
ownership. A PID is a useful diagnostic, not a connection credential. See the
[session-sharing guide](../doc/MATLAB_AI_session_sharing_review.md) for the
documented sharing procedure and version-specific pinning option.

If the target is wrong or empty, stop live mutations. Reconnect to the intended
session, or have the agent that owns it execute a reviewed self-contained
function and return verifiable outputs. Check parent and child connections
independently when using authorized subagents; serialize shared GUI/workspace
changes even when several connections reach the same MATLAB.

Never run `restoredefaultpath` through a live MCP session: removing its helper
paths can break the connection. Close only figures created for the current
task, using retained handles. Avoid `clear all`, `close all`, and unrelated
changes to root graphics defaults.

## Live versus batch

Use the live desktop session for existing workspace values and figures. A
separate batch process must reload inputs and save its results; it cannot modify
that desktop workspace or retain interactive windows after it exits.

Use the [batch reference](arpes-browse/references/matlab-batch-fallback.md) only
when the task can be fulfilled through independent file inputs and saved
outputs. A live-session failure is not permission to silently replace an
interactive task with a batch run. Batch does not fix invalid data, missing
calibration, or a numerical error.

Report the selected input/output names, effective parameters, actual checks,
and any unperformed validation. Evidence from an old session does not establish
the current session's state.
