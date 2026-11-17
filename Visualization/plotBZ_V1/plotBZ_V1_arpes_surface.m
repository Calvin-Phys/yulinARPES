function scan = plotBZ_V1_arpes_surface(params)
%PLOTBZ_V1_ARPES_SURFACE Sample a free-electron ARPES measurement surface.
%   PARAMS.mode is 'fixed' (polar-by-tilt) or 'photon' (hnu-by-tilt).
%   Shared fields: workFunction, innerPotential, bindingEnergy [eV],
%   azimuth [deg], tiltMin, tiltMax, tiltStep [deg]. Fixed mode additionally
%   uses photonEnergy [eV], polarMin, polarMax, polarStep [deg]. Photon mode
%   uses photonMin, photonMax, photonStep [eV], polarAngle [deg].
%   Coordinates are in inverse angstrom, with surface normal +kz and the
%   slit along +kx at azimuth zero. Positive tilt points along +ky.
%   Endpoints are included; actual spacing never exceeds the requested step.
%   Photon momentum, intensity and non-free-electron final states are omitted.

arguments
    params (1,1) struct
end
if ~isfield(params, 'mode') || ...
        ~(ischar(params.mode) && isrow(params.mode) || ...
        isstring(params.mode) && isscalar(params.mode)) || ...
        ~any(strcmp(params.mode, {'fixed','photon'}))
    error('plotBZ_V1:InvalidSimulation', 'Simulation mode must be fixed or photon.');
end
shared = {'workFunction','innerPotential','bindingEnergy','azimuth', ...
    'tiltMin','tiltMax','tiltStep'};
if strcmp(params.mode, 'fixed')
    required = [shared, {'photonEnergy','polarMin','polarMax','polarStep'}];
else
    required = [shared, {'photonMin','photonMax','photonStep','polarAngle'}];
end
for index = 1:numel(required)
    field = required{index};
    if ~isfield(params, field) || ~isnumeric(params.(field)) || ...
            ~isscalar(params.(field)) || ~isreal(params.(field)) || ...
            ~isfinite(params.(field))
        error('plotBZ_V1:InvalidSimulation', '%s must be a finite real scalar.', field);
    end
    params.(field) = double(params.(field));
end
if any([params.workFunction params.innerPotential params.bindingEnergy] < 0)
    error('plotBZ_V1:InvalidSimulation', ...
        'Work function, inner potential and binding energy must be nonnegative.');
end
tilt = sampleRange(params.tiltMin, params.tiltMax, params.tiltStep, 'Tilt');
if strcmp(params.mode, 'fixed')
    firstAxis = sampleRange(params.polarMin, params.polarMax, params.polarStep, 'Polar');
    [polarGrid, tiltGrid] = ndgrid(firstAxis, tilt);
    energies = repmat(params.photonEnergy, size(polarGrid));
else
    firstAxis = sampleRange(params.photonMin, params.photonMax, params.photonStep, 'Photon energy');
    [energies, tiltGrid] = ndgrid(firstAxis, tilt);
    polarGrid = repmat(params.polarAngle, size(energies));
end
if any(abs([polarGrid(:); tiltGrid(:)]) >= 90)
    error('plotBZ_V1:InvalidSimulation', 'Polar and tilt must lie strictly between -90 and 90 degrees.');
end
kineticEnergy = energies - params.workFunction - params.bindingEnergy;
if any(kineticEnergy(:) <= 0)
    error('plotBZ_V1:InvalidSimulation', ...
        'Photon energy must exceed work function plus binding energy.');
end
% CODATA electron mass, elementary charge and reduced Planck constant;
% 1e-10 converts inverse metres into inverse angstrom.
factor = sqrt(2*9.1093837139e-31*1.602176634e-19)/1.054571817e-34*1e-10;
kSlit = factor*sqrt(kineticEnergy).*sind(polarGrid);
kTilt = factor*sqrt(kineticEnergy).*cosd(polarGrid).*sind(tiltGrid);
scan.kx = kSlit*cosd(params.azimuth) - kTilt*sind(params.azimuth);
scan.ky = kSlit*sind(params.azimuth) + kTilt*cosd(params.azimuth);
scan.kz = factor*sqrt(kineticEnergy.*(cosd(polarGrid).*cosd(tiltGrid)).^2 + params.innerPotential);
if any(~isfinite([scan.kx(:);scan.ky(:);scan.kz(:)]))
    error('plotBZ_V1:InvalidSimulation','Simulation energies exceed the numerical range.');
end
scan.polar = polarGrid;
scan.tilt = tiltGrid;
scan.photonEnergy = energies;
scan.kineticEnergy = kineticEnergy;
scan.firstDimensionVaries = numel(firstAxis) > 1;
scan.dimension = double(numel(firstAxis) > 1) + double(numel(tilt) > 1);
scan.center = [mean(scan.kx,'all'), mean(scan.ky,'all'), mean(scan.kz,'all')];
scan.parameters = params;
end

function values = sampleRange(first, last, step, label)
if first > last || step <= 0
    error('plotBZ_V1:InvalidSimulation', '%s range must be ordered with a positive step.', label);
end
count = ceil((last-first)/step) + 1;
if count > 201
    error('plotBZ_V1:InvalidSimulation', '%s exceeds 201 samples; increase the step.', label);
end
values = linspace(first, last, count);
end
