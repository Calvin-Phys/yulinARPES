# yulinARPES

MATLAB software from the Chen group for loading, processing, fitting, and
visualising angle-resolved photoemission spectroscopy data.

## Quick start

In MATLAB, make the checkout root the current folder and run:

```matlab
setup_yulinARPES;
ARPES_data_browser_v5;
```

[`ARPES_data_browser_v5.m`](ARPES_data_browser_v5.m) is the primary entry point.
[`data_browser_demo_v32.m`](data_browser_demo_v32.m) is **legacy**, retained for
compatibility. Browser v5 itself uses built-in MATLAB layout components and
does not require GUI Layout Toolbox. Legacy v32 and some launched tools,
including `PlotSlices`, still require it. Measured-data classes and several
tools also use the separate OX_ARPES package.

Use **Load → Export NXmpes...** in browser v5, or
**Loader → Export NXmpes...** in legacy v32, to select workspace datasets
and save a NeXus file. This opens `export_nxmpes_UI` from the separate
OX_ARPES `GUI` folder, which must be on the MATLAB path.

**Analyze → Fit spectra → Fit Fermi-level (new)** in browser v5, or
**Tools → Fit Fermi-level (new)** in legacy v32, opens `FDD_fit_app`, the
toolbox-free Fermi-edge fitter from the OX_ARPES `GUI/FDD` folder (which must be
on the MATLAB path). The original **Fit Fermi level** entry is kept above it.

## Documentation

- [User manual](Manual/Manual.md): interactive workflows and background.
- [AI manual](Manual/Manual_for_AI.md): setup, dependencies, package structure,
  agent entry points, session handling, and validation instructions.
- [Skills map](AI_skills/SKILLS_MAP.md): choose a skill and understand instruction
  categories and discovery.
- [Review and maintenance records](doc/README.md): dated evidence and limitations.

The software reflects contributions from many generations of group members.
Feedback, fixes, and new functions are welcome.

## License and contact

Project-owned code is [GPL-3.0-only](LICENSE). Bundled third-party components
retain their own licenses and attribution.

Contact: Cheng Peng <cheng.peng@physics.ox.ac.uk>

[Chen Group | ARPES at Oxford](http://www.arpes.org.uk)
