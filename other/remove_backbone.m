function remove_backbone(obj,Y,M,m,nf)
%
% FUNCTION: remove_backbone(obj,Y,M,m)
%
% PURPOSE: subtract the moving-average mean from object's data, interpolated
% data, and simulation; and compare the PDFs of the resulting noise
%
% INPUT: 
% - obj: DataSet object for the data you want to use
% - Y: number of "years" (sectors) to divide data into
% - M: number of "months" (subsections) to divide "years" into
%
% OUTPUT: no return, but generates a bunch of plots of f, noise, 
% integral of f
%
%%
    
    if nargin == 4
        nf = 1;
    end
    
    win_size = M;
    
    % remove backbone from original data
    data_br = obj.Y - movmean(obj.Y,win_size);
    % data_br = data_br / std(data_br);
    
    
    % remove backbone from interpolated data
    [data_x,interp_data] = interpolate(obj.X,obj.Y,Y*M,"makima");
    interp_br = interp_data - movmean(interp_data,win_size);
    % interp_br = interp_br / std(interp_br);

    
    % remove backbone from simulation
    [sim_x,sim_y] = epica_sim1D(obj,Y,M,m,nf);
    sim_br = sim_y - movmean(sim_y,win_size);
    % sim_br = sim_br / std(sim_br);
    %sim_br = sim_y - f_scaled;
    
    
    % do stuff with f(tau)
    [~,~,f,~] = findanf_epica(obj,Y,M,m);
    f_x = linspace(-Y,-1,Y) * range(obj.X) / Y + range(obj.X)/Y;
    f_sum = cumsum(f) * max(obj.Y)/max(cumsum(f));
    f_interp = makima(f_x,f_sum,sim_x);
    f_scaled = ( f_interp - mean(f_interp) ) / std(f_interp) * std(interp_data);
    
    
    
    %% do stats and stuff
    
    
    std_interp = zeros(M,1);
    for k=1:M
        summ = 0;
        for j=1:Y
            index = (j-1) + M*(k-1) + 1;
            summ = summ + interp_br(index) * interp_br(index);
        end
        std_interp(k) = sqrt(summ / (Y-1));
    end


    std_sim = zeros(M,1);
    for k=1:M
        summ = 0;
        for j=1:Y
            index = (j-1) + M*(k-1) + 1;
            summ = summ + sim_br(index) * sim_br(index);
        end
        std_sim(k) = sqrt(summ / (Y-1));
    end


    

    
    %% make plots
    
    % plot scaled version of f over interpolated & simulated data
    close all;
    figure(1);
    hold on;
    plot(sim_x,f_scaled);
    plot(obj.X,obj.Y - obj.data_mean);
    plot(sim_x,sim_y);
    legend("f scaled","original data","simulated data");
    
    % plot data, interpolated data, and simulation with background removed
    figure(2);
    hold on;
    plot(obj.X,data_br);
    plot(data_x,interp_br);
    plot(sim_x,sim_br);
    legend("data w/ background removed","interp w/ background removed","sim w/ background removed");
    
    % make histogram of PDF for noise of data, interpolated data, simulation w/ background removed
    figure(3);
    hold on;
    histogram(data_br);
    histogram(interp_br);
    histogram(sim_br);
    legend("data noise histogram","interp noise histogram","simulation noise histogram");
    
    % plot integral of f (backbone) for different Y values
    figure(4);
    hold on;
    for Y=[20,52,100,200]
        [~,~,f,~] = findanf_epica(obj,Y,M,m);
        f_x = linspace(-Y,-1,Y) * range(obj.X) / Y + range(obj.X)/Y;
        plot(f_x,cumsum(f));
    end
    legend("Y=20","Y=52","Y=100","Y=200");
    
    
    % plot stdev of noise data
    figure(5);
    hold on;
    plot(std_interp);
    plot(std_sim);
    legend("interpolated noise stdev","simulated noise stdev");

    
end