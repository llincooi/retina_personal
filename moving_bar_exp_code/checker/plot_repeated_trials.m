figure;
%ha = tight_subplot(4,1,[0 0],[0.05 0.05],[.02 .01]);    
for j = 1:4
    load(['D:\Leo\0417exp\sort_merge_spike\sort_merge_0319_HMM_UL_DR_G4.5_7min_Br50_Q100_',num2str(j),'.mat'])
    Spikes = sorted_spikes;
    %Spikes = reconstruct_spikes;
    for i=1:60
        Spikes{i} = Spikes{i}';
        if isempty(Spikes{i})==1
            Spikes{i}=0;
        end
    end
    Spikes{31} = 0;
    %axes(ha(j));
    subplot(5,1,j);
    LineFormat.Color = [0.3 0.3 0.3];
    plotSpikeRaster(Spikes,'PlotType','vertline','LineFormat',LineFormat);
    hold on;
    
end
subplot(5,1,5);
plot(1/60:1/60:length(bin_pos)/60, bin_pos);

samexaxis('abc','xmt','on','ytac','join','yld',1) % function need ''parseArgs'' function, from matlab center