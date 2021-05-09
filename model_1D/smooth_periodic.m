function smooth_arr = smooth_periodic(arr,win)

    % get number of columns
    len = size(arr,2);              
    % tack on array copies to both ends (horizontally)
    arr_x3 = cat(2,arr,arr,arr);
    
    % smooth out transposed array, and re-transpose
    smooth_x3 = smoothdata(arr_x3',"Gaussian",win);
    smooth_x3 = smooth_x3';
    
    % cut back down to center portion
    smooth_arr = smooth_x3(:,len+1:2*len);
    

end