function run_mftwdfa(obj,mftwdfa_settings)
%
% FUNCTION: run_mftwdfa(obj,mftwdfa_settings)
%
% PURPOSE: read in climate data series, run MFTWDFA on it, write results to file
%
% TODO: update inputs s.t. can control from outside what interp_scheme, data_res, q_arr to run with
%
% INPUT:
% - obj: DataSet object to run MFTWDFA on
% - mftwdfa_settings: set of MFTWDFA parameter sets to run algo with
%
% OUTPUT: no return values, just creates files and figures
% - writes timescale and fluctuation function arrays to text files in folder_out (exact location given by mftwdfa_filepath)
%
    % ===== RUN MFTWDFA ALGORITHM ===== %
    
    fprintf("Running MFTWDFA on %s dataset\n", obj.data_name);
    
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
                
                % RUN ALGORITHM
                mftwdfa(obj, settings);
                
                % print when run is complete
                fprintf("%s, %d, q=%d run complete\n", interp_scheme, data_res, q);
                
            end
        end
    end
    

end