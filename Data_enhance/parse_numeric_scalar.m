function value = parse_numeric_scalar(text)
%PARSE_NUMERIC_SCALAR Parse one finite numeric value from GUI text.

if isstring(text) && isscalar(text)
    text = char(text);
end
if ~ischar(text) || ~isrow(text)
    error('yulinARPES:InvalidNumericInput', ...
        'Expected one numeric value as text.');
end

value = str2double(text);
if ~isscalar(value) || ~isfinite(value)
    error('yulinARPES:InvalidNumericInput', ...
        'Enter one finite numeric value in the selected field.');
end
end
