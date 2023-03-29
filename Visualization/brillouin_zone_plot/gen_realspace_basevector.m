function a = gen_realspace_basevector( handles )
%generate base vectors a (primitive cell) of real space lattice 
%  return a=[a1;a2;a3]

% alpha=str2double(get(handles.alpha,'String'))/180*pi;
beta=str2double(get(handles.beta,'String'))/180*pi;
gamma=str2double(get(handles.gamma,'String'))/180*pi;
a=str2double(get(handles.a_length,'String'));
b=str2double(get(handles.b_length,'String'));
c=str2double(get(handles.c_length,'String'));

a1=a*[1,0,0];
a2=b*[cos(gamma),sin(gamma),0];
a31=c*cos(beta);
A=1+(a2(3)/a2(2))^2;
B=-2*a2(3)*(b-a2(1))*c*cos(beta)/a2(2);
C=(b-a2(1))^2*c^2*cos(beta)^2/a2(2)^2-c^2+a31^2;
if B^2-4*A*C<0
    return;
end
a33=(-B+sqrt(B^2-4*A*C))/2/A;
a32=((b-a2(1))*c*cos(beta)-a33*a2(3))/a2(2);
a3=[a31,a32,a33];
a=[a1;a2;a3];

if get(handles.bcc,'Value')
    a=[-0.5,0.5,0.5;0.5,-0.5,0.5;0.5,0.5,-0.5]*a;
elseif get(handles.fcc,'Value')
    a=[0,0.5,0.5;0.5,0,0.5;0.5,0.5,0]*a;
end

end

