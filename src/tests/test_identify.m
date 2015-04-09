clear all, clc, close all;

[data,modelSS] = loaddata();

opt = identifyOptions;
opt.target = 'prediction';
opt.inputDelayAuto = false;
opt.cost ='variance';
opt.modelType = 'oe';
opt.maxOrders = [ 5 5 5 5 3 ];
opt.validate = 1;
opt.validationData = data{1,2};
opt.addNoise = 0;

disp('OE model');
modelOE = identify(data{1,1},opt);

opt.modelType ='arx';
disp('armax model');
modelARX = identify(data{1,1},opt);

modelOE, modelARX

disp('OE vs ARMAX');
%%
close all
compare(data{1,2},modelARX,modelOE,0);
    % 
% disp('SS vs ARMAX');
% compare(in.u1,out.y1,modelARX,modelSS);
% 
% disp('OE vs SS');
% compare(in.u1,out.y1,modelOE,modelSS);
