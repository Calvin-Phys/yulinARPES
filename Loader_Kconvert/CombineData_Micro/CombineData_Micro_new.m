function varargout = CombineData_Micro_new(varargin)
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

% Last Modified by GUIDE v2.5 11-Jun-2023 14:41:22

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


%  =================== COMBINE BUTTON =====================================

function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% get input variables
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_num = size(index_selected,2);

var_name = list_entries{index_selected(1)}; %first cut
datav = evalin('base',var_name);              %first cut
if (~isfield(datav,'x') || ~isfield(datav,'y') || ~isfield(datav,'value')) && ...
        (~isprop(datav,'x') || ~isprop(datav,'y') || ~isprop(datav,'value'))
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
%----------whether Normal yz before combine?-------------
flag_yz=get(handles.radiobutton5,'value');
%----------whether Normal xz-------------
flag_xz=get(handles.radiobutton3,'value');
%----------whether Normal analyser-------------
flag_analyser=get(handles.Analyser,'value');
if flag_analyser==1
    gold_name=get(handles.Gold,'String');
    try
        ref=evalin('base',gold_name);
    catch
        load("MCP_calibration.mat");
        ref.value = MCP_calibration;
    end
end
%----------end whether Normal-------------

%-------Combine Data 2D to 3D----------
for i= 1: map_num % for each tilt
   h=(i-1)*cut_num+1; % variable index
   var_name = list_entries{index_selected(h)};
   datav = evalin('base',var_name);
   % construct new map data
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

for i=1:map_num % for each tilt
    left(i)=round((new_data(i).y(1)-new_data(1).y(1))/step)+1;
    [useless,sizeY]=size(new_data(i).y);
    right(i)=left(i)+sizeY-1;
end

data.y=linspace(new_data(1).y(1),new_data(map_num).y(sizeY),right(map_num));
[useless,sizeY]=size(data.y);
[useless,sizeX]=size(data.x);
[useless,sizeZ]=size(data.z);
data.value=zeros(sizeX,sizeY,sizeZ);

% merge the data
for i = 1:map_num-1
    overlapping = right(i) - left(i+1) + 1;
    for j = 1:overlapping
        new_data(i).value(:,end-overlapping+j,:) = new_data(i).value(:,end-overlapping+j,:) * (1 - j/overlapping);
        new_data(i+1).value(:,j,:) = new_data(i+1).value(:,j,:) * j/overlapping;
    end

end

for i=1:map_num
    new_data(i).value=cat(2,zeros(sizeX,left(i)-1,sizeZ),new_data(i).value,zeros(sizeX,sizeY-right(i),sizeZ));

    data.value=data.value+new_data(i).value;
end

% for y=1:sizeY
%    for i=1:(map_num-1)
%       if (y>=left(i+1))&&(y<=right(i)) 
%          data.value(:,y,:)=data.value(:,y,:)/2;
%       end
%    end  
% end

name_output=[MapName,'_combine'];

cut1 = evalin('base',list_entries{index_selected(1)});
if isa(cut1,'OxA_CUT')
    data = OxA_MAP(data);
    data.info = cut1.info;
end

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

vars = evalin('base','who');
set(hObject,'String',vars)


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


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes during object creation, after setting all properties.
function checkbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'value',1)

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
% --- Executes during object creation, after setting all properties.
function checkbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'value',0)


% --- Executes during object creation, after setting all properties.
function radiobutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(hObject,'value',1)

