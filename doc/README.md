# Documentation index

For agent operation, start with the [AI manual](../Manual/Manual_for_AI.md)
and [skills map](../AI_skills/SKILLS_MAP.md). The repository
[README](../README.md) provides the short v5 launch path. The [manual](../Manual/Manual.md)
introduces the interactive processing workflow.

## Guides and navigation

| Document | Use it for |
|---|---|
| [Skills map](../AI_skills/SKILLS_MAP.md) | Skill summaries, task routing, instruction categories, and skill discovery. |
| [MATLAB setup](../AI_skills/MATLAB_SETUP.md) | Portable path resolution, dependencies, session ownership, and live/batch boundaries. |
| [MATLAB session sharing](MATLAB_AI_session_sharing_review.md) | Existing-session attachment, PID guards, version-specific connection pinning, and named Engine alternatives. |
| [Codex–MATLAB workflow log](codex_matlab_workflow_log.md) | Dated connection diagnostics, MCP restart behavior, and disconnect options. |
| [Documentation maintenance review](AI_documentation_review.md) | Scope, changes, validation, and limits of the portability/navigation cleanup. |

## Dated implementation evidence

The records below preserve findings and test results from particular revisions.
They are not instructions to repeat old actions, claims about the current
workspace, or release-wide certifications. Read the latest follow-up in each
record before treating an original finding as unresolved; inspect the current
source when deciding a new change.

| Area | Record | Context |
|---|---|---|
| Whole package | [Technical review](yulinARPES_review_report.md) | Initial source review and subsequent stabilization work. |
| Browser v32 | [Review](data_browser_demo_v32_review.md) | Legacy workflow, callback findings, fixes, and static-review limits. |
| Browser v5 | [Improvement record](ARPES_data_browser_v5_log.md) | Final recorded summary followed by superseded intermediate revisions, API changes, and synthetic checks. |
| `PlotSlices` | [Review and improvement record](PlotSlices_review.md) | Data representation, slicing, linked plots, mass-plot behavior, and remaining limitations. |
| `kz_plot` | [Review](kz_plot_review.md) and [skill validation](../AI_skills/arpes-kz-plot/references/validation-results.md) | Simulation model, managed overlays, callback behavior, and independent evaluation boundaries. |
| Plot BZ geometry | [Original review and fixes](plotBZ_V1_review.md) | Reciprocal geometry defects and initial corrections; later interface/dependency work is recorded separately. |
| Plot BZ interface and simulation | [Improvement log](plotBZ_V1_improvement_log.md) | Later GUI/API work, model conventions, scoped graphics, and dated validation. |
| PeakFit (MDC/EDC peaks) | [User guide](PeakFit_user_guide.md), [improvement log](PeakFit_improvement_log.md) and [fit_MDC_demo review](fit_MDC_demo_review.md) | Replacement of `fit_MDC_demo`: confirmed design, model, export contract and dated synthetic/measured validation. |
| Cross-skill history | [Development summary](../AI_skills/session_summary.md) | Historical skill/API development and evaluation; use the skills map for current routing. |

## Screenshots

Retained interface screenshots show synthetic fixtures or simulation settings:
[browser v5](ARPES_data_browser_v5_interface.png),
[compact browser](ARPES_data_browser_v5_compact.png),
[kz_plot](kz_plot_interface.png), [Plot BZ](plotBZ_V1_interface.png) and
[PeakFit](PeakFit_interface.png) (a measured cut under a synthetic variable
name; [example fits](PeakFit_example_fit.png)).
The [four-view simulation](plotBZ_V1_simulation_example.png) and
[styled simulation](plotBZ_V1_style_example.png) show calculated geometry.
These are historical illustrations, not proof of today's layout or numerical
results. An older browser comparison image containing measurement names was
removed during documentation cleanup.

## Keep evidence reusable

Use repository-relative links and runtime-resolved paths. Replace measured
filenames, live process/window identifiers, and personal directory layouts with
role descriptions or explicit session inputs. Keep dates, tested releases,
scientific units, numerical limits, and meaningful observed results. Label
examples and dated checks clearly, and avoid duplicating API contracts across
logs and operation skills.
