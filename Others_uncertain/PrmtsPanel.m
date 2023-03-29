function varargout = PrmtsPanel(varargin)
% PRMTSPANEL MATLAB code for PrmtsPanel.fig
%      PRMTSPANEL, by itself, creates a new PRMTSPANEL or raises the existing
%      singleton*.
%
%      H = PRMTSPANEL returns the handle to a new PRMTSPANEL or the handle to
%      the existing singleton*.
%
%      PRMTSPANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRMTSPANEL.M with the given input arguments.
%
%      PRMTSPANEL('Property','Value',...) creates a new PRMTSPANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PrmtsPanel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PrmtsPanel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PrmtsPanel

% Last Modified by GUIDE v2.5 07-Jun-2013 03:09:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PrmtsPanel_OpeningFcn, ...
                   'gui_OutputFcn',  @PrmtsPanel_OutputFcn, ...
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


% --- Executes just before PrmtsPanel is made visible.
function PrmtsPanel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PrmtsPanel (see VARARGIN)

% Choose default command line output for PrmtsPanel
handles.output = hObject;


% ---define column headers, making modifications in the future easier---
handles.COL_HEADER_NAME.index=1;
handles.COL_HEADER_NAME.string='name';
handles.COL_HEADER_NAME.editable=false;
handles.COL_HEADER_NAME.columnwidth=100;
handles.COL_HEADER_NAME.format='char';

handles.COL_HEADER_PHOTON_ENERGY.index=2;
handles.COL_HEADER_PHOTON_ENERGY.string='<html>h&nu;';
handles.COL_HEADER_PHOTON_ENERGY.editable=true;
handles.COL_HEADER_PHOTON_ENERGY.columnwidth=30;
handles.COL_HEADER_PHOTON_ENERGY.format='numeric';

handles.COL_HEADER_TOTAL_RESOLUTION.index=3;
handles.COL_HEADER_TOTAL_RESOLUTION.string='<html>&Delta;h&nu;';
handles.COL_HEADER_TOTAL_RESOLUTION.editable=true;
handles.COL_HEADER_TOTAL_RESOLUTION.columnwidth=35;
handles.COL_HEADER_TOTAL_RESOLUTION.format='numeric';

handles.COL_HEADER_POLARIZATION.index=4;
handles.COL_HEADER_POLARIZATION.string='pol';
handles.COL_HEADER_POLARIZATION.editable=true;
handles.COL_HEADER_POLARIZATION.columnwidth=30;
handles.COL_HEADER_POLARIZATION.format='char';

handles.COL_HEADER_X_MIN.index=5;
handles.COL_HEADER_X_MIN.string='<html>x<sub>min';
handles.COL_HEADER_X_MIN.editable=false;
handles.COL_HEADER_X_MIN.columnwidth=45;
handles.COL_HEADER_X_MIN.format='numeric';

handles.COL_HEADER_X_MAX.index=6;
handles.COL_HEADER_X_MAX.string='<html>x<sub>max';
handles.COL_HEADER_X_MAX.editable=false;
handles.COL_HEADER_X_MAX.columnwidth=45;
handles.COL_HEADER_X_MAX.format='numeric';

handles.COL_HEADER_N_X.index=7;
handles.COL_HEADER_N_X.string='<html>N<sub>x';
handles.COL_HEADER_N_X.editable=false;
handles.COL_HEADER_N_X.columnwidth=25;
handles.COL_HEADER_N_X.format='numeric';

handles.COL_HEADER_Y_MIN.index=8;
handles.COL_HEADER_Y_MIN.string='<html>y<sub>min';
handles.COL_HEADER_Y_MIN.editable=false;
handles.COL_HEADER_Y_MIN.columnwidth=45;
handles.COL_HEADER_Y_MIN.format='numeric';

handles.COL_HEADER_Y_MAX.index=9;
handles.COL_HEADER_Y_MAX.string='<html>y<sub>max';
handles.COL_HEADER_Y_MAX.editable=false;
handles.COL_HEADER_Y_MAX.columnwidth=45;
handles.COL_HEADER_Y_MAX.format='numeric';

