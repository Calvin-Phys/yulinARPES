# `fit_MDC_demo` Review and Upgrade Plan

> Dated review and planning record. Nothing in this document has been
> implemented yet: **no MATLAB code was changed** during this review. Use the
> [documentation index](README.md) and [skills map](../AI_skills/SKILLS_MAP.md)
> for current workflow routing. Recorded test results describe the revision
> reviewed below and the R2023a box runtime on that date only.

**Files:** `Fitting/fit_MDC_demo/fit_MDC_demo_20150312.m` (entry point),
`Fitting/fit_MDC_demo/fit_MDC_tools.m` (companion), plus bundled third-party
`peakfit.m` and `PeakFinder/`

**Revision reviewed:** yulinARPES `33ee1b9` (folder unchanged since `b3c1fc3 Initial Upload`)

**Review date:** 23 November 2026

**Review type:** Full source read, MATLAB Code Analyzer, dependency scan, and
read-only batch runtime checks on synthetic data (MATLAB R2023a, Linux box)

**Requested by Calvin (scope of the upgrade):**

1. Remove the dependency on `data_browser_demo`; accept a variable at startup.
2. Optimise the layout.
3. Support both horizontal (MDC) and vertical (EDC) peak fitting.
4. Redo the hand-specified initial peaks, which are hard to use.

This report evaluates the current program and those four points and proposes a
design. It is for planning only.

---

## 1. Executive summary

`fit_MDC_demo_20150312` is a 2015 classic-`figure` GUI (Han Peng) that fits one
to six Lorentzian peaks plus a constant background to every MDC of a 2-D
ARPES cut and plots the resulting dispersion on the image. The core idea is sound
and, when seeded correctly, it tracks a synthetic linear band well (median
position error 0.004 in x-axis units across 61 slices). The program is
nonetheless **prototype-grade**:

- **It cannot be used on current data objects.** Fitting an `OxA_CUT` fails with
  `Unrecognized property 'FitPeak' for class 'OxA_CUT'` (line 488). Loading data
  needs the old browser's `'DataBrowser'` tag, so **launching from
  `ARPES_data_browser_v5` always warns, and Refresh then errors** (lines 49–55,
  268–272).
- **It can destroy user data.** *Save Peaks* and *Save&Load* overwrite the
  source workspace variable without asking, with the app's internal copy. That
  copy may already be cropped by *Select Area* and has an added `FitPeak` field
  (lines 264, 515–518).
- **Peak seeding is fragile.** Each peak needs at least two hand-placed seeds on
  different MDCs, and every listed peak must be seeded. One seed gives
  `Interpolation requires at least two sample points`, and an unseeded extra
  peak gives `Index exceeds the number of array elements` (both verified).
- **The fit is unconstrained and has no uncertainties.** Bounds are computed but
  never used (`fminsearch`, lines 438–454). Slices that are entirely NaN quietly
  return the seed as if it were a fit. The exported background `b` is always the
  seed value, not the fitted value (verified: exported `b = 0`, fitted
  `b ≈ 1–2×10⁻⁵`).
- **Much of the interface is non-functional.** The Fit Settings table is never
  populated and its callbacks only `disp(evt)`. Show/Hide All Peaks, Go to
  Point's MDC and Delete Point are empty stubs. Peak1 can never be deleted.
- **Only one direction is supported.** MDC is hard-coded as `data.value(:,j)`
  throughout. There is no EDC mode, no integration width, and no Fermi cutoff
  model.

**Recommendation:** do not patch the 2015 file. Build a new, toolbox-free
peak-fitting app with a separate, tested numerical backend, following the
pattern of the recent FDD upgrade (`OX_ARPES/GUI/FDD`). Keep the old tool and
its menu items untouched until the new one is accepted.

## 2. Current state

### 2.1 Files

| File | Lines | Role | Used by entry point? |
|---|---:|---|---|
| `Fitting/fit_MDC_demo/fit_MDC_demo_20150312.m` | 1143 | GUI, state, fitting loop, plotting, export; ~45 local functions | — (entry point) |
| `Fitting/fit_MDC_demo/fit_MDC_tools.m` | 96 | Separate mini-window: list `*Peak*` base variables, linear fit → Fermi velocity, delete variable | No (standalone, not on any menu) |
| `Fitting/fit_MDC_demo/peakfit.m` | 2420 | T. O'Haver `peakfit` v6.1 (2015), third-party | **No** |
| `Fitting/fit_MDC_demo/PeakFinder/` (20 `.m` + `ipeakdata.mat`) | ~11 100 | O'Haver `findpeaks*`/`ipeak` family, third-party | **No** |

