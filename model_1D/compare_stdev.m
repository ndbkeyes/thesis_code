function compare_stdev(data_y,sim_y,Y,M,win)

    if nargin == 4
        win = 0;
    end

    data_y = reshape(data_y,Y,M);
    sim_y = reshape(sim_y(1:end-1),Y,M);
    
    
    sd_data = zeros(1,M);
    sd_sim = zeros(1,M);
    for k=1:M
        summ_data = 0;
        summ_sim = 0;
        for j=1:Y
            summ_data = summ_data + data_y(j,k)^2;
            summ_sim = summ_sim + sim_y(j,k)^2;
        end
        sd_data(k) = sqrt(summ_data);
        sd_sim(k) = sqrt(summ_sim);
    end
    
    if win ~= 0
        sd_data = smooth_periodic(sd_data,win);
        sd_sim = smooth_periodic(sd_sim,win);
    end
    
    hold on;
    plot(sd_data,'black');
    plot(sd_sim,'red');
    legend("data sd", "sim sd");
    title("Monthly standard deviation");

end

