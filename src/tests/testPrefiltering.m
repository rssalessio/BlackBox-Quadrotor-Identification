clear all, close all, clc

%guarda come viene l'arx in compare. Viene piatto a tratti se zoommi


[data,lovera,ts] = loaddata();
arcs = load('../data/models/pred/ARXmodels.mat', 'models');
oe = load('../data/models/sim/OEmodels.mat', 'models');

data = data{1,1};
arcs = arcs.models{1};
oe = oe.models{1};

L = idpoly(1,arcs.a,1,1,1,0,0.2);

uL = lsim(L,data.u);
yL = lsim(L,data.y);
dataL = iddata(yL,uL,ts);

IdOptions = identifyOptions();
    IdOptions.output = 0;
    IdOptions.modelType = 'arx';
    IdOptions.target = 'prediction';
    IdOptions.minOrders = [ 1 1 1 1 2];
    IdOptions.maxOrders = [ 5 5 5 5 3];
arcsL = identify(dataL, IdOptions);
%%
compareModels(data,arcsL,arcs,0);
disp(['ESR ARX: ' num2str(esr(arcsL,data))]);
disp(['ESR OE: ' num2str(esr(oe,data))]);