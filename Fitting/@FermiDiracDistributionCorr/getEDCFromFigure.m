function getEDCFromFigure(obj,varargin)
direction=get(obj.SelectDirection,'String');
num=get(obj.SelectDirection,'Value');
direction=direction{num};

% Get target figure
figureNum=get(obj.InputFigureNum,'String');
figureNum=str2double(figureNum);
h=figure(figureNum);

% Get all children from the figure object
hList=findobj(h);

% Determine whether hList(i) is an EDC curve and get data  
data=[];
for i = 1:length(hList)
    if isaEDC(hList(i));
        data.x=get(hList(i),'XData');
        data.y=get(hList(i),'YData');        
    end
end
if ~isempty(data)
obj.Data=data;
switch direction
    case 'x-y'
        obj.Data.y=data.y/max(data.y(:));
    case 'y-x'
        obj.Data.x=data.x/max(data.x(:));
end
obj.plot;
end
% Normalization

end

function flag=isaEDC(h)
flag=0;
if isa(h,'matlab.graphics.primitive.Line')...
        ||isa(h,'matlab.graphics.chart.primitive.Line')
    xData=get(h,'XData');
    if length(xData)>4 % an EDC curve often has more than 4 data points
        flag=1;
    end
end
end

