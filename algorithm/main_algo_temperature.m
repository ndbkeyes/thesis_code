%% ===== IMPORT DATA ===== %%

close all;
warning('off','all')

filename = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\data\epica\edc3\edc3_deut-temp_2007_DATA.txt";

A = readtable(filename);
A = A(13:end,:);    % data above 13th bag all have NaN temperature readings

% create age and temp arrays from table & plot
age = cell2mat(table2cell(A(:,{'Age'})));
temp = cell2mat(table2cell(A(:,{'Temperature'})));
X = flip(age) * -1;
Y = flip(temp);
% plot(X,Y);
% xlim([min(X),0]);


%% ===== SET PARAMETERS ===== %%
s_res = 100;                % number of values of s to run with
% interp_scheme = "makima";
% data_res = 5000;
frac_data = 1;
q_arr = [-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
q = 2;

data_folder = "C:\Users\Nash\Dropbox\_NDBK\research\mftwdfa\results\temperature\";

saveas(gcf,strcat(data_folder,"epica_temperature_data.fig"));
close all;


%% ===== RUN MFTWDFA ALGORITHM ===== %%

% hold on;
% 
% for interp_scheme=["makima","spline"]
%     for data_res=[1000,5000]
%         for q=q_arr
%             % run algo and plotting    
%             [t_arr,f_arr] = mftwdfa(X, Y, s_res, interp_scheme, data_res, q, frac_data, data_folder);
%             fprintf("\n%s, %d, q=%d run complete\n", interp_scheme, data_res, q);
%             if q == 2
%                 plot(log10(t_arr),log10(f_arr), "-o");
%             end
%         end
%     end
% end


%% ===== MAKE Fq COMPARISON PLOT (q=2) ===== %%
hold on;
for interp_scheme=["makima","spline"]
    for data_res=[1000,5000]
        [t_arr,f_arr] = read_data(interp_scheme,data_res,q,frac_data,data_folder);
        plot(log10(t_arr),log10(f_arr));
    end
end
legend("makima 1000", "makima 5000", "spline 1000", "spline 5000");
title("F_2(t) comparison over all four runs - Temperature");
xlabel("log_{10} t");
ylabel("log_{10}F_2(t)");