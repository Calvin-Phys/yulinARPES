---
name: arpes-data-browser
description: Operate yulinARPES browser v5 to inspect and filter live MATLAB workspace variables, select data, and manage four ARPES groups. Use arpes-browse for loading, momentum conversion, and image export.
---

# Operate ARPES browser v5

Follow [shared MATLAB setup and session guidance](../MATLAB_SETUP.md). Use the
desktop session containing the data, with yulinARPES on its path. Browser v5
uses native MATLAB panels; launched tools such as `PlotSlices` can still
require GUI Layout Toolbox. This skill operates `ARPES_data_browser_v5`, an
independent singleton; it does not silently replace a user's requested v32
browser or viewer.

## Inspect and select

```matlab
browserFigure = ARPES_data_browser_v5;
ARPES_data_browser_v5('refresh');
state = ARPES_data_browser_v5('read');
```

`state` contains `figure`, `names`, `selected`, `group`, `groupNames`, and
`typeFilter`. Read/raise preserve existing state; refresh scans the workspace
on demand and preserves selection by name where still visible. There is no
background polling. `read` opens the browser if none exists.

Translate requested selection/filter changes explicitly:

```matlab
ARPES_data_browser_v5('typefilter', 'all');
ARPES_data_browser_v5('group', 0);
ARPES_data_browser_v5('select', {'sample_map'});
state = ARPES_data_browser_v5('read');
```

`sample_map` is an illustrative name: choose from the actual workspace. Select
requires visible names and rejects hidden/missing inputs. Filter/group changes
in the example are deliberate; preserve existing filters unless a change is
needed by the request. See [API and controls](references/api.md) for type
matching, search, table inspection, and plotting callbacks.

## Change group membership

```matlab
ARPES_data_browser_v5('membership', 'add', 2);
ARPES_data_browser_v5('renamegroup', 2, 'Photon scans');
```

These are separate mutating examples, to use only when the request calls for
them. Membership changes the selected scalar ARPES values' `info.GroupInfo`
in the base workspace. `add` retains other groups; `move` removes the active
source group and adds the target; `remove` uses the active group. Same-group
moves retain membership. Group labels persist in MATLAB preferences; flags
persist in data files only when the data are saved.

## Verify the result

Re-read state and check the selected names, group, and filter. For membership,
inspect the actual selected values' `info.GroupInfo` and the count control's
`TooltipString` for skipped-value/mutation reports. Group/name/type filters
compose; an empty result is not evidence that data vanished from the workspace.

The browser dispatches plotting and processing to existing tools. Its facade
does not validate every loader, viewer, or numerical algorithm. For measured
data loading, conversion, and exports, use [arpes-browse](../arpes-browse/SKILL.md).
For implementation history and dated checks, read the
[browser record](../../doc/ARPES_data_browser_v5_log.md).
