# ARPES data browser v5 improvement record

> Dated review/implementation evidence. Use the [documentation index](README.md)
> and [skills map](../AI_skills/SKILLS_MAP.md) for current workflow routing.
> Later follow-ups supersede earlier designs and findings; recorded test
> results do not describe the current runtime unless rerun.

## Final recorded delivery summary — 17 November 2026

This section describes the final interface recorded for this revision. The chronological sections below retain earlier decisions and validation results; later user revisions supersede them.

- **Entry point:** `ARPES_data_browser_v5` opens its own singleton, independently of v32. Default client size is 600 x 460, with two equal 300-pixel columns; minimum size is 600 x 450. Compact margins and consistent 8-point controls/main table preserve the existing coordinate/metadata font sizes.
- **Menus:** actions are grouped under Load, Visualize, Process and Analyze. Load starts with the direct `ARPES loader (new)` action. Process includes the six-action Fine structure submenu above the Processing toolbox separator. All 43 original main-menu callback destinations remain represented. The initial v32 menu renaming/reordering and flattened Process actions are included as a separate compatibility change in its original entry point.
- **Workspace table:** Name / Class / Size columns replace the listbox. Size uses at most three significant digits with binary units, derived from the whole variable's `whos.bytes`. White and very light green rows alternate; selected rows are blue. CUT text is blue, MAP/ToF green, and KZ purple, matching the radio labels. Workspace names remain literal even though class cells contain colour markup.
- **Groups and filters:** native All/four-group tabs contain a shared multi-selection table. Add / Move / Remove / Rename and the group selector occupy one row. Names persist in local MATLAB preferences; membership retains the compatible four `info.GroupInfo` flags. Same-group moves retain membership, and refresh preserves visible selection by name. Name search combines with All / Cut / Map / KZ / 4D / 1D radios. **All shows every workspace variable**, including ordinary values and legacy structs; the other radios match OX classes. The filter row sits above the single-line All/Group/Shown/Selected counts.
- **Details and editing:** the removed upper-right selection summary and First selection footer free space for coordinate and metadata tables. Coordinate Min/Max use two decimal places and flag missing, mismatched or nonuniform axes. Metadata contains only the selected variable's `info` fields. Edit Variable sits at the bottom right and uses the same callback as the context menu.
- **Plotting and automation:** Enter and Plot selected invoke the existing plotting function. Classic-table double-clicks are bound directly to the Swing table peer using the existing `findjobj_2013` helper. Public actions are open/read/refresh/select/group/renamegroup/membership/typefilter; the repository operation skill documents their semantics.

### Final verification and limits

Final pre-commit validation in MATLAB R2024a passed **all eight comparison/check groups without warnings**. This includes 43 menu targets, v32/v5 plotting and grouping/NaN-processing parity, native Swing double-click event dispatch, tab/search/type filtering, metadata, fonts, geometry and colour/size checks. Both changed MATLAB files have **zero Code Analyzer notices**. The final palette also received targeted live checks for striping and selection restoration. Default/minimum screenshots were refreshed after the green-striping change and inspected. These are synthetic-fixture checks, not measured-data or end-to-end validation of every external loader/viewer/processing tool.

Physical Windows mouse automation remains blocked by the documented window-owner error; direct Swing event dispatch verifies repeated double-clicks, including unchanged selection and tab switches. The Java bridge is an isolated legacy compatibility dependency, not a promise of future MATLAB UI-framework support.

### Commit scope

The browser commit contains the new entry point, the earlier v32 menu edits, the focused comparison test, this log and interface screenshots, the browser operation skill, and browser-specific ignore exceptions. Pre-existing Plot BZ, README/manual and broader skill/session-history work remains outside this commit. No data files or scientific model changes are included.

## Chronological implementation record

17 November 2026. Implementation complete; validated in MATLAB R2024a on Windows. Current layout: 600 x 460 with two 300-pixel columns; see the final recorded summary above for the delivered menu arrangement.

Request: create a new entry point from v32, organize menus, improve groups and details, inspect the actual layout, and compare callback behavior.

Plan: retain v32 scientific/action callbacks in a separate v5 entry point; reorganize dispatch menus; use a two-column layout with search, explicit group actions/counts, and readable tables for coordinates and metadata. Preserve base-workspace conventions and four `info.GroupInfo` flags. Keep v32 and existing working-tree edits intact.

