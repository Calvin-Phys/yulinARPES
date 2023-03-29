function [Parameter0,ParameterF,ParameterL,ParameterU]=getParameterTable(obj,varargin)
tabledata=get(obj.ParameterTable,'Data');
FieldName = {'Ef','Et','Ew','dE','dK','p','m'};
for i = 1:length(FieldName)
    Parameter0.(FieldName{i})=str2num(tabledata{i,1}); %#ok<ST2NM>
    ParameterF.(FieldName{i})=tabledata{i,2};
    ParameterL.(FieldName{i})=str2num(tabledata{i,3}); %#ok<ST2NM>
    ParameterU.(FieldName{i})=str2num(tabledata{i,4}); %#ok<ST2NM>
end
Parameter0.Et=Parameter0.Et*8.61733e-5;
end

