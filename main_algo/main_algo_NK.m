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


%% plot slope stdev over different slope segments for each dataset

hold on;
for j=1:3
    
    increment = 0.05;
    bounds_avg = [];
    stdevs = [];
    i = 1;
    
    for lb = 2.2 : 0.1 : 5.5
        ub = lb + 0.6;
        bounds = {lb, ub};
        v = slope_stdev(obj_arr{j}, mset_arr{j}, bounds, increment);
        bounds_avg(i) = (lb + ub)/2;
        stdevs(i) = v;
        i = i + 1;
    end
    
    plot(bounds_avg,stdevs);
    
end

legend("co2 slope stdev", "ch4 slope stdev", "temperature slope stdev");