`rg` confirms nothing in yulinARPES or OX_ARPES calls `peakfit`, `PeakFinder`, or
`fit_MDC_tools`. The only references to the entry point are the two browser
menus:

| Caller | Line | Menu path | Call |
|---|---:|---|---|
| `data_browser_demo_v32.m` | 84 | Tools → Fit MDC | `'Callback',@fit_MDC_demo_20150312` |
| `ARPES_data_browser_v5.m` | 947 | Analyze → Fit spectra → Fit MDC | `'Callback',@fit_MDC_demo_20150312` |

Both pass `(src, evt)` as `varargin`, and the function ignores them.

### 2.2 Architecture

- **Framework:** a programmatic classic `figure` (no GUIDE `.fig`, not
  `uifigure`), laid out with GUI Layout Toolbox `uiextras.VBox/HBox/Panel`
  (deprecated v1 API).
- **State:** spread across graphics properties. The data is in the figure's
  `UserData`, the per-slice seeds (`UserPeak`, a struct array with dynamic
  `PeakN` fields that also holds graphics handles) are in the `uitable`'s
  `UserData`, and an unmodified backup is in the Refresh button's `UserData`.
  `guidata` holds the handles and the current slice index.
- **Workflow:** startup loads built-in synthetic data named
  `test_data_CdAs3_kz` (lines 97, 182). **Refresh** asks to save, then loads
  `VarNames{1}` from the figure tagged `'DataBrowser'`. The user then works
  through these steps:
  1. **Add Peak** adds a name to the list.
  2. Drag the blue line to a slice.
  3. Right-click the MDC axes → **Add New Point → to PeakN**.
  4. Drag the `+` marker for position/height and the dashed line for width,
     and the black line for the background.
  5. Repeat on another slice.
  6. **Start Fitting**.
  7. Use **Export Peak** (list context menu) or **Save Peaks**.
- **Model:** `h·w²/((x−x₀)²+w²)`, a Lorentzian where *h* is the peak height and
  *w* the **HWHM** (half width at half maximum); this is undocumented. A
  constant background *b* is shared by all peaks of a slice.
- **Fitting:** each slice is fitted independently, with `fminsearch` on the
  summed squared residual. The start values are spline-interpolated from the
  seeds (lines 400–405). Only rows between the first and last seed of each peak
  are fitted.
- **Export:** `assignin('base', '<var>_PeakN', struct x,y,h,w,b)`, plus `_x` and
  `_y` vectors. The `x,y` fields are compatible with `EmassFitting`
  (`data.x,data.y`, `Fitting/EffectiveMassFitting/EmassFitting.m:147–148`) and
  `fit_MDC_tools`.

### 2.3 Dependencies (R2023a, `requiredFilesAndProducts` + manual grep)

| Dependency | Where | Status on this box |
|---|---|---|
| GUI Layout Toolbox (`uiextras.*`) | lines 69–160; `fit_MDC_tools` line 13 | Installed 23 Nov 2026 (separate checkout on the saved path) |
| Image Processing Toolbox (`imrect`, deprecated) | lines 650, 652 (Select Area) | Installed 23 Nov 2026 (IPT 11.7) |
| Curve Fitting Toolbox (`fit(...,'Poly1')`) | `fit_MDC_tools.m` line 34 | **Not installed.** On the current path `fit` resolves to `Fitting/@FitFermiSurface/fit.m`, a class method, so the linear fit fails for `double` input |
| Optimization / Signal Processing / Statistics | — | Not used (`fminsearch` is base MATLAB) |

### 2.4 Code Analyzer (`checkcode -id`)

| File | Messages | Detail |
|---|---:|---|
| `fit_MDC_demo_20150312.m` | 2 | `IMRECT` ×2: `imrect` is not recommended (lines 650, 652) |
| `fit_MDC_tools.m` | 2 | `NOSEMI` ×2 (lines 32, 47) |
| `peakfit.m` (unused) | 358 | Mostly style (`NOCOMMA` 187, `NOSEMI` 49, `AGROW` 34, `GVMIS` 32) |

