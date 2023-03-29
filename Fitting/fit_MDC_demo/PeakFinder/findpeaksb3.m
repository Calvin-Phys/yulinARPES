function FPB=findpeaksb3(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype,PeakShape,extra,NumTrials,AUTOZERO,ShowPlots)
% function P=findpeaksb3(x,y,SlopeThreshold,AmpThreshold,smoothwidth,
% peakgroup,smoothtype,PeakShape,extra,NumTrials,AUTOZERO,ShowPlots)
% Function to locate and fit the positive peaks in a noisy x-y time series
% data set and fit each detected peak with 3 Gaussians, the two flanking
% Gaussians taken from the previous and next peaks found by prior
% application of findpeaks. Finds peaks by looking for downward
% zero-crossings in the first derivative that exceed SlopeThreshold.
% Returns a matrix of peak number, peak position, peak height, peak width,
% peak area, and the percent fitting error, for each peak detected.
% Version 1.1, January 2014
%
% Input arguments:
% "SlopeThreshold", "AmpThreshold" and "smoothwidth" control peak 
% sensitivity. Higher values will neglect smaller features.
%
% "smoothwidth" is the width of the smooth applied before peak detection;
% larger values ignore narrow peaks. If smoothwidth=0, no smoothing.
%
% "peakgroup" is the number points around the top part of the peak that are
% taken for thge initial estimation. If Peakgroup=0 the local maximum is
% takes as the peak height and position.
%
% "smoothtype" determines the smooth algorithm:
%   If smoothtype=1, rectangular (sliding-average or boxcar) 
%   If smoothtype=2, triangular (2 passes of sliding-average)
%   If smoothtype=3, pseudo-Gaussian (3 passes of sliding-average)
%
% "PeakShape" specifies the model peak shape: "peakshape" = 1-20.
% (1=Gaussian, 2=Lorentzian, 3=logistic, 4=Pearson, 5=exponentionally
% broadened Gaussian; 6=equal-width Gaussians; 7=Equal-width Lorentzians;
% 8=exponentionally broadened equal-width Gaussian, 9=exponential pulse,
% 10=sigmoid, 11=Fixed-width Gaussian, 12=Fixed-width Lorentzian;
% 13=Gaussian/Lorentzian blend; 14=BiGaussian, 15=BiLorentzian,
% 16=Fixed-position Gaussians; 17=Fixed-position Lorentzians;
% 18=exponentionally broadened Lorentzian; 19=alpha function; 20=Voigt.
%
% "extra" Specifies the value of 'extra', used only in the Voigt, Pearson,
% exponentionally broadened Gaussian, Gaussian/Lorentzian blend, and
% bifurcated Gaussian and Lorentzian shapes to fine-tune the peak shape.
%
% "NumTrials" sets the number of trial fits and selects the best one (with
% lowest itting error); can be any positive integer (default is 1).
%
% "AUTOZERO": 0 does not subtract baseline from data segment; 1 subtracts 
% interpolated linear baseline from data segment; 2 subtracts interpolated
% quadratic baseline from data segment; 3 subtracts flat baseline without
% reference to the data segment.
%
% "ShowPlots" 1 displays each fit graphically as it goes; 0 does not plot.
%
% See http://terpconnect.umd.edu/~toh/spectrum/Smoothing.html and 
% http://terpconnect.umd.edu/~toh/spectrum/PeakFindingandMeasurement.htm
%
% T. C. O'Haver, version 1, Jan. 2014
%
% Example: Four Lorentzians, heights=1, 2, 3, and 4, widths=3
% x=1:.2:100;
% y=modelpeaks(x,4,2,[1 2 3 4],[45 50 55 60],[3 3 3 3])+.02*randn(size(x));
% findpeaksresults=findpeaksplot(x,y,.00005,.5,9,12,3);
% findpeaksb3results=findpeaksb3(x,y,.00005,.5,9,12,3,2,0,10,0,0);
% disp('          Peak      Position      Height      Width        Area        % error')
% findpeaksresults
% findpeaksb3results

% Copyright (c) 2014, Thomas C. O'Haver
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

fixedparameters=0; % Used for fixed parameters shapes only (11,16,12,and 17)
plots=ShowPlots;
if smoothtype>3;smoothtype=3;end
if smoothtype<1;smoothtype=1;end
smoothwidth=round(smoothwidth);
peakgroup=round(peakgroup);
if ShowPlots,
    P=findpeaksplot(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype);
    drawnow;
else
    P=findpeaks(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype);
end
NumPeaks=size(P);
NumPeaks=NumPeaks(1);
PeakX=zeros(size(NumPeaks));
PeakY=zeros(size(NumPeaks));
MeasuredWidth=zeros(size(NumPeaks));
MeasuredArea=zeros(size(NumPeaks));
MeasuredError=zeros(size(NumPeaks));
for peak=1:NumPeaks;
    % Fit first peak
    if peak==1,
        x1=P(peak,2)-P(peak,4);
        x2=P(peak+1,2);
        startpoint=val2ind(x,x1);
        endpoint=val2ind(x,x2);
        XXX=x((startpoint):(endpoint));
        YYY=y((startpoint):(endpoint));
        signal=[XXX',YYY']; % Portion of the signal selected for fitting
        start=[P(peak,2) P(peak,4) P(peak+1,2) P(peak+1,4)];
        [FitResults,Error]=peakfit(signal,0,0,2,PeakShape,extra,NumTrials,start,AUTOZERO,fixedparameters,plots);
        if ShowPlots,drawnow;end
    end % peak=1
    % Fit intermediate peaks
    if peak>1,
        if peak<NumPeaks,
            x1=P(peak-1,2);
            x2=P(peak+1,2);
            startpoint=val2ind(x,x1);
            endpoint=val2ind(x,x2);
            XXX=x((startpoint):(endpoint));
            YYY=y((startpoint):(endpoint));
            signal=[XXX',YYY']; % Portion of the signal selected for fitting
            start=[P(peak-1,2) P(peak-1,4) P(peak,2) P(peak,4) P(peak+1,2) P(peak+1,4)];
            [FitResults,Error]=peakfit(signal,P(peak,2),2*(P(peak+1,2)-P(peak-1,2)),3,PeakShape,extra,NumTrials,start,AUTOZERO,fixedparameters,plots);
            if ShowPlots,drawnow;end
        end %  if peak<NumPeaks,
    end % if peak>1
    % Fit last peak
    if peak==NumPeaks,
        x1=P(peak-1,2);
        x2=P(peak,2)+P(peak,4);
        startpoint=val2ind(x,x1);
        endpoint=val2ind(x,x2);
        XXX=x((startpoint):(endpoint));
        YYY=y((startpoint):(endpoint));
        signal=[XXX',YYY']; % Portion of the signal selected for fitting
        start=[P(peak-1,2) P(peak-1,4) P(peak,2) P(peak,4)]; 
        [FitResults,Error]=peakfit(signal,P(peak,2),2*(max(XXX)-P(peak-1)),2,PeakShape,extra,NumTrials,start,AUTOZERO,fixedparameters,plots);
    if ShowPlots,drawnow;end
    end % if peak=NumPeaks
    % Assign FitResults to the result arrays PeakX, PeakY, MeasuredWidth,
    % MeasuredArea, and MeasuredError.
    CenterPeak=val2ind(FitResults(:,2),P(peak,2)); % find the peak number of the peak whose position is closest to each peak 
    PeakX(peak)=FitResults(CenterPeak(1),2); % Get the X value of that peak
    PeakY(peak)=FitResults(CenterPeak(1),3); % and the Y value
    MeasuredWidth(peak)=FitResults(CenterPeak(1),4); % and the width.
    MeasuredArea(peak)=FitResults(CenterPeak(1),5); % and the area.
    MeasuredError(peak)=Error; % and the fitting error
    % PeakNumber=peak % for testing
end % for peak=1:NumPeaks;
% Assemble result arrays into a matrix and return to calling routine.
 FPB=[1:NumPeaks;PeakX;PeakY;MeasuredWidth;MeasuredArea;MeasuredError]';
% end of function
% -----------------------internal functions--------------------------------
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
  
  function P=findpeaks(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype)
% function P=findpeaks(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype)
% Function to locate the positive peaks in a noisy x-y time series data
% set.  Detects peaks by looking for downward zero-crossings
% in the first derivative that exceed SlopeThreshold.
% Returns list (P) containing peak number and position, 
% height, width, and area of each peak. Arguments "slopeThreshold",
% "ampThreshold" and "smoothwidth" control peak sensitivity.
% Higher values will neglect smaller features. "Smoothwidth" is
% the width of the smooth applied before peak detection; larger
% values ignore narrow peaks. If smoothwidth=0, no smoothing
% is performed. "Peakgroup" is the number points around the top 
% part of the peak that are taken for measurement. If Peakgroup=0
% the local maximum is takes as the peak height and position.
% The argument "smoothtype" determines the smooth algorithm:
%   If smoothtype=1, rectangular (sliding-average or boxcar) 
%   If smoothtype=2, triangular (2 passes of sliding-average)
%   If smoothtype=3, pseudo-Gaussian (3 passes of sliding-average)
% See http://terpconnect.umd.edu/~toh/spectrum/Smoothing.html and 
% http://terpconnect.umd.edu/~toh/spectrum/PeakFindingandMeasurement.htm
% T. C. O'Haver, 1995.  Version 5.1, Last revised December, 2012
% Skip peaks if peak measurement results in NaN values
% Examples:
% findpeaks(0:.01:2,humps(0:.01:2),0,-1,5,5)
% x=[0:.01:50];findpeaks(x,cos(x),0,-1,5,5)
% x=[0:.01:5]';findpeaks(x,x.*sin(x.^2).^2,0,-1,5,5)

% Copyright (c) 2013, Thomas C. O'Haver
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
% 
if nargin~=7;smoothtype=1;end  % smoothtype=1 if not specified in argument
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
                    groupindex=j+k-n+1;
                    if groupindex<1, groupindex=1;end
                    if groupindex>vectorlength, groupindex=vectorlength;end
                    xx(k)=x(groupindex);yy(k)=y(groupindex);
                end
                if peakgroup>3,
                    [coef,S,MU]=polyfit(xx,log(abs(yy)),2);  % Fit parabola to log10 of sub-group with centering and scaling
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
  
function [FitResults,LowestError,BestStart,xi,yi,BootResults]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials,start,autozero,fixedparameters,plots)
% Version 4.21: November, 2013. Added voigt profile shape. 
global AA xxx PEAKHEIGHTS FIXEDWIDTH FIXEDPOSITIONS AUTOZERO

