function [filepath_in, varnames, cutoff, t_scale, data_name, folder_out, bounds_lhs, bounds_rhs, data_res] = set_params(data_name, results_folder)\

if data_name == "spice_temp"
        
        % ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
        filepath_in = "C:\Users\charl\Desktop\files\summer2020 research\SPIceCoreDatahalfcmAverage01-08-2020";
        varnames = {'Age','Temperature'};
        cutoff = 13;
        t_scale = 1;
        



        % ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
        folder_out = strcat(results_folder,data_name,"\");
        bounds_lhs = {3.5,4.5};
        bounds_rhs = {5.15,5.6};