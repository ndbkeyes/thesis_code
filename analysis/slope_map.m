function slope_map(obj, mftwdfa_settings,lb_bounds, ub_bounds, increment)


    lb_arr = lb_bounds{1}:increment:lb_bounds{2};
    ub_arr = ub_bounds{1}:increment:ub_bounds{2};

    slope_matrix = [];

    for i=1:length(lb_arr)
        for j=1:length(ub_arr)

            if ub_arr(j) >= lb_arr(i) + 0.2
                slope_bounds = {lb_arr(i), ub_arr(j)};
                s = avg_slope(obj,mftwdfa_settings,slope_bounds);
            else
                s = 0;
            end

            slope_matrix(j,i) = s;

            % fprintf("(%d,%d): %.4f\n", i, j, s);

        end
    end

    surf(lb_arr,ub_arr,slope_matrix);
    axis("xy");
    xlabel("X: lower bound");
    ylabel("Y: upper bound");

end