Acceptance: launch both entry points, compare synthetic data plotting and grouping callbacks, check empty/malformed/short axes, selection identity, singleton state, and inspect screenshots at normal and smaller sizes. Tests own only temporary variables and figures.

Design choices: four named groups remain compatible with v32; names persist in MATLAB preferences while memberships remain in data metadata. Add retains memberships; move removes only the active source membership and retains other groups; moving into the same group is a no-op. No physical units are inferred for coordinate arrays.


## Delivered interface

Launch from the yulinARPES path:

```matlab
ARPES_data_browser_v5
```

The new file has its own singleton tag (`ARPESDataBrowserV5`). The v32 file retains the menu adjustments made earlier in that maintenance session; this v5 work does not change it. Existing plotting, viewing, combination, save and processing callbacks were carried into the new entry point. They retain their base-workspace conventions and external dependencies. This is a staged GUI improvement, not a replacement of the scientific processing backend.

Menus now follow the task:

| Menu | Contents |
|---|---|
| Load | Import/sync and coordinate conversion |
| Visualize | Cuts/spectra, volumes/viewers, plotting tools; separated Plot BZ (new) and KZ cut simulation at the bottom |
| Process | Resampling/cropping, combination, normalization; curvature, gradient, smoothed derivative, mirror and ridge actions remain direct entries |
| Analyze | Spectral fitting, tight binding, WIEN2k import and resolution calculator |

All 43 original main-menu callback destinations remain represented. Labels use consistent capitalization and describe the action. No new claims about the underlying conversion methods are introduced.

The two-column window provides:

- Case-insensitive name search, explicit refresh, and selection preserved by variable name rather than by row number.
- Four compatible groups with visible counts, active selection styling and full-name tooltips. A destination selector and Add / Move / Remove / Rename buttons expose actions previously hidden in context menus. Names also update destination menus and persist as local MATLAB preferences. Names do not transfer with saved measurements; flags do.
- Membership creation for ARPES structs missing INFO, skipped-variable counts for unsupported values/metadata, empty-state handling, and a corrected same-group move. Add retains memberships; move clears only the active source, preserving unrelated memberships; removal applies to the active group.
- A details summary with variable name, array class/shape, workspace storage size and NaN/Inf counts. Coordinates show minimum, maximum, samples, uniform step or nonuniform indication, and dimension mismatches. Missing axes use indices. Scalar axes have no step. The metadata table summarizes fields without printing entire arrays. Vector VALUE arrays use a single X coordinate row.
- A minimum window size of 900 x 580 MATLAB logical pixels. Layout remains resizable above that size. Default size is 1000 x 650. Long group labels have tooltips; metadata columns can scroll.

## Validation and visual evidence

Final invocation:

```matlab
addpath(fullfile(pwd,'tests'))
report = test_ARPES_data_browser_v5;
```

This is an assertion-based comparison function, not a `matlab.unittest` suite. It returned `passed = true`, `checks = 6`, `topMenuTargets = 43` on MATLAB 24.1.0.2537033 (R2024a). Final execution emitted no warnings. Both production and comparison files had zero Code Analyzer notices. `git diff --check` passed; Git only noted normal CRLF conversion notices.

The six check groups cover:

1. Discovery of synthetic 1D, 2D, 3D, single-point-coordinate and missing-metadata data; all 43 top-level menu dispatch handles match v32 despite regrouping and renaming.
2. Actual double-click callbacks produce identical 1D line samples in v32/v5, also checked directly against the synthetic X/VALUE arrays.
3. Actual context-menu add and cross-group move callbacks agree with v32.
4. V5 same-group move retains membership; removal clears only the intended flag; missing metadata is created; VALUE is preserved.
5. Actual NaN replacement callbacks agree with v32, preserve the source and retain Inf.
6. Single-point axis mismatch and nonuniform step summaries, rename/menu synchronization, search, selection identity, empty details and singleton raise/read state preservation.

The test saves/restores existing v32 controls, group-name preferences, and removes only owned fixture variables and newly created figures. V5 remains open with ordinary workspace state after fixtures are removed. Reviewers can rerun the function in the same session.

Fresh captured client areas were inspected visually:

