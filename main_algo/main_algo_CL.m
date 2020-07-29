close all;
warning('off','all')

user_id = "CL";
data_name = "spice_temp";
results_folder = "C:\Users\charl\Desktop\files\summer2020 research\results\";
obj = DataSet(user_id, data_name);

fprintf("*===== %s main_algo =====*\n",obj.data_name);

% ----- MFTWDFA settings ----- %

scheme_arr = ["makima","spline"];               % try both schemes
res_arr = [floor(obj.data_res/2), obj.data_res];        % use the resolution calculated from opt_res inside of set_params, and half of that value
q_arr = [-20,-15,-10,-5,-2,-1,1,2,5,10,15,20];  % range of q values to run with
mftwdfa_settings = {scheme_arr, res_arr, q_arr};


% ----- Run MFTWDFA and analysis ----- %

obj.run_mftwdfa(mftwdfa_settings);
obj.main_analysis(mftwdfa_settings);