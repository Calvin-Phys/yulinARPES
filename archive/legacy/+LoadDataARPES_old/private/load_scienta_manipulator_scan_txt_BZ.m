function tf=load_scienta_manipulator_scan_txt(varargin)

% The function load_scienta_manipulator_scan_txt(filename) is designed
% to load the scienta manipulator scan data file into the workspace.
% Input "filename" is a string that contain the full filename
% with its path
%
% The function then loads the file into the workspace with the
% variable name start with the filename plus the serial number for each
% theta set (theta is the angle perpendicular to each cut) with the same
% phi angle. For different phi angle sets, the phi angle is automatic
% offseted by the info from the file.
%
% *** Note that the T and F defined in HELM is different to usual
% convention, i.e. F is the theta mentioned above, and T is the phi's
% offset ***
%
% The variable contains the field "info", axis information of
% "x", "y" and "z" depending on the measuring data's dimension
% and the field "value" for the bulk data.
%
% In case bugs are found, please contact the author (Yulin Chen) by
% Email: chen.yulin@gmail.com

% return true if successfully loaded, otherwise return false.

if nargin~=1
%     errordlg('There should be only one input -- the data filename','Wrong argument No.');
    tf=false;
    return
end

[~, ~, ext] = fileparts(varargin{1}); 
if ~strcmp(ext,'.txt')
%     errordlg(['The file "' varargin{1} '" is not a .txt file!'],'Wrong file format');
    tf=false;
    return
end

fid=fopen(varargin{1}); % open data file

%--------------gathering data information & scale---------------------
data.info=fgetl(fid);   % start getting data.info
info_line=fgetl(fid);
scale1=[];scale2=[];scale3=[];  %initialize all three scales, and for later judgement

while ~strncmp(info_line,'[Run Mode',9)
    if ~strncmp(info_line,'Dimension',9)    %as Dimension info is long, filter it out
        data.info=strvcat(data.info,info_line);
    end
    %----------get scale info---------------
    if strncmp(info_line, 'Dimension 1 scale=',18)
        % dimension 1 is energy which in terms of Yulin's def, should be
        % data.z in 3_d case and data.y in 2_d case
        scale1=str2num(info_line(19:size(info_line,2)));
        data.x=scale1;  % first 1D, if 2D or 3D adjust as below
    elseif strncmp(info_line, 'Dimension 2 scale=',18)
        % dimension 2 is angle -> data.x (2D) and data.y (3D)
        data.y=data.x;
        scale2=str2num(info_line(19:size(info_line,2)));
        data.x=scale2;  % first 2D, if 3D adjust as below
    elseif strncmp(info_line, 'Dimension 3 scale=',18)
        % if there is a dimension 3, change dim1 and dim2's def above
        data.z=data.y;
        data.y=data.x;
        scale3=str2num(info_line(19:size(info_line,2)));
        data.x=scale3; % if scale3 is still not the right one, change later
    end
    %----------end of getting scale info & scale-----
    info_line=fgetl(fid);
    if info_line==-1
        tf=false;
        return
    end
end
%--------------end of gathering data info---------------------


%--------------get scan info----------------------------------
while ~strncmp(info_line,'Step',4)  %move the line to scan angle matrix
    info_line=fgetl(fid);
end

scan_step=1; % used to label the total angle scan steps
while strncmp(info_line,'Step',4)
    info_line_data=sscanf(info_line,'%s %f %s %s %s %f %s %s %s %f %s');
    scan_angle(scan_step,:)=[info_line_data(9),info_line_data(13)]; % first is T, 2nd is F
    
    info_line=fgetl(fid);
    scan_step=scan_step+1;
end
%--------------end of getting scan info-----------------------

while ~strncmp(info_line, '[Data',5) % move cursor to data
    info_line=fgetl(fid);
end

if isempty(scale3) % judge if the data format is wrong
%     errordlg('This is not manipulator scan data','Wrong data format.');
    tf=false;
    return;
end

%======================get data===============================
% the method is for each phi offset, get the 2-D cuts, and save in a 3-d data
% variable, then run for different phi offset.
offset_flag=scan_angle(1,1);
offset_counter=1;
file_no=0;
scan_angle_no=1;

while scan_angle_no<=size(scan_angle,1)
    file_no=file_no+1;

    theta_no=1;
    while scan_angle(scan_angle_no,1)==offset_flag
        %datavalue=[];
        for i=1:size(scale1,2) % get the 2D cut
            line_data_c=fgetl(fid);
            line_data=str2num(line_data_c);
            datavalue(i,:)=line_data(2:size(line_data,2));
        end
        %reassign the correct theta number and give the phi_offset
        data_combine(file_no).theta(theta_no)=scan_angle(scan_angle_no,2);
        data_combine(file_no).phi_offset=offset_flag;
        data_combine(file_no).value(theta_no,:,:)=datavalue';
        theta_no=theta_no+1;                 % move to next theta
        scan_angle_no=scan_angle_no+1;       % move to next scan angle
        while ~strncmp(line_data_c, '[Data',5) && ischar(line_data_c) % move cursor to next data
            line_data_c=fgetl(fid);
        end
        if line_data_c==-1 
            break
        end       % if reach the end of file, go out of loop
    end
    if scan_angle_no<=size(scan_angle,1);
        offset_flag=scan_angle(scan_angle_no,1);
    end
end




fclose(fid);
%===============end of getting data===========================


%================assign variable into workspace===============
%first get the filename without extension
full_name=varargin{1};
%the file name should be chars between the last "\" and "."
str_pos=strfind(full_name,'\');
end_pos=strfind(full_name,'.');
file_name=full_name(str_pos( size(str_pos,2) )+1 : end_pos( size(end_pos,2) )-1 );
%if 1st char of file_name is a number, should add a letter in front of it
if ~isempty(str2num( file_name(1) ))
    file_name=strcat('A',file_name);
end

%----------assign each theta scan set to a variable-----------
for i=1:size(data_combine,2)
    file_name_sub=strcat(file_name,'_',num2str(i));
    data1.info=data.info;
    data1.x=data_combine(i).theta;
    data1.y=data.y+data_combine(i).phi_offset;
    data1.z=data.z;
    data1.value=data_combine(i).value;
    assignin('base',file_name_sub,data1);
end
tf=true;