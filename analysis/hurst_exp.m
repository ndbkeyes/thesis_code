function h_arr = hurst_exp(q_arr, interp_scheme, data_res, frac_data, result_folder)

    h_arr = zeros(1,length(q_arr));

    for i=1:length(q_arr)
        
        [t_arr,f_arr] = read_data(interp_scheme,data_res,q_arr(i),frac_data, result_folder);

        % Cut down data to main slope segment
        small = find(log10(t_arr) > 3.75);
        starti = small(1);
        large = find(log10(t_arr) > 4.75);
        endi = large(1);

        x = log10(t_arr(starti:endi));
        y = log10(f_arr(starti:endi));

        % and create x matrix for linear regression
        x_matrix = [ones(endi-starti+1,1) x];

        % perform linear regression, store slope as Hurst exponent
        h = x_matrix \ y;    
        h_arr(i) = h(2);

    end

end