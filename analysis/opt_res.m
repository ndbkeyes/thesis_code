function res = opt_res(filepath_in, varnames, read_settings)
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

    [X,~] = load_data(filepath_in, varnames, read_settings);

    % find timegaps between consecutive data points
    timegaps = zeros(length(X)-1,1);
    for i=1:length(X)-1
        timegaps(i) = X(i+1)-X(i);
    end
    
    % calculate estimate of good resolution (# of interpolation points)
    % based on dividing the range by the most common timegap, and multiplying by 2 just to be safe
    res = ceil(range(X) / median(timegaps));

end