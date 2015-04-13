function [] = plotfft(y)
%function used to plot the fft of y and its fourier series representation
    y=detrend(y);
    x = 1:1:length(y);
    T = length(y);
    df =1/T;

    N=length(x);
    
    vett_f=0:df:df*(N/2-1);
    fftout=fft(y);
    mody(1)=abs(fftout(1))/N;
    mody(2:N/2)=abs(fftout(2:N/2))*2/N;
    fasy(1:N/2)=angle(fftout(1:N/2));
    figure;
    subplot 211;bar(vett_f,mody);grid
    subplot 212;bar(vett_f,fasy);grid
    
    dt=0.001;
    tempo=0:dt:T;
    np=length(tempo);
    yr=zeros(1,np);
    for k=1:N/2
        ome=2*pi*vett_f(k);
        yr=yr+mody(k)*cos(ome*tempo+fasy(k));
    end
    figure;
    plot(1:dt:T+1,yr); hold on; plot(y)
end