close all;
warning('off','all');





% ===== LOAD DATA ===== %


obj_arr = make_objs();
X1 = obj_arr{1}.X;
Y1 = obj_arr{1}.Y;
X2 = obj_arr{2}.X;
Y2 = obj_arr{2}.X;
X3 = obj_arr{3}.X;
Y3 = obj_arr{3}.X;




% ===== SETTINGS & INIT ARRAYS ===== %

DIM = 2;
n_windows = 80;
interp_res = 2000;

a1_arr = cell(n_windows);
a2_arr = cell(n_windows);
a3_arr = cell(n_windows);

b12_arr = cell(n_windows);
b13_arr = cell(n_windows);
b21_arr = cell(n_windows);
b23_arr = cell(n_windows);
b31_arr = cell(n_windows);
b32_arr = cell(n_windows);



% ===== LOOP THRU WINDOWS ===== %

for i=1:n_windows
    
    
    if DIM == 2
        
        [data1_arr, increment] = split_data( X1,Y1, n_windows);
        [data2_arr, ~] = split_data( X2,Y2, n_windows);
    
        x1 = data1_arr{1,i};
        y1 = data1_arr{2,i};
        x2 = data2_arr{1,i};
        y2 = data2_arr{2,i};

        [a1, a2, b12, b21] = coupling_2D(obj_arr{1}, obj_arr{2}, interp_res);

        a1_arr{i} = a1;
        a2_arr{i} = a2;
        b12_arr{i} = b12;
        b21_arr{i} = b21;
    
    
    elseif DIM == 3
        
        [data1_arr, increment] = split_data( X1,Y1, n_windows);
        [data2_arr, ~] = split_data( X2,Y2, n_windows);
        [data3_arr, ~] = split_data( X3,Y3, n_windows);
        
        x1 = data1_arr{1,i};
        y1 = data1_arr{2,i};
        x2 = data2_arr{1,i};
        y2 = data2_arr{2,i};
        x3 = data3_arr{1,i};
        y3 = data3_arr{2,i};

        [a1, a2, a3, b12, b13, b21, b23, b31, b32] = coupling_3D(obj_arr{1},obj_arr{2},obj_arr{3}, interp_res);

        a1_arr{i} = a1;
        a2_arr{i} = a2;
        a3_arr{i} = a3;
        b12_arr{i} = b12;
        b13_arr{i} = b13;
        b21_arr{i} = b21;
        b23_arr{i} = b23;
        b31_arr{i} = b31;
        b32_arr{i} = b32;
    
    
    end
    
end


% ===== PLOT RESULTS ===== %

result_folder = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\coupling\";

increment_coords = -800000:increment:-1;
disp(length(increment_coords));


if DIM == 2

    hold on;
    plot(increment_coords,cell2mat(a1_arr));
    plot(increment_coords,cell2mat(b12_arr));
    plot(increment_coords,cell2mat(a1_arr)-cell2mat(b12_arr));
    legend("a1","b12", "a1-b12");
    title(sprintf("stability & coupling: %s (coupled to %s)", obj_arr{1}.data_name, obj_arr{2}.data_name));
    xlim([-800000-increment,0]);
    saveas(gcf, sprintf("coupling2d_%s-%s_%d-%d.jpeg", obj_arr{1}.data_name, obj_arr{2}.data_name, n_windows, interp_res));


    close all;
    hold on;
    plot(increment_coords,cell2mat(a2_arr));
    plot(increment_coords,cell2mat(b21_arr));
    plot(increment_coords,cell2mat(a2_arr)-cell2mat(b21_arr));
    legend("a2","b21", "a2-b21");
    title(sprintf("stability & coupling: %s (coupled to %s)", obj_arr{1}.data_name, obj_arr{2}.data_name));
    xlim([-800000-increment,0]);
    saveas(gcf, sprintf("coupling2d_%s-%s_%d-%d.jpeg", obj_arr{2}.data_name, obj_arr{1}.data_name, n_windows, interp_res));



elseif DIM == 3
    
    % (1)
    hold on;
    plot(increment_coords,cell2mat(a1_arr));
    plot(increment_coords,cell2mat(b12_arr));
    plot(increment_coords,cell2mat(b13_arr));
    plot(increment_coords,cell2mat(a1_arr)-cell2mat(b12_arr));
    plot(increment_coords,cell2mat(a1_arr)-cell2mat(b13_arr));
    legend("a1","b12", "b13", "a1-b12", "a1-b13");
    title(sprintf("stability & coupling: %s (coupled to [2] %s and [3] %s)", obj_arr{1}.data_name, obj_arr{2}.data_name, obj_arr{3}.data_name));
    xlim([-800000-increment,0]);
    saveas(gcf, sprintf("coupling2d_%s-%s+%s_%d-%d.fig", obj_arr{1}.data_name, obj_arr{2}.data_name, obj_arr{3}.data_name, n_windows, interp_res));
    saveas(gcf, sprintf("coupling2d_%s-%s+%s_%d-%d.png", obj_arr{1}.data_name, obj_arr{2}.data_name, obj_arr{3}.data_name, n_windows, interp_res));
    
    % (2)
    close all;
    hold on;
    plot(increment_coords,cell2mat(a2_arr));
    plot(increment_coords,cell2mat(b21_arr));
    plot(increment_coords,cell2mat(b23_arr));
    plot(increment_coords,cell2mat(a2_arr)-cell2mat(b21_arr));
    plot(increment_coords,cell2mat(a2_arr)-cell2mat(b23_arr));
    legend("a2","b21", "b23", "a2-b21", "a2-b23");
    title(sprintf("stability & coupling: %s (coupled to [1] %s and [3] %s)",  obj_arr{2}.data_name, obj_arr{1}.data_name, obj_arr{3}.data_name));
    xlim([-800000-increment,0]);
    saveas(gcf, sprintf("coupling2d_%s-%s+%s_%d-%d.fig", obj_arr{2}.data_name, obj_arr{1}.data_name, obj_arr{3}.data_name, n_windows, interp_res));
    saveas(gcf, sprintf("coupling2d_%s-%s+%s_%d-%d.png", obj_arr{2}.data_name, obj_arr{1}.data_name, obj_arr{3}.data_name, n_windows, interp_res));
    
    % (3)
    close all;
    hold on;
    plot(increment_coords,cell2mat(a3_arr));
    plot(increment_coords,cell2mat(b31_arr));
    plot(increment_coords,cell2mat(b32_arr));
    plot(increment_coords,cell2mat(a3_arr)-cell2mat(b31_arr));
    plot(increment_coords,cell2mat(a3_arr)-cell2mat(b32_arr));
    legend("a3","b31", "b32", "a3-b31", "a3-b32");
    title(sprintf("stability & coupling: %s (coupled to [1] %s and [2] %s)", obj_arr{3}.data_name, obj_arr{1}.data_name, obj_arr{2}.data_name));
    xlim([-800000-increment,0]);
    saveas(gcf, sprintf("coupling2d_%s-%s+%s_%d-%d.fig", obj_arr{3}.data_name, obj_arr{1}.data_name, obj_arr{2}.data_name, n_windows, interp_res));
    saveas(gcf, sprintf("coupling2d_%s-%s+%s_%d-%d.png", obj_arr{3}.data_name, obj_arr{1}.data_name, obj_arr{2}.data_name, n_windows, interp_res));
    
    
end

