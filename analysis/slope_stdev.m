function slope_std = slope_stdev(obj, mftwdfa_settings, bounds, increment)
%
% FUNCTION: slope_stdev(obj, mftwdfa_settings, bounds, increment)
%
% PURPOSE: find the standard deviation of slopes within a larger slope
% segment, to see how well the slope adheres to a straight line
% demonstrating power-law behavior
%
% INPUT:
% - usual obj & mftwdfa_settings
% - bounds: {lowerbound, upperbound} for whole slope segment being analyzed
% - increment: size of sub-segments used to find stdev of slopes
%
% OUTPUT:
% - slope_std: standard deviation of the sub-segment slopes
%

    slope_arr = [];
    i = 1;
    for lb = bounds{1} : increment : bounds{2} - increment
        
        ub = lb + increment;
        
        s = avg_slope(obj,mftwdfa_settings,{lb,ub});
        slope_arr(i) = s;
        i = i + 1;
        
    end
    
    slope_std = std(slope_arr);    

end

