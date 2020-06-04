%% ===== SET PARAMS! ===== %%

s_res = 100;                % number of values of s to run with
interp_scheme = "makima";
data_res = 5000;
frac_data = 1;
q_arr = [-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

% generate legend for all values of q
legend_text = {};
for i=1:length(q_arr)
    legend_text{i} = sprintf("q=%d",q_arr(i));    
end

% change folder that data is coming from - USE THIS TO SWITCH BETWEEN DATA SETS!
data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\temperature\";


%% ===== GENERATE Fq FIGURES ===== %%

for i=1:length(q_arr)
    hold on;
    [t_arr,f_arr] = read_data(interp_scheme,data_res,q_arr(i),frac_data,data_folder);
    plot(log10(t_arr),log10(f_arr),'LineWidth',1);
end

% set up and save plot
lgd = legend(legend_text);
lgd.Location = 'Southeast';
title("Fluctuation function over different settings");
xlabel("log t");
ylabel("log F_q");
filename = strcat(data_folder, "fq_recent.fig");
saveas(gcf,filename);
close all;





%% ===== FIND & PLOT HURST EXPONENTS h(q) ===== %%

% Find H(q) data set from q_arr and the F(q) file corresponding to the current settings


%%% --- LEFT SLOPE SECTION: : hurst exponent & singularity spectrum


lowerbound = 4;
upperbound = 4.5;

h_arr = hurst_exp(q_arr, interp_scheme, data_res, frac_data, lowerbound, upperbound, data_folder);
scatter(q_arr,h_arr);

% set up and save plot
title("Hurst exponent vs. statistical moment q");
xlabel("q");
ylabel("h(q)");
filename = strcat(data_folder, sprintf("h(q)_recent_%.1f-%.1f.fig", lowerbound, upperbound));
saveas(gcf,filename);
close all;

% Write columns of data to file
file = sprintf("%s-%d_H(q)_%.1f-%.1f.txt",interp_scheme,data_res,lowerbound,upperbound);
filename = strcat(data_folder,file);
data = [q_arr, h_arr];
writematrix(data,filename); 

% ---

% Find and plot singularity spectrum using q and H(q)
[alpha_arr, D_arr] = sing_spectrum(q_arr, h_arr);
scatter(alpha_arr,D_arr);

% set up and save plot
title("Singularity spectrum");
xlabel("\alpha");
ylabel("f(\alpha)");
filename = strcat(data_folder, sprintf("singspec_recent_%.1f-%.1f.fig", lowerbound, upperbound));
saveas(gcf,filename);
close all;

% Write columns of data to file
file = sprintf("%s-%d_SPECTRUM_%.1f-%.1f.txt",interp_scheme,data_res, lowerbound, upperbound);
filename = strcat(data_folder,file);
data = [alpha_arr, D_arr];
writematrix(data,filename); 



%%% --- RIGHT SLOPE SECTION: hurst exponent & singularity spectrum

lowerbound = 5;
upperbound = 5.5;

h_arr = hurst_exp(q_arr, interp_scheme, data_res, frac_data, lowerbound, upperbound, data_folder);
scatter(q_arr,h_arr);

% set up and save plot
title("Hurst exponent vs. statistical moment q");
xlabel("q");
ylabel("h(q)");
filename = strcat(data_folder, sprintf("h(q)_recent_%.1f-%.1f.fig", lowerbound, upperbound));
saveas(gcf,filename);
close all;

% Write columns of data to file
file = sprintf("%s-%d_H(q)_%.1f-%.1f.txt",interp_scheme,data_res,lowerbound,upperbound);
filename = strcat(data_folder,file);
data = [q_arr, h_arr];
writematrix(data,filename); 

% ---

% Find and plot singularity spectrum using q and H(q)
[alpha_arr, D_arr] = sing_spectrum(q_arr, h_arr);
scatter(alpha_arr,D_arr);

% set up and save plot
title("Singularity spectrum");
xlabel("\alpha");
ylabel("f(\alpha)");
filename = strcat(data_folder, sprintf("singspec_recent_%.1f-%.1f.fig", lowerbound, upperbound));
saveas(gcf,filename);
close all;

% Write columns of data to file
file = sprintf("%s-%d_SPECTRUM_%.1f-%.1f.txt",interp_scheme,data_res,lowerbound, upperbound);
filename = strcat(data_folder,file);
data = [alpha_arr, D_arr];
writematrix(data,filename); 

