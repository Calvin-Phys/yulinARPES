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

## Quick start

In MATLAB, make the checkout root the current folder, then run:

```matlab
setup_yulinARPES;
ARPES_data_browser_v5;
```

The setup function adds maintained code and active support folders, excluding
`archive`. Avoid recursively adding the entire checkout. For automation in an
existing session, locate the root from the selected project or
`fileparts(which('setup_yulinARPES'))`; preserve the session's working directory.

The manual describes MATLAB R2022a–R2024a and GUI Layout Toolbox 2.3.5. Browsers
and `PlotSlices` need GUI Layout Toolbox (`uiextras`). Measured-data classes,
the new loader, and OX viewers also require the matching separate OX_ARPES
checkout; setup does not install that dependency. See the
[dependency guide](../AI_skills/MATLAB_SETUP.md#dependencies-by-workflow) and
[manual](Manual.md) for the selected workflow. Historical execution
evidence was primarily collected in R2024a; check the installed version.

Browser v5 is the primary entry point. Its public facade can also return state:

```matlab
browserFigure = ARPES_data_browser_v5;
state = ARPES_data_browser_v5('read');
```

V5 offers a scriptable selection/grouping facade. `data_browser_demo_v32.m`
is the legacy browser, retained for explicit compatibility requests and regression
comparisons. Both browsers dispatch to scientific tools with their own input and
dependency contracts; neither supplies a uniform API for every algorithm.

## AI workflow entry points

| Task | Read first | Main interface |
|---|---|---|
| Load/view measured data, convert supported objects, export images | [arpes-browse](../AI_skills/arpes-browse/SKILL.md) | OX loader/object methods, `PlotSlices`, v5 workflow |
| Inspect/filter/select workspace variables and manage groups in v5 | [arpes-data-browser](../AI_skills/arpes-data-browser/SKILL.md) | `ARPES_data_browser_v5` |
| Manage simulated photon-energy cut curves | [arpes-kz-plot](../AI_skills/arpes-kz-plot/SKILL.md) | `kz_plot_agent` |
| Crystal/BZ geometry and simulated ARPES coverage | [arpes-plot-bz](../AI_skills/arpes-plot-bz/SKILL.md) | `plotbz_agent` / `plotBZ_V1` |
| Review/improve GUI, code, scientific contracts, or agent APIs | [improve-scientific-guis](../AI_skills/improve-scientific-guis/SKILL.md) | Maintenance workflow and evidence templates |

Repository skills are files to read, not automatically installed host skills.
The [skills map](../AI_skills/SKILLS_MAP.md) explains discovery, relevant references,
helper paths, and routing for operations without a dedicated skill.

Before live execution, verify the intended MATLAB workspace and target figures.
An agent or subagent may connect to another MATLAB process; passing its PID in a
prompt does not reconnect the tool. Use the [session-sharing guide](../doc/MATLAB_AI_session_sharing_review.md)
when attachment is uncertain. A batch process has separate state. Coordinate
shared mutations, preserve raw measurements, and use distinct output names
unless replacement is requested. Check actual classes, axis units, calibration,
and dimensions; a successful GUI callback alone does not validate a scientific result.

## Repository map

| Folder | Contents and scope |
|---|---|
| `Data_enhance` | Symmetrisation, interpolation, curvature, and related enhancement tools. |
| `Data_process` | Data combination, grid repair, and processing tools. |
| `Fitting` | Peak, dispersion, and Fermi-edge fitting tools. |
| `Loader_kconvert` | Format readers and momentum-conversion tools. |
| `Visualization` | `PlotSlices`, plotting, viewers, figure export, `kz_plot`, and `plotBZ_V1`. |
| `Others_uncertain` | Older or less-classified utilities; inspect callers/contracts before use. |
| `third_party` | Active third-party libraries with their own licenses. |
| `archive` | Superseded copies retained for reference; excluded from setup. |
| `Manual` | Interactive user guide and supporting material. |
| `tests` | Project-owned unit tests and the separate browser comparison function. |
| `AI_skills` | Skill map, shared setup, operation/maintenance skills, helpers, and dated skill history. |
| `doc` | Navigation, session guide, dated reviews/logs, and illustrative screenshots. |

## Validation

Run only checks appropriate to the change. The project-owned MATLAB unit files
can be run individually from a configured checkout:

```matlab
yulinRoot = fileparts(which('setup_yulinARPES'));
unitFiles = {'test_stable_entry_points.m', 'test_plotBZ_V1.m', ...
    'test_plotBZ_V1_simulation.m', 'test_plotBZ_V1_integration.m', ...
    'test_plotbz_agent.m'};
for k = 1:numel(unitFiles)
    results = runtests(fullfile(yulinRoot, 'tests', unitFiles{k}));
    assertSuccess(results);
end
```

These cover input parsing/rearrangement, BZ geometry, simulations, GUI
integration, and the Plot BZ agent facade. Some create or close GUI singletons;
use a dedicated verification session when preserving an active user's panel
configuration matters.

The browser v5 comparison is an assertion-based function, not a
`matlab.unittest` suite. With OX_ARPES classes, GUI Layout Toolbox, and the
classic desktop JVM available, run it separately:

```matlab
addpath(fullfile(yulinRoot, 'tests'));
report = test_ARPES_data_browser_v5;
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
