# Technical Review of yulinARPES

> Dated review/implementation evidence. Use the [documentation index](README.md)
> and [skills map](../AI_skills/SKILLS_MAP.md) for current workflow routing.
> Later follow-ups supersede earlier designs and findings; recorded test
> results do not describe the current runtime unless rerun.

**Review date:** 14 November 2026

**Reviewed snapshot:** `5e7dede18427bfc9adbbd53edbbe8dba565e6229` (2 July 2026)

**Review type:** Static source and documentation review

**Status:** Working tree was clean at review time

## Executive assessment

yulinARPES is a long-running laboratory code collection for ARPES data loading, momentum conversion, processing, fitting, and visualisation. It has substantial accumulated domain knowledge and useful coverage of beamline formats and research workflows. The newer namespaced areas, including `+LoadDataARPES` and `+FitARPES`, provide some structure within a repository that is otherwise dominated by GUIDE applications, standalone scripts, demos, and historical variants.

The package is best treated as a laboratory toolkit for users familiar with MATLAB and the group’s conventions. It is not yet a dependable, uniform library API: many operations are coupled to the MATLAB base workspace or GUI state, interfaces and validation vary, and project-owned automated coverage is difficult to identify. I found several source-level issues that can trigger unintended behaviour or silently produce scientifically misleading results.

The recommended next step is a focused stabilization pass: remove unintended side effects and dynamic evaluation at input boundaries, validate coordinate compatibility before combining data, and establish a small set of automated checks around the supported workflows. A wholesale rewrite is not necessary to make near-term progress.

| Area | Assessment | Summary |
|---|---|---|
| Scientific and workflow coverage | Strong | Broad collection of ARPES tools accumulated over many years. |
| Organisation | Mixed | Several useful MATLAB package namespaces coexist with large legacy and experimental folders. |
| API consistency | Weak to fair | Many functions depend on figures, base-workspace variables, dialogs, or implicit input conventions. |
| Correctness safeguards | Weak | Some entry points do not validate user choices or coordinate compatibility. |
| Documentation | Fair | A user manual describes setup and common GUI workflows; developer contracts and supported configurations are less clear. |
| Testing and reproducibility | Weak | Demo and bundled third-party tests exist, but a project-level test suite and test entry point were not evident. |
| Distribution readiness | Limited | Setup depends on external OX_ARPES and GUI Layout Toolbox; root-level release and dependency metadata are limited. |

## Review basis and scope

The review covered the checked-out `yulinARPES` tree at the commit above. The working tree had no reported local changes. The repository contains 1,241 MATLAB `.m` files, alongside GUIDE `.fig` files, datasets, manuals, and bundled third-party code. In particular, `Others_uncertain` contains 858 MATLAB files; the repository also includes identifiable third-party trees such as matGeom, export_fig, viewer3d, and PeakFinder. This makes the raw file count a poor measure of project-owned code.

The review sampled the launcher, data-processing and enhancement routines, momentum-conversion code, and the `+LoadDataARPES` loader. MATLAB Code Analyzer was run on eight representative files. It reported style/performance items and source warnings; it was not used as a substitute for reading the affected logic.

This was a static review. I did not run GUI applications, loaders, or numerical routines against beamline files. Findings about numerical/scientific results should be checked against representative data and domain-owner expectations before changing behaviour. App Designer binary internals and most third-party code were not reviewed in detail.

## What the project does

The documented workflow is to launch `data_browser_demo_v32`, load measurements through a GUI, and use workspace-backed tools for plotting, processing, fitting, and k-space conversion. The repository has code for:

- Loading data from several analyser and beamline formats, including HDF5/Nexus, FITS, Igor waves, and Scienta text or ZIP exports.
- K-space conversion, including photon-energy scans.
- Data combination, interpolation, symmetrisation, curvature and ridge enhancement.
- Peak and dispersion fitting.
- GUI-based browsing, plotting, and workflow controls.

