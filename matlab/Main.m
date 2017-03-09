function [ output_args ] = Main(config, create_graphs)
%RECIEVELIVE Summary of this function goes here
%   Detailed explanation goes here
cur = datestr(now,'HH-MM');
if (ischar(config) == 1)
    
    %getting information from file
    init = IniConfig();
    init.ReadFile(config)

    receivers_use = str2num(init.GetValues('Receivers', 'receivers_use'));
    number_of_receivers = size(receivers_use,2);
    history_length = init.GetValues('Algorithm', 'history_length');

    sum_samples = init.GetValues('Algorithm', 'sum_samples');

    disp( sprintf('Loaded configuration:\n\tNumber of receivers: \t\t%d\n\n\tNum of history samples: \t%d\n\tSum samples:\t\t\t\t%d', number_of_receivers, history_length, sum_samples) )

    recI = init.GetValues('receiver 1', 'type');
    if (strcmp(recI, 'file'))
        %jump to handle files
    end

    %Live section
    ports =[];

    %getting ports information for each receiver.
    for i=receivers_use
        recI_port = init.GetValues(['receiver ' num2str(i)], 'port');
        ports = [ports recI_port]; 
    end
    
    %[history, samples_s] = receive_csi_live(ports, history_length, sum_samples);
    [history, samples_s] = receive_csi_live_tampering(ports, history_length, sum_samples);

    %sync streams to fix missed packets
    history = sync_stream(history);
    samples_s = sync_stream(samples_s);

end

%threshold calculation.
if (exist('thresholds_max') == 0) %check if already loaded to avoid recalculation
    number_of_receivers = size(history,1);
    parfor i=1:number_of_receivers
        thresholds_max(i) = max_threshold(history(i,:)); 
        thresholds_mean(i) = mean_threshold(history(i,:)); 
    end
end



%distance from history set
if (exist('distance_semaples_from_history') == 0)
    parfor i=1:number_of_receivers
        distance_semaples_from_history{i} = graph_distance_from_history(history(i,:),samples_s(i,:)); 
    end

end

roc_curve_plot(distance_semaples_from_history, [0,1,0,1,0,1,0,1,0,1]);

if (exist('time_filter') == 0)
        time_filter = time_wise_filter(distance_semaples_from_history, thresholds_max, 10);
end



%saving all workspace to folder
if (exist('path_cur') == 0)
    path_cur = sprintf('%s/%s',date, cur);
    name_file = sprintf('%s/%s.mat',path_cur, cur);
    mkdir(path_cur);
    save(name_file, 'samples_s','history', 'thresholds_max', 'thresholds_mean', 'distance_semaples_from_history','path_cur','number_of_receivers', 'time_filter');

end

if create_graphs
    for i=1:number_of_receivers
        figure(i);
        x = 1:size(samples_s,2);
        max_thrshold_vec = thresholds_max(i) * ones(1, size(samples_s,2));
        mean_thrshold_vec = thresholds_mean(i) * ones(1, size(samples_s,2));
        plot(x, distance_semaples_from_history{i}, x, max_thrshold_vec,'--g', x, mean_thrshold_vec,':r');
        title(sprintf('Receiver %d',i))
    
        axis([0 size(samples_s,2) 0.0 1])
        legend('Samples', 'Max threshold','Mean threshold')
        saveas(figure(i),sprintf('%s/Receiever %d.png',path_cur,i));
    end
end




end

