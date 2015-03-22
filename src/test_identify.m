clear all, clc, close all;

[in,out,mod] = loaddata();

disp('OE model');
modelOE = identify(in.prbs1,out.prbs1,'oe',[5 5 5], 'simulation', 'out');

disp('ARX model');
modelARX = identify(in.prbs1,out.prbs1,'arx',[5 5 5], 'simulation', 'out');


modelOE, modelARX