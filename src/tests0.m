%some tests on data
%
%
clear, clc, close all
[data,model]= loaddata();
stateSpaceModel=ss(model.A,model.B,model.C,model.D,0.2);

u = data.u1;
y = data.y1;

data=iddata(y,u);
%%
plotCov(y,30);

%From the covf plot we notice that there is no sudden drop to 0-> AR influence
%From the parcor plot there is no sudden drop to 0 -> MA influence, though
%for N>20 (about) it's nearly 0 (AR 20?)

%%
%nk = delayest(iddata(y,u),20,20);
%[f,a]=armaTest(y,10,10);
%[f,a]=armaxTest(u,y,20,20,20,nk);
%From an initial test it results NA = 20, NC = 13
% Event with na=1:30, nc=1:15 the best one is NA=20,NC=13
modelPred = armax(data, [19 13 20 1]);
opt = armaxOptions;
opt.Focus = 'simulation';
opt.SearchOption.MaxIter = 20;
opt.Display = 'on';
modelSim = armax(data, [19 13 20 1], opt);

%compare(data,modelPred,modelSim);
simulate(stateSpaceModel,modelSim,y,u);
%for armax 19 13 20, nk=1