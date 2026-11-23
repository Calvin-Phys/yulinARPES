---
name: arpes-browse
description: Load and view yulinARPES data in MATLAB, convert supported OX_ARPES objects to momentum space, and export 2D images. Use the live MATLAB session and PlotSlices by default; use an explicitly requested viewer when specified.
---

# Browse ARPES data in MATLAB

Use the MATLAB MCP execution tool with an existing desktop MATLAB session first. This workflow uses the yulinARPES GUI and the OX_ARPES scriptable loader. It does not require reviewing either full repository.

Read [shared setup and session guidance](../MATLAB_SETUP.md) when establishing
the connection or paths. Confirm that this is the MATLAB holding the intended
data; a new or empty session is not a replacement for the user's live workspace.
Use [batch fallback](references/matlab-batch-fallback.md) only for tasks that can
be fulfilled with independent file inputs and saved outputs.

## Setup

Resolve `yulinRoot` from `setup_yulinARPES` and locate the matching OX_ARPES
checkout as described in the shared setup guide. Add its `DataType`,
`DataLoader`, `DataAnalysis`, and `GUI` folders when needed. Browser v5 itself
does not require GUI Layout Toolbox; `PlotSlices` and legacy v32 still require
it (`uiextras`).

```matlab
setup_yulinARPES;
which loader_UI -all
which PlotSlices -all
ARPES_data_browser_v5;
```

Browser v5 is the primary singleton; another call raises it.
`data_browser_demo_v32` is legacy, retained for explicit compatibility requests.
For v5 selection, filters, and grouping, use
[arpes-data-browser](../arpes-data-browser/SKILL.md).
Do not reset the MATLAB path through a live connector.

## Load named files into the base workspace

Set `dataRoot` to the selected input directory; the basenames below are synthetic
examples to replace with the actual requested files. For those paths, call the OX_ARPES `loader_UI` in script mode with `AssignToBase=true`. Unlike picker mode, script mode does not assign to the base workspace by default. It calls `load_arpes`, chooses an approved reader from the file schema, and validates the returned object by default.

```matlab
paths = { ...
    fullfile(dataRoot, 'sample-map.nxs'), ...
    fullfile(dataRoot, 'sample-cut.nxs')};
[loaded, reports] = loader_UI(paths, ...
    'AssignToBase', true, 'Progress', 'text');
```

For multiple inputs, `loaded` and `reports` are cell arrays in input order. The base workspace name is `matlab.lang.makeValidName` of the file stem: the synthetic example `sample-map.nxs` becomes `sample_map`. Verify the loader result and workspace variable before reporting success:

```matlab
for k = 1:numel(paths)
    [~, stem] = fileparts(paths{k});
    name = matlab.lang.makeValidName(stem);
    present = evalin('base', sprintf('exist(''%s'',''var'')', name));
    if ~present || ~reports{k}.validated
        error('ARPES load was not validated in the base workspace: %s', name);
    end
    data = evalin('base', name);
    fprintf('%s: %s, %s, size %s\n', name, reports{k}.loader, ...
        class(data), mat2str(size(data.value)));
end
```

For one file, `reports` is a struct rather than a cell; adjust indexing. Do not report a scan as loaded if the loader errors or returns no data. `AssignToBase=true` replaces a same-named base variable. When replacement is not intended, use `[data,report] = load_arpes(filePath)` and `assignin('base',uniqueName,data)` with a distinct valid name, then use `uniqueName` for `PlotSlices`. For `.mat` input, `load_arpes` returns a structure and the report's `validated` flag remains false; inspect its fields instead of applying the ARPES-object check above.

## Open PlotSlices

**Default display method:** use `PlotSlices` when the user asks to plot, open, or view loaded data without naming a viewer. Use **Data Viewer (new)** only when the instruction directly requests that viewer. Do not infer a switch to the new viewer from the data class or dimension alone.

`PlotSlices` reads a **variable name from the MATLAB base workspace**, not an object or file path. It accepts a direction of `x`, `y`, or `z` and supports 2D and 3D `value` arrays.

- For a 3D `OxA_MAP` or `OxA_KZ`, use `PlotSlices(name,'z')` for an energy slice unless the user specifies another direction.
- For a 2D `OxA_CUT`, use `PlotSlices(name,'x')`. The viewer promotes the cut to a one-element `x` dimension, making the original angle-energy image visible.
- Do not send a 1D or 4D object to `PlotSlices`; ask what view is intended unless the user has directly requested Data Viewer (new).

Example:

```matlab
mapView = PlotSlices('sample_map','z');
cutView = PlotSlices('sample_cut','x');
fprintf('map=%d, cut=%d\n', ...
    isgraphics(mapView.Figure), isgraphics(cutView.Figure));
```

For an arbitrary list, inspect `class(data)` and `size(data.value)` after loading, choose a useful direction, open one figure per requested file, and confirm each `Figure` handle with `isgraphics`. The MATLAB code can keep the returned `PlotSlices` handles in named variables if later interaction is needed.

If running a temporary verification, close only the `Figure` handles returned by the `PlotSlices` objects created for that verification, and clear only its temporary base variables. Leave the `DataBrowser` figure open when the user asked to start it.

## Data Viewer (new): explicit requests only

The `Data Viewer (new)` item is in the variable list's right-click menu in `ARPES_data_browser_v5` (also available in legacy v32). Select the loaded base-workspace variable, right-click it, and choose **Data Viewer (new)**. Its callback reads the selected variable and dispatches by `value` dimensions: 2D to `OxArpes_DataViewer_2D`, 3D to `OxArpes_DataViewer_3D`, and 4D to `OxArpes_DataViewer_4D`. These are the `.mlapp` viewers in OX_ARPES `GUI`. A vector takes the browser's 1D `PlotData` route instead.

If the GUI selection is impractical for an agent, call the same viewer directly after loading, using the base-workspace object and the `GUI` path added at startup:

```matlab
name = 'sample_map';  % replace with the loaded workspace variable
data = evalin('base', name);
if isstruct(data)
    data.name = name;  % the browser callback does this for structures
end
if isvector(data.value)
    error('Data Viewer (new) uses the browser PlotData action for vectors.');
end
switch ndims(data.value)
    case 2
        viewer = OxArpes_DataViewer_2D(data);
    case 3
        viewer = OxArpes_DataViewer_3D(data);
    case 4
        viewer = OxArpes_DataViewer_4D(data);
    otherwise
        error('Data Viewer (new) does not support this array dimension.');
end
```

Use the returned app handle to confirm its UI figure is open. The direct call reproduces the menu's viewer selection; it does not change the default `PlotSlices` choice for other requests.

## Momentum conversion and image export

When the user requests momentum space or a saved image, follow [references/momentum-and-export.md](references/momentum-and-export.md). It gives the class-specific metadata, `kconvert()` workflow, naming and verification steps, and a clean 300 dpi PNG export using `show()` and `exportgraphics`. Momentum conversion does not happen merely because a file was loaded. Convert the **full 3D object by default**; restrict conversion to a Fermi-surface window only when the user specifically asks to convert only the Fermi surface. After conversion, display the result with `PlotSlices` by default; use Data Viewer (new) only if directly requested.

## Simulated photon-energy overlays

For instructions to add, update, style, move, or delete a simulated cut at a
specified photon energy in a MATLAB figure, use
[arpes-kz-plot](../arpes-kz-plot/SKILL.md). That workflow operates `kz_plot`
overlays in the live session and does not require loading or converting measured
data. Keep the existing figure and its measured-data graphics when adding an
overlay.
