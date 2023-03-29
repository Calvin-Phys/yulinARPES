function subplot_output_test
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

h_figure=get(100,'Children');
n=length(h_figure);
h1=get(h_figure(1),'Children');
set(h_figure(1),'Color','none');
export_fig(h_figure(1),'100.png','-transparent','-r200'); 
%Resolution Setting: 
%'-r200' = 200dpi

% imgf=getframe(h1);
% img=frame2im(imgf);
% imwrite(img,'1.tiff');

% clc;close all;clear all;
% Img=imread('1.jpg');
% if ndims(Img)==3
%     I=rgb2gray(Img);
% else
%     I=Img;
% end
% I=im2bw(I,graythresh(I));
% [m,n]=size(I);
% imshow(I);title('binary image');
% txt=get(gca,'Title');
% set(txt,'fontsize',16);
% L=bwlabel(I);
% stats=regionprops(L,'all');
% set(gcf,'color','w');
% set(gca,'units','pixels','Visible','off');
% q=get(gca,'position');
% q(1)=0;%设置左边距离值为零
% q(2)=0;%设置右边距离值为零
% set(gca,'position',q);
% for i=1:length(stats)
%     hold on;
%     rectangle('position',stats(i).BoundingBox,'edgecolor','y','linewidth',2);
%     temp = stats(i).Centroid;
%     plot(temp(1),temp(2),'r.');
%     drawnow;
% end
% frame=getframe(gcf,[0,0,n,m]);%
% im=frame2im(frame);
% imwrite(im,'a.jpg','jpg');%可以修改保存的格式
