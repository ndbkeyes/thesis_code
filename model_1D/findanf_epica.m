function anf = findanf_epica(obj,Y,M,varargin)
% 
% FUNCTION: findanf_epica(obj)
%
% PURPOSE: extracts stochastic model parameters a, N, f, P from data using
% more complicated method with P(k) generated by RK4
%
% INPUT: 
% - obj - DataSet object containing the data to be analyzed
% - Y: number of years to divide dataset into
% - M: number of months to divide each year into
% - m: offset in "years" for autocorrelation of f
% - plotting: whether (1) or not (0) to make plots of the quantities
%
% OUTPUT:
% - a: array of monthly stability parameters over 1 year
% - N: array of noise amplitudes
% - f: array of slow forcing values
% - P_final: converged periodic parameter used to find a for 1 year
%




    %% parse inputs
    
    p = inputParser;
    
    addRequired(p,'obj');
    addRequired(p,'Y');
    addRequired(p,'M');
    
    addOptional(p,'mm',2);
    addOptional(p,'plt',0);
    addOptional(p,'br_win',0);
    addOptional(p,'est',0);
    
    parse(p,obj,Y,M,varargin{:});
    opt = p.Results;

    
    
    %% convert raw data to (year,month) averaged matrix   
    
    [~,data,delt] = data2matrix(obj,Y,M,opt.br_win);
    
    
    
    %%% ----------------------------- %%%
    %%% - FIND DATA STAT QUANTITIES - %%%
    %%% ----------------------------- %%%
    

    %% find S(k) = variance of month k data (over all years)
    
    S = zeros(1,M);
    for k=1:M
        summ = 0;
        for j=1:Y
            summ = summ + data(j,k) * data(j,k);
        end
        S(k) = summ / (Y-1);
    end



    %% find A(k) = inter-monthly autocorrelation of months m & m+1 (over all years)
    
    A = zeros(1,M);
    for k=1:M
        summ = 0;
        for j=1:Y-1
            if k == M   % loop around from last month to first month
                summ = summ + data(j,k) * data(j+1,1);
            else        % normal inter-month corr, m & m+1
                summ = summ + data(j,k) * data(j,k+1);
            end
        end
        A(k) = summ / ((Y-1)-1);
    end
   

    
    
    
    %%% -------------------------- %%%
    %%% - FULL FINDANF ALGORITHM - %%%
    %%% -------------------------- %%%
    
    if opt.est == 0
        

        %% find B(k) = inter-year autocorrelation of month k (between years j and j+m)
    
        B = zeros(1,M);    
        if opt.mm >= Y-1
            disp("ERROR - m must be < Y-1");
        end

        for k=1:M
            summ = 0;
            for j=1:Y-opt.mm+1
                summ = summ + data(j,k) * data(j+opt.mm-1,k);
            end
            B(k) = summ / (Y-opt.mm-1);
        end


        %% find derived quantities G(k) and H(k)

        G = zeros(1,M);
        H = zeros(1,M);
        for k=1:M	% has to be M-1 since A(m) has max m=M-1
            G(k) = 1/delt * (S(k) - A(k)) / S(k);
            H(k) = (S(k) - B(k)) / S(k);
        end
        
        
        %% use RK4 to solve for P(k) - using altered ENAS 441 code!
        P = RK4_P(Y,M,G,H,delt); 
        P_final = P(M*999:M*1000-1);


        %% find a(k) = sector stability, using P, G, H
        
        a = zeros(1,length(P_final));
        for k=1:M
            a(k) = 1/P_final(k) * (-G(k)*P_final(k) + H(k) - 1.0);
        end



        %% find N(k) = noise amplitude

        % compute y(t)
        y = zeros(Y,M);
        for k=1:M
            for j=1:Y
                if k == M
                % last month & last year
                    if j == Y
                        y(j,k) = - a(k) * data(j,k) * delt;
                % last month ONLY (wraparound)
                    else
                        y(j,k) = data(j+1,1) - data(j,k) - a(k) * data(j,k) * delt;
                    end
                % normal case
                else
                    y(j,k) = data(j,k+1) - data(j,k) - a(k) * data(j,k) * delt;
                end
            end
        end

        % then, find y's variance & intermonth autocorr over years
        y_var = zeros(1,M);
        y_atc = zeros(1,M);
        for k=1:M
            summ_var = 0;
            summ_atc = 0;
            for j=1:Y
                
                % add term to variance
                summ_var = summ_var + y(j,k)^2;
                
                % add term to autocorrelation
                
                if k == M     
                % last month & last year
                    if j == Y
                        summ_atc = summ_atc + y(j,k)^2;
                % last month ONLY (wraparound)
                    else
                        summ_atc = summ_atc + y(j,k) * y(j+1,1);
                    end
                % normal case
                else            
                    summ_atc = summ_atc + y(j,k) * y(j,k+1);
                end
                
            end
            y_var(k) = summ_var / (Y-1);
            y_atc(k) = summ_atc / (Y-1);
        end


        % use y's variance and autocorrelation to estimate noise amplitude
        N = zeros(1,M);
        for k=1:M
            Nsq = (y_var(k) - y_atc(k)) / delt;
            if Nsq < 0
                N(k) = 0.0;
            else
                N(k) = sqrt(Nsq);
            end
        end

        
