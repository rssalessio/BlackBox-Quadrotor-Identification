function [g] = craAnalysis(data)
% Estimate the impulse response given the output and the input of the
% system. This is done with the correlation anaylsis
%
%Suppose u = white noise, y(t) = sum_k(g(k) *u(t-k)), where g is the
%impulse response (convolution)
%Then Cyu = sum(sum_k(g(k) *u(t-k))u(t-k)) = g(k) Cuu = g(k) lambda I
% if u is not wn then we calc u2=Lu s.t. u2 is nearly wn, and apply L also
% to y, then do everything
    data = detrend(data);
    
    m = ar(data.InputData, 30, 'ls');% i find A(z)u(t)=e(t)
    L=tf(m.A, 1,-1,'variable','z^-1');% L(z)=A(z)
    
    y = lsim(L,data.OutputData); 
    u = lsim(L,data.InputData);%new u = e(t)
    
    
    [Cyu,lags]=xcov(data.OutputData,data.InputData,length(u),'biased'); 
    Cyu = Cyu(lags >= 0);
    
    lambda = sum(data.InputData.^2)/length(data.InputData);
    
    g = Cyu/lambda;
    
    figure;
    plot(0:1:19,g(1:20)); grid; hold on;
    gmat=cra(data); legend('CraAnalysis (AR30)','Matlab CRA (AR10)');
end