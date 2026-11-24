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
| Browser v5 | Desktop MATLAB; its native panel layout does not require GUI Layout Toolbox. External viewers/processors have their own dependencies. |
| Browser v32 and `PlotSlices` | Desktop MATLAB and GUI Layout Toolbox (`uiextras`). |
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
addpath(fullfile(oxRoot, 'GUI', 'FDD'));
which loader_UI -all
which FDD_fit_app -all
which PlotSlices -all
```

`oxRoot` is a session-specific input, not a literal placeholder to execute.
For tool availability, inspect `which`, installed help, and the actual API
before installing or changing dependencies.

## Verify the live session

Default to the identified, data-owning MATLAB for all agents and subagents.
Start MATLAB independently of MCP when a new live session must outlast one
agent; run `shareMATLABSession()` in it. Configure the parent MATLAB MCP server
with `--matlab-session-mode=existing` so a failed attachment does not launch an
empty workspace. Subagents inherit that configuration. A fresh connection
selects the most recently shared MATLAB, so have each agent verify its actual
PID against one recorded independently from the intended MATLAB, then check
expected base-workspace names, classes/shapes, dataset metadata, and figure
ownership before processing. A PID is an identity check, not a connection
credential or per-call selector. See the
[session-sharing guide](../doc/MATLAB_AI_session_sharing_review.md) and
[tested handoff log](../doc/codex_matlab_workflow_log.md).

If the target is wrong or empty, stop live mutations. Reconnect to the intended
session, or have the agent that owns it execute a reviewed self-contained
function and return verifiable outputs. Do not accept a newly started MATLAB as
a substitute for loaded workspace data. Check parent and child connections
independently when using authorized subagents; serialize shared GUI/workspace
changes even when several connections reach the same MATLAB. If an agent must
hand off its workspace, close its own MCP client before ending the agent turn,
verify that client/server exited, and keep the independently started MATLAB
running. The next agent makes a fresh `existing`-mode connection and repeats
the PID/data check. An MCP server closes MATLAB that it launched in `new` mode
or via `auto` fallback when that server stops. The inherited Codex MATLAB tool
has no inspected per-call disconnect action, and ending a subagent turn has not
been shown to close its MCP server. Use an agent-owned standalone MCP client
when explicit disconnect is required; report the limitation if unavailable.
Never call MATLAB `exit` as a client disconnect.

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
