function [J] = validate(idModel, data, costfunc,opt)
    ysim = sim(idModel, data.InputData,opt);
    eps = data.OutputData - ysim;
    if (strcmp(costfunc, 'variance'))%used to minimise variance
        J = var(eps); %
        [~,ratio,~] = isWhite(eps,0.1,0.1,'nooutput');
    elseif strcmp(costfunc, 'max') %minimise max absolute error
        J = max(abs(eps));
    elseif strcmp(costfunc, 'fit') % fit = (1- |y-ysim|/|y-mean(y)|)*100
        temp1= norm(data.OutputData-ysim);
        temp2= norm(data.OutputData-ones(size(data.OutputData))*mean(data.OutputData));
        J =temp1/temp2 *100;
    else
        error('Bad cost function');
    end
end