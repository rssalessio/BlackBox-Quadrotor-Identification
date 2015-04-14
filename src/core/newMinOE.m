function [theta] =newMinOE(data, order)
    data = detrend(data);
    nb = order(2);
    na = order(1);
    nk = order(3);
   
    
    T = length(data.y);
     u= [zeros(nk+nb,1); data.u];
    y=[zeros(na, 1);data.y];
    R = zeros(nb+na,nb+na);
    phi = 0;
    C = zeros(na+nb,1);
    for t=1:T
        phi=[0];
        for j=0:nb-1
            phi = [phi; u(nk+nb+t-nk-j,1)];
        end
        for j=1:na
            phi = [phi; -y(na+t-j,1)];
        end
        %phi = [u(nk+nb+t-nk:nk+nb+t-nk-nb) ; -y(nb+t-1:nb+t-nb)];
        phi = phi(2:end,1);
        R=R+phi*phi';
        C=phi*y(t);
    end
    theta = R\C;
end