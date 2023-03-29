function [b1_prim, b2_prim, b3_prim,g_hkl ] = plotBZ_V1_construct_rec_lattice_vectors(handles)
%plotBZ_V1_construt_rec_lattice_vectors constructs rec lattice vectors based on
%primitive unit cell parameters.mostly, g_hkl base on conventional unit
%cell.

%% load Bravais Lattice 
LatticeClass_val = get(handles.LatticeClass,'Value');
LatticeClass_str = get(handles.LatticeClass,'String');
LatticeClass = LatticeClass_str{LatticeClass_val};
LatticeType = get(findobj(handles.uipanel_LatticeType,'Value',1),'String');
a = str2double(get(handles.a,'String'));
b = str2double(get(handles.b,'String'));
c = str2double(get(handles.c,'String'));
alpha = deg2rad(str2double(get(handles.alpha,'String')));
beta = deg2rad(str2double(get(handles.beta,'String')));
gamma = deg2rad(str2double(get(handles.gamma,'String')));
MillerH = str2double(get(handles.MillerH,'String'));
MillerK = str2double(get(handles.MillerK,'String'));
MillerL = str2double(get(handles.MillerL,'String'));

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
end

%% construct reciprocal space vectors
% conventional reciprocal space vectors
volume_convcell = abs(dot(a1_conv,cross(a2_conv,a3_conv)));
b1_conv = 2*pi*cross(a2_conv,a3_conv)/volume_convcell;
b2_conv = 2*pi*cross(a3_conv,a1_conv)/volume_convcell;
b3_conv = 2*pi*cross(a1_conv,a2_conv)/volume_convcell;
% primitive reciprocal space vectors
volume_primcell = abs(dot(a1_prim,cross(a2_prim,a3_prim)));
b1_prim = 2*pi*cross(a2_prim,a3_prim)/volume_primcell;
b2_prim = 2*pi*cross(a3_prim,a1_prim)/volume_primcell;
b3_prim = 2*pi*cross(a1_prim,a2_prim)/volume_primcell;
        
%% construct vector normal to cleavage plane
if get(handles.radio_hklconv,'Value')
    g_hkl = MillerH*b1_conv+MillerK*b2_conv+MillerL*b3_conv;
else
    g_hkl = MillerH*b1_prim+MillerK*b2_prim+MillerL*b3_prim;
end


