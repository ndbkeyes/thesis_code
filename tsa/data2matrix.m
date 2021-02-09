function [matrix_x,matrix_y,M_length,mean_y] = data2matrix(obj,Y,M)
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



%%
    
    % initialize empty matrices
    matrix_x = zeros(Y,M);
    matrix_y = zeros(Y,M);
    
    % interpolate first so we don't have to worry about varying data
    % density limiting choice of year and month lengths
    [xx,yy] = interpolate(obj.X,obj.Y,Y*M*20,"makima");
    
    % translate X-values (time) so that it starts at zero rather than -800kyr
    xx = xx - min(xx);
    
    % get data range and lengths of years & months
    range = max(xx) - min(xx);
    Y_length = range / Y;
    M_length = Y_length / M;
    % fprintf("range = %.2f, Y_length = %.2f, M_length = %.2f", range, Y_length, M_length);
    
    
    
    
    
%%

    % loop over (year,month) pairs
    for y=1:Y
        for m=1:M     
            
            % find time interval corresponding to month m of year y
            t_min = (y-1)*Y_length + (m-1)*M_length;
            t_max = (y-1)*Y_length + m*M_length;
            summ = 0;
            n = 0;
            % fprintf("Year: %d, Month: %d     t_min: %.2f, t_max: %.2f\n",y,m,t_min,t_max);
            
            % find datapoints that fall in correct time interval for (y,m)
            for i=1:length(xx)
                if xx(i) >= t_min && xx(i) <= t_max
                    summ = summ + yy(i);
                    n = n+1;
                end
            end
            
            
%             if n == 0
%                 fprintf("%d,%d: has 0 points. ERROR - program terminating.\n",y,m);
%                 return
%             else
%                 fprintf("%d,%d: has %d points.\n",y,m,n);
%             end
            
            
            % add average x and y coordinates of points into matrix
            matrix_x(y,m) = (t_min + t_max) / 2 + min(obj.X);
            matrix_y(y,m) = summ / n;
            
        end
    end
    
    % translate data down so that average is zero! (needed for variance calculations)
    mean_y = mean(matrix_y,'all');
    matrix_y = matrix_y - mean_y;

end

