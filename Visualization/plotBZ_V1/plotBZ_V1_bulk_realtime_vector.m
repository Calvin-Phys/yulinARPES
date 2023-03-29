function [b1_prim,b2_prim,b3_prim,g_hkl] = plotBZ_V1_bulk_realtime_vector(b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl,handles)
%% rotate reciprocal lattice vectors b, so that g_hkl is perp to z-axis (this makes the projection of the cutting planes easier later on)
[delta_a,delta_e,~] = cart2sph(g_origin_hkl(1),g_origin_hkl(2),g_origin_hkl(3));
g_hkl = (rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*g_origin_hkl')'; 
b1_prim = (rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*b1_origin_prim')'; 
b2_prim = (rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*b2_origin_prim')';
b3_prim = (rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*b3_origin_prim')';

%% rotate reciprocal lattice vectors as rot3DBZ requires,so that 3DBZ and 2D horizontal BZ rotate some degrees around kz axis.
rot3DBZ = str2double(get(handles.rot3DBZ,'String'));
b1_prim = (rotz(rot3DBZ)*b1_prim')';
b2_prim = (rotz(rot3DBZ)*b2_prim')';
b3_prim = (rotz(rot3DBZ)*b3_prim')';
set(handles.b1_vector,'String',sprintf('%0.4f  ',b1_prim));
set(handles.b2_vector,'String',sprintf('%0.4f  ',b2_prim));
set(handles.b3_vector,'String',sprintf('%0.4f  ',b3_prim));