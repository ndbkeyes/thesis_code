function avg_slope = avg_slope(obj,settings,slope_bounds)


    scheme_arr = settings{1};
    res_arr = settings{2};
    q = 2;
    
    lowerbound = slope_bounds{1};
    upperbound = slope_bounds{2};
    
    
    slope_sum = 0;
    
    % loop over interpolation settings
    for scheme=scheme_arr
        for res=res_arr
            
            % Read in data
            settings = {scheme, res, q};
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


            col = ones(length(t_arr), 1);
            t_arr_col = [col t_arr];

            % find avg-t and slope values
            t = mean(t_arr);
            beta = t_arr_col \ f_arr; % using backslash operator to get slope
            slope = beta(2);
            
            slope_sum = slope_sum + slope;

        end
    end
    
    
    avg_slope = slope_sum / (length(scheme_arr) * length(res_arr));

end