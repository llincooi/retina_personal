clear all
load('C:\Users\llinc\OneDrive\Documents\GitHub\retina_personal\0406\Analyzed_data\30Hz_27_RF_15min\unsort\RF_properties.mat')
load('C:\Users\llinc\OneDrive\Documents\GitHub\retina_personal\0406\merge\merge_0224_HMM_RL_G20_5min_Q100_6.5mW.mat')
newXpos = Monitor2DCoor2BarCoor(RF_properties(:,2),RF_properties(:,4),'RL',"OLED");
analyze_spikes = reconstruct_spikes;
for i = 1:60  % i is the channel number
    [n,~] = hist(analyze_spikes{i},diode_BT) ;  %yk_spikes is the spike train made from"Merge_rePos_spikes"
    BinningSpike(i,:) = n ;
end
Weighted_pos = newXpos.*BinningSpike;
BinningSpike(find(~newXpos), :) =0;
PVA = sum(Weighted_pos,1)./sum(BinningSpike,1);
sPVA = smooth(PVA);
ssPVA = smooth(sPVA);
%plot(PVA);
% hold on;
% plot(ssPVA)
% plot(bin_pos);
% xc = xcorr(sPVA,bin_pos);
% plot(xc)
% [m i] = max(xc);

StimuSN=6; %number of stimulus states
TheStimuli=bin_pos;
nX=sort(TheStimuli);
abin=length(nX)/StimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
temp=0; isi2=[];
for jj=1:length(TheStimuli)
    isi2(jj) = find(TheStimuli(jj)<=intervals,1);
end

nX=sort(sPVA');
abin=length(nX)/StimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
temp=0; Neurons=[];
for jj=1:length(sPVA)
    Neurons(jj) = find(sPVA(jj)<=intervals,1);
end

bin=BinningInterval*10^3; %ms
backward=ceil(15000/bin);
forward=ceil(15000/bin);
time=[-backward*bin:bin:forward*bin];
information = MIfunc(Neurons,isi2,BinningInterval,backward,forward);
plot(time,information)