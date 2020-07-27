function [filepath_in, varnames, cutoff, t_scale, data_name, folder_out, bounds_lhs, bounds_rhs] = set_params_CL(data_name, results_folder)

if data_name == "spice_temp"
        
        % ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
        filepath_in = "C:\Users\charl\Desktop\files\summer2020 research\SPIceCoreDatahalfcmAverage01-08-2020";
        varnames = {'Var1','Var2'};
        cutoff = 1;
        t_scale = 1;

        
        % ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
        folder_out = strcat(results_folder,data_name,"\");
        bounds_lhs = {1.8,3};
        bounds_rhs = {};
end

end