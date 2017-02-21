function [ output_args ] = alarm( history, samples )
%ALARM Summary of this function goes here
%   Detailed explanation goes here
    
    
    vec = zeros(1, length(samples));
    threshold = max_threshold( history );
    
    for sample=1:length(samples)
      vec(sample) =  distance_from_set(history, samples{sample}); 
    end
    
    triggered = vec > threshold;
    stem(triggered,'markerfacecolor',[0 0 1]);
    axis([0,500, 0,10])
end

