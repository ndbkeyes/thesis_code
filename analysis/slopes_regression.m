%% ===== DETECT SLOPE CHANGES ===== %%

function [t_matrix,w_matrix] = slopes_regression(interp_scheme,q,data_res,frac_data,result_folder,max_w,lowerbound,upperbound)

    hold on;

    % Read in data
    [t_arr,f_arr] = read_data(interp_scheme,data_res,q,frac_data,result_folder);
    t_arr = log10(t_arr);
    f_arr = log10(f_arr);
    
    
    
    
    % Cut down data to desired slope segment
    small = find(t_arr > lowerbound);
    starti = small(1);
    large = find(t_arr > upperbound);
    endi = large(1);
    t_arr = t_arr(starti:endi);
    f_arr = f_arr(starti:endi);
    
    % check that max window size isn't too large
    N = length(t_arr);
    if N/max_w < 2
        max_w = floor(N/2);
        fprintf("max w value too large; reduced to N=%d\n",N);
    end
    
    disp(N);
    
    % prep for loop
    last_dpw = 0;
    skip = 0;
    tiledlayout(4,5);
    t_matrix = {};
    w_matrix = {};        

    % loop over window sizes
    for w=max_w:-1:1     
        
        dpw = floor(N / w);  % data per window
        
        % loop over windows
        for i=1:floor(N/dpw)
                   
            % want to skip window numbers that give same number of data points per window
            if dpw == last_dpw || dpw == 1
                skip = 1;
                break
            else
                skip = 0;
            end

            % trim data to ith window
            startind = (i-1)*dpw+1;
            endind = min((i)*dpw, length(t_arr));        
            t_fit = t_arr(startind:endind);
            f_fit = f_arr(startind:endind);
            
            % add column of ones to t arr for regression
            col = ones(endind-startind+1, 1);
            t_fit_col = [col t_fit];
            
            fprintf("w=%d, i=%d; dpw=%d; startind=%d, endind=%d\n", w, i, dpw, startind, endind);
            
            % find avg-t and slope values
            t = mean(t_fit);
            beta = t_fit_col \ f_fit; % using backslash operator to get slope
            slope = beta(2);

            % append to this window size's array
            t_matrix{w,i} = t;
            w_matrix{w,i} = slope;

                        
        end    
        
        % if the data per window is different from prev run, plot!
        if skip == 0
            
            % plot the slopes for this window size
            x = cell2mat(t_matrix(w,:));
            y = cell2mat(w_matrix(w,:));

            nexttile
            % plotting the slopes
            color = [0 0 0];
            p = plot(x,y,"LineWidth", 0.1, "Color", color, "MarkerFaceColor", color);
            p.Marker = "*";
                   
            xlim([lowerbound*0.95, upperbound*1.05]);
            ylim([-0.5,2.5]);
            title(sprintf("w = %d",w));
            
        % if dpw same as prev window, reset skip vbl and update dpw
        else
            
            skip = 0;
            last_dpw = dpw;
            
        end
        
    end
   
end