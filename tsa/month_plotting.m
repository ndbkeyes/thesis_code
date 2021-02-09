function month_plotting(obj,Y,M)

    [matrix_x,matrix_y,~,~] = data2matrix(obj,Y,M);
    
    hold on;
    for m=1:M
        month_data = zeros(Y,2);
        for y=1:Y
            month_data(y,1) = matrix_x(y,m);
            month_data(y,2) = matrix_y(y,m);
        end
        plot(month_data(:,1),month_data(:,2));
    end
    
end