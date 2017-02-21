function [ CSI_history, CSI_samples]  = receive_csi_live(ports, history_size, samples_size)
    
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

   enviornment_move = []; 
  tamper_history =[];
  
  %Capturing history_size packets and putting inside CSI_history
  for index_history=1:history_size
    for index_rec=1:length(ports)
      CSI_history{index_rec,index_history} = handle_data(sockets{index_rec});
     
    end
  index_history  
  end
  
  
  for index_samples=1:samples_size
    for index_rec=1:length(ports)
      CSI_samples{index_rec,index_samples} = handle_data(sockets{index_rec});
        index_samples
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