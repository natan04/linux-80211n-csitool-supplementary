function [ output_args ] = time_csi( csi_input )
%PCA_CSI Summary of this function goes here
%   Detailed explanation goes here

len = size(csi_input);
data = [];
for csi_sample = 1:len
    csi_val = get_scaled_csi(csi_input{csi_sample});
    
    csi_matrix = squeeze(csi_val);
  %vec = (abs(real(squeeze(csi_val(1,:,:)))))/norm(squeeze(csi_val(1,:,:)));
   vec = (abs(real(csi_matrix)))/norm(csi_matrix(:));
 %  vec = ((abs(squeeze(csi_val(1,:,:)).')));
    
    antA = vec(1,:);
    normA = antA - mean(antA(:));
    nromA = normA/std(normA(:));
    antB = vec(:,2);
    antC = vec(:,3);

    data = [data ; antA];
end

fc = 5/250;
fs = 10;

[b,a] = butter(6,fc/(fs/2));

dataOut =[];
for index=1:30
    dataOut= [dataOut ; filter(b,a,data(index,:))];
        
end
data_norm = normc(dataOut);

[COEFF,SCORE] = princomp(data_norm');
pcaSamples = COEFF*data_norm;
transPca = pcaSamples;


ver_pca = zeros(30,2);
for pcacomp_run=1:30
    ver_pca(pcacomp_run, 1) = mad(transPca(pcacomp_run,1:10000)); 
    ver_pca(pcacomp_run, 2) = mad(transPca(pcacomp_run,25000:35000));
end

ver_sc = zeros(30,2);
for sccomp_run=1:30
    ver_sc(sccomp_run, 1) = mad(data(sccomp_run,1:10000)); 
    ver_sc(sccomp_run, 2) = mad(data(sccomp_run,25000:35000));
end

plot(transPca(10:20,:).')
 

figure(1)

    figure(2)
plot(data(1,:))
end

