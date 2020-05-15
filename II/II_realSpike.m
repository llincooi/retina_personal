clear all;
close all;
%load('D:\Leo\0229\merge\merge_0224_HMM_UR_DL_G2.5_5min_Q100_6.5mW.mat')
load('merge_0224_HMM_UL_DR_G4.5_5min_Q100_6.5mW.mat')
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
sqrtStimuSN = 6;

% [n,~] = hist(reconstruct_spikes{27},diode_BT) ;  %yk_spikes is the spike train made from"Merge_rePos_spikes"
% isir= n ;

nX=sort(x);
abin=length(nX)/sqrtStimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
temp=0; isix=[];
for jj=1:length(x)
    isix(jj) = find(x(jj)<=intervals,1);
end
nX=sort(v);
abin=length(nX)/sqrtStimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
isiv=[];
for jj=1:length(v)
    isiv(jj) = find(v(jj)<=intervals,1);
end
isii = sqrtStimuSN*(isiv-1) + isix;

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


bin = BinningInterval*1000;
backward=ceil(5000/bin);
forward=ceil(5000/bin);
time=[-backward*bin:bin:forward*bin];
[information_x_r information_v_r redundant_I] = PIfunc(isir,isix, isiv,BinningInterval,backward,forward);
information_i_r = MIfunc(isir,isii,BinningInterval,backward,forward);
%information_x_v = MIfunc(isix, isiv,BinningInterval,backward,forward);
% shuffle_isir = isir(randperm(length(isir)));
% shuffle_information_x_r = MIfunc(shuffle_isir,isix,BinningInterval,backward,forward);
% shuffle_information_v_r = MIfunc(shuffle_isir,isiv,BinningInterval,backward,forward);
% shuffle_information_i_r = MIfunc(shuffle_isir,isii,BinningInterval,backward,forward);
% information_x_r = information_x_r - min(shuffle_information_x_r);
% information_v_r = information_v_r - min(shuffle_information_v_r);
% information_i_r = information_i_r - min(shuffle_information_i_r);
figure(4);
plot(time,information_x_r, 'r');hold on;
plot(time,information_v_r, 'b')
plot(time,information_i_r, 'k')
plot(time,information_x_r+ information_v_r, 'm')
legend('MI(x, ??›¾)','MI(v, ??›¾)', 'MI([x,v], ??›¾)', 'MI(x, ??›¾)+MI(v, ??›¾)');
z = information_x_r + information_v_r -information_i_r;
%z_minus_base = z- min(shuffle_information_x_r) - min(shuffle_information_v_r) + min(shuffle_information_i_r);
synergy_I = redundant_I-z;
PI_x = information_x_r - redundant_I;
%a = information_x_v - z ;
PI_v = information_v_r - redundant_I;
figure(6);
plot(time,PI_x, 'r');hold on;
plot(time,PI_v, 'b')
plot(time,synergy_I, 'k')
plot(time,redundant_I, 'g')
legend('PI x','PI v', 'synergy I', 'redundant I');

% 
% figure(7)
% plot(z./)