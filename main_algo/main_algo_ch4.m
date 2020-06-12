close all;
warning('off','all')



% ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_ch4_DATA.txt";
varnames = {'Var2','Var3'};



% ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
data_name = "ch4";
folder_out = strcat("C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\",data_name,"\");


% ----- run MFTWDFA from climate data ----- %
q_arr = [-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]; % range of q values to run with
mftwdfa_settings = {"makima",1000,2};
run_mftwdfa(mftwdfa_settings,filepath_in,folder_out,varnames,data_name);

% 
% % ----- plot log-log fluctuation func, q=2 ----- %
%         % interp_scheme, data_res, q
% fqplot_settings = {"makima", 1000, 2};
% fq_plot(folder_out,data_name,fqplot_settings);
% 
% 
% % ----- slope analysis ----- %
% max_logw = 5;
% bounds_lhs = {3.5,4.9};
% bounds_rhs = {5.1,5.5};
% slope_analysis(folder_out,data_name,fqplot_settings,max_logw,bounds_lhs);
% slope_analysis(folder_out,data_name,fqplot_settings,max_logw,bounds_rhs);
% 
% 
% % ----- Hurst exponent and singularity spectrum for left half
% makeplot = 1;
% hurst_settings = {"makima",1000,q_arr};
% 
% h_arr = hurst_exp(folder_out, data_name, hurst_settings, bounds_lhs, makeplot);
% sing_spectrum(q_arr, h_arr, folder_out, data_name, hurst_settings, bounds_lhs, makeplot);
% 
% h_arr = hurst_exp(folder_out, data_name, hurst_settings, bounds_rhs, makeplot);
% sing_spectrum(q_arr, h_arr, folder_out, data_name, hurst_settings, bounds_rhs, makeplot);