%% ===== SET PARAMS! ===== %%

s_res = 100;                % number of values of s to run with
interp_scheme = "spline";
data_res = 5000;
frac_data = 1;
q_arr = [-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
q = 2;

max_e = 3;

% generate legend for all values of q
legend_text = {};
for i=1:length(q_arr)
    legend_text{i} = sprintf("q=%d",q_arr(i));    
end

data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\ALL_DATA\";

for interp_scheme=["makima","spline"]
    for data_res=[1000,5000]
        slopes_regression(interp_scheme,q,data_res,frac_data,data_folder,max_e,3.5,4.5);
    end
end


for interp_scheme=["makima","spline"]
    for data_res=[1000,5000]
        slopes_regression(interp_scheme,q,data_res,frac_data,data_folder,max_e,4.75,5.5);
    end
end
