function [X,Y] = load_data(filepath_in, varnames, read_settings)
%
% FUNCTION: load_data(filepath_in, varnames, cutoff, scalefactor)
%
% PURPOSE: read in climate time series from text file
%
% INPUT:
% - filepath_in: FULL path of data file, both folder and filename
% - varnames: cell array of column titles in table for independent variable (time) and dependent variable (climate quantity)
% - cutoff: number of rows of data to cut off at the top, if needed --  OPTIONAL, default = 1
% - scalefactor: scaling multiplier for x-axis (time variable), in case of e.g. kyr units -- OPTIONAL, default = 1
%
% OUTPUT:
% - X: independent-variable (time) series of the climate dataset
% - Y: dependent-variable (climate quantity) series of the climate dataset
%
    
    if nargin == 2
        read_settings = {};
    end

    if length(read_settings) == 0
        cutoff = 1;
        scalefactor = 1;
    elseif length(read_settings) == 1
        cutoff = read_settings{1};
        scalefactor = 1;
    elseif length(read_settings) == 2
        cutoff = read_settings{1};
        scalefactor = read_settings{2};
    else
        disp("ERROR - weird read_settings");
    end
    
    Xvarname = varnames{1};
    Yvarname = varnames{2};

    % ===== LOAD IN CLIMATE DATA FROM FILE ===== %

    % Read in data from file as table, trim any top part of the data needed
    A = readtable(filepath_in);
    A = A(cutoff:end,:);
    % create age and temp arrays from table & plot
    X = cell2mat(table2cell(A(:,{Xvarname})));
    Y = cell2mat(table2cell(A(:,{Yvarname})));
    % create X and Y arrays in order of age and with correct sign (time goes negative)
    X = flip(X) * -1 * scalefactor;
    Y = flip(Y);

end