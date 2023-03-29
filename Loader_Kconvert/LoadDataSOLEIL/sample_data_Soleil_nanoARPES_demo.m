function varargout=sample_data_Soleil_nanoARPES_demo(varargin)
%'sample_data_Soleil_nanoARPES_demo' samples large real space scan data or 
%map data in Soleil '.nxs' files, including a quick map to help sampling 
%
%To start the GUI, simply call 'sample_data_Soleil_nanoARPES_demo()'
%Or run 'sample_data_Soleil_nanoARPES_demo.fig'
%Or open with 'Data Browser Demo v2'
%
%This GUI is written by Shuzhan Sun
%sunshu@mail.ustc.edu.cn
%University of Science and Technology of China

% Last Modified by GUIDE v2.5 06-Aug-2015 11:19:29

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sample_data_Soleil_nanoARPES_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @sample_data_Soleil_nanoARPES_demo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% GUI CreateFcn
function sample_data_Soleil_nanoARPES_demo_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = sample_data_Soleil_nanoARPES_demo_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
function edit_current_folder_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox_current_folder_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_Raw_Data_Bytes_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_Expected_Bytes_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_Data_Type_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popup_Map_Type_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_1_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider_2_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function edit_1_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_2_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%
%function
function edit_current_folder_Callback(hObject, ~, ~)
%% Read Current Folder from Edit  
handles=guidata(hObject);

%reset current folder
handles.current_folder=get(handles.edit_current_folder,'String'); 
cd(handles.current_folder);  

%select all '*.nxs' of current folder
fileextension='*.nxs';  
DirRes=dir(fileextension);

% Get the files + directories names
[ListNames{1:length(DirRes),1}] = deal(DirRes.name);
    
% Get directories only
[DirOnly{1:length(DirRes),1}] = deal(DirRes.isdir);
    
% Turn into logical vector and take complement to get indexes of files
FilesOnly = ~cat(1, DirOnly{:});
ListNames = ListNames(FilesOnly);
set(handles.listbox_current_folder,'String', ListNames);

guidata(hObject,handles);

function pb_select_folder_Callback(hObject, ~, ~)
%% Push Button 'Browse...' to Select Current Folder
handles=guidata(hObject);

%reset current folder
handles.current_folder=uigetdir();  
set(handles.edit_current_folder,'String',handles.current_folder);
cd(handles.current_folder);  

%select all '*.nxs' of current folder
fileextension='*.nxs';  
DirRes=dir(fileextension);

% Get the files + directories names
[ListNames{1:length(DirRes),1}] = deal(DirRes.name);
    
% Get directories only
[DirOnly{1:length(DirRes),1}] = deal(DirRes.isdir);
    
% Turn into logical vector and take complement to get indexes of files
FilesOnly = ~cat(1, DirOnly{:});
ListNames = ListNames(FilesOnly);
set(handles.listbox_current_folder,'String', ListNames);

guidata(hObject,handles);

function listbox_current_folder_Callback(hObject, ~, ~)
%% Push Button 'Open' to Open Current File
handles=guidata( hObject );
handles.rawdata=cell(1,4); % x,y,z,k

%% get fullfilename
list_entries=get(handles.listbox_current_folder,'String');
index_selected=get(handles.listbox_current_folder,'Value');
name = list_entries{index_selected};
handles.fullfilename=fullfile(handles.current_folder,name);  

%% data size
details=dir(handles.fullfilename);
bytes_KB=floor(details.bytes/1024);
handles.rawdata_size=bytes_KB;
set(handles.edit_Raw_Data_Bytes,'String',num2str(bytes_KB));
set(handles.edit_Expected_Bytes,'String',num2str(bytes_KB));

%% Load Data  data.xyzk only
%clear previous data
set(handles.table_Raw_Data,'Data',NaN(4,4));
set(handles.table_Sampled_Data,'Data',NaN(4,4));
%filtrate file, too small file size means no data stored
if handles.rawdata_size<250 
    return;
