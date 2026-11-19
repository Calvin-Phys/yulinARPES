# Browser v5 API and control reference

Read after [SKILL.md](../SKILL.md) when the basic public actions are insufficient.
Prefer the public facade to control internals.

## Public actions

| Action | Meaning |
|---|---|
| No argument or `open` | Open or raise this browser's singleton. |
| `read` | Return figure, visible names, selected names, active group, group labels, and type filter; create the browser if absent. |
| `refresh` | Re-scan the workspace and preserve selection by name where visible. |
| `select`, cell array of names | Select visible names; reject missing/hidden names. |
| `group`, integer 0–4 | Filter to all (0) or one of four groups. |
| `typefilter`, name | Choose `all`, `cut`, `map`, `kz`, `4d`, or `1d`. |
| `renamegroup`, integer 1–4, label | Set a 1–24 character label and persist it in MATLAB preferences. |
| `membership`, operation, target | Apply `add`, `move`, or `remove` to the selected scalar ARPES values. |

All actions establish the browser if it does not exist. Existing read/raise
operations do not reset filters or selection. Empty groups/searches have no
selection. Refresh is explicit, not a background synchronization service.

## Filters and grouping

| Type filter | Matching values |
|---|---|
| All | Every workspace variable, including ordinary values and legacy structs. |
| Cut | `OxA_CUT`. |
| Map | `OxA_MAP` and `OxA_MAP_ToF`. |
| KZ | `OxA_KZ`. |
| 4D / 1D | Corresponding `OxArpes_4D_Data` / `OxArpes_1D_Data` classes. |

Class matching uses `isa`; group and case-insensitive name search further
restrict the list. An absent row can be hidden by any of these filters.

Four numeric flags in `info.GroupInfo` remain compatible with v32. Add retains
other flags. Move clears the active source flag, adds the target, and preserves
unrelated flags; moving to the same group retains membership. Remove uses the
active group regardless of its target argument. Removal from the all view is
a no-op reported in the count label tooltip. Structs missing `info` receive a
struct; incompatible metadata and ordinary values are skipped and counted.
Group labels live in preferences, separately from the data flags.

## Inspect controls only when needed

```matlab
state = ARPES_data_browser_v5('read');
handles = guidata(state.figure);
```

Useful fields are `VarList`, `AxisTable`, `Metadata`, `GroupTarget`, `Search`,
`TypeFilter`, `EditVariable`, and `GroupTabs` / `GroupAll` / `Group1`–`Group4`.
Use the public group/select actions instead of changing table rows or parents.

`VarList` is a classic `uitable` with `Data` columns Name / Class / Size, not a
listbox with `String`/`Value`. Class cells can contain colour HTML; Name cells
remain literal. Selected rows are also stored as `SelectedRows` appdata. Storage
is the whole variable's `whos.bytes`, displayed with binary units and at most
three significant digits; it is not the array shape.

For a requested name search, set the `Search` control's `String` and invoke its
actual callback to apply it. Read the callback representation before dispatching
it; do not assume every callback is a bare function handle. Mutation reports
are in the count control's `TooltipString`.

## Details and external actions

Coordinate and metadata tables summarize the first selection. Coordinate units
are inherited, not inferred; nonuniform, missing, invalid, and mismatched axes
are identified. Metadata contains only `data.info` fields, or an empty table
when absent. These tables are read-only summaries.

`EditVariable` uses the same callback as the context-menu Edit Variable action,
opens the whole selected workspace value, and is disabled with no selection.
Enter and Plot selected plot the first selection through existing callbacks.
Right-click actions apply to the selected rows.

Native double-click handling uses the classic desktop JVM and bundled
`findjobj_2013` Swing adapter. The historical checks exercised actual Swing
event dispatch, including repeated clicks and tab changes; physical OS mouse
input remained unverified. Do not translate that limitation into a guarantee
of current platform compatibility. External processors retain their original
dependencies and scientific contracts.