The low analyzer count for the entry point hides behavioural defects. Most of
the problems below are logic, state and data-contract issues that the analyzer
cannot see, and many warnings are suppressed with `%#ok`.

### 2.5 Does it run on this box?

In `matlab -batch` (R2023a, invisible figures), it **launches in about 6 s**
now that GLT and IPT are installed. Before 23 Nov it would have failed at line
69 without GLT. On the built-in synthetic data, a three-seed Peak1 fit over 61
of 100 slices took 2.6 s, with a median position error of 0.004 (max 0.11 at
the image edge) and widths of 0.58–0.64 against an intrinsic HWHM of 0.6. In an
interactive session it shows a "Please Open Data Browser" warning on every
launch unless `data_browser_demo_v32` is open. The interactive drag, `imrect`
and dialog paths were reviewed in source but not driven in this check.

## 3. Findings (severity-ranked)

Line numbers refer to `fit_MDC_demo_20150312.m` unless another file is named.
"Verified" means the behaviour was reproduced in the batch checks in §2.5.

### Critical

| # | Finding | Location | Evidence |
|---|---|---|---|
| C1 | **Fitting fails for `OxA_CUT` and other value-class objects.** `data.FitPeak = Peak` cannot add a property to `OxArpes_2D_Data` subclasses, so the whole fit is lost at the last step. Current loaders produce these objects. | 488–489 (also 924, 230) | Verified: `Unrecognized property 'FitPeak' for class 'OxA_CUT'` |
| C2 | **Silent overwrite of the source variable.** *Save Peaks* writes the app's internal copy back under the source name without confirmation. After *Select Area* that copy has cropped `x`/`value`, so the original data is replaced by a truncated version. *Save&Load* does the same. On first use the name is the hard-coded `test_data_CdAs3_kz`. | 515–518, 258–265, 97 | Source review |
| C3 | **Cannot load data without the v32 browser, and not at all from v5.** The startup position and Refresh both look up `findobj('Tag','DataBrowser')`. v5's figure tag is `'ARPESDataBrowserV5'`. When the lookup is empty, `warndlg` is followed by `h1(1)` on an empty array, which errors. If no variable is selected, `VarNames{1}` also errors. | 49–55, 268–273; `ARPES_data_browser_v5.m:19,56` | Verified tag mismatch; error path from source |
| C4 | **`fit_MDC_tools` Delete may clear the wrong variable.** The selection index refers to the filtered `*Peak*` list but is used to index the full `who` list, and the confirmation dialog shows that wrong name. | `fit_MDC_tools.m` 82–92 | Source review |

### High

| # | Finding | Location | Evidence |
|---|---|---|---|
| H1 | **One seed per peak is a hard error, and an unseeded listed peak breaks the whole fit.** `interp1(...,'spline')` needs at least 2 seeds. A peak added but never seeded leaves `Peak.x` shorter than `Peak.x_f`, giving an index error in the redraw. | 400–405, 393–396, 928 | Verified both errors |
| H2 | **Unconstrained optimiser; computed bounds are dead code.** `x_lb`/`x_ub` are built and then ignored, and `fminsearch` with default options is used for up to 19 parameters. Peaks can swap or jump to a neighbour, or drift outside the window. Negative heights and widths are possible. Nelder–Mead convergence is not checked. | 437–454 | Source review; the clean synthetic case stayed sensible |
| H3 | **Exported background is wrong.** The fitted value goes into `Peak.b(j)` (465), but export and `FitPeak.b_f` read the seed array `Peak.b_f` (374, 386, 247). | 247, 374, 386, 465 | Verified: exported `b` = 0 vs fitted 1–2×10⁻⁵ |
| H4 | **All-NaN or empty slices report the seed as a fitted value.** With no finite points, `fminsearch` returns `x0` unchanged and there is no flag. | 447–454 | Verified: all-NaN row returned the interpolated seed (66.36) |
| H5 | **No uncertainties or goodness-of-fit.** There are no σ, χ², residuals or convergence flags, so the dispersion cannot be weighted or quality-filtered. | 454 | Source review |
| H6 | **Peak identity is tied to its name's last digit and to cell order.** Export uses `str2double(PeakName(end))` as the cell index, but the cells are stored in list order. With non-contiguous peaks (for example Peak1 and Peak3), exporting Peak3 indexes cell 3 of 2. The count is capped at 6 and the digit parse at 9. | 241–247, 362–370, 534 | Source review |
| H7 | **Refresh leaves inconsistent state.** It resets `UserPeak` to Peak1 only but leaves stale Peak2… entries in the list and context menu. It does not update the MDC scatter `XData` for the new axis, calls a bare `hold off` on `gca` (possibly another figure), and loses the previous fit without saving it. | 256–305 | Source review |
| H8 | **`fit_MDC_tools` is broken on this box and has a loop bug.** `fit` needs the Curve Fitting Toolbox (see §2.3). The loop runs over all list names but indexes `index(i)`, which errors whenever fewer items are selected than listed. | `fit_MDC_tools.m` 32–34 | Dependency scan; source review |

