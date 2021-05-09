function pdf_hist(fighandle,matrix_y,sim_y,name)

    figure(fighandle);
    close all;

    data_y = reshape(matrix_y',[],1);

    % make PDF histograms of averaged data & simulation
    hold on;
    minmin = min(min(data_y),min(sim_y));
    maxmax = max(max(data_y),max(sim_y));
    diff = (maxmax - minmin) / 20;
    bins = minmin:diff:maxmax;
    histogram(data_y,bins,'FaceAlpha',0.25,'EdgeAlpha',0);
    histogram(sim_y,bins,'FaceAlpha',0.3,'EdgeAlpha',0);
    legend("interp data","sim");
    title(sprintf("PDF of data & sim of %s",name));
    hold off;


end