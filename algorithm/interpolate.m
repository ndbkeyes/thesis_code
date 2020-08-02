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

    
    % Average data values with same age!
    X_avg = [];
    Y_avg = [];
    j = 1;

    for i=1:length(X)

        % if age value not already encountered:
        if ~ismember(X(i), X_avg)

            % add it to avg X-array
            X_avg(j) = X(i);

            % add mean value to avg-Y array - using logical indexing
            Y_avg(j) = mean(Y(X==X(i)));

            % increment avg-array index
            j = j + 1;

        end
    end


    % Evenly spaced x values to interpolate to
    if strcmp(scheme,'none')
        xx = X_avg;
    else
        xx = min_X:step:max_X;  
    end
    
    % Interpolate y values
    if strcmp(scheme,'spline')
        yy = spline(X_avg,Y_avg,xx);
    elseif strcmp(scheme,'pchip')
        yy = pchip(X_avg,Y_avg,xx);
    elseif strcmp(scheme,'makima')
        yy = makima(X_avg,Y_avg,xx);
    elseif strcmp(scheme, 'none')
        yy = Y_avg;
    else
        disp("ERROR - invalid interpolation scheme");
    end
    

end