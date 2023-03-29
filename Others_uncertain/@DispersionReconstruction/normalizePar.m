function ParameterNormalized = normalizePar(Parameter0,data)
Lx=length(data.x);
Ly=length(data.y);
stepX=(max(data.x)-min(data.x))/Lx;
stepY=(max(data.y)-min(data.y))/Ly;
ParameterNormalized.Ef=(Parameter0.Ef-min(data.y))/stepY;
ParameterNormalized.Et=Parameter0.Et/stepY;
ParameterNormalized.Ew=Parameter0.Ew/stepY;
ParameterNormalized.dE=Parameter0.dE/stepY;
ParameterNormalized.dK=Parameter0.dK/stepX;
LOrder=length(Parameter0.p);
for i = 1:LOrder
    ParameterNormalized.p(i)=...
        Parameter0.p(i)*stepX^(LOrder-i)/stepY;
end
ParameterNormalized.p(end)=...
    ParameterNormalized.p(end)-min(data.y)/stepY;
LOrder=length(Parameter0.m);
for i = 1:LOrder
    ParameterNormalized.m(i)=...
        Parameter0.m(i)/stepX^LOrder;
end
end