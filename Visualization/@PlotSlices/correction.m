function correction(obj,varargin)
% Set the Upper and Lower limit. It is changeable, but now
% disabled.
%            tll=1;  %Tolerance lower limit.
%Max of tolerance is 1 and zero tolerance is forbidden.
%Choose this value in between.
%            tul=1;  %Tolerance upper limit.
%Max of tolerance is 1 and zero tolerance is forbidden.
%Choose this value in between.

%modified by sandy for photon dep data

%% Gather information
disp('Fermi surface correction: Please select points, enter to end.');
% disp(['Please process Square correction first if needed. '...
%     'Along x or y is permitted. '...
%     'Please select at least three points. '...
%     'Data selection end with Enter.']);

% switch obj.Direction
%     case 'x'
%         d=1;
%         xData=obj.Data.y;
%         yData=obj.Data.z;
%         if size(xData,1) < size(xData,2)
%             xData = xData';
%             yData = yData';
%         end
%     case 'y'
%         d=2;
%         xData=obj.Data.x;
%         yData=obj.Data.z;
%         if size(xData,1) < size(xData,2)
%             xData = xData';
%             yData = yData';
%         end
%     otherwise
%         d=3;
%         xData=obj.Data.x;
%         yData=obj.Data.y;
%         if size(xData,1) < size(xData,2)
%             xData = xData';
%             yData = yData';
%         end
% end

% pos=get(obj.Slider,'Value');
% [~,posInd]=min(abs(obj.AxisData-pos));
% index=arraySliceIndex(3,posInd,d);
% sliceData=squeeze(obj.Data.value(index{:}));
% sizeOfxData=length(xData);
% sizeOfyData=length(yData);

% get image and axis
sliceData = obj.imag.CData;
xData = obj.imag.XData;
yData = obj.imag.YData;

% get points
[m,n]=getpts;

% fit ferimi surface curve

% A=polyfit(m,n,2);
% FS_CURVE=polyval(A,xData);

% FS_CURVE = interp1(m,n,xData,'spline');
FS_CURVE = interp1(m,n,xData,'makima');
FS_CURVE = reshape(FS_CURVE,[1,length(FS_CURVE)]);
FS_mean = mean(FS_CURVE,'all');

% plot points and curve
hold on;
correctionPointHandle = plot(m,n,'k+');
correctionLineHandle = plot(xData,FS_CURVE,'r--');
hold off;

% interpolate
Emax = max(yData,[],'all');
Emin = min(yData,[],'all');

P = polyfit(1:length(yData),yData,1);
dE = P(1);

Cmax = max(FS_CURVE-FS_mean,[],'all');
Cmin = min(FS_CURVE-FS_mean,[],'all');

EEF_new = (Emin-Cmax):dE:(Emax-Cmin);
[EEFF, XX] = meshgrid(EEF_new,xData);

FS_m = repmat(FS_CURVE-FS_mean,length(EEF_new),1);

VALUE_new = interp2(xData,yData,sliceData,XX,EEFF+FS_m','spline',0);



newData = evalin('base',obj.DataName);
if ndims(newData.value) == 2
    newData.y = EEF_new;
    newData.value = VALUE_new;
else
    newData.z = EEF_new;
    VALUE_new3 = zeros(length(newData.x),length(newData.y),length(EEF_new));
    switch obj.Direction
        case 'x'
            for i = 1:length(newData.x)
                VALUE_new3(i,:,:) = interp2(xData,yData,squeeze(newData.value(i,:,:))',XX,EEFF+FS_m','spline',0);
            end
        case 'y'
            for i = 1:length(newData.y)
                VALUE_new3(:,i,:) = interp2(xData,yData,squeeze(newData.value(:,i,:))',XX,EEFF+FS_m','spline',0);
            end
    
        otherwise
            return
    end
    VALUE_new3(VALUE_new3<0) = 0;
    newData.value = VALUE_new3;
end

DataName=inputdlg({'Data Name'},'Save correction',1,{[obj.DataName,'_corr']});
if isempty(DataName)
    return;
end
assignin('base',DataName{1},newData);

delete(correctionLineHandle);
delete(correctionPointHandle);

end
