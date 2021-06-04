function modelpdf_2D(obj1,obj2,Y,M,sim_n1_sample,sim_n2_sample,br_win)

   
    
    close all;


    % unpack data into arrays
    [~,matrix_y1,~] = data2matrix(obj1,Y,M,br_win);
    [~,matrix_y2,~] = data2matrix(obj2,Y,M,br_win);
    data_y1 = reshape(matrix_y1',[],1);
    data_y2 = reshape(matrix_y2',[],1);
    
    % make array of x-values for PDFs
    bound = floor(min(min(data_y1),min(data_y2)));
    xi =  1.5*bound : 0.5 : -1.5*bound;

    % set bandwidth for kernel smoothed PDF
    % bw = 5;

    % find and plot ks-PDFs for data and sample sim
    [pdf_data1,~] = ksdensity(data_y1,xi);%,'Bandwidth',bw);
    [pdf_sim1,~] = ksdensity(sim_n1_sample,xi);%,'Bandwidth',bw);
    [pdf_data2,~] = ksdensity(data_y2,xi);%,'Bandwidth',bw);
    [pdf_sim2,~] = ksdensity(sim_n2_sample,xi);%,'Bandwidth',bw);
    
    
    figure(1);
    hold on;
    plot(xi,pdf_data1,'Color','blue','LineWidth',1.5);
    plot(xi,pdf_sim1,'Color','red','LineWidth',1.5);
    title("1) PDFs of data & sample simulation");
    legend("data PDF","sample simulation PDF");  
    
    figure(2);
    hold on;
    plot(xi,pdf_data2,'Color','blue','LineWidth',1.5);
    plot(xi,pdf_sim2,'Color','red','LineWidth',1.5);
    title("2) PDFs of data & sample simulation");
    legend("data PDF","sample simulation PDF");  
    
    
    
    
    % get 1D model coefficients
    abN = coupling_2D(obj1,obj2,Y,M,br_win);
    
    % number of model runs
    n_runs = 500;
    
    % empty arrays for loop quantities
    pdf_avgsim1 = zeros(1,length(xi));
    means_sim1 = zeros(1,n_runs);
    stds_sim1 = zeros(1,n_runs);
    skews_sim1 = zeros(1,n_runs);
    means_data1 = zeros(1,n_runs);
    stds_data1 = zeros(1,n_runs);
    skews_data1 = zeros(1,n_runs);
    pdf_avgsim2 = zeros(1,length(xi));
    means_sim2 = zeros(1,n_runs);
    stds_sim2 = zeros(1,n_runs);
    skews_sim2 = zeros(1,n_runs);
    means_data2 = zeros(1,n_runs);
    stds_data2 = zeros(1,n_runs);
    skews_data2 = zeros(1,n_runs);

    
    %% run simulation multiple times and get & plot PDFs and summary stats
   
    for i=1:n_runs
        
        % simulate a 1D model run
        [~, sim_n1, sim_n2] = epica_sim2D(obj1,obj2,Y,M,abN,br_win);
        % get kernel-smoothed PDF for that run
        [pdf_sim1,~] = ksdensity(sim_n1,xi);%,'Bandwidth',bw);
        [pdf_sim2,~] = ksdensity(sim_n2,xi);%,'Bandwidth',bw);
        % add run's PDF to average sim PDF
        pdf_avgsim1 = pdf_avgsim1 + pdf_sim1;
        pdf_avgsim2 = pdf_avgsim2 + pdf_sim2;

        figure(3);
        hold on;
        % plot run's PDF
        plot(xi,pdf_sim1,'Color',[0.85 0.85 0.85],'LineWidth',0.3);

        figure(4);
        hold on;
        % plot run's PDF
        plot(xi,pdf_sim2,'Color',[0.85 0.85 0.85],'LineWidth',0.3);
        
        

        % find summary stats of run
        means_sim1(i) = mean(sim_n1);
        stds_sim1(i) = std(sim_n1);
        skews_sim1(i) = skewness(sim_n1);
        means_sim2(i) = mean(sim_n2);
        stds_sim2(i) = std(sim_n2);
        skews_sim2(i) = skewness(sim_n2);
        

        % bootstrap the original data
        fake_data1 = datasample(data_y1,length(data_y1),'Replace',true);
        fake_data2 = datasample(data_y2,length(data_y2),'Replace',true);
        means_data1(i) = mean(fake_data1);
        stds_data1(i) = std(fake_data1);
        skews_data1(i) = skewness(fake_data1);
        means_data2(i) = mean(fake_data2);
        stds_data2(i) = std(fake_data2);
        skews_data2(i) = skewness(fake_data2);
        

    end
    
    

    %% summary stats

    % get PDFs of data, average sim, and fit Gaussian
    [pdf_data1,~] = ksdensity(data_y1,xi);%,'Bandwidth',bw);
    [pdf_data2,~] = ksdensity(data_y2,xi);%,'Bandwidth',bw);
    pdf_avgsim1 = pdf_avgsim1 / n_runs;
    pdf_avgsim2 = pdf_avgsim2 / n_runs;
    ynorm1 = normpdf(xi,mean(data_y1),std(data_y1));%,'Bandwidth',bw);
    ynorm2 = normpdf(xi,mean(data_y2),std(data_y2));%,'Bandwidth',bw);
    
    
    % get summary stats of data and simulation
    mean_data1 = mean(data_y1);
    std_data1 = std(data_y1);
    skew_data1 = skewness(data_y1);
    mean_data2 = mean(data_y2);
    std_data2 = std(data_y2);
    skew_data2 = skewness(data_y2);
    
    
