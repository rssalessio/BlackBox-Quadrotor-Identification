function [] = plotCov(y,N)
    R=covf(y,N);

    figure;
    subplot(2,1,1); plot(R);
    subplot(2,1,2);
    
    
    parcorr(y,N);
end