clear all, close all , clc;

[i,o,m]=loaddata();

u = i.prbs1;
y = o.prbs1;
% 
% C = tf([1 0], [1 -1],-1);
% Cinv = tf ([1 -1],[1 0], -1);
% t=1:length(y);
% r = lsim(Cinv,u)+y;
% figure;
% subplot(3,1,1); plot(t,r);
% subplot(3,1,2); plot(t,u);
% subplot(3,1,3); plot(t,r,t,y); legend('r','y');
opt = identifyOptions;
opt.inputDelayAuto = false;
opt.cost ='fit';
opt.modelType = 'oe';
opt.maxOrders = [ 10 10 10 10 3];
opt.validate = 0;
opt.validationData = iddata(o.y2,i.u2);
in=i;
out = o;
disp('OE model');
modelOE = identify(u,y,opt);

opt.modelType ='arx';
disp('ARX model');
modelARX = identify(u,y,opt);



modelOE, modelARX
compare(u,y,modelARX,modelOE);
% 
% x = 1:1:length(y);
% xx = 1:.001:length(y);
% yy = spline(x,y,xx);
% plot(xx,yy)
% 
% 
% 
% 
% df=1/0.2;;
% N=length(yy);
% vett_f=0:df:df*(N/2-1);
% fftout=fft(yy);
% mody(1)=abs(fftout(1))/N;
% mody(2:N/2)=abs(fftout(2:N/2))*2/N;
% fasy(1:N/2)=angle(fftout(1:N/2));
% figure
% subplot 211;bar(vett_f,mody);grid;axis([0 300 0 6]);
