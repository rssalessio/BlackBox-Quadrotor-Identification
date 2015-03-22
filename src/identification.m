function [finalModel] = identification(u, y, modelType, maxOrders, idOpt)
% identification(u,y,modelType,idOpt) identifies a polynomial model based on data
% (u,y)
%INPUT:
%   u: measured input data
%   y: measured output data
%   modelType : type of model to be identified, choices =
%   'arx','armax','oe','bj'
%   maxOrders : max orders
%   idOpt: identification option, can be either 'simulation' or
%   'prediction'
%OUTPUT:
%   finalModel: model identified

    data = iddata(y,u);
    nk = delayest(data); %estimate time delay (dead time) - also a step response could be used(it's the difference between the first u!= 0 and y!=0)
    
    switch(nargin)
        case 3
            maxOrders = [20 20 20 20];
            idOpt = 'simulation';
        case 4
            idOpt = 'simulation';
    end
    
    numOrders = 4;
 
    if strcmp(modelType,'arx')
        maxOrders(3:4) = [1 1];
        idFunc = @arx;
        opt = arxOptions;
        numOrders = 2;
    elseif strcmp(modelType, 'oe')
        maxOrders(3:4) = [1 1];
        idFunc = @oe;
        opt = oeOptions;
        numOrders = 2;
    elseif strcmp(modelType, 'armax')
        maxOrders(4) = 1;
        idFunc = @armax;
        opt = armaxOptions;
        numOrders = 3;
    else
        idFunc = @bj;
        opt = bjOptions;
        numOrders = 4;
    end
    opt.Focus = idOpt;
    
    orders = [ 1 1 1 1 ];
    J = -1;
    
    for na=1:maxOrders(1)
        for nb=1:maxOrders(2)
            for nc=1:maxOrders(3)
                for nd=1:maxOrders(4)
                    orders =[na nb nc nd];
                    idModel = idFunc(data, [orders(1:numOrders) nk], opt);
                    if (idModel.Report.Fit.FitPercent > J)
                        J = idModel.Report.Fit.FitPercent;
                        disp(['New model with orders ' num2str([orders(1:numOrders) nk]) ' - J: ' num2str(J)]);
                        finalModel = idModel;
                    end
                end
            end
        end
    end
end