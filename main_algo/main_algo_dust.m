% close all;
% warning('off','all')

close all;

filename = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_dust_DATA-series3.txt";
data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\dust\";
cutoff = 1;
Xvarname = 'EDC3Age_kyrBP_';
Yvarname = 'LaserFPP_norm_';
data_name = "Dust";
scalefactor = 10^3;

% run_mftwdfa(filename,Xvarname,Yvarname,cutoff,scalefactor,data_folder);
fq_plot_compare(data_folder,data_name);

% [X,Y] = load_data(filename,Xvarname,Yvarname,cutoff,scalefactor);
% disp(X);
% plot(X,Y);
% disp("TESTING");
