function [ X ] = multiple_extract_features( rec_group )
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes here
   %avg amplitude
   X = [];
for rec=1:length(rec_group)
    group = rec_group{rec};
    avg_amp_vec = [];
   
   for i = 1:length(group)
        subgroup = group{i};
        avg_amp_vec = [avg_amp_vec; avg_amp(subgroup)];
   end
   
   mad_amp_vec = [];
   for i = 1:length(group)
        subgroup = group{ i};
        mad_amp_vec = [mad_amp_vec; mad_amp(subgroup)];
   end
   amp_deviation = [];
     
   for i = 1:length(group)
        subgroup = group{i};
        amp_deviation = [amp_deviation; dev_amp(subgroup)];
    end
   
   
   moment2_amp_vec = [];
   moment3_amp_vec = [];
   for i = 1:length(group)
        subgroup = group{ i};
        moment2_amp_vec = [moment2_amp_vec; moment_second(subgroup,2)];
        moment3_amp_vec = [moment3_amp_vec; moment_second(subgroup,3)];
   end
   max_dirative_amp_vec = [];
   min_dirative_amp_vec = [];
   moment3_amp_vec = [];
  
   for i = 1:length(group)
        subgroup = group{ i};
        max_dirative_amp_vec = [max_dirative_amp_vec; max_dirative(subgroup,2)];
        min_dirative_amp_vec = [min_dirative_amp_vec; min_dirative(subgroup,2)];
   end
   
   
end
   X = [X avg_amp_vec mad_amp_vec moment2_amp_vec moment3_amp_vec amp_deviation]
end


function res = avg_amp(subgroup)
    amps = zeros(3, 30, length(subgroup));
    count = 1;
    for i=1:length(subgroup) 
        csi = squeeze(get_scaled_csi(subgroup{i}));
        for sc=1:30
            for rec=1:3
                mesourments = csi(rec, sc);
                amps(rec, sc, i) = abs(mesourments)/norm(csi(:)); 
            end
        end
    end
    
    m = mean(amps,3);
    res = m(:)';
end

function res = mad_amp(subgroup)
    for i=1:length(subgroup) 
        csi = squeeze(get_scaled_csi(subgroup{i}));
        for sc=1:30
            for rec=1:3
                mesourments = csi(rec, sc);
                amps(rec, sc, i) = abs(mesourments)/norm(csi(:)); 
            end
        end
    end
    
    m = mad(amps,1,3);
    res = m(:)';
end

function res = dev_amp(subgroup)
    for i=1:length(subgroup) 
        csi = squeeze(get_scaled_csi(subgroup{i}));
        for sc=1:30
            for rec=1:3
                mesourments = csi(rec, sc);
                amps(rec, sc, i) = abs(mesourments)/norm(csi(:)); 
            end
        end
    end
    
    m = std(amps,0,3);
    res = m(:)';
end


function res = moment_second(subgroup, order)
    for i=1:length(subgroup) 
        csi = squeeze(get_scaled_csi(subgroup{i}));
        for sc=1:30
            for rec=1:3
                mesourments = csi(rec, sc);
                amps(rec, sc, i) = abs(mesourments)/norm(csi(:)); 
            end
        end
    end
    
    m = moment(amps,order,3);
    res = m(:)';
end



function res = max_dirative(subgroup, order)
    for i=1:length(subgroup) 
        csi = squeeze(get_scaled_csi(subgroup{i}));
        for sc=1:30
            for rec=1:3
                mesourments = csi(rec, sc);
                amps(rec, sc, i) = abs(mesourments)/norm(csi(:)); 
            end
        end
    end
    
   m = diff(amps,1,3);
   
   for sc=1:30
    for rec=1:3
        vec_dirative_sub = m(rec, sc,:);
        mat(rec, sc) = max(abs(vec_dirative_sub));
    end
   end

    res = m(:)';
end