---
name: arpes-peak-fit
description: Fit Lorentzian, Gaussian or pseudo-Voigt peaks in MDCs or EDCs of a 2-D ARPES cut with yulinARPES PeakFit_app / pkf_* (linear background, optional EDC Fermi cutoff, slice tracking, ±1σ export). Not for Fermi-edge fitting (OX_ARPES FDD) or 3-D maps.
---

# Fit MDC/EDC peaks with PeakFit

Follow [shared MATLAB setup](../MATLAB_SETUP.md). Code is in
`Fitting/PeakFit/` (added by `setup_yulinARPES`). Base MATLAB only.
Full interface: [user guide](../../doc/PeakFit_user_guide.md).

## Inputs

- A 2-D cut: `OxA_CUT` or a struct with `x`, `y`, `value` (`numel(x) × numel(y)`),
  optional `x_name/x_unit`, `y_name/y_unit`, `info.temperature`,
  `info.photon_energy`, `info.workfunction`. 3-D/4-D input is refused
  (`PeakFit:Not2D`); extract a slice first.
- Direction: **MDC** = profile along x at fixed y; **EDC** = profile along y
  at fixed x.

## Procedure

1. Check class, size, axis names/units and the energy reference (binding vs
   kinetic) before choosing slices and windows.
2. Pick a slice, integration half-width and a window that excludes detector
   edges and, for EDCs without the cutoff, the region above E_F.
3. Seed peaks: `pkf_find_peaks` / `app.autoFindPeaks` (replaces existing
   peaks) or explicit centres with `app.addPeak(c, 'FWHM', w)`.
4. Fit one slice; inspect R², residual and ±1σ before tracking.
5. Track with `fitRange` / `pkf_track`; check `nValid`, `flagged` and the
   rejected points; lower `MaxJump` or add guides if branches swap.
6. Export to a NEW variable (`<source>_peaks`); never overwrite the source.

```matlab
D = pkf_input(cut, 'cut');
[u, I] = pkf_extract_profile(D, 'MDC', E0, dE);
R = pkf_fit_profile(u, I, struct('centre', {c1, c2}), 'Shape', 'Lorentzian', 'Window', [a b]);
T = pkf_track(D, R.peaks, 'Direction', 'MDC', 'Start', E0, 'Range', [E1 E2], 'Window', [a b]);
S = pkf_export(T, D);  assignin('base', 'cut_peaks', S);
```

EDC with the Fermi cutoff: `'Fermi', struct('EF', EF, 'T', T_K)`;
`[EF, src] = pkf_default_ef(D)` gives 0 on binding-energy axes or hν − φ on
kinetic-energy axes. E_F and T are held; determine them with OX_ARPES
`FDD_fit_app` when unknown.

## Contracts

- Model: `height·(η·L + (1−η)·G)`, shared FWHM; Lorentzian η = 1, Gaussian
  η = 0, Pseudo-Voigt η ∈ [0, 1]. Background `c0 + c1·(u − window centre)`;
  `FlatBackground` fixes c1 = 0.
- Widths are FWHM (legacy `fit_MDC_demo` stored half widths).
- Export `peaks(k).x/.y` are data-axis coordinates: MDC x = centre, y = slice;
  EDC x = slice, y = centre. Top-level `x`, `y` copy peak 1.
- ±1σ is scaled by the residual variance; χ²_red is only absolute when
  intensities are counts (`'Weights','poisson'`).
- GUI agents: use public methods (`selectData`, `setDirection`, `setSlice`,
  `addPeak`, `autoFindPeaks`, `fitCurrentSlice`, `fitRange`, `exportPeaks`,
  `getState`); hidden `simulate*` methods reproduce pointer events in tests.

## Validation

`runtests({'test_PeakFit_core','test_PeakFit_gui'})`; dated results in the
[improvement log](../../doc/PeakFit_improvement_log.md).