end

hinfo = h5info(handles.fullfilename);
rootPath=hinfo.Groups(1).Name;

  %% if Map Data
n1 = length(hinfo.Groups);
k = 0;
UnsortedGroupList={};
for i = 1:n1
    n2 = length(hinfo.Groups(i).Groups);
    for j = 1:n2
        startInd = regexp(hinfo.Groups(i).Groups(j).Name,'/Scienta_0_\d*');
        if ~isempty(startInd)
            k=k+1;
            UnsortedGroupList{k}.path = hinfo.Groups(i).Groups(j).Name;
            UnsortedGroupList{k}.num = str2double(...
                UnsortedGroupList{k}.path(startInd+11:end));
        end
    end
end
n=length(UnsortedGroupList);
if n>0     % if '/Scienta_0' exists, then it is map data.
    SortedGroupPath=cell(1,n);
    for i = 1:n
        newNum = UnsortedGroupList{i}.num+1;
        path = UnsortedGroupList{i}.path;
        SortedGroupPath{newNum} = path;
    end
    % get data.x, data.y, data.z 
    for j = 1:length(SortedGroupPath)
        %phi is rotated while theta stays the same (sample position)
        data.x(j) = h5read(handles.fullfilename,[SortedGroupPath{j},'/Phi']);
        data.y = h5read(handles.fullfilename,[SortedGroupPath{j},'/sliceScale1'])';
        data.z = h5read(handles.fullfilename,[SortedGroupPath{j},'/channelScale1'])';    
    end
    
    %reset data type
    handles.datatype='Map Data';
    set(handles.edit_Data_Type,'String','Map Data');
    
    r_min=[min(data.x);min(data.y);min(data.z);NaN];
    r_max=[max(data.x);max(data.y);max(data.z);NaN];
    r_length=[length(data.x);length(data.y);length(data.z);NaN];
    r_dept=(r_max-r_min)./(r_length-1);
    data_range=[r_min,r_max,r_length,r_dept];
    
    handles.rawdata{4}=NaN(1,20);
end

  %% if Real Space Scan Data
idx=strfind(rootPath,'salsaentry_1');
if ~isempty(idx)
    idx=strfind(rootPath,'salsaentry_1_1');
    if ~isempty(idx)
        data.info.DataType='PIx-PIy';
        value_info=h5info(handles.fullfilename,[rootPath '/scan_data/data_04']);
    else
        data.info.DataType='PIx-ZPs';
        value_info=h5info(handles.fullfilename,[rootPath '/scan_data/data_02']);
    end
    value_size=value_info.Dataspace.Size;
    data.x=h5read(handles.fullfilename,[rootPath '/scan_data/trajectory_2_1']);
    data.y=h5read(handles.fullfilename,[rootPath '/scan_data/trajectory_1_1']);
    
    try
        data.k= h5read(handles.fullfilename,[rootPath,...
            '/ANTARES/ScientaAtt1/sliceScale/data']);
    catch
        warning([handles.fullfilename,...
            ' data.k',...
            ' is missing.',...
            ' Index are adopted.']);
        data.k=1:value_size(2);
    end
    try
        data.z= h5read(handles.fullfilename,[rootPath,...
            '/ANTARES/ScientaAtt1/channelScale/data']);
    catch
        warning([handles.fullfilename,...
            ' data.z',...
            ' is missing.',...
            ' Index are adopted.']);
        data.z=1:value_size(1);
    end
    
    if value_size(2)~=length(data.k)
        data.k=1:value_size(2);
    end
    if value_size(1)~=length(data.z)
        data.z=1:value_size(1);
    end
    
    %reset data type
    handles.datatype='Real Space Scan Data';
    set(handles.edit_Data_Type,'String','Real Space Scan Data');
    
    r_min=[min(data.x);min(data.y);min(data.z);min(data.k)];
    r_max=[max(data.x);max(data.y);max(data.z);max(data.k)];
    r_length=[length(data.x);length(data.y);length(data.z);length(data.k)];
    r_dept=(r_max-r_min)./(r_length-1);
    data_range=[r_min,r_max,r_length,r_dept];
    
    handles.rawdata{4}=data.k;
