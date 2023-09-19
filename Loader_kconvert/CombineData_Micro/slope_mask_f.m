function array_out = slope_mask_f(array_in)
%SLOPE_MASK Summary of this function goes here
%   Detailed explanation goes here
    index0 = 0;
    index1 = 0;
    
    for k = 1:(length(array_in)-1)
        if array_in(k) == 0 && array_in(k+1) == 1
            index0 = k;
        end
        if array_in(k) == 1 && array_in(k+1) == 0
            index1 = k;
        end
    end

    if index0 == 0 && index1 == 0
        array_out = array_in;
    else
        array_out = zeros(size(array_in));
        array_out(index0+1:index1) = linspace(0,1,index1-index0);
    end


end

