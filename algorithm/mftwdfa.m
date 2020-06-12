function [t_arr,f_arr] = mftwdfa(X,Y,mftwdfa_settings,filepath_out)
%
% FUNCTION: mftwdfa(X,Y,settings,filepath_out)
%
% PURPOSE: run MFTWDFA algorithm on given dataset with given settings
%
% INPUT:
% - X: independent-variable (time) series of the climate dataset
% - Y: dependent-variable (climate quantity) series of the climate dataset
% - mftwdfa_settings: array of settings for the MFTWDFA run desired -- cell array in form {interp_scheme, data_res, q}
% - filepath_out: FULL filepath (folder and filename) of textfile to write MFTWDFA results to
%                 (generate beforehand with mftwdfa_filepath.m)
% 
% OUTPUT:
% - t_arr: array of timescale values generated
% - f_arr: array of the fluctuation function values calculated
% also, generates text file at filepath_out containing [t_arr, f_arr]
% 
 



    % ----- SETTINGS ----- %
    
    % unpack settings from array
    interp_scheme = mftwdfa_settings{1};
    data_res = mftwdfa_settings{2};
    q = mftwdfa_settings{3};
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

        % Create weighted fit of interpolated dataset
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