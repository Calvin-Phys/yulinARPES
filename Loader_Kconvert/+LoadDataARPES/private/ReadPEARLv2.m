function [Angle,Energy,Scan,Data,ep,Note]=ReadPEARLv2(file)
% [Angle,Energy,Scan,Data,ep,Note]=ReadARPES(file) reads in HDF5 and SP2 files 
% to return Angle (row), Energy (column), Scan (empty for 2D arrays and row
% for 3D arrays, Data (2- or 3-dim array), ep (pass energy) and Note (info)

    try
        low=h5read(file,'/scan 1/attrs/ScientaLowEnergy');
        str_scan='/scan 1/';
    catch
        low=h5read(file,'/scan1/attrs/ScientaLowEnergy');
        str_scan='/scan1/';
    end
    
    Data=h5read(file,[str_scan,'ScientaImage']);
    low=h5read(file,[str_scan,'attrs/ScientaLowEnergy']);
    high=h5read(file,[str_scan,'attrs/ScientaHighEnergy']);
    step=h5read(file,[str_scan,'attrs/StepSize']);
    Anglow=h5read(file,[str_scan,'attrs/ScientaSliceBegin']);
    Anghigh=h5read(file,[str_scan,'attrs/ScientaSliceEnd']);
    Angsteps=h5read(file,[str_scan,'attrs/ScientaNumSlices']);
    Note={};
    Note.hv=h5read(file,[str_scan,'attrs/MonoEnergy']);
    

%     Energy=low(end):step(end):high(end);
    try
        Energy=h5read(file,[str_scan,'ScientaChannels']);
    catch
        Energy=test;
    end
    Energy=Energy;
    Angle=linspace(Anglow(end),Anghigh(end),Angsteps(end));
    
    if length(Note.hv)>1
        Scan=round(Note.hv);
    else
        Scan=[];
    end
    ep=[];
   