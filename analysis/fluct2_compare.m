function fluct2_compare(obj,settings)

    % plot F_2(t)
    close all;
    hold on;
    
    scheme_arr = settings{1};
    res_arr = settings{2};
    q_arr = settings{3};
    
    if obj.normed == 0
        normed_tag = "_NOT-normed";
    else
        normed_tag = "_normed";
    end
    
    for scheme=scheme_arr
        for res=res_arr
            mftwdfa_settings = {scheme,res,2};
            [t_arr, f_arr] = read_data(obj,mftwdfa_settings);
            plot(log10(t_arr), log10(f_arr));
        end
    end
    
    lgd = legend("makima datares/2", "makima datares", "spline datares/2", "spline datares");
    lgd.Location = "southeast";
    xlabel("log_{10} t");
    if obj.normed
        title(sprintf("Fluctuation function (q=2) comparison, NORMALIZED - %s", obj.data_name));
        ylabel("log_{10} F_2(t)_{normed}");
    else
        title(sprintf("Fluctuation function (q=2) comparison, /NOT/ NORMALIZED - %s", obj.data_name));
        ylabel("log_{10} F_2(t)_{not normed}");
    end
    
    fig_filename = sprintf("%s%s_fluct2-compare%s.fig",obj.folder_out,obj.data_name,normed_tag);
    saveas(gcf, fig_filename);
    
end