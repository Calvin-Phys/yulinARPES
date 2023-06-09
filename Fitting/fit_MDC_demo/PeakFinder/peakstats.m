function PS=peakstats(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype,displayit)
% function
% PS=peakstats(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,
% smoothtype,displayit). Function to locate the positive peaks in a noisy
% x-y time series data set and compute a table of summary statistics of the
% peak intervals (the x-axis interval between adjacent detected peaks),
% heights, widths, and areas, listing the maximum, minimum, average, and
% percent standard deviation, and optionally displaying the x,t data plot
% with numbered peaks and the histograms of the peak intervals, heights,
% widths, and areas in figure window 2. Detects peaks by looking for
% downward zero-crossings in the first derivative that exceed
% SlopeThreshold. Returns peak statistics (PS) containing of the maximumn,
% minimum, mean, and percent standard deviation of the peak intervals,
% heights, widths, in a matrix. Arguments "slopeThreshold", "ampThreshold"
% and "smoothwidth" control peak sensitivity. Higher values will neglect
% smaller features. "Smoothwidth" is the width of the smooth applied before
% peak detection; larger values ignore narrow peaks. If smoothwidth=0, no
% smoothing is performed. "Peakgroup" is the number points around the top
% part of the peak that are taken for measurement. If Peakgroup=0 the local
% maximum is takes as the peak height and position.
% The optional argument "smoothtype" determines the smooth algorithm:
%   If smoothtype=1, rectangular (sliding-average or boxcar) If
%   smoothtype=2, triangular (2 passes of sliding-average) If smoothtype=3,
%   pseudo-Gaussian (3 passes of sliding-average)
% The optional last argument "displayit" =1 if the x,y data plot, numbered
% peaks, and peak statistics table and the histogtams are to be displayed,
% othersize not.
% See http://terpconnect.umd.edu/~toh/spectrum/Smoothing.html and
% http://terpconnect.umd.edu/~toh/spectrum/PeakFindingandMeasurement.htm
% T. C. O'Haver, 2013.  Version 1.1. Last revised December, 2013
%
% Examples:
% x=[0:.1:100];y=5+5.*cos(x)+randn(size(x));peakstats(x,y,0,-1,11,19,3,1);
% As above, but no display, and statistics table returned in matrix PS:
% x=[0:.01:5]';PS=peakstats(x,x.*sin(x.^2).^2,0,-1,5,5);
% x=[0:.1:100];y=5+5.*cos(x)+randn(size(x));PS=peakstats(x,y,0,-1,11,19,3);
% x=[0:.01:5]';peakstats(x',x.*sin(x.^2).^2,0,-1,5,5,1,1) display
% statistics table and histogram plots
%
% Related functions:
% findvalleys.m, findpeaksL.m, findpeaksb.m, findpeaksplot.m, findpeaks.m,
% findpeaksnr.m, findpeaksGSS.m, findpeaksLSS.m, findpeaksfit.m.

if nargin==6;smoothtype=1;displayit=0;end % smoothtype=1, displayit=0 if not specified in 7th argument
if nargin==7;displayit=0;end  % displayit=0 if not specified in 8th argument
if smoothtype>3;smoothtype=3;end
if smoothtype<1;smoothtype=1;end
smoothwidth=round(smoothwidth);
peakgroup=round(peakgroup);
if smoothwidth>1,
    d=fastsmooth(deriv(y),smoothwidth,smoothtype);
else
    d=y;