- [Default v5 layout](ARPES_data_browser_v5_interface.png): populated 2D fixture; selection, coordinate checks and metadata are readable.
- [Compact v5 layout](ARPES_data_browser_v5_compact.png): the retained image was regenerated after the later compact-layout changes; it does not show the original 900 x 580 layout.
- The former v32 comparison screenshot was removed during documentation cleanup because its workspace list exposed measurement names. Callback comparison results remain recorded above.

Screenshot pixel dimensions can differ from MATLAB logical pixels because of display scaling; `getframe` captures the client area, excluding the native title/menu bars. Menu hierarchy and destination preservation were verified from live menu objects. Initial visual review found names cramped in a five-button row; a two-row arrangement resolved that. The unused sixth grid cell provides spacing.

## Development findings and corrections

The initial capture attempt used `exportapp`, which does not accept this classic MATLAB figure; captures use `getframe` and `imwrite`. The first comparison function passed its assertions but its nested cleanup failed during workspace destruction. Cleanup was changed to a standalone function with explicitly captured values and the test was rerun without warnings. A processing test initially set the list selection without firing its single-click callback, leaving v32's cached selection stale. The test now invokes the actual click callback before processing. Fixture discovery also distinguishes input variables from generated output names.

## Scriptable operation and limits

The new entry point supports `open`, `read`, `refresh`, `select`, `group`, `renamegroup` and `membership`, using the same group and refresh functions as the GUI. See [the repository operation skill](../AI_skills/arpes-data-browser/SKILL.md). That skill is saved in the checkout, not installed globally. Raising/reading an existing v5 window preserves group/filter/selection; refresh is explicit and there is no background workspace polling.

These comparisons use synthetic data. External loaders, viewers, multi-dimensional plotting, file dialogs and each numerical processing tool were not executed end-to-end; callback destination parity is not validation of those external tools. No measured beamline results were compared. Group tests cover scalar structs; object classes remain dependent on writable INFO semantics. Large workspaces may make refresh and NaN/Inf summaries expensive because values are inspected on demand. The original base-workspace architecture and copied callback bodies remain maintenance limitations. No commits or dependency installations were made.


## Compact-layout follow-up — 17 November 2026

User feedback: the initial v5 window was too large; retain almost the original height, use a width just above twice the original, reduce gaps, promote the frequent loader, and regroup fine-structure actions.

Default dimensions are now **680 x 460**, compared with v32's **300 x 450**. Minimum dimensions are **640 x 450**. These replace the initial 1000 x 650 / 900 x 580 sizes recorded above. Outer padding decreased from 12 to 5 pixels; column spacing from 12 to 6; vertical spacing from 8 to 4. Headings, summaries and coordinate tables use tighter row heights. The group destination/rename controls have their own compact row above Add/Move/Remove so they remain usable at this width. Coordinate column headers are Axis / Min / Max / Count / Step / Check, with narrower columns. Both default and compact screenshots linked above were regenerated and visually inspected after the final changes.

`Load > ARPES loader (new)` is now the first direct child of Load. Classic import and sync remain in Import data. `Process > Fine structure` contains Curvature, Gradient, Smooth derivation, Mirror, Ridge detection and Fine structure tool. It sits immediately above the separator preceding Processing toolbox. These supersede the initial menu hierarchy described above.

The six comparison check groups passed again without warnings in MATLAB R2024a. Added live-menu assertions verify the loader's direct parent and first position, all six Fine structure children, and the separator below that submenu. All 43 dispatch destinations still match v32. Both changed MATLAB files have zero Code Analyzer notices. No additional numerical algorithms were changed.


## Native tabs and info metadata — 17 November 2026

User feedback requested native tabs around the group list, bottom counts, one row of membership controls, a narrower details column, and metadata limited to `data.info`.

Implemented a native `uitabgroup` with All and four named `uitab` children. One shared list lives inside the selected tab and is reparented when the tab changes; the same refresh, selection and membership functions serve tab clicks and the public group API. Tabs contain group names only. Workspace/group/visible/selected counts now appear below the single destination + Add + Move + Remove + Rename row, followed by action status. The group API and data flag semantics are unchanged. Tab titles track renamed groups; long titles follow native MATLAB tab overflow behavior.

Column proportions changed from 42/58 to 56/44 (workspace/details), within the existing 680 x 460 default / 640 x 450 minimum. Narrower coordinate and metadata columns and a shorter summary reduce unused space. Metadata now enumerates only the selected scalar `data.info` fields, displaying field names directly (without the redundant info prefix). VALUE/X/Y/Z and other data fields are excluded. Missing/empty INFO produces an empty table; a non-struct INFO displays its value under info. Large arrays/nested values retain concise summaries.

