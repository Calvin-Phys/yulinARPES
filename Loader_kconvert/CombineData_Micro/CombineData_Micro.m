function varargout = CombineData_Micro(varargin)
% COMBINEDATA_MICRO MATLAB code for CombineData_Micro.fig
%      COMBINEDATA_MICRO, by itself, creates a new COMBINEDATA_MICRO or raises the existing
%      singleton*.
%
%      H = COMBINEDATA_MICRO returns the handle to a new COMBINEDATA_MICRO or the handle to
%      the existing singleton*.
%
%      COMBINEDATA_MICRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMBINEDATA_MICRO.M with the given input arguments.
%
%      COMBINEDATA_MICRO('Property','Value',...) creates a new COMBINEDATA_MICRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CombineData_Micro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CombineData_Micro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CombineData_Micro

% Last Modified by GUIDE v2.5 17-Oct-2020 20:55:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CombineData_Micro_OpeningFcn, ...
                   'gui_OutputFcn',  @CombineData_Micro_OutputFcn, ...
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


% --- Executes just before CombineData_Micro is made visible.
function CombineData_Micro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CombineData_Micro (see VARARGIN)

% Choose default command line output for CombineData_Micro
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CombineData_Micro wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CombineData_Micro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_num=size(index_selected,2);
var_name = list_entries{index_selected(1)}; %first cut
datav=evalin('base',var_name);              %first cut
if ~isfield(datav,'x') || ~isfield(datav,'y') || ~isfield(datav,'value')
    errordlg('Selected data must contain data.x, data.y and data.value.',...
        'Incorrect input');
    return;
end
%----------get the info for map-------------
P_initial=str2num(get(handles.edit1,'String'));
P_final=str2num(get(handles.edit2,'String'));
P_step=str2num(get(handles.edit3,'String'));
cut_num=round((P_final-P_initial)/P_step)+1;% maybe bug here
T_initial=str2num(get(handles.edit4,'String'));
T_final=str2num(get(handles.edit6,'String'));
T_step=str2num(get(handles.edit7,'String'));
MapName=get(handles.edit9,'String');
map_num=var_num/cut_num;
%----------end get the info for map-------------
%----------whether truncate?-------------
truncate=str2num(get(handles.edit8,'String'));
flag_trun=get(handles.radiobutton1,'value');
%----------end whether truncate?-------------

%----------whether Normal yz before combine?-------------
flag_yz=get(handles.radiobutton5,'value');
%----------end whether Normal yz before combine?-------------

%----------whether Normal xz-------------
flag_xz=get(handles.radiobutton3,'value');
%----------end whether Normal-------------
%----------whether Normal analyser-------------
flag_analyser=get(handles.Analyser,'value');
if flag_analyser==1
    gold_name=get(handles.Gold,'String');
    ref=evalin('base',gold_name);
end
%----------end whether Normal-------------

%-------Combine Data 2D to 3D----------
for i= 1: map_num
    h=(i-1)*cut_num+1;
   var_name = list_entries{index_selected(h)};
   datav=evalin('base',var_name);
   new_data(i).x=P_initial:P_step:P_final;
   new_data(i).y=datav.x+T_initial+T_step*(i-1);
   new_data(i).z=datav.y;
   for h=1:cut_num
       var_name = list_entries{index_selected((i-1)*cut_num+h)};
       datav=evalin('base',var_name);
       if flag_analyser==1 
           datav.value=datav.value./ref.value;
       end
       new_data(i).value(h,:,:)=datav.value;
   end
   name_output=[MapName,'_Part',num2str(i)];
   assignin('base',name_output,new_data(i));
end
clear datav;clear j; clear h;
%-------end Combine Data 2D to 3D---------
%--------Normal yz before combine-------
if (flag_yz==1)
    for i=1:map_num
            data=new_data(i);
            [sizeX,sizeY,sizeZ]=size(data.value);
    for j=1:sizeX
        dataCutYZ=data.value(j,:,:);
        sumCutYZ=sum(sum(dataCutYZ));
        data_nor.value(j,:,:)=dataCutYZ/sumCutYZ;
        
    end
    new_data(i).value=data_nor.value;
    %name_output=[MapName,'_Part',num2str(i),'_nor'];
    %assignin('base',name_output,new_data(i));
    end
end
%--------End Normal yz before combine----
%--------Truncate before combine-------
if (flag_trun==1)&&(map_num>1)
    for i=1:map_num
        data=new_data(i);
        [sizeX,sizeY,sizeZ]=size(data.value);
        left=truncate; right=truncate;
        if (i==1) left=0; end
        if (i==map_num) right=0;end
        y_min_index=round(left/(data.y(2)-data.y(1)))+1;
        y_max_index=sizeY-round(right/(data.y(2)-data.y(1)));
        data_tk.x=data.x;
        data_tk.y=data.y(y_min_index:y_max_index);
        data_tk.z=data.z;
        data_tk.value=data.value(:,y_min_index:y_max_index,:);
        new_data(i)=data_tk;
        %name_output=[MapName,'_Part',num2str(i),'_tk'];
       %assignin('base',name_output,new_data(i));
       clear data;
    end
end    
clear left; clear right;
%--------End Truncate------------------
%-------Combine Data 3D to Final----------
data.x=new_data(1).x;
data.z=new_data(1).z;
step=new_data(1).y(2)-new_data(1).y(1);


for i=1:map_num
    left(i)=round((new_data(i).y(1)-new_data(1).y(1))/step)+1;
    [useless,sizeY]=size(new_data(i).y);
    right(i)=left(i)+sizeY-1;
end
data.y=linspace(new_data(1).y(1),new_data(map_num).y(sizeY),right(map_num));
[useless,sizeY]=size(data.y);
[useless,sizeX]=size(data.x);
[useless,sizeZ]=size(data.z);
data.value=zeros(sizeX,sizeY,sizeZ);
for i=1:map_num
    new_data(i).value=cat(2,zeros(sizeX,left(i)-1,sizeZ),new_data(i).value,zeros(sizeX,sizeY-right(i),sizeZ));
    data.value=data.value+new_data(i).value;
end
for y=1:sizeY
   for i=1:(map_num-1)
      if (y>=left(i+1))&&(y<=right(i)) 
         data.value(:,y,:)=data.value(:,y,:)/2;
      end
   end  
end
name_output=[MapName,'_combine'];
assignin('base',name_output,data);


%-------end Combine Data 3D to Final--------

%----------Normal xz---------------
if (flag_xz==1)
    
    [sizeX,sizeY,sizeZ]=size(data.value);
    for j=1:sizeY
        dataCutXZ=data.value(:,j,:);
        sumCutXZ=sum(sum(dataCutXZ));
        data_nor.value(:,j,:)=dataCutXZ/sumCutXZ;
        
    end
   data.value=data_nor.value;
    name_output=[MapName,'_combine_nor'];
    assignin('base',name_output,data);
    
end
%----------End Normal xz-----------


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars = evalin('base','who');
set(handles.listbox1,'String',vars)



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Analyser.
function Analyser_Callback(hObject, eventdata, handles)
% hObject    handle to Analyser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Analyser



function Gold_Callback(hObject, eventdata, handles)
% hObject    handle to Gold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gold as text
%        str2double(get(hObject,'String')) returns contents of Gold as a double


% --- Executes during object creation, after setting all properties.
function Gold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
