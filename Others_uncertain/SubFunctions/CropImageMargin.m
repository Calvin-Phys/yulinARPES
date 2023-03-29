function [ output_args ] = CropImageMargin( filename )
%CropImageMargin Summary of this function goes here
%   Detailed explanation goes here
data=imread(filename);

meanxy=mean(data,3);
meanx=mean(meanxy,2);
meany=mean(meanxy,1);

x1=find(meanx<255,1,'first');
x2=find(meanx<255,1,'last');
y1=find(meany<255,1,'first');
y2=find(meany<255,1,'last');

imwrite(data(x1:x2,y1:y2,:),['crop_' filename]);

end

