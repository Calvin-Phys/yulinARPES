function lattice_with_unit(xlist,ylist,zlist,a,b,c,alpha,beta,gamma,simple,body,face,side,num)
n=length(xlist);
hold on;
if ((simple||body||face||side)==0)||(((simple&&body)||(simple&&face)||(simple&&side)||(body&&face)||(body&&side)||(face&&side))==1)
    error_plot;
else
for i=1:n
    if (a==b)&&(a==c)&&(alpha==90)&&(beta==90)&&(gamma==90)
        if simple==1
            lattice_sc(xlist(i),ylist(i),zlist(i),a,num);
        else
            if body==1
                lattice_bcc(xlist(i),ylist(i),zlist(i),a,num);
            else
                if face==1
                    lattice_fcc(xlist(i),ylist(i),zlist(i),a,num);
                else
                    error_plot;
                    break;
                end
            end
        end
    else
    if (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
        if simple==1
            lattice_so(xlist(i),ylist(i),zlist(i),a,b,c,num);
        else
            if body==1
                lattice_body_centred(xlist(i),ylist(i),zlist(i),a,b,c,num);
            else
                error_plot;
                break;
            end
        end
    else
    if (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(beta==90)&&(gamma==90)
        if simple==1
            lattice_so(xlist(i),ylist(i),zlist(i),a,b,c,num);
        else
            if body==1
                lattice_body_centred(xlist(i),ylist(i),zlist(i),a,b,c,num);
            else
                if face==1
                    lattice_face_centred(xlist(i),ylist(i),zlist(i),a,b,c,num);
                else
                    if side==1
                        lattice_side_centred(xlist(i),ylist(i),zlist(i),a,b,c,num);
                    else
                        error_plot;
                        break;
                    end
                end
            end
        end
    else
    if (a~=b)&&(a~=c)&&(b~=c)&&(alpha==90)&&(gamma==90)&&(beta~=90)
        if simple==1
            lattice_mono(xlist(i),ylist(i),zlist(i),a,b,c,beta,num);
        else
            if side==1
                lattice_side_centered_mono(xlist(i),ylist(i),zlist(i),a,b,c,beta,num);
            else
                error_plot;
                break;
            end
        end
    else   
    if (a==b)&&(b==c)&&(alpha==beta)&&(alpha==gamma)
        if simple==1
            lattice_trigonal(xlist(i),ylist(i),zlist(i),a,alpha,num);
        else
            error_plot;
            break;
        end
    else
    if (a==b)&&(a~=c)&&(alpha==90)&&(beta==90)&&(gamma==120)
        if simple==1
            lattice_prim(xlist(i),ylist(i),zlist(i),beta,gamma,num);
        else
            error_plot;
            break;
        end
    else
        sorry_plot;
    end
    end
    end
    end
    end
    end
end
end
axis equal;
end
