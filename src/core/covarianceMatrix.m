function [R]=covarianceMatrix(data, order,matlab)
%CovarianceMatrix returns the covariance matrix with the given data and the
%order desired. Data needs to be a column vector
    if(matlab)
        R = covf(data,order);
        R= R'*R;
    else
        N = length(data);
        R=zeros(order,order);
        tempData = [data; data(1: order)];
        for i = 1:N
           phi = tempData(1+(i-1):(i-1)+order);
           R=R+phi*phi';
        end
        R=R/N;
    end
end