function [filepath_in, data_subfolder, figs_subfolder, figs_compare, varnames, cutoff, t_scale, bounds_lhs, bounds_rhs] = set_params(obj)


    
    if obj.user_id == "CL"
        tag = "C:\Users\charl\Documents\GitHub";

    elseif obj.user_id == "NK"
        tag = "C:\Users\ndbke\Dropbox\_NDBK\Research\mftwdfa\";

    end
    
    base_folder = strcat(tag,"mftwdfa_code\");
    data_subfolder = strcat(base_folder,"data\",obj.data_name,"\");
    figs_subfolder = strcat(base_folder,"figures\",obj.data_name,"\");
    figs_compare = strcat(base_folder,"figures\COMPARE\");
    
   
     
    %%% SPICE SETTINGS
    
    % Spice oxygen isotope data settings
    if obj.data_name == "spice-temp"

        % ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
        filepath_in = strcat(tag,"mftwdfa_code\data\spice_RAW\spice_age_d18O.csv");
        varnames = {'Age','d18O_cm_ave'};
        cutoff = 1;
        t_scale = 1;


        % ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
        bounds_lhs = {1.3,2.3};
        bounds_rhs = {3.2,4.2};


    %%% EPICA SETTINGS
    
    % Carbon dioxide data settings
    elseif obj.data_name == "epica-co2"

        % ----- SETTINGS FOR INPUT ----- %
        filepath_in = strcat(tag,"mftwdfa_code\data\epica_RAW\edc3-2008_co2_DATA-series3-composite.txt");
        varnames = {'Age_yrBP_','CO2_ppmv_'};
        cutoff = 1;
        t_scale = 1;


        % ----- SETTINGS FOR OUTPUT ----- %
        bounds_lhs = {4,4.75};
        bounds_rhs = {5.1,5.6};




    % Methane data settings    
    elseif obj.data_name == "epica-ch4"
        
        % ----- SETTINGS FOR INPUT ----- %
        filepath_in = strcat(tag,"mftwdfa_code\data\epica_RAW\edc3-2008_ch4_DATA.txt");
        varnames = {'Var2','Var3'};
        cutoff = 1;
        t_scale = 1;

        % ----- SETTINGS FOR OUTPUT ----- %
        bounds_lhs = {4,4.75};
        bounds_rhs = {5.1,5.6};



    % Temperature data settings    
    elseif obj.data_name == "epica-temp"

        % ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
        filepath_in = strcat(tag,"mftwdfa_code\data\epica_RAW\edc3-2007_temperature_DATA.txt");
        varnames = {'Age','Temperature'};
        cutoff = 13;
        t_scale = 1;


        % ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
        bounds_lhs = {3.5,4.5};
        bounds_rhs = {5.15,5.6};

    else

        disp("ERROR - invalid data name");

    end

end