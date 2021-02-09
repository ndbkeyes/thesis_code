function [a_final,N,f,P_final] = findanf_epica(obj,Y,M,d,h)
% 
% FUNCTION: findanf_epica(obj)
%
% PURPOSE: extracts stochastic model parameters a, N, f, P from data
%
% INPUT: 
% - obj - DataSet object containing the data to be analyzed
% - Y: number of years to divide dataset into
% - M: number of months to divide each year into
%
% OUTPUT:
% - a: array of monthly stability parameters
% - N_amp: array of noise amplitudes
% - ftau: array of slow forcing values
% - P: periodic parameter used to find a
%


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
                end
            else        % normal, m & m+1
                summ = summ + data(y,m) * data(y,m+1);
            end
        end
        A(m) = summ / (Y-1);
    end


    %% find B(m) = inter-year autocorrelation of month m (between years y and y+i)
    
    B = zeros(M,1);
    fprintf("finding B with d=%d :\n",d);
    
    if d >= Y-1
        disp("ERROR - d must be < Y-1");
    end
    
    for m=1:M
        summ = 0;
        for y=1:Y-d
            summ = summ + data(y,m) * data(y+d,m);
        end
        B(m) = summ / (Y-d-1);
    end



    %% find derived quantities G(m) and H(m)
    
    G = zeros(M,1);
    H = zeros(M,1);
    for m=1:M	% has to be M-1 since A(m) has max m=M-1
        G(m) = 1/delt * (S(m) - A(m)) / S(m);
        H(m) = (S(m) - B(m)) / S(m);
    end

    

    %% use RK4 to solve for P(m) - using altered ENAS 441 code!
    P = RK4_P(Y,M,G,H,h); 
    P_final = P(end-M+1:end);
    

    %% find a(m) = sector stability, using P, G, H
    
    a = zeros(length(P),1);
    for m=1:length(P)
        m_mod = mod_1n(m,M);
        a(m) = 1/P(m) * (H(m_mod) - G(m_mod)*P(m) - 1.0);
    end

    a_final = a(end-M+1:end);
    
    
    %% find N(m) = noise amplitude

    % compute g(t)
    g = zeros(Y,M);
    for m=1:M
        for y=1:Y
            if m == M
                if y ~= Y
                    g(y,m) = data(y+1,1) - data(y,m) - a(m) * data(y,m);
                end
            else
                g(y,m) = data(y,m+1) - data(y,m) - a(m) * data(y,m);
            end
        end
    end

    %%
    
    % then, find g's variance & intermonth autocorr over years
    g_var = zeros(Y-1,1);
    g_atc = zeros(Y-1,1);
    summ_var = 0;
    summ_atc = 0;
    for m=1:M
        for y=1:Y
            summ_var = summ_var + g(y,m)^2;
            if m == M
                if y ~= Y
                    summ_atc = summ_atc + g(y,m) * g(y+1,1);
                end
            end
        end
        g_var(m) = summ_var / (M-1);
        g_atc(m) = summ_atc / (M-1);
    end
    
    

    % use g's variance and autocorrelation to estimate noise amplitude
    N = zeros(M,1);
    for m=1:M
        N(m) = sqrt(g_var(m) - g_atc(m));
    end

 
    
    %% find f(tau) = long-term backbone
    f = zeros(Y,1);
    summ = 0;
    for y=1:Y
        for m=1:M
            if m == M
                if y ~= Y
                    summ = summ + (data(y,m) - data(y,m-1))/delt - a_final(m) * data(y,m);
                end
            else
                summ = summ + (data(y,m+1) - data(y,m))/delt - a_final(m) * data(y,m);
            end
        end
        f(y) = summ / M;
    end
    
    close all;
    hold on;
    plot(P);
    plot(a);

    
    
end
