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