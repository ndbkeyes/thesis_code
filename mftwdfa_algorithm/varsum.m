function v = varsum(nu,s,N,P_interp,yhat)
%
% FUNCTION: varsum(nu,s,N,Y_interp,yhat)
%
% PURPOSE: for a given MFTWDFA window, find the variance of the data from the weighted fit
%
% INPUT: 
% - nu: index of the window for which the variance is being calculated
% - s: size of the windows (i.e. the timescale under examination)
% - N: total number of points
% - P_interp: profile of the interpolated time series
% - yhat: point-by-point weighted linear regression fit to the data in the window
%
% OUTPUT:
% - v: the computed variance of the nu'th window of size s
%


    v = 0;
    Ns = floor(N/s);
      
    % up profile
    if nu <= Ns
        for i=1:s
            index = (nu - 1)*s + i;
            v = v + ( P_interp(index) - yhat(index) )^2;
        end
    
    % down profile
    else 
        for i=1:s
            index = N - (nu - Ns)*s + i;
            v = v + ( P_interp(index) - yhat(index) )^2;
        end
    end
    
    % normalize sum
    v = 1/s * v;
        
end