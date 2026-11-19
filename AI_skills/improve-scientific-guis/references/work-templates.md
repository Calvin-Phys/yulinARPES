# Adaptable planning, delegation, and evidence templates

Use the portions that fit the request. Replace sample values with observed
facts; these templates do not authorize new actions or require extra artifacts.

## Compact improvement plan

```markdown
# <Program> improvement record
Date / runtime / checkout:
Request and current status:
Prior notes read / existing edits to preserve:

| User outcome | Contract to preserve | Implementation owner | Acceptance evidence |
|---|---|---|---|
| Clean layout | Entry point and useful control semantics | ... | Fresh launch + screenshot |
| Reliable new behavior | Units, frames, valid/degenerate cases | ... | Independent numerical cases |
| AI control | Same backend, explicit defaults and ownership | ... | Realistic API workflow |

Implementation decisions and why:
Validation performed (command/scope, release, result, warnings):
Visual artifacts and what was inspected:
Remaining limitations / unperformed checks:
Final user-visible state and launch/API path:
```

Keep the current status accurate. Add dated follow-up sections for subsequent
feedback; do not leave an old test count looking like the final acceptance result.

## Scoped implementation handoff

```text
Outcome: <concrete behavior or artifact>.
Read: <minimum source/contract/context>.
You own: <specific files or directory>.
Other owners: <paths/interfaces to coordinate; do not edit them concurrently>.
Interface: <input/output schema, tags, units/frames, defaults, state ownership>.
Runtime access: <who may mutate the live session/layout and when>.
Preserve: <existing user state, callbacks, data, working-tree edits>.
Validate: <checks appropriate to this task>.
Report: files changed, behavior, evidence, unresolved issues, and stable-for-QA status.
```

Before integration, resolve interface changes and ask owners to stop editing
the version under test. Serialize callbacks/GUI mutation if tools share state.
Use models suited to the uncertainty and authorized environment, not a mandatory
brand or fixed hierarchy. Simple independent work may need no delegation.

## Independent skill evaluation

```text
Use <skill path> to perform this realistic request: <goal>.
Available inputs: <minimum raw artifacts and permitted environment>.
Permitted side effects: <isolated output location/owned test figures>.
Report observable results, unexpected behavior, warnings/errors, and what you
cleaned up. Do not change implementation during this evaluation.
```

Keep expected answers, suspected bugs, and proposed fixes out of the evaluator's
brief unless necessary for the requested task. The primary agent compares the
actual outcome with independent evidence afterward. If execution is unavailable,
label the result a review or dry run, not a completed behavioral test.

## Evidence matrix

| Layer | Useful evidence | Does not establish |
|---|---|---|
| Source review | Dataflow, lifecycle, ownership and validation findings | Runtime correctness |
| Static analysis | Counts and classified notices on named changed files | Scientific validity or clean layout |
| Numerical tests | Analytical invariants, non-default and boundary cases | Callback wiring or appearance |
| GUI/API tests | Actual saved callbacks, outputs, state preservation, warnings | Visual readability at all DPI settings |
| Visual inspection | Fresh GUI/plot images with size/scaling context | Numerical correctness |
| Export inspection | Expected format/content on representative artifacts | Every future export is identical |
| Independent skill task | Agent can complete a realistic request using the skill | Broad compatibility beyond the exercised environment |

Choose evidence that can fail for a meaningful regression. Do not pin tests to
incidental per-face object counts, exact file byte lengths, or documentation
wording when those are not user-visible contracts.

## Skill session-summary addition

```markdown
## <Program/skill> — <date>
Purpose and skill/helper paths:
New or changed API defaults, selection, update/clear/export semantics:
Setup and actual runtime used:
Validation performed and observable results:
Independent evaluation (or state that none was performed):
Tool/validator limitations and clearly identified fallback checks:
Detailed implementation log and visual evidence links:
```

For the user handoff, lead with what works now, then the material validation,
paths to the skill/log/preview, and any practical limitations. Detailed history
belongs in the record, not in the final chat response.
