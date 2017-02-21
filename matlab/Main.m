function [ output_args ] = Main(config, create_graphs)
%RECIEVELIVE Summary of this function goes here
%   Detailed explanation goes here
cur = datestr(now,'HH-MM');
if (ischar(config) == 1)
init = IniConfig();
init.ReadFile(config)

receivers_use = str2num(init.GetValues('Receivers', 'receivers_use'));
number_of_receivers = size(receivers_use,2);
history_length = init.GetValues('Algorithm', 'history_length');

sum_samples = init.GetValues('Algorithm', 'sum_samples');
tamper_history_size = init.GetValues('Algorithm', 'tamper_history_size');
enviornment_move_size = init.GetValues('Algorithm', 'enviornment_move_size');



disp( sprintf('Loaded configuration:\n\tNumber of receivers: \t\t%d\n\n\tNum of history samples: \t%d\n\tSum samples:\t\t\t\t%d', number_of_receivers, history_length, sum_samples) )

recI = init.GetValues('receiver 1', 'type');
if (strcmp(recI, 'file'))
    %jump to handle files
end

%Live section
ports =[];
max_receivers = init.GetValues('Receivers', 'max_receivers');

for i=receivers_use
    recI_port = init.GetValues(['receiver ' num2str(i)], 'port');
    ports = [ports recI_port]; 
end
[history, samples_s] = receive_csi_live(ports, history_length, sum_samples);

history = sync_stream(history);
samples_s = sync_stream(samples_s);

end

%%%%%%%%%%%%%%%%%%%%threshold calculation%%%%%% 
if (exist('thresholds_max') == 0)

    number_of_receivers = size(history,1);
    parfor i=1:number_of_receivers
        thresholds_max(i) = max_threshold(history(i,:)); 
        thresholds_mean(i) = mean_threshold(history(i,:)); 
    end
end



%%%%%%%%%%%%%%%%%%%%distance from set%%%%%% 
if (exist('distance_semaples_from_history') == 0)
    parfor i=1:number_of_receivers
        distance_semaples_from_history{i} = graph_distance_from_history(history(i,:),samples_s(i,:)); 
    end


end

%preffering already saved location
if (exist('path_cur') == 0)
%    path_cur = sprintf('%s/%s',datestr(datetime('today')), cur);
    path_cur = sprintf('%s/%s',date, cur);

    name_file = sprintf('%s/%s.mat',path_cur, cur);
    mkdir(path_cur);
    save(name_file, 'samples_s','history', 'thresholds_max', 'thresholds_mean', 'distance_semaples_from_history','path_cur','number_of_receivers');

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




















%group intresting data:%
%    [groups_period, time_grouped] = multiple_period_vec(samples_s, distance_set, thresholds_max); 
% 
% x
%group intresting data:%
%for i=1:number_of_receivers
%   [groups_period{i}, time_grouped{i}] = period_vec(samples_s(i,:), distance_set{i}, thresholds_max(i)); 
%end

% for i=1:number_of_receivers
%    groups_tamper_history{i} = mat2cell(tamper_history(i,:), 1, ones(1,length(tamper_history)/5)*5);
% end

% for i=1:number_of_receivers
%    group_environemnt_history{i} = period_vec(environemnt_history(i,:), distance_set_enviornment{i}, thresholds_max(i)); 
% end

%    group_environemnt_history = multiple_period_vec(environemnt_history, distance_set_enviornment, thresholds_max); 

%features extraction$%
%    features_tamper_history =  multiple_extract_features(groups_tamper_history);
%   features_environements_history =  multiple_extract_features(group_environemnt_history);
%    X = [  features_tamper_history; features_environements_history;];
%    Y_up = ones(size(features_tamper_history,1),1);
%    Y_down = -1*ones(size(features_environements_history,1),1);
%    Y = [Y_up; Y_down];
% 

% %features extraction$%
% for i=1:number_of_receivers
%    features_tamper_history{i} =  extract_features(groups_tamper_history{i});
%   features_environements_history{i} =  extract_features(group_environemnt_history{i});
%    X{i} = [  features_tamper_history{i}; features_environements_history{i};];
%    Y_up = ones(size(features_tamper_history{i},1),1);
%    Y_down = -1*ones(size(features_environements_history{i},1),1);
%    Y{i} = [Y_up; Y_down];
% end
% 
% for i=1:number_of_receivers
% c{i} = fitcsvm(X{i},Y{i},'KernelFunction','rbf',...
%     'BoxConstraint',Inf,'ClassNames',[-1,1]);
% 
% end


% c = fitcsvm(X,Y,'KernelFunction','rbf',...
%     'BoxConstraint',Inf,'ClassNames',[-1,1]);
% 
% 


% for i=1:number_of_receivers
%    features_samples{i} =  extract_features(groups_period{i});
%    [label,score] = predict(c{i},features_samples{i});
%    vec_intresting = time_grouped{i}.*label';
%    
%    positiveIdx = vec_intresting(vec_intresting > 0);
%     negIdx = abs(vec_intresting(vec_intresting<0));
%     vec_distance = distance_set{i};
%   
%     positiveY = vec_distance(positiveIdx);
%     negY = vec_distance(negIdx);
%     
%         figure(i);
%             
%     x = 1:size(samples_s,2);
%     max_thrshold_vec = thresholds_max(i) * ones(1, size(samples_s,2));
%     mean_thrshold_vec = thresholds_mean(i) * ones(1, size(samples_s,2));
%     plot(x, distance_set{i}, x, max_thrshold_vec,'--g', x, mean_thrshold_vec,':r', positiveIdx, positiveY, '*r', negIdx, negY, '*k');
%     title(sprintf('Receiver %d',i))
%     
%     axis([0 size(samples_s,2) 0.0 1])
%     legend('Samples', 'Max threshold','Mean threshold')
%     saveas(figure(i),sprintf('%s/Receiever %d svm.png',path_cur,i));
%     
%  
%     
% end

% 
% for i=1:number_of_receivers
%    features_samples =  multiple_extract_features(groups_period);
%    [label,score] = predict(c,features_samples);
%    vec_intresting = time_grouped.*label';
%    
%    positiveIdx = vec_intresting(vec_intresting > 0);
%     negIdx = abs(vec_intresting(vec_intresting<0));
%     vec_distance = distance_set{i};
%   
%     positiveY = vec_distance(positiveIdx);
%     negY = vec_distance(negIdx);
%     
%         figure(i);
%             
%     x = 1:size(samples_s,2);
%     max_thrshold_vec = thresholds_max(i) * ones(1, size(samples_s,2));
%     mean_thrshold_vec = thresholds_mean(i) * ones(1, size(samples_s,2));
%     plot(x, distance_set{i}, x, max_thrshold_vec,'--g', x, mean_thrshold_vec,':r', positiveIdx, positiveY, '*r', negIdx, negY, '*k');
%     title(sprintf('Receiver %d',i))
%     
%     axis([0 size(samples_s,2) 0.0 1])
%     legend('Samples', 'Max threshold','Mean threshold')
%     saveas(figure(i),sprintf('%s/Receiever %d svm.png',path_cur,i));
%     
%  
%     
% end


end

