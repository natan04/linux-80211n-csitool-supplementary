function [ CSI_history, CSI_samples]  = receive_csi_live_tampering(ports, history_size, samples_size)
    
    %getting connection from all receivers
    display('waiting for connection');
    for i=1:length(ports)
        sockets{i} = tcpip('0.0.0.0', ports(i), 'NetworkRole', 'server');
        fopen(sockets{i});
        display(sprintf('get connection from ip %s', sockets{i}.RemoteHost))
    end
    %all of them start together
    for i=1:length(ports)
        flushinput(sockets{i});
    end
  
    %Capturing history_size packets and putting inside CSI_history
    for index_history=1:history_size
        
        for index_rec=1:length(ports)
            CSI_history{index_rec,index_history} = handle_data(sockets{index_rec}); 
        end
        display(sprintf('history index of %d / %d ', index_history, history_size));

    
    end
  
    
    %Capturing samples_size packets and putting inside CSI_history
    for index_samples=1:samples_size
        for index_rec=1:length(ports)
            CSI_tamper_try{index_rec,index_samples} = handle_data(sockets{index_rec});
            
        end
        display(sprintf('samples index of %d / %d ', index_samples, samples_size));

    end
  
  
    
    extra_sample_to_test = 150;
  %calculate threshold to see if succeeding
    parfor index=1:length(ports)
        thresholds_max(index) = max_threshold(CSI_history(index,:)); 
    end
    display('finish to calculate threshold')
    
    %all of them start together (empty all sockets)
    
    for i=1:length(ports)
        flushinput(sockets{i});
     end
    

    for index_samples=1:extra_sample_to_test
                
        x_one_to_extra = 1:index_samples;

        for index_rec=1:length(ports)
            index_samples  
            CSI_i = handle_data(sockets{index_rec});
            CSI_samples{index_rec,index_samples} = CSI_i ;
            distance_i{index_rec}(index_samples) = graph_distance_from_history(CSI_history(i,:),{CSI_i});

        end
        
        for index_rec=1:length(ports)
                              
            max_thrshold_vec = thresholds_max(index_rec) * ones(1, index_samples);
            figure(index_rec);
            plot(x_one_to_extra, distance_i{index_rec}, x_one_to_extra, max_thrshold_vec,'--g');
            hold on
%            display(sprintf( '(threshold, ditance, dec ,sign -): (%d, %d, %d, %d)',  thresholds_max(index_rec), distance_i{index_rec}(index_samples),thresholds_max(index_rec) - distance_i{index_rec}(index_samples), sign(thresholds_max(index_rec) - distance_i{index_rec}(index_samples)) ));
        end
    end
  
end




function ret = handle_data(f)

broken_perm = 0;                % Flag marking whether we've encountered a broken CSI yet
triangle = [1 3 6];             % What perm should sum to for 1,2,3 antennas

waiting_for_new_packet = 1;
% Read size and code
   while (waiting_for_new_packet)
    field_len = fread(f, 1, 'uint16');
    if (isempty(field_len) == 1)
        continue;
    end
    %  field_len = fread(f, 1, 'uint16', 0, 'ieee-be');
    code = fread(f,1);
    
    % If unhandled code, skip (seek over) the record and continue
    if (code == 187) % get beamforming or phy data
      %  bytes = fread(f, field_len-1, 'uint8=>uint8');
        bytes = fread(f, field_len-1, 'uint8');
        bytes = uint8(bytes);
        if (length(bytes) ~= field_len-1)
            fclose(f);
            return;
        end
    else % skip all other info
        fseek(f, field_len - 1, 'cof');
    end
    
    if (code == 187) %hex2dec('bb')) Beamforming matrix -- output a record
        ret = read_bfee(bytes);
        
        perm = ret.perm;
        Nrx = ret.Nrx;
        if Nrx == 1 % No permuting needed for only 1 antenna
            return;
        end
        if sum(perm) ~= triangle(Nrx) % matrix does not contain default values
            if broken_perm == 0
                broken_perm = 1;
                filename = 'bla'
                fprintf('WARN ONCE: Found CSI (%s) with Nrx=%d and invalid perm=[%s]\n', filename, Nrx, int2str(perm));
            end
        else
            ret.csi(:,perm(1:Nrx),:) = ret.csi(:,1:Nrx,:);
        end
    end
    waiting_for_new_packet = 0;
   end
   
end