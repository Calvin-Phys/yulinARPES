# Historical skill development and validation

> Historical evidence from November 2026, not a live workspace inventory or
> operating policy. For task routing, use the [skills map](SKILLS_MAP.md); for
> setup, use [MATLAB_SETUP.md](MATLAB_SETUP.md). Earlier outcomes, validator
> limitations, and intermediate designs remain dated evidence. They were not
> rerun by the later documentation cleanup.

This document summarizes the MATLAB browser, loading, viewing, momentum-conversion, image-export, and simulated photon-energy overlay workflows developed during the dated sessions below. Labels such as `sample_cut` and `sample_map` are **synthetic examples**, not the filenames or workspace names of the measured scans. The loader classes, array sizes, and data-workflow outcomes below came from real Diamond Light Source data; the kz_plot workflow uses calculated curves without measured inputs.

## Workflow recorded during development

1. **Start the browser.** The entry point is `data_browser_demo_v32`; the initially requested shorter name does not exist. `setup_yulinARPES` adds the yulinARPES code folders. The browser is a singleton: another call raises the existing Data Browser window. OX_ARPES `DataType`, `DataLoader`, `DataAnalysis`, and `GUI` must also be on the MATLAB path for the full workflow.
2. **Load files.** The OX_ARPES `loader_UI(paths,'AssignToBase',true)` route calls `load_arpes`, validates supported ARPES objects, and creates filename-derived variables in the MATLAB base workspace. The tested NeXus scans selected `load_DLS_io5_HR`. Check each report, class, dimensions, and base-workspace name. Script-mode `loader_UI` does not assign to the base workspace unless `AssignToBase=true` is supplied; assigning may replace a same-named variable.
3. **Display data.** `PlotSlices` is the default. Use direction `x` for a 2D `OxA_CUT` and `z` for a 3D `OxA_MAP` or `OxA_KZ`, unless the user requests another direction. The browser's **Data Viewer (new)** action dispatches 2D, 3D, and 4D arrays to the matching OX_ARPES mlapp viewer. Use it only when the instruction directly requests the new viewer.
4. **Convert to momentum space.** For `OxA_CUT`, `OxA_MAP`, and `OxA_KZ`, inspect physical metadata, apply the requested angular offsets to a value-class copy, call `kconvert()`, validate the result, and assign it a distinct base-workspace name such as `sample_map_ksp`. The raw object remains available. Convert the **full 3D volume by default**, including when a later step exports one image. Reduce to a Fermi-energy window only when asked specifically to convert only the Fermi surface.
5. **Export an image when requested.** Use the 2D object directly or call `get_slice` on a 3D object, then use its `show()` axes with `exportgraphics(...,'Resolution',300)`. Verify the PNG path and report the slice and calibration used. This produces a clean data image rather than a capture of the PlotSlices controls.
6. **Choose MATLAB execution.** Use the MATLAB MCP tool and a live desktop session first. If that route cannot complete because of a tool or session failure, use a separate `matlab -batch` process only for compatible file-based work. Batch work must reload inputs and save persistent results to disk; it cannot populate the already-open desktop base workspace or leave interactive windows open after exit.

## Representative tests

The first interactive run loaded four scans, then reopened them in a persistent subagent run. Each load returned `validated=1`; each requested PlotSlices figure was valid. The table uses synthetic role labels:

| Synthetic label | Class | `value` size | Default PlotSlices direction |
| --- | --- | --- | --- |
| `sample_map_a` | `OxA_MAP` | `[77 835 1034]` | `z` |
| `sample_kz` | `OxA_KZ` | `[71 835 1135]` | `z` |
| `sample_map_b` | `OxA_MAP` | `[63 835 1034]` | `z` |
| `sample_cut_a` | `OxA_CUT` | `[835 1034]` | `x` |

An independent agent evaluation first used temporary names to preserve existing workspace variables. It confirmed the loading and plots, then cleaned up its own objects. Its initial figure cleanup also closed the browser; the browser was reopened, and the skill now instructs agents to close only their own PlotSlices figure handles. A later four-scan run retained all four data objects and plot windows.

A separate two-scan agent evaluation checked both display methods. A 2D cut opened in PlotSlices and the 2D mlapp viewer; a 3D map opened in PlotSlices and the 3D mlapp viewer. Both loads were validated without warnings. All four new windows and the Data Browser were confirmed open at the end of that test.

