function [name] = getDenomination(Model)
    temp = Model.Report.Method;

    if length(Model.a) > 1
        temp = [temp num2str(length(Model.a)-1)];
    end

    if length(Model.b) > 1
        temp = [temp num2str(sum(Model.b~=0))];
    end

    if length(Model.c) > 1
        temp = [temp num2str(length(Model.c)-1)];
    end

    if length(Model.d) > 1
        temp = [temp num2str(length(Model.d))];
    end

    if length(Model.f) > 1
        temp = [temp num2str(length(Model.f)-1)];
    end
    
    name = temp;
end