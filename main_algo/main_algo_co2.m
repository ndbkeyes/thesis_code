close all;
warning('off','all')

% ----- SETTINGS FOR OUTPUT: MFTWDFA ----- %
data_name = "CO2";
folder_out = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\co2\";

% ----- SETTINGS FOR INPUT: CLIMATE DATA FILE ----- %
filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_co2_DATA-series3-composite.txt";
Xvarname = 'Age_yrBP_';
Yvarname = 'CO2_ppmv_';



%%% run MFTWDFA by getting files that were written out to
% run_mftwdfa(filepath_in,folder_out,Xvarname,Yvarname,data_name);

%%% plot log-log fluctuation function
        % interp_scheme, data_res, q
settings = {"makima", 1000, 2};
filepath_out = mftwdfa_filepath(folder_out,data_name,settings); % constructing the FULL filepath of output file
[t_arr, f_arr] = read_data(filepath_out);
scatter(log10(t_arr),log10(f_arr));