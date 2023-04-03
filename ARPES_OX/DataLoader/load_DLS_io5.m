function DATA = load_DLS_io5(file_path)
%LOAD_DLS_IO5 Summary of this function goes here
%   Detailed explanation goes here
    
    %   -------------------------
    title = h5read(file_path,'/entry1/title');
    try
        value = double(h5read(file_path,'/entry1/analyser/data'));
    catch

    end

    photon_energy = h5read(file_path,'/entry1/instrument/monochromator/energy');
    pass_energy = h5read(file_path,'/entry1/instrument/analyser/pass_energy');
    if pass_energy == 50
        workfunction = 4.4979E-6 *photon_energy.^2 + 1.49105E-3 *photon_energy + 4.40416;
    elseif pass_energy == 20
        workfunction = 5.77602E-6 *photon_energy.^2 + 1.23949E-3 *photon_energy + 4.4144;
    elseif pass_energy == 10
        workfunction = 5.77602E-6 *photon_energy.^2 + 1.23949E-3 *photon_energy + 4.4144;
    else
        workfunction = 4.5;
    end

    if contains(title,'static readout')
        x = h5read(file_path,'/entry1/analyser/angles');
        y = h5read(file_path,'/entry1/analyser/energies');
        
        DATA = OxA_CUT(x,y,value');
%         DATA = DATA.set_contrast();
        
    elseif contains(title,'scan pathgroup')
        value = permute(value,[3,2,1]);
        x = h5read(file_path,'/entry1/analyser/sapolar');
        y = h5read(file_path,'/entry1/analyser/angles');
        z = h5read(file_path,'/entry1/analyser/energies');
        DATA = OxA_MAP(x,y,z,value);
%         DATA = DATA.set_contrast();
    elseif contains(title,'scan scan_group')
        value = permute(value,[3,2,1]);
        x = h5read(file_path,'/entry1/analyser/sapolar');
        y = h5read(file_path,'/entry1/analyser/angles');
        z = mean(h5read(file_path,'/entry1/analyser/energies'),2);
        DATA = OxA_MAP(x,y,z,value);
    elseif contains(title,'scan deflector_x')
        value = permute(value,[3,2,1]);
        x = h5read(file_path,'/entry1/analyser/deflector_x');
        y = h5read(file_path,'/entry1/analyser/angles');
        z = mean(h5read(file_path,'/entry1/analyser/energies'),2);
        DATA = OxA_MAP(x,y,z,value);
%         DATA = DATA.set_contrast();

    % old KZ scan
    elseif contains(title,'scan energy_group')
        value = flip(permute(value,[3,2,1]),1);
        x = flip(h5read(file_path,'/entry1/analyser/value'));
        y = h5read(file_path,'/entry1/analyser/angles');

        ZZ = h5read(file_path,'/entry1/analyser/energies');
        HHVV = repmat(x',size(ZZ,1),1);
%         WW = repmat(workfunction',size(ZZ,1),1);
        z = mean(ZZ - HHVV,2) + workfunction;

        DATA = OxA_KZ(x,y,z,value);
%         DATA = DATA.set_contrast();

    % new KZ scan
    elseif contains(title,'scan energy') && ~contains(title,'scan energy_group')
        value = flip(permute(value,[3,2,1]),1);
        x = flip(h5read(file_path,'/entry1/analyser/energy'));
        y = h5read(file_path,'/entry1/analyser/angles');

        ZZ = h5read(file_path,'/entry1/analyser/energies');
        HHVV = repmat(photon_energy',size(ZZ,1),1);
        WW = repmat(workfunction',size(ZZ,1),1);
%         WW = 0;
        z = mean(ZZ - (HHVV - WW),2);

        DATA = OxA_KZ(x,y,z,value);
%         DATA = DATA.set_contrast();
    elseif contains(title,'scan say')
        x = flip(h5read(file_path,'/entry1/analyser/say'));
        value = h5read(file_path,'/entry1/analyser/analyser');
        DATA = OxArpes_1D_Data(x,value);
        DATA.x_name = 'say';
        DATA.x_unit = 'mm';
    elseif contains(title,'scan salong')
        x = flip(h5read(file_path,'/entry1/analyser/salong'));
        value = h5read(file_path,'/entry1/analyser/analyser');
        DATA = OxArpes_1D_Data(x,value);
        DATA.x_name = 'salong';
        DATA.x_unit = 'mm';
    elseif contains(title,'scan sax') && contains(title,'saz')
        x = mean(flip(h5read(file_path,'/entry1/analyser/sax')),1)';
        y = mean(h5read(file_path,'/entry1/analyser/saz'),2);
        z = mean(h5read(file_path,'/entry1/analyser/energies'),[2 3]);
        value = squeeze(sum(h5read(file_path,'/entry1/analyser/data'),2));
        value = permute(value,[3,2,1]);
        DATA = OxA_RSImage(x,y,z,value);
        DATA.x_name = 'sax';
        DATA.x_unit = 'mm';
        DATA.y_name = 'saz';
        DATA.y_unit = 'mm';
        DATA.z_name = 'kinetic Energy';
        DATA.z_unit = 'eV';
    else
        DATA = [];
    end

    % ------- add Info
    DATA.info.workfunction = workfunction;
    DATA.info.photon_energy = h5read(file_path,'/entry1/instrument/monochromator/energy');
    DATA.info.polarization = h5read(file_path,'/entry1/instrument/insertion_device/beam/final_polarisation_label');
    DATA.info.acquisition_mode = h5read(file_path,'/entry1/instrument/analyser/acquisition_mode');
    DATA.info.pass_energy = h5read(file_path,'/entry1/instrument/analyser/pass_energy');
    DATA.info.center_energy = h5read(file_path,'/entry1/instrument/analyser/kinetic_energy_center');
    DATA.info.temperature = h5read(file_path,'/entry1/sample/temperature');

%     remove spikes
    if strcmp(DATA.info.acquisition_mode,'Fixed')
        switch ndims(value)
            case 2
%                 DATA.value = filloutliers(DATA.value,'linear','mean',2);
                DATA.value(17,91) = 0;
            case 3
%                 DATA.value = filloutliers(DATA.value,'linear','mean',3);
                DATA.value(:,17,91) = zeros(size(DATA.value,1),1);
        end
    end
end