### Medium

| # | Finding | Location |
|---|---|---|
| M1 | MDC only: `data.value(:,j)` and `data.y` slicing are hard-coded in every function, and there is no integration width (single-pixel MDCs). | 194, 425, 447, 704, 744 |
| M2 | Only 2-D input is accepted, and only through Refresh. There is no slice selection from a 3-D map, and the startup `varargin` is ignored. | 1, 276 |
| M3 | Only one model: a Lorentzian with HWHM width (undocumented, exported as `w`) and a constant background. There is no Gaussian, Voigt or linear background, and no Fermi cutoff or resolution, which EDC fitting needs. | 1002–1003, 504–513 |
| M4 | Seeds are spline-interpolated between the outermost seeds only, so widths and heights can overshoot. Rows outside the seeded span are never fitted, and there is no slice-to-slice tracking (each slice starts from the interpolated seed, not the neighbouring fit). Unseeded rows start with background 0. | 393–405, 386 |
| M5 | *Select Area* crops data from the backup, which discards `FitPeak`. It does not crop the image or redraw axes, and it relies on deprecated `imrect` (IPT) with a modal "press DONE" state. | 638–694 |
| M6 | The fit redraws both axes for every slice inside the loop. It is acceptable at 100 slices (2.6 s) but scales poorly, cannot be cancelled, and shows no busy state. | 467–477 |
| M7 | Hidden failure modes: `str2double(name(end))` colour lookup, `ListBox` index arithmetic (`ind<=3`, `ind-1`), and `'Peak[0-9]'` regex filtering of dynamic fields. | 369, 592, 615, 359 |
| M8 | Window position depends on the browser and screen height (`ScrSiz(4)-730`) and can land off-screen on small displays. | 52–68 |

### Low

| # | Finding | Location |
|---|---|---|
| L1 | Dead UI: the Fit Settings table always shows `{0 0 0 0 0 false}`, has 5 editable flags for 6 columns, and its callbacks only `disp(evt)`. Show/Hide All Peaks, Go to Point's MDC, Delete Point and `UpdateSettingTable` are empty stubs. The `Fig1PointsContextMenu` is never attached. | 139–148, 164–168, 324–327, 696–707 |
| L2 | Peak1 can never be deleted (`ind<=3` guard). | 592 |
| L3 | About 120 lines of repeated data-structure comment blocks, commented-out code, a typo (`'Heigt'`) and a misleading "EDC Panel Menu" comment. | throughout |
| L4 | `fit_MDC_tools` uses whimsical dialog wording ("My lord… You shall not stop me!") for a destructive action. | `fit_MDC_tools.m` 86–88 |
| L5 | Unused third-party `peakfit.m` and `PeakFinder/` (~13 500 lines) ship in the same folder, enlarging the path and risking name clashes with Signal Processing `findpeaks`-style helpers. | folder |
| L6 | No help text, no tests and no operation skill. | — |

## 4. Deep dive on Calvin's four points

### 4.1 Decouple from `data_browser_demo` and accept startup input

**Current behaviour.** The function ignores its arguments, always opens on
synthetic test data, and can only load the browser's first selected variable
via Refresh. This requires the v32 tag (C3). The v5 menu effectively launches a
demo that cannot load real data.

**Recommendation: one input-normalisation layer and several entry routes.**

```matlab
app = PeakFit_app;                                 % empty app, pick data in-window
app = PeakFit_app('sample_cut');                   % base-workspace variable name
app = PeakFit_app(cutObj);                         % OxA_CUT / OxArpes_2D_Data / struct
app = PeakFit_app(mapObj,'SliceAxis','z','SliceIndex',40);   % 3-D → one 2-D slice
app = PeakFit_app(data,'Direction','EDC','Name','myCut');
```

