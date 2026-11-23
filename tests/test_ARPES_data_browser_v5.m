function report = test_ARPES_data_browser_v5
% Synthetic callback comparisons; owned workspace variables/figures only.
initialFigures=findall(groot,'Type','figure');
existingOld=findall(groot,'Tag','DataBrowser');
savedControls=findall(existingOld,'Type','uicontrol');
savedProperties=cell(numel(savedControls),1);
for j=1:numel(savedControls)
    savedProperties{j}=get(savedControls(j),{'String','Value','BackgroundColor'});
end

root=fileparts(fileparts(mfilename('fullpath')));
fixtureNames={'v5test_spectrum','v5test_map','v5test_cube','v5test_short','v5test_missing','v5test_missing_onan','v5test_map3d','v5test_tof','v5test_4d','v5test_ordinary','v5test_legacy'};
for k=1:numel(fixtureNames)
    assert(~evalin('base',sprintf('exist(''%s'',''var'')',fixtureNames{k})), 'Fixture name already exists.');
end
hadPref=ispref('ARPESDataBrowserV5','GroupNames');
oldPref=getpref('ARPESDataBrowserV5','GroupNames',{});
cleanup=onCleanup(@()finish(fixtureNames,hadPref,oldPref,savedControls,savedProperties,initialFigures));
spectrum=struct('value',[2 4 3 8],'x',[-1 0 1 2], ...
    'info',struct('GroupInfo',[1 0 0 0],'note','Synthetic spectrum'));
map=struct('value',reshape(1:30,5,6),'x',linspace(-1,1,5), ...
    'y',linspace(-2,2,6),'info',struct('GroupInfo',[0 1 0 0],'photonEnergy',21.2));
cube=struct('value',reshape(1:60,3,4,5),'x',[0 1 3],'y',1:4,'z',1:5, ...
    'info',struct('GroupInfo',[0 0 1 0]));
short=struct('value',1:4,'x',0,'info',struct('GroupInfo',[0 0 0 0]));
missing=struct('value',[NaN 1;2 Inf]);
source=spectrum; spectrum=OxArpes_1D_Data(source); spectrum.info=source.info;
source=map; map=OxA_CUT(source); map.info=source.info;
source=cube; cube=OxA_KZ(source); cube.info=source.info;
source=short; short=OxArpes_1D_Data; short.value=source.value; short.x=source.x; short.info=source.info;
source=missing; missing=OxArpes_2D_Data; missing.value=source.value; missing.info=[];
values={spectrum,map,cube,short,missing};
for k=1:numel(values), assignin('base',fixtureNames{k},values{k}); end
new=ARPES_data_browser_v5;
data_browser_demo_v32;
old=findall(groot,'Tag','DataBrowser');
a=guidata(old); b=guidata(new);
fire(a.GroupAll);
ARPES_data_browser_v5('group',0);
ARPES_data_browser_v5('typefilter','all');
assert(all(ismember(fixtureNames(1:5),get(a.VarList,'String'))));
assert(all(ismember(fixtureNames(1:5),namesIn(b))));
% Top-level menu leaf dispatch remains equivalent despite label/group changes.
oldCallbacks=menuTargets(old); newCallbacks=menuTargets(new);
assert(isequal(sort(oldCallbacks),sort(newCallbacks)),'Menu dispatch changed.');
loadMenu=findall(new,'Type','uimenu','Label','Load');
loader=findall(loadMenu,'Label','ARPES loader (new)');
assert(isequal(get(loader,'Parent'),loadMenu) && get(loader,'Position')==1);
process=findall(new,'Type','uimenu','Label','Process');
fine=findall(process,'Label','Fine structure');
assert(isequal(get(fine,'Parent'),process) && strcmp(get(fine,'Separator'),'off'));
assert(numel(get(fine,'Children'))==6);
toolbox=findall(process,'Label','Processing toolbox');
assert(get(fine,'Position')<get(toolbox,'Position') && strcmp(get(toolbox,'Separator'),'on'));

fprintf('PASS: fixture discovery and all %d menu dispatch targets.\n',numel(oldCallbacks));
% Same 1D plot callback route and exact sampled output.
curves=cell(1,2);
for k=1:2
    if k==1, f=old; h=a; else, f=new; h=b; end
    select(h,'v5test_spectrum');
    set(f,'SelectionType','open'); fire(h.VarList); set(f,'SelectionType','normal');
    line=findall(gcf,'Type','line');
    curves{k}={get(line(1),'XData'),get(line(1),'YData')};
    delete(gcf);
