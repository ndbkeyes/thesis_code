function [t_arr,f_arr] = fq_plot(folder_out,data_name,mftwdfa_settings)
%
% FUNCTION: fq_plot(folder_out,data_name,mftwdfa_settings)
%
% PURPOSE: plot log-log fluctuation function for given data and MFTWDFA settings
%
% INPUT:
% - folder_out: folder in which MFTWDFA data file is located
% - data_name: nametag of data series being examined
% - mftwdfa_settings: array of settings for the MFTWDFA run desired -- cell array in form {interp_scheme, data_res, q}
%
% OUTPUT: none, just plots Fq and saves figure in folder_out
%


    [t_arr, f_arr] = read_data(folder_out,data_name,mftwdfa_settings);    
    
    scatter(log10(t_arr),log10(f_arr));
    filename = sprintf("%s%s_FluctFunc_%s-%d-%d.fig",folder_out,data_name,mftwdfa_settings{1},mftwdfa_settings{2},mftwdfa_settings{3});
    saveas(gcf,filename);
    
    
end