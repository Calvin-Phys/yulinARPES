function [fitted_intensity_map, fitted_params] = ....
    data_fitting_standalone(data, funcs, initial_params)
    fitted_params = fitting_data(data, funcs, initial_params);
    fitted_intensity_map = ...
        generate_dispersive_band(funcs, fitted_params, data.x, data.y);
end

function data = generate_dispersive_band(funcs, params, ticks_k, ticks_E)
    % Arguments:
    % funcs: cell array of functions, each band function with the form
    % funcs{i}(k, params.band_params{i});
    % params: struct, contains all the params needed to generate a
    % dispersive band intensity map; in which:
    % params.band_params: cell array of double array, 
    % params.band_params{i} correspond to funcs{i}'s params;
    % params.matrix_params: double array, coefficient of the
    % approximation polynomial, [a1,a2,a3] will generate the
    % polynomial a1*k^2 + a2*k + a3;
    % params.sigma: array, [sigma_k, sigma_E];
    % params.temperature: double, the temperature of the experiment
    % params.alpha: the Lorentz gamma = alpha * ( E - E_f )^2
    % note that the params_array is defined to be in exactly the same
    % names of above
    % ticks_k: k values in the intensity map;
    % ticks_E: E values in the intensity map;
    % Returns:
    % data: struct, the 2D data structure used by Chen group
    
    % calculate k and E resolution from ticks
    delta_k = abs(ticks_k(2)-ticks_k(1));
    delta_E = abs(ticks_E(2)-ticks_E(1));
    % create mesh grid for later use
    [mesh_k, mesh_E] = ndgrid(ticks_k, ticks_E);
    
    % generate the original delta function shaped band
    % we use the normal distribution to approximate the delta function
    % delta is the dirac delta function approximation param
    % this delta setup makes 3-sigma spans 5 pixels
    delta = 5 * (delta_E / 3.00);
    % avoid delta_intensity function's struct reference
    band_params = params.band_params;
    matrix_params_1 = params.matrix_params(1);
    matrix_params_2 = params.matrix_params(2);
    matrix_params_3 = params.matrix_params(3);
    temperature = params.temperature;
    
    % generate delta intensity map: the vectorization method
    % gpuArray to boost calculation 
    band_num = length(funcs);
    intensity = zeros(length(ticks_k), length(ticks_E));
    parfor i = 1:band_num
        func = funcs{i};
        band_i_params = band_params{i};
        mesh_E_k = arrayfun(@(k) func(k, band_i_params), mesh_k);
        intensity = intensity + (1 / ( sqrt(2 * pi) * delta )) * ...
            exp( - (mesh_E - mesh_E_k) .^ 2 / (2 * delta ^2));
    end
        
    % impose the Fermi Distribution effect on the delta band map pixel
    % it is assumed that the Fermi Level has been prepared to zero
    % 1 eV / k_B = 11604.5221 K, assuming that the E unit is in eV
    fermi_multiplier = ...
            1 ./ (exp((11604.5221 / temperature) * (mesh_E - 0))+1);
    % impose the matrix element effect on delta intensity map pixel
    matrix_multiplier = matrix_params_1 * mesh_k .^ 2 +...
                        matrix_params_2 * mesh_k .^ 1 +...
                        matrix_params_3 * mesh_k .^ 0;
    matrix_multiplier = mat2gray(matrix_multiplier);
    % generate the delta band
    ARPES_band_value = intensity .* fermi_multiplier .* matrix_multiplier;
    
    % impose the lorentz broadening
    for i = 1:length(ticks_E)
        MDC = ARPES_band_value(:,i);
        gamma = params.alpha * (ticks_E(i) - 0)^2;
        % this makes the lorentz PDF to be truncated at 1/10 maximum
        k_divide = (- 3 * gamma) : delta_k : (3 * gamma);
        lorentz_profile = ...
            (1/(pi * gamma)) * (gamma^2 ./ ( gamma^2 + k_divide.^2));
        MDC = conv(MDC, lorentz_profile, 'same');
        ARPES_band_value(:,i) = MDC;
    end
    
    % do the gaussian convolution using imgaussfilt
    sigma_k = params.sigma(1);
    sigma_E = params.sigma(2);
    % converse the gaussian convolution into pixel numbers
    % abs is for not constrain the optimization
    radius_k = abs( sigma_k / delta_k );
    radius_E = abs( sigma_E / delta_E );
    gauss_convolved_value = imgaussfilt(ARPES_band_value, [radius_k, radius_E]);
    
    % generating dispersive band data
    data.x = ticks_k;
    data.y = ticks_E;
    data.value = gauss_convolved_value;
end

function d = distance(generated_data, experiment_data)
    % Arguments:
    % generated_data: ChenGroup data struct, generated intensity map by the
    % generate_dispersive_band function;
    % experiment_data: ChenGroup data struct, experiment intensity map;
    % Returns:
    % d: double, the sum-square-difference of the 2 matrix;
    difference = (mat2gray(generated_data.value) ...
        - mat2gray(experiment_data.value)).^2;
    d = sum(difference(:));
end

function fitted_params = fitting_data(data, funcs, initial_params)
    % Arguments:
    % data: ChenGroup data struct, the data to be fitted;
    % func: function, the band function with the form func(k,
    % params.band_params);
    % initial_params: struct, the params to be used as initial condition;
    % Returns:
    % fitted_params: struct, the optimized params.
    function params_array = to_params_array(params)
        field_names = fieldnames(initial_params);
        field_num = length(field_names);
        params_array = [];
        for i = 1:field_num
            % if the current field is band_params, then do another loop to
            % extract the band params in struct
            if strcmp(field_names{i}, 'band_params')
                temp_cell = params.band_params;
                append_part = [];
                for j = 1:length(temp_cell)
                    append_part = [append_part, temp_cell{j}]; %#ok<AGROW>
                end
            else
                append_part = params.(field_names{i});
            end
            % params_array will not be large, so the warning is suppressed
            params_array = [params_array, append_part]; %#ok<AGROW>
        end
    end
    % to_params function chages params_array to a struct 
    function params = to_params(params_array)
        field_names = fieldnames(initial_params);
        field_num = length(field_names);
        current_array_index = 1;
        for i = 1:field_num
            if strcmp(field_names{i}, 'band_params')
                temp_cell = initial_params.band_params;
                params.band_params = {};
                for j = 1:length(temp_cell)
                    current_field_length = length(temp_cell{j});
                    params.band_params{j} = params_array(...
                        current_array_index:...
                        (current_array_index+current_field_length-1));
                    current_array_index = current_array_index...
                                    + current_field_length;
                end
            else
                current_field_length = ...
                    length(initial_params.(field_names{i}));
                params.(field_names{i}) = params_array(...
                    current_array_index:...
                    (current_array_index+current_field_length-1));
                current_array_index = current_array_index...
                                    + current_field_length;
            end
        end 
    end
    % define the target function
    function cost = target_function(params_array)
        params = to_params(params_array);
        experiment_data = data;
        tick_k = data.x;
        tick_E = data.y;
        generated_data = generate_dispersive_band(funcs, params, tick_k, tick_E);
        cost = distance(generated_data, experiment_data);
    end
    initial_params_array = to_params_array(initial_params);
    % use the fminsearch to do derivative-free search on this problem.
    % possible alternative: use the fminunc (since the target function is
    % smooth).
    fminsearch_options = optimset('Display', 'iter','MaxFunEvals', 10000);
    fitted_params_array = fminsearch(@target_function,...
        initial_params_array, fminsearch_options);
    fitted_params = to_params(fitted_params_array);
end

