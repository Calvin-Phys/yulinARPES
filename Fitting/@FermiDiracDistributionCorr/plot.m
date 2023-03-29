function plot(obj,varargin)
    direction=get(obj.SelectDirection,'String');
    num=get(obj.SelectDirection,'Value');
    direction=direction{num};
    temperature=get(obj.InputTemperature,'String');
    temperature=str2double(temperature);
    Ef=get(obj.InputEf,'String');
    Ef=str2double(Ef);
    kT=8.617e-5*temperature;
    res=get(obj.InputEnergyResolution,'String');
    res=str2double(res);
    threshold=get(obj.InputThreshold,'String');
    threshold=str2double(threshold);
    
    cla(obj.Axis);
       
    obj.CurveOfEDC=plot(obj.Axis,obj.Data.x,obj.Data.y);
    xlim(obj.Axis,[min(obj.Data.x),max(obj.Data.x)]);
    ylim(obj.Axis,[min(obj.Data.y),max(obj.Data.y)]);
    
    %% Plot FD Distribution
    hold(obj.Axis,'on');
    axes(obj.Axis);
    switch direction
        case 'x-y'           
            yFD=fdDistribution(obj.Data.x,Ef,kT,res);
            yData=obj.Data.y;
            yData(yData<threshold)=0;
            yCorrEDC=yData./yFD;
            yCorrEDC=yCorrEDC/max(yCorrEDC);
            obj.CurveOfFDD=plot(obj.Data.x,yFD);
            obj.CurveOfCorrEDC=plot(obj.Data.x,yCorrEDC);
            obj.LineOfEf=line([Ef,Ef],ylim(obj.Axis));
            LineOfThreshold=line(xlim(obj.Axis),[threshold,threshold]);
        case 'y-x'
            xFD=fdDistribution(obj.Data.y,Ef,kT,res);
            xData=obj.Data.x;
            xData(xData<threshold)=0;
            xCorrEDC=xData./xFD;
            xCorrEDC=xCorrEDC/max(xCorrEDC);
            obj.CurveOfFDD=plot(xFD,obj.Data.y);
            obj.CurveOfCorrEDC=plot(xCorrEDC,obj.Data.y);
            obj.LineOfEf=line(xlim(obj.Axis),[Ef,Ef]);
            LineOfThreshold=line([threshold,threshold],ylim(obj.Axis));
        otherwise
            return;
    end
    hold(obj.Axis,'off');
    
    set(obj.LineOfEf,'LineStyle','--','Color','Red');
    set(obj.CurveOfFDD,'LineStyle',':','Color','Black');
    set(obj.CurveOfEDC,'Color','Blue','LineWidth',2);
    set(obj.CurveOfCorrEDC,'Color','Green','LineWidth',1);
    set(LineOfThreshold,'Color','Black','LineWidth',1);
    
end

function yData=fdDistribution(xData,Ef,kT,res)
% get extended data
M=length(xData);
N=floor(M/5);
step=xData(2)-xData(1);
maxX=max(xData);
minX=min(xData);
xDataLeft=minX-N*step:step:xData(1)-step;
xDataRight=xData(end)+step:step:maxX+N*step;
xDataExt=[xDataLeft,xData,xDataRight];
yFDD=1./(exp((xDataExt-Ef)/kT)+1);

% make resolution function
xResFunc=-N*step:step:N*step;
yResFunc=exp(-log(2)*xResFunc.^2/(res)^2);
% convolution
yFDDNew=conv(yFDD,yResFunc,'same');
yData=yFDDNew(N+1:M+N);
yData=yData/max(yData);
end