end
n=round(peakgroup/2+1);
P=[0 0 0 0 0];
vectorlength=length(y);
peak=1;
AmpTest=AmpThreshold;
for j=2*round(smoothwidth/2)-1:length(y)-smoothwidth,
    if sign(d(j)) > sign (d(j+1)), % Detects zero-crossing
        if d(j)-d(j+1) > SlopeThreshold*y(j), % if slope of derivative is larger than SlopeThreshold
            if y(j) > AmpTest,  % if height of peak is larger than AmpThreshold
                xx=zeros(size(peakgroup));yy=zeros(size(peakgroup));
                for k=1:peakgroup, % Create sub-group of points near peak
                    groupindex=j+k-n+2;
                    if groupindex<1, groupindex=1;end
                    if groupindex>vectorlength, groupindex=vectorlength;end
                    xx(k)=x(groupindex);yy(k)=y(groupindex);
                end
                if peakgroup>3,
                    [coef,S,MU]=polyfit(xx,rmnan(log(yy)),2);  % Fit parabola to log10 of sub-group with centering and scaling
                    c1=coef(3);c2=coef(2);c3=coef(1);
                    PeakX=-((MU(2).*c2/(2*c3))-MU(1));   % Compute peak position and height of fitted parabola
                    PeakY=exp(c1-c3*(c2/(2*c3))^2);
                    MeasuredWidth=norm(MU(2).*2.35482/(sqrt(2)*sqrt(-1*c3)));
                    % if the peak is too narrow for least-squares technique to work
                    % well, just use the max value of y in the sub-group of points near peak.
                else
                    PeakY=max(yy);
                    pindex=val2ind(yy,PeakY);
                    PeakX=xx(pindex(1));
                    MeasuredWidth=0;
                end
                % Construct matrix P. One row for each peak
                % detected, containing the peak number, peak
                % position (x-value) and peak height (y-value).
                % If peak measurements fails and results in NaN, skip this
                % peak
                if isnan(PeakX) || isnan(PeakY) || PeakY<AmpThreshold,
                    % Skip this peak
                else % Otherwiase count this as a valid peak
                    P(peak,:) = [round(peak) PeakX PeakY MeasuredWidth  1.0646.*PeakY*MeasuredWidth];
                    peak=peak+1; % Move on to next peak
                end
            end
        end
    end
end
PP=P;
%  "diff" is the vector of x-axis intervals between peaks.
diff=zeros(size(1:length(PP)-1));
for n=1:length(PP)-1;
    diff(n)=max(PP(n+1,2)-PP(n,2));
end
PS(1,:)=[max(diff);max(PP(:,3));max(PP(:,4));max(PP(:,5))];
PS(2,:)=[min(diff);min(PP(:,3));min(PP(:,4));min(PP(:,5))];
PS(3,:)=[mean(diff);mean(PP(:,3));mean(PP(:,4));mean(PP(:,5))];
PS(4,:)=[100.*std(diff)./mean(diff);100.*std(PP(:,3))./mean(PP(:,3));100.*std(PP(:,4))./mean(PP(:,4));100.*std(PP(:,5))./mean(PP(:,5))];
if displayit,
    plot(x,y)
    text(PP(:,2),PP(:,3),num2str(PP(:,1)))
    disp('Peak Summary Statistics')
    disp( [ num2str(length(P)) ' peaks detected' ] )
    disp('          Interval      Height      Width          Area')
    disp( [ 'Maximum    ' num2str(max(diff)) '       ' num2str(max(PP(:,3))) '       ' num2str(max(PP(:,4)))  '       ' num2str(max(PP(:,5)))  ])
    disp( [ 'Minimum    ' num2str(min(diff)) '       ' num2str(min(PP(:,3))) '       ' num2str(min(PP(:,4)))  '       ' num2str(min(PP(:,5)))  ])
    disp( [ 'Mean       ' num2str(mean(diff)) '       ' num2str(mean(PP(:,3))) '       ' num2str(mean(PP(:,4)))  '       ' num2str(mean(PP(:,5)))  ])
    disp( [ '% STD      ' num2str(100.*std(diff)./mean(diff)) '       ' num2str(100.*std(PP(:,3))./mean(PP(:,3))) '       ' num2str(100.*std(PP(:,4))./mean(PP(:,4)))  '       ' num2str(100.*std(PP(:,5))./mean(PP(:,5)))  ])
    figure(2);
    subplot(2,2,1);hist(diff);title('Histogram of intervals between peak positions')
    subplot(2,2,2);hist(PP(:,3));title('Histogram of peak heights')
    subplot(2,2,3);hist(PP(:,4));title('Histogram of Gaussian peak widths')
    subplot(2,2,4);hist(PP(:,5));title('Histogram of Gaussian peak areas')
