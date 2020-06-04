% Find H(q) data set from q_arr and the F(q) file corresponding to the current settings

clear all;
close all;

hold on;

q_arr = [20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-20];
frac_data = 1;
mkr_size = 2;


scheme = ["makima","spline"];
res = [1000,5000];
colors = [[1, 0, 0]; [0.1, 0.9, 0.1]; [0.4, 0.7, 1]; [0.5, 0.1, 0.5]];

lowerbound = 4.0;
upperbound = 4.5;
data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\co2\";

for i=1:length(scheme)
    for j=1:length(res)
        index = (i-1)*length(res) + j;
        h_arr = hurst_exp(q_arr, scheme(i), res(j), frac_data, lowerbound, upperbound, data_folder);
        plot(q_arr, h_arr, "LineWidth", mkr_size, "Color", colors(index,:));
    end
end


for i=1:length(scheme)
    for j=1:length(res)
        index = (i-1)*length(res) + j;
        h_arr = hurst_exp(q_arr, scheme(i), res(j), frac_data, lowerbound, upperbound, data_folder);
        scatter(q_arr, h_arr, mkr_size*5, colors(index,:), "filled");
    end
end


title("Hurst exponent as a function of q for EPICA Dome-C carbon dioxide record");
xlabel("q");
ylabel("H(q)");
legend("makima, 1000 points", "makima, 5000 points", "spline, 1000 points", "spline, 5000 points");
ylim([1,2.5]);


