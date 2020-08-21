function [filepath_in, results_folder, varnames, cutoff, t_scale, folder_out, bounds_lhs, bounds_rhs] = set_params(obj)


    
    if obj.user_id == "CL"
        tag = "C:\Users\charl\Documents\GitHub";

    elseif obj.user_id == "NK"
        tag = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa";
    end
        
    results_folder = strcat(tag,"\mftwdfa_code\data\");
    
   
     
    %%% SPICE SETTINGS
    
    % Spice oxygen isotope data settings
    if obj.data_name == "temp_spice"

            % ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
            filepath_in = strcat(tag,"\mftwdfa_code\data\spice_RAW\spice_age_d18O.csv");
            varnames = {'Age','d18O_cm_ave'};
            cutoff = 1;
            t_scale = 1;


            % ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
            folder_out = strcat(results_folder, obj.data_name, "\");
            bounds_lhs = {1.3,2.3};
            bounds_rhs = {3.2,4.2};

    else


        disp("ERROR - invalid data name");

    end



%%% EPICA SETTINGS

     % Carbon dioxide data settings
    if obj.data_name == "co2_epica"

        % ----- SETTINGS FOR INPUT ----- %
        filepath_in = strcat(tag,"\mftwdfa_code\data\epica_RAW\edc3-2008_co2_DATA-series3-composite.txt");
        varnames = {'Age_yrBP_','CO2_ppmv_'};
        cutoff = 1;
        t_scale = 1;


        % ----- SETTINGS FOR OUTPUT ----- %
        folder_out = strcat(results_folder, obj.data_name, "\");
        bounds_lhs = {4,4.75};
        bounds_rhs = {5.1,5.6};




    % Methane data settings    
    elseif obj.data_name == "ch4_epica"

        % ----- SETTINGS FOR INPUT ----- %
        filepath_in = strcat(tag,"\mftwdfa_code\data\epica_RAW\edc3-2008_ch4_DATA.txt");
        varnames = {'Var2','Var3'};
        cutoff = 1;
        t_scale = 1;

        % ----- SETTINGS FOR OUTPUT ----- %
        folder_out = strcat(results_folder, obj.data_name, "\");
        bounds_lhs = {4,4.75};
        bounds_rhs = {5.1,5.6};



    % Temperature data settings    
    elseif obj.data_name == "temp_epica"

        % ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
        filepath_in = strcat(tag,"\mftwdfa_code\data\epica_RAW\dc3-2007_temperature_DATA.txt");
        varnames = {'Age','Temperature'};
        cutoff = 13;
        t_scale = 1;


        % ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
        folder_out = strcat(results_folder, obj.data_name, "\");
        bounds_lhs = {3.5,4.5};
        bounds_rhs = {5.15,5.6};

    else

        disp("ERROR - invalid data name");

    end

end