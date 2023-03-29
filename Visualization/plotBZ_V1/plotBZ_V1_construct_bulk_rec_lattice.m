function [rec_lattice_coordinates,rec_lattice_rows] = plotBZ_V1_construct_bulk_rec_lattice(b1_prim, b2_prim, b3_prim,handles)
%plotBZ_V1_construct_rec_lattice constructs reciprocal lattice based on
%primitive reciprocal lattice vectors.
KxStart=str2double(get(handles.KxStart,'String'));
KxEnd=str2double(get(handles.KxEnd,'String'));
KyStart=str2double(get(handles.KyStart,'String'));
KyEnd=str2double(get(handles.KyEnd,'String'));
KzStart=str2double(get(handles.KzStart,'String'));
KzEnd=str2double(get(handles.KzEnd,'String'));
BZ_Kxrange=KxStart:KxEnd;
BZ_Kyrange=KyStart:KyEnd;
BZ_Kzrange=KzStart:KzEnd;
rec_lattice_coordinates=zeros((length(BZ_Kxrange)+6)*+(length(BZ_Kyrange)+6)*(length(BZ_Kzrange)+6),3);
rec_lattice_rows = zeros(1,length(BZ_Kxrange)*length(BZ_Kyrange)*length(BZ_Kzrange));
i=1; 
j=1;


for hh=KxStart-3:KxEnd+3 % more lattice points are created than BZ's are plotted to avoid boundary artefacts
    for kk=KyStart-3:KyEnd+3
        for ll=KzStart-3:KzEnd+3
            rec_lattice_coordinates(i,:)=hh.*b1_prim+kk.*b2_prim+ll.*b3_prim; 
            
            if ismember(hh,BZ_Kxrange) && ismember(kk,BZ_Kyrange)&& ismember(ll,BZ_Kzrange)
               rec_lattice_rows(1,j)=i;
               j=j+1;
            end;
            i=i+1;
        end;
    end
end;


