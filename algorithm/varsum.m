%%% Variances: sum variances up or down profile for fluctuation function
function v = varsum(nu,s,N,Y_interp,yhat)

    v = 0;
    Ns = floor(N/s);
      
    % up profile
    if nu <= Ns
        for i=1:s
            index = (nu - 1)*s + i;
            v = v + ( Y_interp(index) - yhat(index) )^2;
        end
    
    % down profile
    else 
        for i=1:s
            index = N - (nu - Ns)*s + i;
            v = v + ( Y_interp(index) - yhat(index) )^2;
        end
    end
    
    % normalize sum
    v = 1/s * v;
        
end