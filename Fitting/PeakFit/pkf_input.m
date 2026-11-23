function D = pkf_input(data, name)
%PKF_INPUT  Normalise a 2-D ARPES cut for the PeakFit tools (read-only).
%   D = PKF_INPUT(data) accepts
%     * a base-workspace variable name (char or string),
%     * a struct with numeric fields x, y and value, or
%     * an OX_ARPES 2-D object (OxA_CUT / OxArpes_2D_Data) with x, y, value.
%   VALUE must be indexed VALUE(x, y), i.e. size [numel(x) numel(y)], the
%   yulinARPES/OX_ARPES convention (x = angle or momentum, y = energy).
%   D = PKF_INPUT(data, name) records NAME as the source name.
%
%   D contains x, y (row vectors, as given, ascending or descending), value
%   (double), xLabel, yLabel, xName, yName, xUnit, yUnit, info, temperature
%   (K from info.temperature, or [] when unavailable), name and sourceClass.
%   The source data are never modified. Only 2-D cuts are supported: maps
%   and other 3-D/4-D data raise PeakFit:Not2D.

if nargin < 2, name = ''; end
if ischar(data) || (isstring(data) && isscalar(data))
    name = char(data);
    if ~isvarname(name)
        error('PeakFit:InvalidName', '"%s" is not a valid MATLAB variable name.', name);
    end
    if ~evalin('base', sprintf('exist(''%s'', ''var'')', name))
        error('PeakFit:UnknownVariable', 'Base-workspace variable "%s" does not exist.', name);
    end
    data = evalin('base', name);
end

if isstruct(data)
    if ~isscalar(data) || ~all(isfield(data, {'x', 'y', 'value'}))
        error('PeakFit:InvalidData', 'A data struct needs scalar fields x, y and value.');
    end
elseif isobject(data)
    if ~all(cellfun(@(f) isprop(data, f), {'x', 'y', 'value'}))
        error('PeakFit:InvalidData', 'Objects of class %s have no x, y and value properties.', class(data));
    end
else
    error('PeakFit:InvalidData', 'Expected a variable name, a struct or an OX_ARPES 2-D object, not %s.', class(data));
end

value = data.value;
if ~(isnumeric(value) || islogical(value)) || isempty(value)
    error('PeakFit:InvalidData', 'value must be a non-empty numeric array.');
end
hasZ = (isstruct(data) && isfield(data, 'z')) || (isobject(data) && isprop(data, 'z'));
if ndims(value) > 2 || (hasZ && numel(data.z) > 1) %#ok<ISMAT>
    error('PeakFit:Not2D', ['2D cuts only; extract a 2D slice first ' ...
        '(value has size %s).'], mat2str(size(value)));
end
x = data.x; y = data.y;
checkAxis(x, 'x'); checkAxis(y, 'y');
x = double(x(:).'); y = double(y(:).');
if ~isequal(size(value), [numel(x) numel(y)])
    error('PeakFit:SizeMismatch', ['value must be [numel(x) numel(y)] = %s, ' ...
        'but it is %s.'], mat2str([numel(x) numel(y)]), mat2str(size(value)));
end
if numel(x) < 3 || numel(y) < 3
    error('PeakFit:TooSmall', 'Both axes need at least 3 points.');
end

D.x = x;
D.y = y;
D.value = double(real(value));
[D.xName, D.xUnit] = axisMeta(data, 'x', 'x');
[D.yName, D.yUnit] = axisMeta(data, 'y', 'Energy');
D.xLabel = makeLabel(D.xName, D.xUnit);
D.yLabel = makeLabel(D.yName, D.yUnit);
D.info = struct();
if (isstruct(data) && isfield(data, 'info')) || (isobject(data) && isprop(data, 'info'))
    if isstruct(data.info) && isscalar(data.info), D.info = data.info; end
end
D.temperature = infoTemperature(D.info);
D.name = name;
D.sourceClass = class(data);
end

function checkAxis(v, label)
if ~isnumeric(v) || ~isvector(v) || any(~isfinite(v(:)))
    error('PeakFit:InvalidAxis', 'Axis %s must be a finite numeric vector.', label);
end
d = diff(double(v(:)));
if ~(all(d > 0) || all(d < 0))
    error('PeakFit:InvalidAxis', 'Axis %s must be strictly monotonic (ascending or descending).', label);
end
end

function [n, u] = axisMeta(data, ax, default)
n = default; u = '';
f = [ax '_name']; g = [ax '_unit'];
if (isstruct(data) && isfield(data, f)) || (isobject(data) && isprop(data, f))
    v = data.(f);
    if (ischar(v) || isstring(v)) && strlength(string(v)) > 0, n = char(v); end
end
if (isstruct(data) && isfield(data, g)) || (isobject(data) && isprop(data, g))
    v = data.(g);
    if (ischar(v) || isstring(v)) && strlength(string(v)) > 0, u = char(v); end
end
end

function s = makeLabel(n, u)
if isempty(u), s = n; else, s = sprintf('%s (%s)', n, u); end
end

function T = infoTemperature(info)
T = [];
if ~isfield(info, 'temperature'), return; end
v = info.temperature;
if ~(isnumeric(v) && isreal(v)) || isempty(v), return; end
v = double(v(:)); v = v(isfinite(v));
if isempty(v), return; end
v = mean(v);
if v > 0, T = v; end
end
