function main_analysis(obj,mftwdfa_settings,normed)
    
    % unpack settings
    scheme_arr = mftwdfa_settings{1};
    res_arr = mftwdfa_settings{2};
    q_arr = mftwdfa_settings{3};
    
    % print abt whether normalized
    if normed
        disp("Fq NORMALIZED");
    else
        disp("Fq /not/ NORMALIZED");
    end


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
    
    
    % ----- fluct2 compare plots ----- %
    obj.normed = 0;
    fluct2_compare(obj,mftwdfa_settings);
    obj.normed = 1;
    fluct2_compare(obj,mftwdfa_settings);
    
    
    
    % ----- slope map ----- %
    inc = 0.1;
    mag_range = 0.25;
    mftwdfa_settings = {"makima",obj.data_res,2};
    obj.normed = 1;
    slope_map(obj,mftwdfa_settings,inc,mag_range,2);
    
    
    
    
%     % also do full 32-win plot for Run 1 (q=2 obvi)
%     slope_settings = {scheme_arr(1), res_arr(1), 2};
%     bounds_all = {obj.bounds_lhs{1},obj.bounds_rhs{2}};
%     logw = {4,4};
%     slope_analysis(obj.folder_out,obj.data_name,slope_settings,logw,bounds_all);

    
    % ----- Compare quantities over different settings ----- %
%     for lbl = ["fluctq","fluct2"]
%         compare_analysis(obj,lbl,mftwdfa_settings);
%     end
%     for lbl = ["hurst","singspec"]
%         compare_analysis(obj,lbl,mftwdfa_settings,obj.bounds_lhs);
%         if ~isempty(obj.bounds_rhs)
%             compare_analysis(obj,lbl,mftwdfa_settings,obj.bounds_rhs);
%         end
%     end

    
end



