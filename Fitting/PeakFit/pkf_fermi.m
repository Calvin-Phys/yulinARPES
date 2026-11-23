function f = pkf_fermi(E, EF, T)
%PKF_FERMI  Fermi-Dirac occupation f = 1 ./ (exp((E - EF)/(kB*T)) + 1).
%   E and EF in eV, T in K (kB = 8.617333262e-5 eV/K). The exponent is
%   clamped to +-700 so the result never overflows; T <= 0 gives a sharp
%   step (0.5 exactly at EF).
kB = 8.617333262e-5;
if T <= 0
    f = double(E < EF) + 0.5 * double(E == EF);
    return
end
z = (E - EF) ./ (kB * T);
z = min(max(z, -700), 700);
f = 1 ./ (exp(z) + 1);
end
