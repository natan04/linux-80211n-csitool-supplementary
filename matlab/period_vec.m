function [groups, time] = period_vec( samples, dist_vect, tresh )
%PERIOD Summary of this function goes here
%   Detailed explanation goes here

bin = dist_vect > tresh;

max_per_bin = 5;
count = 0;
in_session = 0;
start_session = 1;
group_index = 1;
groups = [];
for i=1:length(bin)
    
    if bin(i) 
        if (in_session == 0)
           start_session = i; 
           in_session=1;
        else
            count = count +1;
            if count == max_per_bin
                 groups{group_index} = samples(start_session:(i-1)); 
                 time(group_index) = i;
                 start_session = i; 
                 count = 0;
                 group_index = group_index + 1;
            end
            
        end
    else
       if in_session     %mean there no more 1
           groups{group_index} = samples(start_session:(i-1));
            time(group_index) = i-1;
            group_index = group_index + 1;
           in_session = 0;
       end
    end
 end
end
 


