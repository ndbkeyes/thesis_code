%%% Profile: convert noiselike data to walklike profile via cumulative summation
function p = prof(y)

    % X needs to be interpolated data
    p = zeros(length(y),1);
    avg = mean(y);
    
    for i=1:length(y)
        cumsum_i = sum(y(1:i)) - avg*i;
        p(i) = cumsum_i;
    end    

end