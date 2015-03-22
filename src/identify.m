function [finalModel] = identify(u, y, opt)
% identification(u,y,opt) identifies a polynomial model based on data
% (u,y)
%INPUT:
%   u: measured input data
%   y: measured output data
%   opt: object of type identifyOptions, used to set options.
%OUTPUT:
%   finalModel: model identified

    data = iddata(y,u);
   
    switch(nargin)
        case 2
            opt = identifyOptions;
    end
 
    if strcmp(opt.modelType,'arx')
        if length(opt.maxOrders) ~= 2
            error('arx model needs 2 orders specifications: na, nb');
        end
        opt.maxOrders(3:4) = [ 1 1 ];
        idFunc = @arx;
        idFuncOpt = arxOptions;
        numOrders = 2;
        
    elseif strcmp(opt.modelType, 'oe')
        if length(opt.maxOrders) ~= 2
            error('oe model needs 2 orders specifications: na, nb');
        end
        opt.maxOrders(3:4) = [ 1 1 ];
        idFunc = @oe;
        idFuncOpt = oeOptions;
        numOrders = 2;
        
    elseif strcmp(opt.modelType, 'armax')
        if length(opt.maxOrders) ~= 3
            error('armax model needs 3 orders specifications: na, nb, nc');        
        end
        opt.maxOrders(4) = 1;
        idFunc = @armax;
        idFuncOpt = armaxOptions;
        numOrders = 3;
    elseif strcmp(opt.modelType, 'bj')
        if length(opt.maxOrders) ~= 4
            error('bj model needs 4 orders specifications: nb, nc, nd, nf');
        end
        idFunc = @bj;
        idFuncOpt = bjOptions;
        numOrders = 4;
    else
        error([opt.modelType ' not known']);
        return;
    end
    
    idFuncOpt.Focus = opt.target;
    
    if opt.inputDelayAuto
        opt.maxOrders(5) = delayest(data); %estimate time delay (dead time) - also a step response could be used(it's the difference between the first u!= 0 and y!=0)
        minNk = opt.maxOrders(5);
        maxNk = minNk;
    else
        minNk = 1;
        maxNk = opt.maxOrders(5);
    end
    
    J = inf; %variance of PE (eps)
    finalModel = 0;
    
    for na=1:maxOrders(1)
        for nb=1:maxOrders(2)
            for nc=1:maxOrders(3)
                for nd=1:maxOrders(4)
                    for nk = minNk:maxNk
                        orders =[na nb nc nd];
                        idModel = idFunc(data, [orders(1:numOrders) nk], opt);

                        ysim = sim(idModel, u);
                        eps = y - ysim;
                        Jtemp = var(eps);

                        [~,ratio,~] = isWhite(eps,0.1,0.1,'nooutput');

                        if (Jtemp < J)
                            if opt.output
                                disp(['New model with orders ' num2str(orders) ' - J: ' num2str(Jtemp) ' isWhite ratio: ' num2str(ratio)]);
                            end

                            finalModel = idModel;
                            J = Jtemp;
                        end
                    end
                end
            end
        end
    end
end