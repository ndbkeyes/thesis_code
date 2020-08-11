function compare_analysis(obj,quantity,settings,bounds)
%
% FUNCTION: compare_analysis(quantity,folder_out,data_name,settings)
%
% PURPOSE: compare types of plots over different ranges of settings
%
% INPUT:
% - quantity: name of the quantity to compare plots of
% - folder_out: path of folder in which MFTWDFA data is stored
% - obj.data_name: name of data being analyzed
% - settings: cell array of sets of MFTWDFA settings to compare
%
% OUTPUT:
% no returns - generates plot of desired quantity comparison
% (saves .fig to folder_out and .png to results file (hardcoded))
%

    % validate bounds input
    if nargin == 3
        bounds = {};
        if ~ismember(quantity,["fluctq","fluct2"])
            disp("improper inputs - this quantity requires bounds");
        end
    end

    % prepare for plotting
    close all;
    hold on;
    mkr_size = 1;
    colors = [[1, 0, 0]; [0.1, 0.9, 0.1]; [0.4, 0.7, 1]; [0.5, 0.1, 0.5]];
    
    
    % unpack MFTWDFA settings array
    scheme_arr = settings{1};
    res_arr = settings{2};
    q_arr = settings{3};

    
    % Plot fluctuation functions over different q but same settings
    if strcmp(quantity,"fluctq")
        
        scheme = scheme_arr(1);
        res = res_arr(1);
        
        q_arr = [-20, -10, -5, -2, 2, 5, 10, 20];
        
        % loop over q values
        for q=q_arr
            fqplot_settings = {scheme,res,q};
            [t_arr, f_arr] = read_data(obj,fqplot_settings);
            plot(log10(t_arr), log10(f_arr), "LineWidth", mkr_size);
        end
        
        % generate legend for all values of q
        legend_text = {};
        for i=1:length(q_arr)
            legend_text{i} = sprintf("q=%d",q_arr(i));    
        end

        title(sprintf("Fluctuation function comparison over settings - %s",obj.data_name));
        xlabel("log(t)");
        ylabel("log(F_2)");
        lgd = legend(legend_text);
        lgd.Location = "southeast";
        
        if ismember(obj.data_name,["co2","ch4","temperature"])
            xlim([2,6]);
            ylim([-2,4]);
        end
        
    end
    
    
    
    % build legend for comparison plots
    lgd_arr = {};
    for i=1:length(scheme_arr)
        for j=1:length(res_arr)
            index = (i-1)*length(res_arr) + j;
            lgd_arr{index} = sprintf("%s, %d points", scheme_arr(i), res_arr(j));
        end
    end
    

    % loop over MFTWDFA settings
    for i=1:length(scheme_arr)
        for j=1:length(res_arr)


            % get index of plot (for color purposes)
            index = (i-1)*length(res_arr) + j;

            % get settings for this iteration
            settings = {scheme_arr(i),res_arr(j),q_arr};


            % Plot fluctuation functions for q=2 over different settings
            if strcmp(quantity,"fluct2")

                settings{3} = 2;
                [t_arr, f_arr] = read_data(obj,settings);
                plot(log10(t_arr), log10(f_arr), "LineWidth", mkr_size, "Color", colors(index,:));

                title(sprintf("Fluctuation function (q=2) comparison - %s",obj.data_name));
                xlabel("log(t)");
                ylabel("log(F_2)");
                
                
                lgd = legend(lgd_arr);
                lgd.Location = "southeast";
                
                if ismember(obj.data_name,["co2","ch4","temperature"])
                    xlim([2,6]);
                    ylim([-2,4]);
                end
                

            % Plot Hurst exponent curves
            elseif strcmp(quantity,"hurst")

                h_arr = hurst_exp(obj, settings, bounds);
                plot(q_arr, h_arr, "-*", "LineWidth", mkr_size, "Color", colors(index,:));

                title(sprintf("Hurst exponent H(q) comparison - %s\n(log(t) = %.2f-%.2f)",obj.data_name,bounds{1},bounds{2}));
                xlabel("q");
                ylabel("H(q)");
                legend(lgd_arr);
                xlim([-20.5,20.5]);
                ylim([0,2.6]);
                


            % Plot singularity spectrum curves
            elseif strcmp(quantity,"singspec")

                h_arr = hurst_exp(obj, settings, bounds);
                [alpha_arr, D_arr] = sing_spectrum(q_arr, h_arr, obj, settings, bounds);
                plot(alpha_arr, D_arr, "-*", "LineWidth", mkr_size, "Color", colors(index,:));

                title(sprintf("Singularity spectrum comparison - %s\n(log(t) = %.2f-%.2f)",obj.data_name,bounds{1},bounds{2}));
                xlabel("\alpha");
                ylabel("f(\alpha)");
                lgd = legend(lgd_arr);
                lgd.Location = "Southwest";
                xlim([-0.25,2.5]);
                ylim([-0.5,1.25]);

            end


        end
    end
    
    if isempty(bounds)
        fig_filename = sprintf("%s%s_%s-compare.fig",obj.folder_out,obj.data_name,quantity);
    else
        fig_filename = sprintf("%s%s_%s-compare_%.2f-%.2f.fig",obj.folder_out,obj.data_name,quantity,bounds{1},bounds{2});
    end
    saveas(gcf,fig_filename);          
end













