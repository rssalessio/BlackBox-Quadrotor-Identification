function [fpeMIN,aicMIN] = armaTest(y,NA,NC)
    fpeMIN = [10^5,0,0];
    aicMIN = [10^5,0,0];
    for na=1:NA
        for nc=1:NC
            disp(['na: ' num2str(na) ' - nc: ' num2str(nc)]);
            th = armax(iddata(y), [na nc]);
            a=fpe(th);
            if (a < fpeMIN(1))
                fpeMIN = [a,na,nc];
            end
            a=aic(th);
            if (a < aicMIN(1))
                aicMIN = [a,na,nc];
            end
        end
    end
end