- `pkf_input(data)` would accept a variable name, a struct with
  `x,y,value`, or any `OxArpes_2D_Data`/`OxArpes_3D_Data` object. It would
  return a plain internal struct (`x, y, value, xName, yName, units, info,
  sourceName, sourceClass`) and **never modify or write back to the source**.
  It would validate numeric finite axes, `size(value)==[numel(x) numel(y)]`,
  and monotonic axes (ascending or descending), and keep units and `info` such
  as `temperature`.
- In the window, a **Data** panel would hold a workspace dropdown filtered to
  compatible variables, a ↻ refresh button and a **Load** button, the same
  pattern as `FDD_fit_app`. For 3-D input it would also show a slice-axis and
  index selector.
- **Browser integration:** both menus would call `@(~,~)PeakFit_app(selected)`.
  `selected` is the browser's current selection (`handles.VarNames{1}` in
  v32/v5), or nothing, which opens the app empty. The app would have no lookup
  of the browser figure or its tag. Old menu items stay until the new tool is
  accepted. A new item could be labelled "Fit peaks (MDC/EDC) (new)", next to
  "Fit Fermi-level (new)".
- **Results never overwrite the source.** Export would go to a *new* named
  variable (default `<source>_peaks`), with a name check and an overwrite
  confirmation, as FDD does.

*Trade-off:* passing the selected name from the browser is a small edit in
each browser, but it avoids the old pick-then-refresh dance. Opening empty
and choosing in-window needs no browser edit. Doing both is cheap.

### 4.2 Layout optimisation

**Current layout.** The window is a fixed 700×500 `figure`. The top 150 px are
taken by a "Target Variable" text, a Refresh button, three HTML buttons, a peak
listbox, and a non-functional 6-column table. The image and MDC axes share the
rest of the space. There are no axis labels, no units, no residual plot and no
status indication other than a one-line text. The core actions (seed, fit,
export) are hidden in right-click menus.

**Proposed layout** (a toolbox-free `uifigure` + `uigridlayout`, consistent
with `FDD_fit_app` and compact as Calvin asked for FDD, about 1100×680 px,
resizable):

```
┌──────────────┬──────────────────────────────┬────────────────────────────┐
│ 1 Data       │                              │  Profile (MDC or EDC)       │
│  var ▾ ↻ Load│   2-D image (x vs y)         │  data · model · components │
│  slice (3-D) │   – slice cursor + band      │  draggable peak/width      │
│ 2 Direction  │     (integration width)      │  handles                   │
│  ◉ MDC ○ EDC │   – fitted dispersion points │────────────────────────────│
│  width [  ]  │     (colour per peak, ±σ)    │  residual                  │
│ 3 Peaks      │   – seed markers             │                            │
│  Auto-find ▸ │                              │                            │
│  + Add  − Del│                              │                            │
│ 4 Fit        ├──────────────────────────────┴────────────────────────────┤
│  model ▾ bg ▾│ Peak table: # | on | pos ±σ | height | FWHM | lock | bounds │
│  range [ – ] │                                                             │
│  Fit slice   │                                                             │
│  Track all ▸ │                                                             │
│ 5 Export     │                                                             │
├──────────────┴─────────────────────────────────────────────────────────────┤
│ ● status lamp  Idle / Fitting 37/120… / Done / Failed      χ²ᵣ, n peaks  │
└─────────────────────────────────────────────────────────────────────────────┘
```

- The left column runs in workflow order (Data → Direction → Peaks → Fit →
  Export), with primary actions as visible buttons rather than right-click
  menus. Advanced options (model, background, bounds, tracking gates) sit in a
  collapsible section.
- Axes would carry labels and units from the data. Colours would be consistent
  per peak across the image, profile and table, with text labels as well as
  colour.
- A status lamp and progress would match FDD. Long tracking runs would get a
  **Stop** button and would not redraw every slice; they would update the
  overlay every N slices.

*Trade-off:* `uifigure` needs the `MATLABWindow` FreeType workaround on this
Linux box (already in `/usr/local/bin/matlab`). A classic `figure` with
`uigridlayout` is not possible, because `uigridlayout` needs `uifigure`. A
classic figure with manual normalised positions avoids the MATLABWindow
dependency but is harder to keep tidy. **Recommendation: `uifigure`**, for
consistency with FDD and v5-era tools.

### 4.3 Dual-direction (MDC and EDC) fitting

