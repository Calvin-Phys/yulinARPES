function label = arpes_axis_label(data, axisName)
%ARPES_AXIS_LABEL Format only the axis name and unit supplied by the data.
%   Missing struct metadata produces a blank label, never a guessed axis name.
name = '';
unit = '';
nameField = [axisName '_name'];
unitField = [axisName '_unit'];
if isstruct(data)
    if isfield(data, nameField), name = data.(nameField); end
    if isfield(data, unitField), unit = data.(unitField); end
else
    if isprop(data, nameField), name = data.(nameField); end
    if isprop(data, unitField), unit = data.(unitField); end
end
if isstring(name) && isscalar(name), name = char(name); end
if isstring(unit) && isscalar(unit), unit = char(unit); end
if ~ischar(name), name = ''; end
if ~ischar(unit), unit = ''; end
if ~isstruct(data)
    label = [name ' (' unit ')'];
elseif isempty(unit)
    label = name;
elseif isempty(name)
    label = ['(' unit ')'];
else
    label = [name ' (' unit ')'];
end
end