end
assert(isequal(curves{1},curves{2}));
assert(isequal(curves{2}{1},spectrum.x) && isequal(curves{2}{2},spectrum.value));
fprintf('PASS: v32 double-click / v5 table Enter plotting match fixture samples.\n');
% Use Swing events before R2025a; invoke the documented callback thereafter.
% Repeated double-clicks must work even when selection does not change.
select(b,'v5test_spectrum');
rows=namesIn(b); spectrumRow=find(strcmp(rows,'v5test_spectrum'));
figuresBefore=findall(groot,'Type','figure');
dispatchMouse(b.VarList,spectrumRow,1,1);
assert(numel(findall(groot,'Type','figure'))==numel(figuresBefore));
for repeat=1:2
    dispatchMouse(b.VarList,spectrumRow,2,1);
    created=setdiff(findall(groot,'Type','figure'),figuresBefore);
    assert(numel(created)==repeat,'Double-click must create exactly one plot.');
    for j=1:numel(created)
        line=findall(created(j),'Type','line');
        assert(isequal(get(line(1),'XData'),spectrum.x));
        assert(isequal(get(line(1),'YData'),spectrum.value));
    end
end
dispatchMouse(b.VarList,spectrumRow,2,3);
dispatchMouse(b.VarList,numel(rows)+2,2,1);
assert(numel(setdiff(findall(groot,'Type','figure'),figuresBefore))==2);
delete(setdiff(findall(groot,'Type','figure'),figuresBefore));
% Tab reparenting must retain the native mouse bridge and clicked-row identity.
fire(b.Group1); fire(b.GroupAll);
select(b,'v5test_map');
rows=namesIn(b); spectrumRow=find(strcmp(rows,'v5test_spectrum'));
dispatchMouse(b.VarList,spectrumRow,2,1);
created=setdiff(findall(groot,'Type','figure'),figuresBefore);
assert(isscalar(created));
line=findall(created,'Type','line'); assert(isequal(get(line(1),'YData'),spectrum.value));
state=ARPES_data_browser_v5('read'); assert(strcmp(state.selected{1},'v5test_spectrum'));
delete(created);
fprintf('PASS: repeated double-click, clicked-row identity and tab switching.\n');

% Actual context callbacks: add and move preserve the existing semantics.
for k=1:2
    if k==1, h=a; else, h=b; end
    assignin('base','v5test_spectrum',spectrum);
    fire(h.GroupAll); select(h,'v5test_spectrum');
    add=findall(get(h.VarList,'UIContextMenu'),'Label','Add to');
    child=get(add,'Children'); fire(child(end-1));
    flags=evalin('base','v5test_spectrum.info.GroupInfo');
    assert(isequal(flags,[1 1 0 0]));
    fire(h.Group1); select(h,'v5test_spectrum');
    move=findall(get(h.VarList,'UIContextMenu'),'Label','Move to');
    child=get(move,'Children'); fire(child(end-1));
    flags=evalin('base','v5test_spectrum.info.GroupInfo');
    assert(isequal(flags,[0 1 0 0]));
end
fprintf('PASS: v32/v5 add and cross-group move callbacks agree.\n');
ARPES_data_browser_v5('group',2); ARPES_data_browser_v5('select',{'v5test_spectrum'});
ARPES_data_browser_v5('membership','move',2);
assert(isequal(evalin('base','v5test_spectrum.info.GroupInfo'),[0 1 0 0]));
ARPES_data_browser_v5('membership','remove',2);
assert(isequal(evalin('base','v5test_spectrum.info.GroupInfo'),[0 0 0 0]));
ARPES_data_browser_v5('group',0); ARPES_data_browser_v5('select',{'v5test_missing'});
ARPES_data_browser_v5('membership','add',4);
assert(isequal(evalin('base','v5test_missing.info.GroupInfo'),[0 0 0 1]));
assert(isequaln(evalin('base','v5test_missing.value'),missing.value));
fprintf('PASS: same-group move, remove, empty metadata, data preservation.\n');
% Compare an actual processing callback and verify the source remains intact.
for k=1:2
    if k==1, h=a; else, h=b; end
    fire(h.GroupAll); select(h,'v5test_missing'); fire(h.VarList);
    action=findall(get(h.VarList,'UIContextMenu'),'Label','Replace NaNs with zero');
    fire(action);
    processed=evalin('base','v5test_missing_onan');
    assert(isequaln(processed.value,[0 1;2 Inf]));
    assert(isequaln(evalin('base','v5test_missing.value'),missing.value));
