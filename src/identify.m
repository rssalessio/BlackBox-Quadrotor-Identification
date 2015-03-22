function [finalModel] = identify(u, y, modelType, maxOrders, idOpt, outputOption)
% identification(u,y,modelType,idOpt) identifies a polynomial model based on data
% (u,y)
%INPUT:
%   u: measured input data
%   y: measured output data
%   modelType : type of model to be identified, choices =
%   'arx','armax','oe','bj'
%   maxOrders : na, nb, nc, nd
%   idOpt: identification option, can be either 'simulation' or
%   'prediction'
%OUTPUT:
%   finalModel: model identified

    data = iddata(y,u);
    
    switch(nargin)
        case 3
            maxOrders = [20 20 20 20];
            idOpt = 'simulation';
            outputOption = 'nooutput';
        case 4
            idOpt = 'simulation';
            outputOption = 'nooutput';
        case 5
            outputOption = 'nooutput';
    end
    
    numOrders = 4;
    
    if strcmp(outputOption, 'nooutput')
        outputOption = 0;
    else
        outputOption = 1;
    end
 
    if strcmp(modelType,'arx')
        if length(maxOrders) ~= 3
            error('arx model needs 3 orders specifications: na, nb, delay');
            return;
        end
        maxOrders = [maxOrders(1:2) 1 maxOrders(3)];
        idFunc = @arx;
        opt = arxOptions;
        numOrders = 2;
        
    elseif strcmp(modelType, 'oe')
        if length(maxOrders) ~= 3
            error('oe model needs 3 orders specifications: na, nb, delay');
            return;  
        end
        maxOrders = [maxOrders(1:2) 1 maxOrders(3)];
        idFunc = @oe;
        opt = oeOptions;
        numOrders = 2;
        
    elseif strcmp(modelType, 'armax')
        if length(maxOrders) ~= 4
            error('armax model needs 4 orders specifications: na, nb, nc, delay');
            return;           
        end
        
        idFunc = @armax;
        opt = armaxOptions;
        numOrders = 3;
    elseif strcmp(modelType, 'bj')
        if length(maxOrders) ~= 5
            error('bj model needs 5 orders specifications: nb, nc, nd, nf, delay');
            return;           
        end
        idFunc = @bj;
        opt = bjOptions;
        numOrders = 4;
    else
        error([modelType ' not known']);
        return;
    end
    
    opt.Focus = idOpt;
    
    orders = [1 1 1 1];
    J = inf; %variance of PE (eps)
    finalModel = 0;
    
    for na=1:maxOrders(1)
        for nb=1:maxOrders(2)
            for nc=1:maxOrders(3)
                for nd=1:maxOrders(4)
                    orders =[na nb nc nd];
                    idModel = idFunc(data, [orders(1:numOrders) nd], opt);

                    ysim = sim(idModel, u);
                    eps = y - ysim;
                    Jtemp = var(eps);
                    
                    [~,ratio,~] = isWhite(eps,0.1,0.1,'nooutput');
                    
                    if (Jtemp < J)
                        if outputOption
                            disp(['New model with orders ' num2str(orders) ' - J: ' num2str(Jtemp) ' isWhite ratio: ' num2str(ratio)]);
                        end
                        
                        finalModel = idModel;
                        J = Jtemp;
                    end
                end
        end
    end
end