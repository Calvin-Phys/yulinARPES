---
name: arpes-kz-plot
description: Add, inspect, update, style, move, or delete simulated photon-energy cut overlays in live MATLAB figures using yulinARPES kz_plot. Use for requests naming figure numbers and photon energies or referring to existing kz_plot curves; measured-data conversion belongs to arpes-browse.
---

# Manage kz_plot simulation curves

Use the MATLAB MCP execution tool in the existing desktop session. Curves live
in that session's figures; a separate batch process cannot edit them. If the
live session is unavailable, report that limitation rather than claiming that a
batch run modified its figures. Do not reset the MATLAB path or clear figures.

## Setup

Follow [shared setup and session guidance](../MATLAB_SETUP.md). Verify the
intended live figures, then resolve the checkout and add this skill helper:

```matlab
yulinRoot = fileparts(which('setup_yulinARPES'));
assert(~isempty(yulinRoot), 'Locate the yulinARPES checkout first.');
setup_yulinARPES;
addpath(fullfile(yulinRoot, 'Visualization'));
addpath(fullfile(yulinRoot, 'AI_skills', 'arpes-kz-plot', 'scripts'));
which kz_plot
which kz_plot_agent
```

No measured data, OX_ARPES classes, or GUI Layout Toolbox is required. The helper
uses the saved GUIDE controls/callbacks, so keep `kz_plot.m` and `kz_plot.fig`
together. It opens or reuses the singleton panel; do not run the layout builder
or open the `.fig` alone for normal operation.

## Translate a request into actions

Use the bundled `kz_plot_agent` helper. Read its help if a less common option is
needed; [references/examples.md](references/examples.md) contains complete
examples, selection details, and verification patterns.

```matlab
% Read-only inventory (does not open the control panel).
curves = kz_plot_agent('list', 10);

% Explicit defaults are reset for each ADD, independent of current UI fields.
c80 = kz_plot_agent('add', 10, 80);
c95 = kz_plot_agent('add', 10, 95, 'Color', 'blue');

% UPDATE loads the matched curve first; unspecified parameters are retained.
c85 = kz_plot_agent('update', 10, 80, 'NewPhotonEnergy', 85);
remaining = kz_plot_agent('delete', 10, 95);
```

For **add with defaults**, use work function 4.5 eV, inner potential 15 eV,
theta -15 to 15 degrees with step 1 degree, green, width 1.5 pt. Photon energy
and target figure come from the request, overriding the panel's 60 eV/2010
defaults. Repeating `add` intentionally adds another curve; inspect inventory
before retrying a call whose outcome is uncertain.

For **update**, the positional energy selects the OLD curve. Supply the new
value with `NewPhotonEnergy`. Editing the slider/energy field alone does not
change a plotted curve; the helper invokes **Update** explicitly. Never emulate
update with delete-and-add; retain the graphics object's identity.

For **delete**, remove only the selected managed line and its associated label.
Never clear axes or delete all lines to accomplish this. Existing measured
images, BZ outlines, and other curves must remain available.

Selection uses the actual target figure plus photon energy, with an absolute
energy tolerance of 1e-8 eV. Zero or multiple matches raise an error before UI
fields or plots change. If several curves match, inspect their angles/colors
and use the request's qualifiers. Pass the matching inventory entry's `Curve`
handle as `'Curve', curves(k).Curve`; ask for clarification only when those
qualifiers cannot distinguish the intended curve. Do not silently take the first
list row. Refresh/re-list after mutations; row positions are not stable IDs.

If a target has multiple axes, `kz_plot` uses its current axes. For a specifically
requested subplot, select that axes handle before adding. Omitted subplot
selection means the current axes, not a new axes replacing existing data.

## Verify and report

The helper checks the returned graphics, stored parameters, and label. Also
inspect `kz_plot_agent('list', figureNumber)` for the requested final energies,
colors, and counts. For an update, verify that the returned `Curve` is the same
handle as before. For a deletion, a retained deleted handle should fail
`isgraphics`. Report figure number, final energies/styles, and any ambiguity.
Leave the requested figures open.

The model plots horizontal kz and vertical kx in inverse angstroms, at the Fermi
level, using `Ekin = photonEnergy - workFunction` and an inner-potential offset.
It is a simulated cut, not a measured-data k-space conversion. Fractional photon
energies are supported by numeric entry even though the slider snaps to 1 eV.
Theta step is a positive magnitude; descending ranges and a shorter final
interval are supported. Existing axes keep their view, so a valid new curve can
be outside the visible limits; change limits only if requested or needed for an
explicit request to show the full curve.

Managed curves are tagged `kz_plot_curve` with `kzPlotParameters` appdata. The
panel can recover them after reopening while target figures remain open.
Untagged curves from old versions cannot be identified safely by this helper.
