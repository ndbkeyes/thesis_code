function [lb, ub, max_slope] = slope_approach(obj, mftwdfa_settings, min_range)

    increment = 0.1;
    [t_arr, ~] = read_data(obj,mftwdfa_settings);
    
    start_bound = round(min(log10(t_arr)),1);
    end_bound = round(max(log10(t_arr)),1);
    
    disp(start_bound);
    disp(end_bound);
    
    ub_arr = [];
    slope_arr = [];
    
    i = 1;
    for other_bound = start_bound + min_range : increment : end_bound
        
        disp(other_bound);
        
        bounds = {start_bound, other_bound};
        s = avg_slope(obj,mftwdfa_settings,bounds);
        
        slope_arr(i) = s;
        ub_arr(i) = bounds{2};
        
        i = i + 1;
        
    end
    
    plot(ub_arr, slope_arr);
    
    max_slope = max(slope_arr);
    lb = start_bound;
    ub = ub_arr(slope_arr == max_slope);
    
    
end