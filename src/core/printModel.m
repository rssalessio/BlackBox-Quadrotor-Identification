function [] = printModel(model)

    if isa(model,'idpoly')
        a = num2str(model.a); na = num2str(size(model.a,2)-1);
        b = num2str(model.b); nb = num2str(sum(model.b~=0));
        c = num2str(model.c);
        d = num2str( sum(model.b == 0) );
        f = num2str(model.f); nf = num2str(size(model.f,2)-1);
        
        if strcmp(model.Report.Method,'OE')
            a = f;
            na = nf;
        end
        
        disp(['na = ' na ' nb = ' nb]);
        disp(['A(z): ' a]);
        disp(['B(z): ' b]);
        disp(['C(z): ' c]);
    else
        error('Input is not idpoly');
    end
end