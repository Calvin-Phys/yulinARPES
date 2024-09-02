function main(varargin)
    handles.mObject = figure('Position', [100 50 300 450], ...
        'Name', 'LoadDataARPES', ...
        'NumberTitle', 'off', ...
        'menubar', 'none', ...
        'Units', 'Pixel', ...
        'HandleVisibility', 'on', ...
        'Tag', 'LoadDataARPES');
    %LimitSizeFig('min', [1000, 650]);

    grid_home = uiextras.Grid('Parent', handles.mObject);
    vbox_home = uiextras.VBox('Parent', grid_home);

    % files tab--------------------------------------------------------
    vbox_files = uiextras.VBox('Parent', vbox_home);
    hbox_files1 = uiextras.HBox('Parent', vbox_files);
    hbox_files2 = uiextras.HBox('Parent', vbox_files);
    set(vbox_files, 'Padding', 2, 'Sizes', [25 -1]);
    % hbox_files1
    uicontrol('Parent', hbox_files1, 'Style', 'text', 'String', 'current folder');

    try
        cd_path = strcat(prefdir, '\cwdhistory.m');
        cd_dir = importdata(cd_path);

        if strncmp(pwd, 'C:\Program Files\', 17)
            cd(cd_dir{1})
        end

        handles.pm_CF = uicontrol('Parent', hbox_files1, 'Style', 'popupmenu', 'String', cd_dir, ...
            'Callback', @pm_CF_Callback);
    catch
        handles.pm_CF = uicontrol('Parent', hbox_files1, 'Style', 'popupmenu', 'String', pwd, ...
            'Callback', @pm_CF_Callback);
    end

    handles.pb_CF = uicontrol('Parent', hbox_files1, 'Style', 'pushbutton', ...
        'String', '<html><b>...</b></html>', ...
        'Callback', @pb_CF_Callback);
    set(hbox_files1, 'Sizes', [50 -1 50]);
    % hbox_files2
    vbox1_hbox_files2 = uiextras.VBox('Parent', hbox_files2);
    vbox2_hbox_files2 = uiextras.VBox('Parent', hbox_files2);
    set(hbox_files2, 'Padding', 2, 'Sizes', [-1 100]);
    % vbox1_hbox_files2
    handles.lb_flist = uicontrol('Parent', vbox1_hbox_files2, 'Style', 'listbox', ...
    'Max', 2, 'BackgroundColor', 'white', 'Callback', @lb_flist_Callback);
    handles.bg_filetype = uibuttongroup('Parent', vbox1_hbox_files2, 'BorderType', 'none', ...
        'SelectionChangeFcn', @bg_filetype_SelectionChangeFcn);
    set(vbox1_hbox_files2, 'Padding', 2, 'Sizes', [-1 20]);
    handles.rb_alltype = uicontrol('Parent', handles.bg_filetype, 'Style', 'radiobutton', 'String', 'all', 'pos', [5 2 50 15]);
    handles.rb_fits = uicontrol('Parent', handles.bg_filetype, 'Style', 'radiobutton', 'String', '.fits', 'pos', [55 2 50 15]);
    handles.rb_txt = uicontrol('Parent', handles.bg_filetype, 'Style', 'radiobutton', 'String', '.txt', 'pos', [105 2 50 15]);
    handles.rb_hdf5 = uicontrol('Parent', handles.bg_filetype, 'Style', 'radiobutton', 'String', '.hdf5', 'pos', [155 2 50 15]);
    handles.rb_png = uicontrol('Parent', handles.bg_filetype, 'Style', 'radiobutton', 'String', '.png', 'pos', [205 2 50 15]);
    % vbox2_hbox_files2
    handles.pb_load = uicontrol('Parent', vbox2_hbox_files2, ...
    'Style', 'pushbutton', 'String', ...
        ['<html><b><font size="+2"><center>Load</center></font>' ...
            '<font color="blue"><br>Scienta .txt<br>Manipulator-scan .txt<br>Diamond' ...
        '<br>Elettra .hdf5<br>ALS BL10 .fits</b></html>'], ...
        'Callback', @pb_load_data_Callback);
    handles.pb_export2txt = uicontrol('Parent', vbox2_hbox_files2, 'Style', 'pushbutton', ...
        'String', '<html><b>Save as Scienta txt</b></html>', 'Callback', @pb_export2txt_Callback);
    handles.pb_CropImageMargin = uicontrol('Parent', vbox2_hbox_files2, 'Style', 'pushbutton', ...
        'String', '<html><b>Crop image margin (.png)</b></html>', 'Callback', @pb_CropImageMargin_Callback);
    uiextras.Empty('Parent', vbox2_hbox_files2);
    set(vbox2_hbox_files2, 'Sizes', [150 50 50 -1], 'Spacing', 5, 'Padding', 5);

    % sync tab -----------------------------------------
    vbox_sync = uiextras.VBox('Parent', vbox_home);
    % ---
    hbox0_vbox_sync = uiextras.HBox('Parent', vbox_sync, 'Padding', 5);
    uicontrol('Parent', hbox0_vbox_sync, 'Style', 'text', 'String', 'Synchronize two folders');
    handles.pb_syncfolder = uicontrol('Parent', hbox0_vbox_sync, 'Style', 'pushbutton', ...
        'String', '<html><b><font size="+2"><center>Sync</center></b></html>', ...
        'Callback', @pb_syncfolders_Callback);
    % ---
    hbox1_vbox_sync = uiextras.HBox('Parent', vbox_sync, 'Padding', 5);
    handles.pb_origin_syncfolder = uicontrol('Parent', hbox1_vbox_sync, 'Style', 'pushbutton', ...
        'String', 'origin', 'Callback', @pb_pickpathorigin_Callback);
    handles.edit_origin_syncfolder = uicontrol('Parent', hbox1_vbox_sync, 'Style', 'edit', ...
        'String', 'path origin folder');
    set(hbox1_vbox_sync, 'Sizes', [40 -1])
    % ---
    hbox2_vbox_sync = uiextras.HBox('Parent', vbox_sync, 'Padding', 5);
    handles.pb_target_syncfolder = uicontrol('Parent', hbox2_vbox_sync, 'Style', 'pushbutton', ...
        'String', 'target', 'Callback', @pb_pickpathtarget_Callback);
    handles.edit_target_syncfolder = uicontrol('Parent', hbox2_vbox_sync, 'Style', 'edit', ...
        'String', 'path target folder');
    set(hbox2_vbox_sync, 'Sizes', [40 -1])
    % ---
    hbox3_vbox_sync = uiextras.HBox('Parent', vbox_sync, 'Padding', 5);
    handles.pb_resetpaths_syncfolder = uicontrol('Parent', hbox3_vbox_sync, 'Style', 'pushbutton', ...
        'String', 'reset paths', 'Callback', @pb_resetpaths_Callback);
    % set(hbox3_vbox_sync,'Sizes',[40])

    set(vbox_sync, 'Sizes', [40 -1 -1 -1])

    % ---
    % ---
    % set sizes of overall vbox_home

    set(vbox_home, 'Sizes', [-1 150])

    % pathname=uigetdir;
    % set(handles.edit_origin_folder,'String',pathname)
    %
    guidata(handles.mObject, handles);
end

function pb_pickpathorigin_Callback(hObject, eventdata)
    % hObject    handle to pm_CF (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);
    pathname = uigetdir;
    set(handles.edit_origin_syncfolder, 'String', pathname)
    pb_CF_Callback(handles.pb_CF, 'Update')
end

function pb_pickpathtarget_Callback(hObject, eventdata)
    % hObject    handle to pm_CF (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);
    pathname = uigetdir;
    set(handles.edit_target_syncfolder, 'String', pathname)
    pb_CF_Callback(handles.pb_CF, 'Update')
end

function pb_resetpaths_Callback(hObject, eventdata)
    % hObject    handle to pm_CF (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);

    try
        load('paths.mat', 'origin', 'target')
        set(handles.edit_target_syncfolder, 'String', target)
        set(handles.edit_origin_syncfolder, 'String', origin)
    catch
        warndlg('no paths.mat file saved from previous sync operation')
    end

    pb_CF_Callback(handles.pb_CF, 'Update')
end

function pb_syncfolders_Callback(hObject, eventdata)
    % hObject    handle to pm_CF (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);
    origin = get(handles.edit_origin_syncfolder, 'String');
    target = get(handles.edit_target_syncfolder, 'String');
    h = waitbar(0, '0%', 'Name', 'Loading');
    syncfolder(origin, target, 1);
    save('paths.mat', 'origin', 'target')
    close(h)
    pb_CF_Callback(handles.pb_CF, 'Update')
end

function pm_CF_Callback(hObject, eventdata)
    % hObject    handle to pm_CF (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);

    list_string = get(handles.pm_CF, 'String');
    index = get(handles.pm_CF, 'Value');
    s_dir = list_string{index};

    if isfolder(s_dir)
        cd(s_dir)
    else
        n = length(list_string);
        newlist(1:index - 1) = list_string(1:index - 1);
        newlist(index:n - 1) = list_string(index + 1:n);
        set(handles.pm_CF, 'String', newlist)
    end

    pb_CF_Callback(handles.pb_CF, 'Update')
end

function pb_CF_Callback(hObject, eventdata)
    % hObject    handle to pb_CF (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);
    newpath = cd();

    if ~strcmpi(eventdata, 'Update')
        newpath = uigetdir();
    end

    if get(handles.rb_alltype, 'Value')
        fileextension = '*.*';
    end

    if get(handles.rb_fits, 'Value')
        fileextension = '*.fits';
    end

    if get(handles.rb_txt, 'Value')
        fileextension = '*.txt';
    end

    if get(handles.rb_png, 'Value')
        fileextension = '*.png';
    end

    if get(handles.rb_hdf5, 'Value')
        fileextension = '*.hdf5';
    end

    if ~isempty(newpath) & (newpath ~= 0)
        cd(newpath);
        cd_dir = get(handles.pm_CF, 'String');
        i_dir = find(ismember(cd_dir, newpath));

        if isempty(i_dir)
            cd_dir_new = cat(1, newpath, cd_dir);
        else
            cd_dir_new = cd_dir;

            if i_dir > 1
                cd_dir_new{1} = newpath;

                for i = 2:i_dir
                    cd_dir_new{i} = cd_dir{i - 1};
                end

            end

        end

        set(handles.pm_CF, 'String', cd_dir_new)
        set(handles.pm_CF, 'Value', 1)
        DirRes = dir(fileextension);
        % Get the files + directories names
        [ListNames{1:length(DirRes), 1}] = deal(DirRes.name);

        % Get directories only
        [DirOnly{1:length(DirRes), 1}] = deal(DirRes.isdir);

        % Turn into logical vector and take complement to get indexes of files
        FilesOnly = ~cat(1, DirOnly{:});
        ListNames = ListNames(FilesOnly);
        set(handles.lb_flist, 'String', ListNames);
        index = get(handles.lb_flist, 'Value');

        if isempty(index)
            set(handles.lb_flist, 'Value', [], 'ListboxTop', 1)
        else

            if max(index) > length(ListNames)
                set(handles.lb_flist, 'Value', [], 'ListboxTop', 1)
            end

        end

    end

end

function lb_flist_Callback(hObject, eventdata)
    % hObject    handle to lb_flist (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);
    pb_CF_Callback(handles.pb_CF, 'Update')
    %-----------------------------------------
end

function bg_filetype_SelectionChangeFcn(hObject, eventdata)
    % hObject    handle to bg_filetype (see GCBO)
    % eventdata  EventName: 'SelectionChanged'
    %            OldValue: Handle of the object selected before this event. [] if none was selected.
    %            NewValue: Handle of the currently selected object.
    handles = guidata(hObject);
    pb_CF_Callback(handles.pb_CF, 'Update')
end

function pb_load_data_Callback(hObject, eventdata)
    % hObject    handle to pb_load (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);

    % select files to load
    list_entries = get(handles.lb_flist, 'String');
    index_selected = get(handles.lb_flist, 'Value');
    n = length(index_selected);

    h = waitbar(0, '0%', 'Name', 'Loading');

    for i = 1:n
        name = list_entries{index_selected(i)};

        try

            if load_scienta_general_txt_BZ(fullfile(cd, name))
                disp('load_scienta_general_txt_BZ');
            elseif load_ADRESS(fullfile(cd, name))
                disp('load_ADRESS');
            elseif load_APE_zip(fullfile(cd, name))
                disp('load_APE_zip');
            elseif load_SSRL_54_hdf5(fullfile(cd,name))
                disp('load_SSRL_54_hdf5');
            elseif load_Diamond_hdf5_nano(fullfile(cd, name))
                disp('load_Diamond_hdf5_nano');
            elseif load_Diamond_hdf5_xmas(fullfile(cd, name))
                disp('load_Diamond_hdf5_xmas');
            elseif load_SIS(fullfile(cd,name))
                disp('load_SIS');

%             elseif loadMAESTRO_fits(fullfile(cd,name))
%                 disp('loadMAESTRO_fits');
            elseif load_Elettra_hdf5_BZ(fullfile(cd, name))
                disp('load_Elettra_hdf5_BZ');
            


            elseif load_CASTEP(fullfile(cd, name))
            elseif bxsfReader(fullfile(cd, name))
            elseif load_APE_spin_txt(fullfile(cd, name))
                %     elseif load_PEARLv02 (fullfile(cd,name))
            elseif load_scienta_general_txt_BZ_ssrlnew(fullfile(cd, name))
            elseif load_scienta_manipulator_scan_txt_BZ(fullfile(cd, name))

                %     elseif load_fits_file_fun_BZ(fullfile(cd,name))
                %     elseif load_fits_file_fun_BL7_BZ(fullfile(cd,name))
            elseif load_soleil_nxs(fullfile(cd, name))
            elseif loadIBW_MAXIV(fullfile(cd, name))
                disp('load_IBW_MAXIV');
            elseif loadIBW(fullfile(cd, name))
                disp('load_IBW');
            end

        catch
            FileInfo = dir(fullfile(cd, name));

            if isempty(FileInfo)
                FileSize = 'File Not Found.';
            else
                FileSize = [num2str(FileInfo.bytes / 1000), 'kb'];
            end

            disp(['Failed to load ', name, '   ', FileSize]);
        end

        waitbar(i / n, h, [num2str(round(i * 100 / n)) '%'])
    end

    close(h)
end

function pb_export2txt_Callback(hObject, eventdata)
    % hObject    handle to pb_load (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);

    %-----------gettting information---------------
    list_entries = get(handles.lb_vars, 'String');
    index_selected = get(handles.lb_vars, 'Value');

    for i = 1:length(index_selected)
        data = evalin('base', list_entries{index_selected(i)});
        Export2ScientaData([list_entries{index_selected(i)} '.txt'], data);
    end

end

function pb_CropImageMargin_Callback(hObject, eventdata)
    % hObject    handle to pb_load (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    handles = guidata(hObject);

    %-----------gettting information---------------
    list_entries = get(handles.lb_flist, 'String');
    index_selected = get(handles.lb_flist, 'Value');

    for i = 1:length(index_selected)
        CropImageMargin(list_entries{index_selected(i)});
    end

end
