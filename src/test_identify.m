clear all, clc, close all;

[in,out,mod] = loaddata();

disp('ID model by Fit');
modelFit = identification(in.prbs1,out.prbs1,'oe',[5 5], 'simulation');

disp('ID model by PE');
modelPE = identify(in.prbs1,out.prbs1,'oe',[5 5 5], 'simulation');

modelFit, modelPE