function yData=fdDistribution(xData,coef)
% get extended data
Ef=coef(1);
kT=8.617e-5*coef(2);
res=coef(3);
a0=coef(4);
E0=coef(5);
V0=coef(6);
bk=coef(7);
M=length(xData);
N=floor(M/5);
step=(xData(end)-xData(1))/length(xData);
maxX=max(xData);
minX=min(xData);
xDataLeft=minX-N*step:step:xData(1)-step;
xDataRight=xData(end)+step:step:maxX+N*step;
xDataExt=[xDataLeft,xData,xDataRight];
yFDD=(-a0*(xDataExt-E0)+V0)./(exp((xDataExt-Ef)/kT)+1)+bk;
% make resolution function
xResFunc=-N*step:step:N*step;
yResFunc=exp(-log(2)*xResFunc.^2/(res)^2);
yResFunc=yResFunc/sum(yResFunc(:));
% convolution
yFDDNew=conv(yFDD,yResFunc,'same');
yData=yFDDNew(N+1:M+N);

end
