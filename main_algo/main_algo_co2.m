close all;
warning('off','all')

filename = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_co2_DATA-compositeonly.txt";
data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\co2\";
cutoff = 1;
Xvarname = 'Age_yrBP_';
Yvarname = 'CO2_ppmv_';
data_name = "CO_2";

% run_mftwdfa(filename,Xvarname,Yvarname,cutoff,data_folder);
fq_plot_compare(data_folder,data_name);