format short g
format compact
warning off all

NumArgOut=nargout;
datasize=size(signal);
if datasize(1)<datasize(2),signal=signal';end
datasize=size(signal);
if datasize(2)==1, %  Must be isignal(Y-vector)
    X=1:length(signal); % Create an independent variable vector
    Y=signal;
else
    % Must be isignal(DataMatrix)
    X=signal(:,1); % Split matrix argument 
    Y=signal(:,2);
end
X=reshape(X,1,length(X)); % Adjust X and Y vector shape to 1 x n (rather than n x 1)
Y=reshape(Y,1,length(Y));
% If necessary, flip the data vectors so that X increases
if X(1)>X(length(X)),
    disp('X-axis flipped.')
    X=fliplr(X);
    Y=fliplr(Y);
end

% Isolate desired segment from data set for curve fitting
if nargin==1 || nargin==2,center=(max(X)-min(X))/2;window=max(X)-min(X);end
% Y=Y-min(Y);
xoffset=0;
n1=val2ind(X,center-window/2);
n2=val2ind(X,center+window/2);
if window==0,n1=1;n2=length(X);end
xx=X(n1:n2)-xoffset;
yy=Y(n1:n2);
ShapeString='Gaussian';

% Define values of any missing arguments
switch nargin
    case 1
        NumPeaks=1;
        peakshape=1;
        extra=0;
        NumTrials=1;
        xx=X;yy=Y;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        plots=1;
    case 2
        NumPeaks=1;
        peakshape=1;
        extra=0;
        NumTrials=1;
        xx=signal;yy=center;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        plots=1;
    case 3
        NumPeaks=1;
        peakshape=1;
        extra=0;
        NumTrials=1;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
    case 4
        peakshape=1;
        extra=0;
        NumTrials=1;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
    case 5
        extra=0;
        NumTrials=1;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
    case 6
        NumTrials=1;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
    case 7
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
    case 8
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
    case 9
        AUTOZERO=autozero;
        FIXEDWIDTH=0;
        plots=1;
    case 10
        AUTOZERO=autozero;
        FIXEDWIDTH=fixedparameters;
        plots=1;
    case 11
        AUTOZERO=autozero;
        FIXEDWIDTH=fixedparameters;
    otherwise
end % switch nargin

% Default values for placeholder zeros
if NumTrials==0;NumTrials=1;end
if peakshape==0;peakshape=1;end
if NumPeaks==0;NumPeaks=1;end
if start==0;start=calcstart(xx,NumPeaks,xoffset);end
if FIXEDWIDTH==0, FIXEDWIDTH=length(xx)/10;end
if peakshape==16;FIXEDPOSITIONS=fixedparameters;end
if AUTOZERO>3,AUTOZERO=3;,end
if AUTOZERO<0,AUTOZERO=0;,end

% Remove linear baseline from data segment if AUTOZERO==1
bkgsize=round(length(xx)/10);
if bkgsize<2,bkgsize=2;end
lxx=length(xx);
if AUTOZERO==1, % linear autozero operation  
    XX1=xx(1:round(lxx/bkgsize));
    XX2=xx((lxx-round(lxx/bkgsize)):lxx);
    Y1=yy(1:(round(length(xx)/bkgsize)));
    Y2=yy((lxx-round(lxx/bkgsize)):lxx);
    bkgcoef=polyfit([XX1,XX2],[Y1,Y2],1);  % Fit straight line to sub-group of points
    bkg=polyval(bkgcoef,xx);
    yy=yy-bkg;
end % if
if AUTOZERO==2, % Quadratic autozero operation  
    XX1=xx(1:round(lxx/bkgsize));
    XX2=xx((lxx-round(lxx/bkgsize)):lxx);
    Y1=yy(1:round(length(xx)/bkgsize));
    Y2=yy((lxx-round(lxx/bkgsize)):lxx);
    bkgcoef=polyfit([XX1,XX2],[Y1,Y2],2);  % Fit parabola to sub-group of points
    bkg=polyval(bkgcoef,xx);
    yy=yy-bkg;
end % if autozero

PEAKHEIGHTS=zeros(1,NumPeaks);
n=length(xx);
newstart=start;

