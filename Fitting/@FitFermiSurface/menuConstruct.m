function menuConstruct(obj)
hmenu=uimenu(obj.Figure,'Label','ARPES Tools');
uimenu(hmenu,'Label','Plot In New Figure','Callback',{@plotInNewFigure,obj});
uimenu(hmenu,'Label','Save Corrected Data To WorkSpace','Callback',{@saveToWorkSpace,obj});
end
function plotInNewFigure(~,~,obj)
h=figure('Name','Furmi Surface Fitting');
copyobj(obj.Axis,h);
end

function saveToWorkSpace(~,~,obj)
data=obj.DataCorr;
SaveName=inputdlg({'Data Name'},...
    'Save Fitted EDC Data',...
    1,...
    {'Fit FS'});
if isempty(SaveName)
    return;
end
assignin('base',SaveName{1},data);
end