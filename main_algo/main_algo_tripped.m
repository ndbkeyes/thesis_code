close all;
warning('off','all')

% ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
series_type = "trippedwalk";
N = 3000;
threshold = 30;
data_name = sprintf("path_%s-%d-%d",series_type,N,threshold);
folder_out = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\tripped\";

% ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
filepath_in = strcat(folder_out,data_name,"_data.txt");
Xvarname = 'Var1';
Yvarname = 'Var2';



%%% run MFTWDFA by getting files that were written out to
run_mftwdfa(filepath_in,folder_out,Xvarname,Yvarname,data_name);

%%% plot log-log fluctuation function for q=2
        % interp_scheme, data_res, q
settings = {"makima", 1000, 2};
filepath_out = mftwdfa_filepath(folder_out,data_name,settings); % constructing the FULL filepath of output file
[t_arr, f_arr] = read_data(filepath_out);
scatter(log10(t_arr),log10(f_arr));