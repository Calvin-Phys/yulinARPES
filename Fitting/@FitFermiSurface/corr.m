function corr(obj,varargin)
tabledata=get(obj.ParameterTable,'Data');
x=obj.Data.x(:)';
y=obj.Data.value(:)';
%% Normalization among dimensions

%% Parameter
EF0=tabledata{1,1};

T0=tabledata{2,1};

ER0=tabledata{3,1};

a0=tabledata{4,1};

V0=tabledata{6,1};

bk = tabledata{7,1};

E0=tabledata{5,1};


    
CoefValue=[EF0,T0,ER0,a0,E0,V0,bk];
%% F-D distribution
yFD=obj.fdDistribution(x,CoefValue);

%% back to real data scale

yFD=yFD/max(yFD);
yNew=y./yFD;
yNew=yNew/max(yNew)*max(y);
%% Plot
dataNew.value=yNew;
dataNew.x=x;
obj.DataCorr=dataNew;
hold(obj.Axis,'off');
plot(obj.Axis,obj.Data.value,obj.Data.x,'blue');
hold(obj.Axis,'on');
plot(obj.Axis,obj.DataCorr.value,obj.DataCorr.x,'red');
plot(obj.Axis,yFD,x,'black');
axis(obj.Axis,'tight');
xlim(obj.Axis,[0,max(y)]);
efline=xlim(obj.Axis);
plot(obj.Axis,efline,[CoefValue(1),CoefValue(1)],'--','Color','red');
hold(obj.Axis,'off');



end

