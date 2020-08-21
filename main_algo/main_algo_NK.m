clear all;
close all;
warning('off','all')


%% make object for each dataset

data_names = ["co2", "ch4", "temperature"];
user_id = "NK";
normed = 0;

obj_arr = {};
mset_arr = {};

for j=1:length(data_names)
    obj_arr{j} = DataSet(user_id, data_names(j), normed);
    mset_arr{j} = {"makima", obj_arr{j}.data_res, 2};
end




%% plot slope subsegment standard deviation

bounds = {2,6};
mag_range = 1;
increments = {0.1, 0.05};
slope_stdev(obj_arr{1}, mset_arr{1}, bounds, mag_range, increments);

