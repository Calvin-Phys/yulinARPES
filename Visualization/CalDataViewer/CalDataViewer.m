function CalDataViewer(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Call Sub Functions ONLY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==1
    fig_CalDataViewer=findall(0,'Tag','fig_CalDataViewer');
    handles=guidata(fig_CalDataViewer);
    eval(varargin{1});
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Build CalDataViewer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=findall(0,'Tag','fig_CalDataViewer');
if ~isempty(h)
    %     figure(h);
    %     return;
    delete(h);
end
handles.fig_CalDataViewer = figure( 'Position', [1030 150 600 875], ...
    'HandleVisibility','off',...
    'Tag','fig_CalDataViewer',...
    'Name', 'CalDataViewer v20150704 -- Teng Zhang',...
    'NumberTitle', 'off', ...
    'menubar', 'none');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Menu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Settings
menu_settings=uimenu(handles.fig_CalDataViewer,...
    'Label','Settings');
handles.menu_local_varlist=uimenu(menu_settings,...
    'Label','Local VarList',...
    'Callback',@menu_local_varlist_Callback);
handles.menu_shared_varlist=uimenu(menu_settings,...
    'Label','Shared VarList',...
    'Callback',@menu_shared_varlist_Callback);
%Help
menu_help=uimenu(handles.fig_CalDataViewer,...
    'Label','Help');
handles.menu_edit_code=uimenu(menu_help,...
    'Label','Edit code',...
    'Callback','edit CalDataViewer');
handles.menu_explore_codefolder=uimenu(menu_help,...
    'Label','Explore codefolder',...
    'Callback',@menu_explore_codefolder_Callback);
handles.menu_zip_code=uimenu(menu_help,...
    'Label','Zip codefile',...
    'Callback',@menu_zip_code_Callback);
handles.menu_zip_allcode=uimenu(menu_help,...
    'Label','Zip all related codefiles',...
    'Callback',@menu_zip_allcode_Callback);
handles.menu_about=uimenu(menu_help,...
    'Label','About',...
    'Separator','on',...
    'Callback',@menu_about_Callback);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Home Layout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.hbox_home=uiextras.HBox('Parent',handles.fig_CalDataViewer);
handles.lb_vars=uicontrol('Parent',handles.hbox_home,...
    'Style','listbox',...
    'Max',2,...
    'BackgroundColor','white',...
    'Callback',@lb_vars_Callback);
vbox_home=uiextras.VBox('Parent',handles.hbox_home);
set(handles.hbox_home,'Sizes',[0 -1]);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Columns Layout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.st_status=uicontrol('Parent',vbox_home,...
    'Style','text',...
    'String','Idle',...
    'BackgroundColor','k',...
    'ForegroundColor','g',...
    'FontSize',13,...
    'FontWeight','bold');
hbox_columns=uiextras.HBox('Parent',vbox_home);
set(vbox_home,'Sizes',[25 -1]);
vbox_column1=uiextras.VBox('Parent',hbox_columns);
vbox_column2=uiextras.VBox('Parent',hbox_columns);
vbox_column3=uiextras.VBox('Parent',hbox_columns);
set(hbox_columns,'Sizes',[-1 -1 -1]);

%vbox_column1 Layout
panel_3D_kspace=uipanel('Parent',vbox_column1,...
    'BorderType','etchedout',...
    'Title','3D k-space [k1, k2, k3, E]',...
    'ForegroundColor','b',...
    'ShadowColor','k',...
    'FontWeight','bold',...
    'FontUnits','pixels');
panel_view3D_isosurf=uipanel('Parent',vbox_column1,...
    'BorderType','etchedout',...
    'Title','3D k-space View -- isosurf3D',...
    'ForegroundColor','b',...
    'ShadowColor','k',...
    'FontWeight','bold',...
    'FontUnits','pixels');
set(vbox_column1,'Sizes',[670 170],'Padding',2,'Spacing',5);

%vbox_column2 Layout

panel_2D_kspace=uipanel('Parent',vbox_column2,...
    'BorderType','etchedout',...
    'Title','2D k-space [k1, k2, E, I]',...
    'ForegroundColor','b',...
    'ShadowColor','k',...
    'FontWeight','bold',...
    'FontUnits','pixels');
panel_view2D_Econtour=uipanel('Parent',vbox_column2,...
    'BorderType','etchedout',...
    'Title','2D k-space View -- Econtours',...
    'ForegroundColor','b',...
    'ShadowColor','k',...
    'FontWeight','bold',...
    'FontUnits','pixels');
panel_view2D_ScatteredData=uipanel('Parent',vbox_column2,...
    'BorderType','etchedout',...
    'Title','2D ScatteredData[xx,yy,(II)]',...
    'ForegroundColor','b',...
    'ShadowColor','k',...
    'FontWeight','bold',...
    'FontUnits','pixels');
set(vbox_column2,'Sizes',[185 280 220],'Padding',2,'Spacing',5);

%vbox_column3 Layout
panel_transform=uipanel('Parent',vbox_column3,...
    'BorderType','etchedout',...
    'Title','2D Transformation',...
    'ForegroundColor','b',...
    'ShadowColor','k',...
    'FontWeight','bold',...
    'FontUnits','pixels');
panel_drawing_parameters=uipanel('Parent',vbox_column3,...
    'BorderType','etchedout',...
    'Title','Drawing Parameters',...
    'ForegroundColor',[0 0.5 0],...
    'ShadowColor',[0 0.5 0],...
    'FontWeight','bold',...
    'FontUnits','pixels');

set(vbox_column3,'Sizes',[170 420],'Padding',2,'Spacing',5);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Panel 3D kspace [k1, k2, k3, E]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbox_3D_kspace=uiextras.VBox('Parent',panel_3D_kspace);
%load file
handles.pb_load_bxsf=uicontrol('Parent',vbox_3D_kspace,...
    'Style','pushbutton',...
    'String','Load ".bxsf"',...
    'Callback',@pb_load_bxsf_Callback);
%bravias lattice
panel_bravais_lattice=uiextras.Panel('Parent',vbox_3D_kspace,...
    'BorderType','etchedout',...
    'Title','Bravais Lattice',...
    'FontUnits','pixels',...
    'Padding',1);
list_bravais_lattice={
    'ORT,TET,SC'
    'BCO,BCT,BCC'
    'FCO,FCC [Not coded]'
    'HEX [Not coded]'
    };
handles.popup_bravais_lattice=uicontrol('Parent',panel_bravais_lattice,...
    'Style','popupmenu',...
    'BackgroundColor','white',...
    'String',list_bravais_lattice,...
    'Value',2,...
    'Callback',@popup_bravais_lattice_Callback);

%lattice const
panel_lattice_const=uiextras.Panel('Parent',vbox_3D_kspace,...
    'BorderType','etchedout',...
    'Title','Lattice Const [ReadOnly]',...
    'FontUnits','pixels');
grid_lattice_const=uiextras.Grid('Parent',panel_lattice_const,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',repmat(20,[1,6]),....
    'Padding',2);
st_ka=uicontrol('Parent',grid_lattice_const,...
    'Style','text',...
    'String','2pi/a [A-1]');
st_kb=uicontrol('Parent',grid_lattice_const,...
    'Style','text',...
    'String','2pi/b [A-1]');
st_kc=uicontrol('Parent',grid_lattice_const,...
    'Style','text',...
    'String','2pi/c [A-1]');
st_a=uicontrol('Parent',grid_lattice_const,...
    'Style','text',...
    'String','a [A]');
st_b=uicontrol('Parent',grid_lattice_const,...
    'Style','text',...
    'String','b [A]');
st_c=uicontrol('Parent',grid_lattice_const,...
    'Style','text',...
    'String','c [A]');
handles.ed_ka=uicontrol('Parent',grid_lattice_const,...
    'Style','edit',...
    'String','NaN');
handles.ed_kb=uicontrol('Parent',grid_lattice_const,...
    'Style','edit',...
    'String','NaN');
handles.ed_kc=uicontrol('Parent',grid_lattice_const,...
    'Style','edit',...
    'String','NaN');
handles.ed_a=uicontrol('Parent',grid_lattice_const,...
    'Style','edit',...
    'String','NaN');
handles.ed_b=uicontrol('Parent',grid_lattice_const,...
    'Style','edit',...
    'String','NaN');
handles.ed_c=uicontrol('Parent',grid_lattice_const,...
    'Style','edit',...
    'String','NaN');

%resample3D
panel_resample3D_type=uiextras.Panel('Parent',vbox_3D_kspace,...
    'BorderType','etchedout',...
    'Title','Resample3D Type',...
    'FontUnits','pixels',...
    'Padding',1);
list_resample3D_type={
    'bulk <Nx,Ny,Nz>'
    'plane kx-ky <Nx,Ny,1>'
    'plane kx-kz <Nx,1,Nz>'
    'plane ky-kz <1,Ny,Nz>'
    'plane kxy-kz <Nxy(P1,P2),Nz>'
    'plane kyz-kx <Nyz(P1,P2),Nx>'
    'plane kxz-ky <Nxz(P1,P2),Ny>'
    };
handles.popup_resample3D_type=uicontrol('Parent',panel_resample3D_type,...
    'Style','popupmenu',...
    'BackgroundColor','white',...
    'String',list_resample3D_type,...
    'Value',1,...
    'Callback',@popup_resample3D_type_Callback);

grid_resample3D_mesh=uiextras.Grid('Parent',vbox_3D_kspace,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',repmat(20,[1,6]));
st_vx=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','text',...
    'String','vx [2pi/a]');
st_vy=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','text',...
    'String','vy [2pi/b]');
st_vz=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','text',...
    'String','vz [2pi/c]');
st_P1=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','text',...
    'String','P1 [x1,y1]',...
    'TooltipString','or [y1,z1] or [x1,z1]');
st_P2=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','text',...
    'String','P2 [x2,y2]',...
    'TooltipString','or [y2,z2] or [x2,z2]');
st_Np=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','text',...
    'String','Np');

handles.ed_vx=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_vy=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_vz=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_P1=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','edit',...
    'String','[-0.5,-0.5]',...
    'BackgroundColor','white');
handles.ed_P2=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','edit',...
    'String','[0.5,0.5]',...
    'BackgroundColor','white');
handles.ed_Np=uicontrol('Parent',grid_resample3D_mesh,...
    'Style','edit',...
    'String','51',...
    'BackgroundColor','white');
handles.pb_Resample3D=uicontrol('Parent',vbox_3D_kspace,...
    'Style','pushbutton',...
    'String','Resample3D [PrimitiveCell2OC]',...
    'Callback',@pb_Resample3D_Callback);

%arbitrary cut
panel_arbitrary_cut=uiextras.Panel('Parent',vbox_3D_kspace,...
    'BorderType','etchedout',...
    'Title','Arbitrary Cut',...
    'FontUnits','pixels');
