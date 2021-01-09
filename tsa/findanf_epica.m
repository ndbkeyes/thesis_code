function [a,N_amp,ftau,P] = findanf_epica(obj)
% 
%
    
    % interpolate
    [~, x] = interpolate(obj.X, obj.Y, obj.data_res, "makima");

    
    %% set parameters for timegaps and number of sectors/points

    Y = 40;                    % number of "years"
    M = floor(length(x) / Y);  % number of "months" in each "year"
    
    

    %% find S(i) = variance of points in "month" k
    
    S = zeros(M,1);
    summ = 0;
    for k=1:M
        for i=0:Y-1
            disp(i*M + k);
            summ = summ + x(i*M + k) * x(i*M + k);
        end
        S(k+1) = summ / (Y-1);
    end



    %% find A(i) = autocorrelation between "months" within ith "year"
    
    A = zeros(M-1,1);
    summ = 0;
    for k=1:M
        for i=0:Y-2
            summ = summ + x(i*M + k) * x((i+1)*M + k);
        end
        A(k+1) = summ / (Y-1);
    end


    %% find B(i) = autocorrelation of kth month over m "years"
    
    m = 2;
    B = zeros(M,1);
    summ = 0;
    for k=1:M
        for i=0:Y-m-1
            summ = summ + x(i*M + k) * x(i*(M+m) + k);
        end
        B(k+1) = summ / (Y-m-1);
    end



    %% find derived quantities G(k) and H(k)
    
    G = zeros(M-1,1);
    H = zeros(M-1,1);
    for k=1:M-1	% has to be M-1 since A(i) has max i=M-1
        G(k) = (S(k) - A(k)) / S(k);
        H(k) = (S(k) - B(k)) / S(k);
    end



    %% use RK4 to solve for P(k) - using ENAS 441 code!
    P = RK4_P(Y,M,G,H);
    


    %% solve for a(k) = sector stability, using P(k)
    a = zeros(Y,1);
    for k=1:Y-1
        a(k) = 1/P(k) * (H(k) - G(k)*P(k) - 1.0);
    end


    %% find N(i) = noise amplitude

    % first, compute y(t)
    y = zeros(Y*M,1);
    for k=1:M
        for i=0:Y-2
            y(i*M + k) = x((i+1)*M + k) - x(i*M + k) - a(k+1) * x(i*M + k);
        end
    end

    % then, use y(t) to find y's variance (over "years" = among points in a sector, j) and autocorrelation (between "months" = sectors, i)
    y_var = zeros(Y-1,1);
    y_atc = zeros(Y-1,1);
    summ_var = 0;
    summ_atc = 0;
    for k=0:Y-2
        for i=1:M
        summ_var = summ_var + y(k*M + i)^2;
        summ_atc = summ_atc + y(k*M + i) * y((k+1) * M + i);
        end
        y_var(k+1) = summ_var / (M-1);
        y_atc(k+1) = summ_atc / (M-1);
    end

    % finally, use y variance and autocorrelation to estimate noise amplitude
    N_amp = zeros(Y-1,1);
    for k=1:M-1
        N_amp(k+1) = sqrt(y_var(k+1) - y_atc(k+1));
    end


    %% find f(i) = long-term backbone
    ftau = zeros(Y,1);
    summ = 0;
    for k=1:M
        for i=0:Y-1
            summ = summ + (x(i*M + (k+1)) - x(i*M + k)) - a(k+1) * x(i*M + k);
        end
        ftau(k+1) = summ / M;
    end

    
    close all;
    hold on;
    plot(a);
    plot(ftau);
    plot(N_amp);
    plot(P);
    plot(G);
    plot(H);
    plot(S);
    legend("a","ftau","N_amp","P","G","H","S");
end