% Assign ShapStrings
switch peakshape
    case 1
        ShapeString='Gaussian';
    case 2
        ShapeString='Lorentzian';
    case 3
        ShapeString='Logistic';
    case 4
        ShapeString='Pearson';
    case 5
        ShapeString='ExpGaussian';
    case 6
        ShapeString='Equal width Gaussians';
    case 7
        ShapeString='Equal width Lorentzians';
    case 8
        ShapeString='Exp. equal width Gaussians';
    case 9
        ShapeString='Exponential Pulse';
    case 10
        ShapeString='Sigmoid';
    case 11
        ShapeString='Fixed-width Gaussian';
    case 12
        ShapeString='Fixed-width Lorentzian';
    case 13
        ShapeString='Gaussian/Lorentzian blend';
    case 14
        ShapeString='BiGaussian';    
    case 15
        ShapeString='BiLorentzian';   
    case 16
        ShapeString='Fixed-position Gaussians';
    case 17
        ShapeString='Fixed-position Lorentzians';
    case 18
        ShapeString='Exp. Lorentzian';
    case 19
        ShapeString='Alpha function';
    case 20
        ShapeString='Voigt profile';
    otherwise
end % switch peakshape
  
% Perform peak fitting for selected peak shape using fminsearch function
options = optimset('TolX',.001,'Display','off','MaxFunEvals',200 );
LowestError=1000; % or any big number greater than largest error expected
FitParameters=zeros(1,NumPeaks.*2); 
BestStart=zeros(1,NumPeaks.*2); 
height=zeros(1,NumPeaks); 
bestmodel=zeros(size(yy));
for k=1:NumTrials, 
    % disp(['Trial number ' num2str(k) ] ) % optionally prints the current trial number as progress indicator
  switch peakshape
    case 1
        TrialParameters=fminsearch(@(lambda)(fitgaussian(lambda,xx,yy)),newstart,options);
    case 2
        TrialParameters=fminsearch(@(lambda)(fitlorentzian(lambda,xx,yy)),newstart,options);
    case 3
        TrialParameters=fminsearch(@(lambda)(fitlogistic(lambda,xx,yy)),newstart,options);
    case 4
        TrialParameters=fminsearch(@(lambda)(fitpearson(lambda,xx,yy,extra)),newstart,options);
    case 5
        zxx=[zeros(size(xx)) xx zeros(size(xx)) ];
        zyy=[zeros(size(yy)) yy zeros(size(yy)) ];
        TrialParameters=fminsearch(@(lambda)(fitexpgaussian(lambda,zxx,zyy,-extra)),newstart,options);
    case 6
        cwnewstart(1)=newstart(1);
        for pc=2:NumPeaks,
            cwnewstart(pc)=newstart(2.*pc-1);  
        end
        cwnewstart(NumPeaks+1)=(max(xx)-min(xx))/5;
        TrialParameters=fminsearch(@(lambda)(fitewgaussian(lambda,xx,yy)),cwnewstart,options);
    case 7
        cwnewstart(1)=newstart(1);
        for pc=2:NumPeaks,
            cwnewstart(pc)=newstart(2.*pc-1);  
        end
        cwnewstart(NumPeaks+1)=(max(xx)-min(xx))/5;
        TrialParameters=fminsearch(@(lambda)(fitlorentziancw(lambda,xx,yy)),cwnewstart,options);
    case 8
        cwnewstart(1)=newstart(1);
        for pc=2:NumPeaks,
            cwnewstart(pc)=newstart(2.*pc-1);  
        end
        cwnewstart(NumPeaks+1)=(max(xx)-min(xx))/5;
        TrialParameters=fminsearch(@(lambda)(fitexpewgaussian(lambda,xx,yy,-extra)),cwnewstart,options);
      case 9
          TrialParameters=fminsearch(@(lambda)(fitexppulse(lambda,xx,yy)),newstart,options);
      case 10
          TrialParameters=fminsearch(@(lambda)(fitsigmoid(lambda,xx,yy)),newstart,options);
      case 11
          fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=min(xx)+pc.*(max(xx)-min(xx))./(NumPeaks+1);
          end
          TrialParameters=fminsearch(@(lambda)(FitFWGaussian(lambda,xx,yy)),fixedstart);
      case 12
          fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=min(xx)+pc.*(max(xx)-min(xx))./(NumPeaks+1);
          end
          TrialParameters=fminsearch(@(lambda)(FitFWLorentzian(lambda,xx,yy)),fixedstart);
      case 13
          TrialParameters=fminsearch(@(lambda)(fitGL(lambda,xx,yy,extra)),newstart,options);
      case 14
          TrialParameters=fminsearch(@(lambda)(fitBiGaussian(lambda,xx,yy,extra)),newstart,options);
      case 15
          TrialParameters=fminsearch(@(lambda)(fitBiLorentzian(lambda,xx,yy,extra)),newstart,options);
      case 16
           fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=(max(xx)-min(xx))./(NumPeaks+1);
              fixedstart(pc)=fixedstart(pc)+.1*randn().*fixedstart(pc);
          end
          TrialParameters=fminsearch(@(lambda)(FitFPGaussian(lambda,xx,yy)),fixedstart,options);
      case 17
           fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=(max(xx)-min(xx))./(NumPeaks+1);
              fixedstart(pc)=fixedstart(pc)+.1*randn().*fixedstart(pc);
          end
          TrialParameters=fminsearch(@(lambda)(FitFPLorentzian(lambda,xx,yy)),fixedstart,options);
      case 18
        zxx=[zeros(size(xx)) xx zeros(size(xx)) ];
        zyy=[ones(size(yy)).*yy(1) yy zeros(size(yy)).*yy(length(yy)) ];
%         plot(zxx,zyy);
        TrialParameters=fminsearch(@(lambda)(fitexplorentzian(lambda,zxx,zyy,-extra)),newstart,options);     
      case 19
          TrialParameters=fminsearch(@(lambda)(fitalphafunction(lambda,xx,yy)),newstart,options);
      case 20
          % extra=extra+.2*randn().*extra;
          TrialParameters=fminsearch(@(lambda)(fitvoigt(lambda,xx,yy,extra)),newstart,options);
      otherwise
  end % switch peakshape
  
% Construct model from Trial parameters
A=zeros(NumPeaks,n);
for m=1:NumPeaks,
    switch peakshape
        case 1
            A(m,:)=gaussian(xx,TrialParameters(2*m-1),TrialParameters(2*m));
        case 2
            A(m,:)=lorentzian(xx,TrialParameters(2*m-1),TrialParameters(2*m));
        case 3
            A(m,:)=logistic(xx,TrialParameters(2*m-1),TrialParameters(2*m));
        case 4
            A(m,:)=pearson(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);
        case 5
            A(m,:)=expgaussian(xx,TrialParameters(2*m-1),TrialParameters(2*m),-extra)';
        case 6
            A(m,:)=gaussian(xx,TrialParameters(m),TrialParameters(NumPeaks+1));
        case 7
            A(m,:)=lorentzian(xx,TrialParameters(m),TrialParameters(NumPeaks+1));
        case 8
            A(m,:)=expgaussian(xx,TrialParameters(m),TrialParameters(NumPeaks+1),-extra)';
        case 9
            A(m,:)=exppulse(xx,TrialParameters(2*m-1),TrialParameters(2*m));
        case 10
            A(m,:)=sigmoid(xx,TrialParameters(2*m-1),TrialParameters(2*m));
        case 11
            A(m,:)=gaussian(xx,TrialParameters(m),FIXEDWIDTH);
        case 12
            A(m,:)=lorentzian(xx,TrialParameters(m),FIXEDWIDTH);
        case 13
            A(m,:)=GL(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);
        case 14
            A(m,:)=BiGaussian(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);
        case 15
            A(m,:)=BiLorentzian(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);        
        case 16
            A(m,:)=gaussian(xx,FIXEDPOSITIONS(m),TrialParameters(m));
        case 17
            A(m,:)=lorentzian(xx,FIXEDPOSITIONS(m),TrialParameters(m));
        case 18
            A(m,:)=explorentzian(xx,TrialParameters(2*m-1),TrialParameters(2*m),-extra)';
        case 19
            A(m,:)=alphafunction(xx,TrialParameters(2*m-1),TrialParameters(2*m));
        case 20
            A(m,:)=voigt(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);        
        otherwise
    end % switch
    for parameter=1:2:2*NumPeaks,
        newstart(parameter)=newstart(parameter)*(1+randn/50);
        newstart(parameter+1)=newstart(parameter+1)*(1+randn/10);
    end
