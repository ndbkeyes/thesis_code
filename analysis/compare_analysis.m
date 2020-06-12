function compare_analysis(quantity,folder_out,data_name,settings)
%
% FUNCTION: compare_analysis(quantity,folder_out,data_name,settings)
%
% PURPOSE: compare types of plots over different ranges of settings
%
% INPUT:
% - quantity: name of the quantity to compare plots of
% - folder_out: path of folder in which MFTWDFA data is stored
% - data_name: name of data being analyzed
% - settings: cell array of sets of MFTWDFA settings to compare
%
% OUTPUT:
% no returns - generates plot of desired quantity comparison, saves to folder_out
%


    close all;
    hold on;

    mkr_size = 1;
    colors = [[1, 0, 0]; [0.1, 0.9, 0.1]; [0.4, 0.7, 1]; [0.5, 0.1, 0.5]];
    
    scheme_arr = settings{1};
    res_arr = settings{2};
    q_arr = settings{3};
    
    
    
    % Plot fluctuation functions over different q but same settings
    if strcmp(quantity,"fluctq")
        
        scheme = scheme_arr(1);
        res = res_arr(1);
        
        % loop over q values
        for q=q_arr
            fqplot_settings = {scheme,res,q};
            [t_arr, f_arr] = read_data(folder_out,data_name,fqplot_settings);
            plot(log10(t_arr), log10(f_arr), "LineWidth", mkr_size);
        end
        
        % generate legend for all values of q
        legend_text = {};
        for i=1:length(q_arr)
            legend_text{i} = sprintf("q=%d",q_arr(i));    
        end

        title(sprintf("Fluctuation function (q=2) comparison - %s",data_name));
        xlabel("log(t)");
        ylabel("log(F_2)");
        legend(legend_text);
        
    end
    
    
    

    % loop over MFTWDFA settings!
    for i=1:length(scheme_arr)
        for j=1:length(res_arr)


            % get index of plot (for color purposes)
            index = (i-1)*length(res_arr) + j;

            % get settings for this iteration
            settings = {scheme_arr(i),res_arr(j),q_arr};


            % Plot fluctuation functions for q=2 over different settings
            if strcmp(quantity,"fluct2")

                settings{3} = 2;
                [t_arr, f_arr] = read_data(folder_out,data_name,settings);
                plot(log10(t_arr), log10(f_arr), "LineWidth", mkr_size, "Color", colors(index,:));

                title(sprintf("Fluctuation function (q=2) comparison - %s",data_name));
                xlabel("log(t)");
                ylabel("log(F_2)");
                legend("makima, 1000 points", "makima, 5000 points", "spline, 1000 points", "spline, 5000 points");
                

            % Plot Hurst exponent curves
            elseif strcmp(quantity,"hurst")

                bounds = {4.1,4.8};

                h_arr = hurst_exp(folder_out, data_name, settings, bounds);
                plot(q_arr, h_arr, "-*", "LineWidth", mkr_size, "Color", colors(index,:));

                title(sprintf("Hurst exponent H(q) comparison - %s\n(log(t) = %.2f-%.2f)",data_name,bounds{1},bounds{2}));
                xlabel("q");
                ylabel("H(q)");
                legend("makima, 1000 points", "makima, 5000 points", "spline, 1000 points", "spline, 5000 points");


            % Plot singularity spectrum curves
            elseif strcmp(quantity,"singspec")

                bounds = {4.1,4.8};

                h_arr = hurst_exp(folder_out, data_name, settings, bounds);
                [alpha_arr, D_arr] = sing_spectrum(q_arr, h_arr, folder_out, data_name, settings, bounds);
                plot(alpha_arr, D_arr, "-*", "LineWidth", mkr_size, "Color", colors(index,:));

                title(sprintf("Singularity spectrum comparison - %s\n(log(t) = %.2f-%.2f)",data_name,bounds{1},bounds{2}));
                xlabel("\alpha");
                ylabel("f(\alpha)");
                legend("makima, 1000 points", "makima, 5000 points", "spline, 1000 points", "spline, 5000 points");

            end


        end
    end
    
    
    
    filename = sprintf("%s%s_%s-compare.fig",folder_out,data_name,quantity);
    saveas(gcf,filename);



end