vbox_arbitrary_cut=uiextras.VBox('Parent',panel_arbitrary_cut,...
    'Padding',2);
grid_arbitrary_cut=uiextras.Grid('Parent',vbox_arbitrary_cut,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',repmat(20,[1,10]));
handles.popup_miller_index_type=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','popupmenu',...
    'String',{'Miller[UC]','Miller[PC]'});
st_new_a=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','text',...
    'String','a [A]');
st_new_b=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','text',...
    'String','b [A]');
st_new_c=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','text',...
    'String','c [A]');
st_Lkx=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','text',...
    'String','Lkx [A-1]');
st_Lky=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','text',...
    'String','Lky [A-1]');
st_Lkz=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','text',...
    'String','Lkz [A-1]');
st_az0=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','text',...
    'String','az0 [norm]');
st_acut_Nx=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','text',...
    'String','Nx');
st_acut_Ny=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','text',...
    'String','Ny');

handles.ed_miller_index=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','[1 1 2]',...
    'BackgroundColor','white');
handles.ed_new_a=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_new_b=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_new_c=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_Lkx=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','5',...
    'BackgroundColor','white');
handles.ed_Lky=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','5',...
    'BackgroundColor','white');
handles.ed_Lkz=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','NaN');
handles.ed_az0=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','0',...
    'BackgroundColor','white');
handles.ed_acut_Nx=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','100',...
    'BackgroundColor','white');
handles.ed_acut_Ny=uicontrol('Parent',grid_arbitrary_cut,...
    'Style','edit',...
    'String','100',...
    'BackgroundColor','white');

handles.pb_arbitrary_cut=uicontrol('Parent',vbox_arbitrary_cut,...
    'Style','pushbutton',...
    'String','Arbitrary Cut [PrimitiveCell2OC]',...
    'Callback',@pb_arbitrary_cut_Callback);
set(vbox_arbitrary_cut,'Sizes',[-1 30]);

