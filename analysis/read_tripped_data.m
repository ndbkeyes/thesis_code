%% ===== READ DATA ===== %%

function [t_arr,f_arr] = read_tripped_data(series_type,N,threshold,input_folder)

    marker = sprintf("mftwdfa_%s-%d-%d",series_type,N,threshold);
    file_name = strcat(input_folder,marker);
    
    timeseries = importdata(file_name);
    t_arr = timeseries(:,1);
    f_arr = timeseries(:,2);
    
end