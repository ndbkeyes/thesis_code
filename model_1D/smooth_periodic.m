function smooth_arr = smooth_periodic(arr,win,ax)

    if nargin == 2
        ax = 2;
    end

    % get number of columns
    len = size(arr,2);              
    % tack on array copies to both ends (horizontally)
    arr_x3 = cat(ax,arr,arr,arr);
    
    % smooth out transposed array, and re-transpose
    smooth_x3 = smoothdata(arr_x3',"Gaussian",win);
    smooth_x3 = smooth_x3';
    
    % cut back down to center portion
    smooth_arr = smooth_x3(:,len+1:2*len);
    

end