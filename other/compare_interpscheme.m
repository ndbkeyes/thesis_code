function compare_interpscheme(filepath_in, varnames, read_settings)

    [X,Y] = load_data(filepath_in, varnames, read_settings);

    fprintf("number of data points: %d\n", length(X));

    % Create arrays of interpolated data
    data_res = opt_res(filepath_in,varnames,read_settings);
    fprintf("estimated optimal resolution: %d\n", data_res);

    [X_1,Y_1] = interpolate(X,Y,data_res,"makima");
    [X_2,Y_2] = interpolate(X,Y,5000,"makima");

    % Plot both interpolations and the original data
    close all;
    hold on;
    plot(X_1, Y_1, "LineWidth", 2, "color", "green");
    plot(X_2, Y_2, "LineWidth", 2, "Color", "red");
    scatter(X,Y, 20, "filled", "blue");
    legend("opt res", "5000", "original data");
    xlim([-825000,25000]);

end