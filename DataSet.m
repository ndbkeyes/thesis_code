classdef DataSet
    
    
%%% =================================================================== %%%

    
    properties
        
        data_name
        
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
    
    
    
%%% =================================================================== %%%
    
    
    methods
        
        %%% CONSTRUCTOR
        function obj = DataSet(data_name,results_folder)
            
            % set dataset attributes
            [obj.filepath_in, obj.varnames, obj.cutoff, obj.t_scale, obj.data_name, obj.folder_out, obj.bounds_lhs, obj.bounds_rhs, obj.data_res] = set_params(data_name,results_folder);
            
            % get raw data from file
            [obj.X, obj.Y] = obj.load_data();
            
        end
        
        
        
        
        %%% LOAD DATASET DATA FROM FILE INTO OBJECT
        function [X,Y] = load_data(obj)

            Xvarname = obj.varnames{1};
            Yvarname = obj.varnames{2};

            % Read in data as table, trim any top part of the data needed
            A = readtable(obj.filepath_in);
            A = A(obj.cutoff:end,:);
            
            % create age and temp arrays from table & plot
            x = cell2mat(table2cell(A(:,{Xvarname})));
            y = cell2mat(table2cell(A(:,{Yvarname})));
            
            % create X and Y arrays in order of age and with correct sign (time goes negative)
            X = flip(x) * -1 * obj.t_scale;
            Y = flip(y);
           
        end

    end
    
    
%%% =================================================================== %%%
    
end