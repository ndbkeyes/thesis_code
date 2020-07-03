function h_arr = hurst_exp(folder_out, data_name, hurst_settings, bounds, makeplot)
%
% FUNCTION: hurst_exp(q_arr, interp_scheme, data_res, frac_data, lowerbound, upperbound, data_folder)
%
% PURPOSE: calculate & plot Hurst exponents for different values of q
% TODO: redo inputs for everything to be in settings{} form
%
% INPUT:
% - folder_out: folder where the MFTWDFA data file is located
% - data_name: nametag of data set being analyzed
% - hurst_settings: cell array containing interpolation settings and array of q values
%                   form: {interp_scheme, data_res, q_arr}
% - lowerbound, upperbound: lower & upper timescale limits for linear fitting to get Hurst exponent
% - makeplot: controls whether function makes & saves plot of h_arr vs. q_arr -- OPTIONAL, default = false
% 
% OUTPUT: 
% - h_arr: array of Hurst exponents corresponding to q_arr values
%

    if nargin == 4
        makeplot = 0;
    end


    interp_scheme = hurst_settings{1};
    data_res = hurst_settings{2};
    q_arr = hurst_settings{3};
    lowerbound = bounds{1};
    upperbound = bounds{2};


    h_arr = zeros(1,length(q_arr));

    for i=1:length(q_arr)
       
        
        settings = {interp_scheme, data_res, q_arr(i)};
        [t_arr,f_arr] = read_data(folder_out,data_name,settings);

        % Cut down data to main slope segment
        small = find(log10(t_arr) > lowerbound);
        starti = small(1);
        large = find(log10(t_arr) < upperbound);
        endi = large(end);

        x = log10(t_arr(starti:endi));
        y = log10(f_arr(starti:endi));

        % and create x matrix for linear regression
        x_matrix = [ones(endi-starti+1,1) x];

        % perform linear regression, store slope as Hurst exponent
        h = x_matrix \ y;    
        h_arr(i) = h(2);

    end
    
    % set up and save plot if asked
    if makeplot
        close all;
        scatter(q_arr,h_arr);
        title("Hurst exponent vs. statistical moment q");
        xlabel("q");
        ylabel("h(q)");
        filename = sprintf("%s%s_Hurst_%s-%d_%.2f-%.2f.fig",folder_out,data_name,interp_scheme,data_res,lowerbound,upperbound);
        saveas(gcf,filename);
    end

end