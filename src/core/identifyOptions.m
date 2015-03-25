classdef identifyOptions
% identifyOptios: class with various options used by the identify function
    properties
        minOrders = [1 1 1 1 0];
        maxOrders = [5 5 5 5 2];    % na nb nc nd, nk fixed input delay
        inputDelayAuto = true;      % choose true to let identify() choose the best fixed input delay, otherwise false and calculate it based on lastcomponent of maxorders
        modelType = 'arx';          %arx, armax, oe, bj,iv4
        target = 'simulation';      %identification target: either simulation  or prediction
        output = true;              %true to print output, otherwise false
        validate = 0;             % 1 to validate with external data, 0 for no validation
        validationData;             %iddata type, used for validation (validationData = iddata(y,u)
        cost = 'variance';          %select best model based either on : variance error (variance), aic (aic), fpe (fpe) or fit percentage (fit), max to reduce max abs error
        minCost = 10^(-5);              %if this cost is achieved, stop the algorithm
        addNoise = false;
    end
end