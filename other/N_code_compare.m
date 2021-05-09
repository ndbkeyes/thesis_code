%%%%%%%%%%%%%%%%%%%%% NASH VERSION %%%%%%%%%%%%%%%%%%%%%
% (based on math in 2017 paper supplementary material)

% compute y(t)
y = zeros(Y,M);
for k=1:M
    for j=1:Y-1
        if k == M
                y(j,k) = data(j+1,1) - data(j,k) - a(k) * data(j,k) * delt;
        else
            y(j,k) = data(j,k+1) - data(j,k) - a(k) * data(j,k) * delt;
        end
    end
end

% then, find y's variance & intermonth autocorr over years
y_var = zeros(M,1);
y_atc = zeros(M,1);
for k=1:M
    summ_var = 0;
    summ_atc = 0;
    for j=1:Y-1

        % add term to variance
        summ_var = summ_var + y(j,k)^2;

        % add term to autocorrelation
        if k == M       % wrap around to next k=1
            summ_atc = summ_atc + y(j,k) * y(j+1,1);
        else            % normal case
            summ_atc = summ_atc + y(j,k) * y(j,k+1);
        end

    end
    y_var(k) = summ_var / ((Y-1)-1);
    y_atc(k) = summ_atc / ((Y-1)-1);
end


% use y's variance and autocorrelation to estimate noise amplitude
N = zeros(M,1);
for k=1:M
    N2 = (y_var(k) - y_atc(k)) / delt;
    if N2 < 0
        N(k) = 0.0;
    else
        N(k) = sqrt(N2);
    end
end

        








%%%%%%%%%%%%%%%%%%%%% JOHN VERSION %%%%%%%%%%%%%%%%%%%%%
% from the code he sent me

N = zeros(M,1);
for k=1:M
    if k == M
        N(k) = (S(1)-A(k))/delt + P(1)/P(k)*(S(k)-A(k))/delt;
        N(k) = N(k) - a(k)*A(k) + P(1)/P(k)*a(k)*S(k);
        if N(k) < 0
            N(k) = 0.0;
        else
            N(k) = sqrt(N(k));
        end
    else
        N(k) = (S(k+1)-A(k))/delt + P(k+1)/P(k)*(S(k)-A(k))/delt;
        N(k) = N(k) - a(k)*A(k) + P(k+1)/P(k)*a(k)*S(k);
        if N(k) < 0
            N(k) = 0.0;
        else
            N(k) = sqrt(N(k));
        end
    end
end