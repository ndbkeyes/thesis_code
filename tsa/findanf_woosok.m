function [a_est,N] = findanf_woosok(obj,Y,M)


    %% convert raw data to (year,month) averaged matrix
    % no need to interpolate since we've already averaged!
    
    [~,data,delt,~] = data2matrix(obj,Y,M);

    

    %% find S(m) = variance of month m data (over all years)
    
    S = zeros(M,1);
    for m=1:M
        summ = 0;
        for y=1:Y
            summ = summ + data(y,m) * data(y,m);
        end
        S(m) = summ / (Y-1);
    end



    %% find A(m) = inter-monthly autocorrelation of months m & m+1 (over all years)
    
    A = zeros(M,1);
    for m=1:M
        summ = 0;
        for y=1:Y
            if m == M  % loop around from last month to first month
                if y < Y
                    summ = summ + data(y,m) * data(y+1,1);
                else    % unless it's the last year, in which case just approximate with autocorr
                    summ = summ + data(y,m) * data(y,m);
                end
            else        % normal, m & m+1
                summ = summ + data(y,m) * data(y,m+1);
            end
        end
        A(m) = summ / (Y-1);
    end




    %% estimate a by finding G
    
    G = zeros(M,1);
    for m=1:M	% has to be M-1 since A(m) has max m=M-1
        G(m) = 1/delt * (S(m) - A(m)) / S(m);
    end

    a_est = -G;
    
    
    
    
    %% estimate N
    
    N = 0;
    
end
