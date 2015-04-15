clear all, close all

%guarda come viene l'arx in compare. Viene piatto a tratti se zoommi


[data,lovera,ts] = loaddata();
arcs = load('../data/models/ARXmodels.mat', 'models');
oe = load('../data/models/OEmodels.mat', 'models');

data = data{1,1};
arcs = arcs.models{1};
oe = oe.models{1};

L = idpoly(1,arcs.a,1,1,1);

uL = lsim(L,data.u);
yL = lsim(L,data.y);
dataL = iddata(yL,uL,ts);

compareModels(dataL,arcs,oe,0);

disp(['ESR ARX: ' num2str(esr(arcs,dataL))]);
disp(['ESR OE: ' num2str(esr(oe,dataL))]);