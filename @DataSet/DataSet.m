classdef DataSet
    
    
    
    properties
        
        user_id
        data_name
        results_folder
        filepath_in
        varnames
        cutoff
        t_scale
        folder_out
        bounds_lhs
        bounds_rhs
        data_res
        X
        Y
        mftwdfa_runs
        
    end
    
    
    
    methods
        
        
        %%% DATASET CLASS CONSTRUCTOR
        
        function obj = DataSet(uid, dn, rf)
            
            % Assign inputs to corresponding object parameters
            obj.user_id = uid;
            obj.data_name = dn;
            obj.results_folder = rf;
            
            % select data set's parameters based on user ID 
            % (to account for differing filesystems)
            if obj.user_id == "NK"
                [obj.filepath_in, obj.varnames, obj.cutoff, obj.t_scale, obj.data_name, obj.folder_out, obj.bounds_lhs, obj.bounds_rhs] = set_params_NK(dn, rf);
            elseif obj.user_id == "CL"
                [obj.filepath_in, obj.varnames, obj.cutoff, obj.t_scale, obj.data_name, obj.folder_out, obj.bounds_lhs, obj.bounds_rhs] = set_params_CL(dn, rf);
            end
            
            % Load in the actual data 
            [obj.X,obj.Y] = obj.load_data();
            
            % Calculate the appropriate data resolution for the dataset
            obj.data_res = opt_res(obj.X);
            
        end
        
        
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