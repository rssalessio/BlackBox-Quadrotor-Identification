function [finalModel,save] = identify(data, opt)
% identification(data,opt) identifies a polynomial model based on data
% (u,y)
%INPUT:
%   data: measured data (iddata object)
%   opt: object of type identifyOptions, used to set options.
%OUTPUT:
%   finalModel: model identified
%   savedData: structure with the identification results

    data = detrend(data);
    
    save.data = data;
    save.opt  = opt;
    
   
    switch(nargin)
        case 1
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
        opt.validate = 0;
    elseif strcmp(opt.cost, 'aic')
        J = inf;
        opt.validate = 0;
    elseif strcmp(opt.cost, 'fit') || strcmp(opt.cost, 'mfit') || strcmp(opt.cost, 'ifit') || strcmp(opt.cost, 'sfit')
        J = Inf;
        if (strcmp(opt.cost,'fit')==0 && opt.validate==0)
            error('mfit and ifit available only with validate');
        end
    else
        error('Invalid cost objective, check identifyOptions');
    end
    
    simopt = simOptions('AddNoise',opt.addNoise);
    finalModel = 0;
        
    totalComp = prod((opt.maxOrders-opt.minOrders +ones(size(opt.maxOrders))));
    timeSteps = zeros(totalComp,1);
    progress = 0;
    reverseStr = '';
    
    
    for na=opt.minOrders(1):opt.maxOrders(1)
        for nb=opt.minOrders(2):opt.maxOrders(2)
            for nc=opt.minOrders(3):opt.maxOrders(3)
                for nd=opt.minOrders(4):opt.maxOrders(4)
                    for nk = minNk:maxNk
                        orders =[na nb nc nd];
                        t1=clock();
                        try
                            idModel = idFunc(data, [orders(1:numOrders) nk], idFuncOpt);
                        catch
                            progress = progress+1;
                            t2=clock();
                            timeSteps(progress) = t2(6)-t1(6);
                            timeSteps(timeSteps < 0) = 0;
                            continue;
                        end
                        if(opt.validate)
                            Jtemp = validate(idModel, opt.validationData, opt.cost,simopt);
                        else
                            if (strcmp(opt.cost, 'variance'))
                                ysim = sim(idModel, data.InputData ,simopt);
                                eps = data.OutputData - ysim;
                                Jtemp = var(eps);
                                [~,ratio,~] = inspectSignal.isWhite(eps,0.1,0.1,'nooutput');
                            elseif(strcmp(opt.cost, 'max'))
                                ysim = sim(idModel, data.InputData,simopt);
                                eps = data.OutputData - ysim;
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
                            finalModel = idModel;
                            J = Jtemp;
                            if (J <= opt.minCost)
                                return;
                            end
                        end
                        progress = progress+1;
                        t2=clock();
                        timeSteps(progress) = t2(6)-t1(6);
                        timeSteps(timeSteps < 0) = 0;
                        tavg=mean(timeSteps(1:progress));
                        if(opt.output)
                            msg = sprintf('Progress done: %3.1f (Time Left: %f s) - Best Cost Function value: %f', 100*progress/totalComp,tavg*(totalComp-progress), J); %Don't forget this semicolon
                            fprintf([reverseStr, msg]);
                            reverseStr = repmat(sprintf('\b'), 1, length(msg));
                        end
                    end
                end
            end
        end
    end
    save.model = finalModel;
    fprintf('\n');
end