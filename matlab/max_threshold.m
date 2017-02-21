function [ threshold ] = max_threshold( history )
%Finding the maximum threshold as described in the algorithm (norm2)
   dist = zeros(length(history));
    for i=1:length(history)
        for j=1:length(history)
            dist(i,j) = distance_from_set(history(i), history{j});
         
            
        end
        
        i
        
    end

    threshold = max(dist(:));
    
        
    if (length(history) == 1)
       threshold = -1; 
    end
end

