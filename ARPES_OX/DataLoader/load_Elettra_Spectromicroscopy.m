function DATA = load_Elettra_Spectromicroscopy(file_path)
    %LOAD_ELETTRA_SPECTROMICROSCOPY Summary of this function goes here
    %   Detailed explanation goes here
    
    data_info = h5info(file_path);
    
    Index = find(contains({data_info.Datasets.Attributes.Name},'Acquisition Type'));
    data_type = data_info.Datasets.Attributes(Index).Value;

    value = h5read(file_path,['/',data_info.Datasets.Name]);
    Dim0_value = data_info.Datasets.Attributes(find(contains({data_info.Datasets.Attributes.Name},'Dim0 Values'))).Value;
    Dim1_value = data_info.Datasets.Attributes(find(contains({data_info.Datasets.Attributes.Name},'Dim1 Values'))).Value;
    Dim2_value = data_info.Datasets.Attributes(find(contains({data_info.Datasets.Attributes.Name},'Dim2 Values'))).Value;

    DATA = [];

    if strcmp(data_type,'Image')
        value = permute(double(value),[2,1,3]);
        z = Dim0_value(1) + (0:size(value,3)-1)*Dim0_value(2);
        x = Dim1_value(1) + (0:size(value,1)-1)*Dim1_value(2);
        y = Dim2_value(1) + (0:size(value,2)-1)*Dim2_value(2);

        DATA = OxA_RSImage(x,y,z,value);
        DATA = DATA.set_contrast();

    elseif strcmp(data_type,'Polar Scan') || strcmp(data_type,'Angular Scan')
        y = Dim0_value(1) + (0:size(value,2)-1)*Dim0_value(2);
        x = Dim1_value(1) + (0:size(value,1)-1)*Dim1_value(2);

        DATA = OxA_CUT(x,y,double(value));

    end

    % ------------- add info
    Index = find(contains({data_info.Datasets.Attributes.Name},'Stage Coord (XYZR)'));
    DATA.info.Xpos = data_info.Datasets.Attributes(Index).Value(1);
    DATA.info.Ypos = data_info.Datasets.Attributes(Index).Value(2);
    DATA.info.Zpos = data_info.Datasets.Attributes(Index).Value(3);
    DATA.info.Rpos = data_info.Datasets.Attributes(Index).Value(4);
    Index = find(contains({data_info.Datasets.Attributes.Name},'Angular Coord'));
    DATA.info.phi = data_info.Datasets.Attributes(Index).Value(1);
    DATA.info.theta = data_info.Datasets.Attributes(Index).Value(2);
    Index = find(contains({data_info.Datasets.Attributes.Name},'Ring En (GeV) GAP (mm) Photon (eV)'));
    DATA.info.photon_energy = data_info.Datasets.Attributes(Index).Value(3);
    Index = find(contains({data_info.Datasets.Attributes.Name},'Temperature (K)'));
    DATA.info.temperature = data_info.Datasets.Attributes(Index).Value(1);
    Index = find(contains({data_info.Datasets.Attributes.Name},'Ep (eV)'));
    DATA.info.pass_energy = data_info.Datasets.Attributes(Index).Value(1);

    DATA.info.workfunction = 2.5; 
end

