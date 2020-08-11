function avg_slope = avg_slope(obj,settings,slope_bounds)
%
% FUNCTION: avg_slope(obj,settings,slope_bounds)
%
% PURPOSE: find the average slope of the MFTWDFA fluctuation function for the given lower/upper slope bounds
%
% INPUT:
% - obj: DataSet object of data set to be analyzed
% - mftwdfa_settings: a SINGLE set of {interp_scheme, data_res, q} settings
% - slope_bounds: cell array of lower & upper log(t) bounds of fluct func curve to find slope of - {lower_bound, upper_bound}
%
% OUTPUT:
% - avg_slope: the slope of the best-fit line of log F_2(log t) between the two bounds in slope_bounds
%

    % unpack bounds and MFTWDFA settings
    lowerbound = slope_bounds{1};
    upperbound = slope_bounds{2};
    scheme = settings{1};
    res = settings{2};
    q = settings{3};

    % Read in MFTWDFA fluct func data
    settings = {scheme, res, q};
    [t_arr,f_arr] = read_data(obj,settings);
    t_arr = log10(t_arr);
    f_arr = log10(f_arr);

    % Cut down data to desired slope segment
    small = find(t_arr > lowerbound);
    large = find(t_arr > upperbound);
    if isempty(small)
        starti = 1;
    else
        starti = small(1);
    end

    if isempty(large)
        endi = length(t_arr);
    else
        endi = large(1);
    end
    t_arr = t_arr(starti:endi);
    f_arr = f_arr(starti:endi);

    % set up matrix for line fitting
    col = ones(length(t_arr), 1);
    t_arr_col = [col t_arr];

    % find slope value
    beta = t_arr_col \ f_arr; % using backslash operator to get slope
    avg_slope = beta(2);


end