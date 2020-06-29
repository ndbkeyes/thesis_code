function main_analysis(filepath_in,folder_out,varnames,data_name,settings,bounds_lhs,bounds_rhs)


    if nargin == 5
        bounds_rhs = {};
    end
    
    scheme_arr = settings{1};
    res_arr = settings{2};
    q_arr = settings{3};


    % ----- slope analysis ----- %
    max_logw = 5;
    slope_settings = {scheme_arr, res_arr, 2};
    avg_slope_left = slope_analysis(folder_out,data_name,slope_settings,max_logw,bounds_lhs);
    fprintf("avg slope left: %.3f\n", avg_slope_left);
    
    % if there's rhs bounds, do rhs and "full" analysis as well
    if ~isempty(bounds_rhs)
        avg_slope_right = slope_analysis(folder_out,data_name,slope_settings,max_logw,bounds_rhs);
        fprintf("avg slope right: %.3f\n", avg_slope_right);
        
        slope_settings = {scheme_arr(1), res_arr(1) ,2};
        bounds_all = {bounds_lhs{1},bounds_rhs{2}};
        slope_analysis(folder_out,data_name,slope_settings,max_logw,bounds_all);
        
    end

    

    % ----- Compare quantities over different settings ----- %
    for lbl = ["fluctq","fluct2"]
        compare_analysis(lbl,folder_out,data_name,settings);
    end
    for lbl = ["hurst","singspec"]
        compare_analysis(lbl,folder_out,data_name,settings,bounds_lhs);
        if ~isempty(bounds_rhs)
            compare_analysis(lbl,folder_out,data_name,settings,bounds_rhs);
        end
    end

    opt_model = fluct_dist(filepath_in,folder_out,varnames,data_name)

end



