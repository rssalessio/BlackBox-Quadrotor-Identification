function [input, output, ssmodel] = loaddata()
%loaddata(opt) returns all the data gathered during the experiment and the
%state-space model identified.
%Returns: (1) input data, (2) output data, (3) model. All of them are
%stored in a struct.

        input = load('../data/input.mat'); 
        output = load('../data/output.mat');
        ssmodel = load('../data/ssmodel.mat');
        
        input = input.input;
        output = output.output;
        ssmodel = ssmodel.ssmodel;
        ssmodel = ss(ssmodel.A,ssmodel.B,ssmodel.C,ssmodel.D);
end
