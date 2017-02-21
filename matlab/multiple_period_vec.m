function [groups, time] = multiple_period_vec( samples, dist_vect, tresh )
%PERIOD Summary of this function goes here
%   Detailed explanation goes here
tresh = zeros(1, length(tresh)); % by that any 5 second windows
bin = ones(1, length(dist_vect{1}));
for i=1:length(dist_vect)
    bin = bin & (dist_vect{i} > tresh(i));
end
max_per_bin = 5;
group_index = 1;
groups = [];
for rec=1:length(dist_vect)
    sam = samples(rec, :);
    count = 0;
in_session = 0;
start_session = 1;
sub_group_index = 1;
sub_group = [];
for i=1:length(bin)
    
    if bin(i) 
        if (in_session == 0)
           start_session = i; 
           in_session=1;
        else
            count = count +1;
            if count == max_per_bin
                
                 sub_group{ sub_group_index} = sam(start_session:(i-1)); 
                 start_session = i; 
                 count = 0;
                  time(sub_group_index) = i-1;

                 sub_group_index = sub_group_index + 1;
            end
            
        end
    else
       if in_session     %mean there no more 1
           sub_group{ sub_group_index} = sam(start_session:(i-1));
            time(sub_group_index) = i-1;

           sub_group_index = sub_group_index + 1;
           in_session = 0;
       end
    end
end
 
groups{group_index} = sub_group;
group_index = group_index + 1;
end


end
 


