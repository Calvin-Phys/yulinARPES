function shape = pkf_shape(shape)
%PKF_SHAPE  Validate a PeakFit line-shape name.
%   Returns 'Lorentzian', 'Gaussian' or 'Pseudo-Voigt'. Accepts these names
%   case-insensitively, plus 'lorentz', 'gauss', 'pv', 'voigt'.
if (ischar(shape) || isstring(shape)) && isscalar(string(shape))
    switch lower(regexprep(char(shape), '[\s_-]', ''))
        case {'lorentzian', 'lorentz', 'l'}
            shape = 'Lorentzian'; return
        case {'gaussian', 'gauss', 'g'}
            shape = 'Gaussian'; return
        case {'pseudovoigt', 'pv', 'voigt'}
            shape = 'Pseudo-Voigt'; return
    end
end
error('PeakFit:InvalidShape', 'Shape must be ''Lorentzian'', ''Gaussian'' or ''Pseudo-Voigt''.');
end
