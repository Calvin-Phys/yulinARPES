function setParameterTable(obj,Parameter0)
Parameter0.Et=Parameter0.Et/8.61733e-5;
tabledata=get(obj.ParameterTable,'Data');
FieldName = {'Ef','Et','Ew','dE','dK','p','m'};
for i = 1:length(FieldName)
    tabledata{i,1}=num2str(Parameter0.(FieldName{i}));
end
set(obj.ParameterTable,'Data',tabledata);
end

