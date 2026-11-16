# yulinARPES: Chen group ARPES data processing software

This repository is designed to organize and maintain the current ARPES data processing software used in Chen's group, ensuring it remains up-to-date for all users. It is an ongoing project and will be updated periodically.

A user manual is available at [Manual/Manual.md](Manual/Manual.md).

## Quick start

Use MATLAB 2022a–2024a as described in the manual. From MATLAB, add this checkout to the path and run the setup function:

```matlab
addpath('/path/to/yulinARPES')
setup_yulinARPES
data_browser_demo_v32
```

The setup function adds the maintained code folders and the active support packages. It does not add the archived code. The GUI workflows also depend on the separate OX_ARPES checkout and GUI Layout Toolbox 2.3.5; install/add those as described in the manual.

## Repository map

| Folder | Contents |
|---|---|
| `Data_enhance` | Symmetrisation, interpolation, curvature, and related enhancement tools. |
| `Data_process` | Data combination, grid repair, and processing tools. |
| `Fitting` | Peak, dispersion, and Fermi-edge fitting tools. |
| `Loader_kconvert` | Format readers and momentum-conversion tools. |
| `Visualization` | Plotting, viewers, and figure export interface. |
| `Others_uncertain` | Older and less-classified helper utilities; use only when needed by a workflow. |
| `third_party` | Active third-party libraries kept separate from project code. |
| `archive` | Superseded copies retained for reference; do not add to the MATLAB path. |
| `Manual` | User guide and related material. |
| `doc` | Review and maintenance documents. |

Some older GUI tools use the MATLAB base workspace. Save the original measurement files separately and review the selected inputs and output paths before running write/export operations.

## Focused checks

Run the small project-owned checks from the repository root with MATLAB:

```matlab
results = runtests(fullfile(pwd, 'tests'));
assertSuccess(results)
```

These checks cover numeric GUI input parsing and the validated entry points for 2-D to 3-D rearrangement. They do not replace tests with representative beamline files or a GUI walkthrough.

## Active and archived dependencies

- `third_party/export_fig` is used by the subplot figure-export tool.
- `third_party/matGeom` is an optional dependency for the BXSF utility under `Others_uncertain/bxsf2mat`.
- `Visualization/plotBZ_V1` uses the bundled `third_party/matGeom` geometry functions and MATLAB's `rotx`/`rotz` from Phased Array System Toolbox. Add the package with `setup_yulinARPES` before opening Plot BZ.
- `archive/third_party/export_fig_2013` is an older duplicate of the active export_fig package. It is retained but excluded from setup.
- `archive/legacy/+LoadDataARPES_old` is an older loader-package copy with no in-repository references found during review. The current `+LoadDataARPES` package remains under `Loader_kconvert`.

The yulinARPES software and functions are the collective contributions of numerous group members across various generations (the full list can be found on the [group website](http://www.arpes.org.uk/People.html)).

This repository aims to serve as a valuable resource for storing, publishing, and bringing together the knowledge and efforts of past and present contributors.

Everyone is encouraged to provide feedback, contribute new functions, or help maintain the software. Your input and collaboration are greatly appreciated.


---
Contact: Cheng Peng <cheng.peng@physics.ox.ac.uk>

Group web: [Chen Group | ARPES at Oxford](http://www.arpes.org.uk)
