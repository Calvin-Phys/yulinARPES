---
name: arpes-plot-bz
description: Configure crystal structure and plot 3D Brillouin zones, projected surface zones, bulk sections, and fixed-photon-energy or photon-scan ARPES simulations with yulinARPES plotBZ_V1 in live MATLAB figures. Use for BZ geometry and experimental-coverage planning, including overlays on existing figures.
---

# Plot BZ and ARPES measurement geometry

Use the MATLAB MCP tool in the existing desktop session when acting on its
figures. A separate batch process cannot modify those figures. Follow
[shared setup and session guidance](../MATLAB_SETUP.md), verify the intended
figures, then add the package and this skill helper:

```matlab
yulinRoot = fileparts(which('setup_yulinARPES'));
assert(~isempty(yulinRoot), 'Locate the yulinARPES checkout first.');
setup_yulinARPES;
addpath(fullfile(yulinRoot,'Visualization','plotBZ_V1'));
addpath(genpath(fullfile(yulinRoot,'third_party','matGeom','matGeom')));
addpath(fullfile(yulinRoot,'AI_skills','arpes-plot-bz','scripts'));
which plotBZ_V1
which plotbz_agent
```

Keep `plotBZ_V1.m` and its `.fig` together. Launch through the helper or
`plotBZ_V1`, rather than opening the `.fig` or running the layout builder.
Do not reset the path or clear unrelated figures. No measured data or sibling
OX_ARPES checkout is required.

## Configure and plot

Use `plotbz_agent` to avoid brittle pixel-based GUI automation. `configure`
starts from explicit defaults; `update` retains unspecified current settings.
Read [references/examples.md](references/examples.md) for full fields and scan
examples. Unknown field names are rejected. Inputs are validated before the
user's panel or target graphics change.

```matlab
p = plotbz_agent('configure',struct('system','Hexagonal','a',3.2,'c',5.2, ...
    'miller',[0 0 1],'bulkRange',[-1 1;-1 1;0 2]));
zones = plotbz_agent('plot','3d',2010);
scan = plotbz_agent('simulate',struct('mode','fixed','target','3d', ...
    'figure',2010,'photonEnergy',60,'polarMin',-15,'polarMax',15, ...
    'tiltMin',-10,'tiltMax',10));
```

Targets are `3d`, `surface`, `horizontal`, and `vertical`. The last three use
their corresponding BZ figure fields. `surface` is a projection onto the
cleavage plane. `horizontal` and `vertical` are actual bulk sections; their
simulation traces can be empty when that plane misses the sampled scan.
Choose a suitable plane offset or range when coverage is requested, and
report an empty intersection accurately.

Crystal lengths are in angstroms; reciprocal axes are in inverse angstroms;
angles are degrees. Centering is `P`, `I`, `F`, or `C` where supported. Miller
indices use the conventional reciprocal basis by default. The selected
normal becomes positive plot `kz`. `rotation3D` rotates BZs about that axis;
the scan's `azimuth` rotates the measurement slit about it. Surface projection
has its own `surfaceRotation`. `horizontalOffset` is a percentage of the
selected reciprocal normal, **not** an absolute `kz` value. Preserve this
distinction when translating user requests.

## Manage overlays and verify

`plot` adds BZ outlines; repeating it adds another outline set. `simulate`
replaces the managed simulation of the same mode and target on the current
axes, retaining the other mode. Each simulate call uses explicit defaults
for omitted scan parameters. Inspect state before retrying an uncertain call.
Default colours distinguish the measurement modes: orange for fixed hv and
purple for photon scans. Pass `color` to override either choice. The GUI retains
custom colours separately for each measurement mode.

```matlab
state = plotbz_agent('read');
items = plotbz_agent('list',2010); % Does not open the panel.
remaining = plotbz_agent('clear',2010,'simulation');
```

Clear kinds are `bz`, `simulation`, or `all`; they remove only this package's
tagged objects and never create a missing figure. For a requested subplot,
select its axes before plotting. Without subplot selection, the current axes
receive the overlay. Existing limits and view may hide geometry outside the
visible range; adjust them only when requested or needed to show the requested
coverage. Leave requested figures open.

Check returned graphics with `isgraphics` and inspect `plotbz_agent('list',fig)`.
The simulation result includes `Graphics`, `Figure`, `Axes`, `Parameters`, and
`Scan`; verify its parameters and finite momentum arrays. An empty `Graphics`
array is meaningful for a section miss. Report the crystal setting, Miller
basis/orientation, target figure/view, and simulation energy/angle ranges.

The simulation uses the free-electron final-state model with
`Ekin = photonEnergy - workFunction - bindingEnergy` and positive inner
potential added to the normal kinetic energy. Binding energy is positive
below the Fermi level. It predicts sampled momentum coverage, not intensity,
and omits photon momentum and band-dependent final states. Match instrument
angle conventions before interpreting it as a measurement plan.
