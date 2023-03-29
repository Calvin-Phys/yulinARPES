function fit(obj,varargin)
tabledata=get(obj.ParameterTable,'Data');
x=obj.Data.x(:)';
y=obj.Data.value(:)';
%% Normalization among dimensions
minx=min(x);
maxx=max(x);
Ly=max(y);
Lx=maxx-minx;
x=(x-minx)/Lx;
y=y/Ly;
%% coef0
EF0=tabledata{1,1};
EF0=(EF0-minx)/Lx;
lb0(1)=(tabledata{1,3}-minx)/Lx;
ub0(1)=(tabledata{1,4}-minx)/Lx;

T0=tabledata{2,1};
T0=T0/Lx;
lb0(2)=tabledata{2,3}/Lx;
ub0(2)=tabledata{2,4}/Lx;

ER0=tabledata{3,1};
ER0=ER0/Lx;
lb0(3)=tabledata{3,3}/Lx;
ub0(3)=tabledata{3,4}/Lx;

a0=tabledata{4,1}*Lx/Ly;
lb0(4)=tabledata{4,3};
ub0(4)=tabledata{4,4};

coef0=[EF0,T0,ER0,a0];
j=1;
k=1;
fixflag=zeros(2,4);
coeffix0=[];
for i = 1:4 % Only the first four parameters need boundaries
    if tabledata{i,2} % if fixed
        coeffix0(k)=coef0(i); %#ok<AGROW>
        fixflag(2,i)=k;
        fixflag(1,i)=2;
        k=k+1;
    else % if not fixed
        coeffit0(j)=coef0(i);  %#ok<AGROW>
        fixflag(2,i)=j;
        fixflag(1,i)=1;
        lb(j)=lb0(i); %#ok<AGROW>
        ub(j)=ub0(i); %#ok<AGROW>
        if lb(j)>ub(j)
            temp=lb(j); 
            lb(j)=ub(j); %#ok<AGROW>
            ub(j)=temp; %#ok<AGROW>
        end
        j=j+1;
    end
end


%% Background, E0, V0
L=length(y);
Lm=ceil(0.1*L);
if tabledata{7,2}
    bk = tabledata{7,1}/Ly;
else
    bk=mean(y(end-Lm+1:end));
end
if tabledata{5,2}
    E0=tabledata{5,1};
    E0=(E0-minx)/Lx;
else
    E0=mean(x(1:Lm));
end
if tabledata{6,2}
    V0=tabledata{6,1};
    V0=V0/Ly;
else
    V0=mean(y(1:Lm))-bk;
end
coefline=zeros(1,3);
coefline(1)=E0;
coefline(2)=V0;
coefline(3)=bk;


%% Fitting
[coeffited,FVal,ExitFlag,OutPut] = ...
    fmincon(@(coeffit)fdDistributionFit(x,y,coefline,coeffit,coeffix0,fixflag),...
    coeffit0,[],[],[],[],lb,ub);
coefcell={coeffited,coeffix0};
%% Output
CoefValue=zeros(1,7);
for i = 1:4
    CoefValue(i)=coefcell{fixflag(1,i)}(fixflag(2,i));
end
CoefValue(5:7)=coefline(:);
yNew=obj.fdDistribution(x,CoefValue);
%% back to real data scale
x=x*Lx+minx; 
yNew=yNew*Ly;
CoefValue(1)=CoefValue(1)*Lx+minx;
CoefValue(2)=CoefValue(2)*Lx;
CoefValue(3)=CoefValue(3)*Lx;
CoefValue(4)=CoefValue(4)*Ly/Lx;
CoefValue(5)=CoefValue(5)*Lx+minx;
CoefValue(6)=CoefValue(6)*Ly;
CoefValue(7)=CoefValue(7)*Ly;
%% Plot
dataNew.value=yNew;
dataNew.x=x;
obj.DataFitted=dataNew;
hold(obj.Axis,'off');
plot(obj.Axis,obj.Data.value,obj.Data.x,'blue');
hold(obj.Axis,'on');
plot(obj.Axis,obj.DataFitted.value,obj.DataFitted.x,'black');
axis(obj.Axis,'tight');
efline=xlim(obj.Axis);
plot(obj.Axis,efline,[CoefValue(1),CoefValue(1)],'--','Color','red');
hold(obj.Axis,'off');
%% Refresh parameter table
for i = 1:7
    tabledata{i,1}=CoefValue(i);
end
set(obj.ParameterTable,'Data',tabledata);

%

end

function diff=fdDistributionFit(x,y,coefline,coeffit,coeffix,fixflag)
% Ef=coef(1);
% kT=8.617e-5*coef(2);
% res=coef(3);
% a0=coef(4);
% E0=coef(5);
% V0=coef(6);
% bk=coef(7);
coef=zeros(1,7);
coefcell={coeffit,coeffix};
for i = 1:4
    coef(i)=coefcell{fixflag(1,i)}(fixflag(2,i));
end
coef(5:7)=coefline(:);
diff = (y - FitFermiSurface.fdDistribution(x,coef)).^2;
diff=sum(diff(:));
end