end
% ----------------------------------------------------------------------
function [index,closestval]=val2ind(x,val)
% Returns the index and the value of the element of vector x that is closest to val
% If more than one element is equally close, returns vectors of indicies and values
% Tom O'Haver (toh@umd.edu) October 2006
% Examples: If x=[1 2 4 3 5 9 6 4 5 3 1], then val2ind(x,6)=7 and val2ind(x,5.1)=[5 9]
% [indices values]=val2ind(x,3.3) returns indices = [4 10] and values = [3 3]
dif=abs(x-val);
index=find((dif-min(dif))==0);
closestval=x(index);

function d=deriv(a)
% First derivative of vector using 2-point central difference.
%  T. C. O'Haver, 1988.
n=length(a);
d(1)=a(2)-a(1);
d(n)=a(n)-a(n-1);
for j = 2:n-1;
    d(j)=(a(j+1)-a(j-1)) ./ 2;
end

function SmoothY=fastsmooth(Y,w,type,ends)
% fastbsmooth(Y,w,type,ends) smooths vector Y with smooth
%  of width w. Version 2.0, May 2008.
% The argument "type" determines the smooth type:
%   If type=1, rectangular (sliding-average or boxcar)
%   If type=2, triangular (2 passes of sliding-average)
%   If type=3, pseudo-Gaussian (3 passes of sliding-average)
% The argument "ends" controls how the "ends" of the signal
% (the first w/2 points and the last w/2 points) are handled.
%   If ends=0, the ends are zero.  (In this mode the elapsed
%     time is independent of the smooth width). The fastest.
%   If ends=1, the ends are smoothed with progressively
%     smaller smooths the closer to the end. (In this mode the
%     elapsed time increases with increasing smooth widths).
% fastsmooth(Y,w,type) smooths with ends=0.
% fastsmooth(Y,w) smooths with type=1 and ends=0.
% Example:
% fastsmooth([1 1 1 10 10 10 1 1 1 1],3)= [0 1 4 7 10 7 4 1 1 0]
% fastsmooth([1 1 1 10 10 10 1 1 1 1],3,1,1)= [1 1 4 7 10 7 4 1 1 1]
%  T. C. O'Haver, May, 2008.
if nargin==2, ends=0; type=1; end
if nargin==3, ends=0; end
switch type
    case 1
        SmoothY=sa(Y,w,ends);
    case 2
        SmoothY=sa(sa(Y,w,ends),w,ends);
    case 3
        SmoothY=sa(sa(sa(Y,w,ends),w,ends),w,ends);
end

function SmoothY=sa(Y,smoothwidth,ends)
w=round(smoothwidth);
SumPoints=sum(Y(1:w));
s=zeros(size(Y));
halfw=round(w/2);
L=length(Y);
for k=1:L-w,
    s(k+halfw-1)=SumPoints;
    SumPoints=SumPoints-Y(k);
    SumPoints=SumPoints+Y(k+w);
end
s(k+halfw)=sum(Y(L-w+1:L));
SmoothY=s./w;
% Taper the ends of the signal if ends=1.
if ends==1,
    startpoint=(smoothwidth + 1)/2;
    SmoothY(1)=(Y(1)+Y(2))./2;
    for k=2:startpoint,
        SmoothY(k)=mean(Y(1:(2*k-1)));
        SmoothY(L-k+1)=mean(Y(L-2*k+2:L));
    end
    SmoothY(L)=(Y(L)+Y(L-1))./2;
end
% ----------------------------------------------------------------------
function a=rmnan(a)
% Removes NaNs and Infs from vectors, replacing with nearest real numbers.
% Example:
%  >> v=[1 2 3 4 Inf 6 7 Inf  9];
%  >> rmnan(v)
%  ans =
%     1     2     3     4     4     6     7     7     9
la=length(a);
if isnan(a(1)) || isinf(a(1)),a(1)=0;end
for point=1:la,
    if isnan(a(point)) || isinf(a(point)),
        a(point)=a(point-1);
    end
end
