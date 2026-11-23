# `PlotSlices` Review and Improvement Record

> Dated review/implementation evidence. Use the [documentation index](README.md)
> and [skills map](../AI_skills/SKILLS_MAP.md) for current workflow routing.
> Later follow-ups supersede earlier designs and findings; recorded test
> results do not describe the current runtime unless rerun.

**File:** `Visualization/@PlotSlices/PlotSlices.m`

**Review date:** 15 November 2026

**Review type:** Source review, MATLAB Code Analyzer check, and subsequent Mass Plot runtime checks

## Purpose

`PlotSlices` is a MATLAB handle class for interactively browsing ARPES data. It reads a named variable from the base workspace, selects a slice along x, y, or z, and displays the resulting 2-D image. The interface includes slice position and width controls, colour limits, gamma and colormap controls, interpolation, crosshairs, linked EDC/MDC traces, mass plots, and repository-specific ARPES operations such as k-space conversion and Brillouin-zone overlays.

The viewer accepts OX_ARPES data objects and legacy bare structs. Its shared display representation uses a numeric `value` array with matching numeric `x`, `y`, and `z` coordinate vectors. A 2-D value array is promoted to a one-slice 3-D array. GUI Layout Toolbox, `drawcrosshair`, and the colormap resource are additional dependencies.

## Review findings and changes

| Finding | Change |
|---|---|
| Dialog values used `str2num`, which evaluates text and accepts unintended forms. | Scalar entries use `str2double`. Mass Plot validates its grid size, step, and shift without evaluating user text. Gamma and conversion inputs are validated before use. |
| 2-D promotion dropped metadata. | OX_ARPES 2-D objects are promoted to `OxArpes_3D_Data` with metadata and axis labels remapped. Legacy structs are copied and updated in place, preserving their additional fields. |
| Invalid dimensions and axes could fail later in GUI creation. | Construction now rejects unsupported dimensions and validates direction, axes, coordinate lengths, and numeric coordinate values before building the interface. Missing optional display metadata on legacy structs receives readable defaults. |
| K-space conversion inferred CUT data from `x == 1` and only handled OX_ARPES instances. | Dispatch now recognizes OX_ARPES CUT/MAP/MAP-ToF/KZ classes. Legacy 2-D structs are wrapped as `OxA_CUT`; 3-D structs are wrapped as MAP or KZ when their axis names or metadata identify the type. Source labels, units, and `info` fields are retained. Ambiguous legacy 3-D structs produce a clear unsupported-data message. |
| Colormap loading depended on the current folder and injected variables into the method workspace. | Custom maps are loaded by selected field from `Visualization/Colormap.mat` using a path relative to the class. MATLAB maps are resolved as a fallback; no `eval` is used. |
| Save dialogs accepted invalid names and silently replaced base-workspace variables. | Slice, line-cut, and k-space save paths validate names and request confirmation before overwriting. The line-cut callback also requires exactly two selected points. |
| Mass Plot required an unwieldy coordinate array and included a save-figure flag. Its fixed energy defaults could fall outside the selected dataset's range. | The dialog now asks for columns, rows, a fixed step, and a shift. It defaults to a 4-by-3 grid, suggests an axis-aware start and step, and has no save-figure branch. The main viewer's slider position is restored after plotting. |
| EDC/MDC windows were not linked to the main viewer's lifecycle, effective plot-box dimensions, cursor region, or visual style. | The main figure now closes its linked plots; manually closing either EDC/MDC window closes the pair. Linked axes use the effective image plot-box dimensions, including axis-equal aspect constraints. The EDC data width equals the MDC data height. Both traces recompute from the moving crosshair rectangle and show paired horizontal/vertical region markers. Fonts and line weights follow the main axes. |
| The restored toolbar layout has tight default spacing and inconsistent text backgrounds. | The current source is back to the original control layout: row heights are 20/40 pixels for 3-D data and 0/40 pixels for single-slice data; fixed position/width/index controls leave the remaining width to the slider. The layout has no explicit outer padding or spacing, uses default control font styling, and does not set all static-text and checkbox backgrounds to white. The recent control-layout adjustments are no longer present. |
| A menu command points to a missing callback, and one menu label is misspelled. | `Sub plot in new figure` references `newFigureSubPlot`, which is not defined in the class or its separate method files. The `copy axis test` entry has been removed from New plot; the remaining `Interploate` label should be corrected to `Interpolate`. |
| Older sections had inconsistent spacing, long callback statements, and obsolete commented code. | The modified code uses wrapped callback expressions, consistent dialog/error handling, and removes obsolete commented plotting code. Explanatory comments were added around input validation, metadata mapping, conversion, and UI actions. |