%%
% ---- PREVIEW BUTTON
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %----------get the info for map-------------
    P_initial=str2num(get(handles.edit1,'String'));
    P_final=str2num(get(handles.edit2,'String'));
    P_step=str2num(get(handles.edit3,'String'));
    
    num_polar = round((P_final-P_initial)/P_step)+1;% maybe bug here
    
    T_initial=str2num(get(handles.edit4,'String'));
    T_final=str2num(get(handles.edit6,'String'));
    T_step=str2num(get(handles.edit7,'String'));
    
    num_tilt = round((T_final-T_initial)/T_step)+1;% maybe bug here


    % get selected variable list
    list_entries = get(handles.listbox1,'String');
    index_selected = get(handles.listbox1,'Value');
    var_num = size(index_selected,2);

    CUT = evalin('base',list_entries{index_selected(1)});

    % truncate cuts or not
    flag_trun = get(handles.radiobutton1,'value');
    truncate = str2num(get(handles.edit8,'String'));

    % polar, tilt & azimuth for gamma
    P0 = str2num(get(handles.edit12,'String'));
    T0 = str2num(get(handles.edit13,'String'));

    % get data points
    kk1 = [];
    kk2 = [];
    
    Eki = max(CUT.y);
    Ekj = min(CUT.y);
    CONST = 0.512316722;
    
    tic
    for y_offset = T_initial:T_step:T_final
        [ThetaX, ThetaY] = meshgrid(P_initial:P_step:P_final,CUT.x);
        kx = ( cosd(ThetaY).*sind(ThetaX-90) );
        ky = ( cosd(y_offset).*sind(ThetaY) +sind(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );
        kz = ( -sind(y_offset).*sind(ThetaY) +cosd(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );
        kk1 = vertcat(kk1,CONST* sqrt(Eki)* [kx(:), ky(:), kz(:)]);
        kk2 = vertcat(kk2,CONST* sqrt(Ekj)* [kx(:), ky(:), kz(:)]);
    
    end
    toc
    
    % plot data points
    figure
    hold on
    scatter3(kk1(:,1),kk1(:,2),kk1(:,3),'r.');
    scatter3(kk2(:,1),kk2(:,2),kk2(:,3),'b.');
%     mm1 = sum(CUT_combined,2);
%     scatter3(kk1(:,1),kk1(:,2),mm1(:),'.');
    
    % plot KX/KY max/min
    Kx_min = min([kk1(:,1);kk2(:,1)]);
    Kx_max = max([kk1(:,1);kk2(:,1)]);
    Ky_min = min([kk1(:,2);kk2(:,2)]);
    Ky_max = max([kk1(:,2);kk2(:,2)]);
    

    kx = linspace(Kx_min,Kx_max, round(1.5*var_num/num_tilt));
    ky = linspace(Ky_min,Ky_max, round(1.2*num_tilt*length(CUT.x)));
    [KY,KX] = meshgrid(ky,kx);
    scatter(KX(:),KY(:),'.');

    legend('Data points (lowest E)','Data points (highest E)','Interpolation points');


% function [kx,ky,kz] = rotate2K(Eki,y_offset,thetax,thetay)
%     % electron mass = 9.1093837 × 10-31 kilograms
%     % hbar = 6.582119569...×10−16 eV⋅s
%     % k (A-1) = CONST [sqrt(2m)/hbar] * sqrt(Ek (eV)) * sin(theta)
%     CONST = 0.512316722;
%     z_i = [0 0 1]';
%     z_f = RM(RM([0 cosd(y_offset) -sind(y_offset)]',thetax)*[1 0 0]',-thetay)*RM([0 cosd(y_offset) -sind(y_offset)]',thetax)*RM([1 0 0]',-y_offset)*z_i;
%     kx = CONST* sqrt(Eki)* z_f(1);
%     ky = CONST* sqrt(Eki)* z_f(2);
%     kz = CONST* sqrt(Eki)* z_f(3);
% 
% function M = RM(U,deg)
% %ROTATION_MATRIX Summary of this function goes here
% %   Detailed explanation goes here
%     ux = U(1);
%     uy = U(2);
%     uz = U(3);
%     M =[cosd(deg)+ux^2*(1-cosd(deg)), ux*uy*(1-cosd(deg))-uz*sind(deg), ux*uz*(1-cosd(deg))+uy*sind(deg);
%         uy*ux*(1-cosd(deg))+uz*sind(deg), cosd(deg)+uy^2*(1-cosd(deg)), uy*uz*(1-cosd(deg))-ux*sind(deg);
%         uz*ux*(1-cosd(deg))-uy*sind(deg), uz*uy*(1-cosd(deg))+ux*sind(deg), cosd(deg)+uz^2*(1-cosd(deg))];

function CUT_out = GaussianSmoothen(CUT_in,sig_x,sig_y)
% sigma - standard deviation
    rad_x = ceil(3.5*sig_x);
    rad_y = ceil(3.5*sig_y);
    x = -rad_x : rad_x;
    y = -rad_y : rad_y;
    [Y,X] = meshgrid(y,x);
    R = (X/sig_x).^2 + (Y/sig_y).^2;
    
    G = exp(-R/2);
    % normalize gaussian filter
    S = sum(G,'all');
    G = G./S;
    
    ma = CUT_in;
    w1 = rad_x;
    w2 = rad_y;
    L = size(ma,1); % x
    J = size(ma,2); % z
    
    map = zeros(L+2*w1, J+2*w2);
    map(1+w1:L+w1, 1+w2:J+w2) = ma;
    map(1:w1,:) = flip(map(1+w1:2*w1,:),1);
    map(w1+L+1:L+2*w1,:) = flip(map(L+1:L+w1,:),1);
    map(:,1:w2) = flip(map(:,1+w2:2*w2),2);
    map(:,w2+J+1:J+2*w2) = flip(map(:,J+1:J+w2),2);
    map = conv2(map,G,'same');

    CUT_out = map(1+w1:L+w1,1+w2:J+w2);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % disable the button
    handles.pushbutton4.Enable = "off";
    pause(0.1);

    load("MCP_calibration.mat");

    % get selected variable list
    list_entries = get(handles.listbox1,'String');
    index_selected = get(handles.listbox1,'Value');
    var_num = size(index_selected,2);

    % truncate cuts or not
    flag_trun = get(handles.radiobutton1,'value');
    truncate = str2num(get(handles.edit8,'String'));

    % polar and tilt for gamma
    P0 = str2num(get(handles.edit12,'String'));
    T0 = str2num(get(handles.edit13,'String'));

    %----------whether Normal yz/xz before combine?-------------
    flag_yz=get(handles.radiobutton5,'value');
    flag_xz=get(handles.radiobutton3,'value');

    %----------whether Normal analyser-------------
    flag_analyser=get(handles.Analyser,'value');
    if flag_analyser==1
        gold_name=get(handles.Gold,'String');
        try
            ref=evalin('base',gold_name);
        catch
            ref.value = MCP_calibration;
        end
    end

    %----------get the info for map-------------
    P_initial=str2num(get(handles.edit1,'String'));
    P_final=str2num(get(handles.edit2,'String'));
    P_step=str2num(get(handles.edit3,'String'));
    
    num_polar = round((P_final-P_initial)/P_step)+1;% maybe bug here
    
    T_initial=str2num(get(handles.edit4,'String'));
    T_final=str2num(get(handles.edit6,'String'));
    T_step=str2num(get(handles.edit7,'String'));
    
    num_tilt = round((T_final-T_initial)/T_step)+1;% maybe bug here

    % get data points
    CUT_combined = [];
    coord = [];
    kk1 = [];
    kk2 = [];
    
    for i = 1:var_num % for each cut

        % get the cut from the workspace
        CUT = evalin('base',list_entries{index_selected(i)});

        % calibrate
        if flag_analyser==1
            CUT.value = CUT.value./ref.value;
        end

        % smoothen the cuts to avoid moire pattern after interpolation
        try
            CUT = CUT.Gaussian_smoothen(0.5,0.5);
        catch
            CUT.value = GaussianSmoothen(CUT.value,0.5,0.5);
        end

        CUT_combined(:,:,i) = CUT.value;
        coord(i,:) = [CUT.info.theta - P0, CUT.info.phi - T0];

        % record K
        for j = 1:length(CUT.x)
            [kx,ky,kz] = rotate2K(min(CUT.y),CUT.info.phi-T0,CUT.info.theta-P0,CUT.x(j));
            kk1(end+1,:) = [kx, ky, kz];
            [kx,ky,kz] = rotate2K(max(CUT.y),CUT.info.phi-T0,CUT.info.theta-P0,CUT.x(j));
            kk2(end+1,:) = [kx, ky, kz];
        end
    end

    % normalize yz/xz
    if flag_yz == 1
        N_curve = sum(CUT_combined,[2 3]);
        N_curve = N_curve/mean(N_curve);
        for j = 1:length(N_curve)
            CUT_combined(j,:,:) = CUT_combined(j,:,:)/N_curve(j);
        end
    end
    if flag_xz == 1
        N_curve = sum(CUT_combined,[1 3]);
        N_curve = N_curve/mean(N_curve);
        for j = 1:length(N_curve)
            CUT_combined(:,j,:) = CUT_combined(:,j,:)/N_curve(j);
        end
    end

    % get Kx/Ky range
    Kx_min = min([kk1(:,1);kk2(:,1)]);
    Kx_max = max([kk1(:,1);kk2(:,1)]);
    Ky_min = min([kk1(:,2);kk2(:,2)]);
    Ky_max = max([kk1(:,2);kk2(:,2)]);

    kx = linspace(Kx_min,Kx_max, round(2*num_polar));
    ky = linspace(Ky_min,Ky_max, round(1.6*num_tilt*length(CUT.x)));
    [KY,KX] = meshgrid(ky,kx);

    % truncate
%     if get(handles.checkbox3,'value') % use parallel computation
    % split the data
    for i=1:num_tilt
        MAP_separated{i} = CUT_combined(:,:,(i-1)*num_polar+1:i*num_polar);
        coord_separated{i} = coord((i-1)*num_polar+1:i*num_polar,:);

        % interpolate
        data_new{i} = zeros(length(kx),length(ky),length(CUT.y));

        % for each energy
        for s=1:length(CUT.y)

            % data to be interpolated
            value3 = MAP_separated{i}(:,s,:);

            % Kx/Ky of the data points
            Kx3 = zeros(1,num_polar*length(CUT.x));
            Ky3 = zeros(1,num_polar*length(CUT.x));
            t = 1;
            for p=1:num_polar
                for j=1:length(CUT.x)
                    [Kx3(t),Ky3(t),~] = rotate2K(CUT.y(s),coord_separated{i}(p,2),coord_separated{i}(p,1),CUT.x(j));
                    t=t+1;
                end
            end


            % two method: no obvious differences
            data_new{i}(:,:,s) = griddata(Kx3(:),Ky3(:),value3(:),KX,KY,'natural');
    %         data_new(:,:,s) = griddata(Kx3(:),Ky3(:),value3(:),KX,KY,'v4');
    %         F = scatteredInterpolant(Kx3(:),Ky3(:),value3(:),'natural','none');
    %         data_new(:,:,s) = F(KX,KY);
%             fprintf('%3.0f/%3.0f \n', s, length(CUT.y));
        end

        data_new{i}(data_new{i}<0) = 0;
        data_new{i}(isnan(data_new{i})) = 0;

    end

    % merge
    for i = 1:num_tilt-1

        % Kx/Ky of the data points
        Ky3 = zeros(1,num_polar*length(CUT.y));
        t = 1;
        for p=1:num_polar
            for j=1:length(CUT.y)
                [~,Ky3(t),~] = rotate2K(CUT.y(j),coord_separated{i}(p,2),coord_separated{i}(p,1),CUT.x(end));
                t=t+1;
            end
        end
        [~,right(i)] = min(abs(ky-min(Ky3)));

        Ky3 = zeros(1,num_polar*length(CUT.y));
        t = 1;
        for p=1:num_polar
            for j=1:length(CUT.y)
                [~,Ky3(t),~] = rotate2K(CUT.y(j),coord_separated{i+1}(p,2),coord_separated{i+1}(p,1),CUT.x(1));
                t=t+1;
            end
        end
        [~,left(i)] = min(abs(ky-max(Ky3)));
        
        mask = -1/abs(right(i) - left(i))*([1:length(ky)]-right(i));
        mask(mask>1) = 1;
        mask(mask<0) = 0;

        for m = 1:length(ky)
            data_new{i}(:,m,:) = data_new{i}(:,m,:)*mask(m);
            data_new{i+1}(:,m,:) = data_new{i+1}(:,m,:)*(1-mask(m));
        end

    end

    % merge
    data_output = zeros(length(kx),length(ky),length(CUT.y));
    for i = 1:num_tilt
        data_output = data_output + data_new{i};
    end


    KMAP.x = kx;
    KMAP.y = ky;
    KMAP.z = CUT.y;
    KMAP.value = data_output;
    
    % for object
    if isa(CUT,'OxA_CUT')
        KMAP = OxA_MAP(KMAP);
        KMAP.x_name = 'K_x';
        KMAP.x_unit = 'Å^{-1}';
        KMAP.y_name = 'K_y';
        KMAP.y_unit = 'Å^{-1}';
        KMAP.z_name = '{\it E}-{\it E}_F';
        KMAP.z_unit = 'eV';
        KMAP.name = [KMAP.name '_ksp'];
        KMAP.info = CUT.info;
        KMAP.info = rmfield(KMAP.info,'phi');
        KMAP.info = rmfield(KMAP.info,'theta');
        KMAP.z = KMAP.z - KMAP.info.photon_energy + KMAP.info.workfunction;
    end

    MapName = get(handles.edit9,'String');
    assignin('base',[MapName,'_combine_k_sp'],KMAP);

    handles.pushbutton4.Enable = "on";


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% detect coordinates

% get selected variable list
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var_num = size(index_selected,2);

% get data points
coord = [];
break_point = [];
num_tilt = 1;

for i = 1:var_num
    CUT = evalin('base',list_entries{index_selected(i)});
%     fprintf('%5.2f %5.2f \n', CUT.info.phi, CUT.info.theta);
    % theta-P, phi-T
    coord(i,:) = [CUT.info.theta, CUT.info.phi];
    if i~=1 && coord(i,2) - coord(i-1,2) > 3
        num_tilt = num_tilt + 1;
        break_point(end+1) = i;
    end
end

% polar
PP = reshape(coord(:,1),[],num_tilt);
PP = mean(PP,2);

x = 1:length(PP);
P = polyfit(x,PP,1);

handles.edit1.String = num2str(round( P(1)+P(2) ,1));
handles.edit2.String = num2str(round( P(1)*length(PP)+P(2) ,1));
handles.edit3.String = num2str(round( P(1) ,2));

% tilt
TT = reshape(coord(:,2),[],num_tilt);
TT = mean(TT,1);

x = 1:length(TT);
P = polyfit(x,TT,1);

handles.edit4.String = num2str(round( P(1)+P(2) ,1));
handles.edit6.String = num2str(round( P(1)*length(TT)+P(2) ,1));
handles.edit7.String = num2str(round( P(1) ,2));

disp("finished");



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disable the button

    handles.pushbutton4.Enable = "off";
    pause(0.1);

    % get selected variable list
    list_entries = get(handles.listbox1,'String');
    index_selected = get(handles.listbox1,'Value');
    var_num = size(index_selected,2);

    % truncate cuts or not
    flag_trun = get(handles.radiobutton1,'value');
    truncate = str2num(get(handles.edit8,'String'));

    % polar and tilt for gamma
    P0 = str2num(get(handles.edit12,'String'));
    T0 = str2num(get(handles.edit13,'String'));

    %----------whether Normal yz/xz before combine?-------------
    flag_yz=get(handles.radiobutton5,'value');
    flag_xz=get(handles.radiobutton3,'value');

    %----------whether Normal analyser-------------
    flag_analyser=get(handles.Analyser,'value');
    if flag_analyser==1
        gold_name=get(handles.Gold,'String');
        try
            ref=evalin('base',gold_name);
        catch
            load("MCP_calibration.mat");
            ref.value = MCP_calibration;
        end
    end

    %----------get the info for map-------------
    P_initial=str2num(get(handles.edit1,'String'));
    P_final=str2num(get(handles.edit2,'String'));
    P_step=str2num(get(handles.edit3,'String'));
    
    num_polar = round((P_final-P_initial)/P_step)+1;% maybe bug here
    
    T_initial=str2num(get(handles.edit4,'String'));
    T_final=str2num(get(handles.edit6,'String'));
    T_step=str2num(get(handles.edit7,'String'));
    
    num_tilt = round((T_final-T_initial)/T_step)+1;% maybe bug here

    % get data points
    CUT_combined = [];
    coord = [];
    kk1 = [];
    kk2 = [];
    
    for i = 1:var_num % for each cut

        % get the cut from the workspace
        CUT = evalin('base',list_entries{index_selected(i)});

        % calibrate
        if flag_analyser==1
            CUT.value = CUT.value./ref.value;
        end

        % smoothen the cuts to avoid moire pattern after interpolation
        try
            CUT = CUT.Gaussian_smoothen(0.5,1);
        catch
            CUT.value = GaussianSmoothen(CUT.value,0.5,1);
        end

        CUT_combined(:,:,i) = CUT.value;
        coord(i,:) = [CUT.info.theta - P0, CUT.info.phi - T0];

        % record K
        for j = 1:length(CUT.x)
            [kx,ky,kz] = rotate2K(min(CUT.y),CUT.info.phi-T0,CUT.info.theta-P0,CUT.x(j));
            kk1(end+1,:) = [kx, ky, kz];
            [kx,ky,kz] = rotate2K(max(CUT.y),CUT.info.phi-T0,CUT.info.theta-P0,CUT.x(j));
            kk2(end+1,:) = [kx, ky, kz];
        end
    end

    % normalize yz/xz
    if flag_yz == 1
        N_curve = sum(CUT_combined,[2 3]);
        N_curve = N_curve/mean(N_curve);
        for j = 1:length(N_curve)
            CUT_combined(j,:,:) = CUT_combined(j,:,:)/N_curve(j);
        end
    end
    if flag_xz == 1
        N_curve = sum(CUT_combined,[1 3]);
        N_curve = N_curve/mean(N_curve);
        for j = 1:length(N_curve)
            CUT_combined(:,j,:) = CUT_combined(:,j,:)/N_curve(j);
        end
    end

    % get Kx/Ky range
    Kx_min = min([kk1(:,1);kk2(:,1)]);
    Kx_max = max([kk1(:,1);kk2(:,1)]);
    Ky_min = min([kk1(:,2);kk2(:,2)]);
    Ky_max = max([kk1(:,2);kk2(:,2)]);

    kx = linspace(Kx_min,Kx_max, round(2*num_polar));
    ky = linspace(Ky_min,Ky_max, round(1.6*num_tilt*length(CUT.x)));
    [KY,KX] = meshgrid(ky,kx);

    % truncate
%     if get(handles.checkbox3,'value') % use parallel computation
    % split the data
    for i=1:num_tilt
        MAP_separated{i} = CUT_combined(:,:,(i-1)*num_polar+1:i*num_polar);
        coord_separated{i} = coord((i-1)*num_polar+1:i*num_polar,:);

        % interpolate
        data_new{i} = zeros(length(kx),length(ky),length(CUT.y));

        % for each energy
        for s=1:length(CUT.y)

            % data to be interpolated
            value3 = MAP_separated{i}(:,s,:);

            % Kx/Ky of the data points
            Kx3 = zeros(1,num_polar*length(CUT.x));
            Ky3 = zeros(1,num_polar*length(CUT.x));
            t = 1;
            for p=1:num_polar
                for j=1:length(CUT.x)
                    [Kx3(t),Ky3(t),~] = rotate2K(CUT.y(s),coord_separated{i}(p,2),coord_separated{i}(p,1),CUT.x(j));
                    t=t+1;
                end
            end


            % two method: no obvious differences
            data_new{i}(:,:,s) = griddata(Kx3(:),Ky3(:),value3(:),KX,KY,'natural');
    %         data_new(:,:,s) = griddata(Kx3(:),Ky3(:),value3(:),KX,KY,'v4');
    %         F = scatteredInterpolant(Kx3(:),Ky3(:),value3(:),'natural','none');
    %         data_new(:,:,s) = F(KX,KY);
%             fprintf('%3.0f/%3.0f \n', s, length(CUT.y));
        end

        data_new{i}(data_new{i}<0) = 0;
        data_new{i}(isnan(data_new{i})) = 0;

    end

    % merge
    for i = 1:num_tilt-1

        % Kx/Ky of the data points
        Ky3 = zeros(1,num_polar*length(CUT.y));
        t = 1;
        for p=1:num_polar
            for j=1:length(CUT.y)
                [~,Ky3(t),~] = rotate2K(CUT.y(j),coord_separated{i}(p,2),coord_separated{i}(p,1),CUT.x(end));
                t=t+1;
            end
        end
        [~,right(i)] = min(abs(ky-min(Ky3)));

        Ky3 = zeros(1,num_polar*length(CUT.y));
        t = 1;
        for p=1:num_polar
            for j=1:length(CUT.y)
                [~,Ky3(t),~] = rotate2K(CUT.y(j),coord_separated{i+1}(p,2),coord_separated{i+1}(p,1),CUT.x(1));
                t=t+1;
            end
        end
        [~,left(i)] = min(abs(ky-max(Ky3)));
        
        mask = -1/abs(right(i) - left(i))*([1:length(ky)]-right(i));
        mask(mask>1) = 1;
        mask(mask<0) = 0;

        for m = 1:length(ky)
            data_new{i}(:,m,:) = data_new{i}(:,m,:)*mask(m);
            data_new{i+1}(:,m,:) = data_new{i+1}(:,m,:)*(1-mask(m));
        end

    end

    % merge
    data_output = zeros(length(kx),length(ky),length(CUT.y));
    for i = 1:num_tilt
        data_output = data_output + data_new{i};
    end


    KMAP.x = kx;
    KMAP.y = ky;
    KMAP.z = CUT.y;
    KMAP.value = data_output;
    
    % for object
    if isa(CUT,'OxA_CUT')
        KMAP = OxA_MAP(KMAP);
        KMAP.x_name = 'K_x';
        KMAP.x_unit = 'Å^{-1}';
        KMAP.y_name = 'K_y';
        KMAP.y_unit = 'Å^{-1}';
        KMAP.z_name = '{\it E}-{\it E}_F';
        KMAP.z_unit = 'eV';
        KMAP.name = [KMAP.name '_ksp'];
        KMAP.info = CUT.info;
        KMAP.info = rmfield(KMAP.info,'phi');
        KMAP.info = rmfield(KMAP.info,'theta');
        KMAP.z = KMAP.z - KMAP.info.photon_energy + KMAP.info.workfunction;
    end

    MapName = get(handles.edit9,'String');
    assignin('base',[MapName,'_combine_k_sp'],KMAP);

    handles.pushbutton4.Enable = "on";



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
