function fq_plot_compare(data_folder,data_name)


    % ===== MAKE Fq COMPARISON PLOT (q=2) ===== %
    hold on;
    q = 2;
    frac_data = 1;
    for interp_scheme=["makima","spline"]
        for data_res=[1000,5000]
            [t_arr,f_arr] = read_data(interp_scheme,data_res,q,frac_data,data_folder);
            plot(log10(t_arr),log10(f_arr));
        end
    end
    lgd = legend("makima 1000", "makima 5000", "spline 1000", "spline 5000");
    title(sprintf("F_2(t) comparison over all four runs - %s", data_name));
    xlabel("log_{10} t");
    ylabel("log_{10}F_2(t)");
    lgd.Location = 'Southeast';
    
    saveas(gcf,sprintf("%sfq_compare_plot.fig",data_folder));
    
    
end