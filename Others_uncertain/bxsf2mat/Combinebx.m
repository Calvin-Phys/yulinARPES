fidin=dir('P:\Dropbox\DLS_20200301\Wien2k\CoSb3');
cd('P:\Dropbox\DLS_20200301\Wien2k\CoSb3');
num=size(fidin);
fidout=fopen('P:\Dropbox\DLS_20200301\Wien2k\CoSb3.bxsf','w');
for i=3:num(1)
    fid=fopen(fidin(i).name,'r');
    flag=0;
    while ~feof(fid)
        txt=fgetl(fid);
        if strncmp(txt,' BAND:',6) 
            flag=1; 
        end
        if strncmp(txt,' END_BANDGRID',13)
            flag=0;
        end
        if flag==1 
            fprintf(fidout,'%s\n',txt);
        end
    end
    fclose(fid);
end
fclose(fidout);