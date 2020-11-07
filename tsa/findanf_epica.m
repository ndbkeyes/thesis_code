function [a,N,ftau,P] = findanf_epica(x)


    %% set parameters for timegaps and number of sectors/points
    % assuming interpolation has already occurred, so # of points per section ~ time size of section

    N = 100;				% number of sectors ("months")
    del_n = range(x) / N;			% size of sectors
    M = num_sectors / size_sectors;		% number of points in each sector
    del_m = del_n / M;			% time between points


    %% find S(i) = variance of points in sector i
    
    S = zeros(N,1);
    for i=1:N
        for j=1:M
            summ = summ + x(i*del_n + j) * x(i*del_n + j);
        end
        S(i) = summ / (M-1);
    end



    %% find A(i) = autocorrelation between sectors i & i+1
    
    A = zeros(N-1,1);
    for i=1:N-1
        for j=1:M
            summ = summ + x(i*del_n + j) * x((i+1)*del_n + j);
        end
        A(i) = summ / (M-1);
    end


    %% find B(i) = autocorrelation over m "years" (between m points in the sector)
    
    m = 2;
    B = zeros(N,1);
    for i=1:N
        for j=1:M-m
            summ = summ + x(i*del_n + j) * x(i*del_n + (j+m));
        end
        B(i) = summ / (M-m-1);
    end



    %% find derived quantities G(i) and H(i)
    
    G = zeros(N-1,1);
    H = zeros(N-1,1);
    for i=1:N-1	% has to be N-1 since A(i) has max i=N-1
        G(i) = 1/del_n  * (S(i) - A(i)) / S(i);
        H(i) = (S(i) - B(i)) / S(i);
    end



    %% use RK4 to solve for P(i) - using ENAS 441 code!

    P = RK4(happrox,G,H);
    


    %% solve for a(i) = sector stability, using P(i)
    a = zeros(N,1);
    for i=1:N
        a(i) = 1/P(i) * (H(i) - G(i)*P(i) - 1.0);
    end


    %% find N(i) = noise amplitude

    % first, compute y(t)
    y = zeros(N-1,1);
    for i=1:N-1
        for j=1:M
        y(i*del_n + j) = x((i+1)*del_n + j) - x(i*del_n + j) - a(i*del_n + j) * x(i*del_n + j) * del_n;
        end
    end

    % then, use y(t) to find y's variance (over "years" = among points in a sector, j) and autocorrelation (between "months" = sectors, i)
    y_var = zeros(N-1,1);
    y_atc = zeros(N-1,1);
    for i=1:N-1
        for j=1:M
        summ_var = summ_var + y(i*del_n + j)^2;
        summ_atc = summ_atc + y(i*del_n + j) * y((i+1) * del_n + j);
        end
        y_var(i) = summ_var / (M-1);
        y_atc(i) = summ_atc / (M-1);
    end

    % finally, use y variance and autocorrelation to estimate noise amplitude
    N = zeros(N-1,1);
    for i=1:N-1
        N(i) = 1/del_n * sqrt(y_var(i) - y_atc(i));
    end


    %% find f(i) = long-term backbone
    ftau = zeros(N,1);
    for i=1:N
        summ = 0.0;
        for j=1:M
            summ = summ + (x(i*del_n + (j+1)*del_m) - x(i*del_n + j*del_m)) / del_m - a(i) * x(i*del_n + j*del_m);
        end
        ftau(i) = summ / M;
    end

    
end
