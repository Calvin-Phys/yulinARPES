# Momentum conversion and PNG export

Use these steps after the [main skill](../SKILL.md) has loaded data into the MATLAB base workspace and added OX_ARPES `DataType` to the path. This procedure is adapted for the live MATLAB MCP workflow from the [OX_ARPES PNG export skill](https://github.com/Calvin-Phys/OX_ARPES_AI_SKILLS/blob/main/SKILL.md). Use the [batch fallback](matlab-batch-fallback.md) only when the MCP workflow cannot complete.

## Choose the operation

- Convert only when the user requests momentum space. Keep the raw base-workspace object; assign the result a new name such as `sample_cut_ksp`.
- Convert the full 3D volume by default, including when a 2D PNG will be exported from one of its slices. Use the narrow-window conversion below only if the user specifically requests conversion of the Fermi surface alone.
- Export only when the user requests a saved image. Use the requested output path; otherwise choose a writable output folder and a filename based on the input stem, and report it. Do not overwrite an existing image without that instruction. A PNG of a 3D scan is a chosen 2D slice, not the full volume.

## Check calibration metadata

`kconvert()` supports `OxA_CUT`, `OxA_MAP`, and `OxA_KZ`. Inspect `class(data)`, `size(data.value)`, and `data.info` after loading. Require finite physical metadata; do not guess missing photon energy or work function. Use zero offsets when the user requests no offset, or as an explicitly reported default when no calibration is supplied.

| Class | Required metadata | Zero-offset fields | Output axes |
| --- | --- | --- | --- |
| `OxA_CUT` | Scalar `photon_energy`, `workfunction` | `thetay_offset` | `k_y`, `E-E_F` |
| `OxA_MAP` | Scalar `photon_energy`, `workfunction` | `thetax_offset`, `thetay_offset`, `azimuth_offset` | `k_x`, `k_y`, `E-E_F` |
| `OxA_KZ` | Scan's photon-energy `x` axis, `workfunction`, `inner_energy` | `thetay_offset` | `k_z`, `k_y`, `E-E_F` |

The `OxA_KZ` constructor supplies `inner_energy = 15 eV` as a default. Report when that default is used, and accept the user's calibrated value when provided. Do not replace a photon-energy scan with one scalar photon energy. The DLS i05 loader reads photon energy and assigns a work function from its beamline calibration; verify the loaded values before conversion.

Work on a MATLAB value-class copy so the raw workspace object remains available. A zero-offset conversion follows this pattern:

```matlab
sourceName = 'sample_cut';  % replace with a loaded base-workspace name
raw = evalin('base', sourceName);
work = raw;
switch class(work)
    case 'OxA_CUT'
        work.info.thetay_offset = 0;
    case 'OxA_MAP'
        work.info.thetax_offset = 0;
        work.info.thetay_offset = 0;
        work.info.azimuth_offset = 0;
    case 'OxA_KZ'
        work.info.thetay_offset = 0;
        % Keep its photon-energy scan axis and check info.inner_energy.
    otherwise
        error('Unsupported class for k-space conversion: %s', class(work));
end
% Before this call, confirm the required metadata in the table above.
kspace = work.kconvert();
kspace.validate();
kspaceName = [sourceName '_ksp'];
kspace.name = kspaceName;
if evalin('base', sprintf('exist(''%s'',''var'')', kspaceName))
    error('Workspace variable already exists: %s', kspaceName);
end
assignin('base', kspaceName, kspace);
fprintf('%s: %s, size %s\n', kspaceName, class(kspace), ...
    mat2str(size(kspace.value)));
```

Confirm `kspace` is nonempty, its axis lengths match `size(kspace.value)`, and `kspaceName` exists in the base workspace. If the target name exists, choose another valid name or replace it only when the user requested a rerun. Use `PlotSlices(kspaceName,'x')` for a converted 2D cut or `PlotSlices(kspaceName,'z')` for a converted 3D map or KZ scan. Check `isgraphics(view.Figure)`. Keep original and converted views open when the user asks for both. A full 3D conversion can consume substantial memory and time; do not silently reduce the requested data to make it faster.

### Fermi-window conversion: explicit Fermi-surface-only requests

For a 3D `OxA_MAP` or `OxA_KZ`, use this reduction only when the user specifically requests conversion of the Fermi surface alone. On the **working copy**, before `kconvert()`, select source planes within a 0.05 eV width around the Fermi level. A raw `OxA_MAP` has a kinetic-energy `z` axis, so its center is `photon_energy - workfunction`; a raw `OxA_KZ` has an `E-E_F` `z` axis, so its center is zero. If no plane falls inside, use the nearest plane:

```matlab
width = 0.05;  % eV; change if the user specifies another energy width
if isa(work, 'OxA_MAP')
    center = work.info.photon_energy - work.info.workfunction;
elseif isa(work, 'OxA_KZ')
    center = 0;
else
    error('Fermi-window conversion requires a 3D MAP or KZ scan.');
end
selected = abs(work.z - center) <= width/2;
if ~any(selected)
    [~, nearest] = min(abs(work.z - center));
    selected(nearest) = true;
end
work.z = work.z(selected);
work.value = work.value(:,:,selected);
kspace = work.kconvert();
kspace.validate();
```

`kspace` now covers only the selected energy window; label it accordingly when assigning it to the workspace. For a raw `OxA_MAP`, the Fermi-slice center is `photon_energy - workfunction` on its kinetic-energy `z` axis. For a converted `OxA_MAP` and for raw or converted `OxA_KZ`, the center is `0` on the `E-E_F` axis. In each case `get_slice('z',center,width)` returns a 2D object and uses the nearest plane if the requested interval contains none. The width is an **energy** thickness, not a momentum width.

## Export a clean image

For a 2D `OxA_CUT`, use the raw or converted object directly. For a 3D `OxA_MAP` or `OxA_KZ`, first create the desired 2D slice. Set `outputRoot` to the chosen writable destination. Workspace names and
filenames here are synthetic examples. This exports a converted Fermi-surface
slice; use the selected 2D cut as `image2D` for a cut image:

```matlab
kspace = evalin('base', 'sample_map_ksp');
width = 0.05;  % eV
image2D = kspace.get_slice('z', 0, width);
image2D.name = 'sample_map_ksp_fermi_surface';
outputPath = fullfile(outputRoot, 'sample-map_ksp.png');
if isfile(outputPath)
    error('Image already exists: %s', outputPath);
end
if ~isfolder(fileparts(outputPath))
    error('Output directory does not exist: %s', fileparts(outputPath));
end
axesHandle = image2D.show();
drawnow;
exportgraphics(axesHandle, outputPath, 'Resolution', 300);
if ~isfile(outputPath)
    error('PNG export did not create %s', outputPath);
end
fprintf('Saved %s\n', outputPath);
```

Use `show()` to produce a clean data figure rather than exporting the whole `PlotSlices` control window. Verify the PNG exists and report its path, whether it came from raw or converted data, the class, energy slice center and width for 3D data, and any calibration values supplied or defaulted. Leave or close this export figure according to the user's window request; do not close other viewers.
