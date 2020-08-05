function [lb_bounds, ub_bounds, slope_matrix] = slope_map(obj, mftwdfa_settings, increment, mag_range, makeplot)

    if nargin == 4
        makeplot = 0;
    end
    
    interp_scheme = mftwdfa_settings{1};
    data_res = mftwdfa_settings{2};
    q = mftwdfa_settings{3};
    
    [t_arr, ~] = read_data(obj,mftwdfa_settings);
    lb_bounds = round(min(log10(t_arr))-increment*2,1) : increment : round(max(log10(t_arr))-mag_range,1);
    ub_bounds = round(min(log10(t_arr))+mag_range,1) : increment : round(max(log10(t_arr)+increment*2),1);

    slope_matrix = [];

    for i=1:length(lb_bounds)
        for j=1:length(ub_bounds)
            
            % fprintf("%.1f, %.1f\n", lb_bounds(i), ub_bounds(j));

            if ub_bounds(j) >= lb_bounds(i) + mag_range
                slope_bounds = {lb_bounds(i), ub_bounds(j)};
                s = avg_slope(obj,mftwdfa_settings,slope_bounds);
            else
                s = NaN;
            end

            slope_matrix(j,i) = s;

            % fprintf("(%d,%d): %.4f\n", i, j, s);

        end
    end

    if makeplot == 1
        contourf(lb_bounds,ub_bounds,slope_matrix,100);
        
    elseif makeplot == 2
        
        hold on;
        contourf(lb_bounds,ub_bounds,slope_matrix,100);
%         [Fx, Fy] = gradient(slope_matrix, increment);
%         plt = quiver(lb_bounds,ub_bounds,Fx,Fy);
%         plt.Color = "red";
        
        xpltarr = 2:increment:6;
        plot(xpltarr, xpltarr);
        plot(xpltarr,xpltarr +1);
        plot(xpltarr,xpltarr +1.5);
        
        yline(max(ub_bounds)-increment*2);
        xline(min(lb_bounds)+increment);
        xlim([min(lb_bounds)-increment,max(lb_bounds)+increment]);
        ylim([min(ub_bounds)-increment,max(ub_bounds)+increment]);
        
        hold off
        
    elseif makeplot == 3
        surf(lb_bounds,ub_bounds,slope_matrix);
        
    end
    
    if makeplot ~= 0
        
        axis("xy");
        xlabel("X: lower bound");
        ylabel("Y: upper bound");
        title(sprintf("Slope & gradient plot for MFTWDFA on %s",obj.data_name));

        saveas(gcf,sprintf("%s%s_slopemap%d_%s-%d-%d.fig",obj.folder_out,obj.data_name,makeplot,interp_scheme,data_res,q));
        saveas(gcf,sprintf("%s%s_slopemap%d_%s-%d-%d.png",obj.folder_out,obj.data_name,makeplot,interp_scheme,data_res,q));
        
    end

end