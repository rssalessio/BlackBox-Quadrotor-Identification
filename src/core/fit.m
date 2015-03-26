function [J] = fit(y1,y2)
% fit(y,ysim) returns a fit ratio value calculated based on |y-ysim|/|y-mean(y)|)*100
    temp1= norm(y1-y2);
    temp2= norm(y1-ones(size(y1))*mean(y1));
    J =temp1/temp2 *100;
end