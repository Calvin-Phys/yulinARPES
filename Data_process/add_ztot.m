function datanu=add_ztot(data)
x=data.x;
xtot=repmat(x-4.7,[length(data.z),1]);
ztot=repmat(data.z',[1,length(x)]);
ztot=ztot+xtot;

datanu.x=x;
datanu.y=data.y;
datanu.z=data.z;
datanu.value=data.value;
datanu.ztot=ztot;
