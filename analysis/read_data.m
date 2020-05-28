%% ===== READ DATA ===== %%

function [t_arr,f_arr] = read_data(interp_scheme,data_res,q,frac_data,input_folder)

    end_tag = "DATA.txt";
    marker = sprintf("%s-%d-%d-%.2f",interp_scheme,data_res,q,frac_data);
    file_name = strcat(input_folder,marker,"_",end_tag);
    
    timeseries = importdata(file_name);
    t_arr = timeseries(:,1);
    f_arr = timeseries(:,2);
    
end