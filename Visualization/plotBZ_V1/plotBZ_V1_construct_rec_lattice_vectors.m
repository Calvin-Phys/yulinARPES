function [b1_prim, b2_prim, b3_prim, g_hkl] = plotBZ_V1_construct_rec_lattice_vectors(handles)
%PLOTBZ_V1_CONSTRUCT_REC_LATTICE_VECTORS Build reciprocal vectors in 1/length.
%   Cell lengths and angles describe the conventional cell. The selected
%   Miller indices can refer to its reciprocal basis or to the primitive
%   reciprocal basis, as chosen in the GUI.

%% load Bravais Lattice 
LatticeClass_val = get(handles.LatticeClass,'Value');
LatticeClass_str = get(handles.LatticeClass,'String');
LatticeClass = LatticeClass_str{LatticeClass_val};
LatticeType = get(findobj(handles.uipanel_LatticeType,'Value',1),'String');
a = plotBZ_V1_parse_scalar(handles, 'a', 'positive');
b = plotBZ_V1_parse_scalar(handles, 'b', 'positive');
c = plotBZ_V1_parse_scalar(handles, 'c', 'positive');
alphaDegrees = plotBZ_V1_parse_scalar(handles, 'alpha');
betaDegrees = plotBZ_V1_parse_scalar(handles, 'beta');
gammaDegrees = plotBZ_V1_parse_scalar(handles, 'gamma');
miller = [plotBZ_V1_parse_scalar(handles, 'MillerH', 'integer'), ...
    plotBZ_V1_parse_scalar(handles, 'MillerK', 'integer'), ...
    plotBZ_V1_parse_scalar(handles, 'MillerL', 'integer')];
if all(miller == 0)
    error('plotBZ_V1:InvalidInput', 'Miller indices must not all be zero.');
end
if any([alphaDegrees, betaDegrees, gammaDegrees] <= 0) || ...
        any([alphaDegrees, betaDegrees, gammaDegrees] >= 180)
    error('plotBZ_V1:InvalidInput', 'Cell angles must be between 0 and 180 degrees.');
end
alpha = deg2rad(alphaDegrees);
beta = deg2rad(betaDegrees);
gamma = deg2rad(gammaDegrees);

% A valid three-dimensional cell has a positive-definite metric. Check
% this before taking square roots in the low-symmetry constructions.
metric = [a^2, a*b*cos(gamma), a*c*cos(beta); ...
    a*b*cos(gamma), b^2, b*c*cos(alpha); ...
    a*c*cos(beta), b*c*cos(alpha), c^2];
if min(eig(metric)) <= 1e-12*max(diag(metric))
    error('plotBZ_V1:InvalidInput', 'Cell lengths and angles do not form a valid 3-D lattice.');
end

%% construct real space vectors
LatticeType = strtrim(LatticeType);
LatticeClass = strtrim(LatticeClass);
Lattice = strcat(LatticeType,32,LatticeClass);

