function [data,model]=loaddata()
    data=load('../data/dati_qr.mat');
    data.separated = load('../data/input.mat');
    data.st = 20*10^(-3); %sampling time
    model=load('../data/modello.mat');
end
