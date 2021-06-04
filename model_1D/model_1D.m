function anf = model_1D(obj,Y,M,m,br_win,plt)

    [~,dm_y,delt] = data2matrix(obj,Y,M,br_win);
    
    %% find A, S, B
    
    
    % monthly variance S(k)
    S = zeros(1,M);
    for k=1:M
        summ = 0;
        for j=1:Y
            summ = summ + dm_y(j,k)^2;
        end
        S(k) = summ / (Y-1);
    end
    
    % inter-monthly autocorrelation A(k)
    A = zeros(1,M);
    for k=1:M
        
        summ = 0;
        
        for j=1:Y
            
            if k == M
                if j == Y
                    summ = summ + dm_y(j,k)^2;              % last month & year BOTH
                else
                    summ = summ + dm_y(j,k) * dm_y(j+1,1);  % last month NOT year (wraparound)
                end                
            else
                summ = summ + dm_y(j,k) * dm_y(j,k+1);      % normal case
            end
            
        end
        
        A(k) = summ / (Y-1);
        
    end
    
    % m-month autocorrelation B(k)
    B = zeros(1,M);
    for k=1:M
        summ = 0;
        for j=1:Y-m
            summ = summ + dm_y(j,k) * dm_y(j+m,k);
        end
        B(k) = summ / (Y-m-1);
    end
    
    
    % intermediate quantities G(k), H(k)
    G = zeros(1,M);
    H = zeros(1,M);
    for k=1:M
        G(k) = ( S(k) - A(k) ) / ( S(k) * delt );
        H(k) = ( S(k) - B(k) ) / ( S(k) );
    end
    
    
    % find P(k) with RK4
    P_full = RK4_P(Y,M,G,H,delt);
    P = P_full(end-M+1:end);
    
    
    % stability a(k)
    a = zeros(1,M);
    for k=1:M
        a(k) = ( H(k) - G(k) * P(k) - 1 ) / P(k);
    end
    
    
    
    
    % intermediate term y(k)
    y = zeros(Y,M);
    for k=1:M
        for j=1:Y
            
            if k == M
                if j == Y
                    y(j,k) = - a(k) * dm_y(j,k) * delt;                         % last month & year BOTH !
                else
                    y(j,k) = dm_y(j+1,1) - dm_y(j,k) - a(k) * dm_y(j,k) * delt; % last month & NOT last year (wraparound)
                end
            else
                y(j,k) = dm_y(j,k+1) - dm_y(j,k) - a(k) * dm_y(j,k) * delt;     % normal case
            end
            
        end
    end
    
    
    % var & autocor of y(k)
    y_var = zeros(1,M);
    y_aco = zeros(1,M);
    
    for k=1:M
        
        summ_var = 0;
        summ_aco = 0;
        
        for j=1:Y
            
            summ_var = summ_var + y(j,k)^2;
            
            if k == M
                if j == Y
                    summ_aco = summ_var + y(j,k)^2;             % last month & year BOTH
                else
                    summ_aco = summ_var + y(j,k) * y(j+1,1);    % last month NOT last year (wraparound)
                end
            else
                summ_aco = summ_var + y(j,k) * y(j,k+1);        % normal case
            end
            
        end
        
        y_var(k) = summ_var / (Y-1);
        y_aco(k) = summ_aco / (Y-1);
        
    end
    
    
    
    % noise N(k)
    N = zeros(1,M);
    for k=1:M
        
        Nsq = ( y_var(k) - y_aco(k) ) / delt;
        if Nsq < 0
            N(k) = 0;
        else
            N(k) = sqrt(Nsq);
        end
        
    end
    
    
    
    
    f = zeros(1,Y);
    for j=1:Y
        summ = 0;
        
        for k=1:M
            if k == M
                
                %%% UNSURE ABOUT THIS - below line is original version
                % summ = summ + (dm_y(j,k) - dm_y(j,k-1))/delt - a(k) * dm_y(j,k);
                
                if j == Y
                    summ = summ - a(k) * dm_y(j,k);                                     % last month & year BOTH
                else
                    summ = summ + (dm_y(j+1,1) - dm_y(j,k))/delt - a(k) * dm_y(j,k);    % last month NOT year (wraparound)
                end
            else
                summ = summ + (dm_y(j,k+1) - dm_y(j,k))/delt - a(k) * dm_y(j,k);        % normal case
            end
        end
        f(j) = summ / M;
        
    end
    
    
    
    if plt
        tiledlayout("flow");
        
        nexttile
        plot(a);
        
        nexttile
        plot(N);
        
        nexttile
        plot(f);
        
    end


end