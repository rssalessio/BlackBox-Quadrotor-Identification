function result = isWhite(process, alpha, opt)
% isWhite(process, alpha, opt) performs the Anderson Whiteness Test for the
% given process.
%   process: process to run the test on
%   alpha: margin of tolerance (default alpha=0.1)
%   opt: 'sp' (show plot) shows the interval of confidence
%        'pt' (print test) display on command line the test result
   
    switch nargin
        case 1 
            alpha = 0.1;
            opt = '';
        case 2
            opt = '';
    end
    
    if size(process,2) ~= 1
        error('process must be a column vector');
        return;
    end
    
    N=length(process); % number of samples

    gamma=covf(process, floor(N/10)); %compute the covariances up to N/10
    rho=gamma(2:end)/gamma(1); %compute the normalized correlations (for tau>0)
    beta=norminv(1-alpha/2); %probability to land outside (-beta;+beta) is alpha

    nalpha=length(find(sqrt(N)*rho>beta))+length(find(sqrt(N)*rho<-beta)); %number of points outside interval
    ratio=nalpha/length(rho);
    
    if ratio <= alpha
        result = 1;
    else
        result = 0;
    end
    
    if strcmp(opt,'sp')
        figure
        hold on
        plot(1:length(rho),beta*ones(length(rho),1),'r:','linewidth',5)
        plot(1:length(rho),-beta*ones(length(rho),1),'r:','linewidth',5)
        plot(1:length(rho),sqrt(N)*rho,'ko')
        ylabel('sqrt(\rho)')
    end
    
    if strcmp(opt,'pt')
        disp(['Ratio of violation: ',num2str(ratio*100),'%, alpha=',num2str(alpha)])
        if result
            disp('Anderson test passed')
        else
            disp('Anderson test failed')
        end
    end

end
