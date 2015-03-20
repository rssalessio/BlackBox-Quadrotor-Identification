function [fpeMIN,aicMIN,opt] = armaxTest(u,y,NA,NC,NB,NK)
    fpeMIN = [10^5,0,0,0];
    aicMIN = [10^5,0,0,0];
    opt = armaxOptions;
    opt.Focus = 'simulation';
    opt.SearchOption.MaxIter = 30;
    opt.SearchMethod='auto';
    for na=1:NA
        for nb=1:NB
            for nc=1:NC
                
                th = armax(iddata(y,u), [na nb nc NK], opt);
                Jf=fpe(th);
                Ja=aic(th);
                disp(['na: ' num2str(na) ' - nb: ' num2str(nb) ' - nc: ' num2str(nc) ' - J(FPE): ' num2str(Jf) ' - J(AIC): ' num2str(Ja)] );
                if (Jf < fpeMIN(1))
                    fpeMIN = [Jf,na,nb,nc];
                end
                
                if (Ja < aicMIN(1))
                    aicMIN = [Ja,na,nb,nc];
                end
            end
        end
    end
end