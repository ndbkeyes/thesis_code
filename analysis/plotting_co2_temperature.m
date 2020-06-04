filename = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3_deut-temp_2007_DATA.txt";
A = readtable(filename);
A = A(13:end,:);    % data above 13th bag all have NaN temperature readings
% create age and temp arrays from table & plot
age = cell2mat(table2cell(A(:,{'Age'})));
temp = cell2mat(table2cell(A(:,{'Temperature'})));
X_temp = flip(age) * -1;
Y_temp = flip(temp);

data = importdata("C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\data\epica\edc3\EPICA_800kyr_age+co2.txt");
% Get age and co2 data - correct time by flipping all & making age negative
X_co2 = flip(data.data(:,1)) * -1;
Y_co2 = flip(data.data(:,2));

close all;

layout = tiledlayout(2,1);

nexttile
plot(X_temp,Y_temp*10+150,"-o");
title("Temperature (Deuterium proxy) EPICA Dome C record");
xlim([-8.1*10^5,100]);
xlabel("Time (years before 1950)");
ylabel("Temperature anomaly (deg C, compared to 1950)");

nexttile
plot(X_co2,Y_co2,"-o","Color","red");
title("CO2 EPICA Dome C EDC3 record");
xlim([-8.1*10^5,100]);
xlabel("Time (years before 1950)");
ylabel("CO_2 concentration (ppm)");

saveas(gcf,"C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\co2_temp_data_plot.fig");
close all;


data_res = 5000;
interp_scheme = "makima";
[X_interp, Y_interp] = interpolate(X_temp, Y_temp, data_res, interp_scheme);
plot(X_interp, Y_interp);