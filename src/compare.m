function []=compare(u,y,Model1,Model2)
% simulate(u,y, TFModel, SSMModel) performs a simulation comparison between
% the TF Model and the SSM Model, based on input and output data (u,y)
%
%INPUT:
%   u: input 
%   y: output 
%   Model1: u-to-y tf
%   Model2: u-to-y tf

    Model1.Name = getDenomination(Model1);
    Model2.Name = getDenomination(Model2);

    ysim1 = sim(Model1, u);
    ysim2 = sim(Model2,u);
    t = 1:1:size(y);
    
    %Plot output comparisons
    figure; 
    subplot(3,1,1);
    plot(t,y,t,ysim1); grid; legend('Data', Model1.Name); xlabel('Time'); ylabel('Output');title('Simulation Output Comparison');
    
    subplot(3,1,2);
    plot(t,y,t,ysim2); grid; legend('Data',Model2.Name); xlabel('Time'); ylabel('Output');
    
    subplot(3,1,3);
    plot(t,y,t,ysim1,t,ysim2); grid; legend('Data', Model1.Name, Model2.Name); xlabel('Time'); ylabel('Output');    
    
    %Compute absolute error
    yerr = [abs(y-ysim1)'; abs(y-ysim2)'; abs(ysim1-ysim2)'];
    yerr_mean = [mean(yerr(1,:)); mean(yerr(2,:));mean(yerr(3,:))];
    yerr_var = [var(yerr(1,:)); var(yerr(2,:));var(yerr(3,:))];
    yerr_nomean = yerr-yerr_mean*ones(1,size(yerr,2));
    
    %Plot absolute error comparisons
    figure;
    subplot(4,1,1);
    plot(t,yerr(1,:)); grid; xlabel('Time'); legend(['Data vs ' Model1.Name]); title('Absolute Error Comparison');
    
    subplot(4,1,2);
    plot(t,yerr(2,:)); grid; xlabel('Time'); legend(['Data vs ' Model2.Name]);
    
    subplot(4,1,3);
    plot(t,yerr(1,:),t,yerr(2,:));grid; xlabel('Time'); legend(['Data vs ' Model1.Name ],[ 'Data vs ' Model2.Name]);
    
    subplot(4,1,4);
    plot(t,yerr(3,:)); grid; xlabel('Time'); legend([Model1.Name ' vs ' Model2.Name]);
    
    
    disp(['[' Model1.Name ' SIMULATION]  Mean absolute error: ' num2str(yerr_mean(1)) ' - Variance absolute error: ' num2str(yerr_var(1))]);
    disp(['[' Model2.Name ' SIMULATION]  Mean absolute error: ' num2str(yerr_mean(2)) ' - Variance absolute error: ' num2str(yerr_var(2))]);
    disp(['[ERR ' Model1.Name ' vs ' Model2.Name ']     Mean absolute error: ' num2str(yerr_mean(3)) ' - Variance absolute error: ' num2str(yerr_var(3))]);
    
    disp(['Area ' Model1.Name ': ' num2str(trapz(yerr(1,:))) ' - Area ' Model2.Name ': ' num2str(trapz(yerr(2,:)))]);

    N=floor(length(yerr_nomean)*0.1);
    coverr1 = covf(yerr_nomean(1,:)',N);
    coverr2= covf(yerr_nomean(2,:)',N);
    coverr3=covf(yerr_nomean(3,:)',N);
    t=1:N;
    
    figure;   
    plot(t,coverr1,t,coverr2,t,coverr3); title('Covariance simulation');grid; xlabel('Step'); ylabel('Cov'); 
    legend(Model1.Name, Model2.Name,'Diff covariance');
    isWhite(coverr1',0.1,0.4,'plot', [Model1.Name ' Simulation error']);
    isWhite(coverr2',0.1,0.4,'plot', [Model2.Name ' Simulation error']);
end