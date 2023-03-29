function varNames = getDataNames()
% getData is used to retrieve data name(s) by selecting data name(s) in
% VarList in data browser.
%
% VarNames = getDataNames() returns var names selected.

h=findobj('Tag','DataBrowser');
if isempty(h)
    errordlg('Please open Data Browser');
    return;
end
handles_h = guidata(h);
if ~isfield(handles_h,'VarNames')
    varNames=[];
else
    varNames = handles_h.VarNames;
end