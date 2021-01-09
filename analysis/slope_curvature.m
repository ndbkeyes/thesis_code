function [tscale_arr, curvature_arr] = slope_curvature(obj, mftwdfa_settings, increments, bounds)
%
% FUNCTION: slope_curvature(obj, mftwdfa_settings)
%
% PURPOSE: find and plot the curvature of the MFTWDFA fluctuation function
%
% INPUT:
% - usual obj (DataSet object) and mftwdfa_settings (interpolation scheme,
% interpolation resolution, statistical moment)
% - increment array: {increment_A, increment_B}
%             where: A = shift between segments, B = size of slope segment
%
% OUTPUT:
% - plot smoothed 2nd deriv (curvature) of fluct func
%

    [tscale_arr, slope_arr] = slope_smoothed(obj,mftwdfa_settings,increments,bounds);
    
    % take gradient of smoothed slope to get curvature
    curvature_arr = gradient(slope_arr,tscale_arr);
    
    
    %% try using slope_smoothed a second time, implement when i have time???
    
    hold on;
    plot(tscale_arr,slope_arr,'Color','b');
    plot(tscale_arr,curvature_arr,'Color','r');
    saveas(gcf,sprintf("%s%s_curvature.fig",obj.figs_subfolder,obj.data_name)); 

end

