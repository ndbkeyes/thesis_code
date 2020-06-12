function [xx,yy] = interpolate(X,Y,resolution,scheme)
%
% FUNCTION: interpolate(age,co2,resolution,scheme)
%
% PURPOSE: interpolate the given (X,Y) dataset, taking out non-unique X-values
% TODO: average Y-values with identical X-values rather than ignoring one?
%
% INPUT:
% - X: independent variable series (here, time)
% - Y: dependent variable series (here, climate quantity)
% - resolution: number of gaps between data points - one less than N (number of interpolated data points)
% - scheme: type of spline to use in interpolation
%            options: "makima", "spline", "pchip"
%
% OUTPUT:
% - xx: evenly-spaced independent-variable (time)
% - yy: interpolated dependent-variable (climate variable) series
%

    % Find range and resolution
    max_X = max(X);
    min_X = min(X);
    range = max_X - min_X;
    step = range / resolution;

    % Remove data values with repeated age - check on whether this is ok
    [X, index] = unique(X);           % Original x values (age)
    Y = Y(index);                     % Original y values (CO2)                          

    % Evenly spaced x values to interpolate to
    if strcmp(scheme,'none')
        xx = X;
    else
        xx = min_X:step:max_X;  
    end
    
    % Interpolate y values
    if strcmp(scheme,'spline')
        yy = spline(X,Y,xx);
    elseif strcmp(scheme,'pchip')
        yy = pchip(X,Y,xx);
    elseif strcmp(scheme,'makima')
        yy = makima(X,Y,xx);
    elseif strcmp(scheme, 'none')
        yy = Y;
    else
        disp("ERROR - invalid interpolation scheme");
    end
    

end