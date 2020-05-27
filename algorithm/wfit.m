%%% Weighted fit: use weighted linear regression to make weighted local estimate to the profile (detrending) 
function yni = wfit(x,Y,s)

    N = length(x);

    %%% Make X (data) matrix - first column all 1's, second column X values
    % ---------------------------------------------------------------------
       
    % add row of ones
    X = zeros(2,N,1);
    X(1,:) = ones(1,N);
    X(2,:) = linspace(1,N,N);
    
    % flip to vertical
    X = X';

    % flip Y to vertical too!
    siy = size(Y);
    if siy(1) == 1
        Y = Y';
    end   
    

    %%% Weighted fit approx for each point 
    % ------------------------------------
    
    yni = zeros(1,N);
    
    % loop thru the data points
    for i=1:N
        
        % Find j value range that will go into weights matrix
        jstart = max(i-s+1,1);
        jend = min(i+s+1,N);
        
        
        % Make weights matrix        
        inds = jstart:1:jend;
        ss = (1 - ( (i-inds)./s ).^2 ).^2;
        w = sparse(inds,inds,ss,N,N);
        
        % Calculate coefficient matrix - solving Ax=b
        Xtw = X' * w;
        A = Xtw*X;
        b = Xtw*Y;
        a = linsolve(A,b);
        
        % Get y approximation
        y = a(1) + a(2)*i;
        yni(i) = y;
        
    end   
        
end