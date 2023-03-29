function data_new=resizeData(data,sizeX,sizeY,sizeZ)
data.value(isnan(data.value))=0;
data_new=data;
xmin=min(data.x);
xmax=max(data.x);
ymin=min(data.y);
ymax=max(data.y);
zmin=min(data.z);
zmax=max(data.z);
xnew=linspace(xmin,xmax,sizeX);
ynew=linspace(ymin,ymax,sizeY);
znew=linspace(zmin,zmax,sizeZ);
[xgrid,ygrid,zgrid]=meshgrid(data.y, data.x,data.z);
[xgrid_nu,ygrid_nu,zgrid_nu]=meshgrid(ynew, xnew,znew);
newValue=interp3(xgrid, ygrid, zgrid,...
    data.value,xgrid_nu,ygrid_nu,zgrid_nu,'spline');
data_new.value=newValue;
data_new.x=xnew;
data_new.y=ynew;
data_new.z=znew;
end