end % for

% Multiplies each row by the corresponding amplitude and adds them up
if AUTOZERO==3,
    baseline=PEAKHEIGHTS(1);
    Heights=PEAKHEIGHTS(2:1+NumPeaks);
    model=Heights'*A+baseline;
else
    model=PEAKHEIGHTS'*A;
    Heights=PEAKHEIGHTS;
    baseline=0;
end

% Compare trial model to data segment and compute the fit error
  MeanFitError=100*norm(yy-model)./(sqrt(n)*max(yy));
  % Take only the single fit that has the lowest MeanFitError
  if MeanFitError<LowestError, 
      if min(Heights)>=0,  % Consider only fits with positive peak heights
        LowestError=MeanFitError;  % Assign LowestError to the lowest MeanFitError
        FitParameters=TrialParameters;  % Assign FitParameters to the fit with the lowest MeanFitError
        BestStart=newstart; % Assign BestStart to the start with the lowest MeanFitError
        height=Heights; % Assign height to the PEAKHEIGHTS with the lowest MeanFitError
        bestmodel=model; % Assign bestmodel to the model with the lowest MeanFitError
      end % if min(PEAKHEIGHTS)>0
  end % if MeanFitError<LowestError
end % for k (NumTrials)
%
% Construct model from best-fit parameters
AA=zeros(NumPeaks,600);
xxx=linspace(min(xx),max(xx),600);
% xxx=linspace(min(xx)-length(xx),max(xx)+length(xx),200);
for m=1:NumPeaks,
   switch peakshape
    case 1
        AA(m,:)=gaussian(xxx,FitParameters(2*m-1),FitParameters(2*m));
    case 2
        AA(m,:)=lorentzian(xxx,FitParameters(2*m-1),FitParameters(2*m));
    case 3
        AA(m,:)=logistic(xxx,FitParameters(2*m-1),FitParameters(2*m));
    case 4
        AA(m,:)=pearson(xxx,FitParameters(2*m-1),FitParameters(2*m),extra);
    case 5
        AA(m,:)=expgaussian(xxx,FitParameters(2*m-1),FitParameters(2*m),-extra*length(xxx)./length(xx))';
    case 6
        AA(m,:)=gaussian(xxx,FitParameters(m),FitParameters(NumPeaks+1));
    case 7
        AA(m,:)=lorentzian(xxx,FitParameters(m),FitParameters(NumPeaks+1));
    case 8
        AA(m,:)=expgaussian(xxx,FitParameters(m),FitParameters(NumPeaks+1),-extra*length(xxx)./length(xx))';
    case 9
        AA(m,:)=exppulse(xxx,FitParameters(2*m-1),FitParameters(2*m));  
    case 10
        AA(m,:)=sigmoid(xxx,FitParameters(2*m-1),FitParameters(2*m));   
    case 11
        AA(m,:)=gaussian(xxx,FitParameters(m),FIXEDWIDTH);
    case 12
        AA(m,:)=lorentzian(xxx,FitParameters(m),FIXEDWIDTH);
    case 13
        AA(m,:)=GL(xxx,FitParameters(2*m-1),FitParameters(2*m),extra);
    case 14
        AA(m,:)=BiGaussian(xxx,FitParameters(2*m-1),FitParameters(2*m),extra);       
    case 15
        AA(m,:)=BiLorentzian(xxx,FitParameters(2*m-1),FitParameters(2*m),extra);       
    case 16
        AA(m,:)=gaussian(xxx,FIXEDPOSITIONS(m),FitParameters(m));
    case 17
        AA(m,:)=lorentzian(xxx,FIXEDPOSITIONS(m),FitParameters(m));
    case 18
        AA(m,:)=explorentzian(xxx,FitParameters(2*m-1),FitParameters(2*m),-extra*length(xxx)./length(xx))';
    case 19
        AA(m,:)=alphafunction(xxx,FitParameters(2*m-1),FitParameters(2*m));
    case 20
        AA(m,:)=voigt(xxx,FitParameters(2*m-1),FitParameters(2*m),extra);       
       otherwise
  end % switch
end % for

% Multiplies each row by the corresponding amplitude and adds them up
heightsize=size(height');
AAsize=size(AA);
if heightsize(2)==AAsize(1),
   mmodel=height'*AA+baseline;
else
    mmodel=height*AA+baseline;
end
% Top half of the figure shows original signal and the fitted model.
if plots,
    subplot(2,1,1);plot(xx+xoffset,yy,'b.'); % Plot the original signal in blue dots
    hold on
end
for m=1:NumPeaks,
    if plots, plot(xxx+xoffset,height(m)*AA(m,:)+baseline,'g'),end  % Plot the individual component peaks in green lines
    area(m)=trapz(xxx+xoffset,height(m)*AA(m,:)); % Compute the area of each component peak using trapezoidal method
    yi(m,:)=height(m)*AA(m,:); % (NEW) Place y values of individual model peaks into matrix yi
end
xi=xxx+xoffset; % (NEW) Place the x-values of the individual model peaks into xi

if plots,
    % Mark starting peak positions with vertical dashed lines
    if peakshape==16||peakshape==17
    else
        for marker=1:NumPeaks,
            markx=BestStart((2*marker)-1);
            subplot(2,1,1);plot([markx+xoffset markx+xoffset],[0 max(yy)],'m--')
        end % for
    end % if peakshape
    plot(xxx+xoffset,mmodel,'r');  % Plot the total model (sum of component peaks) in red lines
    hold off;
    axis([min(xx)+xoffset max(xx)+xoffset min(yy) max(yy)]);
    switch AUTOZERO,
        case 0
            title('peakfit 4.2   No baseline correction')
        case 1
            title('peakfit 4.2   Linear baseline subtraction')
        case 2
            title('peakfit 4.2   Quadratic subtraction baseline')
        case 3
            title('peakfit 4.2   Flat baseline correction')
    end
 
    switch peakshape
    case {4,20}
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '     Error = ' num2str(round(100*LowestError)/100) '%     Shape Constant = ' num2str(extra) ] )
    case {5,8,18}
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '     Error = ' num2str(round(100*LowestError)/100) '%     Time Constant = ' num2str(extra) ] )
    case 13
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '     Error = ' num2str(round(100*LowestError)/100) '%     % Gaussian = ' num2str(extra) ] )
    case {14,15}
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '     Error = ' num2str(round(100*LowestError)/100) '%     Asymmetry = ' num2str(extra) ] )
    otherwise
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '     Error = ' num2str(round(100*LowestError)/100) '% ' ] )
    end

    % Bottom half of the figure shows the residuals and displays RMS error
    % between original signal and model
    residual=yy-bestmodel;
    subplot(2,1,2);plot(xx+xoffset,residual,'b.')
    axis([min(xx)+xoffset max(xx)+xoffset min(residual) max(residual)]);
    xlabel('Residual Plot')
