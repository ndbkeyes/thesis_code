function [xF,F] = power_spectrum(obj)
%
% FUNCTION: [xF, F] = power_spectrum(obj)
%
% PURPOSE: get power spectrum of data from obj dataset
%
% INPUT: - obj: DataSet to analyze
%
% OUTPUT: 
% - xF: frequency values for which we've found the power
% - F: power spectrum values
%
%%
    
    [xx,yy] = interpolate(obj.X, obj.Y, obj.data_res, "makima");
    
    tgap = range(obj.X) / obj.data_res;
    n = length(xx);

    F = fft(yy);
    F = abs(F).^2 / n;

    xF = [0:n-1] * 1/(n*tgap);

    nexttile;
    plot(xF,F);
    xlim([0.5*10^(-5),6*10^(-5)]);
    xlabel("frequency");
    ylabel("power");
    title(sprintf("Power spectrum of %s dataset",obj.data_name));
    
end