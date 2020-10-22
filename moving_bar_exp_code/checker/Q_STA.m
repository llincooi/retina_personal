clear all
close all
% load('D:\GoogleDrive\retina\Exps\2020\0503\merge\merge_0224_OUsmooth_RL_G4.5_5min_Q100_6.5mW_1Hz_re.mat')
for Fc = [0.5 1 2 4 8 0]
load(['D:\GoogleDrive\retina\Exps\2020\0729\merge\merge_0727_OUsmooth_Bright_UL_DR_G4.5_5min_Q100_6.5mW_',num2str(Fc),'Hz.mat'])
load(['D:\GoogleDrive\retina\Exps\2020\0729\MI\unsort\0727_OUsmooth_Bright_UL_DR_G4.5_5min_Q100_6.5mW_',num2str(Fc),'Hz.mat'])
MI_time = time;
% put your stimulus here!!
TheStimuli=bin_pos;  %recalculated bar position
forward = -1;
backward = 1;
forward = round(forward/BinningInterval);
backward = round(backward/BinningInterval);
time=[forward:backward]*BinningInterval;
% Binning
bin=BinningInterval*10^3; %ms
BinningTime =diode_BT;

%% BinningSpike and calculate STA
BinningSpike = zeros(60,length(BinningTime));
analyze_spikes = cell(1,60);
analyze_spikes = reconstruct_spikes;

sum_n = zeros(1,60);
dis_STA = zeros(60,backward-forward+1);
channelnumber = 52;
for i = channelnumber%:60  % i is the channel number
    [n,~] = hist(analyze_spikes{i},BinningTime) ;
    BinningSpike(i,:) = n ;
    sum_n(i) = sum(BinningSpike(i,1-forward:end-backward));
    for time_shift = 1-forward:length(BinningTime)-backward
        dis_STA(i,:) = dis_STA(i,:) + BinningSpike(i,time_shift)*TheStimuli(time_shift+forward:time_shift+backward);
    end
    if sum_n(i)
        dis_STA(i,:) = dis_STA(i,:)/sum_n(i);
    end
    
    Syn = smooth(joint_Mutual_infos{i}-pos_Mutual_infos{i}-v_Mutual_infos{i}+Redun_Mutual_infos{i},10);
    Syn = smooth(joint_Mutual_infos{i},5);
    Syn_peaktime = MI_time(find(Syn==max(Syn)))*10^-3;
end
figure()
plot(MI_time,Syn)
figure()
dSTA = diff(dis_STA,1,2)/BinningInterval;
plot3(dis_STA(channelnumber,2:end),dSTA(channelnumber,:),time(2:end));grid on; hold on;
scatter3(dis_STA(channelnumber,[31 61 91]), dSTA(channelnumber,[30 60 90]) ,time([31 61 91]));
Syn_peakpos = interp1(time,dis_STA(channelnumber,:),Syn_peaktime);
Syn_peakv = interp1(time(2:end),dSTA(channelnumber,:),Syn_peaktime);
scatter3(Syn_peakpos, Syn_peakv, Syn_peaktime)

xcenter = (max(dis_STA(channelnumber,:))+min(dis_STA(channelnumber,:)))/2;
vcenter = 0;
scatter3(xcenter, vcenter, 0)
xaxislength = (max(dis_STA(channelnumber,:))-min(dis_STA(channelnumber,:)))/2;
vaxislength = (max(smooth(dSTA(channelnumber,:),3))-vcenter);
1/(Syn_peakpos-xcenter)*xaxislength*(Syn_peakv-vcenter)/vaxislength
end