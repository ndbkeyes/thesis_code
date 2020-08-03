function [a1, a2, a3, b12, b13, b21, b23, b31, b32] = coupling_3D(X1, Y1, X2, Y2, X3, Y3, interp_res)
%
% FUNCTION: coupling(X1, Y1, X2, Y2, X3, Y3, interp_res)
%
% PURPOSE: perform 3D coupling analysis on the 3 inputted data sets
%
% INPUT: 
% - Xi, Yi: x,y coordinates of i-th set (i=1,2,3)
% - interp_res: resolution (in number of points) for interpolation
%
% OUTPUT:
% - ai: stability of i-th set (i=1,2,3)
% - bij: influence of jth set on ith set (i=1,2,3, j=/=i)
%


    scheme = "makima";
    [x1, n1] = interpolate(X1, Y1, interp_res, scheme);
    [x2, n2] = interpolate(X2, Y2, interp_res, scheme);
    [x3, n3] = interpolate(X3, Y3, interp_res, scheme);


    
    % ===== FIND DATA'S STATISTICAL QUANTITIES ===== %
    
    n1sq = mean( n1 .^ 2 );
    n2sq = mean( n2 .^ 2 );
    n3sq = mean( n3 .^ 2 );
    
    n1n2 = mean( n1 .* n2 );
    n1n3 = mean( n1 .* n3 );
    n2n3 = mean( n2 .* n3 );
    
    n1_dn1 = mean( n1(1:end-1) .* diff(n1)/diff(x1) );
    n2_dn1 = mean( n2(1:end-1) .* diff(n1)/diff(x1) );
    n3_dn1 = mean( n3(1:end-1) .* diff(n1)/diff(x1) );
    
    n1_dn2 = mean( n1(1:end-1) .* diff(n2)/diff(x2) );
    n2_dn2 = mean( n2(1:end-1) .* diff(n2)/diff(x2) );
    n3_dn2 = mean( n3(1:end-1) .* diff(n2)/diff(x2) );
    
    n1_dn3 = mean( n1(1:end-1) .* diff(n3)/diff(x3) );
    n2_dn3 = mean( n2(1:end-1) .* diff(n3)/diff(x3) );
    n3_dn3 = mean( n3(1:end-1) .* diff(n3)/diff(x3) );
    
    



    % ===== A MATRICES ===== %
    
    A1 = zeros(3,3);
    A1(1,1) = n1sq;
    A1(1,2) = n1n2 - n1sq;
    A1(1,3) = n1n3 - n1sq;
    A1(2,1) = n1n2;
    A1(2,2) = n2sq - n1n2;
    A1(2,3) = n2n3 - n1n2;
    A1(3,1) = n1n3;
    A1(3,2) = n2n3 - n1n3;
    A1(3,3) = n3sq - n1n3;

    A2 = zeros(3,3);
    A2(1,1) = n1n2;
    A2(1,2) = n1sq - n1n2;
    A2(1,3) = n1n3 - n1n2;
    A2(2,1) = n2sq;
    A2(2,2) = n1n2 - n2sq;
    A2(2,3) = n2n3 - n2sq;
    A2(3,1) = n2n3;
    A2(3,2) = n1n3 - n2n3;
    A2(3,3) = n3sq - n2n3;
    
    A3 = zeros(3,3);
    A3(1,1) = n1n3;
    A3(1,2) = n1sq - n1n3;
    A3(1,3) = n1n2 - n1n3;
    A3(2,1) = n2n3;
    A3(2,2) = n1n2 - n2n3;
    A3(2,3) = n2sq - n2n3;
    A3(3,1) = n3sq;
    A3(3,2) = n1n3 - n3sq;
    A3(3,3) = n2n3 - n3sq;



    % ===== Q VECTORS ===== %
    
    Q1 = zeros(3,1);
    Q1(1,1) = n1_dn1;
    Q1(2,1) = n2_dn1;
    Q1(3,1) = n3_dn1;

    Q2 = zeros(3,1);
    Q2(1,1) = n1_dn2;
    Q2(2,1) = n2_dn2;
    Q2(3,1) = n3_dn2;
    
    Q3 = zeros(3,1);
    Q3(1,1) = n1_dn3;
    Q3(2,1) = n2_dn3;
    Q3(3,1) = n3_dn3;



    % ===== X VECTORS ===== %
    
    X1 = inv(A1) * Q1;
    X2 = inv(A2) * Q2;
    X3 = inv(A3) * Q3;



    % ===== UNPACK RESULTS ===== %
    
    % 1: co2
    % 2: ch4
    % 3: temp.

    % (1) co2 local stability
    a1 = X1(1,1);
    % ch4 -> co2 influence
    b12 = X1(2,1);
    % temp. -> co2 influence
    b13 = X1(3,1);
    
    
    % ch4 local stability
    a2 = X2(1,1);
    % co2 -> ch4 influence
    b21 = X2(2,1);
    % temp. -> ch4 influence
    b23 = X2(3,1);
    

    % temp. local stability
    a3 = X3(1,1);
    % co2 -> temp. influence
    b31 = X3(2,1);
    % ch4 -> temp. influence
    b32 = X3(3,1);


    % fprintf("a1 = %.3e, b12 = %.3e, b13 = %.3e\n", a1, b12, b13);



end