close all;
hold on;

% set parameters for series
N = 1000;
threshold = 30;
series_type = "trippedwalk";

% setup for loop
x = 0;
x_arr = zeros(N,1);
n_arr = zeros(N,1);
noise = randn(N,1);

% generate random-noise time series
for n=1:N
   
    if strcmp(series_type,"trippedwalk")
        x = x + noise(n);
        if x < 0 || x > threshold
            x = 0;
        end
    elseif strcmp(series_type,"randomwalk")
        x = x + noise(n);
    elseif strcmp(series_type,"whitenoise")
        x = noise(n);
    end
    n_arr(n) = n;
    x_arr(n) = x;
    
end

% write data to file
folder = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\tripped\";
filename = sprintf("path_%s-%d-%d",series_type,N,threshold);
filepath = strcat(folder,filename);
data_in = [n_arr, x_arr];
writematrix(data_in, filepath);

% % read data out
% A = readtable(filepath);
% A = A(1:end,:);
% disp(A);
% Xvarname = 'Var1';
% Yvarname = 'Var2';
% X = cell2mat(table2cell(A(:,{Xvarname})));
% Y = cell2mat(table2cell(A(:,{Yvarname})));
% 
% % plot series
% plot(X,Y);

% run MFTWDFA by getting files that were written out to
run_mftwdfa(filepath,Xvarname,Yvarname,1,folder);

% plot log-log fluctuation function
[t_arr, f_arr] = read_tripped_data(series_type,N,threshold,input_folder);
scatter(log10(t_arr),log10(f_arr));

