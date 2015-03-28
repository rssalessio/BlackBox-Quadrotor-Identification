clear all, clc, close all;

[in,out,modelSS] = loaddata();

opt = identifyOptions;
opt.target = 'simulation';
opt.inputDelayAuto = false;
opt.cost ='fit';
opt.modelType = 'oe';
opt.maxOrders = [ 3 3 3 3 3 ];
%opt.maxOrders = [ 5 7 5 5 2 ];
opt.validate = 1;
opt.validationData = iddata(out.prbs2,in.prbs2);
opt.addNoise = 0;

disp('OE model');
modelOE = identify(in.u2,out.y2,opt);

opt.modelType ='armax';
disp('armax model');
modelARX = identify(in.u2,out.y2,opt);

modelOE, modelARX

disp('OE vs ARMAX');
%%
close all
compare(in.u1,out.y1,modelARX,modelOE,0);
    % 
% disp('SS vs ARMAX');
% compare(in.u1,out.y1,modelARX,modelSS);
% 
% disp('OE vs SS');
% compare(in.u1,out.y1,modelOE,modelSS);
