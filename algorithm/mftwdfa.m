function [t_arr,f_arr] = mftwdfa(X,Y,settings,filepath_out)

    % ----- SETTINGS ----- %
    
    % unpack settings from array
    interp_scheme = settings{1};
    data_res = settings{2};
    q = settings{3};
    % hardcoded - number of s values to run with, fraction of data to include
    s_res = 100;
    frac_data = 1;

    if data_res ~= 0
        N = data_res + 1;
    else
        N = length(X);
    end

    
   
    % ----- INTERPOLATE & PROFILE ----- %

    % Create arrays of interpolated data
    [X_interp,Y_interp] = interpolate(X,Y,data_res,interp_scheme);
    
    % Trim data after interpolation
    if data_res ~= 0
        N = ceil( N * frac_data );      % decrease N to just go up to fraction of data desired
    end
   
    X_interp = X_interp(1:N);
    Y_interp = Y_interp(1:N);
    
    % Make profile (cumulative sum of interpolated data)
    P_interp = prof(Y_interp);



    
    
    % ----- CALCULATE DERIVED SETTING VALUES ----- %
    
   
    % get derived quantities from above
    range = max(X_interp) - min(X_interp);
    if data_res ~= 0
        t_step = range / data_res;   % years step between interpolated points
    else
        t_step = 1/12;
    end

    % beginning and end s values - calculate based on time gap sizeand range
    tmin = t_step * 2;
    tmax = range / 2;
    smin = tmin / t_step;
    smax = tmax / t_step;

    % make array of s values to use
    s_values = unique(floor(logspace(log10(smin),log10(smax),s_res)));
    
    
    
    
    % ----- FLUCTUATION FUNCTION ----- %

    % Setup
    t_arr = zeros(length(s_values),1);
    f_arr = zeros(length(s_values),1);


    % Loop through values of s
    i = 1;
    for s=s_values

        % Print loop info
        lineLength = fprintf("%d / %d\n", i,length(s_values));

        % Create profile of interpolated dataset
        P_fit = wfit(X_interp,P_interp,s);

        f = 0;
        Ns = floor(N / s);

        % Sum var^(q/2) up & down profile
        for nu=1:2*Ns
            term = varsum(nu,s,N,P_interp,P_fit);
            f = f + ( term )^(q/2);      
        end

        % Normalize sum, raise to 1/q
        f = 1/(2*Ns) * f;
        f = f^(1/q);

        % Append t and f values to arrays
        t_arr(i) = s * t_step;
        f_arr(i) = f;
        
        % Increment loop & clear print statement
        i = i + 1;
        fprintf(repmat('\b',1,lineLength));

    end


    
    
    
    % ----- WRITE DATA TO FILE ----- %

    % Write columns of data to file
    data = [t_arr, f_arr];
    writematrix(data, filepath_out); 
 
    

end