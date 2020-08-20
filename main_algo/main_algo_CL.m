close all;
warning('off','all')

% user_id = "CL";
% data_name = "spice_oxygen";
% obj_spice = DataSet(user_id, data_name);
% obj_spice.data_res = 30000;
% 
% fprintf("*===== %s main_algo =====*\n",obj.data_name);

% ----- MFTWDFA settings ----- %

% scheme_arr = ["makima","spline"];               % try both schemes
% res_arr = [floor(obj_spice.data_res/2), obj_spice.data_res];        % use the resolution calculated from opt_res inside of set_params, and half of that value
% q_arr = [-20,-15,-10,-5,-2,-1,1,2,5,10,15,20];  % range of q values to run with
% mftwdfa_settings = {scheme_arr, res_arr, q_arr};

% ----- Run MFTWDFA and analysis ----- %

% obj.run_mftwdfa(mftwdfa_settings);
% obj.main_analysis(mftwdfa_settings);

% ---- Plot normed spice and epica fluctuation function results on same plot ---- % 

user_id = "CL";
normed = 1;
obj_spice = DataSet(user_id, "spice_oxygen", normed);
obj_spice.data_res = 30000;
obj_epica = DataSet(user_id, "epica_temp", normed);

mftwdfa_settings_spice = {"makima", obj_spice.data_res, 2};
mftwdfa_settings_epica = {"makima", obj_epica.data_res, 2};

% obj_spice.run_mftwdfa(mftwdfa_settings_spice);
% obj_epica.run_mftwdfa(mftwdfa_settings_epica);

hold on

fq_plot(obj_spice, mftwdfa_settings_spice);
fq_plot(obj_epica, mftwdfa_settings_epica);

hold off

% ---- Slope gradient map ---- %
% inc = 0.1;
% mag_range = 0.25;
% 
% mftwdfa_settings = {"makima",obj.data_res,2};
% slope_map(obj,mftwdfa_settings,inc,mag_range,2);