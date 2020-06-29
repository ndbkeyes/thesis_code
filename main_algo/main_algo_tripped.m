close all;
warning('off','all')


%%% ----- settings for generating tripped data ----- %%%
                % type of walk, threshold, walk length
tripped_settings = {"trippedwalk",15,3000};
data_name = sprintf("%s-%d-%d",tripped_settings{1},tripped_settings{2},tripped_settings{3});
folder_out = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\tripped\";
filepath_in = strcat(folder_out,data_name,"_data.txt");
varnames = {'Var1', 'Var2'};
read_settings = {};


%%% ----- settings for MFTWDFA ----- %%

scheme_arr = ["makima"];
res_arr = [1000];
q_arr = [-20,-15,-10,-5,-2,-1,1,2,5,10,15,20]; % range of q values to run with
mftwdfa_settings = {scheme_arr,res_arr,q_arr};


run_mftwdfa(mftwdfa_settings,filepath_in,folder_out,varnames,data_name);


bounds = {1,3};
main_analysis(filepath_in,folder_out,varnames,data_name,bounds,{});