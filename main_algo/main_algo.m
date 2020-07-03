close all;
warning('off','all')


data_name = "temperature";
[filepath_in, varnames, read_settings, data_name, folder_out, bounds_lhs, bounds_rhs, data_res] = set_params(data_name);

fprintf("*===== %s main_algo =====*\n",data_name);

% ----- MFTWDFA settings ----- %

scheme_arr = ["makima","spline"];               % try both schemes
res_arr = [floor(data_res/2), data_res];        % use the resolution calculated from opt_res inside of set_params, and half of that value
q_arr = [-20,-15,-10,-5,-2,-1,1,2,5,10,15,20];  % range of q values to run with
mftwdfa_settings = {scheme_arr, res_arr, q_arr};


% ----- Run MFTWDFA and analysis ----- %

run_mftwdfa(mftwdfa_settings,filepath_in,folder_out,varnames,data_name,read_settings);
main_analysis(filepath_in,folder_out,varnames,data_name,mftwdfa_settings,bounds_lhs,bounds_rhs);