Six comparison groups passed without warnings in MATLAB R2024a. Additional checks exercise native tab selection, verify that the list's parent becomes the selected tab, check filtered membership, and assert that metadata contains precisely GroupInfo and photonEnergy for the fixture, with photonEnergy displayed as 21.2. All 43 main-menu destinations retain parity with v32. Code Analyzer reports zero notices for both changed MATLAB files. Normal/minimum screenshots were refreshed and visually inspected. Screenshot name search limits v5 captures to synthetic fixtures; live workspace measurements are preserved. `git diff --check` passed.

These changes supersede the button-group, separate-action-row and top-count descriptions in the historical sections above. The existing synthetic-data and external-tool validation limits still apply.


## Equal-width columns and coordinate precision — 17 November 2026

User requested two 300-pixel columns, counts on one line, removal of the double-click hint, and two decimal places for coordinate Min/Max.

The default figure client area is now 600 x 460 MATLAB logical pixels, with equal 300-pixel columns. The outer layout has no padding or intercolumn gap; each column retains 3-pixel internal padding. Minimum size is 600 x 450. Resizing wider expands the columns equally. Counts use a single line: All / Group / Shown / Selected. The initial Double-click hint was removed; the status control remains available for action results. Numeric coordinate Min/Max cells now use `%.2f` text formatting, including trailing zeros; stored axis values and calculations retain their precision. Missing or invalid axis indicators remain textual.

Six comparison check groups passed without warnings in MATLAB R2024a. Added assertions measure both default columns as 300 pixels, verify single-line counts, and check fixture Min/Max strings as -1.00 / 1.00. Both MATLAB files have zero analyzer notices. Regenerated screenshots were visually inspected; columns, one-row controls/counts, and coordinate precision are readable. These dimensions replace the preceding layout sizes in this historical record.


## Workspace table and removed summary — 17 November 2026

User requested a table of data name, class and storage size, and removal of the selected-data summary near the upper right.

The group tabs now contain one shared native `uitable` with **Name / Class / Size** columns. Class is the workspace variable class (`whos.class`), e.g. struct or an ARPES data class; Size is the whole workspace variable's reported storage (`whos.bytes`), formatted as B, KiB, MiB or GiB. It includes metadata, rather than just the VALUE array. The top-right DataSummary control and its shape/NaN/Inf readout were removed. Coordinates and info metadata now begin directly below the right-column heading. Both columns remain 300 pixels at the default 600 x 460 window.

Table selection uses documented CellSelectionCallback indices, deduplicated by row. Selected rows are stored on the table and highlighted across the full row, including selection made through the public select API. Refresh preserves selection by variable name. All copied actions now read names/rows through shared helpers; no hidden legacy listbox is used. Multi-row selection, grouping, rename, plotting and combination continue to operate on those selected rows. Enter and the new context-menu Plot selected action invoke the same plotting function. The owning figure mouse callback handles double-clicks within the table bounds, including a cell whose selection has not changed.

