function [data, ssmodel,Ts] = loaddata()
%loaddata(opt) returns all the data gathered during the experiment and the
%state-space model identified.
%Returns: (1) input data, (2) output data, (3) model, (4) Samplig time. All of them are
%stored in a struct (except (4))

        data = load('../data/data.mat'); 
        ssmodel = load('../data/ssmodel.mat');

        data =data.data.exp;
        ssmodel = ssmodel.ssmodel;
        Ts=0.2; %sampling time, 0.2sec
        ssmodel = ss(ssmodel.A,ssmodel.B,ssmodel.C,ssmodel.D,Ts);
end
    