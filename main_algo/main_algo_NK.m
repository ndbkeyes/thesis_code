clear all;
close all;
warning('off','all')


%% make object for each dataset
data_names = ["epica-co2", "epica-ch4", "epica-temp"];
user_id = "NK";
normed = 0;
obj_arr = {};
mset_arr = {};
for j=1:length(data_names)
    obj_arr{j} = DataSet(user_id, data_names(j), normed);
    mset_arr{j} = {"makima", 10000, 2};
end




%% plot slope subsegment standard deviation
bounds = {3,6};
mag_range = 0.6;
increments = {0.1, 0.05};
hold on;
for j=1:3
    slope_stdev(obj_arr{j}, mset_arr{j}, bounds, mag_range, increments);
end
title(sprintf("Standard deviation within slope segments\nfor MFTWDFA fluctuation func on EPICA data (co2, ch4, temp)"));
legend("epica-co2", "epica-ch4", "epica-temp");
annotation('textbox', [0.5, 0.2, 0.1, 0.1], 'String', sprintf('size of (A) slope segments: %.2f\nsize of (B) sub-segments: %.2f',mag_range,increments{2}));
saveas(gcf, sprintf("%sepica-compare_slope-stdev.fig",obj_arr{1}.figs_compare));