handles.COL_HEADER_N_Y.index=10;
handles.COL_HEADER_N_Y.string='<html>N<sub>y';
handles.COL_HEADER_N_Y.editable=false;
handles.COL_HEADER_N_Y.columnwidth=25;
handles.COL_HEADER_N_Y.format='numeric';

handles.COL_HEADER_Z_MIN.index=11;
handles.COL_HEADER_Z_MIN.string='<html>z<sub>min';
handles.COL_HEADER_Z_MIN.editable=false;
handles.COL_HEADER_Z_MIN.columnwidth=45;
handles.COL_HEADER_Z_MIN.format='numeric';

handles.COL_HEADER_Z_MAX.index=12;
handles.COL_HEADER_Z_MAX.string='<html>z<sub>max';
handles.COL_HEADER_Z_MAX.editable=false;
handles.COL_HEADER_Z_MAX.columnwidth=45;
handles.COL_HEADER_Z_MAX.format='numeric';

handles.COL_HEADER_N_Z.index=13;
handles.COL_HEADER_N_Z.string='<html>N<sub>z';
handles.COL_HEADER_N_Z.editable=false;
handles.COL_HEADER_N_Z.columnwidth=25;
handles.COL_HEADER_N_Z.format='numeric';

handles.COL_HEADER_THETA.index=14;
handles.COL_HEADER_THETA.string='<html>&theta;';
handles.COL_HEADER_THETA.editable=true;
handles.COL_HEADER_THETA.columnwidth=45;
handles.COL_HEADER_THETA.format=[];

handles.COL_HEADER_THETA_OFFSET.index=15;
handles.COL_HEADER_THETA_OFFSET.string='<html>&theta;<sub>off';
handles.COL_HEADER_THETA_OFFSET.editable=true;
handles.COL_HEADER_THETA_OFFSET.columnwidth=40;
handles.COL_HEADER_THETA_OFFSET.format=[];

handles.COL_HEADER_PHI.index=16;
handles.COL_HEADER_PHI.string='<html>&phi;';
handles.COL_HEADER_PHI.editable=true;
handles.COL_HEADER_PHI.columnwidth=45;
handles.COL_HEADER_PHI.format=[];

handles.COL_HEADER_PHI_OFFSET.index=17;
handles.COL_HEADER_PHI_OFFSET.string='<html>&phi;<sub>off';
handles.COL_HEADER_PHI_OFFSET.editable=true;
handles.COL_HEADER_PHI_OFFSET.columnwidth=40;
handles.COL_HEADER_PHI_OFFSET.format=[];

handles.COL_HEADER_AZI.index=18;
handles.COL_HEADER_AZI.string='<html>&omega;';
handles.COL_HEADER_AZI.editable=true;
handles.COL_HEADER_AZI.columnwidth=45;
handles.COL_HEADER_AZI.format=[];

handles.COL_HEADER_AZI_OFFSET.index=19;
handles.COL_HEADER_AZI_OFFSET.string='<html>&omega;<sub>off';
handles.COL_HEADER_AZI_OFFSET.editable=true;
handles.COL_HEADER_AZI_OFFSET.columnwidth=40;
handles.COL_HEADER_AZI_OFFSET.format=[];

handles.COL_HEADER_T_SAMPLE.index=20;
handles.COL_HEADER_T_SAMPLE.string='<html>T<sub>sample';
handles.COL_HEADER_T_SAMPLE.editable=true;
handles.COL_HEADER_T_SAMPLE.columnwidth=50;
handles.COL_HEADER_T_SAMPLE.format='numeric';

handles.COL_HEADER_PASS_ENERGY.index=21;
handles.COL_HEADER_PASS_ENERGY.string='Pass E';
handles.COL_HEADER_PASS_ENERGY.editable=true;
handles.COL_HEADER_PASS_ENERGY.columnwidth=40;
handles.COL_HEADER_PASS_ENERGY.format='numeric';