switch Lattice
    case 'primitive Cubic'
        a1_conv = [a,0,0];
        a2_conv = [0,a,0];
        a3_conv = [0,0,a];
        a1_prim = a1_conv;
        a2_prim = a2_conv;
        a3_prim = a3_conv;
    case 'face-centered Cubic'
        a1_conv = [a,0,0];
        a2_conv = [0,a,0];
        a3_conv = [0,0,a];
        a1_prim = [0,a/2,a/2];
        a2_prim = [a/2,0,a/2];
        a3_prim = [a/2,a/2,0];
    case 'body-centered Cubic'
        a1_conv = [a,0,0];
        a2_conv = [0,a,0];
        a3_conv = [0,0,a];
        a1_prim = [-a/2,a/2,a/2];
        a2_prim = [a/2,-a/2,a/2];
        a3_prim = [a/2,a/2,-a/2];
    case 'primitive Tetragonal'
        a1_conv = [a,0,0];
        a2_conv = [0,a,0];
        a3_conv = [0,0,c];
        a1_prim = a1_conv;
        a2_prim = a2_conv;
        a3_prim = a3_conv;
    case 'body-centered Tetragonal'
        a1_conv = [a,0,0];
        a2_conv = [0,a,0];
        a3_conv = [0,0,c];
        a1_prim = [-a/2,a/2,c/2];
        a2_prim = [a/2,-a/2,c/2];
        a3_prim = [a/2,a/2,-c/2];
    case 'primitive Orthorhombic'
        a1_conv = [a,0,0];
        a2_conv = [0,b,0];
        a3_conv = [0,0,c];
        a1_prim = a1_conv;
        a2_prim = a2_conv;
        a3_prim = a3_conv;
    case 'face-centered Orthorhombic'
        a1_conv = [a,0,0];
        a2_conv = [0,b,0];
        a3_conv = [0,0,c];
        a1_prim = [0,b/2,c/2];
        a2_prim = [a/2,0,c/2];
        a3_prim = [a/2,b/2,0];
    case 'body-centered Orthorhombic'
        a1_conv = [a,0,0];
        a2_conv = [0,b,0];
        a3_conv = [0,0,c];
        a1_prim = [-a/2,b/2,c/2];
        a2_prim = [a/2,-b/2,c/2];
        a3_prim = [a/2,b/2,-c/2];
    case 'base-centered Orthorhombic'
        a1_conv = [a,0,0];
        a2_conv = [0,b,0];
        a3_conv = [0,0,c];
        a1_prim = [a/2,-b/2,0];
        a2_prim = [a/2,b/2,0];
        a3_prim = [0,0,c];
    case 'primitive Hexagonal'
        a1_conv = [a/2,-a*sqrt(3)/2,0];
        a2_conv = [a/2,a*sqrt(3)/2,0];
        a3_conv = [0,0,c];
        a1_prim = a1_conv;
        a2_prim = a2_conv;
        a3_prim = a3_conv;
    case 'primitive Rhombohedral'
        a1_conv = [a*cos(alpha/2),-a*sin(alpha/2),0];
        a2_conv = [a*cos(alpha/2),a*sin(alpha/2),0];
        a3_conv = [a*cos(alpha)/cos(alpha/2),0,a*sqrt(1-(cos(alpha)/cos(alpha/2))^2)];
        a1_prim = a1_conv;
        a2_prim = a2_conv;
        a3_prim = a3_conv;
    case 'primitive Monoclinic'
        a1_conv = [a,0,0];
        a2_conv = [0,b,0];
        a3_conv = [c*cos(beta),0,c*sin(beta)];
        a1_prim = a1_conv;
        a2_prim = a2_conv;
        a3_prim = a3_conv;
    case 'base-centered Monoclinic'
        a1_conv = [a,0,0];
        a2_conv = [0,b,0];
        a3_conv = [c*cos(beta),0,c*sin(beta)];
        a1_prim = [a/2,b/2,0];
        a2_prim = [-a/2,b/2,0];
        a3_prim = [c*cos(beta),0,c*sin(beta)];
    case 'primitive Triclinic'
        a1_conv = [a,0,0];
        a2_conv = [b*cos(gamma),b*sin(gamma),0];
        a3_conv = [c*cos(beta),c*(cos(alpha)-cos(beta)*cos(gamma))/sin(gamma),c*sqrt((sin(gamma))^2-(cos(alpha))^2-(cos(beta))^2+2*cos(alpha)*cos(beta)*cos(gamma))/sin(gamma)];
        a1_prim = a1_conv;
        a2_prim = a2_conv;
        a3_prim = a3_conv;
    otherwise
        error('plotBZ_V1:InvalidInput', 'Unsupported lattice type: %s.', Lattice);
end

%% construct reciprocal space vectors
% conventional reciprocal space vectors
volume_convcell = dot(a1_conv,cross(a2_conv,a3_conv));
if ~isfinite(volume_convcell) || volume_convcell <= 0
    error('plotBZ_V1:InvalidInput', 'Conventional cell volume must be positive.');
end
b1_conv = 2*pi*cross(a2_conv,a3_conv)/volume_convcell;
b2_conv = 2*pi*cross(a3_conv,a1_conv)/volume_convcell;
b3_conv = 2*pi*cross(a1_conv,a2_conv)/volume_convcell;
% primitive reciprocal space vectors
volume_primcell = dot(a1_prim,cross(a2_prim,a3_prim));
if ~isfinite(volume_primcell) || volume_primcell <= 0
    error('plotBZ_V1:InvalidInput', 'Primitive cell volume must be positive.');
end
b1_prim = 2*pi*cross(a2_prim,a3_prim)/volume_primcell;
b2_prim = 2*pi*cross(a3_prim,a1_prim)/volume_primcell;
b3_prim = 2*pi*cross(a1_prim,a2_prim)/volume_primcell;
        
%% construct vector normal to cleavage plane
if get(handles.radio_hklconv,'Value')
    g_hkl = miller(1)*b1_conv + miller(2)*b2_conv + miller(3)*b3_conv;
else
    g_hkl = miller(1)*b1_prim + miller(2)*b2_prim + miller(3)*b3_prim;
end


