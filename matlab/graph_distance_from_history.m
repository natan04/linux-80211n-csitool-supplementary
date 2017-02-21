function [ output_args ] = graph_distance_from_history( history, samples )
%GRAPH_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here

vec = zeros(1,length(samples));

for i=1:length(samples)
    vec(i) = distance_from_set(history,samples{i});
    i
end


plot(vec)
output_args =vec;
end

