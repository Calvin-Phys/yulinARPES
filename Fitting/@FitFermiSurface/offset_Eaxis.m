function offset_Eaxis(obj,varargin)
    %OFFSET_EAXIS Shifts the energy axis by fitted Ef value
    %   Detailed explanation goes here
    tabledata=get(obj.ParameterTable,'Data');
    Ef=tabledata{1,1};
    
    h=findobj('Tag','DataBrowser');
    if isempty(h)
        errordlg('Please open Data Browser');
    end
    handles_h = guidata(h);
    var_name = handles_h.VarNames;

    data = evalin('base',var_name{1});
    
    if isfield(data,'z') || isprop(data,'z')
        data.z=data.z-Ef;
    else
        data.y=data.y-Ef;
    end
    assignin('base',[var_name{1} '_offset'],data);

end