**Current state.** MDC only, hard-coded (M1).

**Recommended abstraction.** Treat the direction as a choice of *profile axis*
and *scan axis*, applied once in the backend:

| Direction | Profile (fitted along) | Scan (stepped over) | Profile at index *j* | Typical output |
|---|---|---|---|---|
| Horizontal / **MDC** | `x` (momentum/angle) | `y` (energy) | `mean(value(:, j−w:j+w), 2)` | `k(E)` dispersion |
| Vertical / **EDC** | `y` (energy) | `x` (momentum/angle) | `mean(value(i−w:i+w, :), 1)` | `E(k)` dispersion |

- `pkf_extract_profile(D, direction, scanIndex, halfWidth)` would return
  `(u, I, scanValue)` for either direction, with an integration width in axis
  units shown as a band on the image. All fitting, seeding and tracking code
  would then be direction-agnostic. A results table would store `direction`,
  `scan`, `position`, `σ`, and so on, plus the axis names and units.
- **Physics difference.** MDC line shapes are close to Lorentzian (the
  self-energy approximation) on a smooth background. EDCs are cut by the Fermi
  function and broadened by resolution, and their backgrounds are often
  inelastic (step or Shirley-like). EDC mode should therefore offer an optional
  **Fermi-cutoff multiplier** reusing the OX_ARPES FDD functions (`fdd_fermi`,
  temperature from `info.temperature`, `E_F` fixed or fitted). It should also
  offer a **linear or step background**. Gaussian and pseudo-Voigt line shapes
  matter more for EDCs (resolution-limited quasiparticles).
- **Axis conventions.** Descending axes and kinetic versus binding energy
  should be preserved as given, and the window shown in the data's units. The
  Lorentzian width should be reported as **FWHM** (the old tool's `w` is the
  HWHM), with a documented conversion for legacy exports.
- **Dispersion tracking works the same in both directions.** The user picks a
  start slice, and the tracker walks along the scan axis in both directions
  (see §4.4).

*Trade-off:* a full-convolution EDC model (Lorentzian × FD ⊗ Gaussian) is
heavier and less identifiable. The recommendation is to start with a
multiplicative Fermi cutoff plus Gaussian or pseudo-Voigt peaks, and to defer
full convolution unless Calvin needs it.

### 4.4 Redesigned initial peak specification

**Current workflow and its pain points.** Add Peak → drag the blue line →
right-click → *Add New Point → to PeakN* → drag the marker, width and
background lines → repeat on a second slice, for every peak. There is no
default width (fixed at 1/8 of the axis), at least two seeds are required
(H1), seeds are spline-interpolated, and nothing previews the rows that will be
fitted.

**Proposal: three complementary ways to seed, one shared peak table.**

1. **Click to seed on the profile (primary).** In "Add peak" mode, clicking on
   the 1-D profile adds a peak at the click position. Its height comes from the
   data at that point minus the background, and its width from the local
   half-maximum crossing (a default if not found). Each peak then shows:
   - a draggable **centre marker** (position and height);
   - two draggable **half-width handles** at half maximum (FWHM);
   - a draggable **background line**.

   The model and component curves update **live** while dragging. Right-click
   or Delete removes the selected peak. This uses plain `line` objects with
   `ButtonDownFcn` and `WindowButtonMotionFcn`, so no IPT ROI objects are
   needed.
2. **Auto-find suggestions.** An "Auto-find" button runs base-MATLAB
   `islocalmax(I_smoothed,'MinProminence',p)`, with a prominence slider and a
   maximum count. Suggestions appear as hollow markers that the user can accept
   all at once or one by one with a click. Signal Processing `findpeaks` is not
   needed. Optional light smoothing (`smoothdata`, base MATLAB) would be used
   only for finding peaks, never for the fit.
3. **Draw a guide on the 2-D image (for tracking).** Clicking points along a
   band on the image creates a polyline seed for one peak across many slices.
   It would be interpolated with `pchip` (no spline overshoot) and extrapolated
   only within a user-set range. A single click also works: a single seed is
   valid and the tracker propagates it (fixing H1).

**Tracking replaces seed interpolation.** "Track" fits the current slice and
then steps outward slice by slice in both directions. Each slice uses the
**previous slice's fitted parameters** as its start, with gates for maximum
position jump (for example 2×FWHM), minimum amplitude or SNR, and an FWHM
range. A slice that fails a gate is flagged (shown as a hollow red point) and
either skipped or stops the walk, as configured. "Refit from here" restarts
from any slice the user fixes manually. Seeds from method 3, where present,
override the propagated start.

