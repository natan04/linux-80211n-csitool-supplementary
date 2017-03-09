function binary = time_wise_filter( distance_vectors_sample, threshold, time_window)
% Receive samples and thresold, and returning binary vector with true iff
% for all time windows the distance samples is above threshold 


number_of_receivers = length(distance_vectors_sample);
number_of_samples   = length(distance_vectors_sample{1});

Q_i = ones(1,number_of_samples);
binary = zeros(1,number_of_samples);
for rec_index=1:number_of_receivers
    Q_i = Q_i & (distance_vectors_sample{rec_index} > threshold(rec_index));
end

for sample_index = 1:number_of_samples
   binary(sample_index) = time_filter(Q_i, sample_index, time_window); 
end


end

function bool_dec = time_filter(Q_i,index, time_window)
    bool_dec = 0;
    
    if index < time_window
        return;
    end
    
    start = index - time_window + 1;
    
    bool_dec = sum(Q_i(start:end) == ones(1, time_window)) == time_window;
end


