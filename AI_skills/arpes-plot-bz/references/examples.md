# Helper fields and examples

`plotbz_agent('defaults')` returns the complete crystal configuration.
`configure` resets to that baseline; `update` merges into current panel state.
The baseline is primitive cubic `a=b=c=3.1416`, all angles 90 degrees,
conventional `(001)`, one zone at the origin, zero rotations/offset, and both
optional 3D section outlines off. Crystal-system constraints derive dependent
lengths/angles. Explicit contradictory dependent values raise an error.

| Crystal field | Meaning |
|---|---|
| `system` | Cubic, Tetragonal, Orthorhombic, Hexagonal, Rhombohedral, Monoclinic, Triclinic |
| `centering` | P/I/F/C; only the 14 supported Bravais combinations are accepted |
| `a`, `b`, `c` | Conventional cell lengths in angstroms |
| `alpha`, `beta`, `gamma` | Conventional cell angles in degrees |
| `miller` | Nonzero integer row vector `[h k l]` |
| `millerBasis` | `conventional` (default) or `primitive` reciprocal basis |
| `bulkRange` | 3-by-2 integer matrix, start/end rows along primitive reciprocal b1/b2/b3 |
| `surfaceRange` | 2-by-2 integer matrix, start/end rows along primitive surface s1/s2 |
| `rotation3D`, `surfaceRotation` | Bulk or surface BZ rotation about the cleavage normal |
| `verticalAzimuth`, `verticalInPlane` | Vertical section's plane azimuth and 2D display rotation |
| `horizontalOffset` | Horizontal plane position, percent of the selected reciprocal normal |
| `showHorizontal`, `showVertical` | Show section outlines alongside the 3D BZ |

For cubic P/I/F; tetragonal P/I; orthorhombic P/I/F/C; hexagonal P;
rhombohedral P; monoclinic P/C; triclinic P. Rhombohedral uses equal lengths
and equal non-right angles. Monoclinic varies beta, with alpha=gamma=90.
Hexagonal uses gamma=120. `C` is base centering of the conventional ab face.

```matlab
% Face-centered cubic, conventional (111), followed by primitive indices.
p = plotbz_agent('configure',struct('system','Cubic','centering','F', ...
    'a',3.8,'miller',[1 1 1]));
plotbz_agent('plot','3d',2020);
plotbz_agent('update',struct('millerBasis','primitive'));
plotbz_agent('plot','surface',2021,struct('color','blue','lineWidth',1.5));
```

BZ style fields are `color` and `lineWidth`. Colors are black, blue, cyan,
green, magenta, red, yellow, white. Line width affects 2D outlines and the 3D
wireframe. Multiple BZ plot calls add outline sets.

Default BZ colours are black for 3D/surface, blue for horizontal sections,
and green for vertical sections; an explicit style colour overrides these.
The 3D section outlines share their respective 2D section colour controls.

## Simulation parameters

Each `simulate` starts with these defaults; pass the full desired parameters
when revising a simulation. UI edits alone do not update already plotted scans.

| Field | Default | Meaning |
|---|---:|---|
| `mode` | fixed | `fixed` or `photon` |
| `target` | 3d | `3d`, `surface`, `horizontal`, `vertical` |
| `figure` | 2010 | Positive integer target figure, never the control panel |
| `photonEnergy` | 60 | Fixed energy, eV |
| `workFunction` | 4.5 | Nonnegative work function, eV |
| `innerPotential` | 15 | Nonnegative inner potential, eV |
| `bindingEnergy` | 0 | Nonnegative energy below EF, eV |
| `azimuth` | 0 | Slit azimuth about plot +kz, degrees |
| `polarMin`, `polarMax`, `polarStep` | -15, 15, 1 | Fixed-hv polar angle range/maximum spacing, degrees |
| `tiltMin`, `tiltMax`, `tiltStep` | -15, 15, 1 | Tilt range/maximum spacing for either mode, degrees |
| `photonMin`, `photonMax`, `photonStep` | 20, 100, 2 | Photon scan range/maximum spacing, eV |
| `polarAngle` | 0 | Fixed polar angle during photon scan, degrees |
| `color` | orange (fixed), purple (photon) | orange, purple, blue, green, black |
| `alpha` | 0.25 | Surface opacity, 0 to 1 |

Angular ranges must be ordered and strictly within -90 to 90 degrees. Both
range endpoints are included; spacing is at most the requested positive step.
Each sampled axis is limited to 201 points. Equal endpoints fix a parameter,
so a nominal surface can reduce to a curve or point. Photon energies must exceed
work function plus binding energy.

Omitting `color` selects orange for fixed-hv mode and purple for photon scans.
An explicit colour overrides that default. The GUI's shared colour menu retains
an independent choice for each mode when switching between measurements;
script calls still apply their explicit defaults rather than inherit GUI state.

```matlab
% Two measurement modes alongside one set of 3D BZs.
plotbz_agent('configure',struct('a',3.8,'bulkRange',[-1 1;-1 1;0 3]));
plotbz_agent('plot','3d',2030);
fixed = plotbz_agent('simulate',struct('figure',2030,'photonEnergy',60));
photon = plotbz_agent('simulate',struct('mode','photon','figure',2030, ...
    'photonMin',30,'photonMax',90,'photonStep',2,'polarAngle',0, ...
    'tiltMin',-10,'tiltMax',10,'color','purple'));
assert(all(isfinite(photon.Scan.kz),'all'));
assert(all(isgraphics(photon.Graphics)));

% Surface XY projection, with the same independent rotation as surface BZs.
plotbz_agent('plot','surface',2031);
xy = plotbz_agent('simulate',struct('target','surface','figure',2031));

% Horizontal cuts at kz=3 angstrom^-1: offset is a percent of g_hkl.
% For primitive cubic (001), |g_hkl| = 2*pi/a.
a = 3.8;
plotbz_agent('update',struct('horizontalOffset',100*3/(2*pi/a)));
plotbz_agent('plot','horizontal',2032);
cut = plotbz_agent('simulate',struct('mode','photon','target','horizontal', ...
    'figure',2032,'photonMin',20,'photonMax',80));
% Graphics can be empty if the chosen plane misses the sampled scan.

% Read-only inventory and narrowly scoped clearing.
items = plotbz_agent('list',2030);
plotbz_agent('clear',2030,'simulation'); % BZs and measured data remain.
```

`list` returns entries with `Graphics`, `FigureNumber`, `Axes`, `Kind` (`bz` or
`simulation`), and `Parameters` (stored simulation metadata, empty for BZ).
The inventory has one entry per graphics object, not per zone or experiment.
Scan surfaces can use several objects for section segments. Do not infer the
number of experiments from inventory length.

## Vector output

Plot BZ output figures use the painters renderer on MATLAB releases before
R2025a. Each has an **Export vector PDF...** menu, which explicitly exports
vector content rather than relying on the screen renderer. Set `outputRoot`
to the chosen writable destination before scripted export:

```matlab
pdfPath = fullfile(outputRoot, 'coverage.pdf');
plotBZ_V1_vector_output(scan.Figure, pdfPath);
```

Use a requested destination and preserve existing files unless replacement
was requested. R2025a and newer ignore the legacy Renderer property; the
explicit vector-PDF export remains the supported path.