**Peak table** columns: ID (stable integer, unlimited peaks), on/off, colour,
position ±σ, height, FWHM ±σ, lock (hold fixed), and lower/upper bounds. Edits
in the table and on the plot stay in sync. Bounds would default to
data-derived values (position ±1 FWHM, FWHM within [2 Δu, span], height ≥ 0)
and **be enforced** (fixing H2).

*Trade-off:* full drag-and-drop editing is the largest GUI cost. A first
version could ship click-to-seed, auto-find, the table and tracking, and add
the 2-D polyline guide in a second step.

## 5. Proposed architecture for the new version

### 5.1 Placement and naming

Mirror the FDD upgrade. The new app would go in **OX_ARPES as
`GUI/PeakFit/`**, with the app class `PeakFit_app.m` and backend functions
prefixed `pkf_`. The yulinARPES browsers would only add menu items. This keeps
the new tool next to `OxA_*` data types and `fdd_*` functions it reuses. The
alternative is `yulinARPES/Fitting/PeakFit/`, next to the legacy tool, which
keeps everything in one repository but splits the modern GUIs across two.
**This needs Calvin's choice (Q1).**

| File | Responsibility |
|---|---|
| `PeakFit_app.m` | `uifigure` class: layout, callbacks, live preview, status; no physics |
| `pkf_input.m` | Normalise name/struct/`OxA_*` (+3-D slice) → internal struct; validation; read-only on source |
| `pkf_extract_profile.m` | Direction abstraction, integration width, NaN handling |
| `pkf_models.m` / `pkf_model.m` | Lorentzian, Gaussian, pseudo-Voigt; constant/linear/step background; optional Fermi cutoff (reuse `fdd_fermi`) |
| `pkf_find_peaks.m` | Prominence-based suggestions (`islocalmax`), width estimate |
| `pkf_initial_guess.m` | Height/width/background from data around a seed |
| `pkf_fit_profile.m` | Bounded Levenberg–Marquardt (adapted from `fdd_fit_edc`): σ from Jacobian, χ²ᵣ, convergence flag, empty/NaN guard |
| `pkf_track.m` | Bidirectional slice walking with gates, seeds and stop/skip policy |
| `pkf_export.m` | Results → struct/table; legacy-compatible `x,y` fields for `EmassFitting`/vF |
| `tests/TestPeakFitCore.m`, `tests/TestPeakFitGui.m` | Matlab unit tests (as for FDD) |

**Scriptable API** (shares the backend with the GUI):

```matlab
R = pkf_fit_profile(u, I, 'Peaks', seeds, 'Model','lorentz', 'Background','linear');
T = pkf_track(D, 'Direction','MDC', 'Start', 0.0, 'Seeds', seeds, 'MaxJump', 0.05);
app.setData(var); app.addPeak(pos); app.fit(); app.track(); S = app.exportResults('name');
```

Toolbox policy: base MATLAB only. No Curve Fitting, Optimization, Signal
Processing, Image Processing or GUI Layout Toolbox.

### 5.2 Output format

The result would be a struct or table with one row per (peak, slice):
`peakId, direction, scan, position, positionErr, height, heightErr, fwhm,
fwhmErr, background…, chi2red, converged, flagged`. A per-peak convenience
struct would carry legacy fields `x, y` (momentum and energy, whichever the
direction), so `EmassFitting` and the vF linear fit keep working. The vF fit
would be re-implemented with `polyfit` to drop the Curve Fitting Toolbox
dependency of `fit_MDC_tools`.

### 5.3 Compatibility and migration

- Leave `fit_MDC_demo_20150312.m` and `fit_MDC_tools.m` untouched initially,
  and add new menu items in v32 (Tools) and v5 (Analyze → Fit spectra), as was
  done for FDD.
- After acceptance, decide whether to retire the old menu items and move the
  unused `peakfit.m`/`PeakFinder/` into `legacy/` (Q5).
- Document the tool in `Manual_for_AI.md`, the skills map, an operation skill
  (for example `AI_skills/ox-arpes-peak-fit/SKILL.md`), and an improvement log.

### 5.4 Testing plan

