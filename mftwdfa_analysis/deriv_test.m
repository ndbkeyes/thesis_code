obj = deriv_obj("NK", "epica-co2");
mset_arr = {"makima",obj.data_res,2};
[s,F] = read_data(obj,mset_arr);
plot(log10(s),log10(F));

power_spectrum(obj);




increments_LHS = {0.05,1};
bounds_LHS = {3.2,4.9};
increments_RHS = {0.05,0.5};
bounds_RHS = {5.1,5.7};
increments_stdev = {0.03,0.5};
bounds_stdev = {3.2,5.7};

close all;


hold on;
% slope_curvature(obj, mset_arr,increments_LHS,bounds_LHS);
% slope_curvature(obj, mset_arr,increments_RHS,bounds_RHS);
slope_curvature(obj, mset_arr,increments_stdev, bounds_stdev);
slope_stdev(obj, mset_arr,increments_stdev, bounds_stdev);
yline(0);
title(sprintf("Slope analysis for %s dataset",obj.data_name));
xlabel("avg timescale of slope section");
saveas(gcf, sprintf("%sepica-compare_slope-ALL_%s.fig",obj.figs_compare,obj.data_name));