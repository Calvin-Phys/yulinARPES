%% 2D 
opts = struct();
opts.debug = true;
opts.peakMethod = 'manual';   % 'auto' | 'manual' | 'direct'
opts.searchRad = 12;
opts.fitRad = 2;

% For direct mode:
% opts.peakMethod = 'direct';
% opts.peakGuess = [18 6; -18 -6];

[data_nu, data_fft, data_fft_full_inan_remove, debug] = FixGridRemove_v4(i09_2_18794_ksp_sa, opts);

%% 3D

opts.direction = 'z';
opts.debug = true;
opts.peakMethod = 'manual';
opts.searchRad = 12;
opts.fitRad = 2;

[data_nu, data_fft, data_fft_full_inan_remove, debug] = FixGridRemove3D_v4(i09_2_18794, opts);
