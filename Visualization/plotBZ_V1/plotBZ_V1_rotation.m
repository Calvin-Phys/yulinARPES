function rotation = plotBZ_V1_rotation(axisName, angleDegrees)
%PLOTBZ_V1_ROTATION Right-handed active Cartesian rotation in degrees.
%   Column vectors transform as R*v; row vectors transform as v*R'.
%   Keeping these elementary matrices local avoids a toolbox dependency.

arguments
    axisName (1,:) char {mustBeMember(axisName, {'x','y','z'})}
    angleDegrees (1,1) double {mustBeReal, mustBeFinite}
end
c = cosd(angleDegrees);
s = sind(angleDegrees);
switch axisName
    case 'x'
        rotation = [1 0 0; 0 c -s; 0 s c];
    case 'y'
        rotation = [c 0 s; 0 1 0; -s 0 c];
    case 'z'
        rotation = [c -s 0; s c 0; 0 0 1];
end
end
