function report = test_ARPES_data_browser_v5_layout(outputFolder)
%TEST_ARPES_DATA_BROWSER_V5_LAYOUT Exercise v5 without GUI Layout Toolbox.
%   Optional OUTPUTFOLDER receives synthetic-fixture screenshots.
if nargin<1, outputFolder=''; end
assert(isempty(findall(groot,'Tag','ARPESDataBrowserV5')), ...
    'Close browser v5 before running this isolated layout test.');
initialFigures=findall(groot,'Type','figure');
originalPath=path;
fixtureNames={'v5layout_map','v5layout_cube'};
for k=1:numel(fixtureNames)
    assert(~evalin('base',sprintf('exist(''%s'',''var'')',fixtureNames{k})), ...
        'Fixture name already exists.');
end
cleanup=onCleanup(@()finish(originalPath,fixtureNames,initialFigures));
% Remove the package roots from this session only; never uninstall the add-on.
folders=strsplit(path,pathsep);
for k=1:numel(folders)
    if isfolder(fullfile(folders{k},'+uiextras')) || isfolder(fullfile(folders{k},'+uix'))
        rmpath(folders{k});
    end
end
assert(isempty(which('uiextras.HBox')) && isempty(which('uix.HBox')), ...
    'GUI Layout Toolbox must not resolve during this test.');
source=fileread(which('ARPES_data_browser_v5'));
assert(isempty(regexp(source,'\<(uiextras|uix)\.','once')));
map=struct('value',reshape(1:30,5,6),'x',linspace(-1,1,5), ...
    'y',linspace(-2,2,6),'info',struct('GroupInfo',[0 0 0 0],'note','Layout fixture'));
assignin('base',fixtureNames{1},map);
fig=ARPES_data_browser_v5;
handles=guidata(fig);
set(handles.Search,'String','v5layout_');
ARPES_data_browser_v5('refresh');
ARPES_data_browser_v5('select',fixtureNames(1));
axesData=get(handles.AxisTable,'Data');
assert(isequal(axesData(:,[1:4 6]), ...
    {'X','-1.00','1.00',5,'OK';'Y','-2.00','2.00',6,'OK'}));
assert(all(abs(cell2mat(axesData(:,5))-[.5;.8])<1e-12));
ARPES_data_browser_v5('membership','add',2);
ARPES_data_browser_v5('group',2);
state=ARPES_data_browser_v5('read');
assert(isequal(state.names,fixtureNames(1)') && isequal(state.selected,fixtureNames(1)'));
assert(isequal(get(handles.VarList,'Parent'),handles.Group2));
assert(isequal(evalin('base','v5layout_map.info.GroupInfo'),[0 1 0 0]));
ARPES_data_browser_v5('typefilter','cut');
state=ARPES_data_browser_v5('read');
assert(isempty(state.names));
ARPES_data_browser_v5('typefilter','all');
ARPES_data_browser_v5('select',fixtureNames(1));

% Test growing, shrinking, minimum-size enforcement, and non-pixel figure units.
browserSizes=[600 460; 600 450; 960 720; 601 451; 400 300];
for k=1:size(browserSizes,1)
    set(fig,'Position',[180 180 browserSizes(k,:)]); drawnow;
    bounds=getpixelposition(fig);
    % Windows display scaling can round a logical pixel to a device pixel.
    assert(all(abs(bounds(3:4)-max(browserSizes(k,:),[600 450]))<1), ...
        'Unexpected browser size: requested %s, received %s.', ...
        mat2str(browserSizes(k,:)),mat2str(bounds(3:4)));
    left=getpixelposition(handles.Layout.Left);
    right=getpixelposition(handles.Layout.Right);
    assert(abs(left(3)-bounds(3)/2)<1 && abs(right(3)-bounds(3)/2)<1);
    assert(abs(right(1)-left(1)-left(3))<1);
    assertContained(handles.Layout.Root);
    assertContained(handles.Layout.Left);
    assertContained(handles.Layout.Right);
    assertContained(handles.Layout.Search);
    assertContained(handles.Layout.Actions);
    assertContained(handles.Layout.Edit);
    if ~isempty(outputFolder) && k<=3
        if ~isfolder(outputFolder), mkdir(outputFolder); end
        frame=getframe(fig);
        imwrite(frame.cdata,fullfile(outputFolder,sprintf('browser_v5_native_%d.png',k)));
    end
end
set(fig,'Units','normalized');
bounds=getpixelposition(fig); bounds(3:4)=[620 480];
setpixelposition(fig,bounds); drawnow;
left=getpixelposition(handles.Layout.Left);
assert(abs(left(3)-310)<1 && strcmp(get(fig,'Units'),'normalized'));
set(fig,'Units','pixels');

% Exercise the actual context action and Save callback for index mapping.
combine=findall(get(handles.VarList,'UIContextMenu'),'Label','Combine');
action=findall(combine,'Label','2D cuts -> 3D');
fire(action);
dialog=findall(groot,'Tag','enter file name');
assert(isscalar(dialog));
panel=findall(dialog,'Tag','RearrangeInputs');
assert(isa(panel,'matlab.ui.container.Panel'));
dialogSizes=[200 150; 320 250];
for dimensions=dialogSizes'
    set(dialog,'Position',[500 400 dimensions']); drawnow;
    children=flipud(get(panel,'Children'));
    for k=1:numel(children)
        bounds=getpixelposition(children(k));
        assert(abs(bounds(3)-dimensions(1))<1 && abs(bounds(4)-dimensions(2)/5)<1);
    end
    assertContained(panel);
end
set(findall(dialog,'Style','popupmenu'),'Value',3);
set(findall(dialog,'Style','edit'),'String',fixtureNames{2});
fire(findall(dialog,'Style','pushbutton','String','Save'));
cube=evalin('base',fixtureNames{2});
assert(isequal(cube.x,1) && isequal(cube.y,map.x) && isequal(cube.z,map.y));
assert(isequal(reshape(cube.value,5,6),map.value));
assert(strcmp(get(dialog,'Visible'),'off'));
assert(isempty(which('uiextras.HBox')) && isempty(which('uix.HBox')));
report=struct('release',version,'passed',true,'toolboxOnPath',false, ...
    'resizeCases',size(browserSizes,1)+1+size(dialogSizes,1),'dialogSave',true);
disp(report);
end

function assertContained(panel)
bounds=getpixelposition(panel);
children=get(panel,'Children');
for k=1:numel(children)
    position=getpixelposition(children(k));
    assert(all(position(1:2)>=-1) && all(position(3:4)>0));
    assert(all(position(1:2)+position(3:4)<=bounds(3:4)+1));
end
end

function fire(control)
callback=get(control,'Callback');
if iscell(callback)
    feval(callback{1},control,[],callback{2:end});
else
    feval(callback,control,[]);
end
end

function finish(originalPath,fixtureNames,initialFigures)
figures=findall(groot,'Type','figure');
delete(figures(~ismember(figures,initialFigures)));
evalin('base',['clear ' strjoin(fixtureNames,' ')]);
path(originalPath);
end