The manual recommends MATLAB 2022a–2024a, OX_ARPES, and GUI Layout Toolbox 2.3.5. The setup information is useful for users, but the repository does not establish a single, machine-checkable dependency manifest or a clear separation between supported entry points and experimental/archived code.

## Priority findings

### P1 — Successful k-space conversion plays an unrelated audio sample

**Location:** `Loader_kconvert/NEWkz/+KzConv/kzconversion.m:108–109`

After assigning the converted result, the function runs `load chirp` and `sound(y, Fs)`. This plays MATLAB’s sample chirp on every successful conversion. It is an unexpected user-visible side effect and can disrupt batch or unattended processing.

**Recommendation:** Remove these statements from the conversion routine. If they were intended as a completion cue, put that behaviour in an optional UI wrapper.

### P1 — GUI numeric fields are evaluated as MATLAB code

**Locations:** `Data_enhance/interpolation_gpu_yiwei.m:188–191`; `Data_enhance/symmetrization_gpu_yiwei.m:294–301` and related parameter callbacks

GUI text fields are converted using `eval`. The comments in the interpolation GUI already suggest numeric parsing with `str2double`, but the callbacks execute the entered text as MATLAB expressions instead. This permits more than a number to be evaluated in the user’s MATLAB session and produces inconsistent errors for invalid input.

**Recommendation:** Parse numeric scalars with `str2double` or `sscanf`, then validate finiteness, scalar shape, and allowed ranges before computation. Apply this consistently to the other GUI parameter fields.

### P1 — Data addition does not check that the coordinates match

**Location:** `Data_process/add_two_value_arrays.m:88–96`

The callback adds `data2.value` to `data1.value` and returns the result with `data1`’s axes and metadata. It does not check that the two arrays have matching dimensions or coordinate vectors. Equal-sized arrays sampled on different axes can therefore be added and presented as though they shared the first dataset’s coordinates.

**Recommendation:** Before adding, require matching dimensions and compatible axis vectors, or explicitly interpolate one dataset onto the other’s grid. Define how conflicting metadata is handled.

### P2 — Unsupported `mapping_by` values fall through without a clear error

**Location:** `Data_process/Rearrange2DTo3D.m:86–102`

The function documents `theta` and `phi` modes and separately handles `index` earlier. For any other value, the switch does not initialise `y_shifts` or `data_new.x`; later expressions then fail with a secondary indexing or undefined-variable error.

**Recommendation:** Validate the argument at entry and return a clear, named error for unsupported modes.

### P2 — Data-browser saving builds MATLAB commands from strings

**Location:** `data_browser_demo_v32.m:518`, `549`, `552`, `558`

Save operations concatenate the selected path and variable names into MATLAB command strings passed to `evalin`. Paths containing quote characters can break the constructed command, and errors are harder to diagnose than with direct file APIs.

**Recommendation:** Replace command construction with direct `save` calls or a controlled workspace export helper, and handle cancellation and write failures explicitly.

## Structure, documentation, and maintainability

The package has a useful manual and README, but discoverability is affected by the scale and age of the tree. The `Others_uncertain` folder alone contains hundreds of MATLAB files, and several operations appear in multiple numbered or suffixed versions. The tree also mixes user-facing tools, examples, tests, old copies, and third-party source. New users are not given a concise map of which directories and entry points are supported.

Most GUI operations exchange data through `evalin`, `assignin`, or shared figure state. This makes workflows convenient interactively, but it couples computation to a live desktop session and complicates scripting, headless use, and automated regression checks. The newer package folders are a good basis for separating reusable logic from GUI callbacks.

The repository includes demo and test-named files, as well as test suites belonging to bundled dependencies. I did not find a root-level project test runner or a focused test suite for the main ARPES workflows. The root README describes the project but does not give a compact developer guide, release/version contract, or explicit list of optional dependencies and supported formats.

## Static analysis notes

MATLAB Code Analyzer was run on these eight representative files:

