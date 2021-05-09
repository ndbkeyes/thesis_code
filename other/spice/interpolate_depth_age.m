function [xx,yy]=interpolate_depth_age(X,Y,step,min_X,max_X)

%
% FUNCTION: depth_to_age(X,Y,resolution,scheme)
%
% PURPOSE: interpolate the given (X,Y) dataset
%
% INPUT:
% - X: independent variable series (depth)
% - Y: dependent variable series (age)
% - step: step for evenly spaced data
% - min_X: least X value
% - max_X: greatest X value
%
% OUTPUT:
% - xx: evenly-spaced independent-variable (depth)
% - yy: interpolated dependent-variable (age) series
%
    
    % Evenly spaced x values to interpolate to
    if strcmp(scheme,'none')
        xx = X;
    else
        xx = min_X:step:max_X; % Took minimum and step from data set 
    end
    
    % Interpolate y values
    yy = makima(X,Y,xx);
        disp("ERROR - invalid interpolation scheme");
    
    end
    

end