## Data compatibility details

- Native `OxArpes_2D_Data` values are promoted to `OxArpes_3D_Data` for the viewer; the original x/y axes become the displayed y/z axes and the singleton x axis is labelled as an index.
- Legacy structs remain structs during display preparation, including their acquisition-specific fields. Missing `name`, axis labels, units, or struct-valued `info` are filled with safe display defaults.
- Native conversion classes keep their class-specific `kconvert` methods. A legacy 2-D struct is interpreted as a CUT. Legacy 3-D data are interpreted as KZ when inner-energy or photon-energy metadata is present, or as MAP when azimuth metadata or angle-axis labels are present. A bare 3-D struct without these clues cannot be classified reliably and is reported as unsupported for k-space conversion.
- Displayed slices are saved as `OxA_CUT`; interpolated line cuts continue to be saved as structs to preserve the existing legacy output shape.

## Mass Plot behaviour

- For constant-energy x-y maps (`Direction = 'z'`), the default step is 0.1 eV and must be a positive multiple of 0.05 eV. A relative `E-E_F` axis starts at zero. For a kinetic-energy axis, the start is estimated as the median photon energy minus the median work function in `info`. When that estimate is unavailable or outside the measured z range, the upper axis limit is used. The editable shift offsets this starting position, and panels descend by the exact entered step until the axis or sample count is exhausted.
- For x-z and y-z views (`Direction = 'y'` or `'x'`), the step must be a positive multiple of 0.5 in the axis units. A suggested step balances coverage of the slider range against unused slots in the default 4-by-3 grid. Panel coordinates form a contiguous sequence with exactly the entered step between neighbours. Zero is retained whenever it lies in the slider range. The editable shift moves the preferred centre of that sequence; the selected sequence remains within the range.
- Rows and columns are editable, with at most 100 panels. A fixed step and finite grid cannot always cover both ends of a wide axis; in that case the x/y series stays near its preferred centre while retaining zero. A coarse step or short axis may leave grid slots empty.
- Panels use `tiledlayout`; the figure is centred and limited to 900 by 600 pixels and 80% of the primary screen dimensions. The calculation explicitly uses pixel units and restores MATLAB's previous root-unit setting. The original viewer position is restored even if plotting exits with an error. Interpolation and line overlays follow the viewer's current settings.

### Runtime checks

A representative measured map was loaded as `OxA_MAP` and plotted along all three directions in MATLAB R2024a. Its kinetic-energy Fermi estimate was about 150.479 eV. A 4-by-3 z plot at 0.1 eV spacing produced 12 panels; the x plot at a fixed step of 2 produced 12 panels from -12 to 10 including zero; the y plot at a fixed step of 3.5 produced 11 panels from -17.5 to 17.5 including zero. The generated figure measured 900 by 600 pixels within the tested display bounds. A separate check with root units set to `normalized` confirmed that Mass Plot used pixel dimensions and restored the prior root-unit setting. A synthetic `E-E_F` dataset confirmed the zero-energy start and binding-energy labels. Code Analyzer reported no issues after these changes.

## Style review

MATLAB Code Analyzer reported **0 errors, 0 warnings, and 0 informational findings** after the changes. A source scan found no active `str2num` or current-folder colormap load. The constructor still uses `evalin` to retrieve a validated base-workspace variable name. The review also checked callback formatting, helper boundaries, error messages, and scalar input validation.

## Current toolbar and menu state

The current `figureConstruct` uses GUI Layout Toolbox containers with their default padding and spacing. The first control row uses fixed widths for the position, width, and index widgets, while the position slider receives the remaining width. The figure now sets `MenuBar` and `ToolBar` to `'none'` to hide MATLAB's built-in menu categories and toolbar; custom menus created by `uimenu` remain available. Only some static-text controls specify a white background; checkbox backgrounds and several text labels use their defaults. The earlier row-height and control-width adjustments are not present.

A MATLAB R2024a check with a temporary hidden figure confirmed both properties accept `'none'` and a custom `uimenu` remains attached. Code Analyzer reports no findings for `PlotSlices.m`.

