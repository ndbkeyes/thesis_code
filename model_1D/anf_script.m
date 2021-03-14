close all;
clc;

% make data object
[obj_arr, mset_arr] = make_objs();
obj_co2 = obj_arr{1};
disp("object made");

% set number of "years" and "months" to divide data into
Y = 30;
M = 30;
d = 3;

%%


% run findanf, plot results
[a_final,N,f,P_final,a,P] = findanf_epica(obj_co2,Y,M,d);
hold on;
plot(a_final);
plot(P_final);
plot(N/10000);

figure(2);
plot(f);

figure(3);
plot(a);
plot(P);




%
% % plot data, interpolation, and year/month averaged matrix
% plot_overlay(obj_co2,Y,M);
% 
% % plot b
% b_plot(obj_co2,Y,M);
% 
% % plot data series for each month
% month_plotting(obj_co2,Y,M);



%%

% figuring out which d best satisfies condition???
% d = 3;
% hold on;
% for M=10:5:30
%     [a,N,f,P] = findanf_epica(obj_co2,Y,M,d);
%     plot(linspace(1,10,M+1),a);
% end
% legend("10","15","20","25","30");


%%

