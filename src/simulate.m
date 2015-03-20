function []=simulate(model, y, u)
    ysim = sim(model, u);
    t = 1:1:size(y);
    
    figure;
    subplot(2,1,1);
    plot(t,y,t,ysim); grid; legend('Data', 'Simulation'); xlabel('Time'); ylabel('Output');
    subplot(2,1,2);
    plot(t,u); grid; legend('Input'); xlabel('Time'); ylabel('Output');
    
    yerr = abs(y-ysim);
    figure;
    subplot(2,1,1);
    plot(t,yerr); grid; legend('Absolute Error abs(data-simulation)'); xlabel('Time'); ylabel('Absolute error');
    subplot(2,1,2);
    plot(t,u); grid; legend('Input'); xlabel('Time'); ylabel('Input');
    
    yerr_mean = mean(yerr);
    yerr_var = var(yerr);
    disp(['Mean absolute error: ' num2str(yerr_mean) ' - Variance absolute error: ' num2str(yerr_var)]);
    
    yerr= yerr-yerr_mean;
    coverr = covf(yerr,200);
    figure;
    plot(coverr); grid; 
end