The same 2D cut and 3D map roles were used for an independent momentum-conversion evaluation. Both loaded objects had finite photon-energy and work-function metadata. Zero angle and azimuth offsets were applied to copies, then `kconvert()` processed the **complete** arrays. The converted cut remained `[835 1034]` with `k_y` and `E-E_F` axes; the converted map remained `[63 835 1034]` with `k_x`, `k_y`, and `E-E_F` axes. Both converted objects passed `validate()`, were assigned under distinct `_ksp` names, and opened in PlotSlices (`x` for the cut, `z` for the map). The two raw objects were unchanged. All four objects and four plot windows were confirmed in the subagent's live MATLAB session.

Temporary export checks produced a 300 dpi PNG from a converted 2D cut and another from a converted map's Fermi slice. The map export check used a 13-plane window to exercise the **explicit Fermi-surface-only branch**; it does not define the default conversion scope. The temporary images were verified and removed. No image was requested or saved during the persistent momentum-viewing test.

The 4D mlapp route resolves on the MATLAB path, but no 4D data was tested. `OxA_KZ` momentum conversion and the batch fallback were documented from the source and were not exercised in this session. The local MATLAB executable was confirmed available for a future batch run.

## Simulated cut overlays with kz_plot

On 16 November 2026, a second skill, `arpes-kz-plot`, was added for requests
expressed as figure numbers, photon energies, and curve edits. It uses the same
live MATLAB execution preference as the browser skill. A separate process cannot
edit or retain graphics in the user's desktop session. The browser skill now
routes simulated-cut requests to this skill rather than loading or converting
measured data.

Its `kz_plot_agent` helper calls the existing GUIDE panel callbacks instead of
implementing a second plotting application. Add operations explicitly reset
defaults to work function 4.5 eV, inner potential 15 eV, theta -15:1:15 degrees,
green, and width 1.5 pt. Updates load the matched curve and retain unspecified
parameters. Inventory exposes actual line and label handles. Updates/deletions
use figure number plus old photon energy and reject missing or ambiguous
matches; an explicitly selected handle disambiguates duplicates. The figure's
unrelated graphics remain available.

An independent validation pass used the written skill in MATLAB R2024a. The
user's exact examples passed: figure 10 received an 80 eV default curve and a
blue 95 eV curve; update changed 80 to 85 eV while retaining the original line
and label handles, and delete removed the 95 eV line and label. The equations,
31-point default sampling, labels, and actual blue RGB values were checked.
Additional requests exercised angle/style edits, moving a curve between figures,
fractional photon energies, and preserving unrelated lines, view limits, and
NextPlot state. Further checks passed for read-only inventory, resetting add
defaults after a styled curve, refusing ambiguous energy-only updates/deletions
without UI mutation, color-qualified handle selection, invalid-step rejection,
and descending theta sampling with a shorter final interval. Test fixtures were
removed using their retained handles. Figure 10 was left with one green 85 eV
curve using default parameters, with the panel open. MATLAB Code Analyzer
reported zero issues in the helper. Detailed outcomes and test boundaries are recorded in
[`validation-results.md`](arpes-kz-plot/references/validation-results.md).

The independent evaluator used its own live MATLAB session. The exact
80/95 eV add and 85 eV update/delete sequence was therefore also run and checked
in the primary desktop session. Its figure 10 now contains the same requested
single green 85 eV default curve; the original Data Browser and kz_plot windows
remain open there.

The bundled skill validator was attempted but could not import PyYAML in the
available Python runtimes; installing that dependency was unavailable. Independent
structural checks passed for frontmatter fields, skill naming, description
length, placeholder absence, balanced code fences, and local reference paths.

## Skill project

