function v=dipersionRender(Lx,Ly,x0,stepX,Ef,Et,Ew,dE,dK,p,m)
% This is a theoretical distribution


% All parameters are normalized

% Resolution
nx=ceil(dK*4);
ny=ceil(dE*4);
if nx==0||ny==0
    v=-100*ones(Lx,Ly);
    return;
end
res_x=(-2*nx):(2*nx);
res_y=(-2*ny):(2*ny);
[res_x,res_y]=ndgrid(res_x,res_y);
res=exp(-log(2)/2*((res_x/dK).^2+(res_y/dE).^2));

% Lattice
LxExt=Lx+2*4*nx+1;
LyExt=Ly+2*4*ny+1;
x=(-4*nx):1:(Lx+4*nx);
x=x+x0/stepX;
y=(-4*ny):1:(Ly+4*ny);
[xx,yy]=ndgrid(x,y);

% Mask
LOrder=length(m);
mask=ones(1,LxExt);
for i = 1:LOrder
mask=mask+m(i)*x.^i;
end
mask=repmat(mask',[1,LyExt]);

% Original Dispersion
LOrder=length(p);
sumxx=ones(LxExt,LyExt)*p(end);
for i = 1:(LOrder-1)
    sumxx=sumxx+p(i)*xx.^(LOrder-i);
end
v=1./((yy-sumxx).^2+Ew^2);
v=v.*(1./(exp((yy-Ef)/Et)+1));
v=v.*mask;


% Broaden Dispersion
v = conv2(v,res,'same');
v=v/sum(sum(v));
v=v((1+4*nx):(Lx+4*nx),(1+4*ny):(Ly+4*ny));
if sum(sum(isnan(v)))~=0
    disp('nan');
end


end
