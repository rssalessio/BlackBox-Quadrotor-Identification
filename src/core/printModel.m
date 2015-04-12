function [] = printModel(model)

    if isa(model,'idpoly')
        a = num2str(model.a);
        b = num2str(model.b);
        c = num2str(model.c);
        d = num2str( sum(model.b == 0) );
        f = num2str(model.f);
        
        if strcmp(model.Report.Method,'OE')
            a = f;
        end
        
        disp(['A(z): ' a]);
        disp(['B(z): ' b]);
        disp(['C(z): ' c]);
        %disp(['delay: ' d]);
    else
        error('Input is not idpoly');
    end
end