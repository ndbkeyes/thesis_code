function plot_overlay(obj,Y,M)

    % plot original data and averaged (year,month) matrix
    hold on;
    [matrix_x,matrix_y,~,mean_y] = data2matrix(obj,Y,M);
    Y_length = (max(obj.X) - min(obj.X)) / Y;
    X_min = min(obj.X);
    for y=1:Y
        for m=1:M
            scatter(matrix_x(y,m),matrix_y(y,m));
        end
        xline(X_min + Y_length*y);  % plot vertical lines marking the years!
    end
    disp(mean_y);
    plot(obj.X,obj.Y - mean_y);
    [xx,yy] = interpolate(obj.X,obj.Y,Y*M*20,"makima");
    plot(xx,yy-mean_y);

end