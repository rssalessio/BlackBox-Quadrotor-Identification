classdef inspectSignal
    properties
    end
    methods(Static)
        function [] = inspect(x,Ts)
           % Some tests to understand:
           % Ts = 0.2; => Fs=5 => nyquist 2.5Hz
           % t=0:Ts:10; x= sin(2*pi*2*t)+sin(2*pi*1*t)+sin(2*pi*5*t);
           %inspectSignal.inspectX(x,Ts); 
           % signal at 1 hz is visible, at 2hz is shifted because near
           % nyquist freq, 5hz not visible
           xt = x - mean(x);
           [Cxx,lags]=xcov(xt,length(x),'biased'); 
           tau=lags; 
           
           t=0:Ts:length(xt)*Ts-Ts;
           figure; subplot(311); plot(t,xt); grid; xlabel('Time [s]'); ylabel('x(t)'); title('Plot');
           subplot(312); plot(tau,Cxx); grid; xlabel('\tau'); ylabel('C_{xx}(\tau)'); title('Covariance');
           
      
           
           subplot 313
           h=spectrumplot(etfe(iddata([],xt,Ts)),spa(iddata([],xt,Ts)));
           legend({'Smoothed periodogram','Blackman-Tukey estimate'});
        end
        
        function [] = crossInspect(data)
           x= data.u;
           y= data.y;
           Ts = data.Ts;
           xt = x - mean(x);
           yt = y -  mean(y);
           [Cyx,lags]=xcov(yt,xt,length(xt),'biased'); 
           tau=lags; 
           
           t=0:Ts:length(xt)*Ts-Ts;
           figure; subplot(311); plot(t,yt); grid; xlabel('Time [s]'); ylabel('y(t)'); title('y(t)');
           subplot(312); plot(t,xt); grid; xlabel('Time [s]'); ylabel('x(t)');  title('u(t)');
           subplot(313); plot(tau,Cyx); grid; xlabel('\tau [s]'); ylabel('C_{xy}(\tau)'); title('Cross-Covariance');
           
           Fs=1/Ts;
           Cyx = Cyx(tau >= 0);
        end
        
        function [result,ratio,tolerances] = isWhite(process, alpha, samples, opt, plotTitle)
        % isWhite(process, alpha, opt) performs the Anderson Whiteness Test for the
        % given process.
        %
        %INPUT:
        %   process: process to run the test on
        %   alpha: margin of tolerance (default alpha=0.1), the lower the better
        %   samples: percentage of samples to consider (default 0.1)
        %   opt: 'plot' (show plot) shows the interval of confidence
        %        'nooutput' no output at all
        %        '' nothing
        %OUTPUT:
        %   result: 1 'passed', 0 'not passed'
        %   ratio:  ratio of points outside the interval
        %   tolerances: column vector of size 2, has tolerances level for:
        %               [anderson, covariance]
   
        switch nargin
            case 1 
                alpha = 0.1;
                samples = 0.1;
                opt = '';
            case 2
                samples = 0.1;
                opt = '';
            case 3
                opt = '';
            case 4
                plotTitle = ' ';
        end

        if size(process,2) ~= 1
            error('process must be a column vector');
        end

        if (alpha <= 0 || alpha >= 1)
            alpha = 0.1;
        end

        if (samples <= 0 || samples > 1)
            samples = 0.1;
        end

        process = detrend(process,'constant');
        process = detrend(process,'linear');

        N=length(process); % number of samples

        process_cov=covf(process, floor(N*samples)); %compute the covariances up to N*samples, 0<samples<=1
        rho=process_cov(2:end)/process_cov(1); %compute the normalized correlations (for tau>0)
        beta=norminv(1-alpha/2); %probability to land outside (-beta;+beta) is alpha
        cov_beta = (beta*process_cov(1))/sqrt(N); %tolerances for covariance

        nalpha=length(find(sqrt(N)*rho>beta))+length(find(sqrt(N)*rho<-beta)); %number of points outside interval

        ratio=nalpha/length(rho);
        result = (ratio <= alpha);
        tolerances = [beta,cov_beta];

        if strcmp(opt,'nooutput')
            return;
        end

        disp(['Ratio of violation: ',num2str(ratio*100),'%, alpha=',num2str(alpha), ', covariance tolerance: ',num2str(cov_beta)])
        disp(['Anderson test pass: ' num2str(result) ]);


            if strcmp(opt,'plot')
                figure
                grid
                hold on
                %Plot anderson
                subplot(2,1,1);
                plot(1:length(rho),beta*ones(length(rho),1),'r--','linewidth',1); hold on;
                plot(1:length(rho),-beta*ones(length(rho),1),'r--','linewidth',1); hold on;
                plot(1:length(rho),sqrt(N)*rho,'ko'); hold on;
                grid;
                ylabel('sqrt(\rho)')
                xlabel('N');
                title(['Anderson Test - ', plotTitle]);
                legend('Tolerance');

                if result
                    text(10,sqrt(N)*rho(1),'WHITE');
                else
                    text(10,sqrt(N)*rho(1),'NOT WHITE');
                end

                %Plot covariance
                subplot (2,1,2);
                plot(1:length(process_cov), process_cov); hold on;
                plot(1:length(process_cov),cov_beta*ones(length(process_cov),1),'r--','linewidth',1); hold on;
                plot(1:length(process_cov),-cov_beta*ones(length(process_cov),1),'r--','linewidth',1); hold on;
                legend('Covariance','Tolerances');
                grid;
                xlabel('N');
                ylabel('Cov');
                title(['Covariance input - ', plotTitle]);
            end


        end

    end
end