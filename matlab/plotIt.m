
function ret = plotIt(csi_entry)
%    csi = get_scaled_csi(csi_entry);

csi = get_scaled_csi(csi_entry);

csi_to_plot = squeeze(csi);
csi_to_plot = abs(real(csi_to_plot)./abs(csi_to_plot))

%plot(db(abs(squeeze(csi).')))
 
plot(csi_to_plot(1,:).')
 mean(csi_to_plot(1,:))
 legend('RX Antenna A', 'RX Antenna B', 'RX Antenna C', 'Location', 'SouthEast' );
    xlabel('Subcarrier index');
        ylabel('SNR [dB]');
% figure(2)
%    plot(db(abs(squeeze(csi(2,:,:)).')))
% plot((normlized_second.'))
 
legend('RX Antenna A', 'RX Antenna B', 'RX Antenna C', 'Location', 'SouthEast' );


 
 drawnow;

        
end