handles.COL_HEADER_N_SWEEPS.index=22;
handles.COL_HEADER_N_SWEEPS.string='<html>N<sub>sweeps';
handles.COL_HEADER_N_SWEEPS.editable=true;
handles.COL_HEADER_N_SWEEPS.columnwidth=44;
handles.COL_HEADER_N_SWEEPS.format='numeric';

handles.COL_HEADER_STEP_TIME.index=23;
handles.COL_HEADER_STEP_TIME.string='<html>t<sub>step</sub> (s)';
handles.COL_HEADER_STEP_TIME.editable=true;
handles.COL_HEADER_STEP_TIME.columnwidth=42;
handles.COL_HEADER_STEP_TIME.format='numeric';

handles.COL_HEADER_X_POS.index=24;
handles.COL_HEADER_X_POS.string='<html>x<sub>pos';
handles.COL_HEADER_X_POS.editable=true;
handles.COL_HEADER_X_POS.columnwidth=40;
handles.COL_HEADER_X_POS.format='numeric';


handles.COL_HEADER_Y_POS.index=25;
handles.COL_HEADER_Y_POS.string='<html>y<sub>pos';
handles.COL_HEADER_Y_POS.editable=true;
handles.COL_HEADER_Y_POS.columnwidth=40;
handles.COL_HEADER_Y_POS.format='numeric';

handles.COL_HEADER_Z_POS.index=26;
handles.COL_HEADER_Z_POS.string='<html>z<sub>pos';
handles.COL_HEADER_Z_POS.editable=true;
handles.COL_HEADER_Z_POS.columnwidth=40;
handles.COL_HEADER_Z_POS.format='numeric';

handles.COL_HEADER_SAMPLE_NAME.index=27;
handles.COL_HEADER_SAMPLE_NAME.string='sample';
handles.COL_HEADER_SAMPLE_NAME.editable=true;
handles.COL_HEADER_SAMPLE_NAME.columnwidth=50;
handles.COL_HEADER_SAMPLE_NAME.format='char';

% ----------------------------------------------------------------------


vbox_home=uiextras.VBox('Parent',hObject);
hbox1_home=uiextras.HBox('Parent',vbox_home);
handles.ut_prmts=uitable('Parent',vbox_home,'RowName',{'numbered'},...
    'CellEditCallback',@ut_prmts_CellEditCallback,...
    'KeyPressFcn',@ut_prmts_KeyPressFcn,...
    'TooltipString','When multi-rows of editable numeric cells are selected, press "F9" to get arithmetic progression.');
set(vbox_home,'Sizes',[15 -1],'Padding',3,'Spacing',3)
% hbox1_home
bg_dim=uibuttongroup('Parent',hbox1_home,'BorderType','none',...
    'SelectionChangeFcn',@bg_dim_SelectionChangeFcn);
handles.rb_2D=uicontrol('Parent',bg_dim,'Style','radiobutton',...
    'String','2D','pos',[10 2 35 15]);
handles.rb_3D=uicontrol('Parent',bg_dim,'Style','radiobutton',...
    'String','3D','pos',[50 2 35 15]);

% ut_prmts
fields=fieldnames(handles);
i_COLs=strmatch('COL_HEADER_',fields);
handles.COL_HEADER_N=length(i_COLs);
handles.COL_HEADER_LIST=cell(1,handles.COL_HEADER_N);
colname=cell(1,handles.COL_HEADER_N);
coleditable=false(1,handles.COL_HEADER_N);
colwidth=cell(1,handles.COL_HEADER_N);
colformat=cell(1,handles.COL_HEADER_N);
for i=1:handles.COL_HEADER_N
    s_COL=char(fields(i_COLs(i)));
    handles.COL_HEADER_LIST(handles.(s_COL).index)={s_COL};
    colname(i)={handles.(s_COL).string};
    coleditable(i)=handles.(s_COL).editable;
    colwidth(i)={handles.(s_COL).columnwidth};
    colformat(i)={handles.(s_COL).format};
