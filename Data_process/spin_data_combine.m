function spin_data_combine(varargin)

varnames=getDataNames;
if length(varnames)~=2
    errordlg('Please selcet two data sets')
    return
end
%% Choice
tstring='spin_data_combine';
qstring={'Compare the two spin data sets?',...
    ['A:',varnames{1}],['B:',varnames{2}]};
str1='(A-B)/(A+B)';
str2='(B-A)/(A+B)';
str3='Cancel';
answer=questdlg(qstring,tstring,str1,str2,str3,str1);
if strcmp(answer,str3)
    return;
elseif strcmp(answer,str2)
    temp=varnames{1};
    varnames{1}=varnames{2};
    varnames{2}=temp;
end
%% Process
data=cell(1,2);
for i=1:2
    data{i}=evalin('base',varnames{i});
end

if sum(abs(size(data{1}.value)-size(data{2}.value)))~=0
    errordlg('Data sets should have same sizes');
    return
end

if sum(abs(data{1}.x-data{2}.x))~=0
    errordlg('Data sets should have same data.x');
    return
end
if isfield(data{1},'y')
if sum(abs(data{1}.y-data{2}.y))~=0
    errordlg('Data sets should have same data.x');
    return
end
end

dataNew=data{1};
dataNew.value=(data{1}.value-data{2}.value)./(data{1}.value+data{2}.value);
% dataNewName=[varnames{1},'_spin'];
% assignin('base',dataNewName,dataNew);

%% Plot 1D data
if sum(size(dataNew.value)==1)==1
    tstring='spin_data_combine';
    qstring='Plot Result?';
    str1='Yes';
    str2='No';
    answer=questdlg(qstring,tstring,str1,str2,str1);
    if strcmp(answer,str2)
        return;
    end
    x=data{1}.x;
    v1=data{1}.value;
    v2=data{2}.value;
    v3=dataNew.value;
    varnamesNew=cell(1,2);
    for i=1:2
        varnamesNew{i}=strrep(varnames{i},'_','\_');
    end
    figure('Name',[varnames{1},' and ',varnames{2}]);
    plot(x,v1,x,v2);
    legend(varnamesNew{:})
    figure('Name',[varnames{1},' and ',varnames{2},' Difference']);
    plot(x,v3);
end

