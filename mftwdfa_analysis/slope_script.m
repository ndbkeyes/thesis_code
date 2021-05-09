clear all;
close all;
warning('off','all')

% make all 3 EPICA data objects: CO2, CH4, temperature
[obj_arr, mset_arr] = make_objs();


% plot slope, curvature, and stdev on one plot per dataset

increments_LHS = {0.05,1};
bounds_LHS = {{3,5},{2.7,5},{2,5}};
increments_RHS = {0.05,0.5};
bounds_RHS = {5.1,5.7};
increments_stdev = {0.02,0.5};
bounds_stdev = {{3,5.7},{2.7,5.7},{2,5.7}};

for j=1:3
    figure(j);
    hold on;
    [p1,p2,~,~] = slope_curvature(obj_arr{j}, mset_arr{j},increments_LHS,bounds_LHS{j});
    [p3,p4,~,~] = slope_curvature(obj_arr{j}, mset_arr{j},increments_RHS,bounds_RHS);
    p5 = slope_stdev(obj_arr{j}, mset_arr{j}, increments_stdev, bounds_stdev{j});
    yline(0);
    title(sprintf("Slope analysis for %s dataset",obj_arr{j}.data_name));
    xlabel("avg timescale of slope section");
    saveas(gcf, sprintf("%sepica-compare_slope-ALL_%s.fig",obj_arr{1}.figs_compare,obj_arr{j}.data_name));
    subset = [p1,p2,p5];
    legend(subset,'smoothed slope','curvature of slope','stdev of slope subsegments');
    saveas(gcf,sprintf("%s_slopes.jpeg",obj_arr{j}.data_name));
end