%         %% JSW VERSION OF N
%         
%         N = zeros(1,M);
%         for k=1:M
%             if k == M
%                 N(k) = (S(1)-A(k))/delt + P(1)/P(k)*(S(k)-A(k))/delt;
%                 N(k) = N(k) - a(k)*A(k) + P(1)/P(k)*a(k)*S(k);
%                 if N(k) < 0
%                     N(k) = 0.0;
%                 else
%                     N(k) = sqrt(N(k));
%                 end
%             else
%                 N(k) = (S(k+1)-A(k))/delt + P(k+1)/P(k)*(S(k)-A(k))/delt;
%                 N(k) = N(k) - a(k)*A(k) + P(k+1)/P(k)*a(k)*S(k);
%                 if N(k) < 0
%                     N(k) = 0.0;
%                 else
%                     N(k) = sqrt(N(k));
%                 end
%             end
%         end



        %% find f(tau) = long-term backbone
        
        f = zeros(1,Y);
        for j=1:Y
            summ = 0;
            for k=1:M
                if k == M
                    summ = summ + (data(j,k) - data(j,k-1))/delt - a(k) * data(j,k);
                else
                    summ = summ + (data(j,k+1) - data(j,k))/delt - a(k) * data(j,k);
                end
            end
            f(j) = summ / M;
        end
        
    
        if opt.br_win ~= 0
            f = zeros(1,Y);
        end
        
        
        
        % smooth and package returned coefficients
        a = smooth_periodic(a,M/2);
        N = smooth_periodic(N,M/2);
        anf = {a;N;f};
        
        
        %%% plot all quantities if requested
        
        %% intermediate quantities
        if opt.plt == 2
            
            close all;
            disp("PLOTTING");
            tiledlayout("flow");

            %% A, S, B
            nexttile
            hold on;
            plot(A);
            plot(S);
            plot(B);
            legend("A(k)","S(k)","B(k)");
            xlabel("months");
            title(sprintf("A, S, B for %s, Y=%d M=%d\n",obj.data_name,Y,M));
            saveas(gcf,sprintf("%s_ASB_%d-%d.jpeg",obj.data_name,Y,M));

            %% H
            nexttile
            plot(H);
            legend("H(k)");
            xlabel("months");
            title(sprintf("H for %s, Y=%d M=%d\n",obj.data_name,Y,M));
            saveas(gcf,sprintf("%s_H_%d-%d.jpeg",obj.data_name,Y,M));

            %% G, H
            nexttile
            hold on;
            plot(G);
            plot(H);
            legend("G(k)","H(k)");
            xlabel("months");
            title(sprintf("G, H for %s, Y=%d M=%d\n",obj.data_name,Y,M));
            saveas(gcf,sprintf("%s_GH_%d-%d.jpeg",obj.data_name,Y,M));

            %% P
            nexttile
            plot(P(1:min(10000,length(P))));
            legend("P");
            title(sprintf("P for %s, Y=%d M=%d\n",obj.data_name,Y,M));
            saveas(gcf,sprintf("%s_P_%d-%d.jpeg",obj.data_name,Y,M));

            %% P_final
            nexttile
            plot(P_final);
            legend("P_{final}");
            title(sprintf("P_{final} for %s, Y=%d M=%d\n",obj.data_name,Y,M));
            saveas(gcf,sprintf("%s_P-final_%d-%d.jpeg",obj.data_name,Y,M));



        %% final parameters
        elseif opt.plt == 1
            
            tiledlayout("flow");
            
            %% a
            nexttile
            plot(a);
            %legend("a(k)");
            title(sprintf("a(k) - %s, 1D model\n",obj.data_name));
            saveas(gcf,sprintf("%s_a_%d-%d.jpeg",obj.data_name,Y,M));
            
            %% N
            nexttile
            plot(N);
            %legend("N(k)");
            title(sprintf("N(k) - %s, 1D model\n",obj.data_name));
            saveas(gcf,sprintf("%s_N_%d-%d.jpeg",obj.data_name,Y,M));

            %% f
            nexttile
            plot(f);
            %legend("f(tau)");
            title(sprintf("f(tau) - %s, 1D model\n",obj.data_name));
            saveas(gcf,sprintf("%s_f_%d-%d.jpeg",obj.data_name,Y,M));

            
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    % ---------------------------- %
    % - SIMPLER WOOSOK ALGORITHM - %
    % ---------------------------- %  
    
    elseif opt.est == 1
        
        
        
        %% estimate a(k) by finding G(k)
    
        G = zeros(1,M);
        for k=1:M
            G(k) = 1/delt * (S(k) - A(k)) / S(k);
        end

        a_est = -G;    

        
        %% estimate N(k) from y(k)

        % compute y(t)
        y = zeros(Y-1,M);
        for k=1:M
            for j=1:Y-1
                if k == M
                    y(j,k) = data(j+1,1) - data(j,k) - a_est(k) * data(j,k) * delt;
                else
                    y(j,k) = data(j,k+1) - data(j,k) - a_est(k) * data(j,k) * delt;
                end
            end
        end

        
        % find y's variance
        y_var = zeros(1,M);
        for k=1:M
            summ = 0;
            for j=1:Y-1
                summ = summ + y(j,k)^2;
            end
            y_var(k) = summ / ((Y-1)-1);
        end

        
        % estimate N(k) from y(k)
        N_est = zeros(1,M);
        for k=1:M
            N_est(k) = sqrt(y_var(k) / delt);
        end

        
        
        %% set return values
        
        a = a_est;
        N = N_est;
        f = zeros(1,Y);
        
        % smooth and package returned coefficients
        a = smooth_periodic(a,M/2);
        N = smooth_periodic(N,M/2);
        anf = {a;N;f};
        
       
        

        
        %% plot all quantities if requested
        
        if opt.plt == 2
            
            tiledlayout("flow");

            %% A, S
            nexttile
            hold on;
            plot(A);
            plot(S);
            legend("A(k)","S(k)");
            xlabel("months");
            title(sprintf("A, S, for %s, Y=%d M=%d (est)\n",obj.data_name,Y,M));
            saveas(gcf,sprintf("%s_AS_%d-%d_est.jpeg",obj.data_name,Y,M));

            %% G, H
            nexttile
            hold on;
            plot(G);
            legend("G(k)");
            xlabel("months");
            title(sprintf("G for %s, Y=%d M=%d (est)\n",obj.data_name,Y,M));
            saveas(gcf,sprintf("%s_GH_%d-%d_est.jpeg",obj.data_name,Y,M));

                       
            
        elseif opt.plt == 1
            
            tiledlayout("flow");
            
            nexttile
            plot(a);
            legend("a(k)");
            title(sprintf("a(k) - %s, 1D model\n",obj.data_name));
            saveas(gcf,sprintf("%s_a_%d-%d_est.jpeg",obj.data_name,Y,M));
            if M > 1
                xlim([1,M]);
            end
            
            nexttile
            plot(N);
            legend("N(k)");
            title(sprintf("N(k) - %s, 1D model\n",obj.data_name));
            saveas(gcf,sprintf("%s_N_%d-%d_est.jpeg",obj.data_name,Y,M));
            if M > 1
                xlim([1,M]);
            end
            
            nexttile
            plot(f);
            legend("f(k)");
            title(sprintf("f(k) - %s, 1D model\n",obj.data_name));
            saveas(gcf,sprintf("%s_f_%d-%d_est.jpeg",obj.data_name,Y,M));
            if Y > 1
                xlim([1,Y]);
            end
            
        end
        

        
        
        
        
    else
        
        disp("ERROR - invalid algorithm argument");
        
    end
    
    
    
    
end
