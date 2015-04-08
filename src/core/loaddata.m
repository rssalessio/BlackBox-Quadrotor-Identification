function [data, ssmodel,Ts] = loaddata()
%loaddata(opt) returns all the data gathered during the experiment and the
%state-space model identified.
%Returns: (1)  cell of iddata objects (2) model, (3) Samplig time. 
%
%The data cell is structured in the following way
% data{j,k} - k refers to the k-eth experiment, j refers to a time portion
% of that experiment: j=1 first part of the exp, j=2 second part, j=3 last
% part


        data = load('../data/data.mat'); 
        ssmodel = load('../data/ssmodel.mat');

        data =data.data.exp;
        ssmodel = ssmodel.ssmodel;
        Ts=0.2; %sampling time, 0.2sec
        ssmodel = ss(ssmodel.A,ssmodel.B,ssmodel.C,ssmodel.D,Ts);
end
    