- `data_browser_demo_v32.m`
- `Data_process/Rearrange2DTo3D.m`
- `Data_process/InterpNaNs.m`
- `Loader_kconvert/NEWkz/+KzConv/kzconversion.m`
- `Loader_kconvert/NEWkz/+KzConv/Eslice_conversion.m`
- `Loader_kconvert/+LoadDataARPES/main.m`
- `Data_process/FixGridRemove/FixGridRemove_v4.m`
- `Data_enhance/ridge_detection/ridge_detection_3_standalone.m`

The analyzer flagged, among other items, broad workspace loading in `kzconversion.m`, possible array growth in loops, unused callback arguments, and a logical comparison around `isreal` in `Eslice_conversion.m:56`. These are sample results, not a repository-wide count or certification. The direct findings above are based on reading the relevant source paths.

## Recommended improvement order

1. Remove the unconditional chirp playback and replace `eval` on numeric GUI inputs with parsing and validation.
2. Add dimension and coordinate checks to data-combination operations.
3. Validate public function options and report errors with actionable messages.
4. Separate reusable computation from GUIDE callbacks and base-workspace reads/writes; preserve the existing GUI as a thin compatibility layer.
5. Define a supported directory map and identify archived, duplicate, and third-party folders.
6. Add a small project-owned test suite for conversion and processing contracts, then validate it against synthetic arrays and trusted beamline reference files.
7. Record the supported MATLAB release and optional toolbox dependencies in one maintained location; add release and citation metadata if the repository is distributed outside the group.

## Overall conclusion

yulinARPES contains valuable research software and enough documentation for an experienced group member to begin using the main GUI workflow. The largest risks are not lack of capability, but accidental side effects, weak validation at operation boundaries, and the difficulty of distinguishing supported code from the long historical tail. Addressing the four priority correctness/safety findings and adding targeted regression coverage would improve trust in the core workflows without requiring an immediate architectural rewrite.

## Maintenance follow-up — 14 November 2026

The following changes were made after the static review:

- Removed the unconditional sample-audio playback from the photon-energy k-space conversion routine.
- Replaced `eval` parsing in the interpolation and symmetrisation GUI numeric fields with a shared finite-scalar parser. The interpolation callback that read the x-step field into the x-count variable now reads the count field.
- Added checks to the data-addition GUI for exactly two selected inputs, compatible value-array shapes, matching available coordinate axes, valid output names, and cancelled dialogs.
- Added explicit validation for `Rearrange2DTo3D` mapping modes and empty input lists.
- Changed the data-browser save callbacks to use direct `save` calls from a workspace-variable structure instead of interpolating the output path into MATLAB command text.
- Changed `load_bxsf_v2` to filter blank lines through a temporary file. The original BXSF file is opened only for reading; cancellation now returns an empty output.
- Added `setup_yulinARPES.m`, a repository map, and setup guidance in the README and manual.
- Moved the active optional `matGeom` dependency and active `export_fig` package to `third_party`. Moved the unreferenced `+LoadDataARPES_old` copy and the duplicate `export_fig_2013` tree to `archive`; the setup function excludes the archive.
- Added a small MATLAB unit suite for scalar parsing and `Rearrange2DTo3D` input/value contracts.

The archive decisions were based on clear duplication or lack of references, not file age alone. Git reports corrupt historical objects for some history queries, so file age could not be used as a reliable retirement signal. Older feature code remains in place where current code or documentation still points to it, including several dependencies embedded alongside the features that use them.

### Follow-up verification

- MATLAB Code Analyzer was run on the changed MATLAB files. It reported no analysis errors on the updated entry points; the older GUI files still produce existing callback-argument and performance/style warnings.
- The project-owned tests passed in MATLAB: **5 passed, 0 failed, 0 incomplete**. They were run after removing the relevant source folders from the MATLAB path to check that their fixtures establish the required paths.
- The setup function was checked to expose `export_fig` and matGeom while leaving `archive` off the path. Numeric parser acceptance and rejection cases also passed.
- The GUI workflows and BXSF reader were not exercised with representative beamline files. Those remain necessary before relying on scientific results from the modified paths.
