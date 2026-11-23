function direction = pkf_direction(direction)
%PKF_DIRECTION  Validate a PeakFit direction and return 'MDC' or 'EDC'.
%   Accepts 'MDC', 'Horizontal', 'EDC' or 'Vertical' (case-insensitive).
if (ischar(direction) || isstring(direction)) && isscalar(string(direction))
    switch lower(char(direction))
        case {'mdc', 'horizontal', 'h'}
            direction = 'MDC'; return
        case {'edc', 'vertical', 'v'}
            direction = 'EDC'; return
    end
end
error('PeakFit:InvalidDirection', 'Direction must be ''MDC'' (horizontal) or ''EDC'' (vertical).');
end
