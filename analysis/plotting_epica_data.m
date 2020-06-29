
% read in all the data

filename_co2 = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_co2_DATA-series3-composite.txt";
varnames_co2 = {'Age_yrBP_','CO2_ppmv_'};
[X_co2, Y_co2] = load_data(filename_co2, varnames_co2);

filename_ch4 = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_ch4_DATA.txt";
varnames_ch4 = {'Var2','Var3'};
[X_ch4, Y_ch4] = load_data(filename_ch4, varnames_ch4);

filename_temp = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2007_temperature_DATA.txt";
varnames_temp = {'Age','Temperature'};
[X_temp, Y_temp] = load_data(filename_temp, varnames_temp,13);



% set up plot

close all;
layout = tiledlayout(3,1);



% plot each series

nexttile
plot(X_co2,Y_co2,"Color","red");
title("CO_2 EDC3 record");
xlim([-8.1*10^5,100]);
xlabel("Time (years before 1950)");
ylabel("CO_2 concentration (ppm)");


nexttile
plot(X_ch4,Y_ch4,"Color","black");
title("CH_4 EDC3 record");
xlim([-8.1*10^5,100]);
xlabel("Time (years before 1950)");
ylabel("CH_4 concentration (ppm)");


nexttile
plot(X_temp,Y_temp);
title("Temperature (Deuterium proxy) EDC3 record");
xlim([-8.1*10^5,100]);
xlabel("Time (years before 1950)");
ylabel("Temperature anomaly (deg C, compared to 1950)");


set(gcf,'Position',[0,0,700,1000]);


saveas(gcf,"C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\epica_plots\ALL-DATA_plot.fig");
saveas(gcf,"C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\write-up\figures\ALL-DATA_plot.png");
