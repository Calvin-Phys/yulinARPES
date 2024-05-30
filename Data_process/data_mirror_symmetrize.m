function varargout = data_mirror_symmetrize(varargin)
% DATA_MIRROR_SYMMETRIZE M-file for data_mirror_symmetrize.fig
%      DATA_MIRROR_SYMMETRIZE, by itself, creates a new DATA_MIRROR_SYMMETRIZE or raises the existing
%      singleton*.
%
%      H = DATA_MIRROR_SYMMETRIZE returns the handle to a new DATA_MIRROR_SYMMETRIZE or the handle to
%      the existing singleton*.
%
%      DATA_MIRROR_SYMMETRIZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_MIRROR_SYMMETRIZE.M with the given input arguments.
%
%      DATA_MIRROR_SYMMETRIZE('Property','Value',...) creates a new DATA_MIRROR_SYMMETRIZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data_mirror_symmetrize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data_mirror_symmetrize_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data_mirror_symmetrize

% Last Modified by GUIDE v2.5 31-Jul-2013 21:39:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data_mirror_symmetrize_OpeningFcn, ...
                   'gui_OutputFcn',  @data_mirror_symmetrize_OutputFcn, ...
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


% --- Executes just before data_mirror_symmetrize is made visible.
function data_mirror_symmetrize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_mirror_symmetrize (see VARARGIN)

% Choose default command line output for data_mirror_symmetrize
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data_mirror_symmetrize wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = data_mirror_symmetrize_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in variables.
function variables_Callback(hObject, eventdata, handles)
% hObject    handle to variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables


% --- Executes during object creation, after setting all properties.
function variables_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refresh_variables.
function refresh_variables_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars=evalin('base','who');
set(handles.variables,'String',vars);


function mx_Callback(hObject, eventdata, handles)
% hObject    handle to mx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mx as text
%        str2double(get(hObject,'String')) returns contents of mx as a double


