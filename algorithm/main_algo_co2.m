%% ===== IMPORT DATA ===== %%
close all;
% Import & display data
data = importdata("C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\data\epica\edc3\EPICA_800kyr_age+co2.txt");
% Get age and co2 data - correct time by flipping all & making age negative
X = flip(data.data(:,1)) * -1;
Y = flip(data.data(:,2));


%% ===== SET PARAMETERS ===== %%
s_res = 100;                % number of values of s to run with
interp_scheme = "spline";
data_res = 1000;
frac_data = 1;
q_arr = [-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\co2\";



%% ===== RUN MFTWDFA ALGORITHM ===== %%
% % only need to do once for each set of parameters
% for interp_scheme=["makima","spline"]
%     for data_res=[1000,5000]
%         for q=q_arr
%             % run algo and plotting    
%             [t_arr,f_arr] = mftwdfa(X, Y, s_res, interp_scheme, data_res, q, frac_data, data_folder);
%             fprintf("\n%s, %d, q=%d run complete\n", interp_scheme, data_res,q);
%         end
%     end
% end


hold on;
% run plotting    
for interp_scheme=["makima","spline"]
    for data_res=[1000,5000]
        [t_arr,f_arr] = read_data(interp_scheme, data_res, 2, frac_data, data_folder);
        plot(log10(t_arr),log10(f_arr));
    end
end
legend("makima 1000", "makima 5000", "spline 1000", "spline 5000");
saveas(gcf,sprintf("%sS_PLOT.fig",data_folder));