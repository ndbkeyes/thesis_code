close all;
warning('off','all')

filename = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2007_temperature_DATA.txt";
data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\temperature\";
cutoff = 13;
Xvarname = 'Age';
Yvarname = 'Temperature';
data_name = "Temperature";

% run_mftwdfa(filename,Xvarname,Yvarname,cutoff,data_folder);
fq_plot_compare(data_folder,data_name);