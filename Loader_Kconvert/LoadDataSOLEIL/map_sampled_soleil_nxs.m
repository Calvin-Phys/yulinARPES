function handles = map_sampled_soleil_nxs( varargin )
cla;   %deletes all graphics objects
handles=varargin{1};

map_type=get(handles.popup_Map_Type,'Value');
indice1=get(handles.slider_1,'Value');
indice2=get(handles.slider_2,'Value');

[~, filename, ext] = fileparts(handles.fullfilename);
if ~strcmpi(ext,'.nxs')
    return;
end
filename(filename=='-')='_';
data=evalin('base',filename);  %data.value(x,y,k,z)

if map_type==1  %y-x
    if strcmp(handles.datatype,'Real Space Scan Data')
        value=data.value(:,:,indice2,indice1);
    elseif strcmp(handles.datatype,'Map Data')
        value=data.value(:,:,indice1);
    end
    pcolor(data.x,data.y,squeeze(value)');
    xlabel('x');
    ylabel('y');
    axis equal;
elseif map_type==2  %z-y
    if strcmp(handles.datatype,'Real Space Scan Data')
        value=data.value(indice1,:,indice2,:);
    elseif strcmp(handles.datatype,'Map Data')
        value=data.value(indice1,:,:);
    end
    pcolor(data.y,data.z,squeeze(value)');
    xlabel('y');
    ylabel('z');
elseif map_type==3  %z-x
    if strcmp(handles.datatype,'Real Space Scan Data')
        value=data.value(:,indice1,indice2,:);
    elseif strcmp(handles.datatype,'Map Data')
        value=data.value(:,indice1,:);
    end
    pcolor(data.x,data.z,squeeze(value)');
    xlabel('x');
    ylabel('z');
elseif map_type==4  %z-k
    if strcmp(handles.datatype,'Real Space Scan Data')
        value=data.value(indice1,indice2,:,:);
    elseif strcmp(handles.datatype,'Map Data')
        return;
    end
    pcolor(data.k,data.z,squeeze(value)');
    xlabel('k');
    ylabel('z');
end
shading interp;
colormap (parula);
