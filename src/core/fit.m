function [J] = fit(y1,y2)% fit = (1- |y-ysim|/|y-mean(y)|)*100
    temp1= norm(y2-y1);
    temp2= norm(y1-ones(size(y2))*mean(y2));
    J =temp1/temp2 *100;
end