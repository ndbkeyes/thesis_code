clear all;
close all;

hold on;

% Import & display data
data = importdata("C:\Users\Nash\Dropbox\_NDBK\KALE\research\mftwdfa\data\epica\epica_domec\EPICA_800kyr_age+co2.txt");
  
% Get age and co2 data - correct time by flipping all & making age negative
X = flip(data.data(:,1)) * -1;
Y = flip(data.data(:,2));

data_res = 5000;




% Create arrays of interpolated data
[X_makima,Y_makima] = interpolate(X,Y,data_res,"makima");
[X_spline,Y_spline] = interpolate(X,Y,data_res,"spline");

plot(X_spline, Y_spline, "LineWidth", 2, "color", "green");
plot(X_makima, Y_makima, "LineWidth", 2, "Color", "red");
scatter(X,Y, 20, "filled", "blue");

legend("Spline", "Modified Akima", "Original data");