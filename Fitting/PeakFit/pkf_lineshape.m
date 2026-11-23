function y = pkf_lineshape(u, centre, fwhm, height, eta)
%PKF_LINESHAPE  Pseudo-Voigt peak with unit-normalised components.
%   y = PKF_LINESHAPE(u, centre, fwhm, height, eta) returns
%       height * (eta * L + (1 - eta) * G)
%   where L = 1 ./ (1 + (2(u - centre)/fwhm).^2) (Lorentzian) and
%   G = exp(-4 ln2 (u - centre).^2 / fwhm^2) (Gaussian). Both components have
%   value 1 at the centre and share the full width at half maximum FWHM, so
%   HEIGHT is the peak height and FWHM the width for every 0 <= eta <= 1.
%   eta = 1 is a pure Lorentzian and eta = 0 a pure Gaussian.
d = (u - centre) ./ fwhm;
L = 1 ./ (1 + 4 * d.^2);
G = exp(-4 * log(2) * d.^2);
y = height .* (eta .* L + (1 - eta) .* G);
end
