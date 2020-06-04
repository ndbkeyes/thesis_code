close all;
warning('off','all')

filename = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_ch4_DATA.txt";
data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\ch4\";
cutoff = 1;
Xvarname = 'Var2';
Yvarname = 'Var3';
data_name = "CH_4";

% run_mftwdfa(filename,Xvarname,Yvarname,cutoff,data_folder);
fq_plot_compare(data_folder,data_name);