end % if plots

% Put results into a matrix, one row for each peak, showing peak index number,
% position, amplitude, and width.
for m=1:NumPeaks,
    if m==1,
        if peakshape==6||peakshape==7||peakshape==8, % equal-width peak models only
            FitResults=[[round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
            if peakshape==11||peakshape==12, % Fixed-width shapes only
                FitResults=[[round(m) FitParameters(m)+xoffset height(m) FIXEDWIDTH area(m)]];
            else
                if peakshape==16||peakshape==17, % Fixed-position shapes only
                    FitResults=[round(m) FIXEDPOSITIONS(m) height(m) FitParameters(m) area(m)];
                else
                    FitResults=[round(m) FitParameters(2*m-1)+xoffset height(m) abs(FitParameters(2*m)) area(m)];
                end
            end
        end % if peakshape
    else
        if peakshape==6||peakshape==7||peakshape==8, % equal-width peak models only
            FitResults=[FitResults ; [round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
            if peakshape==11||peakshape==12, % Fixed-width shapes only
                FitResults=[FitResults ; [round(m) FitParameters(m)+xoffset height(m) FIXEDWIDTH area(m)]];
            else
                if peakshape==16||peakshape==17, % Fixed-position shapes only
                    FitResults=[FitResults ; [round(m) FIXEDPOSITIONS(m) height(m) FitParameters(m) area(m)]];
                else
                    FitResults=[FitResults ; [round(m) FitParameters(2*m-1)+xoffset height(m) abs(FitParameters(2*m)) area(m)]];
                end
            end
        end % if peakshape
    end % m==1
end % for m=1:NumPeaks
% Display Fit Results on upper graph
if plots,
    subplot(2,1,1);
    startx=min(xx)+xoffset+(max(xx)-min(xx))./20;
    dxx=(max(xx)-min(xx))./10;
    dyy=(max(yy)-min(yy))./10;
    starty=max(yy)-dyy;
    FigureSize=get(gcf,'Position');
    if peakshape==9||peakshape==10||peakshape==19,  % Pulse and sigmoid shapes only
        text(startx,starty+dyy/2,['Peak #          tau1           Height           tau2             Area'] );
    else
        text(startx,starty+dyy/2,['Peak #          Position        Height         Width             Area'] );
    end
    % Display FitResults using sprintf
    for peaknumber=1:NumPeaks,
        for column=1:5,
            itemstring=sprintf('%0.4g',FitResults(peaknumber,column));
            xposition=startx+(1.7.*dxx.*(column-1).*(600./FigureSize(3)));
            yposition=starty-peaknumber.*dyy.*(400./FigureSize(4));
            text(xposition,yposition,itemstring);
        end
    end
    xposition=startx;
    yposition=starty-(peaknumber+1).*dyy.*(400./FigureSize(4));
    if AUTOZERO==3,
       text(xposition,yposition,[ 'Baseline= ' num2str(baseline) ]);
    end
end % if plots

if NumArgOut==6,
    if plots,disp('Computing bootstrap sampling statistics.....'),end
    BootstrapResultsMatrix=zeros(5,100,NumPeaks);
    BootstrapErrorMatrix=zeros(1,100,NumPeaks);
    clear bx by
    tic;
    for trial=1:100,
        n=1;
        bx=xx;
        by=yy;
        while n<length(xx)-1,
            if rand>.5,
                bx(n)=xx(n+1);
                by(n)=yy(n+1);
            end
            n=n+1;
        end
        bx=bx+xoffset;
        [FitResults,BootFitError]=fitpeaks(bx,by,NumPeaks,peakshape,extra,NumTrials,start,AUTOZERO,FIXEDWIDTH);
        for peak=1:NumPeaks,
            BootstrapResultsMatrix(:,trial,peak)=FitResults(peak,:);
            BootstrapErrorMatrix(:,trial,peak)=BootFitError;
        end
    end
    if plots,toc;end
    for peak=1:NumPeaks,
        if plots,
            disp(' ')
            disp(['Peak #',num2str(peak) '         Position    Height       Width       Area']);
        end % if plots
        BootstrapMean=mean(real(BootstrapResultsMatrix(:,:,peak)'));
        BootstrapSTD=std(BootstrapResultsMatrix(:,:,peak)');
        BootstrapIQR=iqr(BootstrapResultsMatrix(:,:,peak)');
        PercentRSD=100.*BootstrapSTD./BootstrapMean;
        PercentIQR=100.*BootstrapIQR./BootstrapMean;
        BootstrapMean=BootstrapMean(2:5);
        BootstrapSTD=BootstrapSTD(2:5);
        BootstrapIQR=BootstrapIQR(2:5);
        PercentRSD=PercentRSD(2:5);
        PercentIQR=PercentIQR(2:5);
        if plots,
            disp(['Bootstrap Mean: ', num2str(BootstrapMean)])
            disp(['Bootstrap STD:  ', num2str(BootstrapSTD)])
            disp(['Bootstrap IQR:  ', num2str(BootstrapIQR)])
            disp(['Percent RSD:    ', num2str(PercentRSD)])
            disp(['Percent IQR:    ', num2str(PercentIQR)])
        end % if plots
        BootResults(peak,:)=[BootstrapMean BootstrapSTD PercentRSD BootstrapIQR PercentIQR];
    end % peak=1:NumPeaks,
end % if NumArgOut==6,
% ----------------------------------------------------------------------
function [FitResults,LowestError]=fitpeaks(xx,yy,NumPeaks,peakshape,extra,NumTrials,start,AUTOZERO,fixedparameters)
% Based on peakfit Version 3: June, 2012. 
global PEAKHEIGHTS FIXEDWIDTH FIXEDPOSITIONS AUTOZERO
format short g
format compact
warning off all
FIXEDWIDTH=fixedparameters;
xoffset=0;
if start==0;start=calcstart(xx,NumPeaks,xoffset);end
PEAKHEIGHTS=zeros(1,NumPeaks);
n=length(xx);
newstart=start;

for peaks=1:NumPeaks,
     peakindex=2*peaks-1;
     newstart(peakindex)=start(peakindex)-xoffset;
end

% Perform peak fitting for selected peak shape using fminsearch function
options = optimset('TolX',.001,'Display','off','MaxFunEvals',200 );
LowestError=1000; % or any big number greater than largest error expected
FitParameters=zeros(1,NumPeaks.*2); 
BestStart=zeros(1,NumPeaks.*2); 
height=zeros(1,NumPeaks); 
bestmodel=zeros(size(yy));
for k=1:NumTrials, 
  switch peakshape
    case 1
        TrialParameters=fminsearch(@(lambda)(fitgaussian(lambda,xx,yy)),newstart);
    case 2
        TrialParameters=fminsearch(@(lambda)(fitlorentzian(lambda,xx,yy)),newstart);
    case 3
        TrialParameters=fminsearch(@(lambda)(fitlogistic(lambda,xx,yy)),newstart);
    case 4
        TrialParameters=fminsearch(@(lambda)(fitpearson(lambda,xx,yy,extra)),newstart);
    case 5
        zxx=[zeros(size(xx)) xx zeros(size(xx)) ];
        zyy=[zeros(size(yy)) yy zeros(size(yy)) ];
        TrialParameters=fminsearch(@(lambda)(fitexpgaussian(lambda,zxx,zyy,-extra)),newstart);
    case 6
        cwnewstart(1)=newstart(1);
        for pc=2:NumPeaks,
            cwnewstart(pc)=newstart(2.*pc-1);  
        end
        cwnewstart(NumPeaks+1)=(max(xx)-min(xx))/5;
        TrialParameters=fminsearch(@(lambda)(fitewgaussian(lambda,xx,yy)),cwnewstart);
    case 7
        cwnewstart(1)=newstart(1);
        for pc=2:NumPeaks,
            cwnewstart(pc)=newstart(2.*pc-1);  
        end
        cwnewstart(NumPeaks+1)=(max(xx)-min(xx))/5;
        TrialParameters=fminsearch(@(lambda)(fitlorentziancw(lambda,xx,yy)),cwnewstart);
    case 8
        cwnewstart(1)=newstart(1);
        for pc=2:NumPeaks,
            cwnewstart(pc)=newstart(2.*pc-1);  
        end
        cwnewstart(NumPeaks+1)=(max(xx)-min(xx))/5;
        TrialParameters=fminsearch(@(lambda)(fitexpewgaussian(lambda,xx,yy,-extra)),cwnewstart);
      case 9
          TrialParameters=fminsearch(@(lambda)(fitexppulse(lambda,xx,yy)),newstart);
      case 10
          TrialParameters=fminsearch(@(lambda)(fitsigmoid(lambda,xx,yy)),newstart);
      case 11
          fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=min(xx)+pc.*(max(xx)-min(xx))./(NumPeaks+1);
          end
          TrialParameters=fminsearch(@(lambda)(FitFWGaussian(lambda,xx,yy)),fixedstart);
      case 12
          fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=min(xx)+pc.*(max(xx)-min(xx))./(NumPeaks+1);
          end
          TrialParameters=fminsearch(@(lambda)(FitFWLorentzian(lambda,xx,yy)),fixedstart);
      case 13
          TrialParameters=fminsearch(@(lambda)(fitGL(lambda,xx,yy,extra)),newstart);
      case 14
          TrialParameters=fminsearch(@(lambda)(fitBiGaussian(lambda,xx,yy,extra)),newstart);
      case 15
          TrialParameters=fminsearch(@(lambda)(fitBiLorentzian(lambda,xx,yy,extra)),newstart);
      case 16
          fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=(max(xx)-min(xx))./(NumPeaks+1);
          end
          TrialParameters=fminsearch(@(lambda)(FitFPGaussian(lambda,xx,yy)),fixedstart);
      case 17
          fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=(max(xx)-min(xx))./(NumPeaks+1);
          end
          TrialParameters=fminsearch(@(lambda)(FitFPLorentzian(lambda,xx,yy)),fixedstar);
      case 18
        zxx=[zeros(size(xx)) xx zeros(size(xx)) ];
        zyy=[zeros(size(yy)) yy zeros(size(yy)) ];
        TrialParameters=fminsearch(@(lambda)(fitlorentzian(lambda,zxx,zyy,-extra)),newstart);
      case 19
          TrialParameters=fminsearch(@(lambda)(alphafunction(lambda,xx,yy)),newstart);
      case 20
        % extra=extra+.2*randn().*extra;
        TrialParameters=fminsearch(@(lambda)(fitvoigt(lambda,xx,yy,extra)),newstart);
      otherwise
  end % switch peakshape
  
% Construct model from Trial parameters
A=zeros(NumPeaks,n);
for m=1:NumPeaks,
   switch peakshape
    case 1
        A(m,:)=gaussian(xx,TrialParameters(2*m-1),TrialParameters(2*m));
    case 2
        A(m,:)=lorentzian(xx,TrialParameters(2*m-1),TrialParameters(2*m));
    case 3
        A(m,:)=logistic(xx,TrialParameters(2*m-1),TrialParameters(2*m));
    case 4
        A(m,:)=pearson(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);
    case 5
        A(m,:)=expgaussian(xx,TrialParameters(2*m-1),TrialParameters(2*m),-extra)';
    case 6
        A(m,:)=gaussian(xx,TrialParameters(m),TrialParameters(NumPeaks+1));
    case 7
        A(m,:)=lorentzian(xx,TrialParameters(m),TrialParameters(NumPeaks+1));  
    case 8
        A(m,:)=expgaussian(xx,TrialParameters(m),TrialParameters(NumPeaks+1),-extra)';    
    case 9
        A(m,:)=exppulse(xx,TrialParameters(2*m-1),TrialParameters(2*m));  
    case 10
        A(m,:)=sigmoid(xx,TrialParameters(2*m-1),TrialParameters(2*m)); 
    case 11
        A(m,:)=gaussian(xx,TrialParameters(m),FIXEDWIDTH);
    case 12
        A(m,:)=lorentzian(xx,TrialParameters(m),FIXEDWIDTH); 
    case 13
        A(m,:)=GL(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);
    case 14
        A(m,:)=BiGaussian(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);       
    case 15
        A(m,:)=BiLorentzian(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);       
    case 16
        A(m,:)=gaussian(xx,FIXEDPOSITIONS(m),TrialParameters(m));
    case 17
        A(m,:)=lorentzian(xx,FIXEDPOSITIONS(m),TrialParameters(m));
    case 18
        A(m,:)=explorentzian(xx,TrialParameters(2*m-1),TrialParameters(2*m),-extra)';
    case 19
        A(m,:)=alphafunction(xx,TrialParameters(2*m-1),TrialParameters(2*m)); 
    case 20
        A(m,:)=voigt(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra); 
   end % switch
    for parameter=1:2:2*NumPeaks,
        newstart(parameter)=newstart(parameter)*(1+randn/50);
        newstart(parameter+1)=newstart(parameter+1)*(1+randn/10);
    end
end % for

% Multiplies each row by the corresponding amplitude and adds them up
if AUTOZERO==3,
    baseline=PEAKHEIGHTS(1);
    Heights=PEAKHEIGHTS(2:1+NumPeaks);
    model=Heights'*A+baseline;
else
    model=PEAKHEIGHTS'*A;
    Heights=PEAKHEIGHTS;
    baseline=0;
end

% Compare trial model to data segment and compute the fit error
  MeanFitError=100*norm(yy-model)./(sqrt(n)*max(yy));
  % Take only the single fit that has the lowest MeanFitError
  if MeanFitError<LowestError, 
      if min(Heights)>=0,  % Consider only fits with positive peak heights
        LowestError=MeanFitError;  % Assign LowestError to the lowest MeanFitError
        FitParameters=TrialParameters;  % Assign FitParameters to the fit with the lowest MeanFitError
        height=Heights; % Assign height to the PEAKHEIGHTS with the lowest MeanFitError
      end % if min(PEAKHEIGHTS)>0
  end % if MeanFitError<LowestError
end % for k (NumTrials)

for m=1:NumPeaks,
    area(m)=trapz(xx+xoffset,height(m)*A(m,:)); % Compute the area of each component peak using trapezoidal method
end

for m=1:NumPeaks,
    if m==1,
        if peakshape==6||peakshape==7||peakshape==8, % equal-width peak models
            FitResults=[[round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
            if peakshape==11||peakshape==12,  % Fixed-width shapes only
                FitResults=[[round(m) FitParameters(m)+xoffset height(m) FIXEDWIDTH area(m)]];
            else
                FitResults=[[round(m) FitParameters(2*m-1)+xoffset height(m) abs(FitParameters(2*m)) area(m)]];
            end
        end % if peakshape
    else
        if peakshape==6||peakshape==7||peakshape==8, % equal-width peak models
            FitResults=[FitResults ; [round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
            if peakshape==11||peakshape==12, % Fixed-width shapes only
                FitResults=[FitResults ; [round(m) FitParameters(m)+xoffset height(m) FIXEDWIDTH area(m)]];
            else
                FitResults=[FitResults ; [round(m) FitParameters(2*m-1)+xoffset height(m) abs(FitParameters(2*m)) area(m)]];
            end
        end % if peakshape
    end % m==1
end % for m=1:NumPeaks
% ----------------------------------------------------------------------
function start=calcstart(xx,NumPeaks,xoffset)
  n=max(xx)-min(xx);
  start=[];
  startpos=[n/(NumPeaks+1):n/(NumPeaks+1):n-(n/(NumPeaks+1))]+min(xx);
  for marker=1:NumPeaks,
      markx=startpos(marker)+ xoffset;
      start=[start markx n/ (3.*NumPeaks)];
  end % for marker
% ----------------------------------------------------------------------
function err = fitgaussian(lambda,t,y)
% Fitting function for a Gaussian band signal.
global PEAKHEIGHTS AUTOZERO
numpeaks=round(length(lambda)/2);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,lambda(2*j-1),lambda(2*j))';
end 
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitewgaussian(lambda,t,y)
% Fitting function for a Gaussian band signal with equal peak widths.
global PEAKHEIGHTS AUTOZERO
numpeaks=round(length(lambda)-1);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,lambda(j),lambda(numpeaks+1))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = FitFWGaussian(lambda,t,y)
%	Fitting function for a fixed width Gaussian
global PEAKHEIGHTS AUTOZERO FIXEDWIDTH
numpeaks=round(length(lambda));
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,lambda(j),FIXEDWIDTH)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = FitFPGaussian(lambda,t,y)
%	Fitting function for fixed-position Gaussians
global PEAKHEIGHTS AUTOZERO FIXEDPOSITIONS
numpeaks=round(length(lambda));
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,FIXEDPOSITIONS(j), lambda(j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = FitFPLorentzian(lambda,t,y)
%	Fitting function for fixed-position Lorentzians
global PEAKHEIGHTS AUTOZERO FIXEDPOSITIONS
numpeaks=round(length(lambda));
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = lorentzian(t,FIXEDPOSITIONS(j), lambda(j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = FitFWLorentzian(lambda,t,y)
%	Fitting function for fixed width Gaussians
global PEAKHEIGHTS AUTOZERO FIXEDWIDTH
numpeaks=round(length(lambda));
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = lorentzian(t,lambda(j),FIXEDWIDTH)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitlorentziancw(lambda,t,y)
% Fitting function for a Lorentzian band signal with equal peak widths.
global PEAKHEIGHTS AUTOZERO
numpeaks=round(length(lambda)-1);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = lorentzian(t,lambda(j),lambda(numpeaks+1))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = gaussian(x,pos,wid)
%  gaussian(X,pos,wid) = gaussian peak centered on pos, half-width=wid
%  X may be scalar, vector, or matrix, pos and wid both scalar
% Examples: gaussian([0 1 2],1,2) gives result [0.5000    1.0000    0.5000]
% plot(gaussian([1:100],50,20)) displays gaussian band centered at 50 with width 20.
g = exp(-((x-pos)./(0.6005615.*wid)).^2);
% ----------------------------------------------------------------------
function err = fitlorentzian(lambda,t,y)
%	Fitting function for single lorentzian, lambda(1)=position, lambda(2)=width
%	Fitgauss assumes a lorentzian function 
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = lorentzian(t,lambda(2*j-1),lambda(2*j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = lorentzian(x,position,width)
% lorentzian(x,position,width) Lorentzian function.
% where x may be scalar, vector, or matrix
% position and width scalar
% T. C. O'Haver, 1988
% Example: lorentzian([1 2 3],2,2) gives result [0.5 1 0.5]
g=ones(size(x))./(1+((x-position)./(0.5.*width)).^2);
% ----------------------------------------------------------------------
function err = fitlogistic(lambda,t,y)
%	Fitting function for logistic, lambda(1)=position, lambda(2)=width
%	between the data and the values computed by the current
%	function of lambda.  Fitlogistic assumes a logistic function 
%  T. C. O'Haver, May 2006
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = logistic(t,lambda(2*j-1),lambda(2*j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = logistic(x,pos,wid)
% logistic function.  pos=position; wid=half-width (both scalar)
% logistic(x,pos,wid), where x may be scalar, vector, or matrix
% pos=position; wid=half-width (both scalar)
% T. C. O'Haver, 1991 
n = exp(-((x-pos)/(.477.*wid)) .^2);
g = (2.*n)./(1+n);
% ----------------------------------------------------------------------
function err = fitlognormal(lambda,t,y)
%	Fitting function for lognormal, lambda(1)=position, lambda(2)=width
%	between the data and the values computed by the current
%	function of lambda.  Fitlognormal assumes a lognormal function 
%  T. C. O'Haver, May 2006
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = lognormal(t,lambda(2*j-1),lambda(2*j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = lognormal(x,pos,wid)
% lognormal function.  pos=position; wid=half-width (both scalar)
% lognormal(x,pos,wid), where x may be scalar, vector, or matrix
% pos=position; wid=half-width (both scalar)
% T. C. O'Haver, 1991  
g = exp(-(log(x/pos)/(0.01.*wid)) .^2);
% ----------------------------------------------------------------------
function err = fitpearson(lambda,t,y,shapeconstant)
%   Fitting functions for a Pearson 7 band signal.
% T. C. O'Haver (toh@umd.edu),   Version 1.3, October 23, 2006.
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = pearson(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = pearson(x,pos,wid,m)
% Pearson VII function. 
% g = pearson7(x,pos,wid,m) where x may be scalar, vector, or matrix
% pos=position; wid=half-width (both scalar)
% m=some number
%  T. C. O'Haver, 1990  
g=ones(size(x))./(1+((x-pos)./((0.5.^(2/m)).*wid)).^2).^m;
% ----------------------------------------------------------------------
function err = fitexpgaussian(lambda,t,y,timeconstant)
%   Fitting functions for a exponentially-broadened Gaussian band signal.
%  T. C. O'Haver, October 23, 2006.
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = expgaussian(t,lambda(2*j-1),lambda(2*j),timeconstant);
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitexplorentzian(lambda,t,y,timeconstant)
%   Fitting functions for a exponentially-broadened lorentzian band signal.
%  T. C. O'Haver, 2013.
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = explorentzian(t,lambda(2*j-1),lambda(2*j),timeconstant);
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitexpewgaussian(lambda,t,y,timeconstant)
% Fitting function for exponentially-broadened Gaussian bands with equal peak widths.
global PEAKHEIGHTS AUTOZERO
numpeaks=round(length(lambda)-1);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = expgaussian(t,lambda(j),lambda(numpeaks+1),timeconstant);
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = expgaussian(x,pos,wid,timeconstant)
%  Exponentially-broadened gaussian(x,pos,wid) = gaussian peak centered on pos, half-width=wid
%  x may be scalar, vector, or matrix, pos and wid both scalar
%  T. C. O'Haver, 2006
g = exp(-((x-pos)./(0.6005615.*wid)) .^2);
g = ExpBroaden(g',timeconstant);
% ----------------------------------------------------------------------
function g = explorentzian(x,pos,wid,timeconstant)
%  Exponentially-broadened lorentzian(x,pos,wid) = lorentzian peak centered on pos, half-width=wid
%  x may be scalar, vector, or matrix, pos and wid both scalar
%  T. C. O'Haver, 2013
g = ones(size(x))./(1+((x-pos)./(0.5.*wid)).^2);
g = ExpBroaden(g',timeconstant);
% ----------------------------------------------------------------------
function yb = ExpBroaden(y,t)
% ExpBroaden(y,t) zero pads y and convolutes result by an exponential decay
% of time constant t by multiplying Fourier transforms and inverse
% transforming the result.
hly=round(length(y)./2);
ey=[y(1).*ones(1,hly)';y;y(length(y)).*ones(1,hly)'];
% figure(2);plot(ey);figure(1);
fy=fft(ey);
a=exp(-(1:length(fy))./t);
fa=fft(a);
fy1=fy.*fa';
ybz=real(ifft(fy1))./sum(a);
yb=ybz(hly+2:length(ybz)-hly+1);
% ----------------------------------------------------------------------
function err = fitexppulse(tau,x,y)
% Iterative fit of the sum of exponental pulses
% of the form Height.*exp(-tau1.*x).*(1-exp(-tau2.*x)))
global PEAKHEIGHTS AUTOZERO
A = zeros(length(x),round(length(tau)/2));
for j = 1:length(tau)/2,
    A(:,j) = exppulse(x,tau(2*j-1),tau(2*j));
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS =abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = exppulse(x,t1,t2)
% Exponential pulse of the form 
% g = (x-spoint)./pos.*exp(1-(x-spoint)./pos);
e=(x-t1)./t2;
p = 4*exp(-e).*(1-exp(-e));
p=p .* (p>0);
g = p';
% ----------------------------------------------------------------------
function err = fitalphafunction(tau,x,y)
% Iterative fit of the sum of alpha funciton
% of the form Height.*exp(-tau1.*x).*(1-exp(-tau2.*x)))
global PEAKHEIGHTS AUTOZERO
A = zeros(length(x),round(length(tau)/2));
for j = 1:length(tau)/2,
    A(:,j) = alphafunction(x,tau(2*j-1),tau(2*j));
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS =abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = alphafunction(x,pos,spoint)
% alpha function.  pos=position; wid=half-width (both scalar)
% lognormal(x,pos,wid), where x may be scalar, vector, or matrix
% pos=position; wid=half-width (both scalar)
% Taekyung Kwon, July 2013  
g = (x-spoint)./pos.*exp(1-(x-spoint)./pos);
for m=1:length(x);if g(m)<0;g(m)=0;end;end
% ----------------------------------------------------------------------
function err = fitsigmoid(tau,x,y)
% Fitting function for iterative fit to the sum of
% sigmiods of the form Height./(1 + exp((t1 - t)/t2))
global PEAKHEIGHTS AUTOZERO
A = zeros(length(x),round(length(tau)/2));
for j = 1:length(tau)/2,
    A(:,j) = sigmoid(x,tau(2*j-1),tau(2*j));
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g=sigmoid(x,t1,t2)
% g=1./(1 + exp((t1 - x)./t2))'; % old version of sigmoid
g=1/2 + 1/2* erf(real((x-t1)/sqrt(2*t2))); % Modified sigmoid
% Bifurcated sigmoid
% lx=length(x);
% hx=val2ind(x,t1);
% g(1:hx)=1./(1 + exp((t1 - x(1:hx))./t2));
% g(hx+1:lx)=1./(1 + exp((t1 - x(hx+1:lx))./(1.3*t2)));
% ----------------------------------------------------------------------
function err = fitGL(lambda,t,y,shapeconstant)
%   Fitting functions for Gaussian/Lorentzian blend.
% T. C. O'Haver (toh@umd.edu), 2012.
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = GL(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = GL(x,pos,wid,m)
% Gaussian/Lorentzian blend. m = percent Gaussian character
% pos=position; wid=half-width
% m = percent Gaussian character.
%  T. C. O'Haver, 2012
g=2*((m/100)*gaussian(x,pos,wid)+(1-(m/100))*lorentzian(x,pos,wid))/2;
% ----------------------------------------------------------------------
function err = fitvoigt(lambda,t,y,shapeconstant)
% Fitting functions for Voigt profile function
% T. C. O'Haver (toh@umd.edu), 2013.
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = voigt(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g=voigt(xx,pos,gD,alpha)
% Voigt profile function. xx is the independent variable (energy,
% wavelength, etc), gD is the Doppler (Gaussian) width, and alpha is the
% shape constant (ratio of the Lorentzian width gL to the Doppler width gD.
% Based on Chong Tao's "Voigt lineshape spectrum simulation", 
% File ID: #26707
% alpha=alpha
gL=alpha.*gD;
gV = 0.5346*gL + sqrt(0.2166*gL.^2 + gD.^2);
x = gL/gV;
y = abs(xx-pos)/gV;
g = 1/(2*gV*(1.065 + 0.447*x + 0.058*x^2))*((1-x)*exp(-0.693.*y.^2) + (x./(1+y.^2)) + 0.016*(1-x)*x*(exp(-0.0841.*y.^2.25)-1./(1 + 0.021.*y.^2.25)));
g=g./max(g);
% ----------------------------------------------------------------------
function err = fitBiGaussian(lambda,t,y,shapeconstant)
%   Fitting functions for BiGaussian.
% T. C. O'Haver (toh@umd.edu),  2012.
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = BiGaussian(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = BiGaussian(x,pos,wid,m)
% BiGaussian (different widths on leading edge and trailing edge).
% pos=position; wid=width 
% m determines shape; symmetrical if m=50.
%  T. C. O'Haver, 2012
lx=length(x);
hx=val2ind(x,pos);
g(1:hx)=gaussian(x(1:hx),pos,wid*(m/100));
g(hx+1:lx)=gaussian(x(hx+1:lx),pos,wid*(1-m/100));
% ----------------------------------------------------------------------
function err = fitBiLorentzian(lambda,t,y,shapeconstant)
%   Fitting functions for BiGaussian.
% T. C. O'Haver (toh@umd.edu),  2012.
global PEAKHEIGHTS AUTOZERO
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = BiLorentzian(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = BiLorentzian(x,pos,wid,m)
% BiLorentzian (different widths on leading edge and trailing edge).
% pos=position; wid=width 
% m determines shape; symmetrical if m=50.
%  T. C. O'Haver, 2012
lx=length(x);
hx=val2ind(x,pos);
g(1:hx)=lorentzian(x(1:hx),pos,wid*(m/100));
g(hx+1:lx)=lorentzian(x(hx+1:lx),pos,wid*(1-m/100));
% ----------------------------------------------------------------------
function b=iqr(a)
% b = IQR(a)  returns the interquartile range of the values in a.  For
%  vector input, b is the difference between the 75th and 25th percentiles
%  of a.  For matrix input, b is a row vector containing the interquartile
%  range of each column of a.
%  T. C. O'Haver, 2012
mina=min(a);
sizea=size(a);
NumCols=sizea(2);
for n=1:NumCols,b(:,n)=a(:,n)-mina(n);end
Sorteda=sort(b);
lx=length(Sorteda);
SecondQuartile=round(lx/4);
FourthQuartile=3*round(lx/4);
b=abs(Sorteda(FourthQuartile,:)-Sorteda(SecondQuartile,:));
