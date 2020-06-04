function run_mftwdfa(filename,Xvarname,Yvarname,cutoff,data_folder)
% RUN_MFTWDFA: run full mftwdfa routine
% - read in climate data from file
% - run mftwdfa on the four different interpolation settings (makima/spline, 1000/5000 pts)
% - make plot of fluctuation functions for the four different settings (at q=2)
%
% INPUT:
% - filename: climate data file to read from
% - Xvarname, Yvarname: column titles to access from data table (needs to be char array, i.e. 'Xvarname' not "Xvarname")
% - cutoff: number of rows of data to cut off at the top, if needed
% - data_folder: destination for text files containing results
%
% OUTPUT: no return values, just creates files and figures
% - writes timescale and fluctuation function arrays to text files in "data_folder"



    % ===== READ IN DATA FROM FILE ===== %

    % Read in data from file as table, trim any top part of the data needed
    A = readtable(filename);
    A = A(cutoff:end,:);
    % create age and temp arrays from table & plot
    X = cell2mat(table2cell(A(:,{Xvarname})));
    Y = cell2mat(table2cell(A(:,{Yvarname})));
    % create X and Y arrays in order of age and with correct sign (time goes negative)
    X = flip(X) * -1;
    Y = flip(Y);
    

    % ===== RUN MFTWDFA ALGORITHM ===== %
    
    s_res = 100;                % number of values of s to run with
    frac_data = 1;              % fraction of data to include
    q_arr = [-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]; % range of q values to run with
    
    for interp_scheme=["makima","spline"]
        for data_res=[1000,5000]
            for q=q_arr
                % run algo and plotting    
                mftwdfa(X, Y, s_res, interp_scheme, data_res, q, frac_data, data_folder);
                fprintf("\n%s, %d, q=%d run complete\n", interp_scheme, data_res, q);
            end
        end
    end
    

end