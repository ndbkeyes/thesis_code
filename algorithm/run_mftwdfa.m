function run_mftwdfa(mftwdfa_settings,filepath_in,folder_out,varnames,data_name,cutoff,scalefactor)
%
% FUNCTION: run_mftwdfa(filepath_in,folder_out,Xvarname,Yvarname,data_name,cutoff,scalefactor)
%
% PURPOSE: read in climate data series, run MFTWDFA on it, write results to file
%
% TODO: update inputs s.t. can control from outside what interp_scheme, data_res, q_arr to run with
%
% INPUT:
% - mftwdfa_settings: cell-array of arrays of settings
%                     form: {[interpscheme_arr], [datares_arr], [q_arr]}
% - filepath_in: climate data file to read from (complete path + filename)
% - folder_out: folder in which to output Fq vs. t to (ONLY folder path; function constructs filename!)
% - Xvarname, Yvarname: column titles to access from data table (needs to be char array, i.e. 'Xvarname' not "Xvarname")
% - data_name: nametag of the data set you're using; used to create output filename
% - cutoff: number of rows of data to cut off at the top, if needed --  OPTIONAL, default = 1
% - scalefactor: scaling multiplier for x-axis (time variable), in case of e.g. kyr units -- OPTIONAL, default = 1
%
% OUTPUT: no return values, just creates files and figures
% - writes timescale and fluctuation function arrays to text files in folder_out (exact location given by mftwdfa_filepath)
%


    if nargin == 5
        cutoff = 1;
        scalefactor = 1;
    elseif nargin == 6
        scalefactor = 1;
    end
    

    % load in data from filein
    [X,Y] = load_data(filepath_in,varnames,cutoff,scalefactor);
    

    % ===== RUN MFTWDFA ALGORITHM ===== %
    
    fprintf("Running MFTWDFA on %s dataset\n", data_name);
    
    % get sets of parameters out of settings array
    schemes_arr = mftwdfa_settings{1};
    res_arr = mftwdfa_settings{2};
    q_arr = mftwdfa_settings{3};
    
    % loop mftwdfa over all the sets of parameters inputted
    for interp_scheme = schemes_arr
        for data_res = res_arr
            for q = q_arr
                
                % gather / generate settings
                settings = {interp_scheme, data_res, q};
                filepath_out = mftwdfa_filepath(folder_out,data_name,settings); % constructing the FULL filepath of output file
                
                % RUN ALGORITHM
                mftwdfa(X, Y, settings, filepath_out);
                
                % print when run is complete
                % fprintf("%s, %d, q=%d run complete\n", interp_scheme, data_res, q);
                
            end
        end
    end
    

end