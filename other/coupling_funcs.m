close all;
warning('off','all');

Y = 100;
M = 20;
obj_arr = make_objs();


[sim_x, sim_n1, sim_n2] = epica_sim2D(obj_arr{1},obj_arr{2},Y,M);
hold on;
plot(sim_x,sim_n1);
plot(sim_x,sim_n2);


% coupling_2D(obj_arr{1},obj_arr{2},Y,M,1);
% coupling_3D(obj_arr{1},obj_arr{2},obj_arr{3},Y,M,1);

% hold on;
%
% for Y=10:10:100
%     
%     [a1_arr, a2_arr, a3_arr, b12_arr, b13_arr, b21_arr, b23_arr, b31_arr, b32_arr] = coupling_3D(obj_arr{1},obj_arr{2},obj_arr{3},Y,M);
%     plot(b12_arr);
%     
% end