end
set(handles.ut_prmts,'ColumnName',colname,'ColumnEditable',coleditable,...
    'ColumnWidth',colwidth,'ColumnFormat',colformat)


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PrmtsPanel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PrmtsPanel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% java object
jscroll = findjobj_2013(handles.ut_prmts); 
handles.jtable = jscroll.getViewport.getComponent(0); 
guidata(hObject, handles);

UpdateUTPrmts(handles)




function bg_dim_SelectionChangeFcn(hObject, eventdata)
% hObject    handle to bg_dim (see GCBO)
% eventdata  EventName: 'SelectionChanged'
%            OldValue: Handle of the object selected before this event. [] if none was selected.
%            NewValue: Handle of the currently selected object.
handles=guidata(hObject);
UpdateUTPrmts(handles)






% set s to [row,col] in ut_prmts
function data=SetUTPrmts(handles,row,col,s)
v_ut_prmts=get(handles.ut_prmts,'Data');
varname=char(v_ut_prmts(row,handles.COL_HEADER_NAME.index));
data=evalin('base',varname);
switch col
    case handles.COL_HEADER_PHOTON_ENERGY.index
        data.info.PhotonEnergy=str2double(s);
    case handles.COL_HEADER_TOTAL_RESOLUTION.index
        data.info.TotalResolution=str2double(s);
    case handles.COL_HEADER_POLARIZATION.index
        data.info.Polarization=s;
    case handles.COL_HEADER_THETA.index
        if get(handles.rb_2D,'Value')
            data.info.theta=str2double(s);
        elseif get(handles.rb_3D,'Value')
            data.info.theta=s;
        end
    case handles.COL_HEADER_THETA_OFFSET.index
        data.info.theta_offset=str2double(s);
    case handles.COL_HEADER_PHI.index
        if get(handles.rb_2D,'Value')
            data.info.phi=str2double(s);
        elseif get(handles.rb_3D,'Value')
            data.info.phi=s;
        end
    case handles.COL_HEADER_PHI_OFFSET.index
        data.info.phi_offset=str2double(s);
    case handles.COL_HEADER_AZI.index
        if get(handles.rb_2D,'Value')
            data.info.azi=str2double(s);
        elseif get(handles.rb_3D,'Value')
            data.info.azi=s;
        end
    case handles.COL_HEADER_AZI_OFFSET.index
        data.info.azi_offset=str2double(s);
    case handles.COL_HEADER_T_SAMPLE.index
        data.info.Tsample=str2double(s);
    case handles.COL_HEADER_PASS_ENERGY.index
        data.info.PassEnergy=str2double(s);
    case handles.COL_HEADER_N_SWEEPS.index
        data.info.Nsweeps=str2double(s);
    case handles.COL_HEADER_STEP_TIME.index
        data.info.StepTime=str2double(s);
    case handles.COL_HEADER_X_POS.index
        data.info.Xpos=str2double(s);
    case handles.COL_HEADER_Y_POS.index
        data.info.Ypos=str2double(s);
    case handles.COL_HEADER_Z_POS.index
        data.info.Zpos=str2double(s);
    case handles.COL_HEADER_SAMPLE_NAME.index
        data.info.SampleName=s;
end
guidata(handles.figure1,handles)






function ut_prmts_CellEditCallback(hObject, eventdata)
% hObject    handle to ut_prmts (see GCBO)
% eventdata  Indices: Row index and column index of the cell the user edited.
%            PreviousData: Previous data for the changed cell. 
%            EditData: User-entered string.
%            NewData: Value that uitable wrote to Data. 
%            Error: Error that occurred
handles=guidata(hObject);
v_ut_prmts=get(handles.ut_prmts,'Data');
varname=char(v_ut_prmts(eventdata.Indices(1),handles.COL_HEADER_NAME.index));
data=SetUTPrmts(handles,eventdata.Indices(1),eventdata.Indices(2),eventdata.EditData);
assignin('base',varname,data)








