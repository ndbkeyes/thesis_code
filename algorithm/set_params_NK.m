function [filepath_in, varnames, cutoff, t_scale, data_name, folder_out, bounds_lhs, bounds_rhs, data_res] = set_params(data_name, results_folder)


    

    
    
    % Carbon dioxide data settings
    if data_name == "co2"
        
        % ----- SETTINGS FOR INPUT ----- %
        filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_co2_DATA-series3-composite.txt";
        varnames = {'Age_yrBP_','CO2_ppmv_'};
        cutoff = 1;
        t_scale = 1;


        % ----- SETTINGS FOR OUTPUT ----- %
        data_name = "co2";
        folder_out = strcat(results_folder,data_name,"\");
        bounds_lhs = {4,4.75};
        bounds_rhs = {5.1,5.6};
        
        
        
        
        
    % Methane data settings    
    elseif data_name == "ch4"
        
        % ----- SETTINGS FOR INPUT ----- %
        filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_ch4_DATA.txt";
        varnames = {'Var2','Var3'};
        cutoff = 1;
        t_scale = 1;

        % ----- SETTINGS FOR OUTPUT ----- %
        data_name = "ch4";
        folder_out = strcat(results_folder,data_name,"\");
        bounds_lhs = {4,4.75};
        bounds_rhs = {5.1,5.6};
        
        
        
        
    % Temperature data settings    
    elseif data_name == "temperature"
        
        % ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
        filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2007_temperature_DATA.txt";
        varnames = {'Age','Temperature'};
        cutoff = 13;
        t_scale = 1;


        % ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
        folder_out = strcat(results_folder,data_name,"\");
        bounds_lhs = {3.5,4.5};
        bounds_rhs = {5.15,5.6};
        
    else
        
        disp("ERROR - invalid data name");
        
    end
    
    
    read_settings = {cutoff, t_scale};
    data_res=1000;
%     data_res = opt_res(filepath_in, varnames, read_settings);


end
    



