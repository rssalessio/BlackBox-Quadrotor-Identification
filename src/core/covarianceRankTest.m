function [minR,order]=covarianceRankTest(data)
    y=detrend(data.y);
    u=detrend(data.u);
    
    if(iscolumn(y) == 0)
        y=y';
    end
    if(iscolumn(u)==0)
        u=u';
    end
    nmax = 100;
    minR=-1;
    order=0;
    for s=1:nmax
        R= zeros(2*(s+1),2*(s+1));
        for t=1:length(y)
            if (t+s) > length(y)
            	phi = [-y(t:end); -y(1:s-(length(y)-t))];
                phi = [phi; u(t:end); u(1:s-(length(y)-t))];
            else
                phi = [-y(t:t+s); u(t:t+s)];
            end
            R=R+phi*phi';
        end
        R = R./length(y);
        J=det(R);
        if (J > minR)
            minR=J;
            order = s;
        end
    end
    
end