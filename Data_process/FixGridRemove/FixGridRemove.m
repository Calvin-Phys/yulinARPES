function [data_nu,data_fft,data_fft_full_inan_remove] = FixGridRemove(data)
% data: input 2D cut
% data_nu: output grid-removed data
% data_fft: output fft of the orginal data
% data_fft_full_inan_remove: output fft of grid-removed data

p1 = 0.8; % intensity threshold parameter: higher value will result in less fft grid pattern found. 0.8<p1<1
p2 = 0.9; % intensity threshold parameter: higher value will result in less area to be set nan. 0.8<p1<1
p3 = 0.3; % region of interest parameter, 0.3<p3<0.7


data_nu = data;
data_fft = data;
data_fft_full = data;

%---calculate log fft---%
data.value(isnan(data.value)) = 0;
value = data.value;
value_fft = fftshift(fft2(value));
value_fft_abs = abs(value_fft);
data_fft.value = log(value_fft_abs);
data_fft_full.value = value_fft;

%---show log fft---%
figure(100);
hold on

pcolor(data_fft.x,data_fft.y,data_fft.value');
shading interp;
disp('first zoom in, then press enter to continue')
while true
    w = waitforbuttonpress;
    switch w
        case 1
            key = get(gcf,'currentcharacter');
            switch key
                case 13
                    break
            end
    end
end

%---manually select first order peak---%
disp('select two first order point');
[xi,yi] = getpts;


%---calculate initial base vector----%
xa = xi(1)-0.5*(data.x(1)+data.x(end));
xb = xi(2)-0.5*(data.x(1)+data.x(end));
ya = yi(1)-0.5*(data.y(1)+data.y(end));
yb = yi(2)-0.5*(data.y(1)+data.y(end));

%----search grid patter peaks----%
% index each pixel
[X,Y] = ndgrid(data.x,data.y);
X = X-0.5*(data.x(1)+data.x(end));
Y = Y-0.5*(data.y(1)+data.y(end));
A = yb/(xa*yb-xb*ya)*X-xb/(xa*yb-ya*xb)*Y;
B = xa/(xa*yb-xb*ya)*Y-ya/(xa*yb-ya*xb)*X;
% search
xp = [];
yp = [];
a = [];
b = [];


data_fft_1 = data_fft;
[Nx,Ny] = size(data_fft_1.value);
data_fft_1.value(round(0.49*Nx):round(0.51*Nx),:)=-1e50;
data_fft_1.value(:,round(0.49*Ny):round(0.51*Ny))=-1e50;
value_sort = sort(data_fft_1.value(:));
N = numel(value_sort);
intensity_threshold = value_sort(round(p1*N));
for ii = -10:10
    for jj = -10:10
        if ii==0&&jj==0
            continue
        else
            filtA = (A>(ii-0.1)).*(A<(ii+0.1));
            filtB = (B>(jj-0.1)).*(B<(jj+0.1));
            filt = filtA.*filtB;
            if sum(filt(:))>0
                temp = data_fft_1.value.*filt;
                temp(temp==0)=nan;
                [M,I] = max(temp(:));
                if M>intensity_threshold
                    [Ix,Iy] = ind2sub(size(temp),I);
                    xp = [xp;data.x(Ix)];
                    yp = [yp;data.y(Iy)];
                    a = [a;ii];
                    b = [b;jj];
                    figure(100);
                    hold on
                    scatter(data.x(Ix),data.y(Iy),'r');
                end
            end
        end
    end
end

%---recalculate base vector---%
xp = xp-0.5*(data.x(1)+data.x(end));
yp = yp-0.5*(data.y(1)+data.y(end));
T = [a,b];
vx = T\xp;
vy = T\yp;
xa = vx(1);xb = vx(2);
ya = vy(1);yb = vy(2);
figure(100)
hold on
line([0.5*(data.x(1)+data.x(end)),0.5*(data.x(1)+data.x(end))+xa],[0.5*(data.y(1)+data.y(end)),0.5*(data.y(1)+data.y(end))+ya],'Color','red');
line([0.5*(data.x(1)+data.x(end)),0.5*(data.x(1)+data.x(end))+xb],[0.5*(data.y(1)+data.y(end)),0.5*(data.y(1)+data.y(end))+yb],'Color','red');
axis tight
disp('press enter to continue');
waitforbuttonpress;


ap = yb/(xa*yb-xb*ya)*xp-xb/(xa*yb-ya*xb)*yp;
bp = xa/(xa*yb-xb*ya)*yp-ya/(xa*yb-ya*xb)*xp;

%---select area and set nan---%
data_fft_remove = data_fft;
V = data_fft_1.value;



for ii = 1:numel(ap)
    filtA = (A>(ap(ii)-p3)).*(A<(ap(ii)+p3));
    filtB = (B>(bp(ii)-p3)).*(B<(bp(ii)+p3));
    filt2 = filtA.*filtB;
    N_local = sum(filt2(:));
    Vtemp = V;
    Vtemp(filt2==0) = nan;
    Vtemp_sort = sort(Vtemp(:));
    thres_local = Vtemp_sort(round(p2*N_local));
    data_fft_remove.value(Vtemp>thres_local) = nan;
    data_fft_full.value(Vtemp>thres_local) = nan;
end       
figure(200);
hold on
pcolor(data_fft_remove.x,data_fft_remove.y,data_fft_remove.value');
shading interp

%---interp nan data_fft_full---%
data_fft_full_inan = InterpNaNs(data_fft_full);
data_fft_full_inan_remove = data_fft_full_inan;
data_fft_full_inan_remove.value = log(abs(data_fft_full_inan.value));
figure(300);
hold on
pcolor(data_fft_full_inan_remove.x,data_fft_full_inan_remove.y,data_fft_full_inan_remove.value');
shading interp;

%---reverse fft---%
data_nu.value = abs(ifft2(fftshift(data_fft_full_inan.value)));
            
        
        