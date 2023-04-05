function DATA = load_PSI_ULTRA(file_path)
%LOAD_PSI_ADRESS Summary of this function goes here
%   Detailed explanation goes here
    data_info = h5info(file_path);
    

    value = h5read(file_path,'/Electron Analyzer/Image Data');


    
    if ndims(value) == 3 % KZ

        Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis0.Scale') ...
            .* ~contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis0.ScaleType'));
        Axis0_scale = data_info.Groups(1).Datasets.Attributes(Index).Value;
        Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis1.Scale') ...
            .* ~contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis1.ScaleType'));
        Axis1_scale = data_info.Groups(1).Datasets.Attributes(Index).Value;
        Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis2.Scale') ...
            .* ~contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis2.ScaleType'));
        Axis2_scale = data_info.Groups(1).Datasets.Attributes(Index).Value;

        z = Axis0_scale(1) + (0:size(value,3)-1)*Axis0_scale(2);
        y = Axis1_scale(1) + (0:size(value,2)-1)*Axis1_scale(2);
        x = Axis2_scale(1) + (0:size(value,1)-1)*Axis2_scale(2);

        z = z - 0.1298;

        DATA = OxA_KZ(x,y,z,value);

    elseif ndims(value) == 2
        Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis0.Scale') ...
            .* ~contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis0.ScaleType'));
        Axis0_scale = data_info.Groups(1).Datasets.Attributes(Index).Value;
        Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis1.Scale') ...
            .* ~contains({data_info.Groups(1).Datasets.Attributes.Name},'Axis1.ScaleType'));
        Axis1_scale = data_info.Groups(1).Datasets.Attributes(Index).Value;

        y = Axis0_scale(1) + (0:size(value,2)-1)*Axis0_scale(2);
        x = Axis1_scale(1) + (0:size(value,1)-1)*Axis1_scale(2);

        y = y - 0.0258;

        DATA = OxA_CUT(x,y',value);

        Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Work Function (eV)'));
        workfunction = data_info.Groups(1).Datasets.Attributes(Index).Value - 0.1298;
        Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Excitation Energy (eV)'));
        photon_energy = data_info.Groups(1).Datasets.Attributes(Index).Value;

        DATA.y = DATA.y + photon_energy - workfunction;

    else
        DATA = [];
    end

        % ------- add Info
    Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Work Function (eV)'));
    DATA.info.workfunction = data_info.Groups(1).Datasets.Attributes(Index).Value - 0.1298;
    Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Excitation Energy (eV)'));
    DATA.info.photon_energy = data_info.Groups(1).Datasets.Attributes(Index).Value;

%     Index = find(contains({data_info.Groups(2).Datasets(21).Attributes.Name},'Mode'));
    DATA.info.polarization = data_info.Groups(2).Datasets(21).Attributes(3).Value;
    Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Acquisition Mode'));
    DATA.info.acquisition_mode = data_info.Groups(1).Datasets.Attributes(Index).Value;
    Index = find(contains({data_info.Groups(1).Datasets.Attributes.Name},'Pass Energy (eV)'));
    DATA.info.pass_energy = data_info.Groups(1).Datasets.Attributes(Index).Value;

    
end

