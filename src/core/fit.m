function [J,eps] = fit(y1,y2,opt,alpha)
eps=0;
% fit(y,ysim) returns a fit ratio value calculated based on |y-ysim|/|y-mean(y)|)*100
if(opt==0)
    temp1= norm(y1-y2);
    temp2= norm(y1-ones(size(y1))*mean(y1));
    J =(1-temp1/temp2 )*100;
    eps=temp1;
elseif(opt==1)
    eps = abs(y1-y2);
    m = meanSegments(abs(y1),alpha);
    l = logical(eps > m);
    J = (1- ( sum(l)/length(eps) )) *100;
    eps=l;
elseif(opt==2)
    eps = abs(y1-y2).^2;
    J=trapz(eps);
elseif(opt==3)
    eps=abs(y1-y2);
    J = max(eps);
else
    error('Bad option in fit');
end