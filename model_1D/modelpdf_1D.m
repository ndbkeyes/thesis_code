function modelpdf_1D(obj,sim_n_sample,br_win)

    close all;
    hold on;

    % unpack data into arrays
    data_y = obj.y_arr;
    data_y
    
    % make array of x-values for PDFs
    xi = 2.5*floor(min(data_y)) : 0.5 : 2*ceil(max(data_y));

    % set bandwidth for kernel smoothed PDF
    % bw = 5;

    % find and plot ks-PDFs for data and sample sim
    [pdf_data,~] = ksdensity(data_y,xi);%,'Bandwidth',bw);
    [pdf_sim,~] = ksdensity(sim_n_sample,xi);%,'Bandwidth',bw);
    
    figure(1);
    hold on;
    plot(xi,pdf_data,'Color','blue','LineWidth',1.5);
    plot(xi,pdf_sim,'Color','red','LineWidth',1.5);
    title("PDFs of data & sample simulation");
    legend("data PDF","sample simulation PDF");    
    
    
    % get 1D model coefficients
    anf = findanf_epica(obj);
    
    
    % number of model runs
    n_runs = 500;
    
    % empty arrays for loop quantities
    pdf_avgsim = zeros(1,length(xi));
    means_sim = zeros(1,n_runs);
    stds_sim = zeros(1,n_runs);
    skews_sim = zeros(1,n_runs);
    means_data = zeros(1,n_runs);
    stds_data = zeros(1,n_runs);
    skews_data = zeros(1,n_runs);

    
    %% run simulation multiple times and get & plot PDFs and summary stats
    figure(2);
    hold on;
    
    for i=1:n_runs
        
        % simulate a 1D model run
        [~, sim_n] = epica_sim1D(obj,anf,br_win);
        % get kernel-smoothed PDF for that run
        [pdf_sim,~] = ksdensity(sim_n,xi);%,'Bandwidth',bw);

        % plot run's PDF
        plot(xi,pdf_sim,'Color',[0.85 0.85 0.85],'LineWidth',0.3);
        % add run's PDF to average sim PDF
        pdf_avgsim = pdf_avgsim + pdf_sim;

        % find summary stats of run
        means_sim(i) = mean(sim_n);
        stds_sim(i) = std(sim_n);
        skews_sim(i) = skewness(sim_n);
        

        % bootstrap the original data
        fake_data = datasample(data_y,length(data_y),'Replace',true);
        means_data(i) = mean(fake_data);
        stds_data(i) = std(fake_data);
        skews_data(i) = skewness(fake_data);
        

    end
    
    

    %% summary stats

    % get PDFs of data, average sim, and fit Gaussian
    [pdf_data,~] = ksdensity(data_y,xi);%,'Bandwidth',bw);
    pdf_avgsim = pdf_avgsim / n_runs;
    ynorm = normpdf(xi,mean(data_y),std(data_y));%,'Bandwidth',bw);
    
    
    % get summary stats of data and simulation
    mean_data = mean(data_y);
    std_data = std(data_y);
    skew_data = skewness(data_y);
    
    
%     mean_avgsim = mean(pdf_avgsim);
%     std_avgsim = std(pdf_avgsim);
    skew_avgsim = skewness(pdf_avgsim);
    
    mean_avgsim = sum(xi .* pdf_avgsim);
    std_avgsim = sqrt( sum( pdf_data .* (xi - mean_avgsim).^2 ) );
    % skew_avgsim = skewness(pdf_avgsim);
    
    % print comparison of summary stats
    fprintf("\tdata summary stats\tavgsim summary stats\nmean:\t\t%.3f\t\t\t%.3f\nstd:\t\t%.3f\t\t\t%.3f\nskew:\t\t%.3f\t\t\t%.3f\n",mean_data,mean_avgsim,std_data,std_avgsim,skew_data,skew_avgsim);
    

    %% plot real, average-simulated, and Gaussian PDFs
    hold on;
    h1 = plot(xi,pdf_data,'Color','blue','LineWidth',1.5);
    h2 = plot(xi,pdf_avgsim,'Color','red','LineWidth',1.5);
    h3 = plot(xi,ynorm,'Color','black');
    legend([h1 h2 h3], "data PDF","average simulated PDF","Gaussian PDF");
    title("PDF comparison");
    
    
    

    %% plot distributions of summary stats for simulations & bootstrapped data
    
    figure(3);
    tiledlayout("flow");
    
    %%% Plot mean distributions
    nexttile
    hold on;
    [means_pdf_data, xi_pdf] = ksdensity(means_data);
    plot(xi_pdf,means_pdf_data,'Color','blue');
    [means_pdf_sim, xi_pdf] = ksdensity(means_sim);
    plot(xi_pdf,means_pdf_sim,'Color','red');
    title("Distributions of means");
    legend("data (bootstrapped)","simulations");

    %%% Plot standard deviation distributions
    nexttile
    hold on;
    [stds_pdf_data, xi_pdf] = ksdensity(stds_data);
    plot(xi_pdf,stds_pdf_data,'Color','blue');
    [stds_pdf_sim, xi_pdf] = ksdensity(stds_sim);
    plot(xi_pdf,stds_pdf_sim,'Color','red');
    title("Distributions of standard deviations");
    legend("data (bootstrapped)","simulations");

    %%% Plot skewness distributions
    nexttile
    hold on;
    [skews_pdf_data, xi_pdf] = ksdensity(skews_data);
    plot(xi_pdf,skews_pdf_data,'Color','blue');
    [skews_pdf_sim, xi_pdf] = ksdensity(skews_sim);
    plot(xi_pdf,skews_pdf_sim,'Color','red');
    title("Distributions of skewnesses");
    legend("data (bootstrapped)","simulations");


end