end

%% Store and Write Raw Data Range
set(handles.table_Raw_Data,'Data',data_range);
set(handles.table_Sampled_Data,'Data',data_range);
handles.rawdata{1}=data.x;
handles.rawdata{2}=data.y;
handles.rawdata{3}=data.z;

guidata(hObject,handles);

function pb_Open_File_Callback(hObject, ~, ~)
%% Push Button 'Open' to Open Current File
handles=guidata( hObject );
handles.rawdata=cell(1,4); % x,y,z,k

%% get fullfilename
list_entries=get(handles.listbox_current_folder,'String');
index_selected=get(handles.listbox_current_folder,'Value');
name = list_entries{index_selected};
handles.fullfilename=fullfile(handles.current_folder,name);  

%% data size
details=dir(handles.fullfilename);
bytes_KB=floor(details.bytes/1024);
handles.rawdata_size=bytes_KB;
set(handles.edit_Raw_Data_Bytes,'String',num2str(bytes_KB));
set(handles.edit_Expected_Bytes,'String',num2str(bytes_KB));

%% Load Data  data.xyzk only
%clear previous data
set(handles.table_Raw_Data,'Data',NaN(4,4));
set(handles.table_Sampled_Data,'Data',NaN(4,4));
%filtrate file, too small file size means no data stored
if handles.rawdata_size<250 
    return;
end

hinfo = h5info(handles.fullfilename);
rootPath=hinfo.Groups(1).Name;

  %% if Map Data
n1 = length(hinfo.Groups);
k = 0;
UnsortedGroupList={};
for i = 1:n1
    n2 = length(hinfo.Groups(i).Groups);
    for j = 1:n2
        startInd = regexp(hinfo.Groups(i).Groups(j).Name,'/Scienta_0_\d*');
        if ~isempty(startInd)
            k=k+1;
            UnsortedGroupList{k}.path = hinfo.Groups(i).Groups(j).Name;
            UnsortedGroupList{k}.num = str2double(...
                UnsortedGroupList{k}.path(startInd+11:end));
        end
    end
end
n=length(UnsortedGroupList);
if n>0     % if '/Scienta_0' exists, then it is map data.
    SortedGroupPath=cell(1,n);
    for i = 1:n
        newNum = UnsortedGroupList{i}.num+1;
        path = UnsortedGroupList{i}.path;
        SortedGroupPath{newNum} = path;
    end
    % get data.x, data.y, data.z 
    for j = 1:length(SortedGroupPath)
        %phi is rotated while theta stays the same (sample position)
        data.x(j) = h5read(handles.fullfilename,[SortedGroupPath{j},'/Phi']);
        data.y = h5read(handles.fullfilename,[SortedGroupPath{j},'/sliceScale1'])';
        data.z = h5read(handles.fullfilename,[SortedGroupPath{j},'/channelScale1'])';    
    end
    
    %reset data type
    handles.datatype='Map Data';
    set(handles.edit_Data_Type,'String','Map Data');
    
    r_min=[min(data.x);min(data.y);min(data.z);NaN];
    r_max=[max(data.x);max(data.y);max(data.z);NaN];
    r_length=[length(data.x);length(data.y);length(data.z);NaN];
    r_dept=(r_max-r_min)./(r_length-1);
    data_range=[r_min,r_max,r_length,r_dept];
    
    handles.rawdata{4}=NaN(1,20);
end

  %% if Real Space Scan Data
