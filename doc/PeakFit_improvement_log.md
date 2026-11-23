# PeakFit improvement log

> Dated implementation evidence. For operation, use the
> [user guide](PeakFit_user_guide.md) and the
> [arpes-peak-fit skill](../AI_skills/arpes-peak-fit/SKILL.md). Recorded results
> describe the revision and runtime named here, not today's runtime.

## New MDC/EDC peak fitter — 23 November 2026

### Origin

The [fit_MDC_demo review](fit_MDC_demo_review.md) found the original
`fit_MDC_demo_20150312` tied to `data_browser_demo` globals, MDC-only,
Curve Fitting Toolbox-dependent, and storing half widths without uncertainties.
The confirmed design decisions are recorded at the end of that review. The new
tool was written from scratch in `Fitting/PeakFit/`; `Fitting/fit_MDC_demo/` is
kept unchanged for reference.

### Delivered

- `PeakFit_app.m` (handle class, uifigure 1100 × 660, `uigridlayout`): left
  workflow column Data → Direction and slice → Model → Peaks → Fit → Export;
  cut image in the centre; profile and residual on the right; editable peak
  table at the bottom; Idle / Fitting… / Done / Failed lamp and a Stop button.
- Backend `pkf_*`: `pkf_input` (2-D only, read-only normalisation),
  `pkf_extract_profile`, `pkf_direction`, `pkf_shape`, `pkf_lineshape`,
  `pkf_fermi`, `pkf_model`, `pkf_initial_guess`, `pkf_fit_profile` (bounded
  Levenberg–Marquardt adapted from OX_ARPES `fdd_fit_edc`, ±1σ, χ²_red, R²,
  NaN handling), `pkf_find_peaks`, `pkf_default_ef`, `pkf_track`
  (bidirectional, neighbour-seeded, jump gate, guides, Stop), `pkf_export`
  and `pkf_open_from_browser` (menu callback).
- Model: pseudo-Voigt with shared FWHM (Lorentzian η = 1, Gaussian η = 0,
  Pseudo-Voigt η free); linear background with a flat option; optional EDC
  Fermi-Dirac cutoff with E_F and T held.
- Menus: **Fit MDC** replaced by **Fit Peaks (MDC/EDC)** (tag `FitPeaksNew`)
  in v32 **Tools** and v5 **Analyze → Fit spectra**. Both call
  `pkf_open_from_browser`, which loads the selected cut or opens empty.
- Tests: `tests/test_PeakFit_core.m` (23) and `tests/test_PeakFit_gui.m` (12).
- `setup_yulinARPES` already adds `Fitting` with `genpath`, so no edit was
  needed. No `pkf_*` or `PeakFit_app` names existed before in yulinARPES or
  OX_ARPES (the old `peakfit.m` is a different name).

### Development findings

- uiaxes `CurrentPoint` is read-only, so pointer handlers take the point as an
  argument; hidden `simulateProfileClick`, `simulateImageClick`,
  `simulateDrag` and `simulateTableEdit` drive them in tests.
- `cla` does not delete children with hidden handles; the profile uses
  `delete(allchild(ax))` to avoid duplicated markers.
- The profile y-limits were left in manual mode from the previous draw, which
  clipped fitted peaks; limits are now computed from the data and fit inside
  the window, so detector-edge spikes outside it do not squash the plot.
- Seeds without `fwhm`/`height`/`eta` crashed `pkf_track`; missing fields are
  now filled with NaN, which the fitter replaces with data-driven guesses.

### Validation (MATLAB R2023a, Linux, `matlab -batch`)

Synthetic (Lorentzian band, 301 × 161, unit noise):

- Single MDC fit: centre 0.10007 ± 0.00016 (true 0.1), FWHM 0.0602 ± 0.0005
  (true 0.06), χ²_red 1.031, R² 0.9955, 4 iterations.
- Tracking from one seed: 161 / 161 slices accepted; max |centre error|
  0.00047, median 0.00010, median σ 0.00016.
- `test_PeakFit_core` 23 / 23 and `test_PeakFit_gui` 12 / 12 pass (after the
  y-limit fix as well).

Measured cut (Diamond i05, `OxA_CUT`, 1000 × 1040, θ −23.9…23.9°, E_kin
145.9…150.1 eV, T 7.05 K; Poisson weights from code):

| Profile | Model | Result |
|---|---|---|
| MDC, E_kin 147.45 eV ± 0.01, window [−11, 12]° | 2 × Lorentzian | centres −5.148 ± 0.026° and 8.601 ± 0.026°; FWHM 2.46 ± 0.09° and 1.71 ± 0.09°; R² 0.941 |
| MDC tracking 147.2–147.75 eV | same | 136 / 136 slices accepted |
| EDC, θ 1.8° ± 0.3, window [147.5, 148.35] eV | PV × Fermi (E_F = hν − φ = 148.133 eV, T 7.05 K) | centre 147.998 ± 0.002 eV, FWHM 0.48 ± 0.02 eV, η 0.47 ± 0.20; R² 0.990 |
| EDC, θ −5° ± 0.3, window [146.9, 147.95] eV (cropped) | PV | centre 147.408 ± 0.001 eV, FWHM 0.280 ± 0.003 eV, η 0.51; R² 0.992 |

χ²_red was 65–380 because the intensities are not raw counts; the σ values
are scaled by the residual variance. The source variable compared equal after
all fits. The GUI run (auto-find, fit, range, export) produced
`<source>_peaks` with 2 peaks over 136 slices.

Regression: Code Analyzer 0 messages on all 17 PeakFit/test files and both
browsers; `test_stable_entry_points` 5 / 5; `test_ARPES_data_browser_v5_layout`
passed. `test_ARPES_data_browser_v5` passed its menu section (all 45 dispatch
targets) and the plotting, group and NaN sections, then stopped at the known
line-153 assertion, which fails identically with the browser edits stashed
(clean `33ee1b9`).

Screenshots: [interface](PeakFit_interface.png) (synthetic variable name over
the measured cut) and [example fits](PeakFit_example_fit.png) (300 dpi).

### Limits and follow-ups

- 2-D cuts only; slice maps first.
- E_F and T are held in the cutoff; fit the edge with `FDD_fit_app` first if
  they are uncertain.
- FWHM is edited in the table; dragging changes centre and height only.
- **Auto-find** replaces the current peaks.
- A running MATLAB desktop needs `rehash path` (or a restart) to see the new
  folder and menu callback; reopen browser windows to get the new menu.
