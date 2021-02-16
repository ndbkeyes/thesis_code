function [a_final,N,f,P_final] = findanf_epica(obj,Y,M,m,plotting)
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

    if nargin == 4
        plotting = 0;
    end


    %% convert raw data to (year,month) averaged matrix
    % no need to interpolate since we've already averaged!
    
    [~,data,delt,~] = data2matrix(obj,Y,M);

    

    %% find S(k) = variance of month k data (over all years)
    
    S = zeros(M,1);
    for k=1:M
        summ = 0;
        for j=1:Y
            summ = summ + data(j,k) * data(j,k);
        end
        S(k) = summ / (Y-1);
    end



    %% find A(k) = inter-monthly autocorrelation of months m & m+1 (over all years)
    
    A = zeros(M,1);
    for k=1:M
        summ = 0;
        for j=1:Y
            if k == M   % loop around from last month to first month
                if j < Y
                    summ = summ + data(j,k) * data(j+1,1);
                else    % unless it's the last year, in which case just approximate with autocorr
                    summ = summ + data(j,k) * data(j,k);
                end
            else        % normal inter-month corr, m & m+1
                summ = summ + data(j,k) * data(j,k+1);
            end
        end
        A(k) = summ / (Y-1);
    end
   

    
    %% find B(k) = inter-year autocorrelation of month k (between years j and j+m)
    
    B = zeros(M,1);    
    if m >= Y-1
        disp("ERROR - d must be < Y-1");
    end
    
    for k=1:M
        summ = 0;
        for j=1:Y-m
            summ = summ + data(j,k) * data(j+m,k);
        end
        B(k) = summ / (Y-m-1);
    end
    
    



    %% find derived quantities G(k) and H(k)
    
    G = zeros(M,1);
    H = zeros(M,1);
    for k=1:M	% has to be M-1 since A(m) has max m=M-1
        G(k) = 1/delt * (S(k) - A(k)) / S(k);
        H(k) = (S(k) - B(k)) / S(k);
    end
    
    

    

    %% use RK4 to solve for P(k) - using altered ENAS 441 code!
    P = RK4_P(Y,M,G,H,delt); 
    P_final = P(end-M+1:end);
    

    %% find a(k) = sector stability, using P, G, H
    
    a = zeros(length(P),1);
    for k=1:length(P)
        m_mod = mod_1n(k,M);
        a(k) = 1/P(k) * (H(m_mod) - G(m_mod)*P(k) - 1.0);
    end

    a_final = a(end-M+1:end);
    
    
    %% find N(k) = noise amplitude

    % compute y(t)
    y = zeros(Y,M);
    for k=1:M
        for j=1:Y
            if k == M
                if j ~= Y
                    y(j,k) = data(j+1,1) - data(j,k) - a(k) * data(j,k);
                end
            else
                y(j,k) = data(j,k+1) - data(j,k) - a(k) * data(j,k);
            end
        end
    end
    
    % then, find g's variance & intermonth autocorr over years
    y_var = zeros(M,1);
    y_atc = zeros(M,1);
    for k=1:M
        summ_var = 0;
        summ_atc = 0;
        for j=1:Y
            summ_var = summ_var + y(j,k)^2;
            if k == M
                if j ~= Y
                    summ_atc = summ_atc + y(j,k) * y(j+1,1);
                else
                    summ_atc = summ_atc + y(j,k) * y(j,k);
                end
            end
        end
        y_var(k) = summ_var / (M-1);
        y_atc(k) = summ_atc / (M-1);
    end
    
    

    % use g's variance and autocorrelation to estimate noise amplitude
    N = zeros(M,1);
    for k=1:M
        N(k) = sqrt(y_var(k) - y_atc(k)) / delt;
    end

 
    
    %% find f(tau) = long-term backbone
    f = zeros(Y,1);
    for j=1:Y
        summ = 0;
        for k=1:M
            if k == M
                if j ~= Y
                    summ = summ + (data(j,k) - data(j,k-1))/delt - a_final(k) * data(j,k);
                end
            else
                summ = summ + (data(j,k+1) - data(j,k))/delt - a_final(k) * data(j,k);
            end
        end
        f(j) = summ / M;
    end
    
    
    %% plot all quantities
    
    if plotting == 1
        close all;

        figure(1);
        hold on;
        plot(A);
        plot(S);
        plot(B);
        legend("A(k)","S(k)","B(k)");
        xlabel("months");
        title(sprintf("A, S, B for %s, Y=%d M=%d\n",obj.data_name,Y,M));
        saveas(gcf,sprintf("%s_ASB_%d-%d.jpeg",obj.data_name,Y,M));

        figure(2);
        close all;
        hold on;
        plot(H);
        legend("H(k)");
        xlabel("months");
        title(sprintf("H for %s, Y=%d M=%d\n",obj.data_name,Y,M));
        saveas(gcf,sprintf("%s_H_%d-%d.jpeg",obj.data_name,Y,M));

        figure(3);
        close all;
        hold on;
        plot(G);
        plot(a_final);
        legend("G(k)","a(k)");
        xlabel("months");
        title(sprintf("G, a for %s, Y=%d M=%d\n",obj.data_name,Y,M));
        saveas(gcf,sprintf("%s_Ga_%d-%d.jpeg",obj.data_name,Y,M));
        
        figure(4);
        close all;
        hold on;
        plot(P(1:1000));
        legend("P");
        title(sprintf("P for %s, Y=%d M=%d\n",obj.data_name,Y,M));
        saveas(gcf,sprintf("%s_P_%d-%d.jpeg",obj.data_name,Y,M));
        
        figure(5);
        close all;
        plot(P_final);
        legend("P_{final}");
        title(sprintf("P_{final} for %s, Y=%d M=%d\n",obj.data_name,Y,M));
        saveas(gcf,sprintf("%s_P-final_%d-%d.jpeg",obj.data_name,Y,M));
        
    end
%     
%     
%     

    
    
end
