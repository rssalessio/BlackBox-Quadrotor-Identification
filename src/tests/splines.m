clear all, close all , clc;

[i,o,m]=loaddata();

u = i.u1;
y = o.y1;

x = 1:1:length(y);
xx = 1:.001:length(y);
yy = spline(x,y,xx);
plot(xx,yy)




df=1/0.2;;
N=length(yy);
vett_f=0:df:df*(N/2-1);
fftout=fft(yy);
mody(1)=abs(fftout(1))/N;
mody(2:N/2)=abs(fftout(2:N/2))*2/N;
fasy(1:N/2)=angle(fftout(1:N/2));
figure
subplot 211;bar(vett_f,mody);grid;axis([0 300 0 6]);