% --- Executes during object creation, after setting all properties.
function mx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function my_Callback(hObject, eventdata, handles)
% hObject    handle to my (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of my as text
%        str2double(get(hObject,'String')) returns contents of my as a double


% --- Executes during object creation, after setting all properties.
function my_CreateFcn(hObject, eventdata, handles)
% hObject    handle to my (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function truncate_Callback(hObject, eventdata, handles)
% hObject    handle to truncate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of truncate as text
%        str2double(get(hObject,'String')) returns contents of truncate as a double


% --- Executes during object creation, after setting all properties.
function truncate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to truncate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flag_smooth.
function flag_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to flag_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flag_smooth




function mz_Callback(hObject, eventdata, handles)
% hObject    handle to mz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mz as text
%        str2double(get(hObject,'String')) returns contents of mz as a double


% --- Executes during object creation, after setting all properties.
function mz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mirror_symmetrize.
function mirror_symmetrize_Callback(hObject, eventdata, handles)
% hObject    handle to mirror_symmetrize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%===================== Get information ==========================
set(handles.light,'BackgroundColor',[0.925,0.839,0.839]);
set(handles.light,'String','Busy');
set(handles.version,'String','version 2013.08.01.16:33.phan');


list_entries = get(handles.variables,'String');
index_selected = get(handles.variables,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
datav=evalin('base',var_name);

flag_1d=get(handles.data_1d,'Value');
flag_2d=get(handles.data_2d,'Value');
flag_3d=get(handles.data_3d,'Value');

flag_x=get(handles.m_x,'Value');
flag_y=get(handles.m_y,'Value');
flag_z=get(handles.m_z,'Value');

flag_index=get(handles.index_scale,'Value');
flag_scale=get(handles.real_scale,'Value');
flag_tk=get(handles.tk_flag,'Value');
flag_smooth=get(handles.flag_smooth,'Value');
flag_method=str2num(get(handles.flag_method,'String'));


m_x=str2num(get(handles.mx,'String'));
m_y=str2num(get(handles.my,'String'));
m_z=str2num(get(handles.mz,'String'));

%====================== check data format =====================
if ~isfield(datav,'value') || ~isfield(datav,'x')
    errordlg('Data must contains "data.value" and at least "data.x" (for 1d)','error input');
    return;
end
%%   ====================== 1d case ================================
if flag_1d==1
    
    if flag_index == 1
        datav_new=mirror_1d(datav,m_x);
    else
        sepa=abs(datav.x(2)- datav.x(1));
        bound_lo=ceil((min(min(datav.x))-m_x)/sepa);
        bound_up=floor((max(max(datav.x))-m_x)/sepa);
        datav_tmp.x=[m_x+bound_lo*sepa:sepa:m_x+bound_up*sepa];
        datav_tmp.value=interp1(datav.x,datav.value,datav_tmp.x,'spline','extrap');
        
        datav_new=mirror_1d(datav_tmp,abs(bound_lo)+1);
    end
    assignin('base',cat(2,var_name,'_symm_m'),datav_new);
end
%%   ====================== 2d case ================================
if flag_2d==1
    datav.value=inpaint_nans(datav.value);
    datav.value(datav.value<0)=0;
    if flag_index==1   %----------if use index------------------
        if flag_x==1   %--if mirror along x-axis----------------
            datav_new=mirror_2d_x(datav,m_x,get(handles.flag_smooth,'Value'),flag_method);
        else           %--if mirror along y-axis----------------
            datav_new=mirror_2d_y(datav,m_y);
        end
    else               %----------if use real scale-------------
        if flag_x==1   %--if mirror along x-axis----------------
            
            if strcmp(get(handles.truncate,'String'),'Auto')
               xk=m_x;
            else xk=str2num(get(handles.truncate,'String'));
            end         
            
            if flag_tk==1  %-------------truncate data----------------
                [~,dim]=max(size(datav.x));
                [~,index]=min(abs(datav.x-xk),[],dim);
                if index<max(size(datav.x))/2
                    if index==1
                        index=2;
                    end
                    vx(1:max(size(datav.x))-index+2)=datav.x(index-1:max(size(datav.x)));
                    datav.x=vx;
                    value(1:size((datav.value),1)-index+2,:)=datav.value(index-1:size(datav.value,1),:);
                    datav.value=value;
                else
                    if index==max(size(datav.x))
                        index=max(size(datav.x))-1;
                    end
                    vx(1:index+1)=datav.x(1:index+1);
                    datav.x=vx;
                    value(1:index+1,:)=datav.value(1:index+1,:);
                    datav.value=value;
                end
            end
            
            
            sepa=abs(datav.x(2)- datav.x(1));      
            bound_lo=ceil((min(min(datav.x))-m_x)/sepa);
            bound_up=floor((max(max(datav.x))-m_x)/sepa);
            datav_tmp.x=[m_x+bound_lo*sepa:sepa:m_x+bound_up*sepa];
            datav_tmp.y=datav.y;
            
            [x0,y0]=meshgrid(datav.y,datav.x);
            [xi,yi]=meshgrid(datav_tmp.y,datav_tmp.x);
            datav_tmp.value=griddata(x0,y0,datav.value,xi,yi,'cubic');
        
            datav_new=mirror_2d_x(datav_tmp,abs(bound_lo)+1,get(handles.flag_smooth,'Value'),flag_method);
      else           %--if mirror along y-axis----------------

          
            if strcmp(get(handles.truncate,'String'),'Auto')
               xk=m_y;
            else xk=str2num(get(handles.truncate,'String'));
            end 
          
            if flag_tk==1  %-------------truncate data----------------
                [~,dim]=max(size(datav.y));
                [~,index]=min(abs(datav.y-xk),[],dim);
                if index<max(size(datav.y))/2
                    if index==1
                        index=2;
                    end
                    vy(1:max(size(datav.y))-index+2)=datav.y(index-1:max(size(datav.y)));
                    datav.y=vy;
                    value(:,1:size((datav.value),2)-index+2)=datav.value(:,index-1:size(datav.value,2));
                    datav.value=value;
                else
                    if index==max(size(datav.y))
                        index=max(size(datav.y))-1;
                    end
                    vy(1:index+1)=datav.y(1:index+1);
                    datav.y=vy;
                    value(:,1:index+1)=datav.value(:,1:index+1);
                    datav.value=value;
                end
            end
                      
          
          
          
            sepa=abs(datav.y(2)- datav.y(1));
            bound_lo=ceil((min(min(datav.y))-m_y)/sepa);
            bound_up=floor((max(max(datav.y))-m_y)/sepa);
            datav_tmp.x=datav.x;
            datav_tmp.y=[m_y+bound_lo*sepa:sepa:m_y+bound_up*sepa];
            
            [x0,y0]=meshgrid(datav.y,datav.x);
            [xi,yi]=meshgrid(datav_tmp.y,datav_tmp.x);
            datav_tmp.value=griddata(x0,y0,datav.value,xi,yi,'cubic');
            
            inter=datav_tmp.x;
            datav_tmp.x=datav_tmp.y;
            datav_tmp.y=inter;
            datav_tmp.value=datav_tmp.value';
        
            datav_new=mirror_2d_x(datav_tmp,abs(bound_lo)+1,get(handles.flag_smooth,'Value'),flag_method);
            inter=datav_new.x;
            datav_new.x=datav_new.y;
            datav_new.y=inter;
            datav_new.value=datav_new.value';
        end
    end
    assignin('base',cat(2,var_name,'_symm_m'),datav_new);
end
%%     ====================== 3d case ================================
if flag_3d==1
    if flag_index==1   %----------if use index------------------
        if flag_x==1              %--if mirror along x-axis----------------
            datav_new=mirror_3d_x(datav,m_x);
        elseif flag_y==1          %--if mirror along y-axis----------------
            datav_new=mirror_3d_y(datav,m_y);
        else
            datav_new=mirror_3d_z(datav,m_z);
        end
    else               %----------if use real scale-------------
        
        %------------Step 1 Pretreatment-----------
        
        if flag_y==1    %--if mirror along y-axis----------------
            datav.value=permute(datav.value,[2,1,3]);
            inter=datav.x;
            datav.x=datav.y;
            datav.y=inter;
            m_x=m_y;
        elseif flag_z==1    %-- if mirror along z-axis----------------
            datav.value=permute(datav.value,[3,2,1]);
            inter=datav.x;
            datav.x=datav.z;
            datav.z=inter;
            m_x=m_z;
        end
        
        %-------------Step 2 Mirror symmetrization---------------

        
        if strcmp(get(handles.truncate,'String'),'Auto')
           xk=m_x;
        else xk=str2num(get(handles.truncate,'String'));
        end
           
        if flag_tk==1  %-------------truncate data----------------
            [~,dim]=max(size(datav.x));
            [~,index]=min(abs(datav.x-xk),[],dim);  % where to begin truncation
            if index<max(size(datav.x))/2
                if index==1
                    index=2;
                end
                vx(1:max(size(datav.x))-index+2)=datav.x(index-1:max(size(datav.x)));
                datav.x=vx;
                value(1:size((datav.value),1)-index+2,:,:)=datav.value(index-1:size(datav.value,1),:,:);
                datav.value=value;
            else
                if index==max(size(datav.x))
                    index=max(size(datav.x))-1;
                end
                vx(1:index+1)=datav.x(1:index+1);
                datav.x=vx;
                value(1:index+1,:,:)=datav.value(1:index+1,:,:);
                datav.value=value;
            end
        end
        
        %--------------deal with nans----------------------------
        for i=1:size(datav.value,3)
            datav.value(:,:,i)=inpaint_nans(datav.value(:,:,i));
            
        end
        datav.value(datav.value<0)=0;           
        sepa=abs(datav.x(2)- datav.x(1));
        bound_lo=ceil((min(min(datav.x))-m_x)/sepa);
        bound_up=floor((max(max(datav.x))-m_x)/sepa);
        datav_tmp.x=[m_x+bound_lo*sepa:sepa:m_x+bound_up*sepa];
        datav_tmp.y=datav.y;
        datav_tmp.z=datav.z;
            
        [x0,y0,z0]=meshgrid(datav.y,datav.x,datav.z);
        [xi,yi,zi]=meshgrid(datav_tmp.y,datav_tmp.x,datav_tmp.z);
        datav_tmp.value=interp3(x0,y0,z0,datav.value,xi,yi,zi);
        
        datav_new=mirror_3d_x(datav_tmp,abs(bound_lo)+1,get(handles.flag_smooth,'Value'),flag_method);
        

        %-------------Step 3 Transpose again-------------------------

        if flag_y==1    %--if mirror along y-axis----------------
            datav_new.value=permute(datav_new.value,[2,1,3]);
            inter=datav_new.x;
            datav_new.x=datav_new.y;
            datav_new.y=inter;
        elseif flag_z==1    %-- if mirror along z-axis----------------
            datav_new.value=permute(datav_new.value,[3,2,1]);
            inter=datav_new.x;
            datav_new.x=datav_new.z;
            datav_new.z=inter;
        end   
    end
    assignin('base',cat(2,var_name,'_symm_m'),datav_new);
end

set(handles.light,'BackgroundColor',[0.757,0.867,0.776]);
set(handles.light,'String','Ready');


%====================== sub functions===========================
%-----------1d-----------------------
function [data_new]= mirror_1d(data,index)
    m=length(data.x);    %m is the array length;
    n=index;                %n is the mirror index number;
    if n<1 || n>m
        errordlg('Index exceed data boundary','error input');
    return
    end
    
    data_tmp.value=flipdim(data.value,2);      % get flipped array;
    data_tmp.x=data.x(n)-flipdim(data.x-data.x(n),2);              % get new axis info
    
    if index<=round(m/2)
        %---new conbined data---------
        data_new.value(1:m+1-2*n)=data_tmp.value(1:m+1-2*n);
        data_new.value(m+2-2*n:m)=( data_tmp.value(m+2-2*n:m)+data.value(1:2*n-1))/2;
        data_new.value(m+1:2*m+1-2*n)=data.value(2*n:m);
        %---new axis------------------
        data_new.x(1:m+1-2*n)=data_tmp.x(1:m+1-2*n);
        data_new.x(m+2-2*n:2*m+1-2*n)=data.x;
    else
        %---new conbined data---------
        data_new.value(1:2*n-m-1)=data.value(1:2*n-m-1);
        data_new.value(2*n-m:m)=( data.value(2*n-m:m)+data_tmp.value(1:2*m-2*n+1))/2;
        data_new.value(m+1:2*n-1)=data_tmp.value(2*m-2*n+2:m);
        %---new axis------------------
        data_new.x(1:m)=data.x;
        data_new.x(m+1:2*n-1)=data_tmp.x(2*m-2*n+2:m);
    end
    
    
%%         -----------2d-----------------------

function [data_new]= mirror_2d_x(data,index,flag_smooth,flag_method)
    m=length(data.x);    %m is the x axis length;
    n=index;             %n is the mirror index number;
    if n<1 || n>m
        errordlg('Index exceed data boundary','error input');
    return
    end
    
    data_tmp.value=flipdim(data.value,1);      % get flipped array;
    data_tmp.x=2*data.x(n)-flipdim(data.x,2);              % get new axis info
    data_tmp.y=data.y;
     
    if index<=round(m/2)
        %---new combined data---------
        mask1=zeros(2*m-2*n+1,length(data.y));
        mask2=mask1;
        tmp1=zeros(2*m-2*n+1,length(data.y));
        tmp2=tmp1;
        
        tmp1(1:m,:)=data_tmp.value(:,:);
        tmp2(m-2*n+2:2*m-2*n+1,:)=data.value(:,:);
        
        mask1(1:m,:)=ones(size(data_tmp.value));
        mask2(m-2*n+2:2*m-2*n+1,:)=ones(size(data.value));      
        
        if flag_smooth
            smoother1=linspace(1,0,n);
            smoother2=linspace(0,1,n);
            if flag_method
                    c=flag_method;
                    smoother1=exp(-(smoother1-1).^2/c)-exp(-1/c);
                    smoother2=exp(-(smoother2-1).^2/c)-exp(-1/c);
            end
            mask1(m-n+1:m,:)=repmat(smoother1',1,length(data.y));
            mask2(m-2*n+2:m-n+1,:)=repmat(smoother2',1,length(data.y));
        end
        mask3=mask1+mask2;
        
        data_new.value=(tmp1.*mask1+tmp2.*mask2)./mask3;
        
        %---new axis------------------
        data_new.x(1:m+1-2*n)=data_tmp.x(1:m+1-2*n);
        data_new.x(m+2-2*n:2*m+1-2*n)=data.x;
        data_new.y=data.y;
    else
        %---new conbined data---------
        mask1=zeros(2*n-1,length(data.y));
        mask2=mask1;
        tmp1=zeros(2*n-1,length(data.y));
        tmp2=tmp1;
        
        tmp1(1:m,:)=data.value(:,:);
        tmp2(2*n-m:2*n-1,:)=data_tmp.value(:,:);
        
        mask1(1:m,:)=ones(size(data_tmp.value));
        mask2(2*n-m:2*n-1,:)=ones(size(data.value));
                
        if flag_smooth
            smoother1=linspace(1,0,m-n+1);
            smoother2=linspace(0,1,m-n+1);
            if flag_method
                    c=flag_method;
                    smoother1=exp(-(smoother1-1).^2/c)-exp(-1/c);
                    smoother2=exp(-(smoother2-1).^2/c)-exp(-1/c);
            end
            mask1(n:m,:)=repmat(smoother1',1,length(data.y));
            mask2(2*n-m:n,:)=repmat(smoother2',1,length(data.y));
        end
        mask3=mask1+mask2;
        
        data_new.value=(tmp1.*mask1+tmp2.*mask2)./mask3;
        %---new axis------------------
        data_new.x(1:m)=data.x;
        data_new.x(m+1:2*n-1)=data_tmp.x(2*m-2*n+2:m);
        data_new.y=data.y;
    end

    function [data_new]= mirror_2d_y(data,index)  % now it may not be used.
    m=length(data.y);    %m is the x axis length;
    n=index;             %n is the mirror index number;
    if n<1 || n>m
        errordlg('Index exceed data boundary','error input');
    return
    end
    
    data_tmp.value=flipdim(data.value,2);      % get flipped array;
    data_tmp.y=data.y(n)-flipdim(data.y-data.y(n),2);              % get new axis info
    data_tmp.x=data.x;
    
    if index<=round(m/2)
        %---new conbined data---------
        data_new.value(:,1:m+1-2*n)=data_tmp.value(:,1:m+1-2*n);
        data_new.value(:,m+2-2*n:m)=( data_tmp.value(:,m+2-2*n:m)+data.value(:,1:2*n-1))/2;
        data_new.value(:,m+1:2*m+1-2*n)=data.value(:,2*n:m);
        %---new axis------------------
        data_new.y(1:m+1-2*n)=data_tmp.y(1:m+1-2*n);
        data_new.y(m+2-2*n:2*m+1-2*n)=data.y;
        data_new.x=data.x;
    else
        %---new conbined data---------
        data_new.value(:,1:2*n-m-1)=data.value(:,1:2*n-m-1);
        data_new.value(:,2*n-m:m)=( data.value(:,2*n-m:m)+data_tmp.value(:,1:2*m-2*n+1))/2;
        data_new.value(:,m+1:2*n-1)=data_tmp.value(:,2*m-2*n+2:m);
        %---new axis------------------
        data_new.y(1:m)=data.y;
        data_new.y(m+1:2*n-1)=data_tmp.y(2*m-2*n+2:m);
        data_new.x=data.x;
    end
    
%%  -----------3d-----------------------

function [data_new]= mirror_3d_x(data,index,flag_smooth,flag_method)
    m=length(data.x);    %m is the x axis length;
    n=index;             %n is the mirror index number;
    if n<1 || n>m
        errordlg('Index exceed data boundary','error input');
    return
    end
    
    data_tmp.value=flipdim(data.value,1);      % get flipped array;
    data_tmp.x=data.x(n)-flipdim(data.x-data.x(n),2);              % get new axis info
    data_tmp.y=data.y;
    data_tmp.z=data.z;
    
    if index<=round(m/2)
        %---new conbined data---------

        mask1=zeros(2*m-2*n+1,length(data.y),length(data.z));
        mask2=mask1;
        tmp1=zeros(2*m-2*n+1,length(data.y),length(data.z));
        tmp2=tmp1;
        
        tmp1(1:m,:,:)=data_tmp.value(:,:,:);
        tmp2(m-2*n+2:2*m-2*n+1,:,:)=data.value(:,:,:);
        
        mask1(1:m,:,:)=ones(size(data_tmp.value));
        mask2(m-2*n+2:2*m-2*n+1,:,:)=ones(size(data.value));      
        
        if flag_smooth
            smoother1=linspace(1,0,n);
            smoother2=linspace(0,1,n);
            if flag_method
                    c=flag_method;
                    smoother1=exp(-(smoother1-1).^2/c)-exp(-1/c);
                    smoother2=exp(-(smoother2-1).^2/c)-exp(-1/c);
            end
            for i=1:length(data.z)
                mask1(m-n+1:m,:,i)=repmat(smoother1',1,length(data.y));
                mask2(m-2*n+2:m-n+1,:,i)=repmat(smoother2',1,length(data.y));
            end
        end
        mask3=mask1+mask2;        
        
        data_new.value=(tmp1.*mask1+tmp2.*mask2)./mask3;
        %---new axis------------------
        data_new.x(1:m+1-2*n)=data_tmp.x(1:m+1-2*n);
        data_new.x(m+2-2*n:2*m+1-2*n)=data.x;
        data_new.y=data.y;
        data_new.z=data.z;
    else
        %---new conbined data---------
        mask1=zeros(2*n-1,length(data.y),length(data.z));
        mask2=mask1;
        tmp1=zeros(2*n-1,length(data.y),length(data.z));
        tmp2=tmp1;
        
        tmp1(1:m,:,:)=data.value(:,:,:);
        tmp2(2*n-m:2*n-1,:,:)=data_tmp.value(:,:,:);
        
        mask1(1:m,:,:)=ones(size(data_tmp.value));
        mask2(2*n-m:2*n-1,:,:)=ones(size(data.value));
                
        if flag_smooth
            smoother1=linspace(1,0,m-n+1);
            smoother2=linspace(0,1,m-n+1);
            if flag_method
                    c=flag_method;
                    smoother1=exp(-(smoother1-1).^2/c)-exp(-1/c);
                    smoother2=exp(-(smoother2-1).^2/c)-exp(-1/c);
            end
            for i=1:length(data.z)
                mask1(n:m,:,i)=repmat(smoother1',1,length(data.y));
                mask2(2*n-m:n,:,i)=repmat(smoother2',1,length(data.y));
            end
        end
        mask3=mask1+mask2;
        
        data_new.value=(tmp1.*mask1+tmp2.*mask2)./mask3;
        %---new axis------------------
        data_new.x(1:m)=data.x;
        data_new.x(m+1:2*n-1)=data_tmp.x(2*m-2*n+2:m);
        data_new.y=data.y;
        data_new.z=data.z;
    end

function [data_new]= mirror_3d_y(data,index)
    m=length(data.y);    %m is the x axis length;
    n=index;             %n is the mirror index number;
    if n<1 || n>m
        errordlg('Index exceed data boundary','error input');
    return
    end
    
    data_tmp.value=flipdim(data.value,2);      % get flipped array;
    data_tmp.y=data.y(n)-flipdim(data.y-data.y(n),2);              % get new axis info
    data_tmp.x=data.x;
    data_tmp.z=data.z;
    
    if index<=round(m/2)
        %---new conbined data---------
        data_new.value(:,1:m+1-2*n,:)=data_tmp.value(:,1:m+1-2*n,:);
        data_new.value(:,m+2-2*n:m,:)=( data_tmp.value(:,m+2-2*n:m,:)+data.value(:,1:2*n-1,:))/2;
        data_new.value(:,m+1:2*m+1-2*n,:)=data.value(:,2*n:m,:);
        %---new axis------------------
        data_new.y(1:m+1-2*n)=data_tmp.y(1:m+1-2*n);
        data_new.y(m+2-2*n:2*m+1-2*n)=data.y;
        data_new.x=data.x;
        data_new.z=data.z;
    else
        %---new conbined data---------
        data_new.value(:,1:2*n-m-1,:)=data.value(:,1:2*n-m-1,:);
        data_new.value(:,2*n-m:m,:)=( data.value(:,2*n-m:m,:)+data_tmp.value(:,1:2*m-2*n+1,:))/2;
        data_new.value(:,m+1:2*n-1,:)=data_tmp.value(:,2*m-2*n+2:m,:);
        %---new axis------------------
        data_new.y(1:m)=data.y;
        data_new.y(m+1:2*n-1)=data_tmp.y(2*m-2*n+2:m);
        data_new.x=data.x;
        data_new.z=data.z;
    end
    
function [data_new]= mirror_3d_z(data,index)
    m=length(data.z);    %m is the x axis length;
    n=index;             %n is the mirror index number;
    if n<1 || n>m
        errordlg('Index exceed data boundary','error input');
    return
    end
    
    data_tmp.value=flipdim(data.value,3);      % get flipped array;
    data_tmp.z=data.z(n)-flipdim(data.z-data.z(n),2);              % get new axis info
    data_tmp.x=data.x;
    data_tmp.y=data.y;
    
    if index<=round(m/2)
        %---new conbined data---------
        data_new.value(:,:,1:m+1-2*n)=data_tmp.value(:,:,1:m+1-2*n);
        data_new.value(:,:,m+2-2*n:m)=( data_tmp.value(:,:,m+2-2*n:m)+data.value(:,:,1:2*n-1))/2;
        data_new.value(:,:,m+1:2*m+1-2*n)=data.value(:,:,2*n:m);
        %---new axis------------------
        data_new.z(1:m+1-2*n)=data_tmp.z(1:m+1-2*n);
        data_new.z(m+2-2*n:2*m+1-2*n)=data.z;
        data_new.x=data.x;
        data_new.y=data.y;
    else
        %---new conbined data---------
        data_new.value(:,:,1:2*n-m-1)=data.value(:,:,1:2*n-m-1);
        data_new.value(:,:,2*n-m:m)=( data.value(:,:,2*n-m:m)+data_tmp.value(:,:,1:2*m-2*n+1))/2;
        data_new.value(:,:,m+1:2*n-1)=data_tmp.value(:,:,2*m-2*n+2:m);
        %---new axis------------------
        data_new.z(1:m)=data.z;
        data_new.z(m+1:2*n-1)=data_tmp.z(2*m-2*n+2:m);
        data_new.x=data.x;
        data_new.y=data.y;
    end


% --- Executes on button press in tk_flag.
function tk_flag_Callback(hObject, eventdata, handles)
% hObject    handle to tk_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tk_flag


% --- Executes on selection change in wc_axis.
function wc_axis_Callback(hObject, eventdata, handles)
% hObject    handle to wc_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wc_axis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wc_axis


% --- Executes during object creation, after setting all properties.
function wc_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wc_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function position_Callback(hObject, eventdata, handles)
% hObject    handle to position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of position as text
%        str2double(get(hObject,'String')) returns contents of position as a double


% --- Executes during object creation, after setting all properties.
function position_CreateFcn(hObject, eventdata, handles)
% hObject    handle to position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function range_Callback(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range as text
%        str2double(get(hObject,'String')) returns contents of range as a double


% --- Executes during object creation, after setting all properties.
function range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in wrinkle.
function wrinkle_Callback(hObject, eventdata, handles)
% hObject    handle to wrinkle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.light,'BackgroundColor',[0.925,0.839,0.839]);
set(handles.light,'String','Busy');




list_entries = get(handles.variables,'String');
index_selected = get(handles.variables,'Value');
var_name = list_entries{index_selected(1)};  %determine the var in base
data_wc=evalin('base',var_name);
xk=str2num(get(handles.position,'String'));
n_pixel=str2num(get(handles.range,'String'));
axis=get(handles.wc_axis,'String');
axis_num=get(handles.wc_axis,'Value');

% ----------------------2D-------------------
if length(size(data_wc.value))==2

    if strcmp(axis{axis_num},'x')
       [~,dim]=max(size(data_wc.x));
       [~,index]=min(abs(data_wc.x-xk),[],dim);
       if rem(n_pixel,2)
             n_pixel=n_pixel+1;
       end
    
       data_wc.value(index-n_pixel/2:index+n_pixel/2,:)=NaN;
       data_wc.value=inpaint_nans(data_wc.value);
       data_wc.value(data_wc.value<0)=0;
    end

    if strcmp(axis{axis_num},'y')
        [~,dim]=max(size(data_wc.y));
        [~,index]=min(abs(data_wc.y-xk),[],dim);
        if rem(n_pixel,2)
            n_pixel=n_pixel+1;
        end

        data_wc.value(:,index-n_pixel/2:index+n_pixel/2)=NaN;
        data_wc.value=inpaint_nans(data_wc.value);
        data_wc.value(data_wc.value<0)=0;
    end
    
% ----------------------3D-------------------    
elseif length(size(data_wc.value))==3
    
    %%  deal with different axis
    if strcmp(axis{axis_num},'y')    %--if mirror along y-axis----------------
        data_wc.value=permute(data_wc.value,[2,1,3]);
        inter=data_wc.x;
        data_wc.x=data_wc.y;
        data_wc.y=inter;
    elseif strcmp(axis{axis_num},'z')    %-- if mirror along z-axis----------------
        data_wc.value=permute(data_wc.value,[3,2,1]);
        inter=data_wc.x;
        data_wc.x=data_wc.z;
        data_wc.z=inter;
    end
    
    %%  wrinkle creame
    [~,dim]=max(size(data_wc.x));
    [~,index]=min(abs(data_wc.x-xk),[],dim);
    if rem(n_pixel,2)
          n_pixel=n_pixel+1;
    end
    
    data_wc.value(index-n_pixel/2:index+n_pixel/2,:,:)=NaN;
    for i=1:size(data_wc.value,3)
        data_wc.value(:,:,i)=inpaint_nans(data_wc.value(:,:,i));    
    end
    data_wc.value(data_wc.value<0)=0;
    %%  deal with different axis
    if strcmp(axis{axis_num},'y')    %--if mirror along y-axis----------------
        data_wc.value=permute(data_wc.value,[2,1,3]);
        inter=data_wc.x;
        data_wc.x=data_wc.y;
        data_wc.y=inter;
    elseif strcmp(axis{axis_num},'z')    %-- if mirror along z-axis----------------
        data_wc.value=permute(data_wc.value,[3,2,1]);
        inter=data_wc.x;
        data_wc.x=data_wc.z;
        data_wc.z=inter;
    end
    
end

assignin('base',cat(2,var_name,'_nw'),data_wc);

set(handles.light,'BackgroundColor',[0.757,0.867,0.776]);
set(handles.light,'String','Ready');
    



function flag_method_Callback(hObject, eventdata, handles)
% hObject    handle to flag_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flag_method as text
%        str2double(get(hObject,'String')) returns contents of flag_method as a double


% --- Executes during object creation, after setting all properties.
function flag_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flag_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
