# Review of `data_browser_demo_v32`

> Dated review/implementation evidence. Use the [documentation index](README.md)
> and [skills map](../AI_skills/SKILLS_MAP.md) for current workflow routing.
> Later follow-ups supersede earlier designs and findings; recorded test
> results do not describe the current runtime unless rerun.

**Review date:** 15 November 2026

**File reviewed:** `data_browser_demo_v32.m`

**Review type:** Static source review and MATLAB Code Analyzer

**Scope:** Purpose, user workflow, data assumptions, maintainability, and improvement suggestions

**Implementation follow-up:** The P1/P2 findings below have been addressed in the MATLAB file, except for the larger architectural recommendation to reduce base-workspace coupling. The final Code Analyzer pass reports no issues.

## Purpose

`data_browser_demo_v32` is a MATLAB desktop GUI for browsing and managing variables in the MATLAB **base workspace**. It is an interactive hub for ARPES work rather than a self-contained data loader or processing library: its Loader menu calls other repository tools, and its list and callbacks then operate on variables those tools put in the workspace.

The intended workflow is:

1. Launch `data_browser_demo_v32`.
2. Load data through the Loader menu or another MATLAB workflow so that the result exists in the base workspace.
3. Browse all variables or filter ARPES variables into one of four groups.
4. Plot or open supported data in viewer tools; use context-menu actions to combine, save, rename, edit, process NaNs, or delete variables.

The GUI is a singleton: another call raises the existing `DataBrowser` figure. It stores graphics handles with `guidata` and routes most work through callbacks.

## Main capabilities

- **Loading and navigation:** Menus dispatch to ARPES loaders, synchronization, and momentum/k-space conversion routines elsewhere in the repository.
- **Visualization:** Double-click plotting, directional slice plots, integrated DOS-style plots with raw/mean/peak normalization, 2-D/3-D/4-D data viewers, and a volume viewer.
- **Grouping:** Four user-named groups filter the list. Membership is stored in each data value's `info.GroupInfo` flags. Add, move, and remove actions modify those flags.
- **Data operations:** Rearrange selected 2-D cuts into 3-D; combine maps directly or through `CombineData_interp`; interpolate NaNs or replace them with zero in derived copies.
- **Workspace and file management:** Rename or edit variables, save selected variables together or separately, and delete selected base-workspace variables after a confirmation dialog.
- **Data summary:** Displays axis minima, maxima, sample counts, and step sizes for the selected ARPES value.

The common ARPES data convention is a `value` array with optional `x`, `y`, and `z` coordinate vectors and an `info` metadata field. Group actions specifically depend on `info.GroupInfo`. The unfiltered list may also contain ordinary MATLAB variables, but most plotting and data-operation actions assume ARPES-like fields.

## Review findings

### P1 — Direct combine could continue after finding incompatible axes — addressed

**Original location:** direct-combine callback

The direct combine callback displays an error when a later dataset's `y` axis differs, but it does not stop or mark the operation as failed. It can continue with later inputs and still assign a result under the fixed name `combinedMap`. The callback checks only `y` equality before concatenation; it does not validate all dimensions and coordinate vectors needed to establish compatibility.

**Suggestion:** Validate the complete data shape and relevant axis vectors before combining. On the first mismatch, stop and leave the workspace unchanged; report which selected variables failed and why. Consider letting the user choose or providing an output name instead of always writing `combinedMap`.

### P1 — Group rename evaluated the typed label as MATLAB code — addressed

**Original location:** group-rename helper

`Rename` constructs `eval` strings to read and update a group button. The new label is inserted into a quoted MATLAB command without escaping. A quote or other special input can cause an error or execute unintended MATLAB expressions.

**Suggestion:** Access the button directly with `handles.(Group)` and call `get`/`set` on that handle. Keep the label as plain text; no `eval` is needed here.

### P2 — 1-D vectors were routed to the 2-D viewer — addressed

**Original location:** data-viewer callback

`mapViewerNew_CallbackFcn` chooses a viewer using `ndims(data.value)`. MATLAB reports at least two dimensions for a vector, so a one-dimensional `value` array can be sent to `OxArpes_DataViewer_2D` instead of being identified as 1-D. `PlotData` already has a separate row/column-vector check, but this viewer callback does not.

