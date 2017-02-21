function [ new_csi ] = sync_stream( CSI )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


indexes = ones(1, size(CSI,1));
new_csi = copy_row({}, CSI, indexes); 

while max(indexes) < size(CSI,2)
    indexes = indexes + 1;
    sync_jump = sync_s(CSI, indexes);
    if (max (sync_jump) > 0)
        display(sprintf('drop in index %d', max(indexes)));
    end
    indexes = indexes + sync_jump; 
    new_csi =   copy_row(new_csi,CSI, indexes);
end
end

function [indexes] = sync_s(CSI, indexes)
    bfee = @(x,rec,ind) x{rec,ind}.bfee_count;
    for rec=1:size(CSI,1)
        countB(rec) = bfee(CSI, rec, indexes(rec) ) - bfee(CSI, rec, indexes(rec) -1) ;
    end
    max_to_jump = max(countB);
    for rec=1:size(CSI,1)
       	indexes(rec) = max_to_jump - countB(rec)  ;
    end
    
end
function [new_csi] = copy_row(new_csi, CSI, indexes)    
   index = size(new_csi, 2);
    for rec=1:size(CSI,1)
       new_csi{rec,index + 1} = CSI{rec, indexes(rec)};
    end
end

