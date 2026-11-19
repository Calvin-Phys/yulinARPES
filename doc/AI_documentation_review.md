# AI documentation review and portability cleanup

Date: 19 November 2026. Scope: the root README, `AI_skills`, `doc`, and their
documentation visibility rules. MATLAB implementation and helper scripts were
not changed.

## Findings and changes

| Finding | Change |
|---|---|
| Skill discovery was spread across the README and historical session notes. | Added [SKILLS_MAP.md](../AI_skills/SKILLS_MAP.md) covering all five skills, their entry points, boundaries, and related workflows. |
| Agents needed a way to classify project instructions and supporting material. | The map distinguishes governing host constraints, current user intent, scoped project guidance, skills, technical references, historical evidence, and task data. It explains local versus host-catalog skill discovery. |
| Setup examples assumed personal checkout/install locations. | Added [shared setup guidance](../AI_skills/MATLAB_SETUP.md) and replaced literal locations with runtime resolution or explicit task inputs. Batch examples use per-job configuration. |
| Session-sharing guidance embedded a particular computer's process IDs, data names, and configuration snapshot. | Rewrote the [session guide](MATLAB_AI_session_sharing_review.md) as a portable procedure with version-qualified implementation details, parameterized guards, and explicit verification limits. |
| Browser v5 operation details formed one dense paragraph mixed with old test statements. | Kept the skill focused on operation and verification; moved detailed filters, membership semantics, and controls to [references/api.md](../AI_skills/arpes-data-browser/references/api.md). |
| Reviews mixed original defects, later fixes, and claims about a past live session. | Added dated-evidence labels, successor links, and an indexed reading order. Retained scientific contracts, meaningful observed results, and stated test limits. |
| Personal measurement identifiers appeared in prose and an image. | Removed measured-file/process/window identifiers, generalized hardware-specific examples, and removed the old browser comparison screenshot containing measurement variable names. Retained screenshots were visually inspected. |
| README test guidance treated all files as unit-test suites. | Listed the actual function-based unit suites and documented the assertion-based browser comparison separately, with dependency and GUI-state caveats. |
| Some existing skills and records could be omitted from a fresh checkout by ignore rules. | Added explicit exceptions for the intended skill directories, map, shared setup, and maintained Markdown records; removed the exception for the deleted screenshot. |

The root [README](../README.md) now introduces the package, routes interactive
users and agents, identifies dependencies, maps source folders, and provides
appropriate validation entry points. The [documentation index](README.md)
separates operational guides from dated implementation evidence.

## Review and validation

- Read all five skill entry points, their supporting Markdown, and the retained
  review/log records; checked key public API and test-routing claims against
  the corresponding source/help and setup function.
- Ran the skill-creator `quick_validate.py` on all five skills: all passed.
  This validates skill structure, not scientific behavior.
- Checked local Markdown destinations and heading anchors, fenced examples,
  TOML parsing, and coverage of every local skill in the map.
- Scanned the README, skills, references, and docs for personal absolute paths,
  known measurement identifiers, live process/window IDs, and model-specific
  evaluator labels. Synthetic examples and actual model defaults remain labelled.
- Verified both MATLAB helper scripts are byte-for-byte unchanged. Historical
  runtime counts were not presented as newly executed tests.
- Visually inspected every retained documentation PNG. The removed comparison
  screenshot had exposed measured workspace names; no fabricated screenshot was
  substituted for it.

Final repository validation also checks documentation visibility and whitespace
after application. No MATLAB execution, GUI interaction, skill installation,
dependency installation, or agent-host reconfiguration was needed for this
documentation cleanup. Compatibility and scientific accuracy remain limited to
the tests/revisions explicitly described in the dated evidence records.
