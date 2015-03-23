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
    
    if (isa(opt, 'identifyOptions')==0)
        error('Opt has to be an object of type identifyOptions');
    end
 
    if strcmp(opt.modelType,'arx')
        opt.maxOrders(3:4) = [ 1 1 ];
        idFunc = @arx;
        idFuncOpt = arxOptions;
        numOrders = 2;
        
    elseif strcmp(opt.modelType, 'oe')
        opt.maxOrders(3:4) = [ 1 1 ];
        idFunc = @oe;
        idFuncOpt = oeOptions;
        numOrders = 2;
        
    elseif strcmp(opt.modelType, 'armax')
        opt.maxOrders(4) = 1;
        idFunc = @armax;
        idFuncOpt = armaxOptions;
        numOrders = 3;
    elseif strcmp(opt.modelType, 'bj')
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
    
    if (opt.validate)
        if (isa(opt.validationData, 'iddata')==0)
            error('Invalid validation data');
        end
    end
    
    if (strcmp(opt.cost, 'variance'))
        J = inf; %variance of PE (eps)
    elseif (strcmp(opt.cost, 'max'))
        J = inf;
    elseif strcmp(opt.cost, 'fpe')
        J = inf;
    elseif strcmp(opt.cost, 'aic')
        J = inf;
    elseif strcmp(opt.cost, 'fit')
        J = 100;
    else
        error('Invalid cost objective, check identifyOptions');
    end
    
        finalModel = 0;

    for na=1:opt.maxOrders(1)
        for nb=1:opt.maxOrders(2)
            for nc=1:opt.maxOrders(3)
                for nd=1:opt.maxOrders(4)
                    for nk = minNk:maxNk
                        orders =[na nb nc nd];
                        idModel = idFunc(data, [orders(1:numOrders) nk], idFuncOpt);
                        
                        if(opt.validate)
                            Jtemp = validate(idModel, opt.validationData, opt.cost);
                        else
                            if (strcmp(opt.cost, 'variance'))
                                ysim = sim(idModel, u);
                                eps = y - ysim;
                                Jtemp = var(eps);
                                [~,ratio,~] = isWhite(eps,0.1,0.1,'nooutput');
                            elseif(strcmp(opt.cost, 'max'))
                                ysim = sim(idModel, u);
                                eps = y - ysim;
                                Jtemp = max(abs(eps));
                            elseif strcmp(opt.cost, 'fpe')
                                Jtemp = fpe(idModel);
                            elseif strcmp(opt.cost, 'aic')
                                Jtemp = aic(idModel);
                            elseif strcmp(opt.cost, 'fit')
                                Jtemp = 100-idModel.Report.Fit.FitPercent;
                            end
                        end

                        

                        if (Jtemp < J)
                            if opt.output
                                disp(['New model with orders ' num2str([orders(1:numOrders) nk]) ' - J: ' num2str(Jtemp) ]);
                                %' isWhite ratio: ' num2str(ratio)
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