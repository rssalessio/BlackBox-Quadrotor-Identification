function [save]=compare(data,Model1,Model2,AddNoise)
% compare(u,y, model1, model2) performs a simulation comparison between
% the 1st model and the 2nd model, based on input and output data (u,y)
%
%INPUT:
%   u: input 
%   y: output 
%   Model1: u-to-y tf
%   Model2: u-to-y tf
%   AddNoise: noise also taken into consideration
%OUTPUT:
%   save: structure with all the comparison data
    save.Model1 = Model1;
    save.Model2 = Model2;
    data = detrend(data);
    save.Data = data;
    save.Noise = AddNoise;
    
    [Model1Name,Model2Name]=modelCheck(Model1,Model2);
    save.Model1Name = Model1Name;
    save.Model2Name = Model2Name;
    plotZeroPoles(Model1,Model1Name,Model2,Model2Name);
    
    opt = simOptions('AddNoise',AddNoise);
    
    ysim1 = sim(Model1, data.InputData,opt);
    ysim2 = sim(Model2, data.InputData,opt);
    save.ysim1 = ysim1;
    save.ysim2 = ysim2;
    t = 1:1:size(data.OutputData);
    
    plotOutput(t,data.OutputData,ysim1,ysim2,Model1Name,Model2Name);
    plotPower(data.OutputData,ysim1,ysim2,data.InputData);
    
    %Compute absolute error
    yerr = [abs(data.OutputData-ysim1)'; abs(data.OutputData-ysim2)'; (ysim1-ysim2)'];
    yerr_mean = [mean(yerr(1,:)); mean(yerr(2,:));mean(yerr(3,:))];
    yerr_var = [var(yerr(1,:)); var(yerr(2,:));var(yerr(3,:))];
    yerr_nomean = yerr-yerr_mean*ones(1,size(yerr,2));
    save.yerr = yerr;
    plotError(t,yerr,yerr_mean,yerr_var,Model1Name,Model2Name);
    
    whiteCheck(t,yerr_nomean,Model1Name,Model2Name);
end

function [Model1Name,Model2Name]=modelCheck(Model1,Model2)
    if isa(Model1,'ss')==1
        Model1Name = 'SS';
    elseif isa(Model1,'idpoly')==1
        Model1Name = getDenomination(Model1);
    else
        error('Model1 must be either a ss model or idpoly');
    end
    
    if isa(Model2,'ss')==1
        Model2Name = 'SS';
    elseif isa(Model2,'idpoly')==1
        Model2Name = getDenomination(Model2);
    else
        error('Model1 must be either a ss model or idpoly');
    end
end

function []=plotZeroPoles(Model1,Model1Name,Model2,Model2Name)
    zsys1 = zpk(Model1);
    zsys2 = zpk(Model2);
    
    figure;
    
    subplot(2,1,1);
    zplane(cell2mat(zsys1.z),cell2mat(zsys1.p)); title(['Zero-poles diagram: ', Model1Name ' - Gain: ' num2str(zsys1.k)]);
    subplot(2,1,2);
    zplane(cell2mat(zsys2.z),cell2mat(zsys2.p)); title(['Zero-poles diagram: ', Model2Name ' - Gain: ' num2str(zsys2.k)]);
end

function []=plotOutput(t,y,ysim1,ysim2,Model1Name,Model2Name)
%Plot output comparisons
    figure; 
    subplot(3,1,1);
    plot(t,y,t,ysim1); axis([0, length(t), min([y;ysim1]), max([y;ysim1])+8]);grid; legend('Data', Model1Name); xlabel('Time'); ylabel('Output');title('Simulation Output Comparison');hold on;
    J=fit(y,ysim1);
    text(0,max(y),['Fit: ' num2str(J) ' %']);hold on;
    
    subplot(3,1,2);
    plot(t,y,t,ysim2); axis([0, length(t), min([y;ysim2]), max([y;ysim2])+8]);grid; legend('Data',Model2Name); xlabel('Time'); ylabel('Output');
    J=fit(y,ysim2);
    text(0,max(y),['Fit: ' num2str(J) ' %']);hold on;
    
    subplot(3,1,3);
    plot(t,y,t,ysim1,t,ysim2);axis([0, length(t), min([ysim2;ysim1]), max([ysim2;ysim1])+8]);grid; legend('Data', Model1Name, Model2Name); xlabel('Time'); ylabel('Output');   
    
end

function []=plotPower(y,ysim1,ysim2,u)
    figure;
    subplot(4,1,1);
    periodogram(y);
    subplot(4,1,2);
    periodogram(ysim1);
    subplot(4,1,3);
    periodogram(ysim2);
    subplot(4,1,4);
    periodogram(u);
end

function []=plotError(t,yerr,yerr_mean,yerr_var,Model1Name,Model2Name)
%Plot absolute error comparisons
    figure;
    subplot(4,1,1);
    plot(t,yerr(1,:)); axis([0, length(t), min(yerr(1,:)), max(yerr(1,:))+8]); grid; xlabel('Time'); legend(['Data vs ' Model1Name]); title('Absolute Error Comparison');hold on;
    [maxi,arg] = max(yerr(1,:)); text(arg,maxi+3,['MAX = ' num2str(maxi)]);
    text(0,maxi+3,['Mean: ' num2str(yerr_mean(1)) ' - Var: ' num2str(yerr_var(1))]);hold on;
    plot(1:length(t),maxi*ones(length(t),1),'m-','linewidth',1); hold on;
    plot(1:length(t),yerr_mean(1)*ones(length(t),1),'m-','linewidth',1); hold on;
    
    subplot(4,1,2);
    plot(t,yerr(2,:)); axis([0, length(t), min(yerr(2,:)), max(yerr(2,:))+8]);grid; xlabel('Time'); legend(['Data vs ' Model2Name]);hold on;
    [maxi,arg] = max(yerr(2,:)); text(arg,maxi+3,['MAX = ' num2str(maxi)]);
    text(0,maxi+3,['Mean: ' num2str(yerr_mean(2)) ' - Var: ' num2str(yerr_var(2))]);hold on;
    plot(1:length(t),maxi*ones(length(t),1),'m-','linewidth',1); hold on;
    plot(1:length(t),yerr_mean(2)*ones(length(t),1),'m-','linewidth',1); hold on;
    
    subplot(4,1,3);
    plot(t,yerr(1,:),t,yerr(2,:));axis([0, length(t), min([yerr(1,:),yerr(2,:)]), max([yerr(2,:),yerr(1,:)])+8]);  grid; xlabel('Time'); legend(['Data vs ' Model1Name ],[ 'Data vs ' Model2Name]);
    
    subplot(4,1,4);
    plot(t,yerr(3,:));axis([0, length(t), min(yerr(3,:)), max(yerr(3,:))+8]); grid; xlabel('Time'); legend([Model1Name ' vs ' Model2Name]); hold on;
    [maxi,arg] = max(yerr(3,:)); text(arg,maxi+3,['MAX = ' num2str(maxi)]);
    text(0,maxi+3,['Mean: ' num2str(yerr_mean(3)) ' - Var: ' num2str(yerr_var(3))]); hold on;
    plot(1:length(t),maxi*ones(length(t),1),'m-','linewidth',1); hold on;
    plot(1:length(t),yerr_mean(3)*ones(length(t),1),'m-','linewidth',1); hold on;
    
    disp(['[' Model1Name ' SIMULATION]  Mean absolute error: ' num2str(yerr_mean(1)) ' - Variance absolute error: ' num2str(yerr_var(1))]);
    disp(['[' Model2Name ' SIMULATION]  Mean absolute error: ' num2str(yerr_mean(2)) ' - Variance absolute error: ' num2str(yerr_var(2))]);
    disp(['[ERR ' Model1Name ' vs ' Model2Name ']     Mean absolute error: ' num2str(yerr_mean(3)) ' - Variance absolute error: ' num2str(yerr_var(3))]);
    
    disp(['Area ' Model1Name ': ' num2str(trapz(yerr(1,:))) ' - Area ' Model2Name ': ' num2str(trapz(yerr(2,:)))]);
end

function []=whiteCheck(t,yerr_nomean,Model1Name,Model2Name)
    N=floor(length(yerr_nomean)*0.1);
    coverr1 = covf(yerr_nomean(1,:)',N);
    coverr2 = covf(yerr_nomean(2,:)',N);
    coverr3 = covf(yerr_nomean(3,:)',N);
    t=1:N;
    
    figure;   
    plot(t,coverr1,t,coverr2,t,coverr3); title('Covariance simulation');grid; xlabel('Step'); ylabel('Cov'); 
    legend(Model1Name, Model2Name,'Diff covariance');
    
    inspectSignal.isWhite(coverr1',0.1,0.4,'plot', [Model1Name ' Simulation error']);
    inspectSignal.isWhite(coverr2',0.1,0.4,'plot', [Model2Name ' Simulation error']);
end