function [a,N,ftau,P] = findanf_v2(obj)
    
    % interpolate
    [~, x] = interpolate(obj.X,obj.Y,obj.data_res,"makima");

    
    %% set parameters for timegaps and number of sectors/points

    N = 50;                    % number of sectors
    M = floor(length(x) / N);  % number of points in each sector

    %% find S(i) = variance of ith sample in sector
    
    S = zeros(N,1);
    summ = 0;
    for j=0:M-1
        for i=1:N
            disp(i*M + j);
            summ = summ + x(i*M + j) * x(i*M + j);
        end
        S(j+1) = summ / (M-1);
    end


    
    % ----
    % KEEP EDITING

    
    
    %% find A(i) = autocorrelation between sectors i & i+1
    
    A = zeros(N-1,1);
    summ = 0;
    for j=0:N-2
        for i=1:M
            summ = summ + x(i*M + j) * x((i+1)*M + j);
        end
        A(i+1) = summ / (M-1);
    end


    %% find B(i) = autocorrelation over m "years" (between m points in the sector)
    
    m = 2;
    B = zeros(N,1);
    summ = 0;
    for i=0:N-1
        for j=1:M-m
            summ = summ + x(i*M + j) * x(i*M + (j+m));
        end
        B(i+1) = summ / (M-m-1);
    end



    %% find derived quantities G(i) and H(i)
    
    G = zeros(N-1,1);
    H = zeros(N-1,1);
    for i=0:N-2	% has to be N-1 since A(i) has max i=N-1
        G(i+1) = 1/M  * (S(i+1) - A(i+1)) / S(i+1);
        H(i+1) = (S(i+1) - B(i+1)) / S(i+1);
    end



    %% use RK4 to solve for P(i) - using ENAS 441 code!
    P = RK4_P(obj,N,M,G,H);
    


    %% solve for a(i) = sector stability, using P(i)
    a = zeros(N,1);
    for i=0:N-2
        a(i+1) = 1/P(i+1) * (H(i+1) - G(i+1)*P(i+1) - 1.0);
    end


    %% find N(i) = noise amplitude

    % first, compute y(t)
    y = zeros(N*M,1);
    for i=0:N-2
        for j=1:M
            y(i*M + j) = x((i+1)*M + j) - x(i*M + j) - a(i+1) * x(i*M + j) * M;
        end
    end

    % then, use y(t) to find y's variance (over "years" = among points in a sector, j) and autocorrelation (between "months" = sectors, i)
    y_var = zeros(N-1,1);
    y_atc = zeros(N-1,1);
    summ_var = 0;
    summ_atc = 0;
    for i=0:N-2
        for j=1:M
        summ_var = summ_var + y(i*M + j)^2;
        summ_atc = summ_atc + y(i*M + j) * y((i+1) * M + j);
        end
        y_var(i+1) = summ_var / (M-1);
        y_atc(i+1) = summ_atc / (M-1);
    end

    % finally, use y variance and autocorrelation to estimate noise amplitude
    N_amp = zeros(N-1,1);
    for i=0:N-2
        N_amp(i+1) = 1/M * sqrt(y_var(i+1) - y_atc(i+1));
    end


    %% find f(i) = long-term backbone
    ftau = zeros(N,1);
    summ = 0;
    for i=0:N-1
        for j=1:M
            summ = summ + (x(i*M + (j+1)) - x(i*M + j)) - a(i+1) * x(i*M + j);
        end
        ftau(i+1) = summ / M;
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
