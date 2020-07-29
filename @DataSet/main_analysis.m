function main_analysis(obj,mftwdfa_settings)


    if nargin == 5
        bounds_rhs = {};
    end
    
    scheme_arr = mftwdfa_settings{1};
    res_arr = mftwdfa_settings{2};
    q_arr = mftwdfa_settings{3};


    % ----- slope analysis ----- %
    max_logw = 5;
    slope_settings = {scheme_arr, res_arr, 2};
    avg_slope_left = slope_analysis(obj,slope_settings,max_logw,obj.bounds_lhs);
    fprintf("avg slope left: %.3f\n", avg_slope_left);
    
    % if there's rhs bounds, do rhs analysis as well
    if ~isempty(obj.bounds_rhs)
        avg_slope_right = slope_analysis(obj,slope_settings,max_logw,obj.bounds_rhs);
        fprintf("avg slope right: %.3f\n", avg_slope_right);
    end
    
%     % also do full 32-win plot for Run 1 (q=2 obvi)
%     slope_settings = {scheme_arr(1), res_arr(1), 2};
%     bounds_all = {obj.bounds_lhs{1},obj.bounds_rhs{2}};
%     logw = {4,4};
%     slope_analysis(obj.folder_out,obj.data_name,slope_settings,logw,bounds_all);

    

    % ----- Compare quantities over different settings ----- %
    for lbl = ["fluctq","fluct2"]
        compare_analysis(obj,lbl,mftwdfa_settings);
    end
    for lbl = ["hurst","singspec"]
        compare_analysis(obj,lbl,mftwdfa_settings,obj.bounds_lhs);
        if ~isempty(obj.bounds_rhs)
            compare_analysis(obj,lbl,mftwdfa_settings,obj.bounds_rhs);
        end
    end

    %opt_model = fluct_dist(obj.filepath_in,obj.folder_out,obj.varnames,obj.data_name);

end



