function is2DARPESData(data)
    if ~isfield(data,'value')
        error('data should be ARPES data')
    end
    if ~ismatrix(data.value)
        error('data should be 2D ARPES data')
    end

