function ret = distance_from_set(history_csi_trace, curr)
%receive history and current sample, and return the distance from the
%history set
    sum_history = 0;

    for j=1:length(history_csi_trace)
        
        sum_inside   = 0;
        for r = 1:3 %number of receives
            
            for sc = 1:30 %number of subcarriers
                
               %we have only one spatial stream
               csi_curr = get_scaled_csi(curr);
               csi_j = get_scaled_csi(history_csi_trace{j});
               
               %we take value and amplitude for new pkt
               value_curr = scaled_value(csi_curr, r, sc);
                              
               %we take value and amplitude from j pkt (history pkt)
               value_j = scaled_value(csi_j, r, sc);
   
               to_add = value_curr - value_j;
               
               sum_inside = sum_inside + to_add*to_add;
               
            end
            
        end
        
        %finding the distance as inside the papper
        sum_inside = sqrt(sum_inside);
        sum_history = sum_history + sum_inside;
        
    end
    sum_history = sum_history / length(history_csi_trace);
    
    ret = sum_history;
    
end

function value = scaled_value(csi, r, sc)
   csi = squeeze(csi);
   mesourments = csi(r, sc);
   amp = real(mesourments);
   norma2 = norm(csi(:));
   %value = abs(amp)/norma2;
   value = abs(mesourments)/norma2;

end