end
evalin('base','clear v5test_missing_onan');
ARPES_data_browser_v5('refresh');
fprintf('PASS: v32/v5 NaN replacement matches; source and Inf retained.\n');

% Details, name-based selection, search, empty states and singleton persistence.
ARPES_data_browser_v5('select',{'v5test_short'});
rows=get(b.AxisTable,'Data'); assert(strcmp(rows{1,6},'Expected 4 samples'));
ARPES_data_browser_v5('select',{'v5test_cube'});
rows=get(b.AxisTable,'Data'); assert(strcmp(rows{1,5},'nonuniform'));
assert(isa(b.GroupTabs,'matlab.ui.container.TabGroup'));
assert(isa(b.VarList,'matlab.ui.control.Table'));
assert(b.VarList.FontSize==8 && strcmp(b.VarList.FontUnits,'points'));
controls=findall(new,'Type','uicontrol');
assert(all(cellfun(@(size)size==8,get(controls,'FontSize'))));
assert(b.AxisTable.FontSize==8 && b.Metadata.FontSize==8);
assert(isempty(findall(new,'Tag','DataSummary')));
entries=get(b.VarList,'Data');
row=find(strcmp(entries(:,1),'v5test_cube'));
assertClassColor(b.VarList,row,'OxA_KZ',[138 62 168]/255);
assert(~isempty(regexp(entries{row,3},'^\d+(\.\d+)? (B|KiB|MiB|GiB)$','once')));
% A native selection event can cover several cells in each selected row.
selectCallback=get(b.VarList,'CellSelectionCallback');
feval(selectCallback,b.VarList,struct('Indices',[row 1; row 2]));
assert(isequal(getappdata(b.VarList,'SelectedRows'),row));
other=find(strcmp(entries(:,1),'v5test_short'));
feval(selectCallback,b.VarList,struct('Indices',[row 1; row 2; other 3]));
selected=ARPES_data_browser_v5('read');
assert(isequal(selected.selected,{'v5test_cube';'v5test_short'}));

fire(b.Group3);
assert(isequal(get(b.VarList,'Parent'),b.Group3));
assert(all(ismember({'v5test_cube'},namesIn(b))));
ARPES_data_browser_v5('group',0);
ARPES_data_browser_v5('select',{'v5test_map'});
metadata=get(b.Metadata,'Data');
assert(isequal(metadata(:,1),{'GroupInfo';'photonEnergy'}));
assert(strcmp(metadata{2,2},'21.2'));
rows=get(b.AxisTable,'Data');
assert(isequal(rows(1,2:3),{'-1.00','1.00'}));
assert(isempty(strfind(get(b.GroupName,'String'),newline))); %#ok<STREMP>
columns=findall(new,'Tag','BrowserColumns');
set(new,'Position',[180 180 600 460]); drawnow;
children=get(columns,'Children');
for j=1:numel(children)
    bounds=getpixelposition(children(j));
    assert(abs(bounds(3)-300)<1,'Each default column must be 300 pixels wide.');
end
ARPES_data_browser_v5('select',{'v5test_cube'});

ARPES_data_browser_v5('renamegroup',1,'Test spectra');
assert(strcmp(get(b.AddMenus(1),'Label'),'Test spectra'));
set(b.Search,'String','v5test_'); fire(b.Search);
state=ARPES_data_browser_v5('read'); assert(strcmp(state.selected{1},'v5test_cube'));
assert(numel(state.names)==5);
ARPES_data_browser_v5; assert(isequal(ARPES_data_browser_v5('read'),state));
set(b.Search,'String','no_matching_fixture'); fire(b.Search);
assert(isempty(getappdata(b.VarList,'SelectedRows')) && isempty(get(b.AxisTable,'Data')));
set(b.Search,'String',''); fire(b.Search);
fprintf('PASS: details, rename synchronization, search, empty selection, singleton state.\n');
% New filters use real classes, never variable names or guessed dimensions.
source=cube; map3d=OxA_MAP(source); tof=OxA_MAP_ToF(source);
four=OxArpes_4D_Data; four.value=zeros(2,2,2,128); four.info=struct;
assignin('base','v5test_map3d',map3d); assignin('base','v5test_tof',tof);
assignin('base','v5test_4d',four); assignin('base','v5test_ordinary',42);
assignin('base','v5test_legacy',struct('value',1:4));
set(b.Search,'String','v5test_'); fire(b.Search);
types={'all','cut','map','kz','4d','1d'};
expected={{'v5test_spectrum','v5test_short','v5test_map','v5test_cube','v5test_missing', ...
    'v5test_map3d','v5test_tof','v5test_4d','v5test_ordinary','v5test_legacy'}, {'v5test_map'}, ...
    {'v5test_map3d','v5test_tof'}, {'v5test_cube'}, {'v5test_4d'}, ...
    {'v5test_spectrum','v5test_short'}};