function ut_prmts_KeyPressFcn(hObject, eventdata)
% hObject    handle to ut_prmts (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
handles=guidata(hObject);

v_ut_prmts=get(handles.ut_prmts,'Data');
rows=handles.jtable.getSelectedRows+1;
cols=handles.jtable.getSelectedColumns+1;

switch eventdata.Key
    case 'f9'
        if length(rows)<3
            return
        end
        for i=1:length(cols)
            s_COL=char(handles.COL_HEADER_LIST(cols(i)));
            if ~handles.(s_COL).editable || strcmpi(handles.(s_COL).format,'char')
                continue
            end
            v1=cell2mat(v_ut_prmts(rows(1),cols(i)));
            v2=cell2mat(v_ut_prmts(rows(2),cols(i)));
            if isempty(v1) || isempty(v2) || isnan(v1) || isnan(v2)
                continue
            end
            for j=3:length(rows)
                v=v2+(v2-v1)*(j-2);
                handles.jtable.setValueAt(java.lang.String(num2str(v)),rows(j)-1,cols(i)-1);
                varname=char(v_ut_prmts(rows(j),handles.COL_HEADER_NAME.index));
                data=SetUTPrmts(handles,rows(j),cols(i),num2str(v));
                assignin('base',varname,data)
            end
        end
    case 'delete'
        if length(rows)>1 || length(cols)>1
            for j=1:length(rows)
                varname=char(v_ut_prmts(rows(j),handles.COL_HEADER_NAME.index));
                for i=1:length(cols)
                    handles.jtable.setValueAt(java.lang.String(''),rows(j)-1,cols(i)-1);
                    data=SetUTPrmts(handles,rows(j),cols(i),'');
                end
                assignin('base',varname,data)
            end
        end
end
% guidata(handles.figure1,handles)





% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateUTPrmts(handles)




% update ut_prmts
function UpdateUTPrmts(handles)
varnames=evalin('base','who');
% get dims for list
flag_3D=get(handles.rb_3D,'Value');
flag_2D=get(handles.rb_2D,'Value');

if flag_2D
    index=1;
    varnames_new={};
    for i=1:length(varnames)
        data=evalin('base',varnames{i});
        if isfield(data,'x') && isfield(data,'y') && ~isfield(data,'z')
            varnames_new{index}=varnames{i};
            index=index+1;
        end
    end
    n_vars=length(varnames_new);
    v_ut_prmts=cell(n_vars,handles.COL_HEADER_N);
    if n_vars
        v_ut_prmts(:,handles.COL_HEADER_NAME.index)=varnames_new;
    end
    handles.COL_HEADER_THETA.format='numeric';
    handles.COL_HEADER_PHI.format='numeric';
    handles.COL_HEADER_AZI.format='numeric';
end

if flag_3D
    index=1;
    varnames_new={};
    for i=1:length(varnames)
        data=evalin('base',varnames{i});
        if isfield(data,'x') && isfield(data,'y') && isfield(data,'z')
            varnames_new{index}=varnames{i};
            index=index+1;
        end
    end
    n_vars=length(varnames_new);
    v_ut_prmts=cell(n_vars,handles.COL_HEADER_N);
    if n_vars
        v_ut_prmts(:,handles.COL_HEADER_NAME.index)=varnames_new;
    end
    handles.COL_HEADER_THETA.format='char';
    handles.COL_HEADER_PHI.format='char';
    handles.COL_HEADER_AZI.format='char';
end

for i=1:n_vars
    data=evalin('base',varnames_new{i});
    if isfield(data,'x')
        v_ut_prmts(i,handles.COL_HEADER_X_MIN.index)={min(data.x)};
        v_ut_prmts(i,handles.COL_HEADER_X_MAX.index)={max(data.x)};
        v_ut_prmts(i,handles.COL_HEADER_N_X.index)={length(data.x)};
    end
    if isfield(data,'y')
        v_ut_prmts(i,handles.COL_HEADER_Y_MIN.index)={min(data.y)};
        v_ut_prmts(i,handles.COL_HEADER_Y_MAX.index)={max(data.y)};
        v_ut_prmts(i,handles.COL_HEADER_N_Y.index)={length(data.y)};
    end
    if isfield(data,'z')
        v_ut_prmts(i,handles.COL_HEADER_Z_MIN.index)={min(data.z)};
        v_ut_prmts(i,handles.COL_HEADER_Z_MAX.index)={max(data.z)};
        v_ut_prmts(i,handles.COL_HEADER_N_Z.index)={length(data.z)};
    end
    if isfield(data,'info')
        if isfield(data.info,'theta')
            if flag_2D
                v_ut_prmts(i,handles.COL_HEADER_THETA.index)={data.info.theta};
            elseif flag_3D
                v_ut_prmts(i,handles.COL_HEADER_THETA.index)={num2str(data.info.theta)};
                
            end
        end
        if isfield(data.info,'theta_offset')
            v_ut_prmts(i,handles.COL_HEADER_THETA_OFFSET.index)={data.info.theta_offset};
        end
        if isfield(data.info,'phi')
            if flag_2D
                v_ut_prmts(i,handles.COL_HEADER_PHI.index)={data.info.phi};
            elseif flag_3D
                v_ut_prmts(i,handles.COL_HEADER_PHI.index)={num2str(data.info.phi)};
                
            end
        end
        if isfield(data.info,'phi_offset')
            v_ut_prmts(i,handles.COL_HEADER_PHI_OFFSET.index)={data.info.phi_offset};
        end
        if isfield(data.info,'azi')
            if flag_2D
                v_ut_prmts(i,handles.COL_HEADER_AZI.index)={data.info.azi};
            elseif flag_3D
                v_ut_prmts(i,handles.COL_HEADER_AZI.index)={num2str(data.info.azi)};
            end
        end
        if isfield(data.info,'azi_offset')
            v_ut_prmts(i,handles.COL_HEADER_AZI_OFFSET.index)={data.info.azi_offset};
        end
        if isfield(data.info,'PhotonEnergy')
            v_ut_prmts(i,handles.COL_HEADER_PHOTON_ENERGY.index)={data.info.PhotonEnergy};
        end
        if isfield(data.info,'TotalResolution')
            v_ut_prmts(i,handles.COL_HEADER_TOTAL_RESOLUTION.index)={data.info.TotalResolution};
        end
        if isfield(data.info,'Polarization')
            v_ut_prmts(i,handles.COL_HEADER_POLARIZATION.index)={data.info.Polarization};
        end
        if isfield(data.info,'Tsample')
            v_ut_prmts(i,handles.COL_HEADER_T_SAMPLE.index)={data.info.Tsample};
        end
        if isfield(data.info,'PassEnergy')
            v_ut_prmts(i,handles.COL_HEADER_PASS_ENERGY.index)={data.info.PassEnergy};
        end
        if isfield(data.info,'Nsweeps')
            v_ut_prmts(i,handles.COL_HEADER_N_SWEEPS.index)={data.info.Nsweeps};
        end
        if isfield(data.info,'StepTime')
            v_ut_prmts(i,handles.COL_HEADER_STEP_TIME.index)={data.info.StepTime};
        end
        if isfield(data.info,'Xpos')
            v_ut_prmts(i,handles.COL_HEADER_X_POS.index)={data.info.Xpos};
        end
        if isfield(data.info,'Ypos')
            v_ut_prmts(i,handles.COL_HEADER_Y_POS.index)={data.info.Ypos};
        end
        if isfield(data.info,'Zpos')
            v_ut_prmts(i,handles.COL_HEADER_Z_POS.index)={data.info.Zpos};
        end
        if isfield(data.info,'SampleName')
            v_ut_prmts(i,handles.COL_HEADER_SAMPLE_NAME.index)={data.info.SampleName};
        end
    end
end

colformat=get(handles.ut_prmts,'ColumnFormat');
colformat(handles.COL_HEADER_THETA.index)={handles.COL_HEADER_THETA.format};
colformat(handles.COL_HEADER_PHI.index)={handles.COL_HEADER_PHI.format};
colformat(handles.COL_HEADER_AZI.index)={handles.COL_HEADER_AZI.format};
set(handles.ut_prmts,'Data',v_ut_prmts,'ColumnFormat',colformat)
guidata(handles.figure1,handles)
