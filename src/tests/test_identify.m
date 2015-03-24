clear all, clc, close all;

[in,out,mod] = loaddata();

opt = identifyOptions;
opt.target = 'simulation';
opt.inputDelayAuto = false;
opt.cost ='fit';
opt.modelType = 'oe';
opt.minOrders  = [ 4 4 4 4 3 ];
opt.maxOrders = [ 5 5 5 5 3 ];
opt.validate = 1;
opt.validationData = iddata(out.prbs2,in.prbs2);

disp('OE model');
modelOE = identify(in.u1,out.y1,opt);

opt.modelType ='iv4';
disp('iv4 model');
modelARX = identify(in.prbs1,out.prbs1,opt);


modelOE, modelARX
compare(in.u1,out.y1,modelARX,modelOE);

