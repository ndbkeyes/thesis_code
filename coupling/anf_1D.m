function a1 = anf_1D(obj, interp_res)
%
% FUNCTION: coupling(X1, Y1, X2, Y2, X3, Y3, interp_res)
%
% PURPOSE: perform 3D coupling analysis on the 3 inputted data sets
%
% INPUT: 
% - obj1, obj2, obj3: DataSet objects holding the data sets we want to analyze coupling for
% - interp_res: resolution (in number of points) for interpolation
%
% OUTPUT:
% - ai: stability of i-th set (i=1,2,3)
% - bij: influence of jth set on ith set (i=1,2,3, j=/=i)
%

    n_sections = 40;                                        % number of sections that the data is averaged in
    delta_t = ( max(obj.X) - min(obj.X) ) / n_sections;     % time gap size btwn these sections
    len_data = length(obj.X);                               % number of data points
    m = 10^4;                                               % intermediate timescale ? (tnum in JSW code)
    
    
    autocorr_mG = zeros(m,n_sections);
    
    for k = 1:n_sections
        for j = 1:m
            
            sum_jk = 0;
            for i = 1:len_data  
                
                sum_jk = sum_jk + obj.X(i,k) * obj.X(i+j-1,k);
                
            end
            
            autocorr_mG(j,k) = sum_jk / len_data;
            
        end
    end
    
    


end