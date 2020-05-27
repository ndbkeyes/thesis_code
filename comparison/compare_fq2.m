clear all;
close all;

hold on;

q = 2;
frac_data = 1;
scheme = ["makima","spline"];
res = [1000,5000];
colors = [[1, 0, 0]; [0.1, 0.9, 0.1]; [0.4, 0.7, 1]; [0.5, 0.1, 0.5]];

for i=1:length(scheme)
    for j=1:length(res)
        index = (i-1)*length(res) + j;
        [t_arr,f_arr] = read_data(scheme(i),res(j),2,frac_data);
        plot(log10(t_arr),log10(f_arr), "Color",colors(index,:), "LineWidth",2);
    end
end


legend("Run 1: Modified Akima, 1000 points", "Run 2: Modified Akima, 5000 points", "Run 3: Spline, 1000 points","Run 4: Spline, 5000 points");