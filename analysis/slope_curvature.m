function slope_curvature(obj, mftwdfa_settings)
%
% FUNCTION: slope_curvature(obj, mftwdfa_settings)
%
% PURPOSE: find and plot the curvature of the MFTWDFA fluctuation function
%
% INPUT:
% usual obj (DataSet object) and mftwdfa_settings (interpolation scheme,
% interpolation resolution, statistical moment)
%
% OUTPUT:
% plots smoothed 2nd deriv / curvature of fluct func
%

    % read in fluctuation function
    [t_arr, f_arr] = read_data(obj, mftwdfa_settings);
    log_t = log10(t_arr);
    log_f = log10(f_arr);
    
    
    increment_A = 0.05;  % amt to shift the fitting segment right each time
    increment_B = 0.4;  % size of fitting segment
    
    % set initial lower and upper bounds
    lb = ceil( (min(log_t) - increment_B / 2) * 4) / 4;
    ub = lb + increment_B;
    
    % make empty arrays to hold t and slope avged values
    tscale_arr = [];
    slope_arr = [];
    
    % loop thru to find and store avg (smoothed) slopes
    i = 1;
    while ub < max(log_t)
        s = avg_slope(obj,mftwdfa_settings,{lb,ub});
        slope_arr(i) = s;
        tscale_arr(i) = (lb+ub)/2;
        i = i + 1;
        lb = lb + increment_A;
        ub = ub + increment_A;
    end
    
    % take gradient of smoothed slope to get curvature
    curvature = gradient(slope_arr,tscale_arr);
    
    hold on;
    plot(tscale_arr,slope_arr);
    plot(tscale_arr,curvature);
    yline(0);
    legend("smoothed slope","curvature","y = 0 (straight slope)");   
    
    saveas(gcf,sprintf("%s%s_curvature.fig",obj.figs_subfolder,obj.data_name)); 

end