idx=strfind(rootPath,'salsaentry_1');
if ~isempty(idx)
    idx=strfind(rootPath,'salsaentry_1_1');
    if ~isempty(idx)
        data.info.DataType='PIx-PIy';
        value_info=h5info(handles.fullfilename,[rootPath '/scan_data/data_04']);
    else
        data.info.DataType='PIx-ZPs';
        value_info=h5info(handles.fullfilename,[rootPath '/scan_data/data_02']);
    end
    value_size=value_info.Dataspace.Size;
    data.x=h5read(handles.fullfilename,[rootPath '/scan_data/trajectory_2_1']);
    data.y=h5read(handles.fullfilename,[rootPath '/scan_data/trajectory_1_1']);
    
    try
        data.k= h5read(handles.fullfilename,[rootPath,...
            '/ANTARES/ScientaAtt1/sliceScale/data']);
    catch
        warning([handles.fullfilename,...
            ' data.k',...
            ' is missing.',...
            ' Index are adopted.']);
        data.k=1:value_size(2);
    end
    try
        data.z= h5read(handles.fullfilename,[rootPath,...
            '/ANTARES/ScientaAtt1/channelScale/data']);
    catch
        warning([handles.fullfilename,...
            ' data.z',...
            ' is missing.',...
            ' Index are adopted.']);
        data.z=1:value_size(1);
    end
    
    if value_size(2)~=length(data.k)
        data.k=1:value_size(2);
    end
    if value_size(1)~=length(data.z)
        data.z=1:value_size(1);
    end
    
    %reset data type
    handles.datatype='Real Space Scan Data';
    set(handles.edit_Data_Type,'String','Real Space Scan Data');
    
    r_min=[min(data.x);min(data.y);min(data.z);min(data.k)];
    r_max=[max(data.x);max(data.y);max(data.z);max(data.k)];
    r_length=[length(data.x);length(data.y);length(data.z);length(data.k)];
    r_dept=(r_max-r_min)./(r_length-1);
    data_range=[r_min,r_max,r_length,r_dept];
    
    handles.rawdata{4}=data.k;
end

%% Store and Write Raw Data Range
set(handles.table_Raw_Data,'Data',data_range);
set(handles.table_Sampled_Data,'Data',data_range);
handles.rawdata{1}=data.x;
handles.rawdata{2}=data.y;
handles.rawdata{3}=data.z;

guidata(hObject,handles);

function table_Sampled_Data_CellEditCallback(hObject, eventdata, ~)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
handles=guidata(hObject);

r=eventdata.Indices(1); %row
c=eventdata.Indices(2); %column
sampled=get(handles.table_Sampled_Data,'Data'); 
raw=get(handles.table_Raw_Data,'Data');
r_d=handles.rawdata;
newdata=eventdata.NewData;

%% Change Whole Table Accordingly
if c==1 %change min
        if newdata<raw(r,1)||newdata>sampled(r,2)
            sampled(r,c)=eventdata.PreviousData;
            set(handles.table_Sampled_Data,'Data',sampled);
            return;
        end
        indice_min=1;
        while r_d{r}(indice_min)<newdata
            indice_min=indice_min+1;
        end
        indice_max=raw(r,3);
        while r_d{r}(indice_max)>sampled(r,2)
            indice_max=indice_max-1;
        end
        sampled(r,3)=floor((r_d{r}(indice_max)-r_d{r}(indice_min))/sampled(r,4))+1;
elseif c==2 %change max
        if newdata>raw(r,2)||newdata<sampled(r,1)
            sampled(r,c)=eventdata.PreviousData;
            set(handles.table_Sampled_Data,'Data',sampled);
            return;
        end
        indice_min=1;
        while r_d{r}(indice_min)<sampled(r,1)
            indice_min=indice_min+1;
        end
        indice_max=raw(r,3);
        while r_d{r}(indice_max)>newdata
            indice_max=indice_max-1;
        end
        sampled(r,3)=floor((r_d{r}(indice_max)-r_d{r}(indice_min))/sampled(r,4))+1;
