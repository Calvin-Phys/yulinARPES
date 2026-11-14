# Third-party code

This directory contains active third-party packages separated from the main yulinARPES source folders. Keep each package's original license and attribution files with its source.

| Package | Use in yulinARPES | Path setup |
|---|---|---|
| `export_fig` | Figure export from `Visualization/subplot_output/subplot_output.m`. | Added by `setup_yulinARPES`. |
| `matGeom` | Optional dependency documented by `Others_uncertain/bxsf2mat/README.md`. | Its `matGeom` source folder is added by `setup_yulinARPES`. |

Other bundled dependencies remain beside the older feature code that uses them, including the Igor binary-wave reader and viewer components. They should only be relocated after their runtime paths are mapped and the affected workflows can be checked.
