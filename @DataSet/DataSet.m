classdef DataSet
    %DATASET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
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
        function obj = DataSet(dn,rf)
            %DATASET Construct an instance of this class
            %   Detailed explanation goes here
            obj.data_name = dn;
            obj.results_folder = rf;
            [obj.filepath_in, obj.varnames, obj.cutoff, obj.t_scale, obj.data_name, obj.folder_out, obj.bounds_lhs, obj.bounds_rhs, obj.data_res] = set_params(dn, rf); 
            [obj.X,obj.Y] = obj.load_data();    
        end
        function [X,Y] = load_data(obj)
            Xvarname = obj.varnames{1};
            Yvarname = obj.varnames{2};

            % ===== LOAD IN CLIMATE DATA FROM FILE ===== %

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
        run_mftwdfa(obj,mftwdfa_settings)
    end
end