elseif c==3 %change point number
        indice_min=1;
        while r_d{r}(indice_min)<sampled(r,1)
            indice_min=indice_min+1;
        end
        indice_max=raw(r,3);
        while r_d{r}(indice_max)>sampled(r,2)
            indice_max=indice_max-1;
        end
        width=r_d{r}(indice_max)-r_d{r}(indice_min);
        if newdata>(width/raw(r,4)+1)
            sampled(r,c)=eventdata.PreviousData;
            set(handles.table_Sampled_Data,'Data',sampled);
            return;
        end
        n=1;
        while width/(newdata-1)>=n*raw(r,4)
            n=n+1;
        end
        sampled(r,4)=(n-1)*raw(r,4);
        sampled(r,3)=floor(width/sampled(r,4))+1;
elseif c==4      %change dept
        indice_min=1;
        while r_d{r}(indice_min)<sampled(r,1)
            indice_min=indice_min+1;
        end
        indice_max=raw(r,3);
        while r_d{r}(indice_max)>sampled(r,2)
            indice_max=indice_max-1;
        end
        width=r_d{r}(indice_max)-r_d{r}(indice_min);
        if newdata<raw(r,4)||newdata>width
            sampled(r,c)=eventdata.PreviousData;
            set(handles.table_Sampled_Data,'Data',sampled);
            return;
        end
        n=1;
        while newdata>=n*raw(r,4)
            n=n+1;
        end
        sampled(r,4)=(n-1)*raw(r,4);
        sampled(r,3)=floor(width/sampled(r,4))+1;
end
set(handles.table_Sampled_Data,'Data',sampled);

%% Calculate Expected Sampled Data Bytes
bytes=NaN;
if strcmp(handles.datatype,'Real Space Scan Data') %RScan Data
    bytes=floor(sampled(1,3)*sampled(2,3)*sampled(3,3)*sampled(4,3)*...
        handles.rawdata_size/(raw(1,3)*raw(2,3)*raw(3,3)*raw(4,3)));
elseif strcmp(handles.datatype,'Map Data')  %Map Data
    bytes=floor(sampled(1,3)*sampled(2,3)*sampled(3,3)*handles.rawdata_size/...
        (raw(1,3)*raw(2,3)*raw(3,3)));
end
set(handles.edit_Expected_Bytes,'String',num2str(bytes));

guidata(hObject,handles);

function pb_Load_Sampled_Data_Callback(hObject, ~, ~)
handles=guidata(hObject);

sampled=get(handles.table_Sampled_Data,'Data'); 
raw=get(handles.table_Raw_Data,'Data');
r_d=handles.rawdata;

%% Create Grid to Select data.value from Raw Data
start=ones(1,4);
count=ones(1,4);
stride=ones(1,4);
fullfilename=handles.fullfilename;
%'start,count,stride' specify sampled 'data.value' to be read, see function'h5read'
%note:for real space scan data, value in '.nxs' file ,z*k*y*x,

if strcmp(handles.datatype,'Real Space Scan Data') %RScan Data
    for r=1:4
        indice_min=1;
        while r_d{r}(indice_min)<sampled(r,1)
            indice_min=indice_min+1;
        end
        start(1,5-r)=indice_min;
        count(1,5-r)=sampled(r,3);
        stride(1,5-r)=round(sampled(r,4)/raw(r,4));
    end
elseif strcmp(handles.datatype,'Map Data')   %Map Data
    for r=1:3
        indice_min=1;
        while r_d{r}(indice_min)<sampled(r,1)
            indice_min=indice_min+1;
        end
        start(1,5-r)=indice_min;
        count(1,5-r)=sampled(r,3);
        stride(1,5-r)=round(sampled(r,4)/raw(r,4));
    end
