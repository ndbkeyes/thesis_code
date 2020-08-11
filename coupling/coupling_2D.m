function [a1, a2, b12, b21] = coupling_2D(obj1, obj2, interp_res)
%
% FUNCTION: coupling(X1, Y1, X2, Y2)
%
% PURPOSE: perform coupling analysis on the 2 inputted data sets
%
% INPUT: 
% - obj1, obj2: DataSet objects holding the data sets we want to analyze coupling for
% - interp_res: resolution (in number of points) for interpolation for both datasets
%
% OUTPUT:
% - a1: stability of 1st set
% - a2: stability of 2nd set
% - b12: influence of 2nd set on 1st set
% - b21: influence of 1st set on 2nd set
%

    % ===== INTERPOLATE ===== %

    scheme = "makima";
    [x1, n1] = interpolate(obj1.X, obj1.Y, interp_res, scheme);
    [x2, n2] = interpolate(obj1.X, obj2.Y, interp_res, scheme);


    
    % ===== FIND DATA'S STATISTICAL QUANTITIES ===== %
    
    n1sq = mean( n1 .^ 2 );
    n2sq = mean( n2 .^ 2 );
    n1n2 = mean( n1 .* n2 );
    n1_dn1 = mean( n1(1:end-1) .* diff(n1)/diff(x1) );
    n1_dn2 = mean( n1(1:end-1) .* diff(n2)/diff(x1) );
    n2_dn1 = mean( n2(1:end-1) .* diff(n1)/diff(x2) );
    n2_dn2 = mean( n2(1:end-1) .* diff(n2)/diff(x2) );



    % ===== A MATRICES ===== %
    
    A1 = zeros(2,2);
    A1(1,1) = n1sq;
    A1(1,2) = n1n2 - n1sq;
    A1(2,1) = n1n2;
    A1(2,2) = n2sq - n1n2;

    A2 = zeros(2,2);
    A2(1,1) = n2sq;
    A2(1,2) = n1n2 - n2sq;
    A2(2,1) = n1n2;
    A2(2,2) = n1sq - n1n2;



    % ===== Q VECTORS ===== %
    
    Q1 = zeros(2,1);
    Q1(1,1) = n1_dn1;
    Q1(2,1) = n2_dn1;

    Q2 = zeros(2,1);
    Q2(1,1) = n1_dn2;
    Q2(2,1) = n2_dn2;



    % ===== X VECTORS ===== %
    
    X1 = inv(A1) * Q1;
    X2 = inv(A2) * Q2;



    % ===== UNPACK RESULTS ===== %

    % co2 local stability
    a1 = X1(1,1);
    % temp. -> co2 influence
    b12 = X1(2,1);

    % temp. local stability
    a2 = X2(1,1);
    % co2 -> temp influence
    b21 = X2(2,1);


    % fprintf("a1,2 = %.3e, %.3e\nb12,21 = %.3e, %.3e\n", a1, a2, b12, b21);



end