The EDC/MDC improvements remain in the current source: the linked figures close with the main window, their data axes account for the main plot box aspect ratio, the EDC data width matches the MDC data height, and paired region markers follow the crosshair positions.

## Remaining maintainability work

The class still combines GUI construction, slicing, plotting, and ARPES workflows in one large file, and most UI state remains publicly visible. Splitting numeric operations and specialized conversion workflows into focused components would make future changes easier to isolate. This larger structural refactor was not included so the current task could preserve the established GUI and data contracts.

## Review limits

The initial review used static inspection and MATLAB Code Analyzer; later Mass Plot checks launched the GUI and processed a representative measured map. Other loader and conversion paths were not retested in those checks. Beamline conventions used to distinguish legacy MAP and KZ structs still need confirmation against real metadata before relying on automatic classification for ambiguous 3-D inputs.

## Struct display defaults — 22 November 2026

The user requested that structs retain their supplied display metadata without
invented axis labels or automatic equal-axis scaling. The confirmed scope is
the browsers' 1-D plots and `PlotSlices` 2-D/3-D views; 4-D visualization is
explicitly excluded.

`PlotSlices` leaves missing axis names and units blank, including the synthetic
axis used internally when promoting a 2-D struct. The shared `arpes_axis_label`
formatter (`Visualization/@PlotSlices/arpes_axis_label.m`, exposed as the public
static method `PlotSlices.arpes_axis_label`) displays supplied names and units
independently, without empty
parentheses. Both browser versions use it for struct spectra, including the
optional `v_name`/`v_unit` intensity label. Structs skip both automatic equal-axis
checks even when their supplied units match. Manual equal-axis selection and
native-object defaults are retained; plotting does not write display defaults
back to the source workspace struct.

Validation in a separate MATLAB R2024a process passed for bare, name-only,
unit-only, and string-valued metadata on 2-D inputs and all three 3-D slice
directions. New 2-D plot windows, manual equal-axis selection, native-object
defaults, and preservation of source workspace structs were also checked.
Both browsers' 1-D plotting callbacks passed with bare structs, absent
coordinates (index fallback), and supplied labels. Batch mode could not
initialize v5's desktop mouse bridge, so the installed Enter callback was used;
native mouse interaction was not retested. Code Analyzer reported zero notices
for all four changed MATLAB files, and `git diff --check` passed.

## R2025a position-slider compatibility — 23 November 2026

User reported an incorrect 3-D position-slider range on R2025a and requested
changes based on online documentation for testing on another desktop. The
acceptance contract is that the slider covers the selected x/y/z coordinates,
its displayed index identifies the initially plotted slice, endpoint positions
select the correct slices, and single-position axes remain valid.

