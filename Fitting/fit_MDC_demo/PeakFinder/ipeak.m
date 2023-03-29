function P=ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange,MaxError,positions,names)
% ipeak 7 is a keyboard-operated Interactive Peak Finder for time series
% data, based on the "findpeaks.m", "findpeaksL.m" and "peakfit.m" functions. 
% Version 6.3, December 2014 ; reduced errors with very noisy signals
% Expected input forms:
% ipeak(y);  % Data in single y vector')
% ipeak(x,y);  % Data in separate x and y vectors')
% ipeak(DataMatrix); % Data in two columns of DataMatrix')
% ipeak(x,y,10), ipeak([x;y],10) or ipeak(y,10), specifying peak density, PeakD
% ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW) specifying peak density, AmpT, SlopeT, SmoothW, FitW')
% ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange) Adding pan and zoom settings ')
% ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange,Autozero)  Adding Autozeo as 9th argument')
% ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange,MaxError,p
% ositions,names)  Adding peak ID')
%
% EXAMPLE 1:  One input argument; data in single vector
%                >> y=cos(.1:.1:100);ipeak(y)
%
% EXAMPLE 2:  One input argument; data in two columns of a matrix
%                >> x=[0:.01:5]';y=x.*sin(x.^2).^2;M=[x y];ipeak(M);
%
% EXAMPLE 3:  Two input arguments; data in separate x and y vectors
%                >> x=[0:.1:100];y=(x.*sin(x)).^2;ipeak(x,y);
%
% EXAMPLE 4:  Additional input argument (after the data) to control peak
% sensitivity.
%        >> x=[0:.1:100];y=5+5.*cos(x)+randn(size(x));ipeak(x,y,10);
%    or  >> ipeak([x;y],10); 
%    or  >> ipeak(humps(0:.01:2),3)
%    or  >> x=[0:.1:10];y=exp(-(x-5).^2);ipeak([x' y'],1)
%
% The additional argument (PeakD) is roughly the ratio of the typical
% peak width to the length of the entire data record. Small values
% detect fewer peaks; larger values detect more peaks. It effects only the
% starting values for the peak detection parameters. (This is just a quick
% way to set reasonable initial values of the peak detection parameters,
% rather than specifying each one individually as in example 5.
%
% iPeak displays the entire signal in the lower half of the Figure window
% and an adjustable zoomed-in section in the upper window. (Press the Enter
% key to change the plot color.)  Adjust the peak detection parameters
% AmpThreshold (A/Z keys), SlopeThreshold (S/X), SmoothWidth (D/C),
% FitWidth (F/V) so that it detects the desired peaks and ignores those
% that are too small, too broad, or too narrow to be of interest. Detected
% peaks are numbered from left to right.  To detect valleys rather than 
% peaks, press "U" and adjust AmpT below the lowest valley. (U toggles 
% between peak and valley mode). Press P to display a table of detected
% peaks/valleys (#, Position, Height, Width). Version 5.3 (April, 2013)
% adds the E key command to print a table of summary statistics of the peak
% intervals (the x-axis interval between adjacent detected peaks), heights,
% widths, and areas, including the maximum, minimum, average, percent
% standard deviation (STD), and histograms. For example:
%   
%           Interval      Height      Width          Area
% Maximum    6.3795       10.5308     3.2354       34.943
% Minimum    6.1649        9.7355     2.6671       29.9008
% Mean       6.291        10.1559     3.0149       32.5771
% %STD       0.91178       1.904      5.2584       4.3022
%
% EXAMPLE 5: Six input arguments. As above, but input arguments 3 to 6
% directly specifies initial values of AmpThreshold (AmpT), SlopeThreshold
% (SlopeT), SmoothWidth (SmoothW), FitWidth (FitW) . PeakD is ignored in
% this case, so just type a '0' as the second argument after the data
% matrix).
%              >> x=[0:.01:5]';y=x.*sin(x.^2).^2;M=[x y];
%              >> ipeak(M,0,0,.0001,20,20);
%
% The cursor arrow kays allow you to pan and zoom the upper window,
% to inspect each peak in detail if desired.  You can set the initial
% values of pan andzoom in optional input arguments 7 ('xcenter') and 8
% ('xrange').  See example 6 below.
%
% The peak cloest to the center of the upper window is labeled in the upper
% left of the top window and it peak position, height, and width are
% listed. The Spacebar/Tab keys jump to the next/previous detected peak and
% displays it in the upper window at the current zoom setting (use the up
% and down cursor arrow keys to adjust the zoom range).  The Y key toggles
% between linear and log y-axis scale in the lower window (a log axis is
% good for inspecting signals with high dynamic range; it effects only the
% lower window display and has no effect on the peak detection or
% measurements).
%
% EXAMPLE 6: Eight input arguments. Like example 5, but input arguments 7
% and 8 specifiy the initial pan and zoom settings, 'xcenter' and 'xrange',
% respectively.  In this example, the x-axis data are wavelengths in
% nanometers (nm), and the upper window zooms in on a very small 0.4 nm
% region centered on 249.7 nm. (These data, provided in the ZIP file, are
% from a high-resolution atomic spectrum).
%
%         >> load ipeakdata.mat 
%         >> ipeak(Sample1,0,110,0.06,3,4,249.7,0.4);
%
% Autozero mode. The T key cycles through none, linear, quadratic autozero,
% and flat baseline modes.  When autozero is OFF, peak heights are measured
% relative to zero. (If the peaks are superimpored on a background, use
% the baseline subtract keys - B and G - first to subtract the background).
% When autozero is linear or quadratic, peak heights are automatically
% measured relative to the local baseline on either side of the peak; use
% the zoom controls to isolate the peaks so that the signal returns to the
% local baseline between the peaks as displayed in the upper window.  When
% autozero is linear or quadratic, the peak heights, widths, and areas in
% the peak table (R or P keys) will be automatically corrected for the
% baseline.  (Autozero OFF will give better results when the baseline is
% zero, or has been subtracted using the B key, even if the peaks are
% partly overlapped. Linear or quadratic mode will work best if the peaks
% are well separated so that the signal returns to the local baseline
% between the peaks. If the peaks are highly overlapped, or if they are not
% Gaussian in shape, the best results will be obtained by using the curve
% fitting function - the N or M keys - in which case the flat baseline mode
% can be used if the peaks are superimposed on a baseline). 
%
% EXAMPLE 7:  Nine input argument controls the basekine correction mode 0
% through 3 (equivalent to pressing the T key). 0=None (default if not specified)
%
%        >> x=1:.02:100;y=5.*sin(10*x)+randn(size(x));
%        >> ipeak([x;y],0,0.5,0.0016259,8,15,97.6,1.1,0)
%
% Normal and Multiple Curve fitting: The N key applies variable-shape
% iterative curve fittingto the detected peaks that are displayed in the
% upper window (referred to a "Normal" curve fitting).  If the peaks are
% superimposed on a background, turn on the Autozero mode (T key). Then use
% the pan and zoom keys to select a peak or a group of overlapping peaks in
% the upper window, with the signal returning all the way to the local
% baseline at the ends of the upper window.  Make sure that AmpThreshold,
% SlopeThreshold, SmoothWidth are adjusted so that each peak is numbered
% once.  Then press the N key, type the number for the desired peak shape
% at the prompt in the Command window and press Enter, then type in a
% number of repeat trial fits and press Enter (the default is 1; start with
% that and then increase if necessary).  The program will perform the fit,
% display the results graphically in Figure window 2, and print out a table
% of results in the command window, e.g.:
%
% Peak shape (1-8): 2 
% Number of trials: 1
% Least-squares fit to Lorentzian peak model 
% Fitting Error 1.1581e-006%
%           Peak#     Position     Height      Width       Area
%             1          100         1          50        71.652 
%             2          350         1          100       146.13 
%             3          700         1          200       267.77
%
% The use of the iterative least-squares function can result in more
% accurate peak parameter measurements that the normal peak table (R or P
% keys), especially if the peaks are non-Gaussian in shape or are highly
% overlapped.
%
% Peak parameter accuracy check: single perfect Gaussian with zero
% baseline; position=5, height=1, width=1.665, area=1.772
% >> x=[0:.1:10];y=exp(-(x-5).^2);ipeak([x;y],0,.5,0.00018,12,20,5,10,0)
% Compare peak table (P key) and peakfit (N key) results, in all 4 baseline
% correction modes (T key).
%
% There is also a "Multiple" peak fit function (M key) that will attempt to
% apply non-linear iterative curve fitting to all the detected peaks in
% the signal simultaneously. Before using this function, use the baseline
% correction function first (B key) to remove the background signal. Then
% press M and proceed as for the normal curve fit. This function may take a
% minute or so to complete, possibly longer than the normal (N-key) curve
% fitting function on each group of peaks separately. Note: The N and M key
% fitting functions perform non-linear iterative curve fitting using the
% peakfit.m function. The number of peaks and the starting values of peak
% positions and widths for the curve fit function are automatically
% supplied by the the findpeaks function, so it is essential that the peak
% detection variables in iPeak be adjust so that all the peaks in the
% selected ragion are detected and numbered once. (For more flexible curve
% fitting, use ipf.m).
%
% Peak identification. There is an optional "peak identification" function
% if optional input arguments 9 ('MaxError'), 10 ('Positions'), and 11
% ('Names') are included. The "i" key toggles this function ON and OFF.
% This function compares the found peak positions (maximum x-values) to a
% database of known peaks, in the form of an array of known peak maximum
% positions ('Positions') and matching cell array of names ('Names'). If
% the position of a found peak in the signal is closer to one of the known
% peaks by less than the specified maximun error ('MaxError'), then that
% peak is considered a match and its name is displayed next to the peak in
% the upper window. When when the 'o' key is pressed, the peak positions,
% names, errors, and amplitudes are printed out in a table in the command
% window.
%
% EXAMPLE 8: Eleven input arguments. As above, but also specifies
% 'MaxError', 'Positions', and 'Names' in optional input arguments 9, 10,
% and 11, for peak identification function. Pressing the 'I' key toggles
% off and on the peak identification labels in the upper window. Pressing
% "o" prints the peak positions, names, errors, and amplitudes in a table
% in the command window. These data (provided in the ZIP file) are from a
% high-resolution atomic spectrum (x-axis in nanometers).
%
%     >> load ipeakdata.mat
%     >> ipeak(Sample1,0,100,0.05,3,6,296,5,0.1,Positions,Names);
%
% ipeak 6.3 KEYBOARD CONTROLS:
% Pan left and right..........Coarse pan: < and >
%                             Fine pan: left and right cursor arrows
%                             Nudge: [ ] 
% Zoom in and out.............Coarse zoom: / and "  
%                             Fine zoom: up and down cursor arrows
% Resets pan and zoom.........ESC
% Select entire signal........Ctrl-A
% Refresh entire plot.........Enter (Updates cursor position in lower plot) 
% Change plot color...........Shift-C (cycles through standard colors)
% Adjust AmpThreshold.........A,Z (Larger values ignore short peaks)
% Type in AmpThreshold........Shift-A 
% Adjust SlopeThreshold.......S,X (Larger values ignore broad peaks)
% Type in SlopeThreshold......Shift-S 
% Adjust SmoothWidth..........D,C (Larger values ignore sharp peaks}
% Adjust FitWidth.............F,V (Adjust to cover just top part of peaks)
% Toggle sharpen mode ........H  Helps detect overlapped peaks.
% Baseline correction:        B, enter # points, then click baseline 
% Restore original signal.....G  to cancel previous background subtraction
% Invert signal...............-  Invert (negate) the signal (flip + and -)
% Set minimum to zero.........0  (Zero) Sets minumun signal to zero
% Interpolate signal..........Shift-I  Interpolate (resample) to N points
% Toggle log y mode OFF/ON....Y  Plot log Y axis on lower graph
% Cycle autozero mode.........T  Selects baseline subtraction modes 0-3
% Toggle valley mode OFF/ON...U  Switch to valley mode
% Gaussian/Lorentzian switch..Shift-G  Switch between Gaussian/Lorentzian mode
% Print report................R  prints Peak table and parameters
% Print peak statistics.......E  prints mean, std of peak intervals, heights, etc.    
% Step through peaks..........Space/Tab  Jumps to next/previous peak
% Jump to specfied peak.......J  Enter desired peak number and press Enter
% Print peak table............P  Peak #, Position, Height, Width, Area
% Save peak table.............Shift-P  Saves peak table as disc file
% Normal peak fit.............N  Fit peaks in upper window with peakfit.m
% Multiple peak fit...........M  Fit all peaks in signal with peakfit.m
% Ensemble average all peaks..Shift-E  Zoom to single peak first.
% Print keyboard commands.....K  prints this list
% Print findpeaks arguments...Q  prints findpeaks function with arguments
% Print ipeak arguments.......W  prints ipeak function with all arguments
% Peak labels ON/OFF..........L  label all peaks detected on upper graph
% Peak ID ON/OFF..............I  Identifies closest peaks in Names database.
% Print table of peak IDs.....O  Prints Name, Position, Error, Amplitude
% Switch to ipf.m.............Shift-Ctrl-F transfer current signal to ipf.m
% Switch to iSignal...........Shift-Ctrl-S  Transfer current signal to iSignal.m

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
% % Recent versions:
% 5.1: Faster pan and zoom with large signals over 100,000 points
%  (change the variable "maxL" in line 485); other small bug fixes
% 5.2: Shift-P saves the peak table as a data file on disc.
% 5.3: Adds E key to print summary statistics of peak intervals,
%    heights, widths, areas.
% 5.4: Adds Lorentzian peak mode (press Shift-G to switch modes).
% 5.5: Fixes bug in autozero operation
% 5.6: Adds Shift-A to enter AmpThreshold directly and 
%   Shift-S to enter Slope Threshold directly.
% 5.7: Adds J key to jump to specfied peak number.
% 5.82: Includes version 4.2 of peakfit.m, adds Voigt profile shape
%   and flat baseline mode for iterative least-squares fits; bug fixes. 
% 5.9  Added relative % fitting error as 6th column of peak table
% 5.95 modified action of flat baseline correction (mode 3) 
% 5.96 adds interpolation function (Shift-I).
% 6.01 adds ensemble average function (Shift-E); Ctrl-A selects
% entire signal.
global X Y xo dx SlopeThreshold AmpThreshold SmoothWidth FitWidth AUTOZERO 
global PeakLabels PeakID Names Positions maxerror logplot plotcolor showpeak 
global SavedY PeakMode Sharpen ShapeMode P FIXEDPARAMETERS
format short g
format compact
warning off all
switch nargin
    % 'nargin' is the number of input arguments
    case 1  % One argument only
      % Assumne that the argument must be a matrix of data.
      % If DataMatrix is in the wrong transposition, fix it.
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      datasize=size(DataMatrix);
      if datasize(2)==1, %  Must be ipeak(Y-vector)
         X=[1:length(DataMatrix)]'; % Create an independent variable vector
         Y=DataMatrix;
      else
         % Must be ipeak(DataMatrix)
         X=DataMatrix(:,1); % Split matrix argument 
         Y=DataMatrix(:,2);
      end
      % Calculate default values of peak detection parameters
      PeakDensity=20;   
      % Estimate approx number of points in a peak half-width
      WidthPoints=length(Y)/PeakDensity;  
      SlopeThreshold=WidthPoints^-2;  
      AmpThreshold=abs(min(Y)+0.1*(max(Y)-min(Y))); 
      SmoothWidth=round(WidthPoints/3);  
      FitWidth=round(WidthPoints/3);
      if FitWidth>100,FitWidth=100;end   % Keep FitWidth below 100
      if SmoothWidth>100,SmoothWidth=100;end   % Keep SmoothWidth below 100
      xo=length(Y)/2; % Initial Pan setting
      dx=length(Y)/4; % Initial Zoom setting
      AUTOZERO=0;
    case 2
      % Two arguments; might be separate x and y data vectors, 
      % data matrix + number, or y vector + number (peak density estimate)
      if isscalar(PeakD)    
         % Must be one data matrix and a peak density estimate.
         % If DataMatrix is in the wrong transposition, fix it.
          datasize=size(DataMatrix);
         if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
         datasize=size(DataMatrix);
         if datasize(2)==1, %  Must be ipeak(Y-vector)
            X=[1:length(DataMatrix)]'; % Create an independent variable vector
            Y=DataMatrix;
         else
            % Must be ipeak(DataMatrix)
            X=DataMatrix(:,1); % Split matrix argument 
            Y=DataMatrix(:,2);
         end
         % Calculate values of peak detection parameters
         % arguments based on the peak density, PeakD
         PeakDensity=PeakD;    
         % Estimate approx number of points in a peak half-width
         WidthPoints=length(Y)/PeakDensity;  
         SlopeThreshold=WidthPoints^-2;  
         AmpThreshold=abs(min(Y)+0.1*(max(Y)-min(Y)));  
         SmoothWidth=round(WidthPoints/3);  
         FitWidth=round(WidthPoints/3);
         if FitWidth>100,FitWidth=100;end   % Keep FitWidth below 100
         if SmoothWidth>100,SmoothWidth=100;end   % Keep SmoothWidth below      xo=length(Y)/2; % Initial Pan setting
         xo=length(Y)/2; % Initial Pan setting
         dx=length(Y)/4; % Initial Zoom setting
         AUTOZERO=0;
      else % if not isscalar
        % Must be separate x and y data vectors
        X=DataMatrix;
        Y=PeakD;
        PeakDensity=20;   
        % Estimate approx number of points in a peak half-width
        WidthPoints=length(Y)/PeakDensity;  
        SlopeThreshold=WidthPoints^-2;  
        AmpThreshold=abs(min(Y)+0.1*(max(Y)-min(Y))); 
        SmoothWidth=round(WidthPoints/3);  
        FitWidth=round(WidthPoints/3); 
        if FitWidth>100,FitWidth=100;end   % Keep FitWidth below 100
        if SmoothWidth>100,SmoothWidth=100;end   % Keep SmoothWidth below 100
        xo=length(Y)/2; % Initial Pan setting
        dx=length(Y)/4; % Initial Zoom setting
      end  % if isscalar
      AUTOZERO=0;
    case 3
      % Must be separate x and y data vectors plus a peak density estimate. 
      X=DataMatrix;
      Y=PeakD;
      % Calculate values of peak detection parameters
      % arguments based on the peak density, PeakD
      PeakDensity=AmpT;    
      % Estimate approx number of points in a peak half-width
      WidthPoints=length(Y)/PeakDensity;  
      SlopeThreshold=WidthPoints^-2;  
      AmpThreshold=abs(min(Y)+0.02*(max(Y)-min(Y)));  
      SmoothWidth=round(WidthPoints/3);  
      FitWidth=round(WidthPoints/3); 
      if FitWidth>100,FitWidth=100;end   % Keep FitWidth below 100
      if SmoothWidth>100,SmoothWidth=100;end   % Keep SmoothWidth below 100
      xo=length(Y)/2; % Initial Pan setting
      dx=length(Y)/4; % Initial Zoom setting
      AUTOZERO=0;
    case 6 
      % Must be one data matrix and all peak detection parameters 
      % specified in arguments 
      % If DataMatrix is in the wrong transposition, fix it.
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      X=DataMatrix(:,1); % Split matrix argument 
      Y=DataMatrix(:,2);
      SlopeThreshold=SlopeT;
      AmpThreshold=AmpT;
      SmoothWidth=SmoothW;
      FitWidth=FitW;
      xo=length(Y)/2; % Initial Pan setting
      dx=length(Y)/4; % Initial Zoom setting
      AUTOZERO=0;
    case 8
      % One data matrix, all peak detection parameters specified
      % in arguments, initial values of xcenter and xrange specified.
      % If DataMatrix is in the wrong transposition, fix it.
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      X=DataMatrix(:,1); % Split matrix argument 
      Y=DataMatrix(:,2);
      SlopeThreshold=SlopeT;
      AmpThreshold=AmpT;
      SmoothWidth=SmoothW;
      FitWidth=FitW;
      if xcenter<min(X),
          disp(['Lowest X value is ' num2str(min(X)) ]),
          xcenter=min(X)+xrange;
      end
      if xcenter>max(X),
          disp(['Highest X value is ' num2str(max(X)) ]),
          xcenter=max(X)-xrange;
      end
      xo=val2ind(X,xcenter);xo=xo(1);
      hirange=val2ind(X,xcenter+xrange./2);
      lorange=val2ind(X,xcenter-xrange./2);
      dx=(hirange-lorange);
      AUTOZERO=0;
    case 9
      % Like case 9, except initial AUTOZERO mode is specified
      % in arguments, initial values of xcenter and xrange specified.
      % If DataMatrix is in the wrong transposition, fix it.
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      X=DataMatrix(:,1); % Split matrix argument 
      Y=DataMatrix(:,2);
      SlopeThreshold=SlopeT;
      AmpThreshold=AmpT;
      SmoothWidth=SmoothW;
      FitWidth=FitW;
      xo=val2ind(X,xcenter);xo=xo(1);
      hirange=val2ind(X,xcenter+xrange./2);
      lorange=val2ind(X,xcenter-xrange./2);
      dx=(hirange-lorange);
      if xcenter<min(X),
          disp(['Lowest X value is ' num2str(min(X)) ]),
          xcenter=min(X)+xrange;
      end
      if xcenter>max(X),
          disp(['Highest X value is ' num2str(max(X)) ]),
          xcenter=max(X)-xrange;
      end
      AUTOZERO=MaxError;
    case 11 % last 3 options arguments provided
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      X=DataMatrix(:,1); % Split matrix argument 
      Y=DataMatrix(:,2);
      SlopeThreshold=SlopeT;
      AmpThreshold=AmpT;
      SmoothWidth=SmoothW;
      FitWidth=FitW;
      xo=val2ind(X,xcenter);xo=xo(1);
      hirange=val2ind(X,xcenter+xrange./2);
      lorange=val2ind(X,xcenter-xrange./2);
      dx=(hirange-lorange);
      if xcenter<min(X),
          disp(['Lowest X value is ' num2str(min(X)) ]),
          xcenter=min(X)+xrange;
      end
      if xcenter>max(X),
          disp(['Highest X value is ' num2str(max(X)) ]),
          xcenter=max(X)-xrange;
      end
        maxerror=MaxError;
        Positions=positions;
        Names=names;
        AUTOZERO=0;
    otherwise
      disp('Invalid number of arguments')
      disp('Expected forms are:')
      disp('ipeak(y);  % Data in single y vector')
      disp('ipeak(x,y);  % Data in separate x and y vectors')
      disp('ipeak(DataMatrix); % Data in two columns of DataMatrix')
      disp('ipeak(x,y,10), ipeak([x;y],10) or ipeak(y,10), specifying peak density')
      disp('ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW);  specifying peak density, AmpT, SlopeT, SmoothW, FitW')
      disp('ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange)    Adding pan and zoom settings ')
      disp('ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange,Autozero)  Adding Autozeo as 9th argument')
      disp('ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange,MaxError,positions,names)  Adding peak ID')
      beep
      return
end % switch nargin
% If necessary, flip the data vectors so that X increases
if X(1)>X(length(X)),
    disp('X-axis flipped.')
    X=fliplr(X);
    Y=fliplr(Y);
end
X=reshape(X,length(X),1); % Adjust X and Y vector shape to 1 x n (rather than n x 1)
Y=reshape(Y,length(X),1);
if FitWidth<3,FitWidth=3;end   % Keep FitWidth above 2 
PeakLabels=0; % Peak numbers only, no parameter labels, in upper window
PeakID=0; % Start with PeakID off
logplot=0; % Start with linear mode
plotcolor=0;  % Start with blue plot color
showpeak=1;  % Start with first peak under green cursor
PeakMode=0;
ShapeMode=1; % 1=Gaussian, 0=Lorentzian
Sharpen=0;
SavedY=Y;
xo=round(xo);xo=xo(1);
% Plot the signal
P=findpeaks(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth,2);
[xx,yy]=RedrawSignal(X,Y,xo,dx);
sizeP=size(P);
NumPeaks=sizeP(1);
P=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,PeakMode);
[xx,yy]=RedrawSignal(X,Y,xo,dx);
% disp('Make sure the Caps Lock key is not engaged')
% Attaches KeyPress test function to the figure.
set(gcf,'KeyPressFcn',@ReadKey)
uicontrol('Style','text')
% end of outer function
% ----------------------------SUBFUNCTIONS--------------------------------
function ReadKey(obj,eventdata)
% Interprets key presses from the Figure window. When a key is pressed, 
% executes the code in the corresponding section in the SWITCH statement.
% Note: If you don't like my key assignments, you can change the numbers
% in the case statements here to re-assign that function to any other key.
% If you press a key that has not yet been assigned to a function, it
% displays the key code number in the command window so you can easily
% add that to the SWITCH statement to add your own custom functions.
global X Y xx yy xo dx SlopeThreshold AmpThreshold SmoothWidth FitWidth plotcolor
global PeakLabels PeakID Names Positions maxerror SavedSignal oldAmpThreshold
global logplot P AUTOZERO showpeak PeakMode Sharpen SavedY FIXEDPARAMETERS ShapeMode
key=get(gcf,'CurrentCharacter');
if isscalar(key),
  ly=length(Y);
  maxL=100001; % Signal length below which the entire signal in the lower
  % window is updated for each change. For larger signals, only the upper 
  % windows is updated, in the interest of speed. Adjust to your liking.
  switch double(key),
      case 29
          % Pans down when left arrow pressed.
          xo=xo+dx/10;
          if xo>ly,xo=ly;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 28
          % Pans up when right arrow pressed.
          xo=xo-dx/10;
          if xo<1,xo=1;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 91
          % Nudge down 1 point when [ pressed.
          xo=xo-1;
          if xo<1,xo=1;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 93
          % Nudge up 1 point when ] pressed.
          xo=xo+1;
          if xo>ly,xo=ly;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 46
          % Pans way down when < key pressed.
          xo=xo+dx/2;
          if xo>ly,xo=ly;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 44
          % Pans way up when > key pressed.
          xo=xo-dx/2;
          if xo<1,xo=1;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 31
          % Zooms out when up arrow pressed.
          dx=dx+dx/10;
          if dx>ly,dx=ly;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 30
          % Zooms in when down arrow pressed.
          dx=dx-dx/10;
          if dx<2,dx=2;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 47
          % Zooms way out when / pressed.
          dx=dx*2;
          if dx>ly,dx=ly;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 39
          % Zooms way in when ' pressed.
          dx=round(dx/2);
          if dx<2,dx=2;end
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 1 % Ctrl-A selects entire signal
            xo=length(Y)/2; % Initial Pan setting           
            dx=length(Y); % Initial Zoom setting
            [xx,yy]=RedrawSignal(X,Y,xo,dx);
     case 27 % When 'ESC' key is pressed, resets pan and zoom
         xo=length(Y)/2; % Initial Pan setting
         dx=length(Y)/4; % Initial Zoom setting
         [xx,yy]=RedrawSignal(X,Y,xo,dx);
     case 67  % Change plot color when Shift-C key pressed
         plotcolor=plotcolor+1;
         if plotcolor==6, plotcolor=0;end
         [xx,yy]=RedrawSignal(X,Y,xo,dx);
     case 13  % Refresh plot wEnter key pressed
         [xx,yy]=RedrawSignal(X,Y,xo,dx);    
     case 98
        % When 'b' key is pressed, user clicks graph 
        % to enter background points, then graph re-drawn.
        SavedSignal=Y;
        oldAmpThreshold=AmpThreshold;
        BaselinePoints=input('Number of baseline points to click: ');
        if isempty(BaselinePoints),BaselinePoints=8;end
        AmpThreshold=input('Amplitude Threshold: ');
        if isempty(AmpThreshold),AmpThreshold=oldAmpThreshold;end
        % Acquire background points from user mouse clicks
        subplot(2,1,2)
        title(['Click on ' num2str(BaselinePoints) ' points on the baseline between the peaks.'])
        bX=[];bY=[];
        for g=1:BaselinePoints;
           [clickX,clickY] = ginput(1);
           bX(g)=clickX;
           bY(g)=clickY;
           xlabel(['Baseline point '  num2str(g) ' / ' num2str(BaselinePoints) ])
        end
        yy=Y;
        for k=1:length(bX)-1,
           fp=val2ind(X,bX(k)); % First point in segment
           lp=val2ind(X,bX(k+1));  % Last point in segment
           % Subtract piecewise linear background from Y
           yy(fp:lp)=Y(fp:lp)-((bY(k+1)-bY(k))/(bX(k+1)-bX(k))*(X(fp:lp)-bX(k))+bY(k));
        end
        Y=yy;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);  
    case 103
          % When 'g' key is pressed, restores signal background and AmpThreshold. 
          Y=SavedSignal;
          AmpThreshold=oldAmpThreshold;
          [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 97
        % When 'a' key is pressed, increases "AmpThreshold" by 10%
        AmpThreshold=AmpThreshold+.1*AmpThreshold;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);      
    case 122
        % When 'z' key is pressed, decreases "AmpThreshold" by 10%
        AmpThreshold=AmpThreshold-.1*AmpThreshold;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);      
    case 115 % When 's' key is pressed, increases "SlopeThreshold" by 10%
         SlopeThreshold=SlopeThreshold+.1*SlopeThreshold;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);   
    case 120 % When 'x' key is pressed, decreases "SlopeThreshold" by 10%
         SlopeThreshold=SlopeThreshold-.1*SlopeThreshold;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);   
    case 100
        % When 'd' key is pressed, increases "SmoothWidth" by 1 or 10%
        if SmoothWidth>20,
            SmoothWidth=round(SmoothWidth+.1.*SmoothWidth);
        else
            SmoothWidth=SmoothWidth+1;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);   
    case 99
        % When 'c' key is pressed, decreases "SmoothWidth" by 1 or 10%
        if SmoothWidth>20,
            SmoothWidth=round(SmoothWidth-.1.*SmoothWidth);
        else
            SmoothWidth=SmoothWidth-1;
        end
        if SmoothWidth<1, SmoothWidth=1;end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);   
    case 102
        % When 'f' key is pressed, increases "FitWidth" by 1 or 10%
        if FitWidth>20,
            FitWidth=round(FitWidth+.1.*FitWidth);
        else
            FitWidth=FitWidth+1;
        end
        [xx,yy]=RedrawUpper(X,Y,xo,dx);   % Update upper window graph 
        subplot(2,1,2);   % Update lower window x-label
        xlabel(['    AmpT: ' num2str(AmpThreshold) '     SlopeT: ' num2str(SlopeThreshold) '    SmoothW: ' num2str(SmoothWidth) '    FitW: ' num2str(FitWidth) ])
    case 118
        % When 'v' key is pressed, decreases "FitWidth" by 1 or 10%
        if FitWidth>20,
            FitWidth=round(FitWidth-.1.*FitWidth);
        else
            FitWidth=FitWidth-1;
        end
         if FitWidth<2, FitWidth=2;end
        [xx,yy]=RedrawUpper(X,Y,xo,dx);  % Update upper window graph
        subplot(2,1,2);   % Update lower window x-label
        xlabel(['    AmpT: ' num2str(AmpThreshold) '     SlopeT: ' num2str(SlopeThreshold) '    SmoothW: ' num2str(SmoothWidth) '    FitW: ' num2str(FitWidth) ])
      case 104 % When 'h' key is pressed, toggles between Sharpen 0 and 1
          % if length(Y)>10000,disp('Warning: Sharpening can be slow for for signal lengths above 10,000 points'),end
          if Sharpen==0,
              Sharpen=1;
              xo=xo(1);
              Startx=round(xo-(dx/2));
              Endx=abs(round(xo+(dx/2)-1));
              if (Endx-Startx)<SmoothWidth,Endx=Startx+SmoothWidth;end
              if Endx>length(Y),Endx=length(Y);end
              if Startx<1,Startx=1;end
              PlotRange=Startx:Endx;
              if (Endx-Startx)<5, PlotRange=xo:xo+5;end
              xx=X(PlotRange);
              yy=Y(PlotRange);
              AverageWidth=mean(P(:,4));
              xinterval=X(round(xo+1))-X(round(xo));   
              EnhanceWidth=round(0.15*AverageWidth./xinterval);
              Sharp1=((AverageWidth./xinterval).^2)./25;
              Sharp2=((AverageWidth./xinterval).^4)./800;
              Y=enhance(Y,Sharp1,Sharp2,EnhanceWidth);
          else
              Sharpen=0;
              Y=SavedY;
          end
          [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 45
         % When '-' key is pressed, invert the signal
          Y=-Y;
          [xx,yy]=RedrawSignal(X,Y,xo,dx); 
          disp('Signal was inverted.')
    case 48
    % When '0' (zero) key is pressed, subtracts minimum from entire signal
    % (to remove positive or negative offset).
          Y=Y-min(Y);
          [xx,yy]=RedrawSignal(X,Y,xo,dx); 
          disp('Mininum signal set to zero.')
    case 114
        % When 'r' key is pressed, prints a report listing current 
        % settings and peak table.
        disp('--------------------------------------------------------')
        if ShapeMode,  % 1=Gaussian, 0=Lorentzian
           disp('Gaussian shape mode (press Shift-G to change)') 
        else
           disp('Lorentzian shape mode (press Shift-G to change)') 
        end
        disp(['Amplitude Threshold (AmpT) = ' num2str(AmpThreshold) ] )
        disp(['Slope Threshold (SlopeT) = ' num2str(SlopeThreshold) ] )
        disp(['Smooth Width (SmoothW) = ' num2str(SmoothWidth) ' points' ] )
        disp(['Fit Width (FitW) = ' num2str(FitWidth) ' points' ] )
        sizeP=size(P);
        NumPeaks=sizeP(1);
        window=max(xx)-min(xx);
        switch AUTOZERO,
            case 0
                disp('No baseline correction')
            case 1
                disp('Linear baseline subtraction')
                disp([ 'Window span: ' num2str(window) ]);
            case 2
                disp('Quadratic subtraction baseline')
                disp([ 'Window span: ' num2str(window) ]);
            case 3
                disp('Flat baseline correction')
                disp([ 'Window span: ' num2str(window) ]);
        end
          if PeakMode,
              disp('        Valley#     Position     Height      Width          Area')
          else
              disp('          Peak#     Position     Height      Width          Area        Error')
          end
        PP=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,PeakMode);
        disp(PP)
     case 101 % When 'E' key is pressed, computes statistical summary of peaks
         sizeP=size(P);
         NumPeaks=sizeP(1);
         window=max(xx)-min(xx);
         PP=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,PeakMode);
         disp('Peak Summary Statistics')
         disp( [ num2str(length(PP)) ' peaks detected' ] )
         switch AUTOZERO,
            case 0
                disp('No baseline correction')
            case 1
                disp('Linear baseline subtraction')
                disp([ 'Window span: ' num2str(window) ]);
            case 2
                disp('Quadratic subtraction baseline')
                disp([ 'Window span: ' num2str(window) ]);
            case 3
                disp('Flat baseline correction')
                disp([ 'Window span: ' num2str(window) ]);
         end
         %  "d" is the vector of x-axis intervals between peaks.
         for n=1:NumPeaks-1;
             d(n)=max(P(n+1,2)-P(n,2));
         end
         disp('          Interval      Height      Width          Area')
         disp( [ 'Maximum    ' num2str(max(d)) '       ' num2str(max(PP(:,3))) '       ' num2str(max(PP(:,4)))  '       ' num2str(max(PP(:,5)))  ])
         disp( [ 'Minimum    ' num2str(min(d)) '       ' num2str(min(PP(:,3))) '       ' num2str(min(PP(:,4)))  '       ' num2str(min(PP(:,5)))  ])
         disp( [ 'Mean       ' num2str(mean(d)) '       ' num2str(mean(PP(:,3))) '       ' num2str(mean(PP(:,4)))  '       ' num2str(mean(PP(:,5)))  ])
         disp( [ '% STD      ' num2str(100.*std(d)./mean(d)) '       ' num2str(100.*std(PP(:,3))./mean(PP(:,3))) '       ' num2str(100.*std(PP(:,4))./mean(PP(:,4)))  '       ' num2str(100.*std(PP(:,5))./mean(PP(:,5)))  ])
         figure(2)
         subplot(2,2,1);hist(d);title('Histogram of intervals between peak positions')
         subplot(2,2,2);hist(PP(:,3));title('Histogram of peak heights')
         subplot(2,2,3);hist(PP(:,4));title('Histogram of peak widths')
         subplot(2,2,4);hist(PP(:,5));title('Histogram of peak areas')
     case 112
          % When 'p' key is pressed, prints out peak table
          disp('--------------------------------------------------------')
          sizeP=size(P);
          NumPeaks=sizeP(1);
          window=max(xx)-min(xx);
          if ShapeMode,  % 1=Gaussian, 0=Lorentzian
              disp('Gaussian shape mode (press Shift-G to change)')
          else
              disp('Lorentzian shape mode (press Shift-G to change)')
          end
          disp([ 'Window span: ' num2str(window) ' units']) 
          switch AUTOZERO,
              case 0
                  disp('No baseline correction')
              case 1
                  disp('Linear baseline subtraction')
              case 2
                  disp('Quadratic subtraction baseline')
              case 3
                  disp('Flat baseline correction')
          end
          if PeakMode,
              disp('        Valley#     Position     Height      Width          Area        Error')
          else
              disp('          Peak#     Position     Height      Width          Area        Error')
          end
          PP=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,PeakMode);
          disp(PP)
    case 107
        % When 'k' key is pressed, prints out table of keyboard commands
        disp('ipeak 6.3 KEYBOARD CONTROLS:')
        disp(' Pan left and right..........Coarse pan: < and >')   
        disp('                             Fine pan: left and right cursor arrows')
        disp('                             Nudge: [ ] ')
        disp(' Zoom in and out.............Coarse zoom: / and "  ') 
        disp('                             Fine zoom: up and down cursor arrows')
        disp(' Resets pan and zoom.........ESC')
        disp(' Select entire signal.......Ctrl-A')
        disp(' Refresh entire plot.........Enter (Updates cursor position in lower plot) ')
        disp(' Change plot color...........Shift-C (cycles through standard colors)')
        disp(' Adjust AmpThreshold.........A,Z (Larger values ignore short peaks)')
        disp(' Type in AmpThreshold........Shift-A') 
        disp(' Adjust SlopeThreshold.......S,X (Larger values ignore broad peaks)')
        disp(' Type in SlopeThreshold......Shift-S') 
        disp(' Adjust SmoothWidth..........D,C (Larger values ignore sharp peaks}')
        disp(' Adjust FitWidth.............F,V (Adjust to cover just top part of peaks')
        disp(' Toggle sharpen mode ........H  Helps detect overlapped peaks.')
        disp(' Baseline correction:        B, enter # points, then click baseline ')
        disp(' Restore original signal.....G  to cancel previous background subtraction')
        disp(' Invert signal...............-  Invert (negate) the signal (flip + and -)')
        disp(' Set minimum to zero.........0  (Zero) Sets minumun signal to zero') 
        disp(' Interpolate signal..........Shift-I  Interpolate (resample) to N points')
        disp(' Toggle log y mode OFF/ON....Y  Plot log Y axis on lower graph')        
        disp(' Cycle autozero mode.........T  Selects baseline subtraction modes 0-3')  
        disp(' Toggle valley mode OFF/ON...U  Switch to valley mode')          
        disp(' Gaussian/Lorentzian switch..Shift-G  Switch between Gaussian/Lorentzian mode')    
        disp(' Print report................R  prints Peak table and parameters') 
        disp(' Print peak statistics.......E  prints mean, std of peak intervals, heights, etc.')        
        disp(' Step through peaks..........Space/Tab  Jumps to next/previous peak')
        disp(' Jump to specfied peak.......J  Enter desired peak number and press Enter')
        disp(' Print peak table............P  Peak #, Position, Height, Width, Area')
        disp(' Save peak table.............Shift-P  Saves peak table as disc file')
        disp(' Normal peak fit.............N  Fit peaks in upper window with peakfit.m')
        disp(' Multiple peak fit...........M  Fit all peaks in signal with peakfit.m')
        disp(' Ensemble average all peaks..Shift-E  (Zoom to single peak first)')
        disp(' Print keyboard commands.....K  prints this list')
        disp(' Print findpeaks arguments...Q  prints findpeaks function with arguments')
        disp(' Print ipeak arguments.......W  prints ipeak function with all arguments')    
        disp(' Peak labels ON/OFF..........L  Label all peaks detected on upper graph')
        disp(' Peak ID ON/OFF..............I  Identifies closest peaks in Names database.')
        disp(' Print table of peak IDs.....O  Prints Name, Position, Error, Amplitude')
        disp(' Switch to ipf.m.............Shift-Ctrl-F  transfer current signal to ipf.m')
        disp(' Switch to iSignal...........Shift-Ctrl-S  Transfer current signal to iSignal.m')
      case 113
        % When 'Q' is pressed, prints findpeaks and findpeaksfit functions
        % with arguments 
        disp(' ')
        disp('For the segment in the upper window):')
        x1=val2ind(X,xx(1));
        x2=val2ind(X,xx(length(xx)));
        if ShapeMode,
            disp(['findpeaks(x(' num2str(x1) ':' num2str(x2) '),y(' num2str(x1) ':' num2str(x2) '),'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3)'] )
            disp(['findpeaksb(x(' num2str(x1) ':' num2str(x2) '),y(' num2str(x1) ':' num2str(x2) '),'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3,' num2str(length(xx)) ',1,' num2str(AUTOZERO) ')'] )
        else
            disp(['findpeaksL(x(' num2str(x1) ':' num2str(x2) '),y(' num2str(x1) ':' num2str(x2) '),'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3)'] )
            disp(['findpeaksb(x(' num2str(x1) ':' num2str(x2) '),y(' num2str(x1) ':' num2str(x2) '),'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3,' num2str(length(xx)) ',2,' num2str(AUTOZERO) ')'] )
        end
        disp(['[findpeaks,peakfit]=findpeaksfit(x(' num2str(x1) ':' num2str(x2) '),y(' num2str(x1) ':' num2str(x2) '),'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3,peakshape,extra,NumTrials,AUTOZERO,fixedparameters,plots)'] )
        disp(' ')
        disp('For the entire signal in the lower window):')
        if ShapeMode,
            disp(['findpeaks(x,y,'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3)'] )
            disp(['findpeaksb(x,y,'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3,' num2str(length(xx)) ',1,' num2str(AUTOZERO) ')'] )
        else
            disp(['findpeaksL(x,y,'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3)'] )
            disp(['findpeaksb(x,y,'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3,' num2str(length(xx)) ',2,' num2str(AUTOZERO) ')'] )
        end
        disp(['[findpeaks,peakfit]=findpeaksfit(x,y,'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',3,peakshape,extra,NumTrials,AUTOZERO,fixedparameters,plots)'] )
      case 119
        % When 'W' is pressed, prints ipeak function with 9 arguments, and isignal and peakfit functions with center and window   
          center=(max(xx)+min(xx))/2;
          window=max(xx)-min(xx); 
          disp(['ipeak(DataMatrix,0,'  num2str(AmpThreshold) ',' num2str(SlopeThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',' num2str(center) ',' num2str(window)  ',' num2str(AUTOZERO) ')'] )
          disp(['isignal(DataMatrix,'  num2str(center) ',' num2str(window) ');'] )
          disp(['peakfit(DataMatrix,'  num2str(center) ',' num2str(window) ');'] )    
    case 105
        % When 'I' is pressed, toggles on/off PeakID in upper panel
        if PeakID==0,
            PeakID=1;
            % load DataTable
            % disp([ 'Loaded "DataTable" from disk. Number of Names:' num2str(length(Positions)) ] )
            % disp(['Position range: ' num2str(min(Positions)) '-' num2str(max(Positions)) ] )
        else
            PeakID=0;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
    case 108
         % When 'L' is pressed, toggles on/off peak labels in upper panel
        if PeakLabels==0,
            PeakLabels=1;
        else
            PeakLabels=0;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
    case 121
         % When 'Y' is pressed, toggles on/off log plot mode
        if logplot==0,
            logplot=1;
        else
            logplot=0;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
     case 117
         % When 'U' is pressed, toggles PeakMode on/off 
        if PeakMode==0,
            PeakMode=1;
        else
            PeakMode=0;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
     case 71
         % When 'Shift-G' is pressed, toggles between Gaussian and Lorentzian shapemode on/off 
         % 1=Gaussian, 0=Lorentzian
         if ShapeMode==0,
            ShapeMode=1;
        else
            ShapeMode=0;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
    case 111
          % When 'o' is pressed, prints table of identified peaks
          if PeakID,
              disp('Peak Number     Name      Position      Error        Amplitude')  %  Print out column lables for table
              for n=1:length(P(:,2)),
                  % m=index of the cloest match in Positions
                  m=val2ind(Positions,P(n,2));
                  % xError=difference between detected peak and nearest
                  % peak in table
                  xError=abs(P(n,2)-Positions(m));
                  if xError<maxerror, % Only identify the peaks if the error is less than MaxError
                      disp([ n Names(m) Positions(m) xError P(n,3)]); % Print out one line of Positions and Errors table
                  end % if error
              end  % for n
          end  % if PeakID

    case 110
         % When 'N' is pressed, applies peakfit function only to peaks in
         % the upper window (up to 6 peaks).
         if Sharpen,Y=SavedY;end
         xo=xo(1);
         Startx=round(xo-(dx/2));
         Endx=abs(round(xo+(dx/2)-1));
         if (Endx-Startx)<SmoothWidth,Endx=Startx+SmoothWidth;end
         if Endx>length(Y),Endx=length(Y);end
         if Startx<1,Startx=1;end
         PlotRange=Startx:Endx;
         if (Endx-Startx)<5, PlotRange=xo:xo+5;end
         xx=X(PlotRange);
         yy=Y(PlotRange);
         sizeP=size(P);
         NumPeaksUW=sizeP(1);
         if NumPeaksUW>1,
             PUW=[]; % PUW=table of peaks in upper window
             for peak=1:NumPeaksUW, % NumPeaksUW=number of peaks in upper window
                 if P(peak,2)>min(xx),
                     if P(peak,2)<max(xx),
                         PUW=[PUW;P(peak,:)];
                     end %  if P(peak,2)<max(xx),
                 end %  if P(peak,2)>min(xx),
             end % for peak=1:length(P),
         else
             PUW=P;
         end
          sizePUW=size(PUW);
          NumPeaksUW=sizePUW(1);
          center=(max(xx)+min(xx))/2;
          window=max(xx)-min(xx); 
          extra=1;
          % Select model peak shape
          disp('1=Gaussian (default), 2=Lorentzian, 3=logistic, 4=Pearson'); 
          disp('5=exponentionally broadened Gaussian, 6=equal-width Gaussian');
          disp('7=Equal-width Lorentzian, 8=exponentionally broadened equal-width');
          disp('Gaussian, 9=exponential pulse, 10=sigmoid, 11=Fixed-width Gaussian,')
          disp('12=Fixed-width Lorentzian; 13=Gaussian/Lorentzian blend,')
          disp('14=Biurcated Gaussian, 15=Bifurcated Lorentzian.')
          disp('16=Fixed-position Gaussians; 17=Fixed-position Lorentzians;')
          disp('18=exponentionally broadened Lorentzian; 19=alpha function.')
          disp('20=Voigt profile.')
          Shape=input('Peak shape (1-20): ');
          if isempty(Shape),Shape=1;end
          NumTrials=input('Number of trials: ');
          if isempty(NumTrials),NumTrials=1;end
          % Prompt for "extra" parameter if variable-shape model selected
          if Shape==4||Shape==5||Shape==8||Shape==13||Shape==14||Shape==15||Shape==18||Shape==20,
             extra=input('"Extra" parameter, for variable-shape models: ');
          end % if Shape==4||Shape==5||Shape==8,
           % Prompt for "FIXEDPARAMETERS" parameter if fixed-shape model
           % selected
           if Shape==11||Shape==12,
               inputparam=input('Peak width: ');
               if isempty(inputparam),
               else
                   FIXEDPARAMETERS=inputparam;
               end
           end
          if NumTrials>1,disp(['Best of ' num2str(NumTrials) ' trial fits.' ]), end       
          startvector=[];
          for peaks=1:NumPeaksUW,
             startvector=[startvector [PUW(peaks,2) PUW(peaks,4)]];
          end
          figure(2)
          [FitResults,MeanFitError,baseline]=peakfit([xx,yy],0,0,NumPeaksUW,Shape,extra,NumTrials,startvector,AUTOZERO,FIXEDPARAMETERS);
          switch Shape
              case 1
                  ShapeString='Gaussian';
              case 2
                  ShapeString='Lorentzian';
              case 3
                  ShapeString='logistic';
              case 4
                  ShapeString='Pearson7';
              case 5
                  ShapeString='ExpGaussian';
              case 6
                  ShapeString='Equal width Gaussians';
              case 7
                  ShapeString='Equal width Lorentzians';
              case 8
                  ShapeString='Equal-width ExpGauss.';
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
                  ShapeString='ExpLorentzian';
              case 19
                  ShapeString='Alpha function';
              case 20
                  ShapeString='Voigt profile';
              otherwise
                  ShapeString='';
          end % switch Shape
        disp(['Least-squares fit of selected peaks to ' ShapeString ' peak model using this peakfit function:' ])
        switch AUTOZERO,
            case 0
                disp('No baseline correction')
            case 1
                disp('Linear baseline subtraction')
            case 2
                disp('Quadratic subtraction baseline')
            case 3
                disp('Flat baseline correction')
        end
        disp(['>> peakfit(DataMatrix,' num2str(center) ',' num2str(window) ',' num2str(NumPeaksUW) ',' num2str(Shape) ',' num2str(extra) ',' num2str(NumTrials) ',[' num2str(startvector) '],' num2str(AUTOZERO) '); '])
        disp(['Fitting Error ' num2str(MeanFitError) '%'])
        disp('          Peak#     Position     Height      Width         Area  ') 
        for peak=1:NumPeaksUW,FitResults(peak,1)=PUW(peak,1);end
        disp(FitResults(:,1:5))
        disp(['Baseline = '  num2str(baseline)])
        disp('Peakfit plot shown in Figure 2')
        figure(1)
    case 116
           % When 't' key is pressed, steps through AUTOZERO modes
           AUTOZERO=AUTOZERO+1;
           if AUTOZERO==4,AUTOZERO=0;end
           [xx,yy]=RedrawSignal(X,Y,xo,dx); 
      case 61
          % When '+' is pressed,
          disp('--------------------------------------------------------------')
      case 109
        % When 'M' is pressed, applies peakfit function to all numbered peaks
          if Sharpen,Y=SavedY;end
          extra=1;
          % Select model peak shape
          disp('1=Gaussian (default), 2=Lorentzian, 3=logistic, 4=Pearson'); 
          disp('5=exponentionally broadened Gaussian, 6=equal-width Gaussian');
          disp('7=Equal-width Lorentzian, 8=exponentionally broadened equal-width');
          disp('Gaussian, 9=exponential pulse, 10=sigmoid, 11=Fixed-width Gaussian,')
          disp('12=Fixed-width Lorentzian; 13=Gaussian/Lorentzian blend,')
          disp('14=Biurcated Gaussian, 15=Bifurcated Lorentzian.')
          disp('16=Fixed-position Gaussians; 17=Fixed-position Lorentzians;')
          disp('18=exponentionally broadened Lorentzian; 19=alpha function.')
          disp('20=Voigt profile.')
          Shape=input('Peak shape (1-20): ');
          if isempty(Shape),Shape=1;end
          NumTrials=input('Number of trials: ');
          if isempty(NumTrials),NumTrials=1;end
          % Prompt for "extra" parameter if variable-shape model selected
                      switch Shape
                case 1
                    ShapeString='Gaussian';
                case 2
                    ShapeString='Lorentzian';
                case 3
                    ShapeString='logistic';
                case 4
                    ShapeString='Pearson';
                case 5
                    ShapeString='ExpGaussian';
                case 6
                    ShapeString='Equal-width Gaussian';
                case 7
                    ShapeString='Equal-width Lorentzian';
                case 8
                    ShapeString='Equal-width ExpGauss.';
                case 9
                    ShapeString='Exponental pulse';
                case 10
                    ShapeString='Sigmoid';
                case 11
                    ShapeString='Fixed-width Gaussian';
                    inputwidth=input('Peak width: ');
                    if isempty(inputwidth),
                    else
                        FIXEDPARAMETERS=inputwidth;
                    end
                case 12
                    ShapeString='Fixed-width Lorentzian';
                    inputwidth=input('Peak width: ');
                    if isempty(inputwidth),
                    else
                        FIXEDPARAMETERS=inputwidth;
                    end
                case 13
                    ShapeString='Gauss/Lorentz blend';
                case 14
                    ShapeString='bifurcated Gaussian';
                case 15
                    ShapeString='bifurcated Lorentzian';
                case 16
                    ShapeString='Fixed-position Gaussians';
                    inputpositions=input('Peak positions as a vector, e.g. [200 400 600]: ');
                    if isempty(inputpositions),
                    else
                        FIXEDPARAMETERS=inputpositions;
                    end
                case 17
                    ShapeString='Fixed-position Lorentzians';
                    inputpositions=input('Peak positions as a vector, e.g. [200 400 600]: ');
                    if isempty(inputpositions),
                    else
                        FIXEDPARAMETERS=inputpositions;
                    end
                case 18
                    ShapeString='ExpLorentzian';   
                case 19
                    ShapeString='Alpha function';
                case 20
                    ShapeString='Voigt profile';               
                otherwise
            end % switch
          if NumTrials>1,disp(['Best of ' num2str(NumTrials) ' trial fits.' ]), end       
          sizeP=size(P);
          NumPeaks=sizeP(1);
          startvector=[];
          for peaks=1:NumPeaks,
             startvector=[startvector [P(peaks,2) P(peaks,4)]];
          end
          figure(2)
          [FitResults,MeanFitError]=peakfit([X,Y],0,0,NumPeaks,Shape,extra,NumTrials,startvector,AUTOZERO,FIXEDPARAMETERS);
          disp(['Least-squares fit of entire signal to ' ShapeString ' peak model using this peakfit function:' ])
          switch AUTOZERO,
              case 0
                  disp('No baseline correction')
              case 1
                  disp('Linear baseline subtraction')
              case 2
                  disp('Quadratic subtraction baseline')
              case 3
                  disp('Flat baseline correction')
          end
        disp(['>> peakfit(DataMatrix,' num2str(0) ',' num2str(0) ',' num2str(NumPeaks) ',' num2str(Shape) ',' num2str(extra) ',' num2str(NumTrials) ',[' num2str(startvector) '],' num2str(AUTOZERO) '); '])
        disp(['Fitting Error ' num2str(MeanFitError) '%'])
        disp('          Peak#     Position     Height      Width         Area  ') 
        for peak=1:NumPeaks,FitResults(peak,1)=P(peak,1);end
        %% Modified by Han Peng 2015.06.05
        % for interface of FitARPES.IPeakWindow
        % It may potentially cause some problem.
        P(:,1:5)=FitResults;
        %%
        disp(FitResults(:,1:5))
        disp('Peakfit plot shown in Figure 2')
        figure(1)
      case 32 % If spacebar is pressed, jump to next peak
          sizeP=size(P);
          NumPeaks=sizeP(1);
          showpeak=showpeak+1;
          if showpeak>NumPeaks,showpeak=1;end
          center=P(showpeak,2);
          xo=val2ind(X,center);xo=xo(1);
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 9 % If Tab is pressed, jump to previous peak
          sizeP=size(P);
          NumPeaks=sizeP(1);
          showpeak=showpeak-1;
          if showpeak>NumPeaks,showpeak=1;end
          if showpeak<1,showpeak=NumPeaks;end
          center=P(showpeak,2);
          xo=val2ind(X,center);xo=xo(1);
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 106 % If 'J' key is pressed, Jump to...
         oldshowpeak=showpeak;
         disp(['Current peak:' num2str(showpeak)]);
         showpeak=input('Jump to peak number: ');
         if isempty(showpeak),showpeak=oldshowpeak;end
          center=P(showpeak,2);
          xo=val2ind(X,center);xo=xo(1);
          if ly>maxL,
              [xx,yy]=RedrawUpper(X,Y,xo,dx);
          else
              [xx,yy]=RedrawSignal(X,Y,xo,dx);
          end
      case 65    % Shift-A
         oldAmpThreshold=AmpThreshold;
         disp(['Current value of AmpThreshold:' num2str(AmpThreshold)]);
         AmpThreshold=input('Amplitude Threshold: ');
         if isempty(AmpThreshold),AmpThreshold=oldAmpThreshold;end
         [xx,yy]=RedrawSignal(X,Y,xo,dx);
      case 83    
         oldSlopeThreshold=SlopeThreshold;
         disp(['Current value of SlopeThreshold:' num2str(SlopeThreshold)]);
         SlopeThreshold=input('Slope Threshold: ');
         if isempty(SlopeThreshold),SlopeThreshold=oldSlopeThreshold;end
         [xx,yy]=RedrawSignal(X,Y,xo,dx);
      case 69    % If Shift-E is pressed, ensenble average peaks
         try  
          sizeP=size(P);
           NumPeaks=sizeP(1);
               Startx=round(xo-(round(dx)/2));
               Endx=abs(round(xo+(round(dx)/2)-1));
               if (Endx-Startx)<SmoothWidth,Endx=Startx+SmoothWidth;end
               if Endx>length(Y),Endx=length(Y);end
               if Startx<1,Startx=1;end
               PlotRange=Startx:Endx;
               if (Endx-Startx)<5, PlotRange=xo:xo+5;end
               xx=X(PlotRange);
               yy=Y(PlotRange);
               EA=zeros(size(xx),NumPeaks);
           for thispeak=1:NumPeaks
               if thispeak>NumPeaks,thispeak=1;end
               if thispeak<1,thispeak=NumPeaks;end
               center=P(thispeak,2);
               xo=val2ind(X,center);
               xo=xo(1);
               Startx=round(xo-(round(dx)/2));
               Endx=abs(round(xo+(round(dx)/2)-1));
               if (Endx-Startx)<SmoothWidth,Endx=Startx+SmoothWidth;end
               if Endx>length(Y),End=length(Y);end
               if Startx<1,Startx=1;end
               PlotRange=Startx:Endx;
               if (Endx-Startx)<5, PlotRange=xo:xo+5;end
               xx=X(PlotRange);
               yy=Y(PlotRange);
               sizeEA=size(EA);      
               % if sizeEA(1)~=size(yy),disp('To avoid this error, ZOOM IN in so that only one peak is displayed');end
               EA(:,thispeak)=yy;
           end
           figure(2)
           clf
           EnsembleAverage=mean(EA');
           plot(1:length(xx),EnsembleAverage,'r.-')
           title('Ensemble Average')
           xlabel('Index number from start of segment')
           ylabel('Amplitude')
           save EnsembleAverage EnsembleAverage
           disp('Ensemble Average displayed in Figure(2) and saved as EnsembleAverage.mat')
           figure(1)
         catch me
            disp(' ')
            disp('ZOOM IN in so that only one peak is displayed') 
         end
       case 73
            % When 'Shift-I' key is pressed, interpolates the signal
            % to find XI,YI, the values of the underlying function Y at the points
            % linearly interpolated between the points of X.
            disp(['X,Y size before interpolation = ' num2str(size(X)) ' , '  num2str(size(Y)) ] )
            InterPoints=input('Number of points in interpolated signal: ');
            if InterPoints>1,
                Xi=linspace(min(X),max(X),InterPoints);
                Y=interp1(X,Y,Xi)';
                X=Xi';
                disp(['X,Y size after interpolation = ' num2str(size(X)) ' , '  num2str(size(Y)) ] )
                xo=length(Y)/2; % Initial Pan setting
                dx=length(Y)/4; % Initial Zoom setting
                SavedSignal=Y;
                SavedXvalues=X;
                RedrawSignal(X,Y,xo,dx);
            end
      case 80
            % When 'Shift-P' key is pressed, processed signal X,Y matrix is saved as in
            % mat file as the variable 'Output"
            Output=P;
            uisave('Output');    
      case 6 % Shift-Ctrl-F Transfer current signal to Interactive Curve Fitter
            ipf(X,Y);
      case 19 % Shift-Ctrl-S Transfer current signal to iSignal
            isignal(X,Y);
      otherwise
         UnassignedKey=double(key)
       disp('Press k to print out list of keyboard commands')
  end % switch double(key),
end % if ischar(key),
% ----------------------------------------------------------------------    
function [xx,yy]=RedrawUpper(X,Y,xo,dx)
% Plots isolated segment (xx,yy) in the upper half, controlled 
% by Pan and Zoom keys.
global SlopeThreshold AmpThreshold SmoothWidth FitWidth PeakLabels PeakMode
global PeakID Names Positions maxerror P plotcolor logplot AUTOZERO Sharpen
global SavedY ShapeMode
xo=xo(1);
Startx=round(xo-(dx/2));
Endx=abs(round(xo+(dx/2)-1));
if (Endx-Startx)<SmoothWidth,Endx=Startx+SmoothWidth;end
if Endx>length(Y),Endx=length(Y);end
if Startx<1,Startx=1;end
PlotRange=Startx:Endx;
if (Endx-Startx)<5, PlotRange=xo:xo+5;end
xx=X(PlotRange);
yy=Y(PlotRange);
hold off
% clf
% Plots isolated segment (xx,yy) in the upper half
switch plotcolor
    case 0
        color='b.';
    case 1
        color='g.';
    case 2
        color='r.';
    case 3
        color='c.';
    case 4
        color='m.';
    case 5
        color='k.';
end

% Autozero computation
lxx=length(xx);
if AUTOZERO==1, % linear auto-zero operation
    X1=min(xx);
    X2=max(xx);
    Y1=mean(yy(1:lxx/20));
    Y2=mean(yy((lxx-lxx/20):lxx));
    yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
end % if AUTOZERO==1,

bkgsize=round(length(xx)/10);
if bkgsize<2,bkgsize=2;end
if AUTOZERO==2, % Quadratic autozero operation  
    XX1=xx(1:round(lxx/bkgsize));
    XX2=xx((lxx-round(lxx/bkgsize)):lxx);
    Y1=yy(1:round(length(xx)/bkgsize));
    Y2=yy((lxx-round(lxx/bkgsize)):lxx);
    bkgcoef=polyfit([XX1;XX2],[Y1;Y2],2);  % Fit parabola to sub-group of points
    bkg=polyval(bkgcoef,xx);
    yy=yy-bkg;
end % if autozero==2
 if AUTOZERO==3;yy=yy-min(yy);end
figure(1);subplot(2,1,1);cla;plot(xx,yy,color);
hold off

switch AUTOZERO
    case 0
        if PeakMode,
            title('ipeak 6.3  Valley mode.    Autozero OFF.   Press K for keyboard commands')
        else
            if Sharpen,
                title('ipeak 6.3  Sharpen mode.   Autozero OFF.   Press K for keyboard commands')
            else
                if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                    title('ipeak 6.3  Gaussian mode.      Autozero OFF.   Press K for keyboard commands')
                else
                    title('ipeak 6.3  Lorentzian mode.    Autozero OFF.   Press K for keyboard commands')                    
                end
            end
        end
    case 1
        if PeakMode,
            title('ipeak 6.3  Valley mode.   Linear autozero.  Press K for keyboard commands')
        else
            if Sharpen,
                title('ipeak 6.3  Sharpen mode.  Linear autozero.  Press K for keyboard commands')
            else
                if ShapeMode, % 1=Gaussian, 0=Lorentzian
                    title('ipeak 6.3  Gaussian mode.    Linear autozero.   Press K for keyboard commands')
                else
                    title('ipeak 6.3  Lorentzian mode.  Linear autozero.   Press K for keyboard commands')
                end
            end
        end
    case 2
        if PeakMode,
                title('ipeak 6.3 Valley mode.  Quadratic autozero.  Press K for keyboard commands')
        else
            if Sharpen,
                title('ipeak 6.3 Sharpen mode. Quadratic autozero.  Press K for keyboard commands')
            else
                if ShapeMode, % 1=Gaussian, 0=Lorentzian
                    title('ipeak 6.3  Gaussian mode.   Quadratic autozero.   Press K for keyboard commands')
                else
                    title('ipeak 6.3  Lorentzian mode. Quadratic autozero.   Press K for keyboard commands')
                end
            end
        end  
end % switch

axis([X(Startx(1)) X(Endx(1)) min(yy) max(yy)+(max(yy)-min(yy))/10]);
xlabel('Space/Tab: next/previous peak.  Mode: U  Autozero: T   Log/linear: Y  Report: R   Shape: Shift-G')

subplot(2,1,1);
if PeakMode,
    PP=findpulses(xx,yy,SlopeThreshold,AmpThreshold,FitWidth);
else 
    PP=findpeaks(xx,yy,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth,2);
end
X1=min(xx);
X2=max(xx);
if PeakLabels,
    % Label the peaks on the upper graph with number, position, height, and
    % width    
    % Autozero computation
lxx=length(xx);
if AUTOZERO==1, % linear auto-zero operation
    X1=min(xx);
    X2=max(xx);
    Y1=mean(yy(1:lxx/20));
    Y2=mean(yy((lxx-lxx/20):lxx));
    yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
end % if AUTOZERO==1,
bkgsize=round(length(xx)/10);
if bkgsize<2,bkgsize=2;end
if AUTOZERO==2, % Quadratic autozero operation  
    XX1=xx(1:round(lxx/bkgsize));
    XX2=xx((lxx-round(lxx/bkgsize)):lxx);
    Y1=yy(1:round(length(xx)/bkgsize));
    Y2=yy((lxx-round(lxx/bkgsize)):lxx);
    bkgcoef=polyfit([XX1;XX2],[Y1;Y2],2);  % Fit parabola to sub-group of points
    bkg=polyval(bkgcoef,xx);
    yy=yy-bkg;
end % if autozero==2
 if AUTOZERO==3;yy=yy-min(yy);end
 
    topaxis=axis;
    yrange=topaxis(4)-topaxis(3);
    pos1=.1*yrange;
    pos2=.2*yrange;
    pos3=.3*yrange;
    pos4=.4*yrange;
    text(P(:,2),P(:,3)-pos1,num2str(P(:,1)))
    text(PP(:,2),PP(:,3)-pos2,num2str(PP(:,2)))
    text(PP(:,2),PP(:,3)-pos3,num2str(PP(:,3)))
    text(PP(:,2),PP(:,3)-pos4,num2str(PP(:,4)))
else
    topaxis=axis;
    yrange=topaxis(4)-topaxis(3);
    pos1=.1*yrange;
    % Number the peaks on the upper graph
   sp=size(P);lp=sp(1);
    for Peak=1:lp,
        if P(Peak,2)>X1 && P(Peak,2)<X2 && lp>1,
           text(P(Peak,2),yy(val2ind(xx,P(Peak,2)))-pos1,num2str(P(Peak,1)))
        end
    end
end
hold on
lyy=min(yy);
uyy=max(yy)+(max(yy)-min(yy))/10;
if lyy<uyy;
    axis([X(Startx(1)) X(Endx(1)) lyy uyy ]);
end
center=X(round(xo));
hold on;plot([center center],[lyy uyy],'g-')
% Draw red best-fit line through peak tops in upper windows.
if PP(1)>0, % if any peaks are detected
    sizePP=size(PP);
    lengthPP=sizePP(1);
    for PeakNumber=1:lengthPP,
        subplot(2,1,1);
        if PeakNumber>lengthPP,PeakNumber=lengthPP;end
        n1=round(val2ind(xx,PP(PeakNumber,2))-FitWidth/2);
        n2=round(val2ind(xx,PP(PeakNumber,2))+FitWidth/2);
        if n1<1, n1=1;end
        if n2>length(yy), n2=length(yy);end
        PlotRange=n1:n2;
        xxx=rmnan(xx(PlotRange));
        yyy=rmnan(yy(PlotRange));
        if PeakMode, % Valley mode
            [coef,S]=polyfit(xxx,yyy,2);  % Fit parabola to sub-group with centering and scaling
            c1=coef(3);c2=coef(2);c3=coef(1);
            subplot(2,1,1);
            plotspace=linspace(min(xxx),max(xxx));
            plot(plotspace,c3*plotspace.^2+c2*plotspace+c1,'r');
        else % Peak mode
            % Fit parabola to log10 of sub-group
            yyy=smoothnegs(yyy);
            yoffset=0;
            if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                [coef,S,MU]=polyfit(xxx,rmnan(log(yyy-yoffset)),2);
                c1=coef(3);c2=coef(2);c3=coef(1);
                % Compute peak position and height Gaussian
                PeakX=real(-((MU(2).*c2/(2*c3))-MU(1)));
                PeakY=real(exp(c1-c3*(c2/(2*c3))^2))+yoffset;
                MeasuredWidth=real(norm(MU(2).*2.35482/(sqrt(2)*sqrt(-1*c3))));
                residual=yy-PeakY*gaussian(xx,PeakX,MeasuredWidth);
                FError=100.*abs(std(residual)./PeakY);
            else
                z=ones(size(xxx))./(yyy-yoffset);
                coef=polyfit(xxx,z,2);
                PeakY=real(4*coef(1)./((4*coef(1)*coef(3))-coef(2)^2))+yoffset;
                PeakX=real(-coef(2)/(2*coef(1)));
                MeasuredWidth=real(sqrt(((4*coef(1)*coef(3))-coef(2)^2)./coef(1))./sqrt(coef(1)));
                residual=yy-PeakY*lorentzian(xx,PeakX,MeasuredWidth);
                FError=100.*abs(std(residual)./PeakY);
            end
                    subplot(2,1,1);
            try
                plotspace=linspace(min(xxx),max(xxx));
            catch me
                disp(me)
                xxx=xxx
                minxxx=min(xxx)
                maxxxx=max(xxx)
            end
            % Draw red peak top
            if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                plot(plotspace,PeakY.*gaussian(plotspace,PeakX,MeasuredWidth),'r');
            else
                plot(plotspace,PeakY.*lorentzian(plotspace,PeakX,MeasuredWidth),'r');
            end
        end
    end   % for PeakNumber  
     
    % Place a label in the upper left corner with peak number, position,
    % height, and width of the peak closest to the center of the window.
    PeakAtCenter=val2ind(P(:,2),center);
    % auto-zero operation
% Autozero computation
lxx=length(xx);
if AUTOZERO==1, % linear auto-zero operation
    X1=min(xx);
    X2=max(xx);
    Y1=mean(yy(1:lxx/20));
    Y2=mean(yy((lxx-lxx/20):lxx));
    yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
end % if AUTOZERO==1,
bkgsize=round(length(xx)/10);
if bkgsize<2,bkgsize=2;end
if AUTOZERO==2, % Quadratic autozero operation  
    XX1=xx(1:round(lxx/bkgsize));
    XX2=xx((lxx-round(lxx/bkgsize)):lxx);
    Y1=yy(1:round(length(xx)/bkgsize));
    Y2=yy((lxx-round(lxx/bkgsize)):lxx);
    bkgcoef=polyfit([XX1;XX2],[Y1;Y2],2);  % Fit parabola to sub-group of points
    bkg=polyval(bkgcoef,xx);
    yy=yy-bkg;
end % if autozero==2
 if AUTOZERO==3;yy=yy-min(yy);end
    n1=round(val2ind(xx,P(PeakAtCenter,2))-FitWidth/2);
    n2=round(val2ind(xx,P(PeakAtCenter,2))+FitWidth/2);
    if n1<1, n1=1;end
    if n2>length(yy), n2=length(yy);end
    FitRange=n1:n2;
    xxx=rmnan(xx(FitRange));
    yyy=rmnan(yy(FitRange));
    if PeakMode,
        [coef]=polyfit(xxx,yyy,2);  % Fit parabola to sub-group with centering and scaling
        c1=coef(3);c2=coef(2);c3=coef(1);
        PeakX=-c2/(2*c3);
        PeakY=(c1-(c2*c2/(4*c3)));
        MeasuredWidth=real(norm(2.35482/(sqrt(2)*sqrt(-1*c3))));
        EstimatedArea=0;
        residual=yyy-polyval(coef,xxx);
        FError=100.*abs(std(residual)./max(yyy));
    else
        % Fit parabola to log10 of sub-group
         yyy=smoothnegs(yyy);
            if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                [coef,S,MU]=polyfit(xxx,rmnan(log(yyy)),2);
                c1=coef(3);c2=coef(2);c3=coef(1);
                % Compute peak position and height Gaussian
                PeakX=real(-((MU(2).*c2/(2*c3))-MU(1)));
                PeakY=real(exp(c1-c3*(c2/(2*c3))^2));
                MeasuredWidth=real(norm(MU(2).*2.35482/(sqrt(2)*sqrt(-1*c3))));
                residual=yyy-PeakY*gaussian(xxx,PeakX,MeasuredWidth);
                FError=100.*abs(std(residual)./PeakY);
            else
                z=ones(size(xxx))./yyy;
                coef=polyfit(xxx,z,2);
                PeakY=real(4*coef(1)./((4*coef(1)*coef(3))-coef(2)^2));
                PeakX=real(-coef(2)/(2*coef(1)));
                MeasuredWidth=real(sqrt(((4*coef(1)*coef(3))-coef(2)^2)./coef(1))./sqrt(coef(1)));
                residual=yyy-PeakY*gaussian(xxx,PeakX,MeasuredWidth);
                FError=100.*abs(std(residual)./PeakY);
            end
    end
    startx=min(xx)+(max(xx)-min(xx))./20;
    dyy=(max(yy)-min(yy))./10;
    starty=max(yy)-dyy;
    if PeakMode,
        text(startx,starty+dyy/2,['Valley ' num2str(PeakAtCenter) ] );
    else
        text(startx,starty+dyy/2,['Peak ' num2str(PeakAtCenter) ] );
    end
    topaxis=axis;
    yrange=topaxis(4)-topaxis(3);
    pos1=.1*yrange;  
    pos2=.2*yrange;
    pos3=.3*yrange;
    pos4=.4*yrange;
    pos5=.5*yrange;
    text(startx,starty+dyy/2-pos1,['Position: ' num2str(PeakX)])
    text(startx,starty+dyy/2-pos2,['Height: ' num2str(PeakY)])
    text(startx,starty+dyy/2-pos3,['Width: ' num2str(MeasuredWidth)])
    if ShapeMode,
        text(startx,starty+dyy/2-pos4,['Area: ' num2str(1.0646.*PeakY*MeasuredWidth)])
    else
        text(startx,starty+dyy/2-pos4,['Area: ' num2str(1.57.*PeakY*MeasuredWidth)])
    end
    text(startx,starty+dyy/2-pos5,['% Fitting error: ' num2str(FError)])           
    % Add peak identification if peak identification mode is ON and
    % information provided in arguments 9, 10, and 11.
    if PeakID, % If peak identification mode is ON
        for n=1:length(PP(:,2)),
            %      [PP(n,2) Positionsv(n)]
            m=val2ind(Positions,PP(n,2)); % m=index of the cloest match in Positions
            xError=abs(PP(n,2)-Positions(m)); % xError=difference between detected peak and nearest peak in table
            if xError<maxerror, % Only identify the peaks if the error is less than MaxError
                text(PP(n,2),PP(n,3),Names(m)); % Label the graph peaks with element names
            end % if xerror
        end  % for n
    end  % if PeakID
end  % if any peaks are detected
hold off
% ----------------------------------------------------------------------    
function [xx,yy]=RedrawSignal(X,Y,xo,dx)
% Plots the entire signal (X,Y) in the lower half of the plot window and an
% isolated segment (xx,yy) in the upper half, controlled by Pan and Zoom
% keys.
global SlopeThreshold AmpThreshold SmoothWidth FitWidth PeakLabels PeakMode
global PeakID Names Positions maxerror P plotcolor logplot AUTOZERO Sharpen
global SavedY ShapeMode
xo=xo(1);
Startx=round(xo-(dx/2));
Endx=abs(round(xo+(dx/2)-1));
if (Endx-Startx)<SmoothWidth,Endx=Startx+SmoothWidth;end
if Endx>length(Y),Endx=length(Y);end
if Startx<1,Startx=1;end
PlotRange=Startx:Endx;
if (Endx-Startx)<5, PlotRange=xo:xo+5;end
xx=X(PlotRange);
yy=Y(PlotRange);
hold off
% clf
% Plots isolated segment (xx,yy) in the upper half
switch plotcolor
    case 0
        color='b.';
    case 1
        color='g.';
    case 2
        color='r.';
    case 3
        color='c.';
    case 4
        color='m.';
    case 5
        color='k.';
end

% Autozero computation
lxx=length(xx);
if AUTOZERO==1, % linear auto-zero operation
    X1=min(xx);
    X2=max(xx);
    Y1=mean(yy(1:lxx/20));
    Y2=mean(yy((lxx-lxx/20):lxx));
    yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
end % if AUTOZERO==1,
bkgsize=round(length(xx)/10);
if bkgsize<2,bkgsize=2;end
if AUTOZERO==2, % Quadratic autozero operation  
    XX1=xx(1:round(lxx/bkgsize));
    XX2=xx((lxx-round(lxx/bkgsize)):lxx);
    Y1=yy(1:round(length(xx)/bkgsize));
    Y2=yy((lxx-round(lxx/bkgsize)):lxx);
    bkgcoef=polyfit([XX1;XX2],[Y1;Y2],2);  % Fit parabola to sub-group of points
    bkg=polyval(bkgcoef,xx);
    yy=yy-bkg;
end % if autozero==2
 if AUTOZERO==3;yy=yy-min(yy);end
 
figure(1);subplot(2,1,1);plot(xx,yy,color);
hold off
switch AUTOZERO
    case 0
        if PeakMode,
            title('ipeak 6.3  Valley mode.    Autozero OFF.   Press K for keyboard commands')
        else
            if Sharpen,
                title('ipeak 6.3  Sharpen mode.   Autozero OFF.   Press K for keyboard commands')
            else
                if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                    title('ipeak 6.3  Gaussian mode.      Autozero OFF.   Press K for keyboard commands')
                else
                    title('ipeak 6.3  Lorentzian mode.    Autozero OFF.   Press K for keyboard commands')                    
                end
            end
        end
    case 1
        if PeakMode,
            title('ipeak 6.3  Valley mode.   Linear autozero.  Press K for keyboard commands')
        else
            if Sharpen,
                title('ipeak 6.3  Sharpen mode.  Linear autozero.  Press K for keyboard commands')
            else
                if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                    title('ipeak 6.3  Gaussian mode.    Linear autozero.   Press K for keyboard commands')
                else
                    title('ipeak 6.3  Lorentzian mode.  Linear autozero.   Press K for keyboard commands')
                end
            end
        end
    case 2
        if PeakMode,
                title('ipeak 6.3 Valley mode.  Quadratic autozero.  Press K for keyboard commands')
        else
            if Sharpen,
                title('ipeak 6.3 Sharpen mode. Quadratic autozero.  Press K for keyboard commands')
            else
                if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                    title('ipeak 6.3  Gaussian mode.   Quadratic autozero.   Press K for keyboard commands')
                else
                    title('ipeak 6.3  Lorentzian mode. Quadratic autozero.   Press K for keyboard commands')
                end
            end
        end  
    case 3
        if PeakMode,
                title('ipeak 6.3 Valley mode.  Flat baseline mode.  Press K for keyboard commands')
        else
            if Sharpen,
                title('ipeak 6.3 Sharpen mode. Flat baseline mode.  Press K for keyboard commands')
            else
                if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                    title('ipeak 6.3  Gaussian mode.   Flat baseline mode.   Press K for keyboard commands')
                else
                    title('ipeak 6.3  Lorentzian mode. Flat baseline mode.   Press K for keyboard commands')
                end
            end
        end  
end % switch
axis([X(Startx(1)) X(Endx(1)) min(yy) max(yy)+(max(yy)-min(yy))/10]);
xlabel('Space/Tab: next/previous peak.  Mode: U  Autozero: T   Log/linear: Y  Report: R   Shape: Shift-G')

% Bottom half of the figure shows full signal
subplot(2,1,2);cla
switch plotcolor
    case 0; color='b';
    case 1; color='g';
    case 2; color='r';
    case 3; color='c';
    case 4; color='m';
    case 5; color='k';
end
hold off
if logplot,
    semilogy(X,abs(Y),color)  % Graph the signal with linear Y axis
else
    plot(X,Y,color)  % Graph the signal with linear Y axis
end
if PeakMode,
  P=findvalleys(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth,2);
else
  P=findpeaks(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth,2);   
end
title('AmpT: A/Z   SlopeT: S/X   SmoothW: D/C    FitW: F/V   Background: B   Sharpen: H'  )
if logplot,
    ylabel('Log y mode')
    xlabel(['    AmpT: ' num2str(AmpThreshold) '     SlopeT: ' num2str(SlopeThreshold) '    SmoothW: ' num2str(SmoothWidth) '    FitW: ' num2str(FitWidth) ])
    axis([X(1) X(length(X)) min(abs(Y)) max(Y)]); % Update plot
else
    ylabel('Linear mode')
    xlabel(['    AmpT: ' num2str(AmpThreshold) '     SlopeT: ' num2str(SlopeThreshold) '    SmoothW: ' num2str(SmoothWidth) '    FitW: ' num2str(FitWidth) ])
    axis([X(1) X(length(X)) min(Y) max(Y)]); % Update plot
end
text(P(:,2),P(:,3),num2str(P(:,1)))  % Number the peaks found on the lower graph
hold on
% Mark the zoom range on the full signal with two magenta dotted vertical lines
center=X(round(xo));
checkzero=abs(Y);
checkzero(~checkzero)=NaN; % Find smallest non-zero value
plot([min(xx) min(xx)],[min(checkzero) max(Y)],'m--')
plot([max(xx) max(xx)],[min(checkzero) max(Y)],'m--')
plot([center center],[min(checkzero) max(Y)],'g-')
% Number the peaks found on the upper graph
subplot(2,1,1);
if PeakMode,
  PP=findvalleys(xx,yy,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth,2);
else
  PP=findpeaks(xx,yy,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth,2);   
end
X1=min(xx);
X2=max(xx);
if PeakLabels,
    % Label the peaks on the upper graph with number, position, height, and
    % width
    % auto-zero operation
    % Autozero computation
    lxx=length(xx);
    if AUTOZERO==1, % linear auto-zero operation
        X1=min(xx);
        X2=max(xx);
        Y1=mean(yy(1:lxx/20));
        Y2=mean(yy((lxx-lxx/20):lxx));
        yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
    end % if AUTOZERO==1,
    bkgsize=round(length(xx)/10);
    if bkgsize<2,bkgsize=2;end
    if AUTOZERO==2, % Quadratic autozero operation
        XX1=xx(1:round(lxx/bkgsize));
        XX2=xx((lxx-round(lxx/bkgsize)):lxx);
        Y1=yy(1:round(length(xx)/bkgsize));
        Y2=yy((lxx-round(lxx/bkgsize)):lxx);
        bkgcoef=polyfit([XX1;XX2],[Y1;Y2],2);  % Fit parabola to sub-group of points
        bkg=polyval(bkgcoef,xx);
        yy=yy-bkg;
    end % if autozero==2
    topaxis=axis;
    yrange=topaxis(4)-topaxis(3);
    pos1=.1*yrange;
    pos2=.2*yrange;
    pos3=.3*yrange;
    pos4=.4*yrange;
    text(P(:,2),P(:,3)-pos1,num2str(P(:,1)))
    text(PP(:,2),PP(:,3)-pos2,num2str(PP(:,2)))
    text(PP(:,2),PP(:,3)-pos3,num2str(PP(:,3)))
    text(PP(:,2),PP(:,3)-pos4,num2str(PP(:,4)))
else
    topaxis=axis;
    yrange=topaxis(4)-topaxis(3);
    pos1=.1*yrange;
    % Number the peaks on the upper graph
    sp=size(P);lp=sp(1);
    for Peak=1:lp,
        if P(Peak,2)>X1 && P(Peak,2)<X2 && lp>1,
            text(P(Peak,2),yy(val2ind(xx,P(Peak,2)))-pos1,num2str(P(Peak,1)))
        end
    end
end
hold on
lyy=min(yy);
uyy=max(yy)+(max(yy)-min(yy))/10;
if lyy<uyy;
    axis([X(Startx(1)) X(Endx(1)) lyy uyy ]);
end
center=X(round(xo));
hold on;plot([center center],[lyy uyy],'g-')
% Draw red best-fit line through peak tops in upper windows.
if PP(1)>0, % if any peaks are detected
    sizePP=size(PP);
    lengthPP=sizePP(1);
    for PeakNumber=1:lengthPP,
        subplot(2,1,1);
        if PeakNumber>lengthPP,PeakNumber=lengthPP;end
        n1=round(val2ind(xx,PP(PeakNumber,2))-FitWidth/2);
        n2=round(val2ind(xx,PP(PeakNumber,2))+FitWidth/2);
        if n1<1, n1=1;end
        if n2>length(yy), n2=length(yy);end
        PlotRange=n1:n2;
        xxx=rmnan(xx(PlotRange));
        yyy=rmnan(yy(PlotRange));
        if PeakMode,
            [coef,S]=polyfit(xxx,yyy,2);  % Fit parabola to sub-group with centering and scaling
            c1=coef(3);c2=coef(2);c3=coef(1);
            subplot(2,1,1);
            plotspace=linspace(min(xxx),max(xxx));
            plot(plotspace,c3*plotspace.^2+c2*plotspace+c1,'r');
        else
            yyy=smoothnegs(yyy);
            if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                [coef,S,MU]=polyfit(xxx,rmnan(log(yyy)),2);
                c1=coef(3);c2=coef(2);c3=coef(1);
                % Compute peak position and height Gaussian
                PeakX=real(-((MU(2).*c2/(2*c3))-MU(1)));
                PeakY=real(exp(c1-c3*(c2/(2*c3))^2));
                MeasuredWidth=real(norm(MU(2).*2.35482/(sqrt(2)*sqrt(-1*c3))));
            else
                z=ones(size(xxx))./yyy;
                coef=polyfit(xxx,z,2);
                PeakY=real(4*coef(1)./((4*coef(1)*coef(3))-coef(2)^2));
                PeakX=real(-coef(2)/(2*coef(1)));
                MeasuredWidth=real(sqrt(((4*coef(1)*coef(3))-coef(2)^2)./coef(1))./sqrt(coef(1)));
            end
            subplot(2,1,1);
            try
                plotspace=linspace(min(xxx),max(xxx));
            catch me
                disp(me)
                xxx=xxx
                minxxx=min(xxx)
                maxxxx=max(xxx)
            end
             % Draw red peak top
            if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                plot(plotspace,PeakY.*gaussian(plotspace,PeakX,MeasuredWidth),'r');
            else
                plot(plotspace,PeakY.*lorentzian(plotspace,PeakX,MeasuredWidth),'r');
            end
        end
    end   % for PeakNumber
    % Place a label in the upper left corner with peak number, position,
    % height, and width of the peak closest to the center of the window.
    PeakAtCenter=val2ind(P(:,2),center);
    % auto-zero operation
    % Autozero computation
    lxx=length(xx);
    if AUTOZERO==1, % linear auto-zero operation
        X1=min(xx);
        X2=max(xx);
        Y1=mean(yy(1:lxx/20));
        Y2=mean(yy((lxx-lxx/20):lxx));
        yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
    end % if AUTOZERO==1,
    bkgsize=round(length(xx)/10);
    if bkgsize<2,bkgsize=2;end
    if AUTOZERO==2, % Quadratic autozero operation
        XX1=xx(1:round(lxx/bkgsize));
        XX2=xx((lxx-round(lxx/bkgsize)):lxx);
        Y1=yy(1:round(length(xx)/bkgsize));
        Y2=yy((lxx-round(lxx/bkgsize)):lxx);
        bkgcoef=polyfit([XX1;XX2],[Y1;Y2],2);  % Fit parabola to sub-group of points
        bkg=polyval(bkgcoef,xx);
        yy=yy-bkg;
    end % if autozero==2
    n1=round(val2ind(xx,P(PeakAtCenter,2))-FitWidth/2);
    n2=round(val2ind(xx,P(PeakAtCenter,2))+FitWidth/2);
    if n1<1, n1=1;end
    if n2>length(yy), n2=length(yy);end
    FitRange=n1:n2;
    xxx=rmnan(xx(FitRange));
    yyy=rmnan(yy(FitRange));
    if PeakMode,
        [coef]=polyfit(xxx,yyy,2);  % Fit parabola to sub-group with centering and scaling
        c1=coef(3);c2=coef(2);c3=coef(1);
        PeakX=-c2/(2*c3);
        PeakY=(c1-(c2*c2/(4*c3)));
        MeasuredWidth=real(norm(2.35482/(sqrt(2)*sqrt(-1*c3))));
        EstimatedArea=0;
        residual=yyy-polyval(coef,xxx);
        FError=100.*abs(std(residual)./max(yyy));
    else
         yyy=smoothnegs(yyy);
         if ShapeMode,  % 1=Gaussian, 0=Lorentzian
                [coef,S,MU]=polyfit(xxx,rmnan(log(yyy)),2);
                c1=coef(3);c2=coef(2);c3=coef(1);
                % Compute peak position and height Gaussian
                PeakX=real(-((MU(2).*c2/(2*c3))-MU(1)));
                PeakY=real(exp(c1-c3*(c2/(2*c3))^2));
                MeasuredWidth=real(norm(MU(2).*2.35482/(sqrt(2)*sqrt(-1*c3))));
                residual=yyy-PeakY*gaussian(xxx,PeakX,MeasuredWidth);
                FError=100.*std(residual)./PeakY;
            else
                z=ones(size(xxx))./yyy;
                coef=polyfit(xxx,z,2);
                PeakY=real(4*coef(1)./((4*coef(1)*coef(3))-coef(2)^2));
                PeakX=real(-coef(2)/(2*coef(1)));
                MeasuredWidth=real(sqrt(((4*coef(1)*coef(3))-coef(2)^2)./coef(1))./sqrt(coef(1)));
                residual=yyy-PeakY*lorentzian(xxx,PeakX,MeasuredWidth);
                FError=100.*std(residual)./PeakY;
         end     
    end
    startx=min(xx)+(max(xx)-min(xx))./20;
    dyy=(max(yy)-min(yy))./10;
    starty=max(yy)-dyy;
    if PeakMode,
        text(startx,starty+dyy/2,['Valley ' num2str(PeakAtCenter) ] );
    else
        text(startx,starty+dyy/2,['Peak ' num2str(PeakAtCenter) ] );
    end
    topaxis=axis;
    yrange=topaxis(4)-topaxis(3);
    pos1=.1*yrange;
    pos2=.2*yrange;
    pos3=.3*yrange;
    pos4=.4 *yrange;
    pos5=.5 *yrange;
    text(startx,starty+dyy/2-pos1,['Position: ' num2str(PeakX)])
    text(startx,starty+dyy/2-pos2,['Height: ' num2str(PeakY)])
    text(startx,starty+dyy/2-pos3,['Width: ' num2str(MeasuredWidth)])
    if ShapeMode,
        text(startx,starty+dyy/2-pos4,['Area: ' num2str(1.0646.*PeakY*MeasuredWidth)])
    else
        text(startx,starty+dyy/2-pos4,['Area: ' num2str(1.57.*PeakY*MeasuredWidth)])
    end
    text(startx,starty+dyy/2-pos5,['% Fitting error: ' num2str(FError)])
    % Add peak identification if peak identification mode is ON and
    % information provided in arguments 9, 10, and 11.
    if PeakID, % If peak identification mode is ON
        for n=1:length(PP(:,2)),
            %      [PP(n,2) Positionsv(n)]
            m=val2ind(Positions,PP(n,2)); % m=index of the cloest match in Positions
            xError=abs(PP(n,2)-Positions(m)); % xError=difference between detected peak and nearest peak in table
            if xError<maxerror, % Only identify the peaks if the FError is less than MaxError
                text(PP(n,2),PP(n,3),Names(m)); % Label the graph peaks with element names
            end % if FError
        end  % for n
    end  % if PeakID
end  % if any peaks are detected
hold off
sizeP=size(P);
NumPeaks=sizeP(1);
P=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,PeakMode);
%-----------------------------------------------------------------
function PP=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,PeakMode)
global ShapeMode  % 1=Gaussian, 0=Lorentzian
% PP=zeros(size(P));
for PeakNumber=1:NumPeaks,
    center=P(PeakNumber,2);
    try
        xo=val2ind(X,center);xo=xo(1);
    catch me
        xo=1;
    end
    Startx=round(xo-(dx/2));
    Endx=abs(round(xo+(dx/2)-1));
    if (Endx-Startx)<SmoothWidth,Endx=Startx+SmoothWidth;end
    if Endx>length(Y),Endx=length(Y);end
    if Startx<1,Startx=1;end
    PlotRange=Startx:Endx;
    if (Endx-Startx)<5, PlotRange=xo:xo+5;end
    xx=X(PlotRange);
    yy=Y(PlotRange);
% Autozero computation
lxx=length(xx);
if AUTOZERO==1, % linear auto-zero operation
    X1=min(xx);
    X2=max(xx);
    Y1=mean(yy(1:lxx/20));
    Y2=mean(yy((lxx-lxx/20):lxx));
    yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
end % if AUTOZERO==1,
bkgsize=round(length(xx)/10);
if bkgsize<2,bkgsize=2;end
if AUTOZERO==2, % Quadratic autozero operation  
    XX1=xx(1:round(lxx/bkgsize));
    XX2=xx((lxx-round(lxx/bkgsize)):lxx);
    Y1=yy(1:round(length(xx)/bkgsize));
    Y2=yy((lxx-round(lxx/bkgsize)):lxx);
    bkgcoef=polyfit([XX1;XX2],[Y1;Y2],2);  % Fit parabola to sub-group of points
    bkg=polyval(bkgcoef,xx);
    yy=yy-bkg;
end % if autozero==2
    n1=round(val2ind(xx,P(PeakNumber,2))-FitWidth/2);
    n2=round(val2ind(xx,P(PeakNumber,2))+FitWidth/2);
    if n1<1, n1=1;end
    if n2>length(yy), n2=length(yy);end
    FitRange=n1:n2;
    xxx=rmnan(xx(FitRange));
    yyy=rmnan(yy(FitRange));
    if PeakMode,
        [coef]=polyfit(xxx,yyy,2);  % Fit parabola to sub-group xxx, yyy
        c1=coef(3);c2=coef(2);c3=coef(1);
        PeakX=-c2/(2*c3);
        PeakY=(c1-(c2*c2/(4*c3)));
        MeasuredWidth=real(norm(2.35482/(sqrt(2)*sqrt(-1*c3))));
        EstimatedArea=0;
        residual=yyy-polyval(coef,xxx);
        FError=100.*abs(std(residual)./max(yyy));
    else
        yyy=smoothnegs(yyy);
        if ShapeMode,  % 1=Gaussian, 0=Lorentzian
            [coef,S,MU]=polyfit(xxx,rmnan(log(yyy)),2);
            c1=coef(3);c2=coef(2);c3=coef(1);
            % Compute peak position and height Gaussian
            PeakX=real(-((MU(2).*c2/(2*c3))-MU(1)));
            PeakY=real(exp(c1-c3*(c2/(2*c3))^2));
            MeasuredWidth=real(norm(MU(2).*2.35482/(sqrt(2)*sqrt(-1*c3))));
            EstimatedArea=1.0646.*PeakY*MeasuredWidth;
            residual=yyy-PeakY*gaussian(xxx,PeakX,MeasuredWidth);
            FError=100.*std(residual)./PeakY;
        else
            z=real(ones(size(xxx))./yyy);
            coef=polyfit(xxx,z,2);
            PeakY=real(4*coef(1)./((4*coef(1)*coef(3))-coef(2)^2));
            PeakX=-real(coef(2)/(2*coef(1)));
            MeasuredWidth=real(sqrt(((4*coef(1)*coef(3))-coef(2)^2)./coef(1))./sqrt(coef(1)));
            EstimatedArea=1.57.*PeakY*MeasuredWidth;
            residual=yyy-PeakY*lorentzian(xxx,PeakX,MeasuredWidth);
            FError=100.*abs(std(residual)./PeakY);
        end
        
    end
%     size(PP(PeakNumber,:))
%     size([PeakNumber PeakX PeakY MeasuredWidth EstimatedArea FError])
    PP(PeakNumber,:)=[PeakNumber PeakX PeakY MeasuredWidth EstimatedArea FError];
end   % for PeakNumber
% ----------------------------------------------------------------------
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
% (c) T.C. O'Haver, 1995, 2014.  Version 5.3, Last revised December, 2014  
% line 91: changed log(abs(yy)) to rmnan(log(yy)); added rmnan function
%
% Examples:
% findpeaks(0:.01:2,humps(0:.01:2),0,-1,5,5)
% x=[0:.01:50];findpeaks(x,cos(x),0,-1,5,5)
% x=[0:.01:5]';findpeaks(x,x.*sin(x.^2).^2,0,-1,5,5)
% x=[-10:.1:10];y=exp(-(x).^2);findpeaks(x,y,0.005,0.3,3,5,3)
%
% Related functions:
% findvalleys.m, findpeaksL.m, findpeaksb.m, findpeaksb3.m,
% findpeaksplot.m, peakstats.m, findpeaksnr.m, findpeaksGSS.m,
% findpeaksLSS.m, findpeaksfit.m, findsteps.m, findsquarepulse.m, idpeaks.m

% Copyright (c) 2013, 2014 Thomas C. O'Haver
%
if nargin~=7;smoothtype=1;end  % smoothtype=1 if not specified in argument
if smoothtype>3;smoothtype=3;end
if smoothtype<1;smoothtype=1;end
if smoothwidth<1;smoothwidth=1;end
smoothwidth=round(smoothwidth);
peakgroup=round(peakgroup);
if smoothwidth>1,
    d=fastsmooth(deriv(y),smoothwidth,smoothtype);
else
    d=deriv(y);
end
n=round(peakgroup/2+1);
P=[0 0 0 0 0 0];
vectorlength=length(y);
peak=1;
AmpTest=AmpThreshold;
for j=smoothwidth:length(y)-smoothwidth,
    if sign(d(j)) > sign (d(j+1)), % Detects zero-crossing
        if d(j)-d(j+1) > SlopeThreshold*y(j), % if slope of derivative is larger than SlopeThreshold
            if y(j) > AmpTest,  % if height of peak is larger than AmpThreshold
                xx=zeros(size(peakgroup));yy=zeros(size(peakgroup));
                for k=1:peakgroup, % Create sub-group of points near peak
                    groupindex=j+k-n+1;
                    if groupindex<1, groupindex=1;end
                    if groupindex>vectorlength, groupindex=vectorlength;end
                    xx(k)=rmnan(x(groupindex));yy(k)=rmnan(y(groupindex));
                end
                yy=smoothnegs(yy);
                [coef,S,MU]=polyfit(xx,rmnan(log(yy)),2);  % Fit parabola to log10 of sub-group with centering and scaling
                c1=coef(3);c2=coef(2);c3=coef(1);
                PeakX=real(-((MU(2).*c2/(2*c3))-MU(1)));   % Compute peak position and height of fitted parabola
                PeakY=real(exp(c1-c3*(c2/(2*c3))^2));
                MeasuredWidth=real(norm(MU(2).*2.35482/(sqrt(2)*sqrt(-1*c3))));
                residual=yy-PeakY*gaussian(xx,PeakX,MeasuredWidth);
                FError=100.*abs(std(residual)./PeakY);
                % if the peak is too narrow for least-squares technique to work
                % well, just use the max value of y in the sub-group of points near peak.
                if peakgroup<3,
                    PeakY=max(yy);
                    pindex=val2ind(yy,PeakY);
                    PeakX=xx(pindex(1));
                end
                % Construct matrix P. One row for each peak
                % detected, containing the peak number, peak
                % position (x-value) and peak height (y-value).
                if isnan(PeakX) || isnan(PeakY) || PeakY<AmpThreshold,
                else
                    P(peak,:) = [round(peak) PeakX PeakY MeasuredWidth 1.0646.*PeakY*MeasuredWidth FError];
                    peak=peak+1;
                end
            end
        end
    end
end
% ----------------------------------------------------------------------
function P=findsteps(x,y,SlopeThreshold,AmpThreshold,peakgroup)
% function P=findsteps(x,y,SlopeThreshold,AmpThreshold,peakgroup)
% Function to locate the positive steps in a noisy x-y time series data
% set. Detects steps by computing the first derivative of y that exceed
% SlopeThreshold, computes the step height by taking the difference between
% the maximum and minimum y values over a number of data point equal to
% "Peakgroup". Returns list (P) containing step number, x position, y value
% and the step height of each step detected. Arguments "slopeThreshold",
% "AmpThreshold" control step sensivity; higher values will neglect smaller
% features. 
% Copyright (c) 2014, Thomas C. O'Haver
% 
peakgroup=round(peakgroup);
d=fastsmooth(deriv(y),3,2);
P=[0 0 0 0 0 0];
upstep=1;
j=peakgroup;
while j<length(y)-peakgroup,
    if d(j) > SlopeThreshold, % if derivative is larger than SlopeThreshold
        startgroup=j-peakgroup/2+1;
        endgroup=j+peakgroup+1;
        miny=min(y(startgroup:endgroup));
        maxy=max(y(startgroup:endgroup));
        % Construct matrix P. One row for each upstep
        if (maxy-miny)>AmpThreshold,
            % count this as a valid peak
            P(upstep,:) = [round(upstep) j x(j) y(j) miny maxy];
            upstep=upstep+1; % Move on to next peak
        end %   if (maxy-miny)>AmpThreshold,
%         plot(x(startgroup:endgroup),y(startgroup:endgroup))
%         pause
        j=j+peakgroup;
    end
    j=j+1;
end
% ----------------------------------------------------------------------
function d=deriv(a)
% First derivative of vector using 2-point central difference.
%  T. C. O'Haver, 1988.
n=length(a);
d(1)=a(2)-a(1);
d(n)=a(n)-a(n-1);
for j = 2:n-1;
    d(j)=(a(j+1)-a(j-1)) ./ 2;
end
% ----------------------------------------------------------------------
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
function [FitResults,LowestError,baseline,BestStart,xi,yi,BootResults]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials,start,autozero,fixedparameters,plots,bipolar)
global AA xxx PEAKHEIGHTS FIXEDWIDTH FIXEDPOSITIONS AUTOZERO delta BIPOLAR
% peakfit.m version 5.1, February 2014
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
        BIPOLAR=0;
    case 2
        NumPeaks=1;
        peakshape=1;
        extra=0;
        NumTrials=1;
        xx=signal;yy=center;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        plots=1;
        BIPOLAR=0;
    case 3
        NumPeaks=1;
        peakshape=1;
        extra=0;
        NumTrials=1;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
        BIPOLAR=0;
    case 4
        peakshape=1;
        extra=0;
        NumTrials=1;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
        BIPOLAR=0;
    case 5
        extra=zeros(1,NumPeaks);
        NumTrials=1;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
        BIPOLAR=0;
    case 6
        NumTrials=1;
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
        BIPOLAR=0;
    case 7
        start=calcstart(xx,NumPeaks,xoffset);
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
        BIPOLAR=0;
    case 8
        AUTOZERO=0;
        FIXEDWIDTH=0;
        plots=1;
        BIPOLAR=0;
    case 9
        AUTOZERO=autozero;
        FIXEDWIDTH=0;
        plots=1;
        BIPOLAR=0;
    case 10
        AUTOZERO=autozero;
        FIXEDWIDTH=fixedparameters;
        plots=1;
        BIPOLAR=0;
    case 11
        AUTOZERO=autozero;
        FIXEDWIDTH=fixedparameters;
        BIPOLAR=0;
    case 12
        AUTOZERO=autozero;
        FIXEDWIDTH=fixedparameters;
        BIPOLAR=bipolar;
    otherwise
end % switch nargin

% Default values for placeholder zeros
if NumTrials==0;NumTrials=1;end
if isscalar(peakshape),
else
    % disp('peakshape is vector');
    shapesvector=peakshape;
    NumPeaks=length(peakshape);
    peakshape=22;
end
if peakshape==0;peakshape=1;end
if NumPeaks==0;NumPeaks=1;end
if start==0;start=calcstart(xx,NumPeaks,xoffset);end
if FIXEDWIDTH==0, FIXEDWIDTH=length(xx)/10;end
if peakshape==16;FIXEDPOSITIONS=fixedparameters;end
if AUTOZERO>3,AUTOZERO=3,end
if AUTOZERO<0,AUTOZERO=0,end
delta=1;

% % Remove linear baseline from data segment if AUTOZERO==1
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
switch peakshape(1)
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
    case 21
        ShapeString='triangular';
    case 22
        ShapeString=num2str(shapesvector);
    otherwise
end % switch peakshape
  
% Perform peak fitting for selected peak shape using fminsearch function
options = optimset('TolX',.001,'Display','off','MaxFunEvals',1000 );
LowestError=1000; % or any big number greater than largest error expected
FitParameters=zeros(1,NumPeaks.*2); 
BestStart=zeros(1,NumPeaks.*2); 
height=zeros(1,NumPeaks); 
bestmodel=zeros(size(yy));

for k=1:NumTrials, 
    % StartVector=newstart
    % disp(['Trial number ' num2str(k) ] ) % optionally prints the current trial number as progress indicator
  switch peakshape(1)
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
          TrialParameters=fminsearch(@(lambda)(FitFWGaussian(lambda,xx,yy)),fixedstart,options);
      case 12
          fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=min(xx)+pc.*(max(xx)-min(xx))./(NumPeaks+1);
          end
          TrialParameters=fminsearch(@(lambda)(FitFWLorentzian(lambda,xx,yy)),fixedstart,options);
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
              fixedstart(pc)=fixedstart(pc)+.1*(rand-.5).*fixedstart(pc);
          end
          TrialParameters=fminsearch(@(lambda)(FitFPGaussian(lambda,xx,yy)),fixedstart,options);
      case 17
           fixedstart=[];
          for pc=1:NumPeaks,
              fixedstart(pc)=(max(xx)-min(xx))./(NumPeaks+1);
              fixedstart(pc)=fixedstart(pc)+.1*(rand-.5).*fixedstart(pc);
          end
          TrialParameters=fminsearch(@(lambda)(FitFPLorentzian(lambda,xx,yy)),fixedstart,options);
      case 18
        zxx=[zeros(size(xx)) xx zeros(size(xx)) ];
        zyy=[ones(size(yy)).*yy(1) yy zeros(size(yy)).*yy(length(yy)) ];
%         plot(zxx,zyy);pause
        TrialParameters=fminsearch(@(lambda)(fitexplorentzian(lambda,zxx,zyy,-extra)),newstart,options);     
      case 19
          TrialParameters=fminsearch(@(lambda)(fitalphafunction(lambda,xx,yy)),newstart,options);
      case 20
          TrialParameters=fminsearch(@(lambda)(fitvoigt(lambda,xx,yy,extra)),newstart,options);
      case 21
          TrialParameters=fminsearch(@(lambda)(fittriangular(lambda,xx,yy)),newstart,options);
      case 22
          TrialParameters=fminsearch(@(lambda)(fitmultiple(lambda,xx,yy,shapesvector,extra)),newstart,options);
      otherwise
  end % switch peakshape
  
% Construct model from Trial parameters
A=zeros(NumPeaks,n);
for m=1:NumPeaks,
    switch peakshape(1)
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
        case 21
            A(m,:)=triangular(xx,TrialParameters(2*m-1),TrialParameters(2*m));
        case 22
            A(m,:)=peakfunction(shapesvector(m),xx,TrialParameters(2*m-1),TrialParameters(2*m),extra(m));        
        otherwise
    end % switch
    for parameter=1:2:2*NumPeaks,
        newstart(parameter)=newstart(parameter)*(1+delta*(rand-.5)/500);
        newstart(parameter+1)=newstart(parameter+1)*(1+delta*(rand-.5)/100);
    end
end % for NumPeaks

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
      if min(Heights)>=-BIPOLAR*10^100,  % Consider only fits with positive peak heights
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
   switch peakshape(1)
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
    case 21
        AA(m,:)=triangular(xxx,FitParameters(2*m-1),FitParameters(2*m));
    case 22
        AA(m,:)=peakfunction(shapesvector(m),xxx,FitParameters(2*m-1),FitParameters(2*m),extra(m));        
       otherwise
  end % switch
end % for NumPeaks

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
    if peakshape(1)==16||peakshape(1)==17
    else
        for marker=1:NumPeaks,
            markx=BestStart((2*marker)-1);
            subplot(2,1,1);plot([markx+xoffset markx+xoffset],[0 max(yy)],'m--')
        end % for
    end % if peakshape
    plot(xxx+xoffset,mmodel,'r');  % Plot the total model (sum of component peaks) in red lines
    hold off;
    lyy=min(yy);
    uyy=max(yy)+(max(yy)-min(yy))/10;
    if BIPOLAR,
        axis([min(xx) max(xx) lyy uyy]);
        ylabel('+ - mode')
    else
        axis([min(xx) max(xx) 0 uyy]);
        ylabel('+ mode')
    end
    switch AUTOZERO,
        case 0
            title(['peakfit 5   No baseline correction'])
        case 1
            title(['peakfit 5   Linear baseline subtraction'])
        case 2
            title(['peakfit 5   Quadratic subtraction baseline'])
        case 3
            title(['peakfit 5   Flat baseline correction'])
    end
 
    switch peakshape(1)
    case {4,20}
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '      Shape Constant = ' num2str(extra) '   Error = ' num2str(round(1000*LowestError)/1000) '%' ] )
    case {5,8,18}
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '      Time Constant = ' num2str(extra) '   Error = ' num2str(round(1000*LowestError)/1000) '%' ] )
    case 13
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '      % Gaussian = ' num2str(extra)  '     Error = ' num2str(round(1000*LowestError)/1000) '% ' ] )
    case {14,15,22}
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '      extra = ' num2str(extra) '     Error = ' num2str(round(1000*LowestError)/1000)  '% ' ] )
    otherwise
        xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '     Error = ' num2str(round(1000*LowestError)/1000) '% ' ] )
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
        if peakshape(1)==6||peakshape(1)==7||peakshape(1)==8, % equal-width peak models only
            FitResults=[[round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
            if peakshape(1)==11||peakshape(1)==12, % Fixed-width shapes only
                FitResults=[[round(m) FitParameters(m)+xoffset height(m) FIXEDWIDTH area(m)]];
            else
                if peakshape(1)==16||peakshape(1)==17, % Fixed-position shapes only
                    FitResults=[round(m) FIXEDPOSITIONS(m) height(m) FitParameters(m) area(m)];
                else
                    FitResults=[round(m) FitParameters(2*m-1)+xoffset height(m) abs(FitParameters(2*m)) area(m)];
                end
            end
        end % if peakshape
    else
        if peakshape(1)==6||peakshape(1)==7||peakshape(1)==8, % equal-width peak models only
            FitResults=[FitResults ; [round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
            if peakshape(1)==11||peakshape(1)==12, % Fixed-width shapes only
                FitResults=[FitResults ; [round(m) FitParameters(m)+xoffset height(m) FIXEDWIDTH area(m)]];
            else
                if peakshape(1)==16||peakshape(1)==17, % Fixed-position shapes only
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
    if peakshape(1)==9||peakshape(1)==10||peakshape(1)==19,  % Pulse and sigmoid shapes only
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

if NumArgOut==7,
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
global PEAKHEIGHTS FIXEDWIDTH FIXEDPOSITIONS AUTOZERO BIPOLAR
format short g
format compact
warning off all
FIXEDWIDTH=fixedparameters;
xoffset=0;
if start==0;start=calcstart(xx,NumPeaks,xoffset);end
PEAKHEIGHTS=zeros(1,NumPeaks);
n=length(xx);
newstart=start;

% Perform peak fitting for selected peak shape using fminsearch function
options = optimset('TolX',.001,'Display','off','MaxFunEvals',1000 );
LowestError=1000; % or any big number greater than largest error expected
FitParameters=zeros(1,NumPeaks.*2); 
BestStart=zeros(1,NumPeaks.*2); 
height=zeros(1,NumPeaks); 
bestmodel=zeros(size(yy));
for k=1:NumTrials,
    % StartVector=newstart
    switch peakshape(1)
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
            TrialParameters=fminsearch(@(lambda)(fitsigmoid(lambda,xx,yy)),newstar,optionst);
        case 11
            fixedstart=[];
            for pc=1:NumPeaks,
                fixedstart(pc)=min(xx)+pc.*(max(xx)-min(xx))./(NumPeaks+1);
            end
            TrialParameters=fminsearch(@(lambda)(FitFWGaussian(lambda,xx,yy)),fixedstart,options);
        case 12
            fixedstart=[];
            for pc=1:NumPeaks,
                fixedstart(pc)=min(xx)+pc.*(max(xx)-min(xx))./(NumPeaks+1);
            end
            TrialParameters=fminsearch(@(lambda)(FitFWLorentzian(lambda,xx,yy)),fixedstart,options);
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
            end
            TrialParameters=fminsearch(@(lambda)(FitFPGaussian(lambda,xx,yy)),fixedstart,options);
        case 17
            fixedstart=[];
            for pc=1:NumPeaks,
                fixedstart(pc)=(max(xx)-min(xx))./(NumPeaks+1);
            end
            TrialParameters=fminsearch(@(lambda)(FitFPLorentzian(lambda,xx,yy)),fixedstart,options);
        case 18
            zxx=[zeros(size(xx)) xx zeros(size(xx)) ];
            zyy=[zeros(size(yy)) yy zeros(size(yy)) ];
            TrialParameters=fminsearch(@(lambda)(fitexplorentzian(lambda,zxx,zyy,-extra)),newstart,options);
        case 19
            TrialParameters=fminsearch(@(lambda)(alphafunction(lambda,xx,yy)),newstart,options);
        case 20
            TrialParameters=fminsearch(@(lambda)(fitvoigt(lambda,xx,yy,extra)),newstart,options);
        case 21
            TrialParameters=fminsearch(@(lambda)(fittriangular(lambda,xx,yy)),newstart,options);
        case 22
            TrialParameters=fminsearch(@(lambda)(fitmultiple(lambda,xx,yy,shapesvector,extra)),newstart,options);
        otherwise
    end % switch peakshape
    
    
for peaks=1:NumPeaks,
     peakindex=2*peaks-1;
     newstart(peakindex)=start(peakindex)-xoffset;
end

    % Construct model from Trial parameters
    A=zeros(NumPeaks,n);
    for m=1:NumPeaks,
        switch peakshape(1)
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
            case 21
                A(m,:)=triangular(xx,TrialParameters(2*m-1),TrialParameters(2*m));
            case 22
                A(m,:)=peakfunction(shapesvector(m),xx,TrialParameters(2*m-1),TrialParameters(2*m),extra(m));
        end % switch
        %     for parameter=1:2:2*NumPeaks,
        %         newstart(parameter)=newstart(parameter)*(1+(rand-.5)/50);
        %         newstart(parameter+1)=newstart(parameter+1)*(1+(rand-.5)/10);
        %     end
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
        if min(Heights)>=-BIPOLAR*10^100,  % Consider only fits with positive peak heights
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
        if peakshape(1)==6||peakshape(1)==7||peakshape(1)==8, % equal-width peak models
            FitResults=[[round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
            if peakshape(1)==11||peakshape(1)==12,  % Fixed-width shapes only
                FitResults=[[round(m) FitParameters(m)+xoffset height(m) FIXEDWIDTH area(m)]];
            else
                FitResults=[[round(m) FitParameters(2*m-1)+xoffset height(m) abs(FitParameters(2*m)) area(m)]];
            end
        end % if peakshape
    else
        if peakshape(1)==6||peakshape(1)==7||peakshape(1)==8, % equal-width peak models
            FitResults=[FitResults ; [round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
            if peakshape(1)==11||peakshape(1)==12, % Fixed-width shapes only
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
function [index,closestval]=val2ind(x,val)
% Returns the index and the value of the element of vector x that is closest to val
% If more than one element is equally close, returns vectors of indicies and values
% Tom O'Haver (toh@umd.edu) October 2006
% Examples: If x=[1 2 4 3 5 9 6 4 5 3 1], then val2ind(x,6)=7 and val2ind(x,5.1)=[5 9]
% [indices values]=val2ind(x,3.3) returns indices = [4 10] and values = [3 3]
dif=abs(x-val);
index=find((dif-min(dif))==0);
closestval=x(index);
% ----------------------------------------------------------------------
function err = fitgaussian(lambda,t,y)
% Fitting function for a Gaussian band signal.
global PEAKHEIGHTS AUTOZERO BIPOLAR
numpeaks=round(length(lambda)/2);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,lambda(2*j-1),lambda(2*j))';
end 
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitewgaussian(lambda,t,y)
% Fitting function for a Gaussian band signal with equal peak widths.
global PEAKHEIGHTS AUTOZERO BIPOLAR
numpeaks=round(length(lambda)-1);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,lambda(j),lambda(numpeaks+1))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = FitFWGaussian(lambda,t,y)
%	Fitting function for a fixed width Gaussian
global PEAKHEIGHTS AUTOZERO FIXEDWIDTH BIPOLAR
numpeaks=round(length(lambda));
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,lambda(j),FIXEDWIDTH)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = FitFPGaussian(lambda,t,y)
%	Fitting function for fixed-position Gaussians
global PEAKHEIGHTS AUTOZERO FIXEDPARAMETERS BIPOLAR
numpeaks=round(length(lambda));
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,FIXEDPARAMETERS(j), lambda(j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = FitFPLorentzian(lambda,t,y)
%	Fitting function for fixed-position Lorentzians
global PEAKHEIGHTS AUTOZERO FIXEDPARAMETERS BIPOLAR
numpeaks=round(length(lambda));
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = lorentzian(t,FIXEDPARAMETERS(j), lambda(j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = FitFWLorentzian(lambda,t,y)
%	Fitting function for fixed width Lorentzian
global PEAKHEIGHTS AUTOZERO FIXEDWIDTH BIPOLAR
numpeaks=round(length(lambda));
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = lorentzian(t,lambda(j),FIXEDWIDTH)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitewlorentzian(lambda,t,y)
% Fitting function for a Lorentzian band signal with equal peak widths.
global PEAKHEIGHTS AUTOZERO BIPOLAR
numpeaks=round(length(lambda)-1);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = lorentzian(t,lambda(j),lambda(numpeaks+1))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = lorentzian(t,lambda(2*j-1),lambda(2*j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = logistic(t,lambda(2*j-1),lambda(2*j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
function err = fittriangular(lambda,t,y)
%	Fitting function for triangular, lambda(1)=position, lambda(2)=width
%	between the data and the values computed by the current
%	function of lambda.  Fittriangular assumes a triangular function 
%  T. C. O'Haver, May 2006
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = triangular(t,lambda(2*j-1),lambda(2*j))';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = triangular(x,pos,wid)
%triangle function.  pos=position; wid=half-width (both scalar)
%triangle(x,pos,wid), where x may be scalar or vector,
%pos=position; wid=half-width (both scalar)
% T. C. O'Haver, 1991
% Example
% x=[0:.1:10];plot(x,triangle(x,5.5,2.3),'.')
g=1-(1./wid) .*abs(x-pos);
for i=1:length(x),  
if g(i)<0,g(i)=0;end
end
% ----------------------------------------------------------------------
function err = fitpearson(lambda,t,y,shapeconstant)
%   Fitting functions for a Pearson 7 band signal.
% T. C. O'Haver (toh@umd.edu),   Version 1.3, October 23, 2006.
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = pearson(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = expgaussian(t,lambda(2*j-1),lambda(2*j),timeconstant);
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitexplorentzian(lambda,t,y,timeconstant)
%   Fitting functions for a exponentially-broadened lorentzian band signal.
%  T. C. O'Haver, 2013.
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = explorentzian(t,lambda(2*j-1),lambda(2*j),timeconstant);
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitexpewgaussian(lambda,t,y,timeconstant)
% Fitting function for exponentially-broadened Gaussian bands with equal peak widths.
global PEAKHEIGHTS AUTOZERO BIPOLAR
numpeaks=round(length(lambda)-1);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = expgaussian(t,lambda(j),lambda(numpeaks+1),timeconstant);
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
% Iterative fit of the sum of exponential pulses
% of the form Height.*exp(-tau1.*x).*(1-exp(-tau2.*x)))
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(x),round(length(tau)/2));
for j = 1:length(tau)/2,
    A(:,j) = exppulse(x,tau(2*j-1),tau(2*j));
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(x),round(length(tau)/2));
for j = 1:length(tau)/2,
    A(:,j) = alphafunction(x,tau(2*j-1),tau(2*j));
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = alphafunction(x,pos,spoint)
% alpha function.  pos=position; wid=half-width (both scalar)
% alphafunction(x,pos,wid), where x may be scalar, vector, or matrix
% pos=position; wid=half-width (both scalar)
% Taekyung Kwon, July 2013  
g = (x-spoint)./pos.*exp(1-(x-spoint)./pos);
for m=1:length(x);if g(m)<0;g(m)=0;end;end
% ----------------------------------------------------------------------
function err = fitsigmoid(tau,x,y)
% Fitting function for iterative fit to the sum of
% sigmiods of the form Height./(1 + exp((t1 - t)/t2))
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(x),round(length(tau)/2));
for j = 1:length(tau)/2,
    A(:,j) = sigmoid(x,tau(2*j-1),tau(2*j));
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = GL(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = GL(x,pos,wid,m)
% Gaussian/Lorentzian blend. m = percent Gaussian character
% pos=position; wid=half-width
% m = percent Gaussian character.
%  T. C. O'Haver, 2012
% sizex=size(x)
% sizepos=size(pos)
% sizewid=size(wid)
% sizem=size(m)
g=2.*((m/100).*gaussian(x,pos,wid)+(1-(m(1)/100)).*lorentzian(x,pos,wid))/2;
% ----------------------------------------------------------------------
function err = fitvoigt(lambda,t,y,shapeconstant)
% Fitting functions for Voigt profile function
% T. C. O'Haver (toh@umd.edu), 2013.
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = voigt(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = BiGaussian(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
global PEAKHEIGHTS AUTOZERO BIPOLAR
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = BiLorentzian(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
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
% ----------------------------------------------------------------------
function err = fitmultiple(lambda,t,y,shapesvector,m)
% Fitting function for a multiple-shape band signal.
% The sequence of peak shapes are defined by the vector "shape".
% The vector "m" determines the shape of variable-shape peaks.
global PEAKHEIGHTS AUTOZERO BIPOLAR
numpeaks=round(length(lambda)/2);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = peakfunction(shapesvector(j),t,lambda(2*j-1),lambda(2*j),m(j))';
end 
if AUTOZERO==3,A=[ones(size(y))' A];end
if BIPOLAR,PEAKHEIGHTS=A\y';else PEAKHEIGHTS=abs(A\y');end
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function p=peakfunction(shape,x,pos,wid,m)
switch shape,
    case 1
        p=gaussian(x,pos,wid);
    case 2
        p=lorentzian(x,pos,wid);
    case 3
        p=logistic(x,pos,wid);
    case 4
        p=pearson(x,pos,wid,m);
    case 5
        p=expgaussian(x,pos,wid,m)';
    case 6
        p=gaussian(x,pos,wid);
    case 7
        p=lorentzian(x,pos,wid);
    case 8
        p=expgaussian(x,pos,wid,m)';
    case 9
        p=exppulse(x,pos,wid);
    case 10
        p=sigmoid(x,pos,wid);
    case 11
        p=gaussian(x,pos,wid);
    case 12
        p=lorentzian(x,pos,wid);
    case 13
        p=GL(x,pos,wid,m);
    case 14
        p=BiGaussian(x,pos,wid,m);
    case 15
        p=BiLorentzian(x,pos,wid,m);
    case 16
        p=gaussian(x,pos,wid);
    case 17
        p=lorentzian(x,pos,wid);
    case 18
        p=explorentzian(x,pos,wid,m)';
    case 19
        p=alphafunction(x,pos,wid);
    case 20
        p=voigt(x,pos,wid,m);
    case 21
        p=triangular(x,pos,wid);
    otherwise
end % switch
% ----------------------------------------------------------------------
function Enhancedsignal=enhance(signal,factor1,factor2,SmoothWidth)
% Resolution enhancement function by derivative method. the
% arguments factor1 and factor 2 are 2nd and 4th derivative weighting
% factors. Larger values of factor1 and factor2 will reduce the 
% peak width but will cause artifacts in the baseline near 
% the peak.  Adjust the factors for the the best compromise. 
% Functions required: secderiv.m, fastsmooth.m
d2=deriv2(signal);  % Computes second derivative
d4=deriv2(d2);   % Computes fourth derivative
eh=signal'-factor1.*fastsmooth(d2,SmoothWidth,3)+...
factor2.*fastsmooth(fastsmooth(fastsmooth(d4,SmoothWidth,3),SmoothWidth,3),SmoothWidth,3);
Enhancedsignal=eh';
% ----------------------------------------------------------------------
function d=deriv2(a)
% Second derivative of vector using 3-point central difference.
%  T. C. O'Haver, 2006.
n=length(a);
for j = 2:n-1;
  d(j)=a(j+1) - 2.*a(j) + a(j-1);
end
d(1)=d(2);
d(n)=d(n-1);
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
% ----------------------------------------------------------------------
function y=smoothnegs(y)
% Replaces zeros and negative points with 2 passes of 3-point average
ly=length(y);
if min(y)<=0,
    if y(1)<=0,y(1)=(y(1)+y(2)+y(3))./3;end
    for pnt=2:ly-1,
        if y(pnt)<=0,y(pnt)=y(pnt-1)+y(pnt)+y(pnt+1)./3;end
    end
    if y(ly)<=0,y(ly)=(y(ly-2)+y(ly-1)+y(ly))./3;end
end
if min(y)<=0,
    if y(1)<=0,y(1)=y(1)+y(2)+y(3)./3;end
    for pnt=2:ly-1,
        if y(pnt)<=0,y(pnt)=(y(pnt-1)+y(pnt)+y(pnt+1))./3;end
    end
    if y(ly)<=0,y(ly)=(y(ly-2)+y(ly-1)+y(ly))./3;end
end            