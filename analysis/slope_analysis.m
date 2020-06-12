function hurst = slope_analysis(folder_out,data_name,settings,max_e,bounds)
% 
% FUNCTION: slope_analysis(data_name,folder_out,settings,max_e,lowerbound,upperbound)
%
% PURPOSE: estimate slope of fluctuation function at decreasing fineness of scale / increasing window sizes
%
% INPUT:
% - data_name: nametag of the series being analyzed
% - folder_out: folder in which MFTWDFA data is located
% - settings: array of MFTWDFA settings for which to analyze slopes -- cell array in form {interp_scheme, data_res, q}
% - max_e: controls maximum # of windows -- 2^max_e windows
% - bounds: cell array of the lower and upper bounds on the timescale for slope calculation
%
% OUTPUT:
% - hurst: one-window slope of Fq span -- est. Hurst exp if segment has ~constant slope over >= 1 order of mag.
% also generates grid of plots of slopes over varying numbers of windows
%

    close all;
    hold on;
    
    interp_scheme = settings{1};
    data_res = settings{2};
    q = settings{3};
    
    lowerbound = bounds{1};
    upperbound = bounds{2};

    % Read in data
    [t_arr,f_arr] = read_data(folder_out,data_name,settings);
    t_arr = log10(t_arr);
    f_arr = log10(f_arr);
    
    % Cut down data to desired slope segment
    small = find(t_arr > lowerbound);
    large = find(t_arr > upperbound);
    if isempty(small)
        starti = 1;
    else
        starti = small(1);
    end
    
    if isempty(large)
        endi = length(t_arr);
    else
        endi = large(1);
    end
    t_arr = t_arr(starti:endi);
    f_arr = f_arr(starti:endi);
        
    range = upperbound - lowerbound;
    
    
    
    % prep for loop
    tiledlayout(max_e+1,1);
    skip = 0;
    
    t_matrix = {};
    w_matrix = {};    

    % loop over window sizes (exponentially)
    for e=0:1:max_e
        
        num_windows = 2^e;
        window_size = range / num_windows;
        
        % loop over window indices
        for i=1:2^e
            
            % trim data to i-th window, or region around such with enough data
            inds = [];
            wf = 0;
            while isempty(inds) && wf <= 4
                inds = find(t_arr >= (min(t_arr)+( i-1 - wf*0.25)*window_size) & t_arr < (min(t_arr) + (i+wf*0.25)*window_size) );
                wf = wf + 1;
            end
            if ~isempty(inds)
                min_ind = min(inds);
                max_ind = max(inds);
                t_fit = t_arr(inds);
                f_fit = f_arr(inds);
            else
                skip = 1;
            end
            
            % check if window doesn't have enough data
            if length(t_fit) < 2
                first_ind = max(min_ind-2,1);
                last_ind = min(max_ind+2,length(t_arr));
                t_fit = t_arr(first_ind:last_ind);
                f_fit = f_arr(first_ind:last_ind);
            end

            % add column of ones to t_arr for regression
            col = ones(length(t_fit), 1);
            t_fit_col = [col t_fit];
            
            % find avg-t and slope values
            t = mean(t_fit);
            beta = t_fit_col \ f_fit; % using backslash operator to get slope
            slope = beta(2);
            
            
            if skip
                slope = NaN;
            end
            
            % append to this window size's array
            t_matrix{e+1,i} = t;
            w_matrix{e+1,i} = slope;
            
               
                        
        end
            
        % plot the slopes for this window size
        x = cell2mat(t_matrix(e+1,:));
        y = cell2mat(w_matrix(e+1,:));

        % plotting the slopes
        ax = nexttile;
               
        scatter(x,y,10,"black","filled");
        xlim([lowerbound-0.05, upperbound+0.05]);
        ylim([-0.5,2.5]);
        title(sprintf("%d windows",num_windows));

        % save the one-window average slope value as overall Hurst exponent
        if e==0 && i==1
            fprintf("w=1 - %s %d , %.2f-%.2f: %.3f\n", interp_scheme, data_res, lowerbound, upperbound, y(1));
            hurst = y(1);
            title(ax, sprintf("%s - %s %d\n (slope of F_2(t), log t = %.2f - %.2f)\n\n1 window",data_name,interp_scheme,data_res,lowerbound,upperbound));
        end
        
    end
    
    % save slope figure
    fig_filename = sprintf("%s%s_Slopes_%s-%d-%d_%.2f-%.2f.fig",folder_out,data_name,interp_scheme,data_res,q,lowerbound,upperbound);
    saveas(gcf, fig_filename);
   
end