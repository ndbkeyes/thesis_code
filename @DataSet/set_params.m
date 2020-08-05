function [filepath_in, results_folder, varnames, cutoff, t_scale, folder_out, bounds_lhs, bounds_rhs] = set_params(obj)


    
    %%% CHARLOTTE SETTINGS
    if obj.user_id == "CL"
        
        results_folder = "C:\Users\charl\Desktop\files\summer2020 research\results\";

        if obj.data_name == "spice_temp"

                % ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
                filepath_in = "C:\Users\charl\Desktop\files\summer2020 research\SPIceCoreDatahalfcmAverage01-08-2020";
                varnames = {'Var1','Var2'};
                cutoff = 1;
                t_scale = 1;


                % ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
                folder_out = strcat(results_folder, obj.data_name, "\");
                bounds_lhs = {1.8,3};
                bounds_rhs = {};
                
                
        else
            
            disp("ERROR - invalid data name");
                
        end
        
    end
    
    
%%
    
    
    %%% NASH SETTINGS
    if obj.user_id == "NK"
        
        
        results_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\";
        
        
         % Carbon dioxide data settings
        if obj.data_name == "co2"

            % ----- SETTINGS FOR INPUT ----- %
            filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_co2_DATA-series3-composite.txt";
            varnames = {'Age_yrBP_','CO2_ppmv_'};
            cutoff = 1;
            t_scale = 1;


            % ----- SETTINGS FOR OUTPUT ----- %
            folder_out = strcat(results_folder, obj.data_name, "\");
            bounds_lhs = {4,4.75};
            bounds_rhs = {5.1,5.6};





        % Methane data settings    
        elseif obj.data_name == "ch4"

            % ----- SETTINGS FOR INPUT ----- %
            filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_ch4_DATA.txt";
            varnames = {'Var2','Var3'};
            cutoff = 1;
            t_scale = 1;

            % ----- SETTINGS FOR OUTPUT ----- %
            folder_out = strcat(results_folder, obj.data_name, "\");
            bounds_lhs = {4,4.75};
            bounds_rhs = {5.1,5.6};




        % Temperature data settings    
        elseif obj.data_name == "temperature"

            % ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
            filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2007_temperature_DATA.txt";
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

end