end
handles.start=start;
handles.count=count;
handles.stride=stride;
handles.ending=start+stride.*(count-1);
%handles. 'start,count,stride' 1,2,3,4 indicate k*z*y*x,
%for map data, 'start,count,stride'(k)=1, data.k=NaN

start=[start(2),start(1),start(3),start(4)];
count=[count(2),count(1),count(3),count(4)];
stride=[stride(2),stride(1),stride(3),stride(4)];
%now 1,2,3,4 indicate z,k,y,x

load_sampled_soleil_nxs(fullfilename,start,count,stride);

%% Initialize Map Setting
map_type=get(handles.popup_Map_Type,'Value');
if map_type==1  %y-x
    set(handles.text_1,'String','z');
    set(handles.text_2,'String','k');
    handles.r_d_1=r_d{3}(handles.start(2):handles.stride(2):handles.ending(2));
    handles.r_d_2=r_d{4}(handles.start(1):handles.stride(1):handles.ending(1));
    handles.count_12=[handles.count(2),handles.count(1)];
elseif map_type==2  %z-y
    set(handles.text_1,'String','x');
    set(handles.text_2,'String','k');
    handles.r_d_1=r_d{1}(handles.start(4):handles.stride(4):handles.ending(4));
    handles.r_d_2=r_d{4}(handles.start(1):handles.stride(1):handles.ending(1));
    handles.count_12=[handles.count(4),handles.count(1)];
elseif map_type==3  %z-x
    set(handles.text_1,'String','y');
    set(handles.text_2,'String','k');
    handles.r_d_1=r_d{2}(handles.start(3):handles.stride(3):handles.ending(3));
    handles.r_d_2=r_d{4}(handles.start(1):handles.stride(1):handles.ending(1));
    handles.count_12=[handles.count(3),handles.count(1)];
elseif map_type==4&&strcmp(handles.datatype,'Real Space Scan Data')  %z-k
    set(handles.text_1,'String','x');
    set(handles.text_2,'String','y');
    handles.r_d_1=r_d{1}(handles.start(4):handles.stride(4):handles.ending(4));
    handles.r_d_2=r_d{2}(handles.start(3):handles.stride(3):handles.ending(3));
    handles.count_12=[handles.count(4),handles.count(3)];
elseif map_type==4&&strcmp(handles.datatype,'Map Data') %invalid map type
    return;
end
set(handles.slider_1,'Min',1,'Max',handles.count_12(1));
set(handles.slider_2,'Min',1,'Max',handles.count_12(2));
if handles.count_12(1)-1>10
    set(handles.slider_1,'SliderStep',[1/(handles.count_12(1)-1),10/(handles.count_12(1)-1)]);
else
    set(handles.slider_1,'SliderStep',[1/(handles.count_12(1)-1),1/(handles.count_12(1)-1)]);
end
if strcmp(handles.datatype,'Real Space Scan Data')
    if handles.count_12(2)-1>10
        set(handles.slider_2,'SliderStep',[1/(handles.count_12(2)-1),10/(handles.count_12(2)-1)]);
    else
        set(handles.slider_2,'SliderStep',[1/(handles.count_12(2)-1),1/(handles.count_12(2)-1)]);
    end
elseif strcmp(handles.datatype,'Map Data')
    set(handles.slider_2,'SliderStep',[1,1]);
end


value1=str2double(get(handles.edit_1,'String'));
value2=str2double(get(handles.edit_2,'String'));
if isnan(value1)||value1<handles.r_d_1(1)||value1>handles.r_d_1(handles.count_12(1)) 
    %no initialized value or out of data_range
    set(handles.edit_1,'String',num2str(handles.r_d_1(1)));
    set(handles.slider_1,'Value',1);
else 
    indice=1;
    while handles.r_d_1(indice)<value1
        indice=indice+1;
    end
    set(handles.edit_1,'String',num2str(handles.r_d_1(indice)));
    set(handles.slider_1,'Value',indice);
