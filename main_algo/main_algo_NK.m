close all;
warning('off','all')

user_id = "NK";
data_name = "co2";
obj = DataSet(user_id, data_name);

fprintf("*===== %s main_algo =====*\n",obj.data_name);

% ----- MFTWDFA settings ----- %

scheme_arr = ["makima","spline"];                   % try both schemes
res_arr = [floor(obj.data_res/2), obj.data_res];    % use the resolution calculated from opt_res inside of set_params, and half of that value
q_arr = [-20,-15,-10,-5,-2,-1,1,2,5,10,15,20];      % range of q values to run with
mftwdfa_settings = {scheme_arr, res_arr, q_arr};

% ----- Run MFTWDFA and analysis ----- %

% obj.run_mftwdfa(mftwdfa_settings);
% obj.main_analysis(mftwdfa_settings);

lb_bounds = {3.2,5.5};
ub_bounds = {3.4,5.7};
increment = 0.2;
slope_map(obj,mftwdfa_settings,lb_bounds,ub_bounds,increment);
