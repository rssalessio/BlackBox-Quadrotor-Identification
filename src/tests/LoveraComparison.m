close all, clear all

[data,lovera,Ts] = loaddata();
oe = load('../data/models/OEmodels.mat', 'models'); oe = oe.models;

%compareModels(data{1,1},oe{1},lovera,0);


for i=1:3
    disp(['Lovera: ' num2str( esr(lovera,data{1,i}) ), ...
            '   OE1: ' num2str( esr(oe{1},data{1,i}) ), ...
            '   OE2: ' num2str( esr(oe{2},data{1,i}) ), ...
            '   OE3: ' num2str( esr(oe{3},data{1,i}) )]);
end