function getFromWorkspace(obj,varargin)
DataName=getDataNames;
DataName=DataName{1};
data1=evalin('base',DataName);
data.value=data1.value;
data.x=data1.x;
obj.Data=data;
y1=num2str(min(data.x(:)));
y2=num2str(max(data.x(:)));
tabledata=get(obj.Table,'Data');
tabledata{2}=y1;
tabledata{3}=y2;
set(obj.Table,'Data',tabledata);
end