clear all;
close all;

hold on;

% Import & display data
data = importdata("C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3-2008_co2_DATA-series3-composite.txt");
  
% Get age and co2 data - correct time by flipping all & making age negative
X = flip(data.data(:,1)) * -1;
Y = flip(data.data(:,2));

% Create arrays of interpolated data
data_res = 5000;
[X_makima,Y_makima] = interpolate(X,Y,data_res,"makima");
[X_spline,Y_spline] = interpolate(X,Y,data_res,"spline");

% Plot both interpolations and the original data
plot(X_spline, Y_spline, "LineWidth", 2, "color", "green");
plot(X_makima, Y_makima, "LineWidth", 2, "Color", "red");
scatter(X,Y, 20, "filled", "blue");
legend("Spline", "Modified Akima", "Original data");