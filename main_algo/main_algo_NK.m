clear all;
close all;
warning('off','all')

user_id = "NK";
data_name = "temperature";
normed = 1;
obj = DataSet(user_id, data_name, normed);

fprintf("*===== %s main_algo =====*\n",obj.data_name);


% ----- Run MFTWDFA and analysis ----- %

scheme_arr = ["makima","spline"];                   % try both schemes
res_arr = [floor(obj.data_res/2), obj.data_res];    % use the resolution calculated from opt_res inside of set_params, and half of that value
q_arr = [-20,-15,-10,-5,-2,-1,1,2,5,10,15,20];      % range of q values to run with
mftwdfa_settings = {scheme_arr, res_arr, q_arr};

% run_mftwdfa(obj,mftwdfa_settings);
normed = 1;
main_analysis(obj,mftwdfa_settings,normed);



% ----- Slope gradient plots ----- %




