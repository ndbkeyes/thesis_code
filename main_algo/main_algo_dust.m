close all;
warning('off','all')


% ----- SETTINGS FOR INPUT ----- %
filepath_in = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_dust_DATA-series3.txt";
varnames = {'EDC3Age_kyrBP_','LaserFPP_norm_'};
read_settings = {1,10^3};


% ----- SETTINGS FOR OUTPUT ----- %
data_name = "dust";
folder_out = strcat("C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\",data_name,"\");
bounds = {0.75,1.75};



% ----- RUN ANALYSIS (without MFTWDFA) ----- %
main_all(filepath_in,folder_out,varnames,data_name,read_settings,bounds);
