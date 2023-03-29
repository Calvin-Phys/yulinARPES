function [s1,s2] = plotBZ_V1_surface_realtime_vector(b1_origin_prim,b2_origin_prim,b3_origin_prim,g_origin_hkl,handles)
% obtain surface BZ vector
[delta_a,delta_e,~] = cart2sph(g_origin_hkl(1),g_origin_hkl(2),g_origin_hkl(3));
g_hkl = (rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*g_origin_hkl')'; 
b1_prim = (rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*b1_origin_prim')'; 
b2_prim = (rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*b2_origin_prim')';
b3_prim = (rotx((90-rad2deg(delta_e)))*rotz((90-rad2deg(delta_a)))*b3_origin_prim')';
plane=createPlane([0,0,0],g_hkl);
s1=projPointOnPlane(b1_prim,plane);
s2=projPointOnPlane(b2_prim,plane);
s3=projPointOnPlane(b3_prim,plane);
rotsurBZ = str2double(get(handles.rotsurBZ,'String'));
s1=(rotz(rotsurBZ)*s1')';
s2=(rotz(rotsurBZ)*s2')';
s3=(rotz(rotsurBZ)*s3')';
s1=[s1(1:2),dot(s1(1:2),s1(1:2))];
s2=[s2(1:2),dot(s2(1:2),s2(1:2))];
s3=[s3(1:2),dot(s3(1:2),s3(1:2))];
s_test=[s1;s2;s3];
s_test=sortrows(s_test,3);
if s_test(1,3)==0
    p1=s_test(2,1:2);
    p2=s_test(3,1:2);
else
   p1=s_test(1,1:2);
   p2=s_test(2,1:2);
   p3=s_test(3,1:2);
   if isParallel(p1,p2)
      p2=p3;
   end
end
s1=p1;
s2=p2;
set(handles.s1_vector,'String',sprintf('%0.4f  ',s1));
set(handles.s2_vector,'String',sprintf('%0.4f  ',s2));

