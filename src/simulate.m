function []=simulate(stateSpaceModel, model, y, u)
    ysim = sim(model, u);
    yssm = lsim(stateSpaceModel,u);
    t = 1:1:size(y);
    
    figure;
    subplot(4,1,1);
    plot(t,y,t,ysim); grid; legend('Data', 'Simulation'); xlabel('Time'); ylabel('Output');title('Simulation output');
    subplot(4,1,2);
    plot(t,y,t,yssm); grid; legend('Data','State Space Model'); xlabel('Time'); ylabel('Output');
    subplot(4,1,3);
    plot(t,y,t,ysim,t,yssm); grid; legend('Data', 'Simulation','State Space Model'); xlabel('Time'); ylabel('Output');
    subplot(4,1,4);
    plot(t,u); grid; legend('Input'); xlabel('Time'); ylabel('Output');
    
    
    yerr = [abs(y-ysim)'; abs(y-yssm)'; abs(ysim-yssm)'];
    yerr_mean = [mean(yerr(1,:)); mean(yerr(2,:));mean(yerr(3,:))];
    yerr_var = [var(yerr(1,:)); var(yerr(2,:));var(yerr(3,:))];
    yerr_nomean = yerr-yerr_mean*ones(1,size(yerr,2));
    
    
    figure;

    subplot(4,1,1);
    plot(t,yerr(1,:)); grid; legend('Absolute Error abs(data-simulation)'); xlabel('Time'); ylabel('Absolute error');title('Absolute error simulation');
    subplot(4,1,2);
    plot(t,yerr(2,:)); grid; legend('Absolute Error abs(data-ssm)'); xlabel('Time'); ylabel('Absolute error');
    subplot(4,1,3);
    plot(t,yerr(1,:),t,yerr(2,:));grid;legend('Absolute Error abs(data-simulation)', 'Absolute Error abs(data-ssm)'); xlabel('Time'); ylabel('Absolute Error');
    subplot(4,1,4);
    plot(t,yerr(3,:)); grid; legend('Absolute Error abs(sim-ssm)'); xlabel('Time'); ylabel('Absolute error');
    
    
    disp(['[SIMULATION]  Mean absolute error: ' num2str(yerr_mean(1)) ' - Variance absolute error: ' num2str(yerr_var(1))]);
    disp(['[SSM]         Mean absolute error: ' num2str(yerr_mean(2)) ' - Variance absolute error: ' num2str(yerr_var(2))]);
    disp(['[ERR SIM-SSM] Mean absolute error: ' num2str(yerr_mean(3)) ' - Variance absolute error: ' num2str(yerr_var(3))]);
    
    disp(['Area Simulation: ' num2str(trapz(yerr(1,:))) ' - Area SSM: ' num2str(trapz(yerr(2,:)))]);

    N=200;
    coverr1 = covf(yerr_nomean(1,:)',N);
    coverr2= covf(yerr_nomean(2,:)',N);
    coverr3=covf(yerr_nomean(3,:)',N);
    t=1:N;
    figure;   
    plot(t,coverr1,t,coverr2,t,coverr3); title('Covariance simulation');grid; xlabel('Step'); ylabel('Cov'); legend('Simulation Covariance', 'SSM Covariance','Diff covariance');
end