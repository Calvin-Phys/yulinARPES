function lattice_cell(xlist,ylist,zlist,a,b,c,n,cubic,tetragonal,orthorhombic,body_centred,face_centred,side_centred)
m=length(xlist);
if ((cubic && tetragonal) || (cubic && orthorhombic) || (tetragonal && orthorhombic))==1
    error_plot;
else
for i=1:m
    if cubic==1
        if a~=b || a~=c || b~=c
            error_plot;
            break;
        end
        if body_centred==1
            lattice_bcc(xlist(i),ylist(i),zlist(i),a,n);
        else
            if face_centred==1
                lattice_fcc(xlist(i),ylist(i),zlist(i),a,n);
            else
                lattice_sc(xlist(i),ylist(i),zlist(i),a,n);
            end
        end
    end
    if tetragonal==1
        if a~=b || a==c || b==c
            error_plot;
            break;
        end
        if body_centred==1
            lattice_body_centred(xlist(i),ylist(i),zlist(i),a,b,c,n);
        else
            lattice_so(xlist(i),ylist(i),zlist(i),a,b,c,n);
        end
    end
    if orthorhombic==1
        if a==b || a==c || b==c
            error_plot;
            break;
        end
        if body_centred==1
            lattice_body_centred(xlist(i),ylist(i),zlist(i),a,b,c,n);
        else
            if face_centred==1
                lattice_fcc(xlist(i),ylist(i),zlist(i),a,n);
            else
                if side_centred==1
                    lattice_side_centred(xlist(i),ylist(i),zlist(i),a,b,c,n);
                else
                    lattice_so(xlist(i),ylist(i),zlist(i),a,b,c,n);
                end
            end
        end
    end
    hold on;
end
end
end

                