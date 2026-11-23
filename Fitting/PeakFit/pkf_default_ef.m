function [EF, source] = pkf_default_ef(D)
%PKF_DEFAULT_EF  Default Fermi level for the EDC Fermi-Dirac cutoff.
%   [EF, source] = PKF_DEFAULT_EF(D) for a cut normalised by PKF_INPUT:
%     * 0 when the energy axis (y) spans 0 (binding energy / E - EF);
%     * info.photon_energy - info.workfunction when that lies within a
%       kinetic-energy axis (first-order estimate; edit it in the GUI or
%       pass the value fitted with FDD_fit_app for accurate work);
%     * otherwise 0 with source 'default (outside the energy axis)'.
y = D.y;
if min(y) <= 0 && max(y) >= 0
    EF = 0; source = 'E - EF axis (0)';
    return
end
info = D.info;
if isfield(info, 'photon_energy') && isfield(info, 'workfunction')
    hv = double(info.photon_energy); wf = double(info.workfunction);
    if isscalar(hv) && isscalar(wf) && isfinite(hv) && isfinite(wf)
        guess = hv - wf;
        if guess >= min(y) && guess <= max(y)
            EF = guess; source = 'info.photon_energy - info.workfunction';
            return
        end
    end
end
EF = 0; source = 'default (outside the energy axis)';
end
