function p = prof(y)
%
% FUNCTION: prof(y)
%
% PURPOSE: create cumulative profile of time series
%
% INPUT:
% - y: the dependent variable in the time series
%
% OUTPUT:
% - p: array holding the cumulative sum values of y
%


    % X needs to be interpolated data
    p = zeros(length(y),1);
    avg = mean(y);
    
    for i=1:length(y)
        cumsum_i = sum(y(1:i)) - avg*i;
        p(i) = cumsum_i;
    end    

end