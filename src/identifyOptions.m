classdef identifyOptions
% identifyOptios: class with various options used by the identify function


    properties
        maxOrders = [5 5 5 5 2]; % na nb nc nd, nk fixed input delay
        inputDelayAuto = true; % choose true to let identify() choose the best fixed input delay, otherwise false and calculate it based on lastcomponent of maxorders
        modelType = 'arx'; %arx, armax, oe, bj
        target = 'simulation';       %identification target: either simulation  or prediction
        output = true;       %true to print output, otherwise false

        cost = 'variance';     %select best model based either on : variance error (variance), aic (aic), fpe (fpe) or fit percentage (fit)
    end
end