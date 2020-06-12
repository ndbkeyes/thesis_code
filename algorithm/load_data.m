function [X,Y] = load_data(filepath_in, varnames, cutoff, scalefactor)
%
% FUNCTION: load_data(filepath_in, Xvarname, Yvarname, cutoff, scalefactor)
%
% PURPOSE: read in climate time series from text file
%
% INPUT:
% - filepath_in: FULL path of data file, both folder and filename
% - Xvarname: column title in table for independent variable (time)
% - Yvarname: column title in table for dependent variable (climate quantity)
% - cutoff: number of rows of data to cut off at the top, if needed --  OPTIONAL, default = 1
% - scalefactor: scaling multiplier for x-axis (time variable), in case of e.g. kyr units -- OPTIONAL, default = 1
%
% OUTPUT:
% - X: independent-variable (time) series of the climate dataset
% - Y: dependent-variable (climate quantity) series of the climate dataset
%

    if nargin == 2
        cutoff = 1;
        scalefactor = 1;
    elseif nargin == 3
        scalefactor = 1;
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