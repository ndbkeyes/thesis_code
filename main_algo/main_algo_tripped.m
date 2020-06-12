close all;
warning('off','all')


%%% ----- settings for generating tripped data ----- %%%
                % type of walk, threshold, walk length
tripped_settings = {"trippedwalk",15,3000};
data_name = sprintf("%s-%d-%d",tripped_settings{1},tripped_settings{2},tripped_settings{3});
folder_out = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\tripped\";
filepath_in = strcat(folder_out,data_name,"_data.txt");
varnames = {'Var1', 'Var2'};


%%% ----- make the tripped random walk data set ----- %%%
generate_noisydata(tripped_settings,folder_out);


%%% ----- run MFTWDFA from generated data ----- %%%
q_arr = [-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
mftwdfa_settings = {"makima",1000,q_arr};
run_mftwdfa(mftwdfa_settings,filepath_in,folder_out,varnames,data_name);


% ----- plot log-log fluctuation func, q=2 ----- %
        % interp_scheme, data_res, q
fqplot_settings = {"makima", 1000, 2};
fq_plot(folder_out,data_name,fqplot_settings);


%%% ----- do slope analysis on result ----- %%%
max_logw = 5;
bounds = {1,3};
slope_analysis(folder_out,data_name,fqplot_settings,max_logw,bounds);


% ----- Hurst exponent and singularity spectrum
makeplot = 1;
hurst_settings = {"makima",1000,q_arr};

h_arr = hurst_exp(folder_out, data_name, hurst_settings, bounds, makeplot);
sing_spectrum(q_arr, h_arr, folder_out, data_name, hurst_settings, bounds, makeplot);
