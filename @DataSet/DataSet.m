classdef DataSet
    
    
    properties
        
        user_id             % nametag of user - for handling different filesystems
        data_name           % nametag of data set
        results_folder      % location of overarching "results" folder in which to store all data sets' results
        filepath_in         % full filepath of raw data text file
        varnames            % column names for reading in data (needs to be cell array of char arrays, i.e. 'Xvarname' not "Xvarname")
        cutoff              % index of line to start reading from in data file
        t_scale             % time scale in data file
        folder_out          % location of folder within "results" to hold this data set's output
        bounds_lhs          % log-t bounds for left-hand fluct func slope segment
        bounds_rhs          % log-t bounds for right-hand fluct func slope segment
        data_res            % data set's optimal/intrinsic resolution
        X                   % array of X data
        Y                   % array of Y data
        
    end
    
    
    
    methods
        
        
        %%% DATASET CLASS CONSTRUCTOR
        
        function obj = DataSet(uid, dn)
            
            % Assign user ID and dataset name
            obj.user_id = uid;
            obj.data_name = dn;

            % Load in data set's parameters
            [obj.filepath_in, obj.results_folder, obj.varnames, obj.cutoff, obj.t_scale, obj.folder_out, obj.bounds_lhs, obj.bounds_rhs] = obj.set_params();
            
            % Load in the raw data 
            [obj.X,obj.Y] = obj.load_data();
            
            % Calculate the appropriate data resolution for the dataset
            obj.data_res = opt_res(obj);
            
        end
        
        
        %%% RETRIEVE PARAMETERS FOR DATASET
        
        [filepath_in, results_folder, varnames, cutoff, t_scale, folder_out, bounds_lhs, bounds_rhs] = set_params(obj);
        
        
        
        %%% LOAD IN RAW DATASET
        
        function [X,Y] = load_data(obj)
            
            % Unpack X and Y variable column names
            Xvarname = obj.varnames{1};
            Yvarname = obj.varnames{2};

            % Read in data from file as table, trim any top part of the data needed
            A = readtable(obj.filepath_in);
            A = A(obj.cutoff:end,:);
            
            % create age and temp arrays from table & plot
            X = cell2mat(table2cell(A(:,{Xvarname})));
            Y = cell2mat(table2cell(A(:,{Yvarname})));
            
            % create X and Y arrays in order of age and with correct sign (time goes negative)
            X = flip(X) * -1 * obj.t_scale;
            Y = flip(Y);
            
        end 
        
        
        
        %%% RUN MFTWDFA ON DATASET
        
        run_mftwdfa(obj,mftwdfa_settings)
        
        
        
        %%% RUN ANALYSIS ON MFTWDFA RESULTS FROM DATASET
        
        main_analysis(obj,mftwdfa_settings)
        
        
    end
    
    
end