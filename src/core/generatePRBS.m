function [temp] = generatePRBS(N,ts,low,high)
% generatePRBS(N,ts,min,max) Generate a pseudo random binary sequence
% signal
%
%INPUT:
%   N: numer of samples
%   ts: signal costant over period of time ts
%   low: min value of the sequence
%   high: max value of the sequence
    warning('off','all');
    for i=1:Inf
        temp= idinput(N,'prbs',[0 ts], [low high]);
        if (isWhite(temp,0.1,1,'nooutput')==1)
            break;
        end
    end
    warning('on','all');

end