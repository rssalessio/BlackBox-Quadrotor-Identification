function [finalModel] = identify(u, y, opt)
% identification(u,y,opt) identifies a polynomial model based on data
% (u,y)
%INPUT:
%   u: measured input data
%   y: measured output data
%   opt: object of type identifyOptions, used to set options.
%OUTPUT:
%   finalModel: model identified

    data = iddata(detrend(y),detrend(u));
    
   
    switch(nargin)
        case 2
            opt = identifyOptions;
    end
    
    if (isa(opt, 'identifyOptions')==0)
        error('Opt has to be an object of type identifyOptions');
    end
    
    if(sum(opt.minOrders > opt.maxOrders) > 0)
        error('minOrders in identifyOptions should contains all values <= to those of maxOrders');
    end
 
    if (strcmp(opt.modelType,'arx') || strcmp(opt.modelType, 'iv4'))
        opt.maxOrders(3:4) = [ 1 1 ];
        opt.minOrders(3:4) = [ 1 1 ];
        if(strcmp(opt.modelType,'arx'))
            idFunc = @arx;
            idFuncOpt = arxOptions;
        else
            idFunc = @iv4;
            idFuncOpt = iv4Options;
        end
        numOrders = 2;
    elseif strcmp(opt.modelType, 'oe')
        opt.maxOrders(3:4) = [ 1 1 ];
        opt.minOrders(3:4) = [ 1 1 ];
        idFunc = @oe;
        idFuncOpt = oeOptions;
        numOrders = 2;
        
    elseif strcmp(opt.modelType, 'armax')
        opt.maxOrders(4) = 1;
        opt.minOrders(4) = 1;
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
        minNk = opt.minOrders(5);
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
        
    totalComp = prod((opt.maxOrders-opt.minOrders +ones(size(opt.maxOrders))));
    progress = 0;
    reverseStr = '';
    for na=opt.minOrders(1):opt.maxOrders(1)
        for nb=opt.minOrders(2):opt.maxOrders(2)
            for nc=opt.minOrders(3):opt.maxOrders(3)
                for nd=opt.minOrders(4):opt.maxOrders(4)
                    for nk = minNk:maxNk
                        orders =[na nb nc nd];
                        try
                            idModel = idFunc(data, [orders(1:numOrders) nk], idFuncOpt);
                        catch
                            continue;
                        end
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
                            %if opt.output
                              %  disp(['New model with orders ' num2str([orders(1:numOrders) nk]) ' - J: ' num2str(Jtemp) ]);
                                %' isWhite ratio: ' num2str(ratio)
                            %end
                            

                            finalModel = idModel;
                            J = Jtemp;
                            if (J <= opt.minCost)
                                return;
                            end
                        end
                        progress = progress+1;
                        if(opt.output)
                            msg = sprintf('Progress done: %3.1f - Best Cost Function value: %f', 100*progress/totalComp, J); %Don't forget this semicolon
                            fprintf([reverseStr, msg]);
                            reverseStr = repmat(sprintf('\b'), 1, length(msg));
                        end
                    end
                end
            end
        end
    end
    fprintf('\n');
end