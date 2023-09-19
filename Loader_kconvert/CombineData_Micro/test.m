P_initial = 0;
P_final = 90;
P_step = 2;
T_initial = 0;
T_final = 60;
T_step = 12;
P0 = 90;
T0 = 0;
A0 = -30;

CUT_x = -7.5:0.5:7.5;
CUT_y = 68:0.01:71.5;

kk1 = [];
Eki = 71;
CONST = 0.512316722;

tic
for y_offset = T_initial:T_step:T_final
    [ThetaX, ThetaY] = meshgrid(P_initial:P_step:P_final,CUT_x);
    kx = CONST* sqrt(Eki)* ( cosd(ThetaY).*sind(ThetaX-90) );
    ky = CONST* sqrt(Eki)* ( cosd(y_offset).*sind(ThetaY) +sind(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );
    kz = CONST* sqrt(Eki)* ( -sind(y_offset).*sind(ThetaY) +cosd(y_offset).*cosd(ThetaY).*cosd(ThetaX-90) );

    kx_ = cosd(P0-90)*kx - sind(P0-90)*kz;
    ky_ = - sind(P0-90)*sind(T0)*kx + cosd(T0)*ky - cosd(P0-90)*sind(T0)*kz;
    kz_ = sind(P0-90)*cosd(T0)*kx + sind(T0)*ky + cosd(P0-90)*cosd(T0)*kz;

    kx2 = cosd(A0)*kx_ + sind(A0)*ky_;
    ky2 = -sind(A0)*kx_ + cosd(A0)*ky_;

    kk1 = vertcat(kk1,[kx2(:), ky2(:), kz_(:)]);

end
toc

figure
hold on
scatter3(kk1(:,1),kk1(:,2),kk1(:,3),'r.');
% 
% 
% function [kx,ky,kz] = rotate2K(Eki,y_offset,thetax,thetay)
%     % electron mass = 9.1093837 × 10-31 kilograms
%     % hbar = 6.582119569...×10−16 eV⋅s
%     % k (A-1) = CONST [sqrt(2m)/hbar] * sqrt(Ek (eV)) * sin(theta)
%     CONST = 0.512316722;
% 
%     kx = CONST* sqrt(Eki)* ( cosd(thetay).*sind(thetax) );
%     ky = CONST* sqrt(Eki)* ( cosd(y_offset).*sind(thetay) +sind(y_offset).*cosd(thetay).*cosd(thetax) );
%     kz = CONST* sqrt(Eki)* ( -sind(y_offset).*sind(thetay) +cosd(y_offset).*cosd(thetay).*cosd(thetax) );
% end

%%

list = {};
for i = 1:102
    list{end+1} = ['SMPM06028_' sprintf('%03.0f', i)];
end

SMS1 = SMS_map('SMS1','bkgd_20');
SMS1.select_cut_list(list,-7,8);
SMS1.direct_combine(-7,8);
SMS1.k_convert(90.5,6.5,-4);

%%
list = {};
for i = 1:40
    list{end+1} = ['SMPM06029_' sprintf('%03.0f', i)];
end

SMS2 = SMS_map('SMS2','bkgd_20');
SMS2.select_cut_list(list,-7,8);
SMS2.direct_combine(-7,8);
SMS2.k_convert(90.5,6.5,-4);

%%
list = {};
for i = 1:20
    list{end+1} = ['SMPM060211_' sprintf('%03.0f', i)];
end

SMS3 = SMS_map('SMS3','bkgd_20');
SMS3.select_cut_list(list,-7,8);
SMS3.direct_combine(-7,8);
SMS3.k_convert(90.5,6.5,-4);

%%
list = {};
for i = 1:10
    list{end+1} = ['SMPM060211_' sprintf('%03.0f', i)];
end
for i = 1:51
    list{end+1} = ['SMPM06028_' sprintf('%03.0f', i)];
end
for i = 1:20
    list{end+1} = ['SMPM06029_' sprintf('%03.0f', i)];
end

for i = 11:20
    list{end+1} = ['SMPM060211_' sprintf('%03.0f', i)];
end
for i = 52:102
    list{end+1} = ['SMPM06028_' sprintf('%03.0f', i)];
end
for i = 21:40
    list{end+1} = ['SMPM06029_' sprintf('%03.0f', i)];
end

SMS4 = SMS_map('SMS4','bkgd_20');
SMS4.select_cut_list(list,-7,8);
SMS4.direct_combine(-7,8);
% normalise
SMS4.k_convert(91,6.3,-4.3);

%%
x1 = SMP0601_036.x;
y1 = SMP0601_036.value;
y1 = y1/max(y1);
x2 = SMP0601_037.x;
y2 = SMP0601_037.value;
y2 = y2/max(y2);

y3 = conv(y1,y2,'same');
y3 = y3/max(y3);

figure
plot(x1,y1,x2,y2,x1,y3);

%% Ge2

list = {};
for i = 1:102
    list{end+1} = ['SMPM06015_' sprintf('%03.0f', i)];
end

Ge2_5 = SMS_map('Ge2_5','bkgd_20');
Ge2_5.select_cut_list(list,-7,8);
Ge2_5.direct_combine(-7,8);
Ge2_5.k_convert(90,3.5,0);

%%
list = {};
for i = 1:27
    list{end+1} = ['SMPM06017_' sprintf('%03.0f', i)];
end

Ge2_6 = SMS_map('Ge2_6','bkgd_20');
Ge2_6.select_cut_list(list,-7,8);
Ge2_6.direct_combine(-7,8);
Ge2_6.k_convert(90.5,6.5,-4);

%%
list = {};
for i = 1:40
    list{end+1} = ['SMPM06018_' sprintf('%03.0f', i)];
end

Ge2_8 = SMS_map('Ge2_8','bkgd_20');
Ge2_8.select_cut_list(list,-7,8);
Ge2_8.direct_combine(-7,8);
Ge2_8.k_convert(90.5,6.5,-4);

%%
list = {};
for i = 1:51
    list{end+1} = ['SMPM060110_' sprintf('%03.0f', i)];
end

Ge2_10 = SMS_map('Ge2_10','bkgd_20');
Ge2_10.select_cut_list(list,-7,8);
Ge2_10.direct_combine(-7,8);
Ge2_10.k_convert(90.5,6.5,-4);

%%
list = {};
for i = 1:51
    list{end+1} = ['SMPM060113_' sprintf('%03.0f', i)];
end

Ge2_13 = SMS_map('Ge2_13','bkgd_20');
Ge2_13.select_cut_list(list,-7,8);
Ge2_13.direct_combine(-7,8);
Ge2_13.k_convert(90.5,6.5,-4);


%% D3_5 & D3_8
list = {};
for i = 1:20
    list{end+1} = ['SMPM06018_' sprintf('%03.0f', i)];
end

for i = 1:51
    list{end+1} = ['SMPM06015_' sprintf('%03.0f', i)];
end

for i = 21:40
    list{end+1} = ['SMPM06018_' sprintf('%03.0f', i)];
end

for i = 52:102
    list{end+1} = ['SMPM06015_' sprintf('%03.0f', i)];
end

Ge2_map1 = SMS_map('Ge2_map1','bkgd_20');
Ge2_map1.select_cut_list(list,-7,8);
Ge2_map1.direct_combine(-7,8);
Ge2_map1.k_convert(90,3.5,0);

%% D3_5 & D3_10 & D3_13
list = {};
for i = 1:102
    list{end+1} = ['SMPM06015_' sprintf('%03.0f', i)];
end
for i = 1:51
    list{end+1} = ['SMPM060110_' sprintf('%03.0f', i)];
end
for i = 1:51
    list{end+1} = ['SMPM060113_' sprintf('%03.0f', i)];
end
Ge2_map2 = SMS_map('Ge2_map2','bkgd_20');
Ge2_map2.select_cut_list(list,-7,8);
Ge2_map2.direct_combine(-7,8);
Ge2_map2.k_convert(90,3.5,0);

%% test WSe2
list = {};
for i = 1:93
    list{end+1} = ['SMPM060312_' sprintf('%03.0f', i)];
end

WSE2 = SMS_map('WSE2','bkgd_20');
WSE2.select_cut_list(list,-7,8);
WSE2.direct_combine(-7,8);
WSE2.k_convert(83,2.3,14.5);

%% test SM
list = {};
for i = 1:162
    list{end+1} = ['SM_' sprintf('%03.0f', i)];
end

SM = SMS_map('SM','bkgd_sm');
SM.select_cut_list(list,-7,8);
SM.direct_combine(-7,8);
SM.k_convert(90,6,-4);