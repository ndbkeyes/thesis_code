function [a_est,N] = findanf_est(obj,Y,M,br_win)
% 
% FUNCTION: findanf_epica(obj)
%
% PURPOSE: extracts stochastic model parameters a, N, f, P from data using
% simpler method estimating a(k) ~ -G(k); no m needed
%
% INPUT: 
% - obj: DataSet object containing the data to be analyzed
% - Y: number of years to divide dataset into
% - M: number of months to divide each year into
%
% OUTPUT:
% - a_est: array of monthly stability parameters
% - N: array of noise amplitudes
%


    % set default to not plot quantities
    if nargin == 3
        br_win = 0;
    end


    %% convert raw data to (year,month) averaged matrix
    % no need to interpolate since we've already averaged!
    
    
    if br_win == 0
        [~,data,delt] = data2matrix(obj,Y,M);       
    else
        disp("SUBTRACTING MOVING AVG");
        [~,data,delt] = data2matrix(obj,Y,M,br_win);
    end
    
    
    

    %% find S(k) = variance of month m data (over all years)
    
    S = zeros(M,1);
    for k=1:M
        summ = 0;
        for j=1:Y
            summ = summ + data(j,k) * data(j,k);
        end
        S(k) = summ / (Y-1);
    end



    %% find A(k) = inter-monthly autocorrelation of months k & k+1 (over all years)
    
    A = zeros(M,1);
    for k=1:M
        summ = 0;
        for j=1:Y
            if k == M  % loop around from last month to first month
                if j < Y
                    summ = summ + data(j,k) * data(j+1,1);
                else    % unless it's the last year, in which case just approximate with autocorr
                    summ = summ + data(j,k) * data(j,k);
                end
            else        % normal, m & m+1
                summ = summ + data(j,k) * data(j,k+1);
            end
        end
        A(k) = summ / (Y-1);
    end




    %% estimate a(k) by finding G(k)
    
    G = zeros(M,1);
    for k=1:M	% has to be M-1 since A(m) has max m=M-1
        G(k) = 1/delt * (S(k) - A(k)) / S(k);
    end

    a_est = -G;    
    
    
    
    %% estimate N fron y(k)
    
    % compute y(t)
    y = zeros(Y,M);
    for k=1:M
        for j=1:Y
            if k == M
                if j ~= Y
                    y(j,k) = data(j+1,1) - data(j,k) - a_est(k) * data(j,k);
                end
            else
                y(j,k) = data(j,k+1) - data(j,k) - a_est(k) * data(j,k);
            end
        end
    end
    
    % find y's variance
    y_var = zeros(M,1);
    for k=1:M
        summ = 0;
        for j=1:Y
            summ = summ + y(j,k)^2;
        end
        y_var(k) = summ / (M-1);
    end
    
    % estimate N(k) from y(k)
    N = zeros(M,1);
    for k=1:M
        N(k) = sqrt(y_var(k) / delt);
    end
       
    
end