set(vbox_3D_kspace,'Sizes',[30, 40 130 40 120 30 -1],'Spacing',2);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Panel view3D_isosurf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbox_view3D_isosurf=uiextras.VBox('Parent',panel_view3D_isosurf);
%Isosurf 3D
grid_isosurf=uiextras.Grid('Parent',vbox_view3D_isosurf,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',[20 20 20 20]);
st_Ebind=uicontrol('Parent',grid_isosurf,...
    'Style','text',...
    'String','Ebind < >',...
    'TooltipString','Press Key <Up>/<Down> to change Ebind');
st_Ebind_step=uicontrol('Parent',grid_isosurf,...
    'Style','text',...
    'String','step');
st_bind_No=uicontrol('Parent',grid_isosurf,...
    'Style','text',...
    'String','Band#');
handles.cb_isosurf_newfig=uicontrol('Parent',grid_isosurf,...
    'Style','checkbox',...
    'String','new figure',...
    'Value',1);
handles.ed_Ebind=uicontrol('Parent',grid_isosurf,...
    'Style','edit',...
    'String','7.265',...
    'BackgroundColor','white',...
    'Callback',@ed_Ebind_Callback,...
    'KeyPressFcn',@ed_Ebind_KeyPressFcn);
handles.ed_Ebind_step=uicontrol('Parent',grid_isosurf,...
    'Style','edit',...
    'String','0.01',...
    'BackgroundColor','white');
handles.ed_band_No=uicontrol('Parent',grid_isosurf,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.cb_isosurf_replace=uicontrol('Parent',grid_isosurf,...
    'Style','checkbox',...
    'String','replace',...
    'Value',1);
panel_view=uiextras.Panel('Parent',vbox_view3D_isosurf,...
    'BorderType','etchedout',...
    'Title','View',...
    'Padding',1);
hbox_view=uiextras.HBox('Parent',panel_view);
handles.pb_front_view=uicontrol('Parent',hbox_view,...
    'Style','pushbutton',...
    'String','front',...
    'Callback','view(0,0)');
handles.pb_side_view=uicontrol('Parent',hbox_view,...
    'Style','pushbutton',...
    'String','side',...
    'Callback','view(90,0)');
handles.pb_top_view=uicontrol('Parent',hbox_view,...
    'Style','pushbutton',...
    'String','top',...
    'Callback','view(0,90)');
handles.pb_3D_view=uicontrol('Parent',hbox_view,...
    'Style','pushbutton',...
    'String','3D',...
    'Callback','view(3)');
handles.pb_isosurf=uicontrol('Parent',vbox_view3D_isosurf,...
    'Style','pushbutton',...
    'String','Plot isosurf3D',...
    'Callback',@pb_isosurf_Callback);
set(vbox_view3D_isosurf,'Sizes',[80 40 30],'Spacing',2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Panel 2D kspace [k1, k2, E]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbox_2D_kspace=uiextras.VBox('Parent',panel_2D_kspace);
%load file
handles.pb_load_folder=uicontrol('Parent',vbox_2D_kspace,...
    'Style','pushbutton',...
    'String','Load Folder',...
    'Callback',@pb_load_folder_Callback);
%pack selected bands
grid_packbands=uiextras.Grid('Parent',vbox_2D_kspace,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',[20]);
st_packbands_prefix=uicontrol('Parent',grid_packbands,...
    'Style','text',...
    'String','output prefix [opt]:');
handles.ed_packbands_prefix=uicontrol('Parent',grid_packbands,...
    'Style','edit',...
    'BackgroundColor','white',...
    'String','');
handles.pb_packbands=uicontrol('Parent',vbox_2D_kspace,...
    'Style','pushbutton',...
    'String','Pack Selected Bands [OC]',...
    'Callback',@pb_packbands_Callback);
%Resample2D
grid_resample2D_mesh=uiextras.Grid('Parent',vbox_2D_kspace,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',repmat(20,[1,3]));
st_resample2D_Nx=uicontrol('Parent',grid_resample2D_mesh,...
    'Style','text',...
    'String','Nx');
st_resample2D_Ny=uicontrol('Parent',grid_resample2D_mesh,...
    'Style','text',...
    'String','Ny');
st_resample2D_prefix=uicontrol('Parent',grid_resample2D_mesh,...
    'Style','text',...
    'String','output prefix [opt]:');
handles.ed_resample2D_Nx=uicontrol('Parent',grid_resample2D_mesh,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_resample2D_Ny=uicontrol('Parent',grid_resample2D_mesh,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_resample2D_prefix=uicontrol('Parent',grid_resample2D_mesh,...
    'Style','edit',...
    'BackgroundColor','white',...
    'String','');
handles.pb_resample2D=uicontrol('Parent',vbox_2D_kspace,...
    'Style','pushbutton',...
    'String','Combine & Resample2D [OC2OC]',...
    'Callback',@pb_resample2D_Callback);
set(vbox_2D_kspace,'Sizes',[30, 20 30, 60 30]);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Panel view2D_Econtour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbox_view2D_Econtour=uiextras.VBox('Parent',panel_view2D_Econtour);
%Generate Econtour & Map
grid_Econtour=uiextras.Grid('Parent',vbox_view2D_Econtour,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',[20 20 20]);
st_Emin=uicontrol('Parent',grid_Econtour,...
    'Style','text',...
    'String','Emin');
st_Emax=uicontrol('Parent',grid_Econtour,...
    'Style','text',...
    'String','Emax');
st_Estep=uicontrol('Parent',grid_Econtour,...
    'Style','text',...
    'String','Estep');
handles.ed_Emin=uicontrol('Parent',grid_Econtour,...
    'Style','edit',...
    'String','7',...
    'BackgroundColor','white');
handles.ed_Emax=uicontrol('Parent',grid_Econtour,...
    'Style','edit',...
    'String','7.5',...
    'BackgroundColor','white');
handles.ed_Estep=uicontrol('Parent',grid_Econtour,...
    'Style','edit',...
    'String','0.01',...
    'BackgroundColor','white');
handles.cb_generate_map=uicontrol('Parent',vbox_view2D_Econtour,...
    'Style','checkbox',...
    'String','generate map',...
    'Value',1);
handles.pb_generate_Econtour=uicontrol('Parent',vbox_view2D_Econtour,...
    'Style','pushbutton',...
    'String','Generate Econtour',...
    'Callback',@pb_generate_Econtour_Callback);
handles.pb_combine_Econtour=uicontrol('Parent',vbox_view2D_Econtour,...
    'Style','pushbutton',...
    'String','Combine Econtour',...
    'Callback',@pb_combine_Econtour_Callback);

%Plot Econtours
grid_plot_Econtours=uiextras.Grid('Parent',vbox_view2D_Econtour,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',[20 20 20],...
    'Padding',2);
st_rows=uicontrol('Parent',grid_plot_Econtours,...
    'Style','text',...
    'String','rows');
st_cols=uicontrol('Parent',grid_plot_Econtours,...
    'Style','text',...
    'String','cols');
st_vE=uicontrol('Parent',grid_plot_Econtours,...
    'Style','text',...
    'String','v_E');
handles.ed_rows=uicontrol('Parent',grid_plot_Econtours,...
    'Style','edit',...
    'String','2',...
    'BackgroundColor','white');
handles.ed_cols=uicontrol('Parent',grid_plot_Econtours,...
    'Style','edit',...
    'String','3',...
    'BackgroundColor','white');
handles.ed_vE=uicontrol('Parent',grid_plot_Econtours,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.cb_seperate_figs=uicontrol('Parent',vbox_view2D_Econtour,...
    'Style','checkbox',...
    'String','seperate figs');
handles.pb_plot_Econtours=uicontrol('Parent',vbox_view2D_Econtour,...
    'Style','pushbutton',...
    'String','Plot Econtours',...
    'Callback',@pb_plot_Econtours_Callback);

set(vbox_view2D_Econtour,'Sizes',[60 20 30, 30, 60 20 30],'Spacing',2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Panel 2D ScatteredData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbox_view2D_ScatteredData=uiextras.VBox('Parent',panel_view2D_ScatteredData);
handles.pb_scatter_points=uicontrol('Parent',vbox_view2D_ScatteredData,...
    'Style','pushbutton',...
    'String','Scatter Points[xx,yy,II] (patch-type)',...
    'Callback',@pb_scatter_points_Callback);
handles.pb_plot_points=uicontrol('Parent',vbox_view2D_ScatteredData,...
    'Style','pushbutton',...
    'String','Plot Points[xx,yy] (line-type)',...
    'Callback',@pb_plot_points_Callback);
handles.pb_save_patch_points=uicontrol('Parent',vbox_view2D_ScatteredData,...
    'Style','pushbutton',...
    'String','Save gca:patch Points[xx,yy,II]',...
    'Callback',@pb_save_patch_points_Callback);
handles.pb_save_line_points=uicontrol('Parent',vbox_view2D_ScatteredData,...
    'Style','pushbutton',...
    'String','Save gca:line Points[xx,yy]',...
    'Callback',@pb_save_line_points_Callback);
grid_catch_settings=uiextras.Grid('Parent',vbox_view2D_ScatteredData,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',[20 20],...
    'Padding',0);
st_catch_threshold=uicontrol('Parent',grid_catch_settings,...
    'Style','text',...
    'String','threshold');
handles.cb_catch_intensity=uicontrol('Parent',grid_catch_settings,...
    'Style','checkbox',...
    'Value',0,...
    'String','catch intensity');
handles.ed_catch_threshold=uicontrol('Parent',grid_catch_settings,...
    'Style','edit',...
    'String','0',...
    'BackgroundColor','white');

handles.pb_catch_image_points=uicontrol('Parent',vbox_view2D_ScatteredData,...
    'Style','pushbutton',...
    'String','Catch gca:image Points',...
    'Callback',@pb_catch_image_points_Callback);
set(vbox_view2D_ScatteredData,'Sizes',[30 30 30 30 40 30],'Padding',2);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Panel Transformation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbox_transform=uiextras.VBox('Parent',panel_transform);
%Symmetrization
panel_symmetrization=uiextras.Panel('Parent',vbox_transform,...
    'BorderType','etchedout',...
    'Title','Symmetrization',...
    'FontUnits','pixels');
grid_symmetrization=uiextras.Grid('Parent',panel_symmetrization,...
    'ColumnSizes',[-1 -1 -1 -1],...
    'RowSizes',[20 20 20 20],...
    'Padding',2);
st_xm=uicontrol('Parent',grid_symmetrization,...
    'Style','text',...
    'String','xm');
st_ym=uicontrol('Parent',grid_symmetrization,...
    'Style','text',...
    'String','ym');
st_azi=uicontrol('Parent',grid_symmetrization,...
    'Style','text',...
    'String','azi [deg]');
st_v=uicontrol('Parent',grid_symmetrization,...
    'Style','text',...
    'String','v');
handles.ed_xm=uicontrol('Parent',grid_symmetrization,...
    'Style','edit',...
    'String','0',...
    'BackgroundColor','white');
handles.ed_ym=uicontrol('Parent',grid_symmetrization,...
    'Style','edit',...
    'String','0',...
    'BackgroundColor','white');
handles.ed_azi=uicontrol('Parent',grid_symmetrization,...
    'Style','edit',...
    'String','90',...
    'BackgroundColor','white');
handles.ed_v=uicontrol('Parent',grid_symmetrization,...
    'Style','edit',...
    'String','[0,0]',...
    'BackgroundColor','white');
handles.cb_mirror_x_copy=uicontrol('Parent',grid_symmetrization,...
    'Style','checkbox',...
    'String','copy',...
    'Value',1);
handles.cb_mirror_y_copy=uicontrol('Parent',grid_symmetrization,...
    'Style','checkbox',...
    'String','copy',...
    'Value',1);
handles.cb_rotate_copy=uicontrol('Parent',grid_symmetrization,...
    'Style','checkbox',...
    'String','copy',...
    'Value',1);
handles.cb_translate_copy=uicontrol('Parent',grid_symmetrization,...
    'Style','checkbox',...
    'String','copy',...
    'Value',1);
handles.pb_mirror_x=uicontrol('Parent',grid_symmetrization,...
    'Style','pushbutton',...
    'String','mirror-x',...
    'Callback','CalDataViewer(''zzz_transform_Callback(handles,''''mx'''')'')');
handles.pb_mirror_y=uicontrol('Parent',grid_symmetrization,...
    'Style','pushbutton',...
    'String','mirror-y',...
    'Callback','CalDataViewer(''zzz_transform_Callback(handles,''''my'''')'')');
handles.pb_rotate=uicontrol('Parent',grid_symmetrization,...
    'Style','pushbutton',...
    'String','rotate',...
    'Callback','CalDataViewer(''zzz_transform_Callback(handles,''''R'''')'')');
handles.pb_translate=uicontrol('Parent',grid_symmetrization,...
    'Style','pushbutton',...
    'String','translate',...
    'Callback','CalDataViewer(''zzz_transform_Callback(handles,''''Tv'''')'')');

%Rescale
panel_rescale=uiextras.Panel('Parent',vbox_transform,...
    'BorderType','etchedout',...
    'Title','Rescale',...
    'FontUnits','pixels');
grid_rescale=uiextras.Grid('Parent',panel_rescale,...
    'ColumnSizes',[-1 -1 -1],...
    'RowSizes',[20 20],...
    'Padding',2);
st_rescale_x=uicontrol('Parent',grid_rescale,...
    'Style','text',...
    'String',['x ' char(215)]);
st_rescale_y=uicontrol('Parent',grid_rescale,...
    'Style','text',...
    'String',['y ' char(215)]);
handles.ed_rescale_x=uicontrol('Parent',grid_rescale,...
    'Style','edit',...
    'String','1',...
    'BackgroundColor','white');
handles.ed_rescale_y=uicontrol('Parent',grid_rescale,...
    'Style','edit',...
    'String','1',...
    'BackgroundColor','white');
handles.pb_rescale_x=uicontrol('Parent',grid_rescale,...
    'Style','pushbutton',...
    'String','rescale-x',...
    'Callback','CalDataViewer(''zzz_transform_Callback(handles,''''ax'''')'')');
handles.pb_rescale_y=uicontrol('Parent',grid_rescale,...
    'Style','pushbutton',...
    'String','rescale-y',...
    'Callback','CalDataViewer(''zzz_transform_Callback(handles,''''ay'''')'')');

set(vbox_transform,'Sizes',[95, 55],'Spacing',2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Panel Drawing Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbox_drawing_parameters=uiextras.VBox('Parent',panel_drawing_parameters);
grid_drawing_parameters=uiextras.Grid('Parent',vbox_drawing_parameters,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',repmat(20,[1 10]),...
    'Padding',2);
st_nextplot=uicontrol('Parent',grid_drawing_parameters,...
    'Style','text',...
    'String','NextPlot');
st_psize=uicontrol('Parent',grid_drawing_parameters,...
    'Style','text',...
    'String','psize');
st_divisor=uicontrol('Parent',grid_drawing_parameters,...
    'Style','text',...
    'String','divisor');
st_xmin=uicontrol('Parent',grid_drawing_parameters,...
    'Style','text',...
    'String','xmin');
st_xmax=uicontrol('Parent',grid_drawing_parameters,...
    'Style','text',...
    'String','xmax');
st_ymin=uicontrol('Parent',grid_drawing_parameters,...
    'Style','text',...
    'String','ymin');
st_ymax=uicontrol('Parent',grid_drawing_parameters,...
    'Style','text',...
    'String','ymax');
st_bgcolor=uicontrol('Parent',grid_drawing_parameters,...
    'Style','text',...
    'String','bgcolor');
handles.cb_title_on=uicontrol('Parent',grid_drawing_parameters,...
    'Style','checkbox',...
    'String','title on',...
    'Value',1);
handles.cb_axis_equal=uicontrol('Parent',grid_drawing_parameters,...
    'Style','checkbox',...
    'String','axis equal',...
    'Value',1);

handles.popup_nextplot=uicontrol('Parent',grid_drawing_parameters,...
    'Style','popupmenu',...
    'String',{'new','add','replace'},...
    'BackgroundColor','white');
handles.ed_psize=uicontrol('Parent',grid_drawing_parameters,...
    'Style','edit',...
    'String','3',...
    'BackgroundColor','white');
handles.ed_divisor=uicontrol('Parent',grid_drawing_parameters,...
    'Style','edit',...
    'String','1',...
    'BackgroundColor','white');
handles.ed_xmin=uicontrol('Parent',grid_drawing_parameters,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_xmax=uicontrol('Parent',grid_drawing_parameters,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_ymin=uicontrol('Parent',grid_drawing_parameters,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_ymax=uicontrol('Parent',grid_drawing_parameters,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_bgcolor=uicontrol('Parent',grid_drawing_parameters,...
    'Style','edit',...
    'TooltipString','ColorSpec: none / w / k / r / g / b /y /c',...
    'String','w',...
    'BackgroundColor','white');
handles.cb_axis_on=uicontrol('Parent',grid_drawing_parameters,...
    'Style','checkbox',...
    'String','axis on',...
    'Value',1);

%panel_type_patch
panel_type_patch=uiextras.Panel('Parent',vbox_drawing_parameters,...
    'Title','Type: patch',...
    'BorderType','etchedout',...
    'ForegroundColor',[0 0.5 0]);
grid_type_patch=uiextras.Grid('Parent',panel_type_patch,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',repmat(20,[1 5]),...
    'Padding',2);
st_cmin=uicontrol('Parent',grid_type_patch,...
    'Style','text',...
    'String','cmin');
st_cmax=uicontrol('Parent',grid_type_patch,...
    'Style','text',...
    'String','cmax');
st_cmap_dark=uicontrol('Parent',grid_type_patch,...
    'Style','text',...
    'String','cmap_dark');
st_cmap_bright=uicontrol('Parent',grid_type_patch,...
    'Style','text',...
    'String','cmap_bright');
handles.cb_reverse_overlap=uicontrol('Parent',grid_type_patch,...
    'Style','checkbox',...
    'String','rev-overlap',...
    'Value',0);

handles.ed_cmin=uicontrol('Parent',grid_type_patch,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_cmax=uicontrol('Parent',grid_type_patch,...
    'Style','edit',...
    'String','auto',...
    'BackgroundColor','white');
handles.ed_cmap_dark=uicontrol('Parent',grid_type_patch,...
    'Style','edit',...
    'TooltipString','ColorSpec: w / k / r / g / b',...
    'String','w',...
    'BackgroundColor','white');
handles.ed_cmap_bright=uicontrol('Parent',grid_type_patch,...
    'Style','edit',...
    'TooltipString','ColorSpec: w / k / r / g / b',...
    'String','r',...
    'BackgroundColor','white');
handles.cb_colorbar=uicontrol('Parent',grid_type_patch,...
    'Style','checkbox',...
    'String','colorbar',...
    'Value',0);

%panel_type_line
panel_type_line=uiextras.Panel('Parent',vbox_drawing_parameters,...
    'Title','Type: line',...
    'ForegroundColor',[0 0.5 0],...
    'BorderType','etchedout');
grid_type_line=uiextras.Grid('Parent',panel_type_line,...
    'ColumnSizes',[-1 -1],...
    'RowSizes',repmat(20,[1 3]),...
    'Padding',2);
st_linespec=uicontrol('Parent',grid_type_line,...
    'Style','text',...
    'String','LineSpec');
st_pcolor=uicontrol('Parent',grid_type_line,...
    'Style','text',...
    'String','pcolor');
st_facecolor=uicontrol('Parent',grid_type_line,...
    'Style','text',...
    'String','facecolor');
handles.ed_linespec=uicontrol('Parent',grid_type_line,...
    'Style','edit',...
    'String','o',...
    'BackgroundColor','white');
handles.ed_pcolor=uicontrol('Parent',grid_type_line,...
    'Style','edit',...
    'String','r',...
    'BackgroundColor','white');
handles.ed_facecolor=uicontrol('Parent',grid_type_line,...
    'Style','edit',...
    'String','pcolor',...
    'BackgroundColor','white');
set(vbox_drawing_parameters,'Sizes',[200 115 75],'Spacing',5);

%% Updata handles
guidata(handles.fig_CalDataViewer,handles);

%% Set Appdata
fig_ARPESdataList=findall(0,'Tag','fig_ARPESdataList');
if length(fig_ARPESdataList)==1
    setappdata(handles.fig_CalDataViewer,'ListMode','shared');
else
    setappdata(handles.fig_CalDataViewer,'ListMode','local');
end

if ~isappdata(0,'VarSel')
    setappdata(0,'VarSel',{});
end

%% refresh GUI
ListMode=getappdata(handles.fig_CalDataViewer,'ListMode');
switch ListMode
    case 'local'
        menu_local_varlist_Callback(handles.menu_local_varlist,[]);
    case 'shared'
        menu_shared_varlist_Callback(handles.menu_shared_varlist,[]);
end
popup_resample3D_type_Callback(handles.popup_resample3D_type,[]);

%% VarList
function lb_vars_Callback(hObject,eventdata)
handles=guidata(hObject);

list_var=evalin('base','who');
if isempty(list_var)
    newindx_sel=[];
    list_var={};
else
    list_entries=get(handles.lb_vars,'String');
    if isempty(list_entries)
        newindx_sel=1;
    else
        oldindx_sel=get(handles.lb_vars,'Value');
        var_sel=list_entries(oldindx_sel);
        newindx_sel=[];
        for j=1:length(var_sel)
            logic_sel=strcmp(var_sel{j},list_var);
            newindx_sel=[newindx_sel find(logic_sel)];
        end
        if isempty(newindx_sel) %if variables have been deleted from workspace
            newindx_sel=1; %set 1 as default value
        end
    end
end
set(handles.lb_vars,'String',list_var,'Value',newindx_sel);
setappdata(0,'VarSel',list_var(newindx_sel));

popup_bravais_lattice_Callback(handles.popup_bravais_lattice,[]);

%% 3D k-space[k1,k2,k3,E]
function pb_load_bxsf_Callback(hObject,eventdata)
handles=guidata(hObject);
[filename,pathname]=uigetfile('*.bxsf');
if isequal(filename,0)
    return;
end
fullpath=fullfile(pathname,filename);

%bxsf2mat
fid=fopen(fullpath,'r');
for j=1:9
    temp=fgetl(fid);
end
cell_tmp=textscan(temp,'%s%s%f','delimiter',' ','MultipleDelimsAsOne',1);
Ef=cell_tmp{3};
for j=1:6
    temp=fgetl(fid);
end
cell_tmp=textscan(temp,'%d','delimiter',' ','MultipleDelimsAsOne',1);
N_band=cell_tmp{1};
temp=fgetl(fid);
cell_tmp=textscan(temp,'%d%d%d','delimiter',' ','MultipleDelimsAsOne',1);
Nx=cell_tmp{1};
Ny=cell_tmp{2};
Nz=cell_tmp{3};
N=Nx*Ny*Nz;
temp=fgetl(fid);
cell_tmp=textscan(temp,'%f%f%f','delimiter',' ','MultipleDelimsAsOne',1);
G0=cell2mat(cell_tmp);
for j=1:3
    temp=fgetl(fid);
    cell_tmp=textscan(temp,'%f%f%f','delimiter',' ','MultipleDelimsAsOne',1);
    v(j,1:3)=cell2mat(cell_tmp);
end

tic;
for j=1:N_band
    str_status=['Load band ' num2str(j) '/' num2str(N_band) ' ...'];
    set(handles.st_status,'String',str_status,'ForegroundColor',[0 0.8 1]);
    drawnow;
    fgetl(fid);
    M=fscanf(fid,'%f',[1,N]);
    value{j,1}=permute(reshape(M,[Nz Ny Nx]),[3 2 1]);
    E_range(j,1)=min(M(:));
    E_range(j,2)=max(M(:));
    fgetl(fid);
end
fclose(fid);
set(handles.st_status,'String','Idle','ForegroundColor','g');
toc;

Rawdata.E=value;
Rawdata.E_range=E_range;
Rawdata.Ef=Ef;
Rawdata.N_band=N_band;
Rawdata.Nx=Nx;
Rawdata.Ny=Ny;
Rawdata.Nz=Nz;
Rawdata.G0=G0;
Rawdata.v1=v(1,:);
Rawdata.v2=v(2,:);
Rawdata.v3=v(3,:);

[~,varname,~]=fileparts(filename);
assignin('base',varname,Rawdata);

zzz_refresh_varlist_Callback(handles);

%%
function popup_bravais_lattice_Callback(hObject,eventdata)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end
varname=VarSel{1};
Rawdata=evalin('base',varname);

sel_bravais=get(handles.popup_bravais_lattice,'Value');

try
    switch sel_bravais
        case 1
            ka=abs(Rawdata.v1(1));
            kb=abs(Rawdata.v2(2));
            kc=abs(Rawdata.v3(3));
        case 2
            ka=abs(Rawdata.v3(1));
            kb=abs(Rawdata.v3(2));
            kc=abs(Rawdata.v1(3));
        otherwise
            ka=nan;
            kb=nan;
            kc=nan;
    end
catch
    ka=nan;
    kb=nan;
    kc=nan;
end
a=2*pi/ka;
b=2*pi/kb;
c=2*pi/kc;
set(handles.ed_ka,'String',num2str(ka,'%.3f'));
set(handles.ed_kb,'String',num2str(kb,'%.3f'));
set(handles.ed_kc,'String',num2str(kc,'%.3f'));
set(handles.ed_a,'String',num2str(a,'%.3f'));
set(handles.ed_b,'String',num2str(b,'%.3f'));
set(handles.ed_c,'String',num2str(c,'%.3f'));

%%
function popup_resample3D_type_Callback(hObject,eventdata)
handles=guidata(hObject);

str=get(handles.popup_resample3D_type,'String');
val=get(handles.popup_resample3D_type,'Value');
sel_resample3D_type=str{val};
switch sel_resample3D_type
    case 'plane kxy-kz <Nxy(P1,P2),Nz>'
        set(handles.ed_vx,'Enable','off');
        set(handles.ed_vy,'Enable','off');
        set(handles.ed_vz,'Enable','on');
        set(handles.ed_P1,'Enable','on');
        set(handles.ed_P2,'Enable','on');
        set(handles.ed_Np,'Enable','on');
    case 'plane kyz-kx <Nyz(P1,P2),Nx>'
        set(handles.ed_vx,'Enable','on');
        set(handles.ed_vy,'Enable','off');
        set(handles.ed_vz,'Enable','off');
        set(handles.ed_P1,'Enable','on');
        set(handles.ed_P2,'Enable','on');
        set(handles.ed_Np,'Enable','on');
    case 'plane kxz-ky <Nxz(P1,P2),Ny>'
        set(handles.ed_vx,'Enable','off');
        set(handles.ed_vy,'Enable','on');
        set(handles.ed_vz,'Enable','off');
        set(handles.ed_P1,'Enable','on');
        set(handles.ed_P2,'Enable','on');
        set(handles.ed_Np,'Enable','on');
    otherwise
        set(handles.ed_vx,'Enable','on');
        set(handles.ed_vy,'Enable','on');
        set(handles.ed_vz,'Enable','on');
        set(handles.ed_P1,'Enable','off');
        set(handles.ed_P2,'Enable','off');
        set(handles.ed_Np,'Enable','off');
end

%%
function pb_Resample3D_Callback(hObject,eventdata)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end
popup_bravais_lattice_Callback(handles.popup_bravais_lattice,[]);

varname=VarSel{1};
Rawdata=evalin('base',varname);
val=get(handles.popup_resample3D_type,'Value');
str=get(handles.popup_resample3D_type,'String');
sel_resample3D_type=str{val};

%build resample mesh
switch sel_resample3D_type
    case 'plane kxy-kz <Nxy(P1,P2),Nz>'
        P1=str2num(get(handles.ed_P1,'String'));
        P2=str2num(get(handles.ed_P2,'String'));
        Np=str2double(get(handles.ed_Np,'String'));
        vx=linspace(P1(1),P2(1),Np);
        vy=linspace(P1(2),P2(2),Np);
        vz=str2num(get(handles.ed_vz,'String'));
        if isempty(vz)
            vz=linspace(-0.5,0.5,Rawdata.Nz);
        end
        Nz=length(vz);
        [X,Z]=ndgrid(vx,vz);
        [Y,Z]=ndgrid(vy,vz);
    case 'plane kyz-kx <Nyz(P1,P2),Nx>'
        P1=str2num(get(handles.ed_P1,'String'));
        P2=str2num(get(handles.ed_P2,'String'));
        Np=str2double(get(handles.ed_Np,'String'));
        vy=linspace(P1(1),P2(1),Np);
        vz=linspace(P1(2),P2(2),Np);
        vx=str2num(get(handles.ed_vx,'String'));
        if isempty(vx)
            vx=linspace(-0.5,0.5,Rawdata.Nx);
        end
        Nx=length(vx);
        [Y,X]=ndgrid(vy,vx);
        [Z,X]=ndgrid(vz,vx);
    case 'plane kxz-ky <Nxz(P1,P2),Ny>'
        P1=str2num(get(handles.ed_P1,'String'));
        P2=str2num(get(handles.ed_P2,'String'));
        Np=str2double(get(handles.ed_Np,'String'));
        vx=linspace(P1(1),P2(1),Np);
        vz=linspace(P1(2),P2(2),Np);
        vy=str2num(get(handles.ed_vy,'String'));
        if isempty(vy)
            vy=linspace(-0.5,0.5,Rawdata.Ny);
        end
        Ny=length(vy);
        [X,Y]=ndgrid(vx,vy);
        [Z,Y]=ndgrid(vz,vy);
    otherwise
        vx=str2num(get(handles.ed_vx,'String'));
        vy=str2num(get(handles.ed_vy,'String'));
        vz=str2num(get(handles.ed_vz,'String'));
        if isempty(vx)
            vx=linspace(-0.5,0.5,Rawdata.Nx);
        end
        if isempty(vy)
            vy=linspace(-0.5,0.5,Rawdata.Ny);
        end
        if isempty(vz)
            vz=linspace(-0.5,0.5,Rawdata.Nz);
        end
        Nx=length(vx);
        Ny=length(vy);
        Nz=length(vz);
        [X,Y,Z]=ndgrid(vx,vy,vz);
end

%check format
switch sel_resample3D_type
    case 'bulk <Nx,Ny,Nz>'
        if Nx<2 || Ny<2 || Nz<2
            msgbox('Nx>=2, Ny>=2, Nz>=2 are required!','Error','error','replace');
            return;
        end
    case 'plane kx-ky <Nx,Ny,1>'
        if Nz~=1
            msgbox('Nz==1 is required!','Error','error','replace');
            return;
        end
    case 'plane kx-kz <Nx,1,Nz>'
        if Ny~=1
            msgbox('Ny==1 is required!','Error','error','replace');
            return;
        end
    case 'plane ky-kz <1,Ny,Nz>'
        if Nx~=1
            msgbox('Nx==1 is required!','Error','error','replace');
            return;
        end
end

%Convert to Orthogonal Coordinates
str=get(handles.popup_bravais_lattice,'String');
val=get(handles.popup_bravais_lattice,'Value');
sel_bravais=str{val};
switch sel_bravais
    case 'ORT,TET,SC'
        V1=rem(X,1);
        V2=rem(Y,1);
        V3=rem(Z,1);
        V1(V1<0)=V1(V1<0)+1;
        V2(V2<0)=V2(V2<0)+1;
        V3(V3<0)=V3(V3<0)+1;
        P=[V1(:),V2(:),V3(:)];
    case 'BCO,BCT,BCC'
        V1=rem((-X+Y-Z)/2,1);
        V2=rem((+X-Y-Z)/2,1);
        V3=rem((-X-Y+Z)/2,1);
        V1(V1<0)=V1(V1<0)+1;
        V2(V2<0)=V2(V2<0)+1;
        V3(V3<0)=V3(V3<0)+1;
        P=[V1(:),V2(:),V3(:)];
    case 'FCO,FCC [Not coded]'
        return;
    case 'HEX [Not coded]'
        return;
    otherwise
        return;
end

%Main
v1=linspace(0,1,Rawdata.Nx);
v2=linspace(0,1,Rawdata.Ny);
v3=linspace(0,1,Rawdata.Nz);
N_band=length(Rawdata.E);
tic;
for j=1:N_band
    str_status=['Resample3D band ' num2str(j) '/' num2str(N_band) ' ...'];
    set(handles.st_status,'String',str_status,'ForegroundColor','g');
    drawnow;
    F=griddedInterpolant({v1,v2,v3},Rawdata.E{j});
    switch sel_resample3D_type
        case 'plane kxy-kz <Nxy(P1,P2),Nz>'
            newdata.E{j,1}=reshape(F(P),[Np Nz]);
        case 'plane kyz-kx <Nyz(P1,P2),Nx>'
            newdata.E{j,1}=reshape(F(P),[Np Nx]);
        case 'plane kxz-ky <Nxz(P1,P2),Ny>'
            newdata.E{j,1}=reshape(F(P),[Np Ny]);
        otherwise
            newdata.E{j,1}=reshape(F(P),[Nx Ny Nz]);
    end
end
set(handles.st_status,'String','Idle','ForegroundColor','g');
toc;

%info
newdata.E_range=Rawdata.E_range;
newdata.Ef=Rawdata.Ef;
switch sel_resample3D_type
    case 'plane kxy-kz <Nxy(P1,P2),Nz>'
        newdata.P1=P1;
        newdata.P2=P2;
        newdata.Np=Np;
        newdata.vz=vz;
    case 'plane kyz-kx <Nyz(P1,P2),Nx>'
        newdata.P1=P1;
        newdata.P2=P2;
        newdata.Np=Np;
        newdata.vx=vx;
    case 'plane kxz-ky <Nxz(P1,P2),Ny>'
        newdata.P1=P1;
        newdata.P2=P2;
        newdata.Np=Np;
        newdata.vy=vy;
    otherwise
        newdata.vx=vx;
        newdata.vy=vy;
        newdata.vz=vz;
end

%suffix
switch sel_resample3D_type
    case 'bulk <Nx,Ny,Nz>'
        newdata.Type='bulk';
        newvarname=[varname '_Nx' num2str(Nx) 'Ny' num2str(Ny) 'Nz' num2str(Nz)];
    case 'plane kx-ky <Nx,Ny,1>'
        newdata.Type='kx-ky';
        if vz==0
            str_kz='0';
        else
            str_kz=num2str(vz,'%.2f');
            str_kz(str_kz=='.')='p';
        end
        newvarname=[varname '_Nx' num2str(Nx) 'Ny' num2str(Ny) '_kz' str_kz];
    case 'plane kx-kz <Nx,1,Nz>'
        newdata.Type='kx-kz';
        if vy==0
            str_ky='0';
        else
            str_ky=num2str(vy,'%.2f');
            str_ky(str_ky=='.')='p';
        end
        newvarname=[varname '_Nx' num2str(Nx) 'Nz' num2str(Nz) '_ky' str_ky];
    case 'plane ky-kz <1,Ny,Nz>'
        newdata.Type='ky-kz';
        if vx==0
            str_kx='0';
        else
            str_kx=num2str(vx,'%.2f');
            str_kx(str_kx=='.')='p';
        end
        newvarname=[varname '_Ny' num2str(Ny) 'Nz' num2str(Nz) '_kx' str_kx];
    case 'plane kxy-kz <Nxy(P1,P2),Nz>'
        newdata.Type='kxy-kz';
        newvarname=[varname '_Nxy' num2str(Np) 'Nz' num2str(Nz)];
    case 'plane kyz-kx <Nyz(P1,P2),Nx>'
        newdata.Type='kyz-kx';
        newvarname=[varname '_Nyz' num2str(Np) 'Nx' num2str(Nx)];
    case 'plane kxz-ky <Nxz(P1,P2),Ny>'
        newdata.Type='kxz-ky';
        newvarname=[varname '_Nxz' num2str(Np) 'Ny' num2str(Ny)];
end

assignin('base',newvarname,newdata);

zzz_refresh_varlist_Callback(handles);

%%
function pb_arbitrary_cut_Callback(hObject, eventdata)
handles=guidata(hObject);
popup_bravais_lattice_Callback(handles.popup_bravais_lattice,[]);

str=get(handles.popup_miller_index_type,'String');
val=get(handles.popup_miller_index_type,'Value');
miller_type=str{val};
miller=str2num(get(handles.ed_miller_index,'String'));
h1=miller(1);
h2=miller(2);
h3=miller(3);
a=str2double(get(handles.ed_new_a,'String'));
b=str2double(get(handles.ed_new_b,'String'));
c=str2double(get(handles.ed_new_c,'String'));
if isnan(a)
    a=str2double(get(handles.ed_a,'String'));
end
if isnan(b)
    b=str2double(get(handles.ed_b,'String'));
end
if isnan(c)
    c=str2double(get(handles.ed_c,'String'));
end
ka=2*pi/a;
kb=2*pi/b;
kc=2*pi/c;

str=get(handles.popup_bravais_lattice,'String');
val=get(handles.popup_bravais_lattice,'Value');
sel_bravais=str{val};

switch sel_bravais
    case 'BCO,BCT,BCC'
        switch miller_type
            case 'Miller[PC]'
                a1=[-a/2,b/2,c/2];
                a2=[a/2,-b/2,c/2];
                a3=[a/2,b/2,-c/2];
                b1=[0,kb,kc];
                b2=[ka,0,kc];
                b3=[ka,kb,0];
            case 'Miller[UC]'
                a1=[a,0,0];
                a2=[0,b,0];
                a3=[0,0,c];
                b1=[ka,0,0];
                b2=[0,kb,0];
                b3=[0,0,kc];
        end
        
        G=h1*b1+h2*b2+h3*b3;
        g=G/norm(G);
        Lkz=2*pi/norm(G);
        n1=a2/h2-a1/h1;
        n2=a3/h3-a1/h1;
        u1=n1/norm(n1);
        u2=cross(g,u1);
        u2=u2/norm(u2);
        
        Lkx=str2double(get(handles.ed_Lkx,'String'));
        Lky=str2double(get(handles.ed_Lky,'String'));
        set(handles.ed_Lkz,'String',num2str(Lkz,'%.3f'));
        az0=str2double(get(handles.ed_az0,'String'));
        kz0=Lkz*az0;
        vz0=kz0*g;
        Nx=str2double(get(handles.ed_acut_Nx,'String'));
        Ny=str2double(get(handles.ed_acut_Ny,'String'));

        w=NaN((Nx+1)*(Ny+1),3);
        for j=0:Ny
            for i=0:Nx
                w(j*(Nx+1)+i+1,:)=u1*Lkx/Nx*i+u2*Lky/Ny*j+vz0;               
            end
        end
        X=w(:,1)/ka;
        Y=w(:,2)/kb;
        Z=w(:,3)/kc;
        V1=rem(-(-X+Y-Z)/2,1);
        V2=rem(-(+X-Y-Z)/2,1);
        V3=rem(-(-X-Y+Z)/2,1);
        V1(V1<0)=V1(V1<0)+1;
        V2(V2<0)=V2(V2<0)+1;
        V3(V3<0)=V3(V3<0)+1;
        P=[V1(:),V2(:),V3(:)];
        
        VarSel=getappdata(0,'VarSel');
        varname=VarSel{1};
        Rawdata=evalin('base',varname);
        
        v1=linspace(0,1,Rawdata.Nx);
        v2=linspace(0,1,Rawdata.Ny);
        v3=linspace(0,1,Rawdata.Nz);
        N_band=length(Rawdata.E);
        tic;
        for j=1:N_band
            str_status=['Abitrary Cut band ' num2str(j) '/' num2str(N_band) ' ...'];
            set(handles.st_status,'String',str_status,'ForegroundColor','g');
            drawnow;
            F=griddedInterpolant({v1,v2,v3},Rawdata.E{j});
            newdata.E{j,1}=reshape(F(P),[Nx+1 Ny+1]);
        end
        set(handles.st_status,'String','Idle','ForegroundColor','g');
        toc;
        
        %info
        newdata.E_range=Rawdata.E_range;
        newdata.Ef=Rawdata.Ef;
        newdata.vx=[0:Lkx/Nx:Lkx];
        newdata.vy=[0:Lky/Ny:Lky];
        newdata.vz=vz0;
        newdata.Type='acut';
        switch miller_type
            case 'Miller[PC]'
                newvarname=[varname '_millerPC'];
            case 'Miller[UC]'
                newvarname=[varname '_millerUC'];
        end
        newvarname=[newvarname num2str(h1) num2str(h2) num2str(h3)];
        str_kz=num2str(kz0,'%.2f');
        str_kz(str_kz=='.')='p';
        newvarname=[newvarname '_kz' str_kz];
        newvarname=[newvarname '_' num2str(Nx+1) 'x' num2str(Ny+1)];
    otherwise
        return;
end
assignin('base',newvarname,newdata);
zzz_refresh_varlist_Callback(handles);

%% 2D k-space[k1,k2,E,I]
function pb_load_folder_Callback(hObject, eventdata)
% eventdata  reserved - to be defined in a future version of MATLAB
handles=guidata(hObject);

tic;
dir_name=uigetdir(cd,'Selection Folder for Rawdata');
if isequal(dir_name,0)
    return;
end

fileinfo=dir(dir_name);
for j=1:length(fileinfo)
    if fileinfo(j).isdir
        continue;
    end
    filename=fileinfo(j).name;
    str_status=['Load ' filename ' ...'];
    set(handles.st_status,'String',str_status,'ForegroundColor',[0 0.8 1]);
    drawnow;
    try
        evalin('base',['load(''' fullfile(dir_name,filename) ''')']);
    catch
        disp(['Fail! ' filename]);
    end
end
set(handles.st_status,'String','Idle','ForegroundColor','g');
toc;

zzz_refresh_varlist_Callback(handles);

%%
function pb_packbands_Callback(hObject, eventdata)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end

tic;
str_status=['Packing Selected Bands ...'];
set(handles.st_status,'String',str_status,'ForegroundColor','g');
drawnow;
N_band=length(VarSel);
for j=1:N_band
    varname=VarSel{j};
    rawdata=evalin('base',varname);
    evalin('base',['clear ' varname]);
    
    if j==1
        data.vx=unique(rawdata(:,1));
        data.vy=unique(rawdata(:,2));
        data.vz=NaN;
        Nx(j)=length(data.vx);
        Ny(j)=length(data.vy);
        N=size(rawdata,1);
        if N~=Nx*Ny
            msgbox('Not grided rawdata!','Error','error','replace');
            return;
        end
    else
        if ~isequal(data.vx,unique(rawdata(:,1)))
            msgbox('different vx!','Error','error','replace');
            return;
        end
        if ~isequal(data.vy,unique(rawdata(:,2)))
            msgbox('different vy!','Error','error','replace');
            return;
        end
    end
    data.E{j,1}=permute(reshape(rawdata(:,3),[Ny Nx]),[2 1]);
    data.I{j,1}=permute(reshape(rawdata(:,4),[Ny Nx]),[2 1]);
    E_range(j,1)=min(rawdata(:,3));
    E_range(j,2)=max(rawdata(:,3));
    I_range(j,1)=min(rawdata(:,4));
    I_range(j,2)=max(rawdata(:,4));
end
data.E_range=E_range;
data.I_range=I_range;
data.Type='surface';
prefix=get(handles.ed_packbands_prefix,'String');
if isvarname(prefix)
    newvarname=[prefix '_oc' num2str(Nx) 'x' num2str(Ny)];
else
    newvarname=['oc' num2str(Nx) 'x' num2str(Ny)];
end

assignin('base',newvarname,data);
set(handles.ed_packbands_prefix,'String','');
set(handles.st_status,'String','Idle','ForegroundColor','g');
toc;

zzz_refresh_varlist_Callback(handles);

%%
function pb_resample2D_Callback(hObject, eventdata, handles)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end

varname=VarSel{1};
data=evalin('base',varname);
data_re.vx=data.vx;
data_re.vy=data.vy;
data_re.vz=NaN;
data_re.E=[];
data_re.E_range=data.E_range;
data_re.I=[];
data_re.I_range=data.I_range;
data_re.Type='surface';
[VX,VY]=ndgrid(data.vx,data.vy);
X=VX(:);
Y=VY(:);
N_band=length(data.E);
E=cell(N_band,1);
I=cell(N_band,1);
for k=1:N_band
    E{k,1}=data.E{k}(:);
    I{k,1}=data.I{k}(:);
end

N_var=length(VarSel);
for j=2:N_var
    varname=VarSel{j};
    data=evalin('base',varname);
    data_re.vx=[data_re.vx;data.vx];
    data_re.vy=[data_re.vy;data.vy];
    [VX,VY]=ndgrid(data.vx,data.vy);
    X=[X;VX(:)];
    Y=[Y;VY(:)];
    N_band=length(data.E);
    if ~isequal(N_band,length(data.E))
        msgbox('Different bands numbers!','Error','error','replace');
        return;
    end
    for k=1:N_band
        E{k,1}=[E{k,1};data.E{k}(:)];
        I{k,1}=[I{k,1};data.I{k}(:)];
    end
end
Nx=str2double(get(handles.ed_resample2D_Nx,'String'));
Ny=str2double(get(handles.ed_resample2D_Ny,'String'));
if isnan(Nx)
    data_re.vx=unique(data_re.vx);
    Nx=length(data_re.vx);
else
    data_re.vx=linspace(min(data_re.vx),max(data_re.vx),Nx);
end
if isnan(Ny)
    data_re.vy=unique(data_re.vy);
    Ny=length(data_re.vy);
else
    data_re.vy=linspace(min(data_re.vy),max(data_re.vy),Ny);
end
[VX,VY]=ndgrid(data_re.vx,data_re.vy);

tic;
for k=1:N_band
    str_status=['Resample2D band ' num2str(k) '/' num2str(N_band) ' ...'];
    set(handles.st_status,'String',str_status,'ForegroundColor','r');
    drawnow;
    F_E=scatteredInterpolant(X,Y,E{k});
    data_re.E{k,1}=F_E(VX,VY);
    F_I=scatteredInterpolant(X,Y,I{k});
    data_re.I{k,1}=F_I(VX,VY);
end
set(handles.st_status,'String','Idle','ForegroundColor','g');
toc;

prefix=get(handles.ed_resample2D_prefix,'String');
if isvarname(prefix)
    newvarname=[prefix '_oc' num2str(Nx) 'x' num2str(Ny)];
else
    newvarname=['oc' num2str(Nx) 'x' num2str(Ny)];
end
assignin('base',newvarname,data_re);
set(handles.ed_resample2D_prefix,'String','');
zzz_refresh_varlist_Callback(handles);

%% 3D k-space View
function ed_Ebind_Callback(hObject,eventdata)
handles=guidata(hObject);
pb_isosurf_Callback(handles.pb_isosurf,[]);

%%
function ed_Ebind_KeyPressFcn(hObject, eventdata)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
switch eventdata.Key
    case 'uparrow'
        a=1;
    case 'downarrow'
        a=-1;
    otherwise
        return;
end
handles=guidata(hObject);
Ebind=str2double(get(handles.ed_Ebind,'String'));
step=str2double(get(handles.ed_Ebind_step,'String'));
Ebind=Ebind+a*step;
set(handles.ed_Ebind,'String',num2str(Ebind,'%.3f'));
ed_Ebind_Callback(handles.ed_Ebind,[]);

%%
function pb_isosurf_Callback(hObject,eventdata)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end
varname=VarSel{1};

data=evalin('base',varname);
if ~strcmp(data.Type,'bulk')
    return;
end

Ebind=str2double(get(handles.ed_Ebind,'String'));
x=data.vx;
y=data.vy;
z=data.vz;
[X,Y,Z]=meshgrid(y,x,z); 

if get(handles.cb_isosurf_newfig,'Value')==1
    figure('Tag','plot_CalDataViewer');
    box on;
    view(3);
    colormap(jet);
    light('Position',[0,0,1]);
else
    if get(handles.cb_isosurf_replace,'Value')==1
        delete(findobj(gca,'Type','patch'));
    end
end
suffix=['_E' num2str(Ebind,'%.2f')];
suffix(suffix=='.')='p';
set(gcf,'Name',[varname suffix]);

tic;
N_band=length(data.E);
band_No=str2num(get(handles.ed_band_No,'String'));
if isempty(band_No)
    band_No=1:N_band;
end
for j=band_No
    str_status=['isosurf band ' num2str(j) '/' num2str(N_band) ' ...'];
    set(handles.st_status,'String',str_status,'ForegroundColor','g');
    drawnow;
    hold on;
    disp(' ');
    disp(['Band ' num2str(j) '/' num2str(N_band) ':']);
    M=data.E{j};
    if Ebind<data.E_range(j,1)
        disp('Ebinding lower than of energy range!')
        continue;
    end  
    if Ebind>data.E_range(j,2)
        disp('Ebinding higher than of energy range!')
        continue;
    end
    isosurface(X,Y,Z,M,Ebind,'verbose'); %patch
end
set(handles.st_status,'String','Idle','ForegroundColor','g');
toc;

lighting gouraud;
material dull;
str_title=['E=',num2str(Ebind,'%.3f')];
title(str_title,'FontSize',15);
xlabel('ky','FontSize',12);
ylabel('kx','FontSize',12);
zlabel('kz','FontSize',12);
axis equal;
uicontrol(handles.ed_Ebind);

%% 2D k-space View
function pb_generate_Econtour_Callback(hObject, eventdata)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end
varname=VarSel{1};
olddata=evalin('base',varname);

Emin=str2num(get(handles.ed_Emin,'String'));
Emax=str2num(get(handles.ed_Emax,'String'));
Estep=str2num(get(handles.ed_Estep,'String'));
v_E=[Emin:Estep:Emax]';
N_E=length(v_E);
data_contour.v_E=v_E;
data_contour.C=cell(N_E,1);

switch olddata.Type
    case 'ky-kz'
        x=olddata.vy;
        y=olddata.vz;
    case 'kx-kz'
        x=olddata.vx;
        y=olddata.vz;
    case {'kx-ky','surface','acut'}
        x=olddata.vx;
        y=olddata.vy;
    case 'kxy-kz'
        Nx=olddata.Np;
        x=linspace(0,1,Nx);
        y=olddata.vz;
    case 'kyz-kx'
        Nx=olddata.Np;
        x=linspace(0,1,Nx);
        y=olddata.vx;
    case 'kxz-ky'
        Nx=olddata.Np;
        x=linspace(0,1,Nx);
        y=olddata.vy;
    otherwise
        msgbox('Wrong data type!','Error','error','replace');
        return;
end
[X,Y]=ndgrid(x,y);

IsGenerate_map=get(handles.cb_generate_map,'Value');
if IsGenerate_map
    data_map.x=x;
    data_map.y=y;
    data_map.z=v_E;
    Nx=length(x);
    Ny=length(y);
    data_map.value=zeros(Nx,Ny,N_E);
    xstep=(x(end)-x(1))/(Nx-1);
    ystep=(y(end)-y(1))/(Ny-1);
end

h_fig=figure;
tic;
N_band=length(olddata.E);
vE_max=max(v_E);
vE_min=min(v_E);
for j=1:N_band
    str_status=['Generate Econtour band ' num2str(j) '/' num2str(N_band) ' ...'];
    set(handles.st_status,'String',str_status,'ForegroundColor','g');
    drawnow;
    if vE_max<olddata.E_range(j,1);
        continue;
    end
    if vE_min>olddata.E_range(j,2);
        continue;
    end
    hold off;
    if isscalar(v_E)
        [C,~]=contour(X,Y,squeeze(olddata.E{j}),[v_E v_E]);
    else
        [C,~]=contour(X,Y,squeeze(olddata.E{j}),v_E);
    end
    title(['Econtour of band ' num2str(j) '/' num2str(N_band)]);
    if isempty(C)
        continue;
    end
    
    col=1;
    xx=[];
    yy=[];
    if isfield(olddata,'I')
        F_I=griddedInterpolant({x,y},olddata.I{j});
    end
    while col<size(C,2);
        Ec=C(1,col);         % contour level
        N_pts=C(2,col);      % number of points of the contour line
        indx=[col+1:col+N_pts];
        xx=C(1,indx);
        yy=C(2,indx);
        nE=find(v_E==Ec);
        M=data_contour.C{nE};
        if isfield(olddata,'I')
            II=F_I(xx,yy);
            dM=[xx' yy' II'];
        else
            II=ones(size(xx));
            dM=[xx' yy'];
        end
        data_contour.C{nE}=[M;dM];
        
        if IsGenerate_map
            nxx=round((xx-x(1))/xstep)+1;
            nyy=round((yy-y(1))/ystep)+1;
            for k=1:length(nxx)
                data_map.value(nxx(k),nyy(k),nE)=data_map.value(nxx(k),nyy(k),nE)+II(k);
            end
        end
        
        col=col+N_pts+1;
    end
end
close(h_fig);
toc;
set(handles.st_status,'String','Idle','ForegroundColor','g');

suffix=['_E' num2str(vE_min,'%.1f') '_' num2str(vE_max,'%.1f')];
suffix(suffix=='.')='p';
assignin('base',[varname suffix '_contour'],data_contour);
if IsGenerate_map
%     data_map(data_map>1)=1;
    assignin('base',[varname suffix '_map'],data_map);
end

zzz_refresh_varlist_Callback(handles);

%%
function pb_combine_Econtour_Callback(hObject, eventdata)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
N_var=length(VarSel);
if N_var<2
    msgbox('Pls select N>2 Econtours with same V_E!','Error','error','replace');
    return;
end

str_status='Combine Econtours ...';
set(handles.st_status,'String',str_status,'ForegroundColor','g');
drawnow;

varname=VarSel{1};
data_cb=evalin('base',varname);
v_E=data_cb.v_E;
N_E=length(v_E);

for j=2:N_var
    varname=VarSel{j};
    data=evalin('base',varname);
    if ~isequal(v_E,data.v_E)
        msgbox('All Econtours must have same v_E!','Error','error','replace');
        return;
    end
    for k=1:N_E
        data_cb.C{k}=[data_cb.C{k};data.C{k}];
    end
end

for k=1:N_E
    data_cb.C{k}=unique(data_cb.C{k},'rows');
end

assignin('base','cbEcontours',data_cb);
set(handles.st_status,'String','Idle','ForegroundColor','g');

zzz_refresh_varlist_Callback(handles);

%%
function pb_plot_Econtours_Callback(hObject, eventdata)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end

str_status='Plot Econtours ...';
set(handles.st_status,'String',str_status,'ForegroundColor','g');
drawnow;

varname=VarSel{1};
data=evalin('base',varname);

v_E=str2num(get(handles.ed_vE,'String'));
if isempty(v_E)
    v_E=data.v_E;
end
N_E=length(v_E);
IsSeperateFig=get(handles.cb_seperate_figs,'Value');
rows=str2double(get(handles.ed_rows,'String'));
cols=str2double(get(handles.ed_cols,'String'));
if ~IsSeperateFig
    if N_E>rows*cols
        msgbox(['Number of figures N=',num2str(N_E),' > rows*cols !'],...
            'Error','error','replace');
        return;
    end
    figure('Tag','plot_CalDataViewer',...
        'Name',[varname ' E=',num2str(v_E(1)),' to ',num2str(v_E(end)),' eV']);
elseif N_E>rows*cols
    sel=questdlg(['Plot all figures(N=' num2str(N_E) ')?'],...
        'Confirmation','OK','Cancel','OK');
    if strcmp(sel,'Cancel')
        return;
    end
end

for j=1:N_E
    str_title=['E= ' num2str(v_E(j)) ' eV'];
    if IsSeperateFig
        figure('Tag','plot_CalDataViewer','Name',[varname ' ' str_title]);
    else
        subplot(rows,cols,j)
    end
    
    [delta,indx]=min(abs(data.v_E-v_E(j)));
    if delta>1e-3
        continue;
    end
    M=data.C{indx};
    if size(M,2)>2
        zzz_draw2D(handles,M,str_title,'scatter');
    else
        zzz_draw2D(handles,M,str_title,'plot');
    end
end
set(handles.st_status,'String','Idle','ForegroundColor','g');

%% 2D ScatteredData
function pb_scatter_points_Callback(hObject, eventdata)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end

str_status=['Scatter Points[xx,yy,II] ...'];
set(handles.st_status,'String',str_status,'ForegroundColor','g');
drawnow;

str_nextplot=get(handles.popup_nextplot,'String');
val_nextplot=get(handles.popup_nextplot,'Value');
switch str_nextplot{val_nextplot};
    case 'new'
        N_var=length(VarSel);
        for i=1:N_var
            varname=VarSel{i};
            data=evalin('base',varname);
            figure('Tag','plot_CalDataViewer','Name',varname);
            zzz_draw2D(handles,data,varname,'scatter');
        end
    case 'add'
        hold on;
        varname=VarSel{1};
        data=evalin('base',varname);
        zzz_draw2D(handles,data,varname,'scatter');
    case 'replace'
        h_patch=findall(gca,'Type','patch','Tag','graph_CalDataViewer');
        delete(h_patch);
        hold on;
        varname=VarSel{1};
        data=evalin('base',varname);
        zzz_draw2D(handles,data,varname,'scatter');
end
        
set(handles.st_status,'String','Idle','ForegroundColor','g');

%%
function pb_plot_points_Callback(hObject, eventdata)
handles=guidata(hObject);
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end

str_status=['Scatter Points[xx,yy,II] ...'];
set(handles.st_status,'String',str_status,'ForegroundColor','g');
drawnow;

str_nextplot=get(handles.popup_nextplot,'String');
val_nextplot=get(handles.popup_nextplot,'Value');
switch str_nextplot{val_nextplot};
    case 'new'
        N_var=length(VarSel);
        for i=1:N_var
            varname=VarSel{i};
            data=evalin('base',varname);
            figure('Tag','plot_CalDataViewer','Name',varname);
            zzz_draw2D(handles,data,varname,'plot');
        end
    case 'add'
        hold on;
        varname=VarSel{1};
        data=evalin('base',varname);
        zzz_draw2D(handles,data,varname,'plot');
    case 'replace'
        h_patch=findall(gca,'Type','line','Tag','graph_CalDataViewer');
        delete(h_patch);
        hold on;
        varname=VarSel{1};
        data=evalin('base',varname);
        zzz_draw2D(handles,data,varname,'plot');
end
        
set(handles.st_status,'String','Idle','ForegroundColor','g');

%%
function pb_save_patch_points_Callback(hObject, eventdata)
handles=guidata(hObject);

h=findall(gca,'Type','patch','Tag','graph_CalDataViewer');
N=length(h);
if N<1
    msgbox('No patch taged "graph_CalDataViewer"!',...
        'Error','none','replace');
    return;
end

newdata=[];
for j=1:N
    hc=h(j);
    xx=get(hc,'XData');
    yy=get(hc,'YData');
    II=get(hc,'CData');
    M=[xx yy II];
    newdata=[newdata;M];
end
newdata=unique(newdata,'rows');
assignin('base','SavePointsPatch',newdata);

zzz_sync_reverse_Callback(handles);

%%
function pb_save_line_points_Callback(hObject, eventdata)
handles=guidata(hObject);

h=findall(gca,'Type','line','Tag','graph_CalDataViewer');
N=length(h);
if N<1
    msgbox('No line taged "graph_CalDataViewer"!',...
        'Error','none','replace');
    return;
end

newdata=[];
for j=1:N
    hc=h(j);
    xx=get(hc,'XData');
    yy=get(hc,'YData');
    M=[xx' yy'];
    newdata=[newdata;M];
end
newdata=unique(newdata,'rows');
assignin('base','SavePointsLine',newdata);

zzz_sync_reverse_Callback(handles);

%%
function pb_catch_image_points_Callback(hObject, eventdata)
handles=guidata(hObject);

h=findall(gca,'Type','image');
if length(h)~=1
    msgbox('There should be one and only one Image !',...
        'Error','none','replace');
    return;
end

threshold=str2num(get(handles.ed_catch_threshold,'String'));
catch_intensity=get(handles.cb_catch_intensity,'Value');

M=get(h,'CData')';
x=get(h,'XData');
y=get(h,'YData');
[X,Y]=ndgrid(x,y);

xx=X(M>threshold);
yy=Y(M>threshold);
if catch_intensity
    II=M(M>threshold);
    newdata=[xx,yy,II];
    assignin('base','CatchImagePtsII',newdata);
else
    newdata=[xx,yy];
    assignin('base','CatchImagePts',newdata);
end

zzz_sync_reverse_Callback(handles);

%% Menu-Settings
function menu_local_varlist_Callback(hObject,eventdata)
handles=guidata(hObject);

set(handles.menu_local_varlist,'Checked','on');
set(handles.menu_shared_varlist,'Checked','off');
set(handles.hbox_home,'Sizes',[400 -1]);
LimitSizeFig(handles.fig_CalDataViewer,'min', [1000, 875]);
set(handles.fig_CalDataViewer,'Position',[10 125 1000 875]);
setappdata(handles.fig_CalDataViewer,'ListMode','local');
zzz_refresh_varlist_Callback(handles);

%%
function menu_shared_varlist_Callback(hObject,eventdata)
handles=guidata(hObject);

set(handles.menu_local_varlist,'Checked','off');
set(handles.menu_shared_varlist,'Checked','on');
set(handles.hbox_home,'Sizes',[0 -1]);
LimitSizeFig(handles.fig_CalDataViewer,'min', [600, 875]);
set(handles.fig_CalDataViewer,'Position',[1030 150 600 875]);
setappdata(handles.fig_CalDataViewer,'ListMode','shared');
zzz_refresh_varlist_Callback(handles);

%% Menu-Help
function menu_explore_codefolder_Callback(hObject,eventdata)
codefile_name='CalDataViewer.m';
codefile_path=which(codefile_name);
[codefile_folder,~,~]=fileparts(codefile_path);
dos(['explorer ',codefile_folder]);

%%
function menu_zip_code_Callback(hObject,eventdata)
codefile_name='CalDataViewer.m';
codefile_path=which(codefile_name);
[codefile_folder,~,~]=fileparts(codefile_path);
formatOut='yyyymmdd_HHMM';
str_date=datestr(now,formatOut);
zipfile_name=['CalDataViewer[',str_date,'].zip'];
zipfile_path=fullfile(codefile_folder,zipfile_name);

disp(['Pack to "',zipfile_path,'"']);
zip(zipfile_path,codefile_path);

%%
function menu_zip_allcode_Callback(hObject,eventdata)
%Layout Package for Matlab2013a is not included
codefile_name='CalDataViewer.m';
codefile_path=which(codefile_name);
[codefile_folder,~,~]=fileparts(codefile_path);
formatOut='yyyymmdd_HHMM';
str_date=datestr(now,formatOut);
zipfile_name=['CalDataViewer[Pak',str_date,'].zip'];
zipfile_path=fullfile(codefile_folder,zipfile_name);

str_related_codefile={
    };
N=length(str_related_codefile);

disp(['Pack ',num2str(1+N),' codefiles to "',zipfile_path,'"']);
disp(['OK! ',codefile_path]);
str_path={codefile_path};
for j=1:N
    codefile_name=str_related_codefile{j};
    codefile_path=which(codefile_name);
    if exist(codefile_path,'file')==2
        str_path{end+1,1}=codefile_path;
        disp(['OK! ',codefile_path]);
    else
        disp(['Error! ',codefile_name,' is lost!']);
    end
end

zip(zipfile_path,str_path);

%%
function menu_about_Callback(hObject, eventdata)
% hObject    handle to pb_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
helpinfo={
    ''
    'Environment: MATLAB2013a + GUILayout-v1p17'
    ''
    'Group: YulinGroup@Oxford,  XueGroup@Tsinghua'
    'Author: Teng Zhang'
    'E-mail: zhangteng11@mails.tsinghua.edu.cn'
    'Date: 20150704'
    };

h_msgbox=msgbox(helpinfo,'About CalDataViewer','none','replace');
h_text=findall(h_msgbox,'type','text');
set(h_text,'FontSize',10,'Color','k','FontName','Arial');

%% zzz
function zzz_transform_Callback(handles,str_Tr)
VarSel=getappdata(0,'VarSel');
if isempty(VarSel)
    return;
end

N_var=length(VarSel);
for i=1:N_var
    varname=VarSel{i};
    str_status=[str_Tr ' ' varname ' ...'];
    set(handles.st_status,'String',str_status,'ForegroundColor','g');
    drawnow;
    
    olddata=evalin('base',varname);
    if isstruct(olddata)
        N_E=length(olddata.v_E);
        newdata.v_E=olddata.v_E;
        for j=1:N_E
            newdata.C{j,1}=zzz_transform_Function(olddata.C{j},str_Tr,handles);
        end
    else
        newdata=zzz_transform_Function(olddata,str_Tr,handles);
    end
    assignin('base',[varname '_' str_Tr],newdata);
end
set(handles.st_status,'String','Idle','ForegroundColor','g');

zzz_refresh_varlist_Callback(handles);

%%
function M=zzz_transform_Function(M0,str_Tr,handles)
if isempty(M0)
    M=[];
    return;
end

M=M0;
switch str_Tr
    case 'mx'
        IsCopy=get(handles.cb_mirror_x_copy,'Value');
        xm=str2double(get(handles.ed_xm,'String'));
        M(:,1)=2*xm-M(:,1);
    case 'my'
        IsCopy=get(handles.cb_mirror_y_copy,'Value');
        ym=str2double(get(handles.ed_ym,'String'));
        M(:,2)=2*ym-M(:,2);
    case 'R'
        IsCopy=get(handles.cb_rotate_copy,'Value');
        azi=str2double(get(handles.ed_azi,'String'));
        xx=M(:,1);
        yy=M(:,2);
        theta=azi/180*pi;
        M(:,1)=xx*cos(theta)-yy*sin(theta);
        M(:,2)=xx*sin(theta)+yy*cos(theta);
    case 'Tv'
        IsCopy=get(handles.cb_translate_copy,'Value');
        v=str2num(get(handles.ed_v,'String'));
        M(:,1)=M(:,1)+v(1);
        M(:,2)=M(:,2)+v(2);
    case 'ax'
        IsCopy=0;
        a=str2double(get(handles.ed_rescale_x,'String'));
        M(:,1)=M(:,1)*a;
    case 'ay'
        IsCopy=0;
        b=str2double(get(handles.ed_rescale_y,'String'));
        M(:,2)=M(:,2)*b;
end
if IsCopy
    M=[M0;M];
end

%%
function zzz_draw2D(handles,M,str_title,method)
%Drawing Parameters
psize=str2double(get(handles.ed_psize,'String'));
divisor=str2double(get(handles.ed_divisor,'String'));
xmin=str2double(get(handles.ed_xmin,'String'));
xmax=str2double(get(handles.ed_xmax,'String'));
ymin=str2double(get(handles.ed_ymin,'String'));
ymax=str2double(get(handles.ed_ymax,'String'));
str_bgcolor=get(handles.ed_bgcolor,'String');
AxisOn=get(handles.cb_axis_on,'Value');
TitleOn=get(handles.cb_title_on,'Value');
AxisEqual=get(handles.cb_axis_equal,'Value');

%divide points number by divisor
M=M(1:divisor:end,:);

%cut off data out of range
if ~isnan(xmin)
    M=M(M(:,1)>xmin,:);
end
if ~isnan(xmax)
    M=M(M(:,1)<xmax,:);
end
if ~isnan(ymin)
    M=M(M(:,2)>ymin,:);
end
if ~isnan(ymax)
    M=M(M(:,2)<ymax,:);
end

%Main
switch method
    case 'scatter'
        cmin=str2double(get(handles.ed_cmin,'String'));
        cmax=str2double(get(handles.ed_cmax,'String'));
        str_cmap_dark=get(handles.ed_cmap_dark,'String');
        str_cmap_bright=get(handles.ed_cmap_bright,'String');
        IsReverseOverlap=get(handles.cb_reverse_overlap,'Value');
        ColorbarOn=get(handles.cb_colorbar,'Value');
        
        %build colormap
        cmap_dark=str2num(str_cmap_dark);
        if isempty(cmap_dark)
            switch str_cmap_dark
                case 'w'
                    cmap_dark=[1 1 1];
                case 'k'
                    cmap_dark=[0 0 0];
                case 'r'
                    cmap_dark=[0.85 0 0];
                case 'g'
                    cmap_dark=[0 0.3 0];
                case 'b'
                    cmap_dark=[0 0 1];
                otherwise
                    cmap_dark=[0 0 0];
            end
        end
        
        cmap_bright=str2num(str_cmap_bright);
        if isempty(cmap_bright)
            switch str_cmap_bright
                case 'w'
                    cmap_bright=[1 1 1];
                case 'k'
                    cmap_bright=[0 0 0];
                case 'r'
                    cmap_bright=[0.85 0 0];
                case 'g'
                    cmap_bright=[0 0.3 0];
                case 'b'
                    cmap_bright=[0 0 0.85];
                otherwise
                    cmap_bright=[1 1 1];
            end
        end
        cmap_r=linspace(cmap_dark(1),cmap_bright(1),256)';
        cmap_g=linspace(cmap_dark(2),cmap_bright(2),256)';
        cmap_b=linspace(cmap_dark(3),cmap_bright(3),256)';
        cmap=[cmap_r cmap_g cmap_b];
        colormap(cmap);
        
        if size(M,2)>2
            %Resort to plot points with higher intersity onto the weaker ones.
            if IsReverseOverlap
                M=sortrows(M,3);
            else
                M=sortrows(M,-3);
            end
            II=M(:,3);
            II(II<0)=0;
        else
            II=cmap_bright;
        end
        
        %Draw2D-scatter
        if ~isempty(M)
            h_hggroup=scatter(M(:,1),M(:,2),psize,II,'fill');
            h_patch=get(h_hggroup,'Children');
            set(h_patch,'Tag','graph_CalDataViewer');
        end
        
        clim=get(gca,'Clim');
        if isnan(cmin)
            cmin=clim(1);
        end
        if isnan(cmax)
            cmax=clim(2);
        end
        caxis([cmin cmax]);
        
        if ColorbarOn
            colorbar;
        end
    case 'plot'
        LineSpec=get(handles.ed_linespec,'String');
        str_pcolor=get(handles.ed_pcolor,'String');
        str_facecolor=get(handles.ed_facecolor,'String');
        
        %Color Settings
        pcolor=str2num(str_pcolor);
        if isempty(pcolor)
            switch str_pcolor
                case {'none','w','k','c','y'}
                    pcolor=str_pcolor;
                case 'r'
                    pcolor=[0.85 0 0];
                case 'g'
                    pcolor=[0 0.3 0];
                case 'b'
                    pcolor=[0 0 0.85];
                otherwise
                    pcolor=[0.85 0 0];
            end
        end
        facecolor=str2num(str_facecolor);
        if isempty(facecolor)
            switch str_facecolor
                case {'none','w','k','c','y'}
                    facecolor=str_facecolor;
                case 'r'
                    facecolor=[0.85 0 0];
                case 'g'
                    facecolor=[0 0.3 0];
                case 'b'
                    facecolor=[0 0 0.85];
                otherwise
                    facecolor=pcolor;
            end
        end
        
        %Draw2D-plot
        h_line=plot(M(:,1),M(:,2),LineSpec);
        set(h_line,'Tag','graph_CalDataViewer',...
            'Color',pcolor,...
            'MarkerFaceColor',facecolor,...
            'MarkerSize',psize);
end

%-----------------------------------
bgcolor=str2num(str_bgcolor);
if isempty(bgcolor)
    switch str_bgcolor
        case {'none','w','k','c','y'}
            bgcolor=str_bgcolor;
        case 'r'
            bgcolor=[0.85 0 0];
        case 'g'
            bgcolor=[0 0.3 0];
        case 'b'
            bgcolor=[0 0 0.85];
        otherwise
            bgcolor=[1 1 1];
    end
end
set(gca,'Color',bgcolor);

if AxisOn
    axis on;
else
    axis off;
end

if TitleOn
    title(str_title,'FontSize',15,'Interpreter','none');
end

if AxisEqual
    axis equal;
end

axis tight;
xlim=get(gca,'Xlim');
if isnan(xmin)
    xmin=xlim(1);
end
if isnan(xmax)
    xmax=xlim(2);
end
set(gca,'Xlim',[xmin xmax]);

ylim=get(gca,'Ylim');
if isnan(ymin)
    ymin=ylim(1);
end
if isnan(ymax)
    ymax=ylim(2);
end
set(gca,'Ylim',[ymin ymax]);

box on;
set(gca,'Layer','top');

%%
function zzz_refresh_varlist_Callback(handles)
ListMode=getappdata(handles.fig_CalDataViewer,'ListMode');
switch ListMode
    case 'local'
        lb_vars_Callback(handles.lb_vars,[]);
    case 'shared'
        zzz_sync_reverse_Callback(handles);
end

%%
function zzz_sync_reverse_Callback(handles)
%% Sync VarListViewer
fig_ARPESdataList=findall(0,'Tag','fig_ARPESdataList');
if length(fig_ARPESdataList)==1
    ARPESdataList('zzz_refresh_varlist_Callback(handles)');
end