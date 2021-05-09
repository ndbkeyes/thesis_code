function [X_unique, Y_unique] = unique_avged(obj)
% clean data array of repeated time values / observations at the same time
% by averaging Y-values that share the same X


    % Average data values with same age!
    X_unique = [];
    Y_unique = [];
    j = 1;

    for i=1:length(obj.X)

        % if age value not already encountered:
        if ~ismember(obj.X(i), X_unique)

            % add it to avg X-array
            X_unique(j) = obj.X(i);

            % add mean value to avg-Y array - using logical indexing
            Y_unique(j) = mean(obj.Y(obj.X == obj.X(i)));

            % increment avg-array index
            j = j + 1;

        end
    end
   

end