1. **Numerical checks against an independent truth.** Synthetic cuts with known
   linear and parabolic bands, in both MDC and EDC orientation, should cover:
   - ascending and descending axes, and kinetic versus binding energy;
   - NaN columns and rows, and noise levels;
   - two overlapping peaks;
   - a Fermi cutoff for EDC.

   Each case would assert the position, FWHM and σ coverage (about 68% over
   repeated noise draws), and bounds enforcement.
2. **Edge cases:** a single seed, zero seeds, all-NaN slices (must be flagged,
   not given seed values), peaks at the window edge, tracking gate failures,
   and 3-D slice input.
3. **Data types:** a struct, `OxA_CUT`, and `OxA_MAP` slices; the source must
   be unchanged after a run.
4. **GUI behaviour:** call real callbacks (load, direction switch, click-seed,
   auto-find, track, stop, export with an overwrite prompt), then close and
   reopen. Also launch from both browser menus.
5. **Visual check:** a screenshot of the compact layout at realistic size, with
   no clipping.
6. **Measured data:** at least one measured cut (for example
   an i05 cut) in both directions. This would be recorded as a
   measured-data check, separate from the synthetic results.

## 6. Open design questions for Calvin

1. **Where and what name?** `OX_ARPES/GUI/PeakFit/PeakFit_app` (mirrors FDD;
   recommended) or `yulinARPES/Fitting/…`? What menu label (for example "Fit
   peaks (MDC/EDC) (new)"), and should the old "Fit MDC" items stay for now?
2. **Line shapes and backgrounds.** Is a Lorentzian plus constant or linear
   background enough for MDCs? For EDCs, do you want a Fermi-cutoff multiplier
   (T from `info.temperature`), Gaussian or pseudo-Voigt peaks, and a
   step/Shirley background? Is full resolution convolution needed in v1?
3. **Scope of input.** Is v1 for 2-D cuts only, or should it also take a slice
   of a 3-D map (kz/FS map) chosen inside the app? Is an integration width
   wanted by default, and in pixels or axis units?
4. **Results format and downstream use.** Should results be a table/struct in
   the workspace (`<source>_peaks`) with legacy `x,y` fields so `EmassFitting`
   and the vF fit keep working? Should widths be reported as FWHM, a change
   from the old HWHM `w`? Should results also be stored inside a copy of the
   data object?
5. *(Lower priority)* After the new tool is accepted, should we retire
   `fit_MDC_tools` (or fold vF/effective-mass fitting into the new app's Export
   step) and move the unused `peakfit.m`/`PeakFinder/` into `legacy/`?

## 7. Review limits

- No code was changed. All runtime checks used built-in or synthetic data in
  `matlab -batch` with invisible figures. Interactive dragging, `imrect`, modal
  dialogs and the browser Refresh path were assessed from source only.
- No measured ARPES data was fitted in this review.
- `peakfit.m` and `PeakFinder/` were scanned for callers and analyzer counts
  only. Their numerical behaviour was not reviewed, because nothing calls
  them.

## 8. Confirmed design decisions — 23 November 2026

Calvin's answers to section 6, and the recommendations he accepted:

1. **Placement:** new tool in `Fitting/PeakFit/` (`PeakFit_app` + `pkf_*`).
   It replaces **Fit MDC** in both browser menus as **Fit Peaks (MDC/EDC)**;
   `Fitting/fit_MDC_demo/` stays unchanged.
2. **Model:** pseudo-Voigt line shape with a shape menu (Lorentzian η = 1,
   Gaussian η = 0, Pseudo-Voigt η free); default Lorentzian for MDCs and
   Pseudo-Voigt for EDCs. Linear background with a **Flat background** option.
   EDCs: crop below E_F by default; optional **Fermi-Dirac cutoff** (off by
   default) with E_F and T held, T from `info.temperature`.
3. **Data:** 2-D cuts only; 3-D/4-D input is refused with a message to slice
   first. The source is never modified.
4. **Export:** new variable `<source>_peaks` (confirm before replacing), with
   legacy-compatible `x`, `y` plus FWHM, height, η, ±1σ, background, χ²_red,
   R² and settings.

Implementation choice beyond the answers: E_F defaults to 0 when the energy
axis spans 0, otherwise to hν − φ from `info` when that lies on the axis
(kinetic-energy cuts); the field is editable. Delivery and validation:
[PeakFit improvement log](PeakFit_improvement_log.md) and
[user guide](PeakFit_user_guide.md).
