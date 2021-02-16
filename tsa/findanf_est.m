function [a_est,N] = findanf_est(obj,Y,M)
% Woosok's simpler method for parameter extraction


    %% convert raw data to (year,month) averaged matrix
    
    [~,data,delt,~] = data2matrix(obj,Y,M);

    

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




    %% estimate a(k) by finding G
    
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
