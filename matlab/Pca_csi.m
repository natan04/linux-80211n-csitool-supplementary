function [ output_args ] = Pca_csi( csi_input )
%PCA_CSI Summary of this function goes here
%   Detailed explanation goes here

len = size(csi_input,2);
data = [];
for csi_sample = 1:len
    csi_val = get_scaled_csi(csi_input{csi_sample});
    vec = (db(abs(squeeze(csi_val(1,:,:)).')));

    antA = vec(:,1);
    antB = vec(:,2);
    antC = vec(:,3);

    data = [data antA];
end

[COEFF,SCORE] = princomp(data');

pcaSamples = COEFF*data;

transPca = pcaSamples';

    plot(transPca(:,30:30))
         axis([0,100,-40,80])

end

