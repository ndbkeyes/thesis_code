function wi = RK4_P(Y,M,G,H)

    close all;

    % create figure for plotting
    fig = figure(1);
    hold on
    title('RK4');

    % print title to the screen and to the output file.
    fprintf('\n OUTPUT FROM pset01-5_code.m \n\n');
    
    % initialize some variables.
    t0 = 0;            % t value to begin integration
    y0 = 0.0;            % y value to begin integration
    tfinal = Y*M;        % t value to end integration
    
    % initialize step size and number of steps
    h = 5;
    steps = floor(tfinal / h);
        
    % print information about the method and the problem to the screen and to the output file
    fprintf('Using RK4 Method with h = %10.6f to integrate a first-order ODE IVP\n', h);
    fprintf('from t = %10.6f to t = %10.6f with initial y value = %10.6f\n\n', t0, tfinal, y0);
    fprintf('%6s%20s%20s\n', 'i', 't', 'w');
    fprintf('----------------------------------------------------------------------------------------------\n');
      
    % prepare for the main loop
    i = 0;
    told = t0;
    wold = y0;
    fprintf('%5d             %10.6f          %+1.4e\n', i, told, wold);

    % create arrays for plotting purposes
    ti = double.empty(0,steps);
    wi = double.empty(0,steps);
    
    
    % define ODE RHS function
    function a = f(k,p,G,H)
        a = -G(k) * p + H(k);
    end

    % main loop
    for i=1:Y-1
       
        % WRONG i - i is step btwn proximate data pts in loop, but in f
        % argument needs to be monht index !!
        
        % use RK4 Method formula to calculate wnew
        k1 = f(i, wold, G, H);
        k2 = f(i, wold + h/2*k1, G, H);
        k3 = f(i, wold + h/2*k2, G, H);     
        k4 = f(i, wold + h*k3, G, H);
        wnew = wold + h/6*(k1 + 2*k2 + 2*k3 + k4);

        % print one row of the results table
        fprintf(' %5d             %10.6f          %+1.4e\n', i, i, wnew);
          
        % store values in arrays for plotting
        ti(i) = i;
        wi(i) = wnew;

        % prepare for the next time through the loop
        wold = wnew;

    end

    % print conclusion
    fprintf('%s\n','----------------------------------------------------------------------------------------------');
    fprintf('End of integration interval reached after %5d steps.\n',Y);
    
    % plot ti and wi
    figure(fig);
    plot(ti,wi);
    title('RK4');
    xlabel('t');
    ylabel('w');
    saveas(fig,'RK4_plot.fig');
    
end