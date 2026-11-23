function [total, components, background, occupation] = pkf_model(u, peaks, bg, opts)
%PKF_MODEL  Evaluate the PeakFit model on the profile axis u.
%   total = PKF_MODEL(u, peaks, bg, opts)
%     peaks  struct array with fields centre, fwhm, height, eta
%     bg     [c0 c1]: linear background c0 + c1 * (u - opts.uMid)
%     opts   struct with uMid and optional Fermi (struct with enabled, EF,
%            T). When Fermi.enabled is true (EDC mode), peaks and background
%            are multiplied by the Fermi-Dirac occupation f(u - EF, T).
%   [total, components, background, occupation] also returns each peak
%   (numel(u) x numel(peaks), already multiplied by the occupation), the
%   background curve and the occupation (ones when the cutoff is off).
u = u(:);
if ~isfield(opts, 'uMid') || isempty(opts.uMid), opts.uMid = mean([min(u) max(u)]); end
occupation = ones(size(u));
if isfield(opts, 'Fermi') && isstruct(opts.Fermi) && isfield(opts.Fermi, 'enabled') && opts.Fermi.enabled
    occupation = pkf_fermi(u, opts.Fermi.EF, opts.Fermi.T);
end
components = zeros(numel(u), numel(peaks));
for k = 1:numel(peaks)
    components(:, k) = occupation .* pkf_lineshape(u, peaks(k).centre, peaks(k).fwhm, ...
        peaks(k).height, peaks(k).eta);
end
background = occupation .* (bg(1) + bg(2) * (u - opts.uMid));
total = sum(components, 2) + background;
end
