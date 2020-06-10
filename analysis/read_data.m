function [t_arr,f_arr] = read_data(filepath_out)
% read_tripped_data: reads climate data out of file located at filepath_out
%
% INPUT: filepath_out - FULL path of file (folder + filename)
%
% OUTPUT: [t_arr, f_arr] - arrays of t and Fq, which together make
% fluctuation function plot

    timeseries = importdata(filepath_out);
    t_arr = timeseries(:,1);
    f_arr = timeseries(:,2);
    
end