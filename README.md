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
compatibility. GUI workflows require GUI Layout Toolbox; measured-data classes
and several tools also use the separate OX_ARPES package.

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
