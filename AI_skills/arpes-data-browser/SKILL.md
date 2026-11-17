---
name: arpes-data-browser
description: Operate ARPES_data_browser_v5 in the live MATLAB session to inspect workspace variables, select data, and manage four compatible ARPES groups.
---

# ARPES browser v5

Use MATLAB in the yulinARPES checkout with GUI Layout Toolbox available. Launch `ARPES_data_browser_v5`; it returns a figure and raises its own singleton independently of v32. This repository skill is not installed for automatic discovery.

Use the entry point as the scriptable facade:

```matlab
ARPES_data_browser_v5('refresh');
state = ARPES_data_browser_v5('read');
ARPES_data_browser_v5('typefilter', 'all'); % all workspace variables; cut/map/kz/4d/1d also supported
ARPES_data_browser_v5('group', 0); % all; groups 1 through 4 also supported
ARPES_data_browser_v5('select', {'myData'});
ARPES_data_browser_v5('membership', 'add', 2);
ARPES_data_browser_v5('renamegroup', 2, 'Photon scans');
```

Read returns figure, visible names, selected names, active group, group names and typeFilter without resetting state. Refresh preserves selection by name if it remains visible. Selection rejects hidden or missing names. Empty groups/searches return no selection. Search uses the `Search` edit control; set String then invoke its Callback to apply it.

Membership edits the selected scalar ARPES values in the base workspace. Add retains other groups. Move removes the active source group and adds the target; other flags survive, and moving to the same group retains membership. Remove uses the active group, regardless of target argument; all-view removal is a no-op with a message in the count label's tooltip. Structs missing INFO receive a struct; incompatible metadata/ordinary variables are skipped and counted. Four numeric flags in `info.GroupInfo` are compatible with v32. Names (1–24 characters) persist in MATLAB preferences, not data files; flags persist only when the data are saved.

To inspect controls use `guidata(state.figure)`: VarList, AxisTable, Metadata, GroupTarget, Search, TypeFilter, EditVariable. VarList is now a classic uitable with Data columns Name/Class/Size (CUT/MAP/KZ class cells contain colour HTML; Name stays literal); it has no String/Value properties. Use the public select/read actions; selected row indices are also available with `getappdata(handles.VarList,'SelectedRows')`. Storage describes the whole workspace variable (whos.bytes), with binary units and at most three significant digits. Groups use native tabs (`GroupTabs`, `GroupAll`, `Group1` through `Group4`); use the public group action to switch programmatically. The list is parented to the selected tab. Counts appear below the type-filter radio buttons at the bottom of the left column. All includes every workspace variable, including ordinary values and legacy structs, subject to the active group and name search. Cut matches OxA_CUT, Map matches OxA_MAP/OxA_MAP_ToF, KZ matches OxA_KZ, and 4D/1D match their dimensional base classes. Type filters combine with group and name filters. Use `typefilter` to switch programmatically. EditVariable sits at the bottom of the right column and uses the same callback as the context-menu Edit Variable and opens the whole selected workspace variable; it is disabled with no selection. Tables are read-only summaries of the first selection; Metadata contains only `data.info` fields (or an empty table if absent). Coordinate units are inherited, never inferred. Nonuniform, missing, invalid and mismatched coordinates are identified. Plotting and processing use existing repository callbacks; Enter and the context-menu Plot selected action plot the first selection; a direct Swing table MouseClickedCallback handles left-button double-clicks, including repeated clicks on the selected cell. This uses the existing findjobj_2013 helper and the classic desktop JVM. Real Swing mouse-event dispatch tests pass (repeated clicks, clicked-row identity and tab switches); physical OS input remains unverified because window targeting failed. Right-click exposes actions on the already selected rows. External tools require their original dependencies and are outside the facade.

Verify state with `read`, inspect actual `info.GroupInfo`, and inspect the count label's TooltipString for mutation reports. Browser refresh scans the workspace on demand; it does not poll for changes. See [implementation and evidence](../../doc/ARPES_data_browser_v5_log.md).
