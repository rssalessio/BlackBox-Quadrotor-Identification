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
    
    
    yerr1 = abs(y-ysim);
    yerr2 = abs(y-yssm);
    yerr3 = abs(ysim-yssm);
    
    
    figure;

    subplot(4,1,1);
    plot(t,yerr1); grid; legend('Absolute Error abs(data-simulation)'); xlabel('Time'); ylabel('Absolute error');title('Absolute error simulation');
    subplot(4,1,2);
    plot(t,yerr2); grid; legend('Absolute Error abs(data-ssm)'); xlabel('Time'); ylabel('Absolute error');
    subplot(4,1,3);
    plot(t,yerr1,t,yerr2);grid;legend('Absolute Error abs(data-simulation)', 'Absolute Error abs(data-ssm)'); xlabel('Time'); ylabel('Absolute Error');
    subplot(4,1,4);
    plot(t,yerr3); grid; legend('Absolute Error abs(sim-ssm)'); xlabel('Time'); ylabel('Absolute error');
    
    
    disp(['[SIMULATION]  Mean absolute error: ' num2str(mean(yerr1)) ' - Variance absolute error: ' num2str(var(yerr1))]);
    disp(['[SSM]         Mean absolute error: ' num2str(mean(yerr2)) ' - Variance absolute error: ' num2str(var(yerr2))]);
    disp(['[ERR SIM-SSM] Mean absolute error: ' num2str(mean(yerr3)) ' - Variance absolute error: ' num2str(var(yerr3))]);
    
    disp(['Area Simulation: ' num2str(trapz(yerr1)) ' - Area SSM: ' num2str(trapz(yerr2))]);

    yerr1= yerr1-mean(yerr1);
    yerr2=yerr2-mean(yerr2);
    yerr3=yerr3-mean(yerr3);
    coverr1 = covf(yerr1,200);
    coverr2= covf(yerr2,200);
    coverr3=covf(yerr3,200);
    figure;   
    plot(1:200,coverr1,1:200,coverr2,1:200,coverr3); title('Covariance simulation');grid; xlabel('Step'); ylabel('Cov'); legend('Simulation Covariance', 'SSM Covariance','Diff covariance');
end