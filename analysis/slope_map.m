function [lb_bounds, ub_bounds, slope_matrix] = slope_map(obj, mftwdfa_settings, increment, mag_range, makeplot)
%
% FUNCTION: slope_map(obj, mftwdfa_settings, increment, mag_range, makeplot)
%
% PURPOSE: create a 2D colormap/contour plot/3D surface of the slope of MFTWDFA fluctuation
% function with a range of lower & upper bounds, to help identify what
% bounds to use
%
% INPUT:
% - obj: DataSet object to get data and info from
% - mftwdfa_settings: array of MFTWDFA settings for which to analyze slopes -- cell array in form {interp_scheme, data_res, q}
% - increment: increment between adjacent lower/upper slope bound values used in
% the contour plot
% - mag_range: minimum different between upper and lower slope bounds
% - makeplot: integer (0-3) that dictates whether/how the results are plotted
%
% OUTPUT:
% - lb_bounds, ub_bounds: arrays of lower & upper log(t) bounds used to find the slopes in the plot
% - slope_matrix: matrix of slope values for corresponding pairs of (lower bound, upper bound)
%


    % if only 4 args, don't plot
    if nargin == 4
        makeplot = 0;
    end
    
    % unpack MFTWDFA settings
    interp_scheme = mftwdfa_settings{1};
    data_res = mftwdfa_settings{2};
    q = mftwdfa_settings{3};
    
    % read in MFTWDFA fluct func, calculate arrays of lower & upper bound values to run with
    [t_arr, ~] = read_data(obj,mftwdfa_settings);
    lb_bounds = round(min(log10(t_arr))-increment*2,1) : increment : round(max(log10(t_arr))-mag_range,1);
    ub_bounds = round(min(log10(t_arr))+mag_range,1) : increment : round(max(log10(t_arr)+increment*2),1);

    slope_matrix = [];

    
    % loop thru arrays of lower and upper log(t) bounds and find the slope using avg_slope for each pair
    for i=1:length(lb_bounds)
        for j=1:length(ub_bounds)

            if ub_bounds(j) >= lb_bounds(i) + mag_range
                slope_bounds = {lb_bounds(i), ub_bounds(j)};
                s = avg_slope(obj,mftwdfa_settings,slope_bounds);
            else
                s = NaN;
            end

            slope_matrix(j,i) = s;

        end
    end

    
    % make the requested type of plot
    
    if makeplot == 1
        
        contourf(lb_bounds,ub_bounds,slope_matrix,100);
        
    elseif makeplot == 2
        
        hold on;
        contourf(lb_bounds,ub_bounds,slope_matrix,100);
       
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
    
    
    % add plot labels & save figures
    
    if makeplot ~= 0
        
        axis("xy");
        xlabel("X: lower bound");
        ylabel("Y: upper bound");
        title(sprintf("Slope & gradient plot for MFTWDFA on %s",obj.data_name));

        saveas(gcf,sprintf("%s%s_slopemap%d_%s-%d-%d.fig",obj.folder_out,obj.data_name,makeplot,interp_scheme,data_res,q));
        saveas(gcf,sprintf("%s%s_slopemap%d_%s-%d-%d.png",obj.folder_out,obj.data_name,makeplot,interp_scheme,data_res,q));
        
    end

end