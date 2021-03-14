function [data_arr, increment] = split_data(X, Y, n_windows)
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
    range = 800000;
    increment = range / n_windows;
    if floor(n_windows) ~= n_windows
        disp("N_WINDOWS NOT INT - PLEASE REDO");
        return;
    end

    % make empty cell arrays of correct size
    data_arr = cell(2,n_windows);

    % fill cell array with windows of data
    % (counting from past to present in time)
    for i = n_windows:-1:1

        % calculate index of current window - i=1 is farthest back in time
        window_index = n_windows - i + 1;

        % find time bounds on window
        start_t = -1 * i * increment;
        end_t = -1 * ((i-1) * increment + 1);
        % fprintf("window %d: start, end = %d, %d\n", window_index, start_t, end_t);

        % get data that fits in that time window
        data_indices = X >= start_t & X < end_t;
        data_arr{1, window_index} = X(data_indices);
        data_arr{2, window_index} = Y(data_indices);

    end


end