for k=1:numel(types)
    button=findobj(b.TypeFilter,'Tag',['Type_' types{k}]);
    set(b.TypeFilter,'SelectedObject',button);
    feval(get(b.TypeFilter,'SelectionChangedFcn'),b.TypeFilter,[]);
    assert(isequal(sort(namesIn(b)),sort(expected{k}(:))));
    state=ARPES_data_browser_v5('read'); assert(strcmp(state.typeFilter,types{k}));
    data=get(b.VarList,'Data');
    if strcmp(types{k},'all')
        assert(any(contains(data(:,3),'KiB')));
        names=data(:,1);
        assertClassColor(b.VarList,find(strcmp(names,'v5test_map')),'OxA_CUT',[23 102 166]/255);
        assertClassColor(b.VarList,find(strcmp(names,'v5test_map3d')),'OxA_MAP',[22 115 74]/255);
        assertClassColor(b.VarList,find(strcmp(names,'v5test_tof')),'OxA_MAP_ToF',[22 115 74]/255);
        assertClassColor(b.VarList,find(strcmp(names,'v5test_cube')),'OxA_KZ',[138 62 168]/255);
    end
    for j=1:size(data,1)
        number=strtok(data{j,3});
        assert(~contains(number,'e'));
        digits=regexprep(number,'[^0-9]','');
        digits=regexprep(digits,'^0+','');
        assert(numel(digits)<=3,'Size must use at most three significant digits.');
    end
end
ARPES_data_browser_v5('group',2);
ARPES_data_browser_v5('typefilter','kz');
assert(isempty(namesIn(b)) && strcmp(get(b.EditVariable,'Enable'),'off'));
ARPES_data_browser_v5('group',0); ARPES_data_browser_v5('typefilter','all');
ARPES_data_browser_v5('select',{'v5test_map'});
editMenu=findall(get(b.VarList,'ContextMenu'),'Label','Edit Variable');
assert(isequal(get(b.EditVariable,'Callback'),get(editMenu,'Callback')));
assert(strcmp(get(b.EditVariable,'Enable'),'on'));
evalin('base','clear v5test_map3d v5test_tof v5test_4d v5test_ordinary v5test_legacy');
ARPES_data_browser_v5('refresh');
fprintf('PASS: six OX class filters, composition, three-digit sizes and Edit Variable callback.\n');
% Capture populated real GUIs, including the smaller supported layout.
set(b.Search,'String','v5test_'); fire(b.Search);
ARPES_data_browser_v5('select',{'v5test_map'});
drawnow; frame=getframe(new); imwrite(frame.cdata,fullfile(root,'doc','ARPES_data_browser_v5_interface.png'));
set(new,'Position',[160 180 600 450]); drawnow;
frame=getframe(new); imwrite(frame.cdata,fullfile(root,'doc','ARPES_data_browser_v5_compact.png'));
fire(a.GroupAll); select(a,'v5test_map'); fire(a.VarList); drawnow;
frame=getframe(old); imwrite(frame.cdata,fullfile(root,'doc','ARPES_data_browser_v32_comparison.png'));
report=struct('release',version,'passed',true,'checks',8,'topMenuTargets',numel(oldCallbacks));
disp(report);
end
function finish(fixtureNames,hadPref,oldPref,savedControls,savedProperties,initialFigures)
        new=findall(groot,'Tag','ARPESDataBrowserV5');
        evalin('base',['clear ' strjoin(fixtureNames,' ')]);
        if hadPref, setpref('ARPESDataBrowserV5','GroupNames',oldPref);
        elseif ispref('ARPESDataBrowserV5','GroupNames'), rmpref('ARPESDataBrowserV5','GroupNames'); end
        for j=1:numel(savedControls)
            if isgraphics(savedControls(j))
                set(savedControls(j),{'String','Value','BackgroundColor'},savedProperties{j});
            end
        end
        figures=findall(groot,'Type','figure');
        delete(figures(~ismember(figures,initialFigures)));
        if isgraphics(new)
            handles=guidata(new);
            labels=getpref('ARPESDataBrowserV5','GroupNames',{'Group 1','Group 2','Group 3','Group 4'});
            handles.GroupLabels=labels;
            for j=1:4
                set(handles.AddMenus(j),'Label',labels{j}); set(handles.MoveMenus(j),'Label',labels{j});
            end
            set(handles.GroupTarget,'String',labels);
            set(handles.Search,'String','');
            set(new,'Position',[180 180 600 460]);
            guidata(new,handles); ARPES_data_browser_v5('group',0);
        end
