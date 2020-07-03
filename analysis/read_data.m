function [t_arr,f_arr] = read_data(folder_out,data_name,mftwdfa_settings)
%
% FUNCTION: read_data(folder_out,data_name,mftwdfa_settings)
%
% PURPOSE: reads MFTWDFA-generated data out of corresponding file
%
% INPUT:
% - folder_out: folder in which the MFTWDFA data is located
% - data_name: nametag of the data series to be read
% - mftwdfa_settings: array of settings for the MFTWDFA run desired -- cell array in form {interp_scheme, data_res, q}
%
% OUTPUT: 
% - [t_arr, f_arr] - arrays of t and Fq, which when plotted in log-log make fluctuation function plot
%

    filepath_out = mftwdfa_filepath(folder_out,data_name,mftwdfa_settings);
    
    try
        timeseries = importdata(filepath_out);
        t_arr = timeseries(:,1);
        f_arr = timeseries(:,2);
    catch
        fprintf("MFTWDFA datafiles do not exist for %s - %s, %d.\n",data_name, mftwdfa_settings{1}, mftwdfa_settings{2});
    end
    
end