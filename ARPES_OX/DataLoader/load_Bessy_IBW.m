function DATA = load_Bessy_IBW(file_path)
%load_Bessy_IBW Summary of this function goes here
%   Detailed explanation goes here

    buffer = IBWread(file_path);
    Ndim = buffer.Ndim;

    switch Ndim
        case 2
            DataSize = size(buffer.y);
            XSize = DataSize(2);
            YSize = DataSize(1);
            data.value = buffer.y';
            data.x = buffer.x0(2)+((1:XSize)-1)*buffer.dx(2);
            data.y = buffer.x0(1)+((1:YSize)-1)*buffer.dx(1);
%             data.value = filloutliers(data.value,'center','mean',1);
            DATA = OxA_CUT(data);
        case 3
            DataSize = size(buffer.y);
            XSize = DataSize(3);
            YSize = DataSize(2);
            ZSize = DataSize(1);
            data.value = permute(buffer.y, [3 2 1]);
            data.x = buffer.x0(3)+((1:XSize)-1)*buffer.dx(3);
            data.y = buffer.x0(2)+((1:YSize)-1)*buffer.dx(2);
            data.z = buffer.x0(1)+((1:ZSize)-1)*buffer.dx(1);
%             data.value = filloutliers(data.value,'linear','mean',2);
            DATA = OxA_MAP(data);

    end

    % notes
    notes = buffer.WaveNotes;
    notes1 = regexp(notes,'[A-Z][\w-]*( [\w-]*)*=[\w-]*(\.\d*)*','match');
    notes2 = squeeze(split(notes1,'='));

    Index = contains(notes2(:,1),'Pass Energy');
    DATA.info.pass_energy = str2num(notes2{Index,2});
    Index = contains(notes2(:,1),'Acquisition Mode');
    DATA.info.acquisition_mode = notes2{Index,2};

    DATA.info.workfunction = 4.4;
%     DATA.info.photon_energy = 121;

    % remove spikes
%     if strcmp(DATA.info.acquisition_mode,'Fixed')
%         switch Ndim
%             case 2
%                 DATA.value = filloutliers(DATA.value,'linear','mean',2);
%             case 3
%                 DATA.value = filloutliers(DATA.value,'linear','mean',3);
%         end
%     end





end