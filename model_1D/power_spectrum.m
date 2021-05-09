function [xF,F] = power_spectrum(obj,col)
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

    if nargin == 1
        col = 'black';
    end
    
    res = obj.data_res*2;
    [xx,yy] = interpolate(obj.X, obj.Y, res, "makima");
    
    tgap = range(obj.X) / res;
    n = length(xx);

    F = fft(yy);
    F = abs(F).^2 / n;

    xF = [0:n-1] * 1/(n*tgap);

    %nexttile;
    plot(xF,F,'Color',col);
    %xlim([0.5*10^(-5),10*10^(-5)]);
    xlabel("frequency");
    ylabel("power");
    title(sprintf("Power spectrum of %s dataset",obj.data_name));
    
end