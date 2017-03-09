function [ output_args ] = roc_curve_plot( distance_semples_from_history, ground_truth)
%Calculte roc curve, by passing on all threshold from 0.1 to 1.

number_of_receivers = length(distance_semples_from_history);
threshold_vec = 0.001:0.001:1;
for rec_index=1:number_of_receivers
  for index_threshold = 1:1000
        rec_dec{rec_index, index_threshold} = (distance_semples_from_history{rec_index} >= threshold_vec(index_threshold));
        threshold_dec = rec_dec{rec_index, index_threshold};
        
        TPR{rec_index}(index_threshold) =  sum(ground_truth & threshold_dec)/sum(ground_truth);
 
        index_vectors_one = threshold_dec == 1;
        FPR{rec_index}(index_threshold) =sum(xor(ground_truth(index_vectors_one), threshold_dec(index_vectors_one)))/sum(ground_truth==0);
        
  end
end

figure();
color = ['g', 'b', 'y', 'm', 'c'];
for rec_index=1:number_of_receivers
   
    plot(TPR{rec_index}, FPR{rec_index}, color(rec_index));
    legendInfo{rec_index}=[sprintf('receiver %d', rec_index)]; % or whatever is appropriate
    hold on
   
end
legend(legendInfo)
title('ROC curve');
xlabel('False positive rate'); ylabel('True positive rate');
end