**Suggestion:** Detect vectors using `isvector` or the data class before dispatching, and either open a 1-D viewer/plot or show a clear unsupported-data message.

### P2 — Axis summary assumed at least two coordinate points — addressed

**Original location:** data-information update logic

When `x` or `y` exists, the information panel reads its second element to calculate step size. Empty or single-point coordinate vectors can raise an indexing error while refreshing the GUI.

**Suggestion:** Check that each coordinate is a nonempty vector, and only compute a step when it has at least two elements. Display an explicit unavailable/index value otherwise. Apply equivalent checks to `z`.

### P2 — Broad volume-viewer catch could hide the original failure — addressed

**Original location:** volume-viewer callback

The volume-viewer callback catches every error from `volumeViewer` and retries the same viewer call through `evalin('caller',...)`. Errors caused by malformed axes, unsupported data, or missing functionality can therefore be obscured by a second error.

**Change made:** The callback now validates the data dimensions and numeric axes before opening the viewer. It reports the caught MATLAB error directly instead of retrying the same call through `evalin`.

### P2 — Selection and workspace coupling make callbacks hard to reuse — remains

**Locations:** callbacks throughout the file, especially `UpdateVarList` and the save/delete/group operations

The GUI discovers variables with `evalin('base','who')` and passes values between callbacks with `evalin` and `assignin`. This is convenient for an interactive workspace, but it means operations depend on global session state, selected list indices, and fixed output names. It also makes them harder to call in scripts, test without a desktop, and safely reuse.

**Suggestion:** As a gradual refactor, keep the GUI callbacks thin and extract operations that accept data values and return results. Centralize workspace reads/writes and make input/output variable names explicit. This preserves the current workflow while creating testable function boundaries.

### P3 — Repeated array growth and callback warnings — addressed

**Initial static analysis:** MATLAB Code Analyzer reported 12 warnings and 9 informational items. Informational items included arrays grown inside loops in plot/list/combine paths. Warnings included unused callback arguments and unused GUI handles assigned while constructing the 2-D-to-3-D prompt.

**Change made:** Selection-dependent arrays are preallocated, unused callback arguments and UI handles were removed where safe, and the final Code Analyzer pass reports no issues.

## Dependencies and structure

- The GUI layout uses `uiextras.VBox`, `HBox`, `Panel`, and `Grid`, which require GUI Layout Toolbox on the MATLAB path.
- Many menu entries call functions defined elsewhere in `yulinARPES` or in related OX_ARPES tools. A dependency scan following the callback references discovered 230 files and associated several MathWorks products; this includes optional menu functionality and should not be read as a startup-only requirement list.
- This file combines figure construction and many callbacks in one function file. Related behavior is grouped by comments, but some older commented-out code and comments remain, and the implementation has accumulated spelling inconsistencies such as `volumeViwer_Callback`.

## Recommended next steps

1. Reduce direct base-workspace access by extracting data operations from GUI callbacks.
2. Make combine output names configurable or ask before replacing an existing result variable.
3. Add focused checks for 1-D/2-D/3-D data, mismatched axes, short coordinate vectors, grouping metadata, and cancellation paths before relying on these changes.
4. Remove or archive inactive legacy blocks and standardize the remaining older callback names as part of a separately reviewed cleanup.

## Implementation and style check

- Direct combination now validates required fields, finite numeric axes, array dimensions, matching non-X axes, and 3-D Z coordinates before creating `combinedMap`. A mismatch stops the operation without assigning a partial result.
- Group renaming now updates the selected UI control directly; it no longer builds MATLAB code from the entered label.
- One-dimensional values now follow the 1-D plotting path. Unsupported dimensionalities produce a clear message.
- The axis-information panel handles missing, malformed, and single-point coordinates without indexing past the axis.
- The volume-viewer callback validates its data and axis scales and displays the original viewer error.
- MATLAB Code Analyzer reports **0 warnings and 0 informational items** after the changes. `git diff --check` passes, and no source line exceeds 120 characters.
- The code was not run against live data or the GUI; the changes received static analysis only. Focused runtime checks remain recommended before relying on these paths for analysis.

## Review limits

This was a static review. MATLAB Code Analyzer and dependency discovery were run, but the GUI was not exercised against representative ARPES measurements, and numerical results were not compared with trusted beamline outputs. Recommendations that affect data interpretation should be validated with representative datasets and domain-owner expectations before implementation.
