function run_mftwdfa(filepath_in,folder_out,Xvarname,Yvarname,data_name,cutoff,scalefactor)
% RUN_MFTWDFA: run full mftwdfa routine
% - read in climate data from filename using load_data function
% - run mftwdfa on the four different interpolation settings (makima/spline, 1000/5000 pts)
% - make plot of fluctuation functions for the four different settings (at q=2)
%
% INPUT:
% - filepath_in: climate data file to read from (complete path + filename)
% - folder_out: folder in which to output Fq vs. t to (ONLY folder path; function constructs filename)
% - Xvarname, Yvarname: column titles to access from data table (needs to be char array, i.e. 'Xvarname' not "Xvarname")
% - data_name: nametag of the data set you're using; used to create output filename
% - cutoff: number of rows of data to cut off at the top, if needed
% - data_folder: destination for text files containing results
%
% OUTPUT: no return values, just creates files and figures
% - writes timescale and fluctuation function arrays to text files in data_folder


    if nargin == 5
        cutoff = 1;
        scalefactor = 1;
    elseif nargin == 6
        scalefactor = 1;
    end

    % load in data from filein
    [X,Y] = load_data(filepath_in,Xvarname,Yvarname,cutoff,scalefactor);
    

    % ===== RUN MFTWDFA ALGORITHM ===== %
    
    q_arr = [-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]; % range of q values to run with
    q_arr = [-20,-10,-5,-2,-1,1,2,5,10,20];
    q_arr = [2];
    
    fprintf("Running MFTWDFA on %s dataset\n", data_name);
    
    for interp_scheme=["makima"]%,"spline"]
        for data_res=[1000]%,5000]
            for q=q_arr
                
                % gather / generate settings
                settings = {interp_scheme, data_res, q};
                filepath_out = mftwdfa_filepath(folder_out,data_name,settings); % constructing the FULL filepath of output file
                
                % RUN ALGORITHM
                mftwdfa(X, Y, settings, filepath_out);
                
                % print when run is complete
                fprintf("%s, %d, q=%d run complete\n", interp_scheme, data_res, q);
                
            end
        end
    end
    

end