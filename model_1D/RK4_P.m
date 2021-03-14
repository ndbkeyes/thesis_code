function P = RK4_P(Y,M,G,H,delt)
%
% FUNCTION: RK4_P(Y,M,G,H,delt)
%
% PURPOSE: RK4 algorithm to numerically integrate and find P(m)
%
% INPUT:
% - Y: number of years of data
% - M: number of months of data
% - G, H: derived quantities from findanf code
% - delt: length of "month"
%
% OUTPUT:
% - ti, wi: x,y coordinates of approximation of P(m)
%


    
   
%% setup printing and plotting

    %{
    close all;
    
    % create figure for plotting
    fig = figure(1);
    hold on;
    title('RK4');
    
    print information about the method and the problem to the screen and to the output file
    fprintf('Using RK4 Method to integrate a first-order ODE IVP\n');
    fprintf('%6s%20s\n', 'm', 'P');
    fprintf('-----------------------------------------\n');
    fprintf(' %5d             %+1.4e\n', m, pold);
    %}
      
    
%% setup for loop

    % create arrays for plotting purposes
    t_arr = double.empty(0,M*Y-1);
    P = double.empty(0,M*Y-1);
    
    pold = 1.0;
    

%% main loop


    % loop over months, since the months are the time domain in question for P(m)
    % run far into the future since P is periodic!
    for m=1:200*M
        
        % find the current & subsequent month indices
        m_mod = mod_1n(m,M);
        mp1_mod = mod_1n(m+1,M);
        
        % find pnew via k1, k2, k3, k4
        k1 = -G(m_mod) * pold + H(m_mod);
        k2 = -1/2 * ( G(m_mod) + G(mp1_mod) ) * (pold + 1/2*delt*k1) + 1/2 * ( H(m_mod) + H(mp1_mod) );
        k3 = -1/2 * ( G(m_mod) + G(mp1_mod) ) * (pold + 1/2*delt*k2) + 1/2 * ( H(m_mod) + H(mp1_mod) );
        k4 = -G(mp1_mod) * (pold + delt*k3) + H(mp1_mod);
        pnew = pold + delt/6 * (k1 + 2*k2 + 2*k3 + k4);

        % print one row of the results table
        % fprintf(' %5d             %+1.4e\n', m, pnew);
          
        % store values in arrays for plotting
        t_arr(m) = m;
        P(m) = pnew;

        % prepare for the next time through the loop
        pold = pnew;

    end

    
    
%% print and plot

    %{
    % print conclusion
    fprintf('-----------------------------------------\n');
    fprintf('End of integration interval reached after %5d steps.\n',M*100-1);
    
    % plot P
    figure(fig);
    plot(t_arr,P);
    title('RK4');
    xlabel('t');
    ylabel('P');
    saveas(fig,'RK4_plot.fig');
    %}
    
    
end