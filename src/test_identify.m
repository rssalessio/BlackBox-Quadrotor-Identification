clear all, clc, close all;

[in,out,mod] = loaddata();

opt = identifyOptions;

opt.modelType = 'oe';

disp('OE model');
modelOE = identify(in.prbs1,out.prbs1,opt);

opt.modelType ='arx';
disp('ARX model');
modelARX = identify(in.prbs1,out.prbs1,opt);


modelOE, modelARX