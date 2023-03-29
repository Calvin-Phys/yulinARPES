function output = ExportAsScientaData( filename, data_x, data_y, data_value, photonenergy )
%ExportAsScientaData Summary of this function goes here
%   Detailed explanation goes here
    if length(data_x)~=size(data_value,1) || length(data_y)~=size(data_value,2)
        output=0;
        return
    end
    if exist(filename,'file')
        button=questdlg(['The file "' filename '" already exists! Overwrite?'],'Overwrite','Yes','No','No');
        if strcmp(button,'No')
            output=0;
            return
        end
    end
    
    s='';
    s=[s sprintf('[Info]\r\n')];
    s=[s sprintf('Number of Regions=1\r\n')];
    s=[s sprintf('Version=1.2.2\r\n')];
    s=[s sprintf('\r\n')];
    s=[s sprintf('[Region 1]\r\n')];
    s=[s sprintf('Region Name=BZ\r\n')];
    s=[s sprintf('Dimension 1 name=Kinetic Energy [eV]\r\n')];
    s=[s sprintf('Dimension 1 size=%d\r\n',length(data_y))];
    s=[s sprintf('Dimension 1 scale=')];
    for i=1:length(data_y)
        s=[s sprintf('%f ',data_y(i))];
    end
    s=[s sprintf('\r\n')];
    s=[s sprintf('\r\n')];
    s=[s sprintf('Dimension 2 name=Y-Scale [deg]\r\n')];
    s=[s sprintf('Dimension 2 size=%d\r\n',length(data_x))];
    s=[s sprintf('Dimension 2 scale=')];
    for i=1:length(data_x)
        s=[s sprintf('%f ',data_x(i))];
    end
    s=[s sprintf('\r\n')];
    s=[s sprintf('\r\n')];
    s=[s sprintf('[Info 1]\r\n')];
    s=[s sprintf('Instrument=R4000\r\n')];
    s=[s sprintf('Location=BZ\r\n')];
    s=[s sprintf('User=BZ\r\n')];
    s=[s sprintf('Sample=BZ\r\n')];
    s=[s sprintf('Comments=\r\n')];
    s=[s sprintf('Date=\r\n')];
    s=[s sprintf('Time=\r\n')];
    s=[s sprintf('Region Name=\r\n')];
    s=[s sprintf('Excitation Energy=%f\r\n',photonenergy)];
    s=[s sprintf('Energy Scale=Kinetic\r\n')];
    s=[s sprintf('Acquisition Mode=Swept\r\n')];
    s=[s sprintf('Center Energy=%f\r\n',(data_y(1)+data_y(end))/2)];
    s=[s sprintf('Low Energy=%f\r\n',data_y(1))];
    s=[s sprintf('High Energy=%f\r\n',data_y(end))];
    s=[s sprintf('Energy Step=%f\r\n',(data_y(end)-data_y(1))/(length(data_y)-1))];
    s=[s sprintf('Step Time=1000\r\n')];
    s=[s sprintf('Detector First X-Channel=1\r\n')];
    s=[s sprintf('Detector Last X-Channel=%d\r\n',length(data_y))];
    s=[s sprintf('Detector First Y-Channel=1\r\n')];
    s=[s sprintf('Detector Last Y-Channel=%d\r\n',length(data_x))];
    s=[s sprintf('Number of Slices=%d\r\n',length(data_x))];
    s=[s sprintf('Lens Mode=Angular30\r\n')];
    s=[s sprintf('Pass Energy=\r\n')];
    s=[s sprintf('Number of Sweeps=1\r\n')];
    s=[s sprintf('\r\n')];
    s=[s sprintf('[Data 1]\r\n')];
    
    fid=fopen(filename,'w');
    fprintf(fid,'%s',s);
    fclose(fid);
    
    data_v=zeros(length(data_x)+1,length(data_y));
    data_v(1,:)=data_y;
    data_v(2:length(data_x)+1,:)=data_value;
    dlmwrite(filename,data_v','-append','delimiter',' ','newline','pc')
    
    output=1;
end

