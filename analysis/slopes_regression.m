%% ===== DETECT SLOPE CHANGES ===== %%

function one_slope = slopes_regression(interp_scheme,q,data_res,frac_data,result_folder,max_e,lowerbound,upperbound)

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
    
    range = upperbound - lowerbound;
    
    % prep for loop
    layout = tiledlayout(4,1);
    layout.Units = 'inches';
    layout.OuterPosition = [0.25 0.25 3 7];
    
    t_matrix = {};
    w_matrix = {};    
    skip = 0;

    % loop over window sizes (exponentially)
    for e=0:1:max_e
        
        num_windows = 2^e;
        window_size = range / num_windows;
        
        % loop over window indices
        for i=1:2^e
            
            % trim data to i-th window
            inds = find(t_arr >= (min(t_arr)+(i-1)*window_size) & t_arr < (min(t_arr)+i*window_size) );
            t_fit = t_arr(inds);
            f_fit = f_arr(inds);
            
            % check if window doesn't have enough data
            if length(t_fit) < 2
                skip = 1;
                break;
            end

            % add column of ones to t_arr for regression
            col = ones(length(t_fit), 1);
            t_fit_col = [col t_fit];
            
            % find avg-t and slope values
            t = (lowerbound+(i-1)*window_size) + window_size/2;
            beta = t_fit_col \ f_fit; % using backslash operator to get slope
            slope = beta(2);
            
            % append to this window size's array
            t_matrix{e+1,i} = t;
            w_matrix{e+1,i} = slope;
                        
        end
        
        % if windows have become too small, stop
        if skip == 1
            break;
        end
            
        % plot the slopes for this window size
        x = cell2mat(t_matrix(e+1,:));
        y = cell2mat(w_matrix(e+1,:));

        % plotting the slopes
        nexttile
        color = [0 0 0];
        p = plot(x,y,"LineWidth", 0.1, "Color", color, "MarkerFaceColor", color);

        p.Marker = "*";
        xlim([lowerbound-0.05, upperbound+0.05]);
        ylim([-0.5,2.5]);
        title(sprintf("%d windows",num_windows));
        
        
        if e==0 && i==1
            fprintf("w=1 - %s %d , %.2f-%.2f: %.3f\n", interp_scheme, data_res, lowerbound, upperbound, y(1));
            one_slope = y(1);
        end
        
    end
    
    
    saveas(gca, sprintf("%sslopes_%.2f-%.2f_%s%d.png",result_folder,lowerbound,upperbound,interp_scheme,data_res));
    saveas(gca, sprintf("%sslopes_%.2f-%.2f_%s%d.fig",result_folder,lowerbound,upperbound,interp_scheme,data_res));
   
end