function [ratio] = esr(model, data)
    %Computes the error-to-signal ratio. The error is referred to the
    %difference between experimental data and data obtained by the model. 
    %Input: Model is the identified model
    %       data is iddata referred to an experiment
    
    yhat = lsim(model, data.u);
    
    err = data.y - yhat;
    
    errVar = var(err);
    dataVar = var(data.y);
    
    ratio = errVar/dataVar;
end