%     mean_avgsim = mean(pdf_avgsim);
%     std_avgsim = std(pdf_avgsim);
    skew_avgsim1 = skewness(pdf_avgsim1);
    skew_avgsim2 = skewness(pdf_avgsim1);
    
    mean_avgsim1 = sum(xi .* pdf_avgsim1);
    std_avgsim1 = sqrt( sum( pdf_data1 .* (xi - mean_avgsim1).^2 ) );
    mean_avgsim2 = sum(xi .* pdf_avgsim2);
    std_avgsim2 = sqrt( sum( pdf_data2 .* (xi - mean_avgsim2).^2 ) );
    % skew_avgsim = skewness(pdf_avgsim);
    
    % print comparison of summary stats
    fprintf("\tdata (1) summary stats\tavgsim summary stats\nmean:\t\t%.3f\t\t\t%.3f\nstd:\t\t%.3f\t\t\t%.3f\nskew:\t\t%.3f\t\t\t%.3f\n",mean_data1,mean_avgsim1,std_data1,std_avgsim1,skew_data1,skew_avgsim1);
    fprintf("\tdata (2) summary stats\tavgsim summary stats\nmean:\t\t%.3f\t\t\t%.3f\nstd:\t\t%.3f\t\t\t%.3f\nskew:\t\t%.3f\t\t\t%.3f\n",mean_data2,mean_avgsim2,std_data2,std_avgsim2,skew_data2,skew_avgsim2);

    %% plot real, average-simulated, and Gaussian PDFs
    figure(3);
    hold on;
    h1 = plot(xi,pdf_data1,'Color','blue','LineWidth',1.5);
    h2 = plot(xi,pdf_avgsim1,'Color','red','LineWidth',1.5);
    h3 = plot(xi,ynorm1,'Color','black');
    legend([h1 h2 h3], "data PDF","average simulated PDF","Gaussian PDF");
    title("1) PDF comparison");
    
    
    figure(4);
    hold on;
    h1 = plot(xi,pdf_data2,'Color','blue','LineWidth',1.5);
    h2 = plot(xi,pdf_avgsim2,'Color','red','LineWidth',1.5);
    h3 = plot(xi,ynorm2,'Color','black');
    legend([h1 h2 h3], "data PDF","average simulated PDF","Gaussian PDF");
    title("2) PDF comparison");
    
    
    

    %% plot distributions of summary stats for simulations & bootstrapped data
    
    figure(5);
    tiledlayout(2,3);
    
    %%% Plot mean distributions
    nexttile
    hold on;
    [means_pdf_data1, xi_pdf1] = ksdensity(means_data1);
    plot(xi_pdf1,means_pdf_data1,'Color','blue');
    [means_pdf_sim1, xi_pdf1] = ksdensity(means_sim1);
    plot(xi_pdf1,means_pdf_sim1,'Color','red');
    title("Distributions of means");

    %%% Plot standard deviation distributions
    nexttile
    hold on;
    [stds_pdf_data1, xi_pdf1] = ksdensity(stds_data1);
    plot(xi_pdf1,stds_pdf_data1,'Color','blue');
    [stds_pdf_sim1, xi_pdf1] = ksdensity(stds_sim1);
    plot(xi_pdf1,stds_pdf_sim1,'Color','red');
    title("Distributions of standard deviations");

    %%% Plot skewness distributions
    nexttile
    hold on;
    [skews_pdf_data1, xi_pdf1] = ksdensity(skews_data1);
    plot(xi_pdf1,skews_pdf_data1,'Color','blue');
    [skews_pdf_sim1, xi_pdf1] = ksdensity(skews_sim1);
    plot(xi_pdf1,skews_pdf_sim1,'Color','red');
    title("Distributions of skewnesses");
    
    
    
    
    
    
    
    
    %% plot distributions of summary stats for simulations & bootstrapped data
    
    %%% Plot mean distributions
    nexttile
    hold on;
    [means_pdf_data2, xi_pdf2] = ksdensity(means_data2);
    plot(xi_pdf2,means_pdf_data2,'Color','blue');
    [means_pdf_sim2, xi_pdf2] = ksdensity(means_sim2);
    plot(xi_pdf2,means_pdf_sim2,'Color','red');
    title("Distributions of means");

    %%% Plot standard deviation distributions
    nexttile
    hold on;
    [stds_pdf_data2, xi_pdf2] = ksdensity(stds_data2);
    plot(xi_pdf2,stds_pdf_data2,'Color','blue');
    [stds_pdf_sim2, xi_pdf2] = ksdensity(stds_sim2);
    plot(xi_pdf2,stds_pdf_sim2,'Color','red');
    title("Distributions of standard deviations");

    %%% Plot skewness distributions
    nexttile
    hold on;
    [skews_pdf_data2, xi_pdf2] = ksdensity(skews_data2);
    plot(xi_pdf2,skews_pdf_data2,'Color','blue');
    [skews_pdf_sim2, xi_pdf2] = ksdensity(skews_sim2);
    plot(xi_pdf2,skews_pdf_sim2,'Color','red');
    title("Distributions of skewnesses");
    
    lgd = legend("bootstrapped data","simulations");
    lgd.Layout.Tile = 'South'; % <-- Legend placement with tiled layout


end