function getFromWorkspace(obj,varargin)
% DataName=getDataNames;
% DataName=DataName{1};
% data1=evalin('base',DataName);
% data.value=data1.value;
% data.x=data1.x;
% obj.Data=data;
% y1=num2str(min(data.x(:)));
% y2=num2str(max(data.x(:)));
% tabledata=get(obj.Table,'Data');
% tabledata{2}=y1;
% tabledata{3}=y2;
% set(obj.Table,'Data',tabledata);

    h=findobj('Tag','DataBrowser');
    if isempty(h)
        errordlg('Please open Data Browser');
    end
    handles_h = guidata(h);
    VarNames = handles_h.VarNames; %get VarNames
    index_size=length(VarNames);
    if index_size==0
        return;
    end

    var_name = VarNames{1};  %determine the var in base
    data=evalin('base',var_name);

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