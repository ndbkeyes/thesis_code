
function fq_plot(fig,interp_scheme,data_res,q,frac_data)




%%%% ===== GENERATE FQ PLOT ===== %%%%


    % Read in data, generate file name 
    [t_arr,f_arr] = read_data(interp_scheme,data_res,q,frac_data);
    fq_img_name = result_filename("FQPLOT.fig",interp_scheme,data_res,q,frac_data);

    % Create figure and axes
    fig = figure;
    ax1 = axes;
    ax2 = axes('Position',ax1.Position);

    %%% AXES 1: Plot slope lines
    fig.CurrentAxes = ax1;
    hold on;
    x = 0:10:10^6;
    y = x;
    white = plot(x,0.5*y,'color',[0.6 0.6 0.6],'Parent',ax1);
    pink = plot(x,y,'color',[1 0.5 0.4],'Parent',ax1);
    red = plot(x,1.5*y,'color',[1 0 0],'Parent',ax1);
    set(ax1,'XTick',[], 'YTick', []);        % Remove axes tick marks

    %%% AXES 2: Plot F_q
    fig.CurrentAxes = ax2;
    hold on;
    % Plot F_q vs. t on log log scale
    fq = scatter(log10(t_arr),log10(f_arr),'filled');

    % Set up ax2
    xlim([2, 6]);
    ylim([0,4.5]);
    xlabel('log t (years)');
    ylabel('log F_q');
    
    t = sprintf('Fluctuation Function: interp = %s, q = %d, datares = %d',interp_scheme, q,data_res);
    title(t);
    set(ax2,'color','none');
    lgd = legend([fq; white; pink; red], ["F_q", "White: H=0.5","Pink: H=1","Red: H=1.5"]);
    lgd.Location = 'Northwest';
        
    saveas(gcf, fq_img_name);
    
    
    
end