end

if strcmp(handles.datatype,'Real Space Scan Data')
    if isnan(value2)||value2<handles.r_d_2(1)||value2>handles.r_d_2(handles.count_12(2)) 
        %no initialized value or out of data_range
        set(handles.edit_2,'String',num2str(handles.r_d_2(1)));
        set(handles.slider_2,'Value',1);
    else 
        indice=1;
        while handles.r_d_2(indice)<value2
            indice=indice+1;
        end
        set(handles.edit_2,'String',num2str(handles.r_d_2(indice)));
        set(handles.slider_2,'Value',indice);
    end
elseif strcmp(handles.datatype,'Map Data')
    set(handles.edit_2,'String','NaN');
end

guidata(hObject,handles);

function pb_Map_Callback(hObject, ~, ~)
handles=guidata(hObject);

handles = map_sampled_soleil_nxs(handles);

guidata(hObject,handles);

function popup_Map_Type_Callback(hObject, ~, ~)
handles=guidata(hObject);
r_d=handles.rawdata;

%% Initialize Map Setting
map_type=get(handles.popup_Map_Type,'Value');
if map_type==1  %y-x
    set(handles.text_1,'String','z');
    set(handles.text_2,'String','k');
    handles.r_d_1=r_d{3}(handles.start(2):handles.stride(2):handles.ending(2));
    handles.r_d_2=r_d{4}(handles.start(1):handles.stride(1):handles.ending(1));
    handles.count_12=[handles.count(2),handles.count(1)];
elseif map_type==2  %z-y
    set(handles.text_1,'String','x');
    set(handles.text_2,'String','k');
    handles.r_d_1=r_d{1}(handles.start(4):handles.stride(4):handles.ending(4));
    handles.r_d_2=r_d{4}(handles.start(1):handles.stride(1):handles.ending(1));
    handles.count_12=[handles.count(4),handles.count(1)];
elseif map_type==3  %z-x
    set(handles.text_1,'String','y');
    set(handles.text_2,'String','k');
    handles.r_d_1=r_d{2}(handles.start(3):handles.stride(3):handles.ending(3));
    handles.r_d_2=r_d{4}(handles.start(1):handles.stride(1):handles.ending(1));
    handles.count_12=[handles.count(3),handles.count(1)];
elseif map_type==4&&strcmp(handles.datatype,'Real Space Scan Data')  %z-k
    set(handles.text_1,'String','x');
    set(handles.text_2,'String','y');
    handles.r_d_1=r_d{1}(handles.start(4):handles.stride(4):handles.ending(4));
    handles.r_d_2=r_d{2}(handles.start(3):handles.stride(3):handles.ending(3));
    handles.count_12=[handles.count(4),handles.count(3)];
elseif map_type==4&&strcmp(handles.datatype,'Map Data') %invalid map type
    return;
end
set(handles.slider_1,'Min',1,'Max',handles.count_12(1));
set(handles.slider_2,'Min',1,'Max',handles.count_12(2));
if handles.count_12(1)-1>10
    set(handles.slider_1,'SliderStep',[1/(handles.count_12(1)-1),10/(handles.count_12(1)-1)]);
else
    set(handles.slider_1,'SliderStep',[1/(handles.count_12(1)-1),1/(handles.count_12(1)-1)]);
end
if strcmp(handles.datatype,'Real Space Scan Data')
    if handles.count_12(2)-1>10
        set(handles.slider_2,'SliderStep',[1/(handles.count_12(2)-1),10/(handles.count_12(2)-1)]);
    else
        set(handles.slider_2,'SliderStep',[1/(handles.count_12(2)-1),1/(handles.count_12(2)-1)]);
    end
elseif strcmp(handles.datatype,'Map Data')
    set(handles.slider_2,'SliderStep',[1,1]);
end


