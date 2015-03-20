function [data,model]=loaddata()
    data=load('dati_qr.mat');
    data.st = 20*10^(-3); %sampling time
    model=load('modello.mat');
end