function [t_arr,f_arr] = read_data(obj,mftwdfa_settings)
%
% FUNCTION: read_data(obj,mftwdfa_settings)
%
% PURPOSE: reads MFTWDFA-generated data out of corresponding file
%
% INPUT:
% - obj: DataSet object for which MFTWDFA was run
% - mftwdfa_settings: array of settings for the MFTWDFA run desired -- cell array in form {interp_scheme, data_res, q}
%
% OUTPUT: 
% - [t_arr, f_arr] - arrays of t and Fq, which when plotted in log-log make fluctuation function plot
%

    % disp(mftwdfa_settings);
    filepath_out = mftwdfa_filepath(obj,mftwdfa_settings);

    
    % import MFTWDFA fluct func data if it exists
    try
        timeseries = importdata(filepath_out);
        t_arr = timeseries(:,1);
        f_arr = timeseries(:,2);
        
        if obj.normed
            f_arr = f_arr ./ mftwdfa_settings{2} * obj.data_res;   % normalize by resolution !
        end
    
    % give error if MFTWDFA hasn't been run yet to make desired files
    catch
        fprintf("MFTWDFA datafiles do not exist for %s - %s, %d.\n",obj.data_name, mftwdfa_settings{1}, mftwdfa_settings{2});
    end
    
end