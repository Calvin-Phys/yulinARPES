function fitPar(obj,varargin)
%% Load Data
data=obj.Data;
Lx=length(data.x);
Ly=length(data.y);
x0=min(data.x);
stepX=(max(data.x)-min(data.x))/Lx;
v=data.value;
[Parameter0,ParameterF,ParameterL,ParameterU]=obj.getParameterTable;
Parameter0=obj.normalizePar(Parameter0,data);
ParameterL=obj.normalizePar(ParameterL,data);
ParameterU=obj.normalizePar(ParameterU,data);
fPara=fieldnames(Parameter0);
para=cell(size(fPara));
for i = 1:length(fPara)
    para{i}=Parameter0.(fPara{i});
    paraL{i}=ParameterL.(fPara{i}); %#ok<AGROW>
    paraU{i}=ParameterU.(fPara{i}); %#ok<AGROW>
end
%% Fitting
% Get fixed/unfixed parameter list
[coef0,CellLengthList]=cell2array(para);
coefL=cell2array(paraL);
coefU=cell2array(paraU);
L=length(coef0);
L0=length(para);
j=1;
for i = 1:L0
    coefF(j:(j+CellLengthList(i)-1))=ParameterF.(fPara{i});
    j=j+CellLengthList(i);
end
fixflag=zeros(2,L);
coeffix0=[];
lb=[];
ub=[];

k=1;
j=1;
for i = 1:L % Only the first four parameters need boundaries
    if coefF(i) % if fixed
        coeffix0(k)=coef0(i); %#ok<AGROW>
        fixflag(2,i)=k;
        fixflag(1,i)=2;
        k=k+1;
    else % if not fixed
        coeffit0(j)=coef0(i);  %#ok<AGROW>
        fixflag(2,i)=j;
        fixflag(1,i)=1;
        lb(j)=coefL(i); %#ok<AGROW>
        ub(j)=coefU(i); %#ok<AGROW>
        if lb(j)>ub(j)
            temp=lb(j); 
            lb(j)=ub(j); %#ok<AGROW>
            ub(j)=temp; %#ok<AGROW>
        end
        j=j+1;
    end
end
% fit
v=v/sum(v(:));
[coeffited,FVal,ExitFlag,OutPut] = ...
    fmincon(@(coeffit)diffRender(...
    Lx,Ly,x0,stepX,v,coeffit,coeffix0,fixflag,CellLengthList),...
    coeffit0,[],[],[],[],lb,ub);
coefcell={coeffited,coeffix0};
coefvalue=zeros(1,L);
for i = 1:L
    coefvalue(i)=coefcell{fixflag(1,i)}(fixflag(2,i));
end
% Output
para=array2cell(coefvalue,CellLengthList);
for i = 1:length(para)
    Parameter0.(fPara{i})=para{i};   
end
Parameter0=DispersionReconstruction.denormalizePar(Parameter0,data);
obj.setParameterTable(Parameter0);
obj.render;


%% End of Fitting
v=DispersionReconstruction.dipersionRender(Lx,Ly,x0,stepX,para{:});
pcolor(obj.Axis2,data.x,data.y,v');
shading(obj.Axis2,'interp');
end

function [ArrayOut,CellLength]=cell2array(CellIn)
L1 = length(CellIn);
CellLength=zeros(1,L1);
j=1;
for i = 1:L1
    CellLength(i)=length(CellIn{i});
    ArrayOut(j:(j+CellLength(i)-1))=CellIn{i}(:);
    j=j+CellLength(i);
end
end

function [CellOut] = array2cell(ArrayIn,CellLength)
L = length(CellLength);
CellOut=cell(1,L);
j=1;
for i = 1:L
    CellOut{i} = ArrayIn(j:(j+CellLength(i)-1));
    j=j+CellLength(i);
end
end

function diff=diffRender(Lx,Ly,x0,stepX,v,coeffit,coeffix,fixflag,CellLength)
L=length(coeffit)+length(coeffix);
coef=zeros(1,L);
coefcell={coeffit,coeffix};
for i = 1:L
    coef(i)=coefcell{fixflag(1,i)}(fixflag(2,i));
end
coefCell=array2cell(coef,CellLength);
vFit=DispersionReconstruction.dipersionRender(Lx,Ly,x0,stepX,coefCell{:});
vFit=vFit/sum(vFit(:));
diff=(v-vFit).^2;
diff=sum(diff(:));
end















