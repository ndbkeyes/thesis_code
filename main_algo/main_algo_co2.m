close all;
warning('off','all')


% ----- SETTINGS FOR INPUT ----- %
filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_co2_DATA-series3-composite.txt";
varnames = {'Age_yrBP_','CO2_ppmv_'};
read_settings = {};


% ----- SETTINGS FOR OUTPUT ----- %
data_name = "co2";
folder_out = strcat("C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\",data_name,"\");
bounds_lhs = {3.5,4.75};
bounds_rhs = {5.1,5.6};


% ----- RUN ANALYSIS ----- %
% main_analysis(filepath_in,folder_out,varnames,data_name,bounds_lhs,bounds_rhs);
% compare_interpscheme(filepath_in, varnames, read_settings);