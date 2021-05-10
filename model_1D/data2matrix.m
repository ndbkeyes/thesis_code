function [matrix_x,matrix_y,delt] = data2matrix(obj)
%
% FUNCTION: data2matrix(obj,Y,M)
%
% PURPOSE: turns one-dimensional data array into matrix of year / month
% points, with a third axis containing the average x and y values
%
% INPUT:
% - obj: DataSet object for the dataset to be analyzed
% - Y: number of years (cyclic sections) to divide the data into
% - M: number of months (subsections) to divide the years (cyclic sections) into
%
% OUTPUT: 
% - matrix_x: Y x M matrix containing the average time coordinate for each (year,month)
% - matrix_y: Y x M matrix containing the average y-coordinate for each (year,month)
% *** years are rows, months are columns ***
%
%%

    if nargin == 3
        br_win = 0;
    end
    
    
    Y = obj.yr;
    M = obj.mo;
    br_win = obj.bw;
    
    % interpolate unique-avged data to standard range
    
    [X_unique, Y_unique] = unique_avged(obj);
    
    global xx
    yy = makima(X_unique,Y_unique,xx);
    
    % get data range and lengths of years & months
    delt = range(xx) / (Y*M);
    
    if br_win ~= 0
        yy = yy - movmean(yy,br_win);
    else
        yy = yy - mean(yy);
    end
    
    
    
%%

    % initialize matrices to hold x and y averaged data values
    matrix_x = zeros(Y,M);
    matrix_y = zeros(Y,M);

    % loop over (year,month) pairs
    for y=1:Y
        for m=1:M     
            
            index = (y-1)*M + m;
            matrix_x(y,m) = xx(index);
            matrix_y(y,m) = yy(index);
            
        end
    end
    


end