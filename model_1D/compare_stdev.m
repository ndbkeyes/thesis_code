function compare_stdev(data_y,sim_y,Y,M)

    data_y = reshape(data_y,Y,M);
    sim_y = reshape(sim_y(1:end-1),Y,M);
    
    
    sd_data = zeros(M,1);
    sd_sim = zeros(M,1);
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
    
    hold on;
    plot(sd_data,'black');
    plot(sd_sim,'red');
    legend("data sd", "sim sd");

end

