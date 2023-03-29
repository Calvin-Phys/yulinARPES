function Parameter0=denormalizePar(ParameterNormalized,data)
Lx=length(data.x);
Ly=length(data.y);
stepX=(max(data.x)-min(data.x))/Lx;
stepY=(max(data.y)-min(data.y))/Ly;
Parameter0.Ef=ParameterNormalized.Ef*stepY+min(data.y);
Parameter0.Et=ParameterNormalized.Et*stepY;
Parameter0.Ew=ParameterNormalized.Ew*stepY;
Parameter0.dE=ParameterNormalized.dE*stepY;
Parameter0.dK=ParameterNormalized.dK*stepX;

LOrder=length(ParameterNormalized.p);
for i = 1:LOrder
    Parameter0.p(i)=...
        ParameterNormalized.p(i)*stepY/stepX^(LOrder-i);
end
Parameter0.p(end)=Parameter0.p(end)+min(data.y);

LOrder=length(ParameterNormalized.m);
for i = 1:LOrder
    Parameter0.m(i)=ParameterNormalized.m(i)*stepX^LOrder;
end
end

