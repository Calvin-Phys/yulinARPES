function tf = loadIBW(varargin)

if nargin~=1
    errordlg('There should be only one input -- the data filename','Wrong argument No.');
    tf=false;
    return
end

[~, file_name, ext] = fileparts(varargin{1}); 
if ~strcmp(ext,'.ibw')
%     errordlg(['The file "' varargin{1} '" is not a .txt file!'],'Wrong file format');
    tf=false;
    return
end

buffer = IBWread(varargin{1});
DataSize = size(buffer.y);
XSize = DataSize(2);
YSize = DataSize(1);
data.value = buffer.y';
data.x = buffer.x0(2)+([1:XSize]-1)*buffer.dx(2);
data.y = buffer.x0(1)+([1:YSize]-1)*buffer.dx(1);


% assign to workspace
if ~isletter( file_name(1) )
    file_name =['A',file_name];
end

assignin('base',file_name,data);

tf = true;



    
    
        
        




