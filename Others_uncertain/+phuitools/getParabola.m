function [a,b,c] = getParabola(direction,Points)
% [a,b,c] = getParabola(direction,Points) returns the coefficient of a
% parabola, fitted by the points provided.
%
%
% Direction should either be 'x' or 'y'.
% Points can be input by getpts function.
% [vx,vy]=getpts; Points=[vx,vy];
%
switch direction
    case 'x'
        coDim = 1;
        valDim = 2;
    case 'y'
        coDim = 2;
        valDim = 1;
    otherwise
        error('Direction should be either x or y')
end
n=size(Points,1);
switch n
    case 1
        a=0;
        b=0;
        c=Points(1,valDim);
    case 2
        a=0;
        b=(Points(1,valDim)-Points(2,valDim))...
            /...
            (Points(1,coDim)-Points(2,coDim));
        c=det([Points(:,coDim),Points(:,valDim)])...
            /...
            (Points(1,coDim)-Points(2,coDim));
    case 3
        aDet = [Points(:,valDim),Points(:,coDim),[1;1;1]];
        bDet = [Points(:,coDim).^2,Points(:,valDim),[1;1;1]];
        cDet = [Points(:,coDim).^2,Points(:,coDim),Points(:,valDim)];
        dDet = [Points(:,coDim).^2,Points(:,coDim),[1;1;1]];
        d=det(dDet);
        a=det(aDet)/d;
        b=det(bDet)/d;
        c=det(cDet)/d;
    otherwise
        % Fit parabola points
        coef=polyfit(Points(:,coDim),Points(:,valDim),2);
        a=coef(1);
        b=coef(2);
        c=coef(3);
end


end