end
function fire(h)
if isa(h,'matlab.ui.container.Tab')
    tabs=get(h,'Parent');
    set(tabs,'SelectedTab',h);
    callback=get(tabs,'SelectionChangedFcn');
    feval(callback,tabs,[]);
    return;
end
if isa(h,'matlab.ui.control.Table')
    fig=ancestor(h,'figure');
    if strcmp(get(fig,'SelectionType'),'open')
        callback=get(h,'KeyPressFcn'); feval(callback,h,struct('Key','return'));
    else
        rows=getappdata(h,'SelectedRows');
        callback=get(h,'CellSelectionCallback');
        feval(callback,h,struct('Indices',[rows(:) ones(numel(rows),1)]));
    end
    return;
end
callback=get(h,'Callback');
if iscell(callback), feval(callback{1},h,[],callback{2:end}); else, feval(callback,h,[]); end
end
function select(handles,name)
names=namesIn(handles);
indices=find(strcmp(names,name));
if isa(handles.VarList,'matlab.ui.control.Table')
    callback=get(handles.VarList,'CellSelectionCallback');
    feval(callback,handles.VarList,struct('Indices',[indices(:) ones(numel(indices),1)]));
else
    set(handles.VarList,'Value',indices);
end
end
function targets=menuTargets(fig)
menus=findall(fig,'Type','uimenu'); targets={};
for k=1:numel(menus)
    cb=get(menus(k),'Callback');
    ancestor=get(menus(k),'Parent');
    while isa(ancestor,'matlab.ui.container.Menu'), ancestor=get(ancestor,'Parent'); end
    if isequal(ancestor,fig) && isa(cb,'function_handle')
        targets{end+1}=func2str(cb); %#ok<AGROW>
    end
end
end


function names=namesIn(handles)
if isa(handles.VarList,'matlab.ui.control.Table')
    data=get(handles.VarList,'Data'); names=data(:,1);
else
    names=get(handles.VarList,'String');
end
end

function dispatchMouse(table,row,count,button)
if ~isMATLABReleaseOlderThan('R2025a')
    % Callback-level coverage only; OS mouse interaction is a manual check.
    if count~=2 || button~=1, return; end
    if row>size(table.Data,1), row=[]; end
    event=struct('InteractionInformation',struct('Row',row,'Column',1));
    feval(get(table,'DoubleClickedFcn'),table,event);
    drawnow;
    return;
end
peer=getappdata(table,'MousePeer');
rectangle=peer.getCellRect(row-1,0,true);
event=javaObject('java.awt.event.MouseEvent',peer, ...
    java.awt.event.MouseEvent.MOUSE_CLICKED,java.lang.System.currentTimeMillis, ...
    0,rectangle.x+5,(row-1)*peer.getRowHeight()+5,count,false,button);
javaMethodEDT('dispatchEvent',peer,event);
drawnow;
end

function assertClassColor(table,row,className,rgb)
data=get(table,'Data');
if isMATLABReleaseOlderThan('R2025a')
    hex=sprintf('#%02X%02X%02X',round(255*rgb));
    assert(contains(data{row,2},className) && contains(data{row,2},hex));
    return;
end
assert(strcmp(data{row,2},className),'Native table class text must be literal.');
styles=table.StyleConfigurations;
for k=1:height(styles)
    if strcmp(styles.Target(k),'cell') && ...
            ismember([row 2],styles.TargetIndex{k},'rows')
        assert(isequal(styles.Style(k).FontColor,rgb));
        return;
    end
end
error('No native colour style found for class cell.');
end
