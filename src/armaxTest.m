function [fpeMIN,aicMIN] = armaxTest(u,y,NA,NC,NB,NK)
    fpeMIN = [10^5,0,0,0];
    aicMIN = [10^5,0,0,0];
    for na=1:NA
        for nc=1:NC
            for nb=1:NB
                disp(['na: ' num2str(na) ' - nc: ' num2str(nc) ' - nb: ' num2str(nb)]);
                th = armax(iddata(y,u), [na nb nc NK]);
                a=fpe(th);
                if (a < fpeMIN(1))
                    fpeMIN = [a,na,nc,nb];
                end
                a=aic(th);
                if (a < aicMIN(1))
                    aicMIN = [a,na,nc,nb];
                end
            end
        end
    end
end