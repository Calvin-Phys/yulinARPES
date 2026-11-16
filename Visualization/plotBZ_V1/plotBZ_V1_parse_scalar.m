function value = plotBZ_V1_parse_scalar(handles, fieldName, kind)
%PLOTBZ_V1_PARSE_SCALAR Read and validate one numeric GUIDE edit control.
%   KIND is 'real', 'positive', 'integer', 'nonnegativeInteger', or 'figure'.

if nargin < 3
    kind = 'real';
end

value = str2double(get(handles.(fieldName), 'String'));
if ~isscalar(value) || ~isreal(value) || ~isfinite(value)
    error('plotBZ_V1:InvalidInput', '%s must be a finite number.', fieldName);
end

switch kind
    case 'real'
        % No additional restriction.
    case 'positive'
        valid = value > 0;
    case 'integer'
        valid = value == fix(value);
    case 'nonnegativeInteger'
        valid = value >= 0 && value == fix(value);
    case 'figure'
        valid = value > 0 && value == fix(value);
    otherwise
        error('plotBZ_V1:InvalidValidator', 'Unknown scalar kind: %s.', kind);
end

if ~strcmp(kind, 'real') && ~valid
    error('plotBZ_V1:InvalidInput', '%s must be a %s value.', fieldName, kind);
end
end