- [`arpes-browse/SKILL.md`](arpes-browse/SKILL.md): entry point, live MATLAB setup, loading, viewer choice, and workflow routing.
- [`arpes-browse/references/momentum-and-export.md`](arpes-browse/references/momentum-and-export.md): metadata, full and Fermi-only conversion, and PNG export.
- [`arpes-browse/references/matlab-batch-fallback.md`](arpes-browse/references/matlab-batch-fallback.md): separate-process fallback and its persistence limits.
- [`arpes-kz-plot/SKILL.md`](arpes-kz-plot/SKILL.md): add, inspect, update, style, move, and delete simulated cut overlays in live MATLAB figures.
- [`arpes-kz-plot/scripts/kz_plot_agent.m`](arpes-kz-plot/scripts/kz_plot_agent.m): callback-based helper with explicit add defaults and unique figure/energy selection for updates and deletions.
- [`arpes-kz-plot/references/examples.md`](arpes-kz-plot/references/examples.md): natural-language requests, MATLAB actions, and outcome checks.
- [`arpes-kz-plot/references/validation-results.md`](arpes-kz-plot/references/validation-results.md): independent live-session validation and limitations.

The momentum and export procedure was adapted from the [OX_ARPES_AI_SKILLS repository](https://github.com/Calvin-Phys/OX_ARPES_AI_SKILLS). Its Bash helper starts a separate MATLAB process; this skill uses the live MCP session by default. The repository [README](../README.md) links to the skill.

## Suggested software improvements

1. Offer a supported setup command that adds both checkouts and checks the required loader and viewer paths.
2. Provide one scriptable load-and-view API that returns the workspace name, load report, object dimensions, and viewer handle; keep PlotSlices as its default.
3. Define an explicit policy for workspace-name collisions so repeat loads cannot silently replace edited data.
4. Add small 2D cut and 3D map fixtures for loader, conversion, viewer, and PNG-export integration checks without relying on large external measurements.
5. Provide a headless export API for batch use while retaining the interactive desktop workflow.

## Plot BZ skill development — 17 November 2026

The initial plan below is followed by the completed implementation and checks.

Requested `arpes-plot-bz` under `AI_skills`, patterned after `arpes-kz-plot`.
The intended workflow configures Bravais/crystal parameters and cleavage
orientation, draws 3D or 2D BZs, and overlays fixed-photon-energy or
photon-energy-scan measurement surfaces. Implementation is delegated to a
scoped skill agent while the primary agent integrates and validates the GUI.

The helper will operate in the existing MATLAB desktop session, preserve
unrelated figures and graphics, and use the same controls and callbacks as the
GUI. The numerical model and graphical coordinate conventions are being
shared with the GUI/simulation agents.

### Completed Plot BZ skill and validation

- [`arpes-plot-bz/SKILL.md`](arpes-plot-bz/SKILL.md) documents live-session setup,
  coordinate/energy conventions, managed overlays, and verification.
- [`arpes-plot-bz/scripts/plotbz_agent.m`](arpes-plot-bz/scripts/plotbz_agent.m)
  provides `defaults`, `configure`, `update`, `read`, `plot`, `simulate`, `list`,
  and `clear`. Configure resets explicit crystal defaults; update retains
  unspecified settings. Simulate resets explicit scan defaults each time.
  Unknown fields, contradictory lattice constraints, and invalid numeric fields
  are rejected before changing the user's panel or graphics.
- [`arpes-plot-bz/references/examples.md`](arpes-plot-bz/references/examples.md)
  contains the field contract, supported Bravais combinations, both scan modes,
  four target views, percent-offset conversion, and inventory/clear examples.
- Full repository suite: **22 passed, 0 failed, 0 incomplete**, without warnings
  in MATLAB R2024a. The helper and three new test files have zero Code Analyzer
  notices. All 18 package MATLAB files also have zero notices. Product analysis
  reports MATLAB only; bundled matGeom is required on the path.

An independent agent followed the skill in a separate live R2024a session:
hexagonal P a=b=3, c=5, gamma=120, conventional (001), zone indices b3=1..2.
The two zone centers were kz=1.256637061436 and 2.513274122872, and the primitive
surface reciprocal area was 5.065083340235, matching analytic values. It drew a
60 eV fixed-hv 31-by-31 scan and a 20:2:40 eV photon 11-by-31 scan in 3D, then
a fixed-hv XY projection at 30-degree slit azimuth. Momentum finiteness, photon
scan symmetry/normal energy, plotted projected vertices, and slit rotation were
checked. Simulation-only clearing invalidated all simulation handles while
preserving every BZ object and two separate measured lines. Only its owned
figures and new panel were closed, and its path was restored. No production
warnings or errors occurred.

The coordinating agent also inspected the rebuilt GUI and a four-view BZ/simulation example.
The implementation preserves the historical BZ section transforms, so section
coordinates are not universally raw Cartesian kx/ky; simulated sections use
exactly those transforms. Surface XY is a projection; horizontal and vertical
targets are plane intersections, which can be empty. Positive binding energy
is below EF, and the free-electron model omits intensity, photon momentum, and
band-dependent final states. No measured-data comparison was performed.

Official `quick_validate.py` could not import missing PyYAML, and a temporary
dependency download failed DNS resolution. Independent structural checks
passed for required frontmatter, skill/folder naming, description bounds,
placeholder absence, helper existence, and local reference links; runtime and
independent behavioral testing supplied additional validation.

Detailed implementation/review record and images:
[`../doc/plotBZ_V1_improvement_log.md`](../doc/plotBZ_V1_improvement_log.md).

### Plot BZ follow-up: colours, spinners, and vector output

The GUI now has bold hierarchical frame titles and increment/decrement controls
on every bulk/surface index bound, retaining the existing AI control tags.
Horizontal/vertical sections default blue/green; the agent helper uses the same
section defaults. Fixed-hv/photon scans default orange/purple. Explicit colour
options remain supported, and GUI mode switching retains separate custom colours.

`plotBZ_V1_vector_output(figureHandle, pdfPath)` exports explicit vector PDF;
output figures also have an Export vector PDF menu. Painters is selected for
MATLAB before R2025a; later releases use explicit export content type because the
legacy renderer property no longer affects output. The updated skill examples
include this path. A full BZ/surface PDF check found no raster image objects.

Singleton initialization now runs only once per live panel, fixing a discovered
centering reset when an agent raised an existing panel. A face-centred configure,
read, and plot regression covers this behavior. Full suite: **26 passed**, no
failures/incomplete tests or runtime warnings, under R2024a. New per-mode colour
and export helpers are included in the package's zero-notice static analysis.
Detailed results and the updated screenshots are in the existing improvement log.

## Reusable GUI-improvement experience skill — 17 November 2026

Created [`improve-scientific-guis/SKILL.md`](improve-scientific-guis/SKILL.md)
from the kz_plot and plotBZ_V1 development discussions, including the later
style, spinner, colour-state, singleton, and vector-output improvements.
It is a repository skill for future maintenance work, distinct from the
program-specific operation skills. It has not been installed globally.

The entry point covers workflow-oriented layout, coding/scientific contracts,
graphics ownership, deterministic AI APIs, static/numerical/behavioral/visual
validation, authorized delegation and shared-session coordination, and evidence
logs. The linked experience record explains actual failures and transferable
lessons; work templates support planning, scoped handoffs, independent reviews,
evidence matrices, and session summaries. Program-specific choices are examples,
not mandatory palettes/layouts/models for all future tools.

Validation for this documentation-only change: structural checks passed for
frontmatter, naming, description, scaffold absence, balanced code fences, and
local links. An independent read-only scenario review used a legacy spectral-fit
GUI request with unknown runtime and no delegation permission. It found no
blocking scope/routing issue and correctly treated runtime discovery, figure
preservation, and authorization as unresolved context to inspect. This was a
scenario review, not a MATLAB execution or a completed modernization task.
The official quick_validate.py was attempted but could not import missing
PyYAML; no dependency installation was attempted for this change. Existing
26-test runtime results in the experience record are historical evidence from
the preceding program implementation, not newly executed tests for this skill.

README discovery and a narrow ignore exception were added. Detailed provenance
remains in [`../doc/plotBZ_V1_improvement_log.md`](../doc/plotBZ_V1_improvement_log.md).


## ARPES data browser v5 — 17 November 2026

Created `arpes-data-browser/SKILL.md` (repository only) for the new independent `ARPES_data_browser_v5` entry point. The facade exposes open/read/refresh/select/group/renamegroup/membership, with name-based visible selection and four compatible INFO.GroupInfo flags. Read/raise preserve state; refresh is explicit. Group names persist in local preferences; membership edits selected base-workspace values. Add retains flags, move clears the active source only, same-group move retains membership, remove uses the active group.

MATLAB R2024a execution passed six assertion-based comparison groups against v32, including 43 menu dispatch targets, actual plotting/group/NaN callbacks, details/search and singleton state. Both new MATLAB files have zero analyzer notices. Actual default/compact screenshots were inspected. No independent agent evaluation or measured-data validation was performed. The skill was reviewed structurally (frontmatter, local evidence link, API examples matching production help); no official skill-validator execution is claimed. See `../doc/ARPES_data_browser_v5_log.md` for full evidence, corrections and limits.

Browser v5 compact-layout follow-up (17 November): default 680 x 460, minimum 640 x 450; tighter spacing/tables and separate group action rows. Load now starts with direct ARPES loader (new); Process groups six actions under Fine structure above the Processing toolbox separator. Six comparison groups plus new hierarchy assertions pass, both MATLAB files have zero analyzer notices, and regenerated normal/minimum screenshots were visually inspected. API semantics are unchanged.

Browser v5 native-tab follow-up (17 November): native GroupTabs replaces group buttons; VarList is reparented to the selected tab. Counts moved to the bottom, membership controls occupy one row, workspace/details width is 56/44. Metadata now shows only data.info fields. Public API semantics unchanged. Six comparison groups, native-tab parent/filter checks and info-only metadata assertions pass in R2024a; both changed MATLAB files have zero analyzer notices. Regenerated screenshots were visually inspected at both sizes.

Browser v5 equal-column follow-up (17 November): default width 600 with two measured 300-pixel columns, height 460, minimum 600 x 450; counts now one line, initial double-click hint removed, coordinate Min/Max formatted to two decimals without changing stored values. Six check groups including new geometry/format assertions pass; both MATLAB files have zero analyzer notices; refreshed screenshot inspected.

Browser v5 table follow-up (17 November): VarList is now a native uitable (Data: Name/Class/Size) with shared row-selection helpers and appdata SelectedRows. Public select/read actions retain their schema. Class/bytes come from whos for the whole workspace variable; size uses binary units. Removed Summary control; coordinate/info tables remain. Enter and context Plot selected invoke plotting; figure mouse callback implements double-click. Six comparison groups, actual table selection/Enter and existing group/processing callbacks pass; both changed files have zero analyzer notices. Native OS double-click verification was blocked by a repeated get_window ownership error; no mouse actions were issued. Detailed limitation and fresh screenshots are in the program log.

Browser v5 double-click fix (17 November): user reported failed double-click; replaced figure mouse callback with direct classic-table Swing MouseClickedCallback via existing findjobj_2013. Exact clicked row, left-button count2 only, no selection-change dependency; adapter warning state restored. Seven check groups pass, including actual Swing dispatchEvent tests for repeated selected-row double-clicks, tab reparenting, different cached selection, and ignored single/right/blank clicks. Both changed files have zero analyzer notices. Physical OS-input check remains blocked by window ownership tool error. Live browser rebuilt and prior group/selection restored. See final log section; this supersedes prior double-click claims.

Browser v5 class-filter follow-up (17 November): Size now at most three significant digits; EditVariable beside Metadata shares the context edit callback and is disabled when empty. Bottom Status removed in favour of native All/Cut/Map/KZ/4D/1D radios. User explicitly chose OX objects only for All; includes four dimensional base classes and subclasses, excludes structs/ordinary variables. Cut/KZ use concrete classes, Map includes standard and ToF. Public typefilter action and read.typeFilter added; filter composes with tabs/search. Mutation reports move to count-label tooltip. Eight runtime groups pass with real OX-class fixtures, zero analyzer notices for both changed files, screenshots visually inspected at both sizes. No new physical OS mouse verification claimed.

Browser v5 All/font revision (17 November): user reversed OX-only All; All now bypasses class filtering and includes all workspace variables, respecting tabs/search. Specific type radios remain class-based; All/Group counts include all corresponding variables. Main table reduced from 10 to 8 points; uicontrol fonts explicitly 8 points; coordinate/metadata tables remain unchanged at 8 points (live before/after verified). Eight check groups pass including revised numeric/struct inclusion and font assertions; both changed MATLAB files have zero analyzer notices. Regenerated normal/minimum screenshots visually checked; live selection/filter state restored.

Browser v5 row-spacing follow-up (17 November): radios now above counts; removed First selection footer and extended metadata to bottom padding. Eight checks pass plus live row-order/bottom-bound assertions; zero browser analyzer notices. Screenshots refreshed, default inspected, live state restored.

Browser v5 colour/button follow-up (17 November): EditVariable moved to bottom-right with same callback; class texts and filter labels use CUT blue / MAP+ToF green / KZ purple. Class cells use HTML, Name cells remain literal; public facade unchanged. Eight checks pass including colour assertions and Swing double-click regression; both files have zero analyzer notices. Default screenshot inspected, state restored.

Browser v5 row-colour follow-up (17 November): alternating white/very-light-green main-table backgrounds, with blue selection overriding and correct stripes restored on deselection. Targeted live palette checks and visual inspection passed, zero browser analyzer notices; no new API behavior or broad regression claim.

R2025a compatibility maintenance (23 November): browser v5 uses literal class
names plus native cell font styles and DoubleClickedFcn on R2025a+, retaining
legacy HTML/Swing on earlier releases. PlotSlices configures coordinate bounds
after slider construction with valid intermediate limits/values, fixes the
N-1 step and initial index, disables single-position sliders, and clamps
position edits. Browser assertions are release-aware; a focused slider test
was added. Public facades and operation skills are unchanged. Work follows
MathWorks R2025a online documentation at the user's request. Standalone R2024a
Code Analyzer and diff whitespace checks pass; no runtime/visual pass is
claimed. R2025a is absent, MCP attach failed and the separate R2024a probe
failed at startup. The user will verify on another desktop; commands and
limitations are recorded in the browser log and PlotSlices review.

Slider lower-bound clarification (23 November): user specified `0..Max`
instead of `Min..Max`. Final slider assignments now set Max before Min, leaving
Min as the final bound written. Tests inspect after draw/resize, cover positive
minima in x/y/z and exercise the Value listener without manual refresh. Fixed
trailing-singleton validation with size(value,dimension), which otherwise
prevented single-slice checks reaching the slider. Static analysis and diff
checks pass; R2025a runtime/root-cause confirmation remains unperformed.

Slider API verification (23 November): MathWorks still documents Min/Max for
UIControl in R2025a; uislider uses Limits on both earlier and later releases.
Added public static PlotSlices.configure_position_slider to select Limits or
Min/Max from the actual control, configure Value/Enable, and distinguish
relative SliderStep from absolute Step when available. PlotSlices retains
its UIControl layout/callbacks. Tests now create real controls of both types
and exercise the shared setup; no MATLAB release switch is assumed. Standalone
Code Analyzer and whitespace checks pass; runtime tests remain unexecuted as
requested. This supersedes the speculative assignment-order explanation.

Remote slider evidence (23 November): user reports UIControl with both stored
axis/control limits 154.2140..155.7863 and Value 155.0002 in the intended
checkout. Incorrect stored Min is ruled out for that instance; visual/input
disagreement is suspected. PlotSlices now uses a native uislider in a panel
for the position control on R2025a+, while older releases and colour/gamma
controls retain UIControl. Native drag rendering uses event.Value; release
and programmatic Value updates are supported. Tests cover both release paths,
the reported energy range, callbacks, panel bounds and desktop-only UI drag
gestures. Static checks pass; runtime/visual tests remain unexecuted locally.
This follow-up supersedes the prior decision to retain UIControl on all releases.

UIControl restoration (23 November): user reported native Slider.Value is not
SetObservable and explicitly requested the previous component/panel. Removed
the native uislider, host panel, resize callback and native event paths; every
release now uses the original UIControl/HBox arrangement. R2025a+ uses raw
0..1 storage mapped to axis units through PlotSlices.position_slider_value;
older releases retain raw physical coordinates. All position reads/writes,
including mass plots and retained separate methods, use the accessor.
Tests now cover both mappings with actual UIControls, physical endpoints and
images, edits/restoration, component types and original layout. Native tests
were removed. Static checks pass; no runtime pass is claimed. This supersedes
the native-control workaround and documents its user-observed runtime failure.

Initial PlotSlices size (23 November): user confirmed the normalized UIControl
works on R2025a and reported a larger initial window. The main figure previously
inherited MATLAB defaults; MathWorks documents a larger monitor-dependent
default from R2025a. It now explicitly sets Units='pixels', Position=[100 100
560 420], and WindowStyle='normal' for a consistent legacy-sized standalone
window. No root defaults, control layout or user resizing policy changed.
Code Analyzer and whitespace checks pass; remote visual confirmation pending.
