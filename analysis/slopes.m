%% ===== DETECT SLOPE CHANGES ===== %%

function [tavg_arr,slope_arr] = slopes(interp_scheme,q,data_res,frac_data,result_folder)

    % Read in data, generate file name 
    [t_arr,f_arr] = read_data(interp_scheme,data_res,q,frac_data,result_folder);

    % Make arrays to hold slopes and avg s values
    slopelen = length(t_arr)-3;
    slope_arr = zeros(slopelen,1);
    tavg_arr = zeros(slopelen,1);
    
    t_arr = log10(t_arr);
    f_arr = log10(f_arr);
    
    for i=1:slopelen
        
        % Find values of s and F_q on either side of interval
        t1 = t_arr(i);
        t2 = t_arr(i+2);
        f1 = f_arr(i);
        f2 = f_arr(i+2);
        
        % Calculate slope
        slope_arr(i) = ( f2 - f1 )/( t2 - t1 );
        
        % Store s of middle of interval
        tavg_arr(i) = (t1+t2)/2.0;
           
    end

end