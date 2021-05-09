function [tscale_arr, slope_arr] = slope_smoothed(obj, mftwdfa_settings, increments, bounds)
%
% FUNCTION: slope_smoothed(obj, mftwdfa_settings)
%
% PURPOSE: find and plot the smoothed slope of the MFTWDFA fluctuation
% function for q=2 by linear fitting adjacent sections of slope
%
% INPUT:
% - usual obj (DataSet object) and mftwdfa_settings (interpolation scheme,
% interpolation resolution, statistical moment)
% - increment array: {increment_A, increment_B}
%             where: A = shift between segments, B = size of slope segment
% - bounds: lower and upper bounds of the region in the fluctuation
% function to analyze
%
% OUTPUT:
% - plot smoothed 2nd deriv (curvature) of fluct func
%
%%

    % read in fluctuation function
    [t_arr, f_arr] = read_data(obj, mftwdfa_settings);
    log_t = log10(t_arr);
    log_f = log10(f_arr);
    
    % unpack increments and bounds
    increment_A = increments{1};  % amt to shift the fitting segment right each time
    increment_B = increments{2};  % size of fitting segment
    lb_min = bounds{1};
    ub_max = bounds{2};
    
    % set up for loop; make empty arrays, set up initial slope segment
    tscale_arr = [];
    slope_arr = [];
    i = 1;
    lb = lb_min - increment_B/2;
    ub = lb_min + increment_B/2;
    
    % loop thru to find and store avg (smoothed) slopes
    while ub <= ub_max + increment_B/2
        
        % find slope of regline over current fluct func segment
        s = avg_slope(obj,mftwdfa_settings,{lb,ub});
        
        % store slope and timescale of section center
        slope_arr(i) = s;
        tscale_arr(i) = (lb+ub)/2;
        i = i + 1;
        
        % shift slope segment for next iteration
        lb = lb + increment_A;
        ub = ub + increment_A;
        
    end

end
