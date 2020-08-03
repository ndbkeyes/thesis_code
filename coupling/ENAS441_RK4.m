function main

    %Clear the command window.
    clc;
    %Clear all previous variables.
    clear all;
    %Close all previously opened figures or images.
    close all;

    %Create figure for plotting
    fig = figure(1);
    hold on
    name = 'RK4';
    title(name);
        
    %Open an output file.
    filename = sprintf('pset01-5_output-%s.txt',name);
    OutputFile = fopen(filename,'w');
    
    %Print title to the screen and to the output file.
    fprintf('\n OUTPUT FROM pset01-5_code.m \n\n');
    fprintf(OutputFile, '\n OUTPUT FROM pset01-5_code.m \n\n');
    
    %Initialize some variables.
    t0 = 0.0;             %t value at which ODE integration will begin
    y0 = 1.0;            %y value at which ODE integration will begin
    tfinal = 1.0;        %t value at which ODE integration will end
    
    for happrox=[1/8 1/16 1/32 1/64 1/128 1/256 1/512]
        
        %Initialize step size and number of steps.
        N = floor ((tfinal-t0)/happrox + 0.1);  %Total number of steps to be taken
        h = (tfinal-t0)/N;    %Actual step size so that integration ends at tfinal
       
        %Print information about the method and the problem to the screen and to the output file.
        fprintf(' Using %s Method with h = %10.6f to integrate a first-order ODE IVP\n', name, h);
        fprintf(' from t = %10.6f to t = %10.6f with initial y value = %10.6f\n\n', t0, tfinal, y0);
        fprintf(OutputFile, ' Using %s Method with h = %10.6f to integrate a first-order ODE IVP\n', name, h);
        fprintf(OutputFile, ' from t = %10.6f to t = %10.6f with initial y value = %10.6f\n\n', t0, tfinal, y0);

        %Print the column headings for the results table.
        fprintf('%6s%20s%20s%20s%20s\n', 'i', 't', 'w', 'y', 'GTE_i');
        fprintf(OutputFile, '%6s%20s%20s%20s%20s\n', 'i', 't', 'w', 'y', 'GTE_i');

        %Print a horizontal line below the column headings.
        fprintf('%s\n','----------------------------------------------------------------------------------------------');
        fprintf(OutputFile, '%s\n','----------------------------------------------------------------------------------------------');

        %Prepare for the main loop.
        i = 0;
        told = t0;
        wold = y0;
        yactual = y0;
        GTE = 0;
        maxabsGTE = 0.d0;
        tmaxabsGTE = told;

        %Print the information for i=0.
        fprintf(' %5d             %10.6f          %+1.4e          %+1.4e\n', i, told, wold, yactual);
        fprintf(OutputFile, ' %5d             %10.6f          %+1.4e          %+1.4e\n', i, told, wold, yactual);

        %Create arrays for plotting purposes
        ti = double.empty(0,N);
        wi = double.empty(0,N);

        %Main loop
        for i = 0:N-1
            tnew = told + h;
            fold = f(told,wold);

            if strcmp(name, 'Euler')
                %Use Euler's Method formula to calculate wnew
                wnew = wold+h*fold;
            elseif strcmp(name, 'Midpoint')
                %Use Midpoint Method formula to calculate wnew
                k2 = f(told + h/2, wold + h/2*fold);
                wnew = wold + h*k2;
            elseif strcmp(name, 'RK4')
                %Use RK4 Method formula to calculate wnew
                k1 = f(told, wold);
                k2 = f(told + h/2, wold + h/2*k1);
                k3 = f(told + h/2, wold + h/2*k2);     
                k4 = f(told + h, wold + h*k3);
                wnew = wold + h/6*(k1 + 2*k2 + 2*k3 + k4);
            else
                fprintf('INVALID METHOD NAME');
            end
            
            
            %Calculate the analytical soln at tnew
            yactual = y(tnew);

            %Accumulate |GTE|_max and the t value at which it occurs.
            GTE = yactual - wnew;
            if abs(GTE) > maxabsGTE
                maxabsGTE = abs(GTE);
                tmaxabsGTE = tnew;
            end

            %Print one row of the results table.
            fprintf(' %5d             %10.6f          %+1.4e          %+1.4e          %+1.4e\n', i+1, tnew, wnew, yactual, GTE);
            fprintf(OutputFile, ' %5d             %10.6f          %+1.4e          %+1.4e          %+1.4e\n', i+1, tnew, wnew, yactual, GTE);

            %Store values in arrays for plotting
            ti(i+1) = tnew;
            wi(i+1) = wnew;

            %Prepare for the next time through the loop.
            told = tnew;
            wold = wnew;

        end

        %Print another horizontal line.
        fprintf('%s\n','----------------------------------------------------------------------------------------------');
        fprintf(OutputFile, '%s\n','----------------------------------------------------------------------------------------------');

        %Print a conclusion statement.
        fprintf(' End of integration interval reached after %5d steps.\n |GTE|max = %1.4e at t = %10.6f\n\n',N, maxabsGTE, tmaxabsGTE);
        fprintf(OutputFile, ' End of integration interval reached after %5d steps.\n |GTE|max = %1.4e at t = %10.6f\n\n',N, maxabsGTE, tmaxabsGTE);
        
        %Plot ti and wi
        figure(fig);
        plot(ti,wi);
        
    end
    
    %Close the output file.
    fclose(OutputFile);
    
    plot(ti,arrayfun(@y,ti));
    title(name);
    xlabel('t');
    ylabel('y and w');
    legend('h=1/8','h=1/16','h=1/32','h=1/64','h=1/128','h=1/256','h=1/512','y(t)')
    saveas(fig,sprintf('pset01-5_plot-%s.png',name));
    
end


function answer = f(t,y)

answer = -y + t + 1;

return
end


function answer = y(t)

answer = t + exp(-t);

return
end
