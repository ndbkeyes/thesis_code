function [tavg_arr, std_arr] = slope_stdev(obj, mftwdfa_settings, increments, bounds)
%
% FUNCTION: slope_stdev(obj, mftwdfa_settings, bounds, increment)
%
% PURPOSE: find the standard deviation of slopes within a larger slope
% segment, to see how well the slope adheres to a straight line
% demonstrating power-law behavior
%
% INPUT:
% - usual obj & mftwdfa_settings
% - bounds: {lowerbound, upperbound} for whole slope area being analyzed
% - increments: 
%       - (1) amt to move (A) largest slope segment by on each iteration
%       - (2) size of (B) sub-segments of (A) used to find stdev of slopes
%
% OUTPUT:
% - slope_std: standard deviation of the sub-segment slopes
%

    bounds_slope = {bounds{1} - increments{2}/2 , bounds{2} + increments{2}/2};

    [tscale_arr, slope_arr] = slope_smoothed(obj,mftwdfa_settings,increments,bounds_slope);
    
    section_size = ceil(increments{2} / increments{1});
    disp(section_size);
    
    i = 1;
    tavg_arr = [];
    stdev_arr = [];
    
    while i + section_size < length(slope_arr)
        indices = i : i+section_size;
        tavg_arr(i) = mean(tscale_arr(indices));
        stdev_arr(i) = std(slope_arr(indices));
        i = i + 1;
    end
    
    plot(tavg_arr,stdev_arr,'Color','g');
    
end

