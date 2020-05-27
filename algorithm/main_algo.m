%% ===== IMPORT DATA ===== %%

close all;
warning('off','all')

% Import & display data
data = importdata("C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\data\epica\epica_domec\EPICA_800kyr_age+co2.txt");
  
% Get age and co2 data - correct time by flipping all & making age negative
X = flip(data.data(:,1)) * -1;
Y = flip(data.data(:,2));


%% ===== SET PARAMETERS ===== %%


s_res = 100;                % number of values of s to run with
interp_scheme = "makima";
data_res = 5000;
frac_data = 1;
q_arr = [-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\ALL_DATA\";



%% ===== RUN MFTWDFA ALGORITHM ===== %%
% only need to do once for each set of parameters

for i=1:length(q_arr)
    
    % run algo and plotting    
    mftwdfa(X, Y, s_res, interp_scheme, data_res, q_arr(i), frac_data, data_folder);
    fprintf("\nq = %d run complete: %d / %d \n", q_arr(i), i, length(q_arr));

end






