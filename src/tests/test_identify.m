clear all, clc, close all;

[in,out,modelSS] = loaddata();

opt = identifyOptions;
opt.target = 'simulation';
opt.inputDelayAuto = false;
opt.cost ='fit';
opt.modelType = 'oe';
opt.maxOrders = [ 5 5 5 5 3 ];
opt.validate = 0;
opt.validationData = iddata(out.exp2.y2,in.exp2.u2);
opt.addNoise = 0;

disp('OE model');
modelOE = identify(in.exp1.u1,out.exp1.y1,opt);

opt.modelType ='armax';
disp('armax model');
modelARX = identify(in.exp1.u1,out.exp1.y1,opt);

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