The [R2025a UIControl reference](https://www.mathworks.com/help/releases/R2025a/matlab/ref/matlab.ui.control.uicontrol-properties.html)
requires `Min < Max` and defines `SliderStep` as fractions of `Max-Min`.
PlotSlices now configures limits after creating the slider, expanding the
default range first and setting an in-range value before narrowing either end.
All intermediate bounds and values remain valid for positive-only and
negative-only coordinates. The initial index is the actual nearest sample.
The minor step is `1/(N-1)` instead of `1/N`; the major step is capped at one
range. Constant/single-position axes get a disabled slider with a small valid
padding around the actual coordinate. Position edits clamp to the actual data
range and nonfinite edits retain the previous position.

These address source-level issues and provide a compatibility measure; the
reported release-specific failure has not been reproduced here. Added
`tests/test_PlotSlices_position_slider.m` covers all three directions, shifted
positive/negative ranges, ascending/descending/nonuniform axes, two-sample
axes, endpoint image values, edit clamping, singleton axes and promoted 2-D
data. Tests own their fixture variables/figures and preserve existing ones.

Validation is static only: standalone R2024a Code Analyzer reports no notices
for both changed implementations and both tests, and `git diff --check` passes.
R2025a is unavailable locally; the connector could not attach and a separate
R2024a process failed at startup. Runtime and visual checks await the other
desktop. After `setup_yulinARPES` with GUI Layout Toolbox and `drawcrosshair`
available, run `runtests('tests/test_PlotSlices_position_slider.m')` from the
repository root. Also drag a real 3-D dataset through both slider endpoints
and compare the position/index fields with its stored coordinates.

### Lower-bound recheck — 23 November 2026

User clarified the symptom: the position range is `0..Max` rather than
`Min..Max`. This is a lower-bound issue, separate from step size. The first
compatibility patch still finalized `Max` after `Min`; it now finalizes `Max`
first and assigns `Min` last, after placing Value inside the requested range.
No later position-slider Max assignment occurs during construction. This is
a targeted initialization correction; neither an R2025a property-reset bug nor
the original runtime cause has been reproduced or established from the docs.

The slider tests now call `drawnow` before inspecting bounds and explicitly
exercise positive minima above the default `[0,1]` range in all directions,
including after figure resize. They verify that the lower bound stays nonzero
and that a programmatic Value change refreshes the index via the installed
listener without directly calling `update_CData`. Existing checks also cover
negative-only ranges. Inspection additionally found that validation indexed
`size(value)` at dimension 3 for singleton-z data; `size(value,3)` now correctly
returns 1, allowing those tests to reach slider construction.

Standalone R2024a Code Analyzer reports no notices for PlotSlices and its
slider test; `git diff --check` passes. No MATLAB runtime checks were repeated,
in accordance with the documentation-only R2025a workflow. The other desktop
must still confirm the physical slider's range and endpoint behaviour.

### Limits versus Min/Max API verification — 23 November 2026

User suggested that R2025a replaced Min/Max with Limits. MathWorks documents
these as two different component APIs, rather than a release-wide property
rename: [UIControl](https://www.mathworks.com/help/releases/R2025a/matlab/ref/matlab.ui.control.uicontrol-properties.html)
still exposes Min/Max for slider controls in R2025a; [uislider](https://www.mathworks.com/help/releases/R2025a/matlab/ref/uislider.html)
uses Limits, including on earlier releases. The
[UIControl migration guide](https://www.mathworks.com/help/matlab/creating_guis/update-ui-controls-and-callbacks.html)
explicitly maps Min/Max to Limits when replacing a UIControl with uislider.
The R2025a Slider reference also documents absolute Step, whereas UIControl's
SliderStep values are fractions of the range.

Position-slider setup is now centralized in the public static helper
`PlotSlices.configure_position_slider(slider,axisData)`. It checks the actual
object's properties: assign Limits together when available, otherwise use
Min/Max with valid intermediate bounds. It assigns Value inside the range,
uses relative SliderStep or absolute Step only when supported, and handles
single-position axes with disabled, strictly increasing bounds. Position and
nearest-sample index are returned for the viewer fields. The helper uses no
release-number assumption. PlotSlices continues creating its existing
UIControl in the GUI Layout Toolbox layout, so this change does not claim a
full migration to the uislider callbacks or layout.

The slider regression file now also creates real UIControl and uislider
objects and exercises the same helper on both with positive, negative,
zero-crossing, narrow, descending and singleton coordinate ranges. This
checks the Limits branch even when running tests on an older release with
uislider support. Existing complete-viewer checks remain in place.

Standalone R2024a Code Analyzer reports no notices for PlotSlices, the helper
and the slider test; `git diff --check` passes. Tests have been authored but
not executed. R2025a runtime and visual confirmation remain for the user's
other desktop. The earlier assignment-order hypothesis was not a verified
root cause; the documented slider-type distinction supersedes any implication
that all R2025a slider objects require the same property names.

### Native position control after remote diagnostics — 23 November 2026

The user supplied R2025a output from the failing desktop: the position control
is `matlab.ui.control.UIControl`; stored axis and control bounds both equal
154.2140..155.7863, and Value is 155.0002. The constructor resolves to the
intended yulinARPES checkout. This rules out an incorrectly stored lower bound
in that inspected instance. A disagreement between reported UIControl bounds
and its visual/interactive range is now the leading explanation; the user has
not yet supplied a captured leftmost drag value. The colour/gamma controls all
intentionally start at zero, so their appearing correct does not test nonzero
lower-bound handling. The earlier assignment-order changes were insufficient.

On R2025a and later, PlotSlices now creates the position control with native
`uislider` and its Limits API. MathWorks explicitly documents support for
uislider in classic figure-based apps from R2025a in the
[uislider version history](https://www.mathworks.com/help/matlab/ref/uislider.html).
Older MATLAB releases retain UIControl and Min/Max. Only the position control
changes type; existing colour/gamma controls remain UIControls. The native
slider is hosted in a borderless panel within the original GUI Layout Toolbox
row and resized with that panel; tick labels are disabled to fit the row.

The native ValueChangingFcn renders event.Value, as required by the
[R2025a Slider reference](https://www.mathworks.com/help/releases/R2025a/matlab/ref/matlab.ui.control.slider.html):
Slider.Value retains the last committed value while dragging. ValueChangedFcn
refreshes on release, and the existing Value listener retains programmatic
position/index editing and mass-plot updates/restoration.

Tests are now aware of the expected control type for the running release.
New callback checks cover the user's narrow nonzero energy range, transient
drag values without changing the committed Value, release updates, endpoint
images and panel bounds. A desktop-only test uses the documented App Testing
Framework drag gesture to move the real native slider to both endpoints;
property readbacks alone cannot validate the reported failure.

Standalone R2024a Code Analyzer and diff whitespace checks pass. These tests
remain unexecuted locally, and native rendering/layout/drag validation is still
required on the R2025a desktop. Reopen a new viewer after syncing the checkout;
its position slider must now report `matlab.ui.control.Slider` and the expected
154.2140..155.7863 Limits. This is a targeted workaround for the observed
legacy-control disagreement, not a confirmed general MathWorks bug diagnosis.

### Restore UIControl and normalize its internal position — 23 November 2026

User rejected the native component after an R2025a constructor failure:
`matlab.ui.control.Slider.Value` is not SetObservable, so attaching the legacy
PostSet listener throws. The native replacement was not validated at runtime
and introduced this error. The user explicitly requires the previous
UIControl and panel behaviour. This supersedes the native-control design above.

PlotSlices again creates a direct UIControl child in its original HBox on
every release. The added native host panel, resize method, native callbacks
and transient event-value handling are removed. The original Value PostSet
listener now attaches only to the same UIControl type used by the other sliders.
Existing row sizes and fixed control widths are retained.

For R2025a and later, the position UIControl deliberately uses Min=0, Max=1.
`PlotSlices.position_slider_value(slider)` maps its raw Value to the actual
axis range; passing a second argument writes a position in axis units.
Thus raw Value=0 means physical position 154.2140 for the user's dataset,
and raw Value=1 means 155.7863. This removes dependence on the reported
nonzero-Min visual/input behaviour while retaining the previous widget.
Older releases retain physical-coordinate Min/Max and Value. The Pos/Ind
fields, averaging widths, slice calculations, index buttons, edit callbacks,
new-figure paths and mass-plot positioning/restoration use physical units on
both paths. The retained separate crosshair/export/correction methods also
use the accessor. Colour and gamma slider code is unchanged.

The configuration helper now accepts only slider UIControls; all uislider
branches and native-component tests are removed. Tests exercise physical and
normalized storage explicitly on the same release, verify endpoint mapping
and images, index and position edits, position restoration, singleton axes,
original HBox parenting/sizes and all four slider component types. Directly
reading or writing raw `viewer.Slider.Value` is no longer a physical-position
API on R2025a+; scripts should use the accessor or the existing GUI edit fields.

Standalone R2024a Code Analyzer reports no notices for PlotSlices, both slider
helpers and the rewritten regression file; diff whitespace checks pass.
R2025a runtime/visual confirmation remains unperformed locally. The next
remote check must use a newly constructed viewer after closing old windows
and clearing their retained object variables. This change removes the
unsupported native-component listener path; it does not claim that the
original MATLAB UIControl rendering issue has been reproduced locally.

## Initial figure size across releases — 23 November 2026

User confirmed the normalized UIControl slider works on R2025a, then reported
that the PlotSlices window opens larger than in older MATLAB versions.
`figureConstruct` did not specify Units, Position or WindowStyle, so the main
window inherited MATLAB's defaults. The
[R2025a release notes](https://www.mathworks.com/help/releases/r2025a/matlab/release-notes.html)
explicitly document a larger monitor-dependent default figure size and show
`Position=[100 100 560 420]` to recover the previous default size. They also
document the change from standalone windows to a docked figure container.

The main PlotSlices figure now explicitly uses pixel units, a 560-by-420
content area at [100 100], and WindowStyle='normal' on every release. This
sets a consistent initial size without changing graphics-root defaults or
fixing/locking subsequent user resizing. The uicontrol/HBox arrangement and
linked/mass-plot figure sizing are unchanged. Window decorations and OS display
scaling can still affect the outer window's physical appearance.

Validation: source inspection found no later main-window size assignment;
standalone R2024a Code Analyzer reports no notices for PlotSlices and diff
whitespace checks pass. No new runtime or visual check was performed; the
R2025a appearance remains for remote confirmation.
