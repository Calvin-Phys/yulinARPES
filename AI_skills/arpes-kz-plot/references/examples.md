# Request examples and checks

Run setup in SKILL.md once in the live desktop session. These are real graphics
operations: do not rerun the whole example sequence on a user's existing
figures just to verify the helper. Verification should inspect the outcome of
the requested action. The development validation uses separate fixtures.

## Add two curves in figure 10

Request: "In figure 10, plot the simulation curve for 80 eV with default
parameters. Also plot a curve for 95 eV in blue."

```matlab
before = kz_plot_agent('list', 10);
c80 = kz_plot_agent('add', 10, 80);
c95 = kz_plot_agent('add', 10, 95, 'Color', 'blue');
after = kz_plot_agent('list', 10);
assert(numel(after) == numel(before) + 2);
assert(c80.WorkFunction == 4.5 && c80.InnerPotential == 15);
assert(c80.ThetaStep == 1 && numel(c80.Curve.XData) == 31);
assert(isequal(c95.Curve.Color, [0 0.4470 0.7410]));
```

## Update and delete by old energy

Request: "Update the 80 eV curve to 85 eV; delete the 95 eV curve."

The figure is 10 from the preceding request. If conversation context does not
identify a figure, inventory all managed curves first and determine whether a
unique matching target exists before editing.

```matlab
c85 = kz_plot_agent('update', 10, 80, 'NewPhotonEnergy', 85);
remaining = kz_plot_agent('delete', 10, 95);
assert(isequal(c85.Curve, c80.Curve)); % when retained from previous operation
assert(~isgraphics(c95.Curve) && ~isgraphics(c95.Label));
assert(c85.PhotonEnergy == 85);
```

## Change angle range and style without changing energy

Request: "For the 85 eV curve in figure 10, use theta -20 to 20 in 2 degree
steps, color purple, and line width 2."

```matlab
c = kz_plot_agent('update', 10, 85, 'ThetaStart', -20, 'ThetaEnd', 20, ...
    'ThetaStep', 2, 'Color', 'purple', 'LineWidth', 2);
assert(numel(c.Curve.XData) == 21 && c.LineWidth == 2);
```

## Move the selected curve and retain settings

Request: "Move that 85 eV curve from figure 10 to figure 11."

```matlab
c = kz_plot_agent('update', 10, 85, 'TargetFigure', 11);
assert(isequal(ancestor(c.Curve, 'figure').Number, 11));
assert(isequal(ancestor(c.Label, 'figure').Number, 11));
```

## Disambiguate same-energy curves

Request: "Delete the blue 85 eV curve in figure 11; keep the purple one."

```matlab
curves = kz_plot_agent('list', 11);
matches = find(abs([curves.PhotonEnergy]-85) <= 1e-8 & strcmp({curves.Color}, 'blue'));
assert(numel(matches) == 1, 'Need a unique blue 85 eV curve.');
kz_plot_agent('delete', 11, 85, 'Curve', curves(matches).Curve);
```

If two blue curves match, inspect angle range or other requested qualifiers;
otherwise ask the user which curve they intend. The helper refuses an ambiguous
energy-only mutation without modifying the plot.

## Inventory and slider semantics

Request: "List the simulated curves in figure 11 without changing them."

```matlab
curves = kz_plot_agent('list', 11);
for k = 1:numel(curves)
    fprintf('Figure %g: %g eV, %s, theta %g:%g:%g\n', ...
        curves(k).FigureNumber, curves(k).PhotonEnergy, curves(k).Color, ...
        curves(k).ThetaStart, curves(k).ThetaStep, curves(k).ThetaEnd);
end
```

For a request such as "change this curve to 85.5 eV", use
`NewPhotonEnergy=85.5` through numeric entry; do not round it to suit the slider.
The helper synchronizes the slider but does not simulate dragging it.
