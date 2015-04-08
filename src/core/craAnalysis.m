function [g] = craAnalysis(y,u)
% Estimate the impulse response given the output and the input of the
% system. This is done with the correlation anaylsis
%
%Suppose u = white noise, y(t) = sum_k(g(k) *u(t-k)), where g is the
%impulse response (convolution)
%Then Cyu = sum(sum_k(g(k) *u(t-k))u(t-k)) = g(k) Cuu = g(k) lambda I
% if u is not wn then we calc u2=Lu s.t. u2 is nearly wn, and apply L also
% to y, then do everything
    y = y-mean(y);
    u = u-mean(u);
    
    m = ar(u, 30, 'ls');% i find A(z)u(t)=e(t)
    L=tf(m.A, 1,-1,'variable','z^-1');% L(z)=A(z)
    
    y = lsim(L,y); 
    u = lsim(L,u);%new u = e(t)
    
    
    [Cyu,lags]=xcov(y,u,length(u),'biased'); 
    Cyu = Cyu(lags >= 0);
    
    lambda = sum(u.^2)/length(u);
    
    g = Cyu/lambda;
    
    figure;
    plot(0:1:19,g(1:20)); grid; hold on;
    gmat=cra(iddata(y,u));
end