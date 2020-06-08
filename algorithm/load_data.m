function [X,Y] = load_data(filename, Xvarname, Yvarname, cutoff, scalefactor)

    if nargin == 4
        scalefactor = 1;
    end

    % ===== LOAD IN CLIMATE DATA FROM FILE ===== %

    % Read in data from file as table, trim any top part of the data needed
    A = readtable(filename);
    A = A(cutoff:end,:);
    % create age and temp arrays from table & plot
    X = cell2mat(table2cell(A(:,{Xvarname})));
    Y = cell2mat(table2cell(A(:,{Yvarname})));
    % create X and Y arrays in order of age and with correct sign (time goes negative)
    X = flip(X) * -1 * scalefactor;
    Y = flip(Y);

end