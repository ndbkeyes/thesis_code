function avg_slope = slope_analysis(obj,settings,exp,bounds)
% 
% FUNCTION: slope_analysis(obj.data_name,obj.folder_out,settings,max_e,lowerbound,upperbound)
%
% PURPOSE: estimate slope of fluctuation function at decreasing fineness of scale / increasing window sizes
%
% INPUT:
% - obj: DataSet object to get data and info from
% - settings: array of MFTWDFA settings for which to analyze slopes -- cell array in form {interp_scheme, data_res, q}
% - exp: controls maximum # of windows -- 2^exp windows. 
%        can be a single number, in which case the number of windows goes from 2^0 to 2^exp
%     or can be a cell array of minimum and maximum exp values
% - side: whether we're doing LHS, RHS, or FULL sections of slope
%
% OUTPUT:
% - hurst: one-window slope of Fq span -- est. Hurst exp if segment has ~constant slope over >= 1 order of mag.
% also generates grid of plots of slopes over varying numbers of windows
%

    
    
    
    % unpack settings and bounds from input arrays
    scheme_arr = settings{1};
    res_arr = settings{2};
    q_arr = settings{3};
    
    
    % set the bounds
    lowerbound = bounds{1};
    upperbound = bounds{2};
    
    
    % check on the format of exp argument
    if length(exp) == 1
        min_exp = 0;
        max_exp = exp;
        
    elseif length(exp) > 1
        min_exp = exp{1};
        max_exp = exp{2};
        
    end
    
    
    
    avg_slope = 0;
    
    for interp_scheme = scheme_arr
        for data_res = res_arr
            for q = q_arr
                
                % figure settings
                close all;
                hold on;

                % Read in data
                settings = {interp_scheme, data_res, q};
                [t_arr,f_arr] = read_data(obj,settings);
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
                nplot = 0;
                if length(exp) == 1
                    nplot = exp + 1;
                elseif length(exp) > 1
                    nplot = exp{2} - exp{1} + 1;
                end
                layout = tiledlayout(nplot,1);
    
    
                skip = 0;

                t_matrix = {};
                w_matrix = {};    

                % loop over window sizes (exponentially)
                for e=min_exp:1:max_exp

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
                        avg_slope = avg_slope + hurst;
                        % title(ax, sprintf("%s - %s %d\n (slope of F_2(t), log t = %.2f - %.2f)\n\n1 window",obj.data_name,interp_scheme,data_res,lowerbound,upperbound));
                    end

                end

                % save slope figure
                
                set(gcf, 'Position',  [0, 0, 300, 150*nplot]);
                
                fig_filename = sprintf("%s%s_Slopes_%s-%d-%d_%.2f-%.2f.fig",obj.folder_out,obj.data_name,interp_scheme,data_res,q,lowerbound,upperbound);
                saveas(gcf, fig_filename);
                
%                 writeup_figs_folder = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\write-up\figures\";
%                 png_filename = sprintf("%s%s_Slopes_%s-%d-%d_%.2f-%.2f.png",writeup_figs_folder,obj.data_name,interp_scheme,data_res,q,lowerbound,upperbound);                
%                 saveas(gcf, png_filename);
        
            end
        end
    end
    
    
    num = length(scheme_arr) * length(res_arr);
    avg_slope = avg_slope / num;
   
end