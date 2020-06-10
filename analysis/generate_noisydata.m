close all;
hold on;


% set parameters for series
series_type = "trippedwalk";
N = 3000;
threshold = 30;                     % xi_bar

% construct data name from parameters
data_name = sprintf("path_%s-%d-%d",series_type,N,threshold);


% setup for loop
x = 0;
x_arr = zeros(N,1);
n_arr = zeros(N,1);

stdev_noise = 1;                    % < theta^2 >
noise = stdev_noise * randn(N,1);   % theta

stdev_threshold = .1 * threshold;   % r


% generate random-noise time series
for n=1:N
    if strcmp(series_type,"trippedwalk")
        x = x + noise(n);
        threshold_value = threshold + stdev_threshold*randn(1,1);   % xi = xi_bar + r
        if x < 0 || x > threshold_value
            x = 0.5*randn(1,1)+1;
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
folder_out = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\tripped\";
filepath_in = strcat(folder_out,data_name,"_data.txt");
data_in = [n_arr, x_arr];
writematrix(data_in, filepath_in);

% read data out
A = readtable(filepath_in);
A = A(1:end,:);
Xvarname = 'Var1';
Yvarname = 'Var2';
X = cell2mat(table2cell(A(:,{Xvarname})));
Y = cell2mat(table2cell(A(:,{Yvarname})));

time_scale = threshold^2 ./ stdev_noise^2;
fprintf("timescale: %d\n", time_scale);

% plot series
plot(X,Y);