value1=str2double(get(handles.edit_1,'String'));
value2=str2double(get(handles.edit_2,'String'));
if isnan(value1)||value1<handles.r_d_1(1)||value1>handles.r_d_1(handles.count_12(1)) 
    %no initialized value or out of data_range
    set(handles.edit_1,'String',num2str(handles.r_d_1(1)));
    set(handles.slider_1,'Value',1);
else 
    indice=1;
    while handles.r_d_1(indice)<value1
        indice=indice+1;
    end
    set(handles.edit_1,'String',num2str(handles.r_d_1(indice)));
    set(handles.slider_1,'Value',indice);
end

if strcmp(handles.datatype,'Real Space Scan Data')
    if isnan(value2)||value2<handles.r_d_2(1)||value2>handles.r_d_2(handles.count_12(2)) 
        %no initialized value or out of data_range
        set(handles.edit_2,'String',num2str(handles.r_d_2(1)));
        set(handles.slider_2,'Value',1);
    else 
        indice=1;
        while handles.r_d_2(indice)<value2
            indice=indice+1;
        end
        set(handles.edit_2,'String',num2str(handles.r_d_2(indice)));
        set(handles.slider_2,'Value',indice);
    end
elseif strcmp(handles.datatype,'Map Data')
    set(handles.edit_2,'String','NaN');
end

guidata(hObject,handles);

%% Control Slider and Edit under Map    
function slider_1_Callback(hObject, ~, ~)
handles=guidata(hObject);

value1=get(handles.slider_1,'Value');
indice=1;
while indice<value1
    indice=indice+1;
end
set(handles.edit_1,'String',num2str(handles.r_d_1(indice)));
set(handles.slider_1,'Value',indice);

handles = map_sampled_soleil_nxs(handles);

guidata(hObject,handles);
function slider_2_Callback(hObject, ~, ~)
handles=guidata(hObject);
if strcmp(handles.datatype,'Real Space Scan Data')
    value2=get(handles.slider_2,'Value');
    indice=1;
    while indice<value2
        indice=indice+1;
    end
    set(handles.edit_2,'String',num2str(handles.r_d_2(indice)));
    set(handles.slider_2,'Value',indice);

    handles = map_sampled_soleil_nxs(handles);
end
guidata(hObject,handles);
function edit_1_Callback(hObject, ~, ~)
handles=guidata(hObject);

value1=str2double(get(handles.edit_1,'String'));
min1=handles.r_d_1(1);
max1=handles.r_d_1(handles.count_12(1));
if isnan(value1)||value1<min1||value1>max1 %no initialized value or out of data_range
    set(handles.edit_1,'String',num2str(min1));
    set(handles.slider_1,'Value',1);
else 
    indice=1;
    while handles.r_d_1(indice)<value1
        indice=indice+1;
    end
    set(handles.edit_1,'String',num2str(handles.r_d_1(indice)));
    set(handles.slider_1,'Value',indice);
end

handles = map_sampled_soleil_nxs(handles);

guidata(hObject,handles);
function edit_2_Callback(hObject, ~, ~)
handles=guidata(hObject);

if strcmp(handles.datatype,'Real Space Scan Data')
    value2=str2double(get(handles.edit_2,'String'));
    min2=handles.r_d_2(1);
    max2=handles.r_d_2(handles.count_12(2));
    if isnan(value2)||value2<min2||value2>max2 %no initialized value or out of data_range
        set(handles.edit_2,'String',num2str(min2));
        set(handles.slider_2,'Value',1);
    else 
        indice=1;
        while handles.r_d_2(indice)<value2
            indice=indice+1;
        end
        set(handles.edit_2,'String',num2str(handles.r_d_2(indice)));
        set(handles.slider_2,'Value',indice);
    end

    handles = map_sampled_soleil_nxs(handles);
elseif strcmp(handles.datatype,'Map Data')
    set(handles.edit_2,'String','NaN');
end

guidata(hObject,handles);
