function res = opt_res(obj)
%
% FUNCTION: opt_res(filepath_in, varnames, read_settings)
%
% PURPOSE: estimates the optimal resolution for MFTWDFA interpolation
%
% INPUT:
% - X: array of X (time) coordinates for climate data series
%
% OUTPUT:
% - res: estimate of appropriate resolution for interpolation, in number of points
%

    % find timegaps between consecutive data points
    timegaps = zeros(length(obj.X)-1,1);
    for i=1:length(obj.X)-1
        timegaps(i) = obj.X(i+1)-obj.X(i);
    end
    
    % calculate estimate of good resolution (# of interpolation points)
    % based on dividing the range by the most common timegap, and multiplying by 2 just to be safe
    res = ceil(range(obj.X) / median(timegaps));

end