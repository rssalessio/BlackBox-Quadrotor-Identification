clear all, close all , clc;

[data,a,b]=loaddata();
data{1,1}=detrend(data{1,1});
y = data{1,1}.y;

x = 1:1:length(y);
xx = 1:0.1:length(y);
yy = spline(x,y,xx);
plot(xx,yy);hold on; plot(y);

close all;
y=yy;
u = data{1,1}.u;

x = 1:1:length(u);
xx = 1:0.1:length(u);
uu = spline(x,u,xx);
plot(xx,uu);hold on; plot(u);
u=uu;

opt = arxOptions;
opt.focus='simulation';
model1 = arx(data{1,1}, [3 3 3],opt);

model2 = arx(iddata(y',u',0.2), [5 5 3],opt);


ysim1= sim(model1, data{1,1}.u);
ysim2= sim(model2, u');
t = 1:1:length(data{1,1}.u);

figure;
subplot 211;
plot(t,data{1,1}.y, t,ysim1); legend('y','ysim1');
subplot 212;
plot(t,data{1,1}.y); hold on; 
plot(1:0.1:2668,ysim2); legend('y','ysim2');



ysim1 = lsim(a, data{1,1}.u);
ysim2 = lsim(a, u');


figure;
subplot 211;
plot(t,data{1,1}.y, t,ysim1); legend('y','ysim1');
subplot 212;
plot(t,data{1,1}.y); hold on; 
plot(1:0.1:2668,ysim2); legend('y','ysim2');