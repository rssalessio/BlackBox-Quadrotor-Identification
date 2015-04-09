function [m] = meanSegments(data,r)
    R = floor(r*length(data));
    if (R == 0 || R == length(data))
        m = mean(data) *ones(size(data));
        return;
    end
    m= zeros(size(data));
    for i =1:1:length(data)
        if (i-R  < 1)
            m(i) = mean(data(1:1+R));
        elseif (R+i > length(data))
            m(i) = mean(data(i:end));
        else
            m(i) = mean(data(i-R:i+R));
        end
    end

end