R2024a classic `figure` tables reject the newer programmatic Selection / SelectionType interfaces (a short isolated probe confirmed this). This implementation uses the classic table callback and row background APIs. See the official [uitable documentation](https://www.mathworks.com/help/matlab/ref/uitable.html) for the classic-figure distinction. Native user highlighting can coexist with full-row application highlighting.

Validation: six comparison groups pass without warnings. V32 double-click plotting is compared with v5's table Enter callback and exact fixture samples. Table event tests cover repeated cells in one row and two distinct rows, name/class/storage formatting, tab filtering, and absence of the DataSummary control. Existing actual context-menu group and NaN-processing callback comparisons remain passing. Both changed MATLAB files have zero Code Analyzer notices. Default/minimum screenshots were regenerated and inspected visually.

A live Windows mouse check was attempted using the computer-use skill. Window discovery succeeded, but get_window failed twice (with refreshed discovery) with a window-ownership mismatch error. No mouse input was issued. Therefore actual OS double-click delivery remains unverified; the implemented mouse route is source-reviewed, while table selection and Enter/context action routes are executed callback checks. The temporary mouse fixture was removed and existing workspace data/figures retained. This limitation does not change the six callback-test results.

The metadata table still shows only data.info; previous data-list and removed-summary descriptions are historical. These changes add no numerical processing formulas.


## Double-click defect and direct table event fix — 17 November 2026

User confirmed that physical double-clicks did not plot. The preceding figure-level mouse callback was insufficient for the classic Java-backed uitable; its mouse input is consumed by the table component. My earlier statement that double-clicking was available described intended behavior without successful native-event verification and did not establish that it worked.

Removed the figure-level handler. The browser now uses the repository's existing findjobj_2013 helper to bind MouseClickedCallback directly to the table's Swing peer. The handler accepts exactly a left-button double-click, resolves the row at the actual event point, updates the selected variable/details, and calls the existing PlotData function. Header/blank-space and right-button events are ignored. This works without waiting for a selection-change notification, so repeated double-clicks on the same cell take the same path. The Java handle is retained in table appdata; Enter and Plot selected remain available. Redundant reparenting on unchanged tabs was removed.

The adapter is isolated in installTableMouseHandler/tableMouseClicked. It depends on classic desktop MATLAB with JVM and the repository helper, whose JavaFrame access is an undocumented compatibility boundary. Its specific JavaFrame deprecation warning is locally suppressed, with all prior warning settings restored afterward. This is a tested R2024a legacy-table fix, not a claim of compatibility with future MATLAB UI frameworks.

The comparison function now has **seven** passing groups. It dispatches actual java.awt.event.MouseEvent instances through the table peer's dispatchEvent method on the event thread, rather than merely invoking the plotting helper. Two successive left-button double-clicks on an already selected row produce exactly two figures with independently checked fixture X/Y samples. A single click, right-button double-click and blank-space double-click add no figures. After switching group tabs, a double-click on a row different from the cached selection plots the clicked row and updates selection correctly. Existing six comparison groups remain passing, with no execution warnings. Both changed MATLAB files pass final Code Analyzer checks without notices.

The Windows computer-use tool again failed native window lookup with the same ownership error, including after refreshed discovery and using the returned window object. Consequently physical OS input was not issued; the evidence is real Swing event dispatch within the live MATLAB GUI, not a claimed successful physical click test. No Java Robot or alternate OS input injection was used. Tests close only owned plot figures and remove synthetic fixtures. The live browser was rebuilt with the fix, and its prior group/selected variable were restored where still available. The changes supersede the previous figure-level double-click implementation and verification status.


## Compact sizes, edit shortcut and class filters — 17 November 2026

User requested at most three digits for Size numbers, an Edit Variable button on the Metadata heading, and bottom radio filters replacing the action-status text. Clarification confirmed that All should include **only OX_ARPES objects**.

Size now uses at most three significant digits with binary units, e.g. 868 B, 1.34 KiB, 12.3 MiB, 123 MiB. Unit promotion happens before rounding would produce a four-digit mantissa. The underlying whos.bytes value is unchanged. Column widths were adjusted to allocate more room to the class string.

Edit Variable is positioned to the right of Metadata (data.info) and uses exactly the same Listbox_openvar callback as the existing context menu, opening the whole selected workspace variable. It is disabled when the table has no selection; the callback also returns safely on empty selection. The test verifies callback identity and enable states; it does not programmatically edit measured data in the MATLAB editor.

The bottom status label is replaced with six mutually exclusive native radio buttons:

| Filter | Matching classes |
|---|---|
| All | OxArpes_1D_Data / OxArpes_2D_Data / OxArpes_3D_Data / OxArpes_4D_Data and their subclasses |
| Cut | OxA_CUT |
| Map | OxA_MAP and OxA_MAP_ToF |
| KZ | OxA_KZ |
| 4D | OxArpes_4D_Data |
| 1D | OxArpes_1D_Data |

These use isa, not array dimensions, metadata guesses or variable names. All excludes ordinary variables and legacy structs, as requested. Filters combine with group tabs and name search. All/Group counts describe OX objects before the type/name filter; Shown and Selected describe the current table. Group mutation reports are retained as the count label's tooltip rather than taking space from the radios. The public facade adds `typefilter` (all/cut/map/kz/4d/1d), and read adds typeFilter without resetting the selected radio.

Final validation: **eight** comparison/check groups pass without warnings in MATLAB R2024a. Fixtures now use actual OX data classes to match the new All contract. Tests exercise all six saved radio callbacks, standard/ToF maps, ordinary-variable and struct exclusion, radio/tab/search composition, no-match editor disable, three-digit B and KiB formatting, and the shared Edit Variable callback. Prior group, processing, geometry, metadata, selection and actual Swing double-click event tests remain passing. Both changed MATLAB files have zero Code Analyzer notices; git diff --check passes. Both normal and minimum-size screenshots were regenerated and visually inspected. The existing browser was rebuilt and its prior group/search/selection restored when still visible under the new class filter. Physical OS mouse testing remains subject to the previously documented window-control limitation.


## All workspace variables and consistent fonts — 17 November 2026

User revised the All filter to include every workspace variable and requested consistent GUI fonts with a smaller main table, while retaining coordinate/metadata font sizes.

All is now a true type-filter bypass: ordinary numbers, structs, objects and other workspace variables are listed, subject to the active group tab and name search. Cut/Map/KZ/4D/1D retain their OX class matching. All/Group counts again include all workspace/group members. This supersedes the OX-only All contract in the preceding section and the initial clarification.

A live font audit found all labels/buttons/edits/radios at 8 points, the main table at 10 points, and coordinate/metadata tables at 8 points. The main table now uses 8 points. Browser-owned uicontrols explicitly use 8-point fonts so sizes remain consistent even when root defaults differ. Bold section headings retain their hierarchy; native tab/menu fonts remain controlled by MATLAB/Windows. Neither coordinate nor metadata table font properties were changed, and a live before/after comparison confirmed their original sizes. No root graphics defaults were modified.

All eight runtime check groups pass without warnings in R2024a. The filter test now requires ordinary numeric and legacy struct fixtures under All while excluding them from specific class filters. Tests also check 8-point main-table/control sizes and the unchanged 8-point details tables. Both changed MATLAB files have zero Code Analyzer notices. Normal/minimum screenshots were regenerated and visually inspected; smaller main-table text also makes the full fixture class names readable. The live browser was rebuilt and prior group/type filter/search/selection restored where still applicable. Existing double-click event regression tests remain passing.


## Bottom rows and metadata height — 17 November 2026

Swapped the bottom-left rows: type-filter radios now sit above the single-line variable/member counts. Removed the First selection footer from the right column and its fixed row allocation; the metadata table fills the recovered 28-pixel row plus 4-pixel gap down to the column padding. Existing dimensions and fonts remain the same.

All eight existing check groups pass in R2024a. Live geometry checks confirm radios above counts, absence of the footer, and metadata extending to the bottom padding. Code Analyzer reports no notices for the browser. Screenshots at both sizes were regenerated; the default layout was visually inspected. Prior live filter/search/selection state was restored.


## Bottom edit button and type colours — 17 November 2026

Moved Edit Variable from the Metadata heading to a right-aligned row at the bottom of the right column. The same context-menu callback and selection-dependent enable state remain bound. The metadata table fills the area above that button row.

Class-column text and the matching radio labels now use consistent colours: CUT blue (#1766A6), MAP/ToF map green (#16734A), KZ purple (#8A3EA8). Type names remain present. Only the class cell contains HTML colour markup supported by the classic table; variable names and Size remain literal. Existing selection/group/plotting callbacks therefore continue using exact workspace names. Other classes retain the standard text colour.

All eight check groups pass in R2024a, including all three colours and ToF's shared Map colour in actual class-cell values. Existing native Swing double-click/selection tests pass. Live bounds checks verify the button below metadata at the bottom padding. Browser and test file have no Code Analyzer notices. Updated default/minimum screenshots were generated; the default was visually inspected with blue CUT/purple KZ text and corresponding coloured radio labels. Original live group/filter/search/selection was restored. Physical mouse-tool limits recorded earlier remain unchanged.


## Light-green alternating main-table rows — 17 November 2026

Main-table rows alternate white and very light green (RGB 0.95, 0.98, 0.95). The palette is recomputed in the shared selection update, so deselecting a row restores the correct alternating background and selected rows retain their existing light-blue highlight. Other tables and type text colours are unchanged.

Targeted live checks verified green even rows, white odd rows, selection highlighting and restoration after selection changes. Browser Code Analyzer has zero notices. The live screenshot was regenerated and inspected, and prior group/filter/search/selection was retained. The previous eight-group regression result is historical; this cosmetic change received targeted palette/runtime and visual checks only.
