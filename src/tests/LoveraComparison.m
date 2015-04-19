close all, clear all

[data,lovera,Ts] = loaddata();
oe23 = load('../data/models/sim/OE23IDmodel.mat', 'oe23id'); oe23 = oe23.oe23id;
oe35 = load('../data/models/sim/OEmodels.mat','models'); oe35 = oe35.models{1};

compareModels(data{1,1},oe23,idpoly(lovera),0);
compareModels(data{1,1},oe35,idpoly(lovera),0);

disp(['Lovera: ' num2str( esr(lovera,data{1,1}) ), ...
      '   OE35: ' num2str( esr(oe35,data{1,1}) ), ...
      '   OE23: ' num2str( esr(oe23,data{1,1}) )]);
  
figure; step(lovera,oe23); legend('SS55', 'OE23');