function [ output_args ] = dist( csis )
%DIST Summary of this function goes here
%   Detailed explanation goes here

allsubantenna = zeros(length(csis), 30);
for i=1:length(csis)
    csi_entry = csis{i};
    %    csi = get_scaled_csi(csi_entry);
    csi = csi_entry(1).csi;
    our_csi_first  = squeeze(csi(1,:,:));
    our_csi_second = squeeze(csi(2,:,:));
        
    normlized_first = (abs(real(our_csi_first)));%./abs(our_csi_first);
    trans = transpose(normlized_first(1,:));
    for j=1:30
     allsubantenna(i,j) = trans(j);
    end
    
end
  %  allsubantenna = transpose(allsubantenna);

for i=1:length(csis)
    csi_entry = csis{i};
    %    csi = get_scaled_csi(csi_entry);
    csi = csi_entry(1).csi;
    our_csi_first  = squeeze(csi(1,:,:));
    our_csi_second = squeeze(csi(2,:,:));
    
    normlized_first = (abs(real(our_csi_first)));%./abs(our_csi_first);
    avg(i) = mean(normlized_first(1,15:30));
    figure(2)
    plot(avg)
    axis([0,i,0,80])

    figure(1)
    normlized_second = (abs(real(our_csi_second)));%./abs(our_csi_second);
    norm(normlized_first(1,:))
    plot((normlized_first.'))
    legend('RX Antenna A', 'RX Antenna B', 'RX Antenna C', 'Location', 'SouthEast' );
    xlabel('Subcarrier index');
        ylabel('SNR [dB]');
          axis([0,30,0,80])
    pause(0.01);
end

end

