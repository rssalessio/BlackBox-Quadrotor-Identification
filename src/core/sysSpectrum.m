function [W,omega] = sysSpectrum(tfsys)
% Plot the the spectrum of a system from -pi to pi (|W(e^(i*omega))|^2)
% Input:  tfsys, input of type tf defined with variable 'z^-1'
% Output: the spectrum W and the omega on which it was calculated

    num = tfsys.num{1};
    den = tfsys.den{1};
    omega = linspace(-pi,pi, 10^5);
    W = zeros(length(omega),1);
    
    for n=1:length(omega)
       tempnum=0;
       for p = 1:length(num)
           tempnum = tempnum + num(p)*exp(-i*omega(n)*(p-1));
       end
       tempden=0;
       for p = 1:length(den)
           tempden = tempden + den(p)*exp(-i*omega(n)*(p-1));
       end
       W(n) = abs(tempnum)^2 / abs(tempden)^2;
    end
    figure;
    subplot 211;
    plot(omega, W);
    axis([-pi pi min(W) max(W)]); grid;
    xlabel('\omega');
    ylabel('|W(e^{i\omega})|^2');
    title('System spectrum');
    subplot 212
    semilogx(omega(omega>0),20*log10(W(omega>0))); grid;
    xlabel('\omega');
    ylabel('20 log_{10}(|W(e^{i\omega})|^2)');
    title('System spectrum');
end