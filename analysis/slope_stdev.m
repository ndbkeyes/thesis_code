function slope_std = slope_stdev(obj, mftwdfa_settings, bounds, mag_range, increments)
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


    increment_A = increments{1};
    increment_B = increments{2};

    
    
    % LOOP OVER (A) larger slope segments
    bounds_A = [];
    stdevs_A = [];
    i = 1;
    for lb_A = bounds{1} - mag_range/2 : increment_A : bounds{2} - mag_range/2

        ub_A = lb_A + mag_range;
        bounds = {lb_A, ub_A};
        
        % (B) sub-sections of the (A) larger segments
        slopes_B = [];
        j = 1;
        for lb_B = bounds{1} : increment_B : bounds{2}

            ub_B = lb_B + increment_B;

            % get slope of (B) sub-section
            s = avg_slope(obj,mftwdfa_settings,{lb_B,ub_B});
            slopes_B(j) = s;
            j = j + 1;

        end

        % find stdev of the distribution of (B) sub-section slopes
        % gives 1 stdev value for the (A) larger segment as a whole!
        slope_std = std(slopes_B); 
        
        bounds_A(i) = (lb_A + ub_A)/2;
        stdevs_A(i) = slope_std;
        i = i + 1;
        
        
    end
    
    plot(bounds_A,stdevs_A);
    xlabel("center of slope segment bounds");
    ylabel("standard deviation of slope sub-segments");
    
    
end

