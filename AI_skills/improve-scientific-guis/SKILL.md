---
name: improve-scientific-guis
description: Improve an existing scientific program's GUI, code structure, scriptable AI interface, and validation workflow. Use for coordinated modernization or maintenance of MATLAB/yulinARPES and similar scientific tools, including reviews, evidence logs, and authorized subagent work; routine use of an existing plotting tool belongs to its operation skill.
---

# Improve scientific GUIs with reviewable evidence

Apply this workflow to the requested scope. It comes from the kz_plot and
plotBZ_V1 improvement sessions; the goal is a usable interface, trustworthy
scientific behavior, and an interface another agent can operate reliably.
Use the [skills map](../SKILLS_MAP.md) to separate maintenance from operation
and the [shared runtime guide](../MATLAB_SETUP.md) before live checks.
Scale the work to the change: a label adjustment does not need a full redesign,
new automation framework, or new regression suite.

Read [the experience record](references/experience-record.md) for the observed
failures and MATLAB-specific details, especially when changing GUIDE layouts,
graphics state, or rendering. Use [work templates](references/work-templates.md)
when coordinating implementation or recording evidence. They are editable
starting points, not required deliverable counts.

For overlay and lifecycle work, go directly to
[axes state](references/experience-record.md#axes-state-includes-more-than-limits)
and [singleton initialization](references/experience-record.md#raising-a-singleton-must-not-reset-configuration).

## Establish the contract before editing

Inspect the actual checkout, applicable project instructions, existing edits,
prior review notes, entry point, saved layout, callbacks, numerical helpers,
tests, operation skills, and installed runtime. Resolve a likely path typo by
checking nearby filenames. Confirm which requested improvements already exist.

Turn the request into observable outcomes and identify what must survive:
scientific conventions, supported parameter families, callback tags, measured
data, user figures, selected axes, and existing custom settings. Trace a control
through its readers and writers before removing it. Removing a diagnostic
display does not imply removing the calculation it displays.

Record a short plan, ownership boundaries, and acceptance evidence in the
program's existing review/log location. Separate the user's stated preferences
from design choices made for this program. Do not turn a successful three-column
layout, colour palette, or range-crossing policy into a rule for every GUI.

## Tidy the interface around the user's work

- Group controls by decisions and workflow, with consistent spacing, aligned
  inputs, visible units, and clearly named actions. Put primary controls before
  advanced options. Hide or remove output-only clutter when it does not help a
  decision; retain useful diagnostics through an API or optional view if needed.
- Use a readable heading hierarchy. Bold titles, restrained level colours, and
  consistent semantic colours can make sections and overlays easy to associate.
  Keep text labels as well as colour distinctions; respect explicit style edits.
- Choose appropriate controls: numeric entry for precision, spinners for integer
  indices, and synchronized sliders where useful. Define stepping, endpoints,
  inactive fields, paired-bound crossing, and validation behavior explicitly.
- Keep separate state for independently styled modes. Switching a mode should
  restore its settings rather than silently apply another mode's colour.
- Keep the saved layout and its source definition synchronized. Reopen the actual
  saved GUI and inspect it at realistic window size and display scaling. Parent
  bounds checks do not detect overlapping siblings or clipped text.

Prefer a staged cleanup that preserves tested behavior. A GUI framework migration
is a separate design decision, not a prerequisite for making a legacy tool tidy.

## Improve code and scientific contracts together

Separate input parsing, validated numerical calculations, graphics ownership,
and GUI callbacks. Share implementation between related views; keep callbacks
small enough to inspect. Preserve required legacy signatures/tags while removing
unbound dead boilerplate. Use descriptive names, readable blocks, public help
text, explicit units, and comments explaining non-obvious invariants.

Validate before changing controls or graphics. Cover finite real values,
physical constraints, integer/nonzero conditions, compatible choices, range
ordering, sample counts, and practical allocation limits. Define how inactive
parameters are treated: ignore them deliberately or validate them before storing
them, rather than accepting values that fail on the next mode switch.

Document coordinate frames, angle signs, energy conventions, basis choice,
projection versus intersection, and relative versus absolute offsets. Return
empty results for legitimate misses. Preserve previously verified geometry when
adding visual features, and test any intentional coordinate change explicitly.

Tag or retain handles for owned graphics. Clear/update only the intended managed
objects, with explicit scope across modes, views, axes, and figures. Preserve
measured data and axes state, including automatic/manual limit modes, view,
aspect ratio, and NextPlot. Avoid changing unrelated root graphics defaults.

Remove unnecessary dependencies when a small documented implementation suffices.
Check installed-version help and authoritative documentation for API changes;
do not assume a renderer setting guarantees vector output on every release.
Optimize or add caching when measured behavior justifies it.

## Make AI control a maintained interface

Provide a small scriptable facade using the same validated backend as the GUI.
An adapter to stable GUI tags is practical for legacy code; independently
callable numerical functions are the longer-term foundation. Avoid duplicating
scientific formulas in an agent-only implementation.

Make these semantics explicit where the program needs them:

| Action | Contract to specify |
|---|---|
| Configure/defaults | A deterministic baseline and the meaning of omitted fields |
| Update | Which existing values are retained |
| Read/list | What state is inspected; whether the panel is opened; no reset of selections |
| Plot/add | Whether repeated calls accumulate graphics |
| Replace/update | Matching identity and handling of zero/multiple matches |
| Clear/delete | Exact ownership and axes/figure/mode scope |
| Export | Target, format, overwrite behavior, and vector/raster content |

Reject unknown option names and ambiguous selection. Return handles, effective
parameters, and numerical results sufficient to verify the outcome. Keep GUI
defaults and API defaults aligned unless a difference is intentional and stated.
Exercise mode changes through the correct callbacks/state transitions.

Create or update the program's operation skill with minimal setup, supported
actions, units, examples, selection semantics, and verification. Keep substantial
field tables in linked references. Distinguish a skill saved in the repository
from one installed for automatic discovery. Use the live MATLAB session for its
existing figures; batch execution has separate state and must save its results.

## Review and test what users can observe

Combine checks according to risk:

1. **Static and manual review:** analyze changed files, then inspect lifecycle,
   validation, state ownership, duplicated logic, and dependency changes. Classify
   notices; neither an empty analyzer report nor a smaller line count proves
   correctness. Explain deliberate compatibility notices.
2. **Numerical checks:** use analytical invariants and independent cases, including
   non-default, centred/low-symmetry, boundary, invalid, and degenerate inputs
   relevant to the change. Do not use the implementation as its only oracle.
3. **Behavioral checks:** invoke actual saved callbacks and the public agent API.
   Verify graphics and stored parameters, replacement identity, preservation of
   unrelated data, mode switching, and close/reopen/raise behavior. Inspect
   warnings as well as assertions: cleanup failures can coexist with a pass.
4. **Visual and export checks:** capture a fresh interface and representative
   plots, inspect clipping/overlap, colour associations, axes, and missing data.
   Test the exported artifact when export is requested; a screenshot is not proof
   of vector content. Artifact checks apply to the tested example, not all future
   plots or mixed image/vector data.

Use isolated fixtures and track owned figures/files. Check whether execution
tools share a session before running concurrent GUI mutations; never infer
isolation merely from having different agents. Restore temporary path/state and
close only owned test objects. Preserve the user's requested final figures.

After relevant checks pass, stop broadening tests without a new change, failure,
or unresolved concern. Apply evidence-based fixes rather than accumulating
speculative requirements.

## Coordinate agents and finish the record

When delegation is authorized and useful, let the primary agent own the plan,
contracts, integration, live GUI session, and final acceptance. Delegate bounded
tasks with disjoint writable files, inputs, expected interfaces, and a definition
of done. Agree control tags, field schemas, coordinate conventions, and callback
order early. Choose agent capability according to uncertainty; no fixed model
name or number of agents is required.

Share contract changes promptly. Serialize shared runtime mutations. Have owners
announce when files are stable before integration tests; reopen/reload changed
code and saved layouts where needed. Review contributions instead of treating
agent completion messages as acceptance evidence. For a substantial operation
skill, an independent realistic task can expose wrong defaults or lifecycle
assumptions; do not supply the expected answer to that evaluator.

Keep current status and final evidence easy to find in the program log. Record
what changed, why, checks/release/results, visual artifacts, remaining limitations,
and user feedback. Keep historical results dated so old counts do not appear to
describe the final version. Update the skill session summary with API/skill
changes and validation. Check that intended deliverables are not hidden by ignore
rules; use narrow exceptions if needed and preserve unrelated working-tree edits.

Hand off the concrete result, relevant evidence, launch/invocation path, and
material limits. Describe a blocked validator as blocked, with alternative checks
clearly distinguished. Do not claim unperformed scientific or measured-data
validation, automatic skill installation, or compatibility beyond the tested scope.
