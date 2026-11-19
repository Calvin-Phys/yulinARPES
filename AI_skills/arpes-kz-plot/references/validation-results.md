# Independent kz_plot skill validation

> Historical validation record. Figure numbers are illustrative test targets,
> not instructions to select those figures in a new session. Use the
> [operation skill](../SKILL.md) for current task execution.

**Date:** 16 November 2026

**Environment:** Live MATLAB R2024a, version 24.1.0.2537033, through MATLAB MCP.

**Evaluator:** Independent agent given the skill and realistic user requests.

The independent evaluator's live MATLAB session was separate from the primary
desktop session. After independent validation, the primary agent also executed
the exact four add/update/delete calls below in the primary desktop session.
That repetition passed actual blue-color, count, default/sampling, retained
line/label identity, and deleted-handle checks. Figure 10 in the primary session
was left with one green default 85 eV curve; its existing Data Browser and
kz_plot windows remained open. Additional cases below refer to the independent
evaluator's session.

The evaluator read `SKILL.md` and `references/examples.md` before executing the
workflow. Figures 10 and 11 were absent initially. The tests used the bundled
`kz_plot_agent.m` helper and the actual GUIDE callback bindings, rather than
constructing equivalent curves independently. No production source changes were
needed during evaluation.

## Requested example sequence

After adding `Visualization` and this skill's `scripts` directory to the MATLAB
path, the following calls completed successfully:

```matlab
c80 = kz_plot_agent('add', 10, 80);
c95 = kz_plot_agent('add', 10, 95, 'Color', 'blue');
c85 = kz_plot_agent('update', 10, 80, 'NewPhotonEnergy', 85);
remaining = kz_plot_agent('delete', 10, 95);
```

These commands are intentionally mutating examples, not a safe-to-repeat test
on arbitrary pre-existing user figures. Inspect inventory before executing a
requested action or retrying after an uncertain outcome.

Observed checks:

- The first two calls created exactly two managed lines in figure 10.
- The 80 eV line used work function 4.5 eV, inner potential 15 eV, theta
  -15:1:15 degrees, green, and width 1.5 pt. It had 31 samples.
- Its actual XData and YData agreed with the documented kz and kx equations
  to absolute tolerance 1e-12 inverse angstroms.
- The 95 eV line's actual color was `[0 0.4470 0.7410]`. The two labels read
  `80 eV` and `95 eV`.
- Updating 80 to 85 retained both the line handle and label handle. The label
  changed to `85 eV` and stored photon energy changed to 85.
- Deleting 95 removed both its line and label. Figure 10 then contained one
  managed 85 eV curve.

## Additional requests exercised

| Request | Observable result |
|---|---|
| Change the 85 eV curve to theta -20:2:20, purple, width 2. | Passed: same line, 21 samples, actual purple RGB and line width 2. |
| Move the curve from figure 10 to figure 11. | Passed: same line and label now belonged to figure 11; figure 10 inventory was empty. |
| Change its energy to 85.5 eV. | Passed: metadata and label retained the fractional value; purple style and 2-degree step were retained. |
| List figure 11 without changing it. | Passed: curve data, UI fields, and selection remained unchanged. |
| Add another 85.5 eV curve in blue with defaults. | Passed: defaults reset independently of the previous purple curve's modified theta and width. |
| Update or delete an 85.5 eV curve without distinguishing the two. | Passed: both operations raised `kz_plot_agent:NonUniqueMatch`; curves, energies, fields, and selection were unchanged. |
| Delete only the blue 85.5 eV curve, retaining purple. | Passed: inventory color filtering and the `Curve` selector removed only the blue line and label. |
| Add a curve with theta step zero. | Passed: input rejected before graphics mutation; managed-curve count unchanged. |
| Add 70 eV with theta 15 down to -15 in steps of 4. | Passed: nine samples including the shorter final interval. The temporary curve was then deleted. |

An unrelated fixture line was added before the style/range update. Its handle,
the target's XLim and YLim, and its NextPlot state all survived that update.
Moving the managed curve also left the unrelated line intact. The fixture line
was deleted only after these checks.

## Final state and limits

The original line was moved back to figure 10 and explicitly restored to 85 eV,
green, work function 4.5 eV, inner potential 15 eV, theta -15:1:15, width 1.5.
It remained the same graphics object first created at 80 eV. Figure 10 and the
kz_plot panel were left open. The empty figure 11 fixture was removed using its
retained and verified ownership handle; no global figure cleanup was used.

An initial cleanup command was rejected by automatic approval review because
it proposed deleting figure 11 by number without retaining proof of ownership.
That block did not execute. The revised cleanup first retained the figure handle
containing the evaluator's own test curve, verified its contents, and deleted
that exact empty fixture after moving the curve out. It completed successfully.

All listed runtime checks passed. This validates the documented agent actions,
graphics identity, selection, defaults, model coordinates, and relevant plot
preservation. It does not establish experimental accuracy of the final-state
model or cover every invalid input, GUI platform, MATLAB release, or race with
concurrent human edits. Skill structural validation and static analysis are
recorded separately in the [historical session summary](../../session_summary.md).
