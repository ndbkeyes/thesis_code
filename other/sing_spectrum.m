function [alpha_arr, D_arr] = sing_spectrum(q_arr, h_arr, obj, singspec_settings, bounds, makeplot)
%
% FUNCTION: sing_spectrum(q_arr, h_arr, obj.folder_out, obj.data_name, singspec_settings, bounds, makeplot)
%
% PURPOSE: calculate and plot singularity spectrum of dataset given that dataset's array of Hurst exponents
%
% INPUT:
% - q_arr: array of q-values (statistical moments)
% - h_arr: array of Hurst exponents calculated by hurst_exp.m, for each q-value in q_arr
% - obj
% - singspec_settings: cell array of interpolation settings used to find the Hurst exponents
%                      form: {interp_scheme, data_res}
% - bounds: cell array of lower and upper slope bounds used for Hurst calculation
% - makeplot: controls whether function makes & saves plot of h_arr vs. q_arr -- OPTIONAL, default = false
%
% OUTPUT: (need to refresh myself on significance)
% - alpha_arr: x-coordinate of singularity spectrum - corresponds to ???
% - D_arr: y-coordinate of singularity spectrum - corresponds to fractal dimension of data with alpha ???
%

    

    if nargin == 5
        makeplot = 0;
    end
    
    interp_scheme = singspec_settings{1};
    data_res = singspec_settings{2};
    lowerbound = bounds{1};
    upperbound = bounds{2};

    
    % do the singularity spectrum calculation
    tau_arr = q_arr .* h_arr - 1;
    alpha_arr = diff(tau_arr) ./ diff(q_arr);
    D_arr = q_arr(1:end-1) .* alpha_arr - tau_arr(1:end-1);
     
    
    
    if makeplot
        
        close all;
        
        scatter(alpha_arr,D_arr);
        
        title("Singularity spectrum");
        xlabel("\alpha");
        ylabel("f(\alpha)");
        filename = sprintf("%s%s_SingSpec_%s-%d_%.2f-%.2f.fig",obj.folder_out,obj.data_name,interp_scheme,data_res,lowerbound,upperbound);
        saveas(gcf,filename);
        close all;
        
    end

end