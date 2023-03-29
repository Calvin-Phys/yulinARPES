function menuConstruct(obj)
hmenu=uimenu(obj.Figure,'Label','ARPES Tools');
uimenu(hmenu,'Label','Plot In New Figure','Callback',{@plotInNewFigure,obj});
uimenu(hmenu,'Label','Save Corrected Data To WorkSpace','Callback',{@saveToWorkSpace,obj});
end

function plotInNewFigure(~,~,obj)
h=figure('Name','EDC Correction');
h=axes('Parent',h);
xData=get(obj.CurveOfCorrEDC,'XData');
yData=get(obj.CurveOfCorrEDC,'YData');
plot(h,xData,yData);
axis tight;
end

function saveToWorkSpace(~,~,obj)
direction=get(obj.SelectDirection,'String');
num=get(obj.SelectDirection,'Value');
direction=direction{num};
switch direction
    case 'x-y'
        xData=obj.Data.x;
        yData=get(obj.CurveOfCorrEDC,'YData');
    case 'y-x'
        xData=get(obj.CurveOfCorrEDC,'XData');
        yData=obj.Data.x;
    otherwise
        return;
end
data.x=xData;
data.value=yData;
SaveName=inputdlg({'Data Name'},...
    'Save Corrected EDC Data',...
    1,...
    {'EDC_corr'});
if isempty(SaveName)
    return;
end
assignin('base',SaveName{1},data);
end