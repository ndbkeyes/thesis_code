function [data_1, data_2] = split_data(X, Y, n_windows, i)
%
% FUNCTION: split_data(X,Y,n_windows)
%
% PURPOSE: splits up data into segments for coupling analysis
%
% INPUT: 
% - X, Y: x,y coordinates of data set
% - n_windows: number of windows (segments) the data will be split into
%
% OUTPUT:
% - data1_arr, data2_arr: cell arrays holding x,y coordinates of data split into sections, indexed from past (1) to present (n_windows)
% - increment: size of the segments split into
%


    % figure out sizing on windows
    increment = range(X) / n_windows;

    % 
    window_mag = n_windows - i + 1;

    % find time bounds on window
    start_t = -1 * window_mag * increment;
    end_t = -1 * ((window_mag-1) * increment + 1);
    % fprintf("window %d: start, end = %d, %d\n", window_index, start_t, end_t);

    % get data that fits in that time window
    data_indices = X >= start_t & X < end_t;
    data_1 = X(data_indices);
    data_2 = Y(data_indices);

end