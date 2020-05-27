function [xx,yy] = interpolate(age,co2,resolution,scheme)

    % Find range and resolution
    max_age = max(age);
    min_age = min(age);
    range = max_age - min_age;
    step = range / resolution;

    % Remove data values with repeated age - check on whether this is ok
    [x, index] = unique(age);           % Original x values (age)
    y = co2(index);                     % Original y values (CO2)                          

    % Evenly spaced x values to interpolate to
    if strcmp(scheme,'none')
        xx = x;
    else
        xx = min_age:step:max_age;  
    end
    
    % Interpolate y values
    if strcmp(scheme,'spline')
        yy = spline(x,y,xx);
    elseif strcmp(scheme,'pchip')
        yy = pchip(x,y,xx);
    elseif strcmp(scheme,'makima')
        yy = makima(x,y,xx);
    elseif strcmp(scheme, 'none')
        yy = y;
    else
        disp("ERROR - invalid interpolation scheme");
    end
    
    
    hold on;
    
%     plot(xx,yy);
%     scatter(age,co2);

end