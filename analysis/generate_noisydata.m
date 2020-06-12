function generate_noisydata(settings,folder_out,makeplot)
% 
% FUNCTION: generate_noisydata(settings,folder_out,makeplot)
% 
% PURPOSE: generate a random-walk time series with given parameters
%
% INPUT:
% - settings: array of settings for the time series -- cell array in form {series_type, threshold, walk length}
%        (series_type options: "trippedwalk", "randomwalk", "whitenoise")
% - folder_out: folder location to output data file to
% - makeplot: if true, display plot of time series -- OPTIONAL, default = false
%
% OUTPUT: none, just creates series and writes to file, displaying plot if asked
% 

    series_type = settings{1};
    threshold = settings{2};
    N = settings{3};

    close all;
    hold on;
    
    if nargin == 2
        makeplot = 0;
    end

    % construct data name from parameters
    data_name = sprintf("%s-%d-%d",series_type,threshold,N);


    % setup for loop
    x = 0;
    x_arr = zeros(N,1);
    n_arr = zeros(N,1);

    stdev_noise = 1;                    % < theta^2 >
    noise = stdev_noise * randn(N,1);   % theta

    stdev_threshold = .1 * threshold;   % r


    % generate random-noise time series
    for n=1:N
        if strcmp(series_type,"trippedwalk")
            x = x + noise(n);
            threshold_value = threshold + stdev_threshold*randn(1,1);   % xi = xi_bar + r
            if x < 0 || x > threshold_value
                x = 0.5*randn(1,1)+1;
            end
        elseif strcmp(series_type,"randomwalk")
            x = x + noise(n);
        elseif strcmp(series_type,"whitenoise")
            x = noise(n);
        end
        n_arr(n) = n;
        x_arr(n) = x;
    end
    
    
    timescale = threshold^2 / stdev_noise^2;
    fprintf("instability timescale = %.2f --> log10(timescale) = %.2f\n",timescale,log10(timescale));


    % write data to file
    filepath_in = strcat(folder_out,data_name,"_data.txt");
    data_in = [n_arr, x_arr];
    writematrix(data_in, filepath_in);
    
    
    if makeplot

        % read data out
        A = readtable(filepath_in);
        A = A(1:end,:);
        Xvarname = 'Var1';
        Yvarname = 'Var2';
        X = cell2mat(table2cell(A(:,{Xvarname})));
        Y = cell2mat(table2cell(A(:,{Yvarname})));

        time_scale = threshold^2 ./ stdev_noise^2;
        fprintf("timescale: %d\n", time_scale);

        % plot series
        plot(X,Y);
        
    end


end

