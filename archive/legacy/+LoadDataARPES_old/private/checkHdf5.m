function checkHdf5(fullfilename,path)
% path is a cell array
for i = 1:length(path)
    try
        value = h5read(fullfilename,path{i});
        disp(path{i});
        disp(size(value));
        disp(class(value));
    catch
        
        disp(path{i});
        disp('error');
    end
    
end