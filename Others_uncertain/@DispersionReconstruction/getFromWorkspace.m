function getFromWorkspace( obj,varargin )
DataName=getDataNames;
DataName=DataName{1};
obj.Data=evalin('base',DataName);
data=obj.Data;
pcolor(obj.Axis1,data.x,data.y,data.value');
shading(obj.Axis1,'interp');
end

