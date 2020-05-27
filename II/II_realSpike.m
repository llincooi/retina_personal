clear all;
close all;
%load('D:\Leo\0229\merge\merge_0224_HMM_UR_DL_G2.5_5min_Q100_6.5mW.mat')
load('merge_0224_HMM_UL_DR_G4.5_5min_Q100_6.5mW.mat')
%load('merge_0224_OUsmooth_RL_G4.5_5min_Q100_6.5mW_1Hz.mat')
fps =60;
x = bin_pos(1:end);
v = finite_diff(x ,4);

BinningSpike = zeros(60,length(diode_BT));
analyze_spikes = cell(1,60);
analyze_spikes = reconstruct_spikes;
for i = 1:60  % i is the channel number
    [n,~] = hist(analyze_spikes{i},diode_BT) ;  %yk_spikes is the spike train made from"Merge_rePos_spikes"
    BinningSpike(i,:) = n ;
end
isir = BinningSpike(18,:);

StimuSN = 6;

% [n,~] = hist(reconstruct_spikes{27},diode_BT) ;  %yk_spikes is the spike train made from"Merge_rePos_spikes"
% isir= n ;

nX=sort(x);
abin=length(nX)/StimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
temp=0; isix=[];
for jj=1:length(x)
    isix(jj) = find(x(jj)<=intervals,1);
end
nX=sort(v);
abin=length(nX)/StimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
isiv=[];
for jj=1:length(v)
    isiv(jj) = find(v(jj)<=intervals,1);
end
isii = StimuSN*(isiv-1) + isix;



bin = BinningInterval*1000;
backward=ceil(5000/bin);
forward=ceil(5000/bin);
time=[-backward*bin:bin:forward*bin];

[MIxr, MIvr, MIxvR, Redun] = NewPIfunc(isir,isix, isiv,BinningInterval,backward,forward);
figure(4);
plot(time,MIxr, 'r');hold on;
plot(time,MIvr, 'b')
plot(time,MIxvR, 'k')
plot(time,MIxr+MIvr, 'm')
legend('MI(x, r)','MI(v, r)', 'MI([x,v], r)', 'MI(x, r)+MI(v, r)');

Syner = MIxvR-MIxr-MIvr+Redun;
U_x = MIxr - Redun;
U_v = MIvr - Redun;
figure(6);
plot(time,U_x, 'r');hold on;
plot(time,U_v, 'b')
plot(time,Syner, 'k')
plot(time,Redun, 'g')
legend('PI x','PI v', 'synergy I', 'redundant I');
