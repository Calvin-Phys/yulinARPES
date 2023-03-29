function [surf_rec_lattice_coordinates,surf_rec_lattice_rows] = plotBZ_V1_construct_surf_rec_lattice(s1,s2,handles)
s1start = str2double(get(handles.s1start,'String'));
s1end = str2double(get(handles.s1end,'String'));
s2start = str2double(get(handles.s2start,'String'));
s2end = str2double(get(handles.s2end,'String'));
s1range = s1start:s1end;
s2range = s2start:s2end;
surf_rec_lattice_rows = zeros(1,length(s1range)*length(s2range));
surf_rec_lattice_coordinates = zeros((length(s1range)+4)*+(length(s2range)+4),2);
i=1;
j=1;
for hh = s1start-2:s1end+2
    for kk = s2start-2:s2end+2
        surf_rec_lattice_coordinates(i,:) = hh.*s1+kk.*s2;
        if ismember(hh,s1range) && ismember(kk,s2range)
            surf_rec_lattice_rows(1,j) = i;
            j=j+1;
        end
        i=i+1;
    end
end