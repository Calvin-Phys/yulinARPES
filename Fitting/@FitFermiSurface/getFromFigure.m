function getFromFigure(obj,varargin)

    tabledata=get(obj.Table,'Data');
    FigureNum = str2double(tabledata{1});
    % Get all children from the figure object
    h=figure(FigureNum);
    hList=findobj(h);
    % Determine whether hList(i) is an EDC curve and get data
    data=[];
    for i = 1:length(hList)
%         disp(hList(i));
        if isa(hList(i),'matlab.graphics.primitive.Image')
            h0=hList(i);
        end
    end
    % Get Data Range
    rect=getrect(figure(FigureNum));
    x1=rect(1);
    x2=rect(1)+rect(3);
    y1=rect(2);
    y2=rect(2)+rect(4);
    x=get(h0,'XData');
    y=get(h0,'YData');
    [~,xind1]=min(abs(x-x1));
    [~,xind2]=min(abs(x-x2));
    [~,yind1]=min(abs(y-y1));
    [~,yind2]=min(abs(y-y2));
    tabledata{2}=num2str(y1);
    tabledata{3}=num2str(y2);
    set(obj.Table,'Data',tabledata);
    % Get Data
    data.value=get(h0,'CData');
    data.x=y(yind1:yind2)';
    data.value=sum(data.value(yind1:yind2,xind1:xind2),2);
    data.value=data.value(:)';
    
    % Plot
    plot(obj.Axis,data.value,data.x);
    axis(obj.Axis,'tight');
    obj.Data=data;
    
    tabledata_full=get(obj.ParameterTable,'Data');
    tabledata_full{1,1}=max(data.x)-min(data.x);
    tabledata_full{1,3}=min(data.x);
    tabledata_full{1,4}=max(data.x);
    set(obj.ParameterTable,'Data',tabledata_full);

end