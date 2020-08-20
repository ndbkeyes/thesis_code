function [max_slope, lb, ub] = slope_xc(obj,mftwdfa_settings,mag_range)

    
    increment = 0.1;
    [t_arr, ~] = read_data(obj,mftwdfa_settings);
    lb_bounds = round(min(log10(t_arr)),1) - mag_range/2 : increment : round(max(log10(t_arr)),1) - mag_range/2;
    
    bounds_center = zeros(length(lb_bounds),1);
    slope_section = zeros(length(lb_bounds),1);
    
    i = 1;
    for lb = lb_bounds
        
        ub = lb + mag_range;    % requiring magnitude range to be 1
        slope_bounds = {lb, ub};
        s = avg_slope(obj,mftwdfa_settings,slope_bounds);
        
        bounds_center(i) = (lb + ub) / 2;
        slope_section(i) = s;
        i = i + 1;
        
    end
    
    max_slope = max(slope_section);
    disp(max_slope);
    
    lb = lb_bounds(slope_section == max_slope);
    ub = lb + 1;
    fprintf("bounds: (%.1f, %.1f)\n", lb, ub);
    % avg_slope(obj,mftwdfa_settings,{lb,ub},1);   % plot line of best fit
    
    
    plot(bounds_center,slope_section);    
    

end