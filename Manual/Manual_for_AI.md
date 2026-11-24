# AI manual for yulinARPES

This is the technical entry point for agents operating or maintaining the
package. Start from the user's task, read applicable host/project instructions,
then use the [skills map](../AI_skills/SKILLS_MAP.md) to select the relevant
`SKILL.md` and only its needed references. The map explains instruction
categories, precedence, and local versus host-catalog discovery.

**Primary browser:** [`ARPES_data_browser_v5.m`](../ARPES_data_browser_v5.m).
**Legacy browser:** [`data_browser_demo_v32.m`](../data_browser_demo_v32.m),
retained for explicit compatibility requests and comparisons.

The [interactive manual](Manual.md) provides background and GUI workflows;
some historical screenshots/menu labels describe the legacy browser. The
[documentation index](../doc/README.md) separates operating guides from dated
review/evaluation records. Examples use synthetic names; discover actual paths,
dataset names, and MATLAB ownership for the current task.

Contents: [Quick start](#quick-start) ·
[AI workflow entry points](#ai-workflow-entry-points) ·
[Fermi-edge fitting](#fermi-edge-fitting-ox_arpes-fdd) ·
[MDC/EDC peak fitting](#mdcedc-peak-fitting-peakfit) ·
[NXmpes export and import](#nxmpes-export-and-import) ·
[Default MATLAB session workflow](#default-matlab-session-workflow) ·
[Repository map](#repository-map) ·
[Validation](#validation) ·
[Active and archived dependencies](#active-and-archived-dependencies)

## Quick start

In the verified, intended MATLAB, make the checkout root the current folder,
then run:

```matlab
setup_yulinARPES;
ARPES_data_browser_v5;
```

The setup function adds maintained code and active support folders, excluding
`archive`. Avoid recursively adding the entire checkout. For automation in an
existing session, locate the root from the selected project or
`fileparts(which('setup_yulinARPES'))`; preserve the session's working directory.

The user manual describes MATLAB R2022a–R2024a. Browser v5 uses built-in MATLAB
layout components and does not require GUI Layout Toolbox. Legacy v32 and
`PlotSlices` still require GUI Layout Toolbox 2.3.5 (`uiextras`, shipped under
`Manual/`). Measured-data classes, the new loader, and OX viewers also require
the matching separate OX_ARPES checkout; `setup_yulinARPES` does not add that
dependency. See the
[dependency guide](../AI_skills/MATLAB_SETUP.md#dependencies-by-workflow) and
[manual](Manual.md) for the selected workflow. Historical execution evidence
was primarily collected in R2024a. PeakFit and the OX_ARPES Fermi-edge fitter
were tested on R2023a; browser v5 includes R2025a compatibility patches
(runtime acceptance of those patches is recorded as outstanding in the
[browser record](../doc/ARPES_data_browser_v5_log.md)). Check the installed
version.

Browser v5 is the primary entry point. Its public facade can also return state:

```matlab
browserFigure = ARPES_data_browser_v5;
state = ARPES_data_browser_v5('read');
```

V5 offers a scriptable selection/grouping facade (`'read'`, `'refresh'`,
`'select'`, `'group'`, `'renamegroup'`, `'membership'`, `'typefilter'`).
`data_browser_demo_v32.m` is the legacy browser, retained for explicit
compatibility requests and regression comparisons. Both browsers dispatch to
scientific tools with their own input and dependency contracts; neither
supplies a uniform API for every algorithm.

Browsers and tools accept OX_ARPES classes (`OxA_CUT` and related cut, map,
and kz types) and legacy structs with a numeric `value` array plus matching
`x`/`y`/`z` coordinate vectors and an `info` metadata field when present.
PeakFit accepts 2-D cuts only; extract a slice from a map first. Preserve
source measurements and write results to new variable names unless replacement
is explicitly requested. New GUIs should use base MATLAB only (no GUI Layout
Toolbox or other paid toolboxes), following browser v5, PeakFit, and FDD.

## AI workflow entry points

| Task | Read first | Main interface |
|---|---|---|
| Load/view measured data, convert supported objects, export images | [arpes-browse](../AI_skills/arpes-browse/SKILL.md) | OX loader/object methods, `PlotSlices`, v5 workflow |
| Inspect/filter/select workspace variables and manage groups in v5 | [arpes-data-browser](../AI_skills/arpes-data-browser/SKILL.md) | `ARPES_data_browser_v5` |
| Manage simulated photon-energy cut curves | [arpes-kz-plot](../AI_skills/arpes-kz-plot/SKILL.md) | `kz_plot_agent` |
| Crystal/BZ geometry and simulated ARPES coverage | [arpes-plot-bz](../AI_skills/arpes-plot-bz/SKILL.md) | `plotbz_agent` / `plotBZ_V1` |
| Review/improve GUI, code, scientific contracts, or agent APIs | [improve-scientific-guis](../AI_skills/improve-scientific-guis/SKILL.md) | Maintenance workflow and evidence templates |
| Fit MDC/EDC peaks in a 2-D cut and track a dispersion | [arpes-peak-fit](../AI_skills/arpes-peak-fit/SKILL.md) | `PeakFit_app`, `pkf_fit_profile` / `pkf_track` / `pkf_export` in `Fitting/PeakFit` |
| Fit a Fermi edge (E_F, resolution, T) or shift/Fermi-Dirac-correct a cut or map | OX_ARPES `AI_skills/ox-arpes-fdd-fit/SKILL.md` (dependency skill) | `FDD_fit_app`, `fdd_extract_edc` / `fdd_fit_edc` / `fdd_correct_data` in OX_ARPES `GUI/FDD` |

Repository skills are files to read, not automatically installed host skills.
The [skills map](../AI_skills/SKILLS_MAP.md) explains discovery, relevant references,
helper paths, and routing for operations without a dedicated skill.

Before live execution, follow the [default session workflow](#default-matlab-session-workflow)
and verify the target figures. Coordinate shared mutations, preserve raw
measurements, and use distinct output names unless replacement is requested.
Check actual classes, axis units, calibration, and dimensions; a successful
GUI callback alone does not validate a scientific result.

### Fermi-edge fitting (OX_ARPES FDD)

`FDD_fit_app` is the maintained Fermi-edge fitter. It lives in the separate
OX_ARPES checkout under `GUI/FDD` (with its `fdd_*` backend), not in this
repository, and needs base MATLAB only (no Curve Fitting, Optimization or Image
Processing Toolbox). Open it from **Analyze → Fit spectra → Fit Fermi-level
(new)** in browser v5 or **Tools → Fit Fermi-level (new)** in legacy v32. In
both browsers the new entry sits directly below the original **Fit Fermi
level** (`FitFermiSurface`) item, which is unchanged; **Fit Peaks (MDC/EDC)**
is listed above the Fermi entries. From code, add OX_ARPES `GUI/FDD` to the
path and call `app = FDD_fit_app` or the scriptable functions:

```matlab
[E, I] = fdd_extract_edc(goldCut, 'XRange', [-10 10]);
R = fdd_fit_edc(E, I, 'Model', 'rcfd_lin_bg_T', 'Temperature', T_K);
shifted = fdd_correct_data(goldCut, R.params);          % new object, source unchanged
```

The app opens empty and lists base-workspace cuts and maps. Selecting one copies
a finite, positive `data.info.temperature` (K) into the Temperature start value,
which the default model holds fixed; a lamp shows Idle, Fitting…, Done or Failed,
also returned by `getState().fitStatus`. Fitting T and resolution together is
flagged as degenerate; prefer the measured temperature. Outputs are new
base-workspace variables. Read OX_ARPES `AI_skills/ox-arpes-fdd-fit/SKILL.md`
before agent use; `doc/FDD_user_guide.md`, `doc/FDD_review.md` and
`doc/FDD_improvement_log.md` there hold the interface, the review of the original
`FDD_new` program and dated validation (synthetic edges, R2023a). Menu wiring is
recorded in the [browser record](../doc/ARPES_data_browser_v5_log.md).

### MDC/EDC peak fitting (PeakFit)

`PeakFit_app` (`Fitting/PeakFit`) fits Lorentzian, Gaussian or pseudo-Voigt
peaks on a linear (or flat) background in MDCs or EDCs of a 2-D cut, with an
optional held Fermi-Dirac cutoff for EDCs, slice-by-slice tracking and ±1σ
uncertainties. It replaces **Fit MDC** as **Fit Peaks (MDC/EDC)** in browser
v5 (**Analyze → Fit spectra**) and legacy v32 (**Tools**); the old
`fit_MDC_demo` folder is kept unchanged. Results go to a new variable
`<source>_peaks`. Read [arpes-peak-fit](../AI_skills/arpes-peak-fit/SKILL.md)
before agent use; see the [user guide](../doc/PeakFit_user_guide.md) and
[improvement log](../doc/PeakFit_improvement_log.md). From code:

```matlab
D = pkf_input(cut, 'cut');
[u, I] = pkf_extract_profile(D, 'MDC', E0, dE);
R = pkf_fit_profile(u, I, struct('centre', {c1, c2}), ...
    'Shape', 'Lorentzian', 'Window', [a b]);
T = pkf_track(D, R.peaks, 'Direction', 'MDC', ...
    'Start', E0, 'Range', [E1 E2], 'Window', [a b]);
S = pkf_export(T, D);          % new struct; assign to <source>_peaks, source unchanged
```

### NXmpes export and import

**Load → Export NXmpes...** in browser v5, or **Loader → Export NXmpes...** in
legacy v32, opens OX_ARPES `export_nxmpes_UI` from the OX_ARPES `GUI` folder
(which must be on the MATLAB path). There is no separate browser Import menu:
NXmpes files are read through the OX_ARPES loader (`loader_UI`, or
`load_nxmpes` / `load_arpes` from code).

## Default MATLAB session workflow

Use **one identified, shared MATLAB workspace** for live work. Agents and
subagents must not each let their MATLAB MCP server start a new session: those
sessions have separate base workspaces and figures. In particular, a PID in a
prompt identifies the target but does not make an MCP tool attach to it.

1. **Select the data-owning MATLAB first.** If the user already has the data
   loaded, use that MATLAB. Have its owner run `shareMATLABSession()` there and
   record `feature('getpid')` plus expected workspace variable names. Obtain
   this identity independently of the MCP connection being checked. Keep the
   MATLAB open while agents use its workspace.
2. **Connect through the MATLAB MCP server in `existing` mode.** Configure the
   host entry with `--matlab-session-mode=existing`; Codex subagents inherit the
   parent's MCP configuration. This mode fails when no shared MATLAB is
   available instead of silently starting an empty one. A fresh connection
   discovers the MATLAB that most recently ran `shareMATLABSession()`.
3. **Guard every agent connection before work.** Each agent or subagent must
   compare its tool's `feature('getpid')` with the independently recorded PID
   and check the expected base-workspace variables, classes, dimensions, and
   relevant metadata. Keep that guard in the same tool call as a mutation when
   practical. Stop if the PID or data differ; re-share the intended MATLAB and
   establish a fresh MCP connection. Never load, plot, or edit in a newly
   reached empty MATLAB just because the tool call succeeded.
4. **Share work through that workspace.** Subagents can read data left in the
   same running MATLAB. Serialize changes to its base workspace and figures;
   do not assume subagent workspaces are isolated.
5. **Disconnect before ending an agent phase.** Each agent or subagent should
   close its own MCP client connection before it finishes, then verify that the
   intended MATLAB PID is still running. Leave the MATLAB workspace and its
   figures open for the next agent, which must make a fresh connection and
   repeat the PID/data guard. Disconnecting is handoff discipline, not an
   exclusive lock: other MCP clients can attach to a shared MATLAB.

The inherited Codex MATLAB tool has no per-call disconnect action in the
inspected interface, and ending a subagent turn has not been shown to close its
MCP server. For a handoff requiring **verified disconnection**, use an
agent-owned standalone `existing`-mode MCP client, close its transport before
the agent ends, and check that its server exited while MATLAB stayed alive.
Do not use MATLAB `exit` to disconnect an agent, or disable a shared host MCP
server that another agent is using. Report the disconnect as unverified if the
client cannot be closed explicitly.

If an agent must create a MATLAB for a task whose workspace will be handed to
another agent, start MATLAB as an **independent OS process**, load the data,
run `shareMATLABSession()`, and keep MATLAB running. An interactive `-r` startup
script can do this; `-batch` exits when its script completes. Connect agent A
with `existing` mode, then disconnect A's MCP client before A finishes. Agent B
starts a fresh `existing`-mode connection and verifies the same PID and data
before continuing. Do not use MCP `new` mode or `auto` launch fallback for a workspace
that must survive its MCP server: the server closes MATLAB processes it
launched when it stops. `matlab.engine.shareEngine` and Engine `disconnect()`
are separate from MCP session sharing.

If the target is missing, investigate or ask for the data/session location
before doing live work. A batch MATLAB has its own workspace and requires
explicit file input and saved output; use it only when the task permits that
workflow. See [shared setup](../AI_skills/MATLAB_SETUP.md#verify-the-live-session),
the [session-sharing guide](../doc/MATLAB_AI_session_sharing_review.md), and
the [tested Codex handoff log](../doc/codex_matlab_workflow_log.md) for details
and limitations.

## Repository map

| Folder | Contents and scope |
|---|---|
| `Data_enhance` | Symmetrisation, interpolation, curvature, and related enhancement tools. |
| `Data_process` | Data combination, grid repair, and processing tools. |
| `Fitting` | Peak, dispersion, and Fermi-edge fitting tools (`PeakFit/` holds the maintained MDC/EDC peak fitter `PeakFit_app`; `FitFermiSurface` is the original Fermi-level window; the maintained fitter is OX_ARPES `FDD_fit_app`). |
| `Loader_kconvert` | Format readers and momentum-conversion tools. |
| `Visualization` | `PlotSlices`, plotting, viewers, figure export, `kz_plot`, and `plotBZ_V1`. |
| `Others_uncertain` | Older or less-classified utilities; inspect callers/contracts before use. |
| `third_party` | Active third-party libraries with their own licenses. |
| `archive` | Superseded copies retained for reference; excluded from setup. |
| `Manual` | Interactive user guide and supporting material. |
| `tests` | Project-owned unit tests (including PeakFit and PlotSlices), the v5/v32 comparison function, and the v5 layout check that runs without GUI Layout Toolbox. |
| `AI_skills` | Skill map, shared setup, operation/maintenance skills, helpers, and dated skill history. |
| `doc` | Navigation, session guide, dated reviews/logs, and illustrative screenshots. |

## Validation

Run only checks appropriate to the change. The project-owned MATLAB unit files
can be run individually from a configured checkout:

```matlab
yulinRoot = fileparts(which('setup_yulinARPES'));
unitFiles = {'test_stable_entry_points.m', 'test_plotBZ_V1.m', ...
    'test_plotBZ_V1_simulation.m', 'test_plotBZ_V1_integration.m', ...
    'test_plotbz_agent.m', 'test_PeakFit_core.m'};
for k = 1:numel(unitFiles)
    results = runtests(fullfile(yulinRoot, 'tests', unitFiles{k}));
    assertSuccess(results);
end
```

These cover input parsing/rearrangement, BZ geometry, simulations, GUI
integration, the Plot BZ agent facade, and the PeakFit backend (base MATLAB
only; `OxA_CUT` checks in `test_PeakFit_core` are skipped if OX_ARPES is off
the path). Some create or close GUI singletons; use a dedicated verification
session when preserving an active user's panel configuration matters.

`test_PeakFit_gui.m` is a `matlab.unittest` suite for the PeakFit window and
browser menus. The browser-menu case also opens `data_browser_demo_v32`, so
that case needs GUI Layout Toolbox:

```matlab
results = runtests(fullfile(yulinRoot, 'tests', 'test_PeakFit_gui.m'));
assertSuccess(results);
```

`test_PlotSlices_position_slider.m` needs GUI Layout Toolbox and
`drawcrosshair`. Run it when changing PlotSlices slider or position
behaviour.

The browser v5 comparison is an assertion-based function, not a
`matlab.unittest` suite. It also opens `data_browser_demo_v32`, so it needs
OX_ARPES classes, GUI Layout Toolbox, and the classic desktop JVM:

```matlab
addpath(fullfile(yulinRoot, 'tests'));
report = test_ARPES_data_browser_v5;
assert(report.passed);
```

To exercise v5 without GUI Layout Toolbox, run the separate assertion-based
layout check, which removes `uiextras`/`uix` from the path for that session.
Close any open browser v5 window first:

```matlab
addpath(fullfile(yulinRoot, 'tests'));
report = test_ARPES_data_browser_v5_layout;
assert(report.passed);
```

Review the [browser record](../doc/ARPES_data_browser_v5_log.md) for fixture,
state-restoration, and physical-input limits. These checks do not replace
representative measurement comparisons or validate every external menu action.

## Active and archived dependencies

- `third_party/export_fig` supports the subplot figure-export tool.
- `third_party/matGeom` supports Plot BZ geometry and the optional BXSF utility.
  Plot BZ uses local Cartesian rotations and does not require Phased Array
  System Toolbox or a separate BZ plotting checkout.
- `archive/third_party/export_fig_2013` and
  `archive/legacy/+LoadDataARPES_old` are superseded copies excluded from setup.
  